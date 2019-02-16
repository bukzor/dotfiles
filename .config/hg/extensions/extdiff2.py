# extdiff2.py - external diff program support for mercurial
#
# Copyright 2006 Vadim Gelfer <vadim.gelfer@gmail.com>
#
# This software may be used and distributed according to the terms of the
# GNU General Public License version 2 or any later version.
"""command to allow external programs to compare revisions

The extdiff2 Mercurial extension allows you to use external programs
to compare revisions, or revision with working directory. The external
diff programs are called with a configurable set of options and two
non-option arguments: paths to directories containing snapshots of
files to compare.

If there is more than one file being compared and the "child" revision
is the working directory, any modifications made in the external diff
program will be copied back to the working directory from the temporary
directory.

The extdiff2 extension also allows you to configure new diff commands, so
you do not need to type :hg:`extdiff2 -p kdiff3` always. ::

  [extdiff2]
  # add new command that runs GNU diff(1) in 'context diff' mode
  cdiff = gdiff -Nprc5
  ## or the old way:
  #cmd.cdiff = gdiff
  #opts.cdiff = -Nprc5

  # add new command called meld, runs meld (no need to name twice).  If
  # the meld executable is not available, the meld tool in [merge-tools]
  # will be used, if available
  meld =

  # add new command called vimdiff, runs gvimdiff with DirDiff plugin
  # (see http://www.vim.org/scripts/script.php?script_id=102) Non
  # English user, be sure to put "let g:DirDiffDynamicDiffText = 1" in
  # your .vimrc
  vimdiff = gvim -f "+next" \\
            "+execute 'DirDiff' fnameescape(argv(0)) fnameescape(argv(1))"

Tool arguments can include variables that are expanded at runtime::

  $parent1, $plabel1 - filename, descriptive label of first parent
  $child,   $clabel  - filename, descriptive label of child revision
  $parent2, $plabel2 - filename, descriptive label of second parent
  $root              - repository root
  $parent is an alias for $parent1.

The extdiff2 extension will look in your [diff-tools] and [merge-tools]
sections for diff tool arguments, when none are specified in [extdiff2].

::

  [extdiff2]
  kdiff3 =

  [diff-tools]
  kdiff3.diffargs=--L1 '$plabel1' --L2 '$clabel' $parent $child

You can use -I/-X and list of file or directory names like normal
:hg:`diff` command. The extdiff2 extension makes snapshots of only
needed files, so running the external diff program will actually be
pretty fast (at least faster than having to compare the entire tree).
"""

from __future__ import absolute_import

import os
import re
import shutil
import stat

from mercurial.i18n import _
from mercurial.node import (
    nullid,
    short,
)
from mercurial import (
    archival,
    cmdutil,
    error,
    filemerge,
    formatter,
    pycompat,
    registrar,
    scmutil,
    util,
)
from mercurial.utils import (
    procutil,
    stringutil,
)

cmdtable = {}
command = registrar.command(cmdtable)

configtable = {}
configitem = registrar.configitem(configtable)

configitem(
    'extdiff2',
    br'opts\..*',
    default='',
    generic=True,
)

configitem(
    'diff-tools',
    br'.*\.diffargs$',
    default=None,
    generic=True,
)

# Note for extension authors: ONLY specify testedwith = 'ships-with-hg-core' for
# extensions which SHIP WITH MERCURIAL. Non-mainline extensions should
# be specifying the version(s) of Mercurial they are tested with, or
# leave the attribute unspecified.
testedwith = 'ships-with-hg-core'


def snapshot(ui, repo, files, node, tmproot, listsubrepos):
  """snapshot files as of some revision

    if not using snapshot, -I/-X does not work and recursive diff
    in tools like kdiff3 and meld displays too many files.
  """
  dirname = os.path.basename(repo.root)
  if dirname == '':
    dirname = 'root'
  if node is not None:
    dirname = '%s.%s' % (dirname, short(node))
  base = os.path.join(tmproot, dirname)
  os.mkdir(base)
  fnsandstat = []

  if node is not None:
    ui.note(_('making snapshot of %d files from rev %s\n') %
            (len(files), short(node)))
  else:
    ui.note(_('making snapshot of %d files from working directory\n') %
            (len(files)))

  if files:
    repo.ui.setconfig('ui', 'archivemeta', False)

    archival.archive(
        repo,
        base,
        node,
        'files',
        match=scmutil.matchfiles(repo, files),
        subrepos=listsubrepos)

    for fn in sorted(files):
      wfn = util.pconvert(fn)
      ui.note('  %s\n' % wfn)

      if node is None:
        dest = os.path.join(base, wfn)

        fnsandstat.append((dest, repo.wjoin(fn), os.lstat(dest)))
  return dirname, fnsandstat


