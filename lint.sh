#!/bin/bash

check_rfc2119() {
  local CMD=(
      git grep --break --heading --line-number --extended-regexp --all-match
      -e '(RFC ?|rfc ?)2119'
      -e '\b(must( not)?|shall( not)?|should( not)?|may|required|recommended|optional)\b'
  )
  # Exit silently if there are no matches.
  "${CMD[@]}" -q '*.md' || return
  # If there are matches, print an error and then print the results afterward.
  # NOTE: We don't just capture the command above because that ends up being
  # more difficult to code and also messes with colors (tty detection). It's
  # easier to just run the command twice.
  cat >&2 <<EOF
ERROR: Do not use lowercase RFC 2119 keywords ("must", "should", etc.) because
such usage is ambiguous. Use uppercase if RFC 2119 meaning is intended,
otherwise use alternate phrasing.

(This check triggers on any Markdown file containing the string "RFC 2119".)

EOF
  "${CMD[@]}" '*.md' >&2
  return 1
}

RC=0
check_rfc2119 && RC=1
exit $RC
