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

# Require all links to be relative, not absolute.
# Allowed: [requirements](/spec/v1.0/requirements)
#          [requirements]: /spec/v1.0/requirements
# Disallowed: [requirements](https://slsa.dev/spec/v1.0/requirements)
#             [requirements]: https://slsa.dev/spec/v1.0/requirements
#
# This uses a heuristic to detect links in Markdown files, namely
# `https?://slsa.dev` immediately following `(` or `]: `.
check_absolute_links() {
  local FILES=':/docs/*.md'
  local CMD=(
      git grep --break --heading --line-number
      -e '\((\|\]: \)https\?://slsa.dev'
  )
  # Exit silently if there are no matches.
  "${CMD[@]}" -q "$FILES" || return 0
  # If there are matches, print an error and then print the results afterward.
  # NOTE: We don't just capture the command above because that ends up being
  # more difficult to code and also messes with colors (tty detection). It's
  # easier to just run the command twice.
  cat >&2 <<EOF
ERROR: Absolute URLs to slsa.dev are disallowed; use a relative URL instead.
For example, instead of [foo](https://slsa.dev/foo), use [foo](/foo).

EOF
  "${CMD[@]}" "$FILES" >&2
  return 1
}

# Run all of the checks above and exit with non-zero status if any failed.
# We use this structure to allow for multiple checks in the future.
RC=0
check_rfc2119 || RC=1
check_absolute_links || RC=1
exit $RC