def dodiff(ui, repo, cmdline, pats, opts):
  """Do the actual diff:

    - copy to a temp structure if diffing 2 internal revisions
    - copy to a temp structure if diffing working revision with
      another one and more than 1 file is changed
    - just invoke the diff for a single file in the working dir
    """

  revs = opts.get('rev')
  change = opts.get('change')
  do3way = '$parent2' in cmdline

  if revs and change:
    msg = _('cannot specify --rev and --change at the same time')
    raise error.Abort(msg)
  elif change:
    ctx2 = scmutil.revsingle(repo, change, None)
    ctx1a, ctx1b = ctx2.p1(), ctx2.p2()
  else:
    ctx1a, ctx2 = scmutil.revpair(repo, revs)
    if not revs:
      ctx1b = repo[None].p2()
    else:
      ctx1b = repo[nullid]

  node1a = ctx1a.node()
  node1b = ctx1b.node()
  node2 = ctx2.node()

  # Disable 3-way merge if there is only one parent
  if do3way:
    if node1b == nullid:
      do3way = False

  subrepos = opts.get('subrepos')

  matcher = scmutil.match(repo[node2], pats, opts)

  mod_a, add_a, rem_a = map(
      set,
      repo.status(node1a, node2, matcher, listsubrepos=subrepos)[:3])
  if do3way:
    mod_b, add_b, rem_b = map(
        set,
        repo.status(node1b, node2, matcher, listsubrepos=subrepos)[:3])
  else:
    mod_b, add_b, rem_b = set(), set(), set()
  modadd = mod_a | add_a | mod_b | add_b
  common = modadd | rem_a | rem_b
  if not common:
    return 0

  tmproot = pycompat.mkdtemp(prefix='extdiff2.')
  try:
    # Always make a copy of node1a (and node1b, if applicable)
    dir1a_files = mod_a | rem_a | ((mod_b | add_b) - add_a)
    dir1a = snapshot(ui, repo, dir1a_files, node1a, tmproot, subrepos)[0]
    dir1a = os.path.join(tmproot, dir1a)
    rev1a = '@%d' % repo[node1a].rev()
    if do3way:
      dir1b_files = mod_b | rem_b | ((mod_a | add_a) - add_b)
      dir1b = snapshot(ui, repo, dir1b_files, node1b, tmproot, subrepos)[0]
      dir1b = os.path.join(tmproot, dir1b)
      rev1b = '@%d' % repo[node1b].rev()
    else:
      dir1b = None
      rev1b = ''

    fnsandstat = []

    # If node2 in not the wc or there is >1 change, copy it
    rev2 = ''
    if node2:
      dir2 = snapshot(ui, repo, modadd, node2, tmproot, subrepos)[0]
      rev2 = '@%d' % repo[node2].rev()
    elif False:  # len(common) > 1:
      #we only actually need to get the files to copy back to
      #the working dir in this case (because the other cases
      #are: diffing 2 revisions or single file -- in which case
      #the file is already directly passed to the diff tool).
      dir2, fnsandstat = snapshot(ui, repo, modadd, None, tmproot, subrepos)
    else:
      # This lets the diff tool open the changed file(s) directly
      dir2 = ''

    label1a = rev1a
    label1b = rev1b
    label2 = rev2

    # Diff the files instead of the directories
    # Handle bogus modifies correctly by checking if the files exist
    for common_file in common:
      common_file = util.localpath(common_file)
      file1a = os.path.join(dir1a, common_file)
      label1a = common_file + rev1a
      #if not os.path.isfile(file1a):
      #file1a = os.devnull
      if do3way:
        file1b = os.path.join(dir1b, common_file)
        label1b = common_file + rev1b
        #if not os.path.isfile(file1b):
        #file1b = os.devnull
      else:
        file1b = None

      file2 = os.path.join(repo.root, common_file)
      if not dir2:
        file2 = os.path.relpath(file2)
      label2 = common_file + rev2

      # Function to quote file/dir names in the argument string.
      # When not operating in 3-way mode, an empty string is
      # returned for parent2
      replace = {
          'parent': file1a,
          'parent1': file1a,
          'parent2': file1b,
          'plabel1': label1a,
          'plabel2': label1b,
          'clabel': label2,
          'child': file2,
          'root': repo.root
      }

      def quote(match):
        pre = match.group(2)
        key = match.group(3)
        if not do3way and key == 'parent2':
          return pre
        return pre + procutil.shellquote(replace[key])

      # Match parent2 first, so 'parent1?' will match both parent1 and parent
      regex = (br"""(['"]?)([^\s'"$]*)"""
               br'\$(parent2|parent1?|child|plabel1|plabel2|clabel|root)\1')
      if not do3way and not re.search(regex, cmdline):
        cmdline2 = cmdline + ' $parent1 $child'
      else:
        cmdline2 = cmdline
      cmdline3 = re.sub(regex, quote, cmdline2)

      ui.write(pycompat.bytestr(cmdline3) + b'\n')
      ui.system(cmdline3, blockedtag='extdiff2')

      for copy_fn, working_fn, st in fnsandstat:
        cpstat = os.lstat(copy_fn)
        # Some tools copy the file and attributes, so mtime may not detect
        # all changes.  A size check will detect more cases, but not all.
        # The only certain way to detect every case is to diff all files,
        # which could be expensive.
        # copyfile() carries over the permission, so the mode check could
        # be in an 'elif' branch, but for the case where the file has
        # changed without affecting mtime or size.
        if (cpstat[stat.ST_MTIME] != st[stat.ST_MTIME] or
            cpstat.st_size != st.st_size or (cpstat.st_mode & 0o100) !=
            (st.st_mode & 0o100)):
          ui.debug('file changed while diffing. '
                   'Overwriting: %s (src: %s)\n' % (working_fn, copy_fn))
          util.copyfile(copy_fn, working_fn)

    return 1
  finally:
    ui.note(_('cleaning up temp directory\n'))
    shutil.rmtree(tmproot)


