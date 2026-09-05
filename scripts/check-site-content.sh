#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
MODE="${1:-full}"
CSS_VERSION="20260715-trace-brand-lockup2"

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

require_count() {
  local file="$1"
  local pattern="$2"
  local expected="$3"
  local actual
  actual="$( (rg -F -o -- "$pattern" "$file" || true) | wc -l | tr -d ' ')"
  [[ "$actual" == "$expected" ]] || {
    echo "Unexpected content count in $file: $pattern (expected $expected, got $actual)" >&2
    exit 1
  }
}

require_regex() {
  local file="$1"
  local pattern="$2"
  rg -U -n -- "$pattern" "$file" >/dev/null || {
    echo "Missing required pattern in $file: $pattern" >&2
    exit 1
  }
}

require_no_regex() {
  local file="$1"
  local pattern="$2"
  if rg -n -- "$pattern" "$file" >/dev/null; then
    echo "Forbidden content in $file: $pattern" >&2
    exit 1
  fi
}

require_absent() {
  local file="$1"
  test ! -e "$file" || {
    echo "Forbidden legacy file still exists: $file" >&2
    exit 1
  }
}

require_png() {
  local file="$1"
  local signature
  signature="$(od -An -t x1 -N 8 "$file" | tr -d '[:space:]')"
  [[ "$signature" == "89504e470d0a1a0a" ]] || {
    echo "Invalid PNG signature in $file" >&2
    exit 1
  }
}

