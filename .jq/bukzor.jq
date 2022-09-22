
def in($haystack; $needle):
  # todo: handle string type too
  $haystack[]? | . == $needle;