extdiffopts = [
    ('o', 'option', [],
     _('pass option to comparison program'), _('OPT')),
    ('r', 'rev', [], _('revision'), _('REV')),
    ('c', 'change', '', _('change made by revision'), _('REV')),
] + cmdutil.walkopts + cmdutil.subrepoopts


@command('extdiff2',
         [('p', 'program', '', _('comparison program to run'), _('CMD')),
         ] + extdiffopts,
         _('hg extdiff2 [OPT]... [FILE]...'),
         helpcategory=command.CATEGORY_FILE_CONTENTS,
         inferrepo=True)
def extdiff2(ui, repo, *pats, **opts):
  """use external program to diff repository (or selected files)

    Show differences between revisions for the specified files, using
    an external program. The default program used is diff, with
    default options "-Npru".

    To select a different program, use the -p/--program option. The
    program will be passed the names of two directories to compare. To
    pass additional options to the program, use -o/--option. These
    will be passed before the names of the directories to compare.

    When two revision arguments are given, then changes are shown
    between those revisions. If only one revision is specified then
    that revision is compared to the working directory, and, when no
    revisions are specified, the working directory files are compared
    to its parent.
  """
  opts = pycompat.byteskwargs(opts)
  program = opts.get('program')
  option = opts.get('option')
  if not program:
    program = 'diff'
    option = option or ['-Npru']
  cmdline = ' '.join(map(procutil.shellquote, [program] + option))
  return dodiff(ui, repo, cmdline, pats, opts)


class savedcmd(object):
  """use external program to diff repository (or selected files)

    Show differences between revisions for the specified files, using
    the following program::

        %(path)s

    When two revision arguments are given, then changes are shown
    between those revisions. If only one revision is specified then
    that revision is compared to the working directory, and, when no
    revisions are specified, the working directory files are compared
    to its parent.
    """

  def __init__(self, path, cmdline):
    # We can't pass non-ASCII through docstrings (and path is
    # in an unknown encoding anyway), but avoid double separators on
    # Windows
    docpath = stringutil.escapestr(path).replace(b'\\\\', b'\\')
    self.__doc__ %= {r'path': pycompat.sysstr(stringutil.uirepr(docpath))}
    self._cmdline = cmdline

  def __call__(self, ui, repo, *pats, **opts):
    opts = pycompat.byteskwargs(opts)
    options = ' '.join(map(procutil.shellquote, opts['option']))
    if options:
      options = ' ' + options
    return dodiff(ui, repo, self._cmdline + options, pats, opts)


def uisetup(ui):
  for cmd, path in ui.configitems('extdiff2'):
    path = util.expandpath(path)
    if cmd.startswith('cmd.'):
      cmd = cmd[4:]
      if not path:
        path = procutil.findexe(cmd)
        if path is None:
          path = filemerge.findexternaltool(ui, cmd) or cmd
      diffopts = ui.config('extdiff2', 'opts.' + cmd)
      cmdline = procutil.shellquote(path)
      if diffopts:
        cmdline += ' ' + diffopts
    elif cmd.startswith('opts.'):
      continue
    else:
      if path:
        # case "cmd = path opts"
        cmdline = path
        diffopts = len(pycompat.shlexsplit(cmdline)) > 1
      else:
        # case "cmd ="
        path = procutil.findexe(cmd)
        if path is None:
          path = filemerge.findexternaltool(ui, cmd) or cmd
        cmdline = procutil.shellquote(path)
        diffopts = False
    # look for diff arguments in [diff-tools] then [merge-tools]
    if not diffopts:
      args = ui.config('diff-tools', cmd+'.diffargs') or \
             ui.config('merge-tools', cmd+'.diffargs')
      if args:
        cmdline += ' ' + args
    command(cmd, extdiffopts[:], _('hg %s [OPTION]... [FILE]...') % cmd,
            helpcategory=command.CATEGORY_FILE_CONTENTS,
            inferrepo=True)(savedcmd(path, cmdline))


# tell hggettext to extract docstrings from these functions:
i18nfunctions = [savedcmd]