require_sha256() {
  local file="$1"
  local expected="$2"
  local actual
  actual="$(shasum -a 256 "$file" | awk '{print $1}')"
  [[ "$actual" == "$expected" ]] || {
    echo "Unexpected SHA-256 in $file: $actual" >&2
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
  "speaker-analysis/index.html"
  "privacy/index.html"
  "support/index.html"
  "en/index.html"
  "en/gemini-api-key/index.html"
  "en/models/index.html"
  "en/speaker-analysis/index.html"
  "en/privacy/index.html"
  "en/support/index.html"
)

for file in "${required_files[@]}"; do
  require_file "$file"
done

require_file "styles.css"
require_file "app-icon.png"
require_file "brand-icon.png"
require_file "model-catalog.json"
require_match "model-catalog.json" '"updatedAt": "2026-09-03"'
require_match "model-catalog.json" '"schemaVersion": 2'
require_count "model-catalog.json" '"settingsHint":' 4
require_count "model-catalog.json" '"settingsHintEn":' 4
require_regex "model-catalog.json" '(?s)"id": "gemini-transcribe".*?"modelID": "gemini-3\.5-transcribe".*?"transcriptionTransport": "nativeTranscribe"'
require_no_regex "model-catalog.json" '(?s)"kind": "transcription".*?"modelID": "gemini-3\.8-flash"'
require_regex "model-catalog.json" '(?s)"id": "gemini-pro-analysis".*?"modelID": "gemini-3\.8-flash".*?"thinkingLevel": "low"'
require_count "model-catalog.json" '"thinkingLevel": "low"' 1

# The public cost explainer must track the remote catalog and its dated pricing
# assumptions. Keep both languages numerically identical so a copy-only update
# cannot silently leave one set of estimates stale.
for file in "models/index.html" "en/models/index.html"; do
  require_match "$file" 'gemini-3.5-flash-lite'
  require_match "$file" 'gemini-3.8-flash'
  require_match "$file" 'USD 0.30 / 1M'
  require_match "$file" 'USD 0.03 / 1M'
  require_match "$file" 'USD 2.50 / 1M'
  require_match "$file" 'USD 0.75 / 1M'
  require_match "$file" 'USD 0.075 / 1M'
  require_match "$file" 'USD 3.75 / 1M'
  require_match "$file" 'USD 0.060'
  require_match "$file" 'USD 0.122'
  require_match "$file" 'USD 0.153'
  require_match "$file" 'USD 0.242'
  require_match "$file" 'USD 0.304'
  require_match "$file" 'USD 0.338'
  require_match "$file" 'gemini-3.5-transcribe'
  require_match "$file" 'USD 0.023'
  require_no_regex "$file" 'gemini-3\.1-flash-lite|gemini-3\.5-flash([^_-]|$)'
done
require_match "models/index.html" '最後更新：2026 年 9 月 3 日'
require_match "en/models/index.html" 'Last updated: September 3, 2026'

for file in "gemini-api-key/index.html" "en/gemini-api-key/index.html"; do
  require_match "$file" 'href="../models/"'
  require_no_regex "$file" 'gemini-3\.1-flash-lite|1 到 2 小時|1 to 2 hours'
done

require_match "index.html" "href=\"./styles.css?v=${CSS_VERSION}\""
require_match "index.html" 'src="./brand-icon.png"'

for file in "${required_files[@]}"; do
  brand_lockup_count=2
  if [[ "$file" == "index.html" || "$file" == "en/index.html" ]]; then
    brand_lockup_count=3
    require_match "$file" 'id="page-title" aria-label="Trace Audio Notes &amp; Insights"'
  fi
  require_match "$file" 'aria-label="Trace Audio Notes &amp; Insights home"'
  require_count "$file" 'class="brand-signature"' "$brand_lockup_count"
  require_count "$file" 'class="brand-descriptor"' "$brand_lockup_count"
  require_count "$file" '> Audio Notes &amp; Insights</span>' "$brand_lockup_count"
  require_no_regex "$file" '<span class="brand-descriptor">:'
done

for asset in \
  '01-ai-studio-api-keys-redacted.png?v=20260715-safe-crop' \
  '02-create-key-redacted.png?v=20260715-safe-crop' \
  '03-active-limits-redacted.png?v=20260715-safe-crop'; do
  require_match "gemini-api-key/index.html" "${asset}"
  require_match "en/gemini-api-key/index.html" "${asset}"
done
require_png "assets/gemini-api-key/01-ai-studio-api-keys-redacted.png"
require_png "assets/gemini-api-key/02-create-key-redacted.png"
require_png "assets/gemini-api-key/03-active-limits-redacted.png"
require_sha256 "assets/gemini-api-key/01-ai-studio-api-keys-redacted.png" "bbe85e340fdf23db9f5c2e25ac190fef1c8e3d62a629f69421e6aa523178f051"
require_sha256 "assets/gemini-api-key/02-create-key-redacted.png" "5619ea8b55e919873c744eb11f0cc19a2f4fee8c0d1d5146201f0ca5af21d901"
require_sha256 "assets/gemini-api-key/03-active-limits-redacted.png" "77d2c61f02ec87dcc574995827841e6135bb8153ecb72911f66d8c0f5036464e"
require_no_regex "gemini-api-key/index.html" '20260523-crop'
require_no_regex "en/gemini-api-key/index.html" '20260523-crop'
require_match "gemini-api-key/index.html" '帳務與實際用量資料未入鏡'
require_match "en/gemini-api-key/index.html" 'project, billing, and actual usage data are outside the crop'
require_count "gemini-api-key/index.html" 'class="guide-figure guide-figure--dialog"' 1
require_count "en/gemini-api-key/index.html" 'class="guide-figure guide-figure--dialog"' 1

zh_nested_pages=(gemini-api-key/index.html models/index.html speaker-analysis/index.html privacy/index.html support/index.html)
for file in "${zh_nested_pages[@]}"; do
  require_match "$file" "href=\"../styles.css?v=${CSS_VERSION}\""
  require_match "$file" 'src="../brand-icon.png"'
done

require_match "gemini-api-key/index.html" 'class="language-switch" href="../en/gemini-api-key/"'
require_match "models/index.html" 'class="language-switch" href="../en/models/"'
require_match "speaker-analysis/index.html" 'class="language-switch" href="../en/speaker-analysis/"'
require_match "privacy/index.html" 'class="language-switch" href="../en/privacy/"'
require_match "support/index.html" 'class="language-switch" href="../en/support/"'

zh_pages=(index.html gemini-api-key/index.html models/index.html speaker-analysis/index.html privacy/index.html support/index.html)
for file in "${zh_pages[@]}"; do
  require_match "$file" 'gemini-api-key/'
  require_match "$file" 'models/'
  require_match "$file" 'privacy/'
  require_match "$file" 'support/'
done

en_pages=(en/index.html en/gemini-api-key/index.html en/models/index.html en/speaker-analysis/index.html en/privacy/index.html en/support/index.html)
for file in "${en_pages[@]}"; do
  require_match "$file" 'gemini-api-key/'
  require_match "$file" 'models/'
  require_match "$file" 'privacy/'
  require_match "$file" 'support/'
done

require_match "en/index.html" "href=\"../styles.css?v=${CSS_VERSION}\""
require_match "en/index.html" 'src="../brand-icon.png"'

en_nested_pages=(en/gemini-api-key/index.html en/models/index.html en/speaker-analysis/index.html en/privacy/index.html en/support/index.html)
for file in "${en_nested_pages[@]}"; do
  require_match "$file" "href=\"../../styles.css?v=${CSS_VERSION}\""
  require_match "$file" 'src="../../brand-icon.png"'
done

require_match "index.html" 'href="./speaker-analysis/"'
require_match "en/index.html" 'href="./speaker-analysis/"'
require_match "speaker-analysis/index.html" '這項增強不會改寫你說過的內容，也不會因本機分析再次上傳音訊'
require_match "speaker-analysis/index.html" 'Gemini 轉錄與整理功能並不是完全離線'
require_match "speaker-analysis/index.html" '1ed7a662fdc7109e36d822db793ee6eebdaf8594'
require_match "en/speaker-analysis/index.html" 'This enhancement does not rewrite what was said or upload the audio again'
require_match "en/speaker-analysis/index.html" "Gemini transcription and analysis features are not fully offline"
require_match "en/speaker-analysis/index.html" '1ed7a662fdc7109e36d822db793ee6eebdaf8594'

# Trace's web design contract mirrors the app's semantic palette and typography.
for token in \
  '--canvas: #ECEAE5;' \
  '--paper: #F7F5F1;' \
  '--panel: #FFFFFF;' \
  '--ivory: #FBFAF6;' \
  '--ink: #171717;' \
  '--muted: #64645B;' \
  '--line: #DCDAD2;' \
  '--teal: #1F6F8B;' \
  '--teal-soft: #DFEFEF;' \
  '--record-soft: #EEE9E0;' \
  '--success: #298C45;' \
  '--warning: #B85309;' \
  '--copper: #B86445;'; do
  require_match "styles.css" "$token"
done

require_match "styles.css" '--font-serif: ui-serif, "Iowan Old Style", "Palatino Linotype", "Songti TC", serif;'
require_match "styles.css" '--font-brand: "Baskerville-SemiBold", "Baskerville", ui-serif, serif;'
require_match "styles.css" '--font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang TC", sans-serif;'
require_match "styles.css" 'font-family: var(--font-serif);'
require_match "styles.css" 'font-family: var(--font-sans);'
require_match "styles.css" '.trace-rail'
require_match "styles.css" 'background: var(--canvas);'
require_match "styles.css" 'background: var(--paper);'
require_regex "styles.css" '(?s)\.brand \{.*?font-family: var\(--font-brand\);.*?font-size: 28px;.*?gap: 12px;'
require_regex "styles.css" '(?s)\.brand-lockup \{.*?align-items: baseline;.*?display: inline-flex;.*?white-space: nowrap;'
require_regex "styles.css" '(?s)\.brand-descriptor \{.*?color: var\(--teal\);.*?font-family: var\(--font-sans\);.*?font-weight: 600;.*?margin-inline-start: 0\.15em;'
require_regex "styles.css" '(?s)\.content h1 \{.*?font-family: var\(--font-sans\);'
require_regex "styles.css" '(?s)h2 \{.*?border-inline-start: 2px solid var\(--teal\);.*?font-family: var\(--font-sans\);'
require_no_regex "styles.css" '\.trace-rail::before|\.trace-rail::after'
require_match "styles.css" '@media (prefers-color-scheme: dark)'
for token in \
  '--canvas: #0C0E0E;' \
  '--paper: #121414;' \
  '--panel: #1E2121;' \
  '--ivory: #181A1A;' \
  '--ink: #F0F0E8;' \
  '--muted: #B0B5AF;' \
  '--line: #3F4443;' \
  '--teal: #68C5D1;' \
  '--teal-soft: #203C40;' \
  '--record-soft: #32302B;' \
  '--success: #6BD18A;' \
  '--warning: #EA9F50;' \
  '--copper: #D37B56;'; do
  require_regex "styles.css" "(?s)@media \\(prefers-color-scheme: dark\\).*?${token}"
done
require_match "styles.css" '@media (prefers-reduced-motion: reduce)'

require_match "index.html" 'class="trace-rail"'
require_match "en/index.html" 'class="trace-rail"'

for file in "${required_files[@]}"; do
  require_match "$file" 'class="brand-icon"'
  require_match "$file" 'width="42" height="42"'
done

for label in '錯誤' '常見意思' '你可以做什麼'; do
  require_count "support/index.html" "data-label=\"${label}\"" 7
done
for label in 'Error' 'Common meaning' 'What to try'; do
  require_count "en/support/index.html" "data-label=\"${label}\"" 7
done

for page in support/index.html en/support/index.html; do
  for anchor in gemini-errors recording-recovery gemini-incomplete gemini-network gemini-quota gemini-access gemini-model gemini-service gemini-request; do
    require_match "$page" "id=\"${anchor}\""
  done
done

require_absent "favicon.svg"
for file in "${required_files[@]}"; do
  require_no_regex "$file" 'MeetingPipeline|(^|[^[:alnum:]_])MP([^[:alnum:]_]|$)'
done
while IFS= read -r file; do
  require_no_regex "$file" 'MeetingPipeline|(^|[^[:alnum:]_])MP([^[:alnum:]_]|$)'
done < <(find . -type f -name '*.svg' -not -path './.git/*' -print)

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

require_match "models/index.html" '不支援自訂詞彙提示'
require_match "en/models/index.html" 'does not support custom vocabulary alongside timestamps'
require_match "models/index.html" 'https://ai.google.dev/gemini-api/docs/transcribe#custom-vocabulary'
require_match "en/models/index.html" 'https://ai.google.dev/gemini-api/docs/transcribe#custom-vocabulary'

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
