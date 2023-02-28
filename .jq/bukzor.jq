def sh_quote:
  tostring
  | if . | test("^[a-zA-Z_0-9-]*$")
    then .
    else sub("'"; "'\\''") | "'\(.)'"
    end
  ;

def sh_export:
  to_entries[] | "export \(.key|sh_quote)=\(.value |sh_quote)";

def urlencode:
  to_entries | map("\(.key)=\(.value |@uri)") | join("&");

def options:
  to_entries[] | "--\(.key)=\(.value)";

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


def npadding(width):
  if width > length then width - length else 0 end;

def ljust(width; pad):
  tostring
  | . + npadding(width) * pad;

def ljust(width):
  ljust(width; " ");

def rjust(width; pad):
  tostring
  | npadding(width) * pad + .;

def rjust(width):
  rjust(width; " ");
