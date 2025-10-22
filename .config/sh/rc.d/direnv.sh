_direnv_hook() {
  local previous_exit_status=$?;
  trap -- '' SIGINT;
  if command -v direnv > /dev/null; then
    eval "$("direnv" export bash)";
  fi
  trap - SIGINT;
  return $previous_exit_status;
};
if ! [[ "${PROMPT_COMMAND:-}" =~ _direnv_hook ]]; then
  PROMPT_COMMAND="_direnv_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi
