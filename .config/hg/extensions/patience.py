# Retrieved 2019-01-21 by Buck from https://bitbucket.org/troter/hg-patience/raw/4a10c8/patience.py
###
# patience.py - Add patience diff to Mercurial.
#
# Copyright 2010 Justin Lebar <justin.lebar@gmail.com>
#
# This software may be used and distributed according to the terms of the
# GNU General Public License version 2 or any later version.
"""generate diffs using the patience diff algorithm

This extension lets Mercurial generate diffs according to (an approximation of)
Cohen's patience diff algorithm.

In particular, you can run :hg:`diff --patience` to get a patience-formatted
diff.  You can also set your hgrc to always use patience diffs::

    [diff]
    patience = 1

This setting will apply to mq as well, just as the rest of the [diff] settings
do.  If you just want hg diff to default to patience diffs, use::

    [defaults]
    diff = --patience

"""

import mercurial
from mercurial import extensions, commands, patch, mdiff
from mercurial.i18n import _
import difflib

using_patience_diff = False


class patiencediffopts(mdiff.diffopts):
  """Wraps a diffopts object as a patiencediffopts object.

    This is used by unidiffwrapper() to signal to blockswrapper() that it
    should use patience diff.

    """

  def __init__(self, opts):
    if not opts:
      opts = mdiff.defaultopts
    self.opts = opts

  def __getattr__(self, attr):
    return getattr(self.opts, attr)

  def copy(self, **kwargs):
    return paticencediffopts(self.opts.copy(kwargs))


def diffcmdwrapper(orig, *args, **kwargs):
  """Wraps the diff command to enable patience diffs.

    If the user passed --patience to diff, this function sets the
    using_patience_diff global to true for the duration of the diff command.
    blockswrapper() will notice that this variable has been set and use the
    patienceblocks function instead of the regular (impatient) blocks function.

    """
  global using_patience_diff

  ui = args[0]
  if kwargs.get('patience'):
    using_patience_diff = True
  ret = orig(*args, **kwargs)
  using_patience_diff = False
  return ret


def diffwrapper(orig, *args, **kwargs):
  """Wraps patch.diff().

    If diff.patience is set to true in the config file, this function wraps the
    diffopts object in a patiencediffopts object, which unidiffwrapper() uses
    to detect that we should use patience diff.

    It's unfortunately not sufficient just to set using_patience_diff in this
    function as we do in diffcmdwrapper(), because patch.diff() returns an
    iterator and blocks() is called only after this function returns.

    """
  ui = args[0].ui
  if ui.configbool('diff', 'patience'):
    if len(args) > 5 and args[5]:
      # Replace args[5] (the diff argument) with a patiencediffopts
      # object.
      argslist = list(args)
      argslist[5] = patiencediffopts(args[5])
      args = tuple(argslist)
    else:
      # Otherwise, set opts in the keyword arguments to a
      # patiencediffopts object.
      kwargs['opts'] = patiencediffopts(kwargs.get('opts'))

  return orig(*args, **kwargs)


def unidiffwrapper(orig, *args, **kwargs):
  """Wraps mdiff.unidiff().

    If the opts argument is a patiencediffopts object, this function sets
    using_patience_diff to true so it can be picked up by blockswrapper(()).

    """
  global using_patience_diff

  patience = isinstance(kwargs.get('opts'), patiencediffopts)
  if patience:
    using_patience_diff = True
  ret = orig(*args, **kwargs)
  if patience:
    using_patience_diff = False
  return ret


def blockswrapper(orig, *args, **kwargs):
  """'Wraps bdiff.blocks(), calling our custom patienceblocks function if

    appropriate.

    """
  global using_patience_diff

  #import sys
  #print >> sys.stderr, 'blockswrapper(), patience=%d' % using_patience_diff

  if not using_patience_diff:
    return orig(*args, **kwargs)
  else:
    return patienceblocks(*args, **kwargs)


def uisetup(ui):
  'Add --patience option to diff command and wrap a few functions.'
  entry = extensions.wrapcommand(commands.table, 'diff', diffcmdwrapper)
  entry[1].append(('', 'patience', True,
                   _('use patience diff algorithm')))

  extensions.wrapfunction(mdiff.bdiff, 'blocks', blockswrapper)
  extensions.wrapfunction(patch, 'diff', diffwrapper)
  extensions.wrapfunction(mdiff, 'unidiff', unidiffwrapper)


#### Slightly-modified copy of hg's bdiff.py below. ####


def splitnewlines(text):
  """like str.splitlines, but only split on newlines."""
  lines = [l + '\n' for l in text.split('\n')]
  if lines:
    if lines[-1] == '\n':
      lines.pop()
    else:
      lines[-1] = lines[-1][:-1]
  return lines


def _normalizeblocks(a, b, blocks):
  prev = None
  for curr in blocks:
    if prev is None:
      prev = curr
      continue
    shift = 0

    a1, b1, l1 = prev
    a1end = a1 + l1
    b1end = b1 + l1

    a2, b2, l2 = curr
    a2end = a2 + l2
    b2end = b2 + l2
    if a1end == a2:
      while (a1end + shift < a2end and a[a1end + shift] == b[b1end + shift]):
        shift += 1
    elif b1end == b2:
      while (b1end + shift < b2end and a[a1end + shift] == b[b1end + shift]):
        shift += 1
    yield a1, b1, l1 + shift
    prev = a2 + shift, b2 + shift, l2 - shift
  yield prev


def _getdupes(a):
  """Returns a set containing the values which appear at least twice in a."""
  once = set()
  twice = set()
  for elem in a:
    if elem in once:
      twice.add(elem)
    else:
      once.add(elem)

  return twice


def patienceblocks(a, b):
  an = splitnewlines(a)
  bn = splitnewlines(b)

  a_dupes = _getdupes(an)
  b_dupes = _getdupes(bn)
  dupes = a_dupes & b_dupes

  d = difflib.SequenceMatcher(dupes.__contains__, an, bn).get_matching_blocks()
  d = _normalizeblocks(an, bn, d)
  return [(i, i + n, j, j + n) for (i, j, n) in d]
