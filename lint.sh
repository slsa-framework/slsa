#!/bin/bash

# Require all RFC 2119 keywords to be uppercase to avoid ambiguity.
#
# For lack of a better solution, we allowlist "recommended suite" using a
# negative lookahead assertion.
check_rfc2119() {
  local CMD=(
      git grep --break --heading --line-number --perl-regexp --all-match
      -e '(RFC ?|rfc ?)2119'
      -e '\b([Mm]ust( not)?|[Ss]hall( not)?|[Ss]hould( not)?|[Mm]ay|[Rr]equired|[Rr]ecommended|[Oo]ptional)\b(?![ -][Ss]uite)'
  )
  # Exit silently if there are no matches.
  "${CMD[@]}" -q '*.md' || return 0
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

# Run all of the checks above and exit with non-zero status if any failed.
# We use this structure to allow for multiple checks in the future.
RC=0
check_rfc2119 || RC=1
exit $RC
