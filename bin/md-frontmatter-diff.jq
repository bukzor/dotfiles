# Recursive leaf-diff. Given two JSON values $cur and $new, emit a single yq
# expression (sub-expressions joined by " | ") that, when applied to $cur,
# produces $new while touching as little of the structure as possible.
#
# Usage:
#   jq -r -n --argjson cur "$current_json" --argjson new "$new_json" \
#     -f md-frontmatter-diff.jq

def diff_expr($cur; $new; $path):
  if $cur == $new then
    empty
  elif ($cur == null) or ($new == null) or (($cur | type) != ($new | type)) then
    ($path + " = " + ($new | tojson))
  elif ($new | type) == "object" then
    (((($cur // {}) | keys_unsorted) + (($new // {}) | keys_unsorted)) | unique) as $keys
    | (
        $keys[] as $k
        | if ($cur | has($k)) and ($new | has($k)) then
            diff_expr($cur[$k]; $new[$k]; $path + "[" + ($k|tojson) + "]")
          elif ($new | has($k)) then
            $path + "[" + ($k|tojson) + "] = " + ($new[$k] | tojson)
          else empty end
      ),
      (
        $keys[] as $k
        | select(($cur | has($k)) and ($new | has($k) | not))
        | "del(" + $path + "[" + ($k|tojson) + "])"
      )
  elif ($new | type) == "array" then
    ($cur | length) as $lc | ($new | length) as $ln
    | (
        range(0; [$lc, $ln] | min) as $i
        | diff_expr($cur[$i]; $new[$i]; $path + "[" + ($i|tostring) + "]")
      ),
      (
        range($lc; $ln) as $i
        | $path + "[" + ($i|tostring) + "] = " + ($new[$i] | tojson)
      ),
      (
        [range($ln; $lc)] | reverse[] as $i
        | "del(" + $path + "[" + ($i|tostring) + "])"
      )
  else
    $path + " = " + ($new | tojson)
  end;

[diff_expr($cur; $new; ".")] | join(" | ")
