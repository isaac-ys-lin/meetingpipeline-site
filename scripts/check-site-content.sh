#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
MODE="${1:-full}"

if [[ "$MODE" != "full" && "$MODE" != "pages-only" ]]; then
  echo "usage: scripts/check-site-content.sh [full|pages-only]" >&2
  exit 2
fi

require_file() {
  local file="$1"
  test -f "$file" || {
    echo "Missing required file: $file" >&2
    exit 1
  }
}

require_match() {
  local file="$1"
  local pattern="$2"
  rg -F -n -- "$pattern" "$file" >/dev/null || {
    echo "Missing required content in $file: $pattern" >&2
    exit 1
  }
}

find_tidy_html5() {
  local tidy_path
  tidy_path="$(command -v tidy || true)"
  [[ -n "$tidy_path" ]] || return 1

  if command -v brew >/dev/null 2>&1 && brew list --formula tidy-html5 >/dev/null 2>&1; then
    local tidy_realpath tidy_prefix tidy_cellar
    tidy_realpath="$(realpath "$tidy_path")"
    tidy_prefix="$(brew --prefix tidy-html5)"
    tidy_cellar="$(brew --cellar tidy-html5)"
    [[ "$tidy_realpath" == "$tidy_prefix"/* || "$tidy_realpath" == "$tidy_cellar"/* ]] || return 1
  else
    "$tidy_path" -version 2>&1 | rg -F -q -- "HTML5" || return 1
  fi

  printf '%s\n' "$tidy_path"
}

required_files=(
  "index.html"
  "gemini-api-key/index.html"
  "models/index.html"
  "privacy/index.html"
  "support/index.html"
  "en/index.html"
  "en/gemini-api-key/index.html"
  "en/models/index.html"
  "en/privacy/index.html"
  "en/support/index.html"
)

for file in "${required_files[@]}"; do
  require_file "$file"
done

zh_pages=(index.html gemini-api-key/index.html models/index.html privacy/index.html support/index.html)
for file in "${zh_pages[@]}"; do
  require_match "$file" 'gemini-api-key/'
  require_match "$file" 'models/'
  require_match "$file" 'privacy/'
  require_match "$file" 'support/'
done

en_pages=(en/index.html en/gemini-api-key/index.html en/models/index.html en/privacy/index.html en/support/index.html)
for file in "${en_pages[@]}"; do
  require_match "$file" 'gemini-api-key/'
  require_match "$file" 'models/'
  require_match "$file" 'privacy/'
  require_match "$file" 'support/'
done

require_match "en/index.html" 'href="../styles.css?v=20260602"'
require_match "en/index.html" 'src="../app-icon.png"'

en_nested_pages=(en/gemini-api-key/index.html en/models/index.html en/privacy/index.html en/support/index.html)
for file in "${en_nested_pages[@]}"; do
  require_match "$file" 'href="../../styles.css?v=20260602"'
  require_match "$file" 'src="../../app-icon.png"'
done

require_match "gemini-api-key/index.html" '會議背景'
require_match "en/gemini-api-key/index.html" 'meeting background'
require_match "gemini-api-key/index.html" 'https://ai.google.dev/gemini-api/docs/audio'
require_match "en/gemini-api-key/index.html" 'https://ai.google.dev/gemini-api/docs/audio'

if [[ "$MODE" == "full" ]]; then
  require_match "support/index.html" 'id="gemini-errors"'
  require_match "en/support/index.html" 'id="gemini-errors"'
  for token in 'HTTP 400' 'HTTP 403' 'HTTP 404' 'HTTP 429' 'HTTP 500' 'HTTP 503' 'HTTP 504' 'Google Gemini API'; do
    require_match "support/index.html" "$token"
    require_match "en/support/index.html" "$token"
  done
  require_match "support/index.html" 'https://ai.google.dev/gemini-api/docs/troubleshooting'
  require_match "en/support/index.html" 'https://ai.google.dev/gemini-api/docs/troubleshooting'
fi

if tidy_cmd="$(find_tidy_html5)"; then
  for file in "${required_files[@]}"; do
    tidy_output="$("$tidy_cmd" -errors -q "$file" 2>&1 >/dev/null || true)"
    if printf '%s\n' "$tidy_output" | rg -q '(^| )Error:'; then
      printf '%s\n' "$tidy_output" >&2
      exit 1
    fi
  done
else
  echo "SKIP: tidy-html5 is not installed or PATH tidy is legacy; install tidy-html5 for stricter HTML validation."
fi
