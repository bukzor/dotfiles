include "bukzor";

def ESC: "\u001b";
def CSI: "\(ESC)[";

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
  | if width > $strlen then width - $strlen else 0 end
;

def ljust(width; pad):
  tostring
  | . + npadding(width) * pad
;

def ljust(width):
  ljust(width; " ")
;

def rjust(width; pad):
  tostring
  | npadding(width) * pad + .;

def rjust(width):
  rjust(width; " ");


.
| "\(CSI)m" as $ANSI_RESET
| "\(CSI)1m" as $ANSI_BOLD
| "\(CSI)31m" as $ANSI_RED
| "\(CSI)32m" as $ANSI_GREEN
| "\(CSI)34m" as $ANSI_BLUE
| "\(CSI)35m" as $ANSI_PINK
| "\(CSI)37m" as $ANSI_GREY
|

def extract:
  { module:
    [ .module_address // ""
    | splits("\\.?module\\.")
    | select(length > 0)
    ]
  , type: .type
  , name: .name
  , index: .index
  , actions: .change.actions
  }
;

def symbolic_action:
  [ if . == "create" then
      $ANSI_GREEN, "+"
    elif . == "update" then
      $ANSI_BLUE, "~"
    elif . == "delete" then
      $ANSI_RED, "-"
    elif . == "no-op" then
      $ANSI_GREY, "="
    end
  , $ANSI_RESET
  ] | join("")
;

def module_format:
  .module
  | if length > 0 then join(".") else "(root module)" end
;

def format:
  .
  | [ (.actions | map(symbolic_action) | join("/") | ljust(3))
    , " "
    , $ANSI_GREY
    , (.type)
    , "."
    , $ANSI_RESET
    , .name
    , if .index != null then
      ( "[\""
      , $ANSI_BOLD
      , $ANSI_PINK
      , .index
      , $ANSI_RESET
      , "\"]"
      )
      else empty
      end
    ]
  | join("")
;

def title($level; $content):
  [ $ANSI_BOLD
  , "#" * $level
  , " "
  , $content
  , $ANSI_RESET
  ]
  | join("")
;


def intersperse($sep):
  ( first
  , ( .[1:]
    | .[]
    | ($sep, .)
    )
  )
;

def module_section:
    .
    #| sort
    | [ title(2; "module: \(first|module_format)")
      , (map(format)[])
      ]
;


def section(title; ifnone):
  arrays
  | map
    ( extract
    | select(.actions != ["no-op"])
    )
  | group_by(.module)
  | map(module_section)
  | if isempty(.[])
    then ifnone
    else title(1; title), intersperse([""])[]
    end
;

.
| ( (.resource_drift | section("Drift:"; "(no drift)"))
  , ""
  , (.resource_changes | section("Plan:"; "(no changes planned)"))
  )
