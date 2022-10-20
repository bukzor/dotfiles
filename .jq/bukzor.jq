
def in($haystack):
  # todo: handle string type too
  . as $needle
  | any($haystack[]?; . == $needle);

def in($needle; $haystack):
  # todo: handle string type too
  any($haystack[]?; . == $needle);


def basename:
  sub("^.*/"; "");

def dirname:
  sub("/[^/]*$"; "");
