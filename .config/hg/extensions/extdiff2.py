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

If there is more than one file being compared and the "new" revision
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

  $old, $olabel - filename, descriptive label of old revision
  $new, $nlabel - filename, descriptive label of new revision
  $root         - repository root

The extdiff2 extension will look in your [diff-tools] and [merge-tools]
sections for diff tool arguments, when none are specified in [extdiff2].

::

  [extdiff2]
  kdiff3 =

  [diff-tools]
  kdiff3.diffargs=--L1 '$olabel' --L2 '$nlabel' $old $new

You can use -I/-X and list of file or directory names like normal
:hg:`diff` command. The extdiff2 extension makes snapshots of only
needed files, so running the external diff program will actually be
pretty fast (at least faster than having to compare the entire tree).
"""

from __future__ import absolute_import

import os
import re
import shutil

from mercurial.i18n import _
from mercurial.node import short
from mercurial import (
    archival,
    cmdutil,
    copies,
    filemerge,
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
    b"extdiff2",
    br"opts\..*",
    default=b"",
    generic=True,
)

configitem(
    b"diff-tools",
    br".*\.diffargs$",
    default=None,
    generic=True,
)


def snapshot(ui, repo, files, node, tmproot, listsubrepos):
  """snapshot files as of some revision

  if not using snapshot, -I/-X does not work and recursive diff
  in tools like kdiff3 and meld displays too many files.
  """
  dirname = os.path.basename(repo.root)
  if dirname == b"":
    dirname = b"root"
  if node is not None:
    dirname = b"%s.%s" % (dirname, short(node))
  base = os.path.join(tmproot, dirname)
  os.mkdir(base)

  if node is not None:
    ui.note(
        _(b"making snapshot of %d files from rev %s\n")
        % (len(files), short(node))
    )
  else:
    ui.note(
        _(b"making snapshot of %d files from working directory\n")
        % (len(files))
    )

  if files:
    repo.ui.setconfig(b"ui", b"archivemeta", False)

    archival.archive(
        repo,
        base,
        node,
        b"files",
        match=scmutil.matchfiles(repo, files),
        subrepos=listsubrepos,
    )

  return dirname


def dodiff(ui, repo, cmdline, pats, opts):
  """Do the actual diff."""

  revs = opts.get(b"rev")
  old, new = scmutil.revpair(repo, revs)

  subrepos = opts.get(b"subrepos")

  matcher = scmutil.match(new, pats, opts)

  status = old.status(new, matcher, listsubrepos=subrepos)
  copy = copies.pathcopies(old, new, matcher)

  mod = set(status.modified)
  add = set(status.added)
  rem = set(status.removed)
  paths_new = mod | add
  paths_old = mod | set(copy.values())
  paths_all = paths_old | paths_new
  if not paths_all:
    return 0

  tmproot = pycompat.mkdtemp(prefix=b"extdiff2.")
  try:
    # Always make a copy of old
    dir_old = snapshot(ui, repo, paths_old, old.node(), tmproot, subrepos)
    dir_old = os.path.join(tmproot, dir_old)
    label_old = b"@%d" % old.rev()

    # If new in not the wc, copy it
    if new.node():
      dir_new = snapshot(ui, repo, paths_new, new.node(), tmproot, subrepos)
      label_new = b"@%d" % new.rev()
    else:
      # This lets the diff tool open the changed file(s) directly
      dir_new = b""
      label_new = b""

    # Diff the files instead of the directories
    # Handle bogus modifies correctly by checking if the files exist
    for path in sorted(paths_new):
      path = util.localpath(path)
      path_old = os.path.join(dir_old, copy.get(path, path))
      label_old = path + label_old

      if not os.path.isfile(path_old):
        path_old = os.devnull.encode("US-ASCII")

      path_new = os.path.join(repo.root, path)
      if not dir_new:
        path_new = os.path.relpath(path_new)
      label_new = path + label_new

      # Function to quote file/dir names in the argument string.
      replace = {
          b"old": path_old,
          b"olabel": label_old,
          b"nlabel": label_new,
          b"new": path_new,
          b"root": repo.root,
      }

      def quote(match):
        pre = match.group(2)
        key = match.group(3)
        return pre + procutil.shellquote(replace[key])

      regex = br"""(['"]?)([^\s'"$]*)""" br"\$(old|new|olabel|nlabel|root)\1"
      if not re.search(regex, cmdline):
        cmdline2 = cmdline + b" $old $new"
      else:
        cmdline2 = cmdline
      cmdline3 = re.sub(regex, quote, cmdline2)

      ui.write(pycompat.bytestr(cmdline3) + b"\n")
      ui.system(cmdline3, blockedtag=b"extdiff2")

    return 1
  finally:
    ui.note(_(b"cleaning up temp directory\n"))
    shutil.rmtree(tmproot)


extdiffopts = (
    [
        (
            b"o",
            b"option",
            [],
            _(b"pass option to comparison program"),
            _(b"OPT"),
        ),
        (b"r", b"rev", [], _(b"revision"), _(b"REV")),
    ]
    + cmdutil.walkopts
    + cmdutil.subrepoopts
)


@command(
    b"extdiff2",
    [
        (b"p", b"program", b"", _(b"comparison program to run"), _(b"CMD")),
    ]
    + extdiffopts,
    _(b"hg extdiff2 [OPT]... [FILE]..."),
    helpcategory=command.CATEGORY_FILE_CONTENTS,
    inferrepo=True,
)
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
  program = opts.get(b"program")
  option = opts.get(b"option")
  if not program:
    program = b"diff"
    option = option or [b"-Npru"]
  cmdline = b" ".join(map(procutil.shellquote, [program] + option))
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
    docpath = stringutil.escapestr(path).replace(b"\\\\", b"\\")
    self.__doc__ %= {r"path": pycompat.sysstr(stringutil.uirepr(docpath))}
    self._cmdline = cmdline

  def __call__(self, ui, repo, *pats, **opts):
    opts = pycompat.byteskwargs(opts)
    options = b" ".join(map(procutil.shellquote, opts[b"option"]))
    if options:
      options = b" " + options
    return dodiff(ui, repo, self._cmdline + options, pats, opts)


def uisetup(ui):
  for cmd, path in ui.configitems(b"extdiff2"):
    path = util.expandpath(path)
    if cmd.startswith(b"cmd."):
      cmd = cmd[4:]
      if not path:
        path = procutil.findexe(cmd)
        if path is None:
          path = filemerge.findexternaltool(ui, cmd) or cmd
      diffopts = ui.config(b"extdiff2", b"opts." + cmd)
      cmdline = procutil.shellquote(path)
      if diffopts:
        cmdline += b" " + diffopts
    elif cmd.startswith(b"opts."):
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
      args = ui.config(b"diff-tools", cmd + b".diffargs") or ui.config(
          b"merge-tools", cmd + b".diffargs"
      )
      if args:
        cmdline += b" " + args
    command(
        cmd,
        extdiffopts[:],
        _(b"hg %s [OPTION]... [FILE]...") % cmd,
        helpcategory=command.CATEGORY_FILE_CONTENTS,
        inferrepo=True,
    )(savedcmd(path, cmdline))


# tell hggettext to extract docstrings from these functions:
i18nfunctions = [savedcmd]
