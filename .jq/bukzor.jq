def ESC: "\u001b";
def CSI: "\(ESC)[";

def objmap(f):
    [to_entries[] | f];

def count_by(s):
    reduce .[] as $x ({}; .[$x | s | tostring] += 1);

def count:
    count_by(.);

def invert:
    objmap([.value, .key]);

def histogram:
    count | invert | sort_by(-.[0]) | map(join(" "))[];

def sh_quote:
  if type == "array"
  then map(sh_quote) | join(" ")
  else 
    ( tostring
    | if . | test("^[a-zA-Z_0-9-]*$")
      then .
      else sub("'"; "'\\''") | "'\(.)'"
      end
    )
  end
;

def sh_export:
  to_entries[] | "export \(.key|sh_quote)=\(.value |sh_quote)";

def urlencode:
  to_entries | map("\(.key)=\(.value |@uri)") | join("&");

def options:
  to_entries[] | "--\(.key)=\(.value)";

def in($haystack):
  # todo: handle string rype too
  . as $needle
  | any($haystack[]?; . == $needle);

def in($needle; $haystack):
  # todo: handle string type too
  any($haystack[]?; . == $needle);


def basename:
  sub("^.*/"; "");
def basename($suffix):
  basename | rtrimstr($suffix);

def dirname:
  sub("/[^/]*$"; "");


def visible:
  gsub("
  ( \(ESC)      # ANSI escapes:
    ( \\].*?(\u0007|\u009c|\(ESC)\\\\)  # OSC
    | [`-~]                             # Fs
    | [0-?]                             # Fp
    | [ -/]+[0-?@-_`-~]                 # nF
    | \\[[^@-_`-~]*[@-_`-~]             # CSI
    | .                                 # other?
    )
  | .\b         # Backspace
  | \\p{Other}  # Unicode non-printing
  )
  "; ""; "x")
;

def npadding(width):
  (visible|length) as $strlen
  | if width > $strlen then width - $strlen else 0 end;

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
