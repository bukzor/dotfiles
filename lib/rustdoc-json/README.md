# rustdoc-json

Build searchable indexes from rustdoc JSON output.

## Usage

```bash
python rustdoc_json_index.py < ~/.cache/rustdoc-json/serde-1.0.228.json
```

Output format: `id impl_string` per line, one entry per impl item.

```
214 impl serde::de::Error for Error::custom
217 impl serde::ser::Error for Error::custom
1535 impl<T> core::convert::From<T> for CowStrDeserializer<'a, E>::from
```

## API

```python
from rustdoc_json_index import index_rustdoc, ast_to_string

data = json.load(open("crate.json"))
for id_str, ast in index_rustdoc(data):
    print(f"{id_str} {ast_to_string(ast)}")
```

The AST is a nested list structure suitable for structured queries:

```python
["impl",
  ["generics", "T"],
  ["trait", "core::convert::From", ["args", ["T"]]],
  ["for", "Error"],
  ["item", "from"]]
```
