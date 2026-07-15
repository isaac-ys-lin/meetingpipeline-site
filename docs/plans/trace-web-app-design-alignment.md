# Trace 網站與 App 設計對齊

Status: Ready for visual review
Last updated: 2026-07-15

## Goal

讓 `/Users/isaacyslin/Code/meetingpipeline-site` 的所有繁中／英文公開頁面使用 Trace App 現行的品牌語言：暖紙、墨色、teal、copper、Serif 品牌字、安靜的 editorial utility 與短促功能性動態；並以 App 匯出 HTML 的 `Trace` signature 作為網站品牌字形來源、以現行 Google AI Studio UI 重拍 API Key 教學截圖。保留網站既有靜態架構、公開內容與路由，不把本輪擴張成行銷站或框架重寫。

App 端設計真相依序以以下檔案為準：

1. `/Users/isaacyslin/Code/iOSapp/MeetingPipelineIOS/App/MeetingPipelineStyle.swift`
2. `/Users/isaacyslin/Code/iOSapp/MeetingPipelineIOS/Assets.xcassets/`
3. `/Users/isaacyslin/Code/iOSapp/MeetingPipelineIOS/Features/` 內現行 SwiftUI 用法
4. `/Users/isaacyslin/Code/iOSapp/docs/superpowers/plans/2026-07-13-trace-remaining-visual-and-device-qa.md`

若實作前 App 設計已漂移，先重新回讀上述來源並更新本計畫，不從舊截圖或 archived plan 反推規範。

## Current contract

- In scope:
  - 重建 `styles.css` 的 semantic token、字體、間距、surface、狀態色、light／dark、responsive 與 motion 規則。
  - 對齊 10 個既有頁面：繁中／英文首頁、API Key、模型與成本、隱私、支援。
  - 重做共用 header／footer、首頁品牌層級、內容頁標題／section／panel／table／callout 的視覺語法。
  - Header 使用 App 現行透明 `BrandIcon`；`app-icon.png` 保留作 favicon／平台圖示。清除未使用且仍顯示 `MeetingPipeline`／`MP` 的 `favicon.svg` 殘餘。
  - 網站跟隨 `prefers-color-scheme` 支援 light／dark；保留 skip link、鍵盤 focus、reduced motion 與語言切換。
  - 更新 `scripts/check-site-content.sh`、CSS cache version 與 README，讓品牌契約可自動回歸。
  - Header Logo 旁與首頁主視覺的 literal `Trace` 採 App `MeetingTemplate.htmlStyles` 已使用的 Baskerville signature 字形；內容頁 H1／H2 維持 system sans，panel title 可用 system serif。
  - 重新拍攝 API Keys、Create key、Rate limits 三張 Google AI Studio 教學截圖，改用現行 UI、聚焦操作區與最小必要遮蔽。
- Out of scope:
  - 不改公開路由、anchor、模型資料、價格內容、隱私承諾、支援責任或中英文資訊架構。
  - 不新增 App Store CTA、方案／付款頁、行銷追蹤、analytics、cookie banner、後端、CMS、JavaScript framework 或第三方 web font。
  - 第一輪不新增手動 theme switch；網站只跟隨系統外觀，避免為單一控制引入狀態與腳本。
  - 不搬用 App 的 splash、TabView、sheet、SF Symbols、錄音 waveform、drag/drop、haptic、Live Activity 或 Liquid Glass。
  - 不修改 App source、不做 release build、不部署網站、不 commit／push；本輪只允許 Debug Simulator build 作 fresh 視覺證據，且完成後停止 App 並清除 session defaults。
  - 不散布 Apple 系統字體檔、不引入未確認授權的 web font；Baskerville 以系統字體 stack 使用，非 Apple 平台保留合適 serif fallback。
  - 重拍截圖不得建立／刪除 API key、變更 Google project／billing／quota，或公開帳號、project、key、付款與用量識別資訊。
- Acceptance criteria:
  - 10 個頁面的品牌鎖定、字體層級、色彩、panel、導覽與 footer 一致；頁面上沒有可見 `MeetingPipeline`／`MP` 舊品牌。
  - Light 使用 `#F7F5F1` paper、`#171717` ink；dark 使用 `#121414` paper、`#F0F0E8` ink，其他 semantic colors 與 App token 對應。
  - Header Logo 旁與首頁 literal `Trace` 使用 App 匯出 HTML signature 的 Baskerville stack；內容頁 H1／H2 使用 system sans，panel title 使用跨平台 system serif。內文／控制使用 system sans；日期、版本、價格與代碼使用 monospace／tabular figures。
  - 主 surface 為 panel＋1px quiet border＋8px radius；一般內容不使用大面積陰影、漸層、玻璃或高飽和裝飾。Teal 只承擔品牌／主要互動，copper 只承擔錄音、警告或破壞性語意。
  - 390、768、1280px 寬度都無頁面級水平 overflow；只有高資訊密度 cost table 可在標示清楚且可鍵盤操作的容器內橫向捲動。支援錯誤表在窄幅改為可直接閱讀的 stacked rows。
  - Nav、language switch、button、card link 等離散控制的 target 至少 44px；prose inline link 不強制撐高到 44px，但必須有持續可見 underline、清楚 focus-visible、足夠行高且不與相鄰 link 重疊。200% zoom、繁中／英文長字串、reduced motion、light／dark 不裁切、不重疊、不只靠色彩傳達狀態。
  - 一般文字與背景至少符合 WCAG AA 4.5:1，大字至少 3:1；不以 App 尚未完成的實機 accessibility gate 代替網站驗收。
  - `bash scripts/check-site-content.sh full`、HTML validation（若 `tidy-html5` 可用）、內部連結／資產檢查與 `git diff --check` 全部通過。
  - Header 品牌字在 Apple 瀏覽器使用 App HTML signature 的 Baskerville 字形，仍保持 42px Logo、28px wordmark、12px gap 與 44px target；fallback 平台不破版。
  - 三張教學截圖使用一致 1280px source viewport 與各任務所需的安全裁切；不靠黑塊或模糊遮蔽，而是讓帳號、key、專案、帳務與實際用量完全不入鏡。中英文頁共用同一組 English UI 截圖，caption／alt 各自本地化。
  - 不以 root token 數值相同視為設計完成；須以 App 現行畫面與 HTML export 做 side-by-side，逐項驗收 paper／panel 比例、色彩角色、邊框與圓角、字體角色、留白密度、資訊層級及 light／dark 整體觀感，並以使用者確認無重大視覺落差為完成條件。

## Decisions

- **Superseded** — 使用者原先要求先寫計畫、暫不實作；2026-07-15 已明確要求「實作這份計畫」。此確認只授權網站檔案實作與驗證，仍不授權 commit、push 或 deployment。
- **Confirmed** — 本輪是設計規範對齊，不是內容與產品定位改版；若要重做 landing story 或 CTA，另行擴充 scope。
- **Confirmed** — 保留原生靜態 HTML／CSS。現況只有 22 個 tracked files，導入 framework 的成本與殘餘大於收益。
- **Confirmed** — 採「semantic token＋必要 markup 調整」，不採只換色的 minimal reskin；只換色無法修正 Serif 品牌、dark mode、共用 shell、窄幅 table 與內容層級差距。
- **Confirmed** — 直接複用 App 的 `BrandIcon.png`，不自行重畫 SVG；App icon 繼續作 favicon。若未來取得正式 vector source，再以同一尺寸與可見 delta 驗收替換。
- **Superseded** — 「系統 light／dark 已能對齊 App 的主要外觀契約」僅由 token 與自動檢查支持，不能代表實際視覺完成；使用者確認目前顏色與設計仍未完全對齊 App。是否加入手動 theme switch 仍維持 out of scope。
- **Confirmed** — 網站的單一 signature 是「Trace rail」：從 BrandIcon 的波形／文件線條與 App 匯出文件的 teal 垂直章節導線抽出一條安靜的 teal rail，只用於首頁主敘事與內容 section 導引；其他元件保持克制。
- **Superseded** — 「Baskerville 只屬於 App launch、不進網站 wordmark」不完整；App 的匯出 HTML 也明確以 `"Baskerville-SemiBold", "Baskerville", serif` 呈現 `.trace-signature`。網站 header 的 Logo 旁 `Trace` 改以這個 HTML signature 為字形來源，但內容 heading 仍維持 system serif。
- **Confirmed** — 現有 Google AI Studio 截圖不是不可變資產；使用者接受重拍。新版本以當前 UI、任務聚焦裁切與最小必要遮蔽取代大面積黑塊／全頁模糊。
- **Confirmed** — 公開網站以 App `MeetingTemplate.htmlStyles` 的 HTML export 作主要版面語法：canvas／parchment、Baskerville signature、sans 文件標題與 2px teal section rail；SwiftUI 畫面則提供 panel、button、spacing、radius 與 semantic color role。網站不逐像素複製 iPhone 構圖。
- **Superseded** — 網站自行放大的 60–72px Serif 文件標題與帶裝飾短線的首頁 Trace rail 不屬於 App／HTML export 現行語法；第二輪改為較緊湊的文件尺度與單純 section rail。

## Visual direction

### Semantic palette

| Token | Light | Dark | 用途 |
| --- | --- | --- | --- |
| canvas | `#ECEAE5` | `#0C0E0E` | 桌機網站外層／App HTML export canvas |
| paper | `#F7F5F1` | `#121414` | 頁面背景 |
| panel | `#FFFFFF` | `#1E2121` | card／table／callout surface |
| ivory | `#FBFAF6` | `#181A1A` | 紙面次層／hover surface |
| ink | `#171717` | `#F0F0E8` | 主文字 |
| muted | `#64645B` | `#B0B5AF` | 次文字 |
| line | `#DCDAD2` | `#3F4443` | quiet border |
| teal | `#1F6F8B` | `#68C5D1` | 品牌、link、主要互動 |
| teal-soft | `#DFEFEF` | `#203C40` | 選取／資訊 surface |
| record-soft | `#EEE9E0` | `#32302B` | 中性記錄狀態 |
| success | `#298C45` | `#6BD18A` | 成功 |
| warning | `#B85309` | `#EA9F50` | 警告 |
| copper | `#B86445` | `#D37B56` | 錄音／破壞性語意 |

色值只出現在 root semantic variables；component 不散落 raw hex。若對比檢查不過，優先調整 web 專用 role alias（例如 link text），不改寫 App source token。

### Typography and geometry

- Header brand wordmark：`"Baskerville-SemiBold", "Baskerville", ui-serif, serif`，沿用 App 匯出 HTML 的 `.trace-signature` 字形；首頁品牌 H1 可共用，其他文件 H1／H2 使用 system sans。Panel title 可用 App SwiftUI 的 system serif。非 Apple 平台與 CJK 缺字回退仍須實際驗收。
- Body／control：`-apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang TC", sans-serif`。
- Utility：`ui-monospace, "SFMono-Regular", Menlo, monospace`，價格／數字加 `font-variant-numeric: tabular-nums`。
- Web spacing 採 4／8／12／16／24／32／48／64 rhythm；panel radius 8、row radius 10，nav／button／card 等離散控制 target 44。iOS point 值是比例來源，不逐字複製到桌面；prose inline link 依文字流驗收，不硬撐 44px。
- 內容閱讀寬度約 68ch；桌機 shell max-width 1120px 可保留，但移除目前紙張 frame 的大面積 drop shadow，改為 paper 上的 quiet layout。

### Layout thesis

```text
Desktop
┌─────────────────────────────────────────────────────────────┐
│ [BrandIcon] Trace              API Key Models Privacy Support│
├─────────────────────────────────────────────────────────────┤
│ ┃ Trace                                                     │
│ ┃ 錄下或匯入內容，整理成可追蹤的結果。                      │
│ ┃                                                          │
│ ┃ [API Key guide] [Models & costs]                          │
│ ┃ [Privacy]       [Support]                                 │
├─────────────────────────────────────────────────────────────┤
│ Trace                                      bilingual links   │
└─────────────────────────────────────────────────────────────┘

Mobile: 同一資訊順序；導覽可換行、cards 單欄，Trace rail 保留但不壓縮內文。
```

- Header lockup 用透明 BrandIcon＋Serif `Trace`，圖示為裝飾時 `alt=""`，整組 link 提供唯一 accessible name。
- 首頁不做 generic SaaS hero、裝置 mockup、亮色漸層或數字 KPI；以真實產品工作流與四個既有入口為主。
- 動態只保留 140–200ms hover／press／focus feedback；首頁可用一次不阻擋內容的 240ms opacity reveal，`prefers-reduced-motion` 時取消。不得搬用 App splash 或 logo flight。

## Implementation outline

預估會碰 15 個既有／新增／移除路徑，超過 8 files，原因是 10 個靜態 HTML 各自持有重複 header／footer 與 CSS cache version；本輪不因此導入 template engine。

### Phase 1 — Brand foundation and shared shell

此 phase 單獨完成即可上線：即使 Phase 2 不做，10 個頁面仍可用，且已具備 Trace token、Serif 品牌、light／dark 與一致 shell。

1. 在 `scripts/check-site-content.sh` 先加入本 phase 的品牌契約，取得可歸因的 RED；完成實作後轉為 GREEN。
2. 在 `styles.css` 建立 exact semantic variables、system dark overrides、字體 stack、spacing／radius／target tokens、focus 與 reduced-motion 規則；保留舊 class alias 到 Phase 2 完成，避免中途破版。
3. 從 App asset catalog 複製正式 `BrandIcon.png` 為網站 `brand-icon.png`；保留 SHA-256 evidence。`app-icon.png` 不改像素，只作 favicon／平台圖示；刪除未使用的舊 `favicon.svg`。
4. 更新 10 個 HTML 的 header／footer lockup、active nav、asset path、CSS version；品牌圖示與字樣不得重複被 assistive technology 朗讀。
5. 更新 README 的 asset source-of-truth、同步方式與禁止手繪替代規則。
6. 跑完整 site check、link／asset check、桌機與手機 light／dark shell QA，並保持 Phase 1 diff 可獨立 review／rollback；只有使用者另行授權後才 commit。

### Phase 2 — Page hierarchy and content components

此 phase 在 Phase 1 已可用的基礎上逐頁完成；每一對 zh／en 頁面一起修改與驗收，避免語系漂移。

1. 首頁 pair：建立 Trace rail、Serif hero、四個等權入口與清楚 hover／focus；不新增產品承諾或 CTA。
2. API Key pair：重排 step list、截圖、metadata 與 comparison，只有真正的流程使用序號；長 URL／code 可換行。
3. Models pair：對齊 model cards、assumption、cost flow、formula、table 與 price number typography；cost table 保留可鍵盤橫向捲動並提供明確 overflow cue。
4. Support pair：把窄幅錯誤表改成 stacked rows，錯誤碼、意思、下一步均可直接閱讀；callout 使用 teal／warning semantic role，不只靠底色。
5. Privacy pair：維持長文閱讀與更新日期層級，避免將政策內容卡片化或用裝飾切碎。
6. 清除 Phase 1 的舊 class compatibility alias，更新 script assertions 與 cache version。
7. 跑下方完整 verification matrix；修正 Important findings 後再做唯讀 adversarial review。保持 Phase 2 diff 與 Phase 1 可區分；只有使用者另行授權後才 commit，不部署。

### Expected file scope

- Modify: `styles.css`
- Modify: `index.html`, `en/index.html`
- Modify: `gemini-api-key/index.html`, `en/gemini-api-key/index.html`
- Modify: `models/index.html`, `en/models/index.html`
- Modify: `privacy/index.html`, `en/privacy/index.html`
- Modify: `support/index.html`, `en/support/index.html`
- Modify: `scripts/check-site-content.sh`
- Modify: `README.md`
- Create: `brand-icon.png`
- Remove: `favicon.svg`
- Modify／replace after privacy review: `assets/gemini-api-key/01-ai-studio-api-keys-redacted.png`, `02-create-key-redacted.png`, `03-active-limits-redacted.png`
- Preserve unchanged: `app-icon.png`, `model-catalog.json`

### Phase 3 — Evidence-led visual parity correction

1. 以 App Simulator 的 Dashboard／Settings light 畫面、`MeetingPipelineStyle.swift` 與 `MeetingTemplate.htmlStyles` 建立 parity matrix；不再用 token presence 代替畫面判斷。
2. CSS 改為 export canvas＋paper frame；品牌 signature 用 Baskerville；文件 H1／H2 用 sans；panel title 保留 serif；統一 8px radius、16px 核心 spacing、1px line 與 teal／teal-soft action roles。
3. 移除首頁 rail 裝飾短線、收斂過大 heading／section spacing／card padding；維持 390／768／1280 responsive 與網站路由／內容不變。
4. 以現行 Google AI Studio UI 重拍三張 task-focused screenshot，不改 Google 帳號狀態；若登入 session 或私人資料無法安全避開，先完成其餘 parity correction 並把 screenshot 標為唯一 blocker。
5. 更新 design-contract assertion、跑完整 automated／visual／accessibility QA，再做 adversarial review。

## Verification contract

### Automated

1. 每個 phase 先讓新增 design-contract assertion 在舊實作真實失敗，再完成 GREEN；不可寫永遠會通過的 presence-only guard。
2. `bash scripts/check-site-content.sh full`
3. 以本機 HTTP server 對 10 個 route 執行 2xx、內部連結、CSS 與 image asset 檢查；anchor `#gemini-errors` 必須保留。
4. 若 `tidy-html5` 可用，10 個 HTML 必須無 Error；若不可用，回報 skip，不把 skip 宣稱為 pass。
5. `git diff --check`
6. Brand audit：公開文字與可讀 SVG 不含 `MeetingPipeline`／`MP`；`app-icon.png` 與 App AppIcon SHA-256 相同，`brand-icon.png` 與 App BrandIcon SHA-256 相同。

### Manual／visual

- Viewports：390×844、768×1024、1280×900。
- Themes：system light、system dark；另外確認 asset 在兩種背景沒有白框、灰邊或不可見細節。
- Pages：10 個 route 全數 smoke；詳細視覺 anchor 至少含 zh 首頁 light／dark、en 首頁 mobile、zh support mobile、en models desktop dark、API Key guide mobile、privacy desktop。
- Accessibility：keyboard-only、skip link、focus-visible、200% zoom、reduced motion、對比、link 不只靠顏色、table overflow 可聚焦；離散控制驗 44px，prose inline link 驗 underline、focus、行高與相鄰 link 不重疊。
- Content stress：繁中／英文長字串、API URL、長 model code、價格欄、支援錯誤碼、guide 截圖 fallback。
- Adversarial review：特別找 token 漂移、dark mode 閃白、重複品牌朗讀、語系路徑錯誤、桌面陰影回潮、mobile table 假 responsive 與舊品牌殘餘；Important findings 清零才可交付。

## Risks and constraints

- **Premise collapse** — 本計畫假設 `MeetingPipelineStyle.swift` 與 2026-07-13 active plan 仍是 App 現行真相；若實作前 App 又改品牌 token、字體或 asset，網站會再次漂移，必須先同步 plan。
- System serif 與 CJK serif 在不同平台會使用不同 fallback；不用外部 font 的代價是字形不完全一致，驗收目標是 hierarchy／character 一致，不是跨平台像素相同。
- `BrandIcon` 目前只有 PNG，沒有正式 vector source；不得為了 SVG 自行重畫。小尺寸與 dark background 必須以實際 render 驗收。
- 10 個頁面重複 shell，最容易發生路徑與 cache version 漂移；script 必須檢查每一頁，不用人工抽樣代替。
- Support 與 cost tables 的窄幅需求不同：support 要 stacked、cost data 要保留欄位比較。不得用單一 table CSS 強行處理兩者。
- 靜態站無資料 migration、外部服務或 credential。實作期間保持逐 phase diff boundary；若之後另行授權 commit，才以逐 phase revert 作 rollback，未 commit 時則反向套用對應 phase patch。CSS cache 以新 version query 避免舊樣式殘留。

## Progress and evidence

- 已唯讀確認網站 repo 為乾淨 `main`，共 22 個 tracked files、10 個中英 HTML、1 份 `styles.css`，沒有 package／framework 或既有 design plan。
- 現行網站固定 `color-scheme: light`、所有 heading 使用 Avenir／system sans、frame 有大面積 shadow；桌機首頁為 1120px frame，手機 390px 時 cards 單欄且頁面無水平 overflow。
- 現行支援表在 390px 以 720px table 放進 335px scroll wrapper；可用但不是手機可直接閱讀的結構。
- `app-icon.png` 與 App `AppIcon.png` SHA-256 相同；App 另有正式透明 `BrandIcon.png`。網站 `favicon.svg` 仍寫 `MeetingPipeline`／`MP`，屬待清除舊品牌殘餘。
- App 已確認的視覺主軸為暖白 paper、ink、teal、copper 與 Serif `Trace`；啟動飛行 Logo 是已否決歷史方案，不得回帶到網站。
- 2026-07-15 使用者已確認實作本計畫；fresh preflight 顯示 site 只有本計畫的 `docs/` 為未追蹤內容，App repo 沒有本輪造成的變更，無阻斷 drift。
- Phase 1 先建立真實 RED：`bash scripts/check-site-content.sh full` 以 `Missing required file: brand-icon.png`、exit 1 失敗；完成品牌資產與共用 shell 後轉為 GREEN。
- Phase 1／2 的工程基礎已完成：10 頁共用 BrandIcon＋Serif Trace lockup、exact light／dark semantic tokens、Trace rail、內容元件、支援錯誤 stacked rows、44px 離散控制、focus-visible 與 reduced-motion；舊 `favicon.svg` 已移除。這些結果只代表 contract／功能 GREEN，色彩角色與整體設計對齊仍為 provisional，尚未取得使用者視覺驗收。
- Brand evidence：網站 `brand-icon.png` 與 App BrandIcon SHA-256 均為 `9441dcc6ccee476964a0bca26932ce23023cefd9a06c882a92921d9cfd53b3ec`；網站 `app-icon.png` 與 App AppIcon 均為 `ec30a0e02d66695a0be4d1e873aa9732d8a417c8fd16b09affce5053248ca855`。
- Automated GREEN：`bash scripts/check-site-content.sh full`、可用的 `/opt/homebrew/bin/tidy` HTML validation、`git diff --check` 全數 exit 0；10 個 route 與 `styles.css`／`brand-icon.png`／`app-icon.png` 經本機 HTTP smoke 全數回 200，`#gemini-errors` 中英文 anchor 均保留，公開 HTML／SVG 無 `MeetingPipeline`／獨立 `MP`。
- Browser QA：390／768／1280px 代表頁均無水平 overflow；首頁 light／dark、英文 models dark、繁中 API guide mobile、support mobile stacked rows、privacy desktop 皆可正常 render，圖片無 broken asset；200% page scale 無水平 overflow，reduced motion 將 reveal 降為 1ms。
- Accessibility evidence：一般 light 對比分別為 ink 16.46:1、muted 5.49:1、teal／focus 5.21:1；dark 分別至少 9.24:1。10 頁保留 skip link 與 focus-visible，cost table wrapper 可聚焦，繁中內容頁語系切換已逐頁對應英文同頁。瀏覽器自動化未能把 Tab 事件送入頁面 DOM，因此 keyboard tab order 以靜態契約確認，仍建議部署前人工走一次鍵盤 smoke。
- Adversarial review 的 3 項 Medium finding（語系頁面情境、focus ring 對比、68ch 長文寬度）已修正並二次確認清零；無剩餘 High／Medium finding。
- 2026-07-15 fresh evidence：App `MeetingPipelineIOS/Core/Templates/MeetingTemplate.swift` 的 HTML export 對 `.trace-signature` 使用 Baskerville-SemiBold；現有三張 Google AI Studio 圖均為 3340×1500，且有大面積黑色遮蔽或全頁模糊，適合重拍成 task-focused assets。
- 2026-07-15 使用者明確指出目前網站顏色與設計尚未完全對齊 App；fresh source readback 只能確認網站 root token 對應 `MeetingPipelineStyle.swift`，尚無逐畫面的 component-role／layout parity evidence，因此不得再宣稱設計已完成。
- 2026-07-15 fresh Simulator evidence：Dashboard／Settings 使用 paper canvas、16px page／panel spacing、white panel、1px line、8px radius、22–28pt serif content／brand title、12–14pt sans body／control、teal／teal-soft action；網站基線則為無 canvas／paper 層次、50–72px 全域 serif headings、22px cards 與額外 hero rail marks。
- Phase 3 已完成：網站採 `#ECEAE5` canvas＋`#F7F5F1` paper frame、Baskerville Trace signature、sans content H1／H2、2px teal section rail，以及 1px line／8px radius／16px panel padding；移除額外 rail marks，收斂過大 heading 與卡片密度。CSS cache version 為 `20260715-trace-app-alignment3`。
- Responsive／theme evidence：390px 的 10 個 route 全數 `scrollWidth === clientWidth`、圖片無 broken asset，首頁 H1 使用 Baskerville、其餘內容頁 H1 使用 system sans；另以 768×900、1280×900 與 system dark 實際回讀 canvas／paper／panel／ink／teal 角色，無頁面級 overflow。
- Google AI Studio evidence：以當前 `/app/api-keys` 與 `/app/rate-limit` UI 唯讀重拍，僅開啟後關閉 Create key dialog，沒有送出表單、建立 key 或修改 project／billing／quota。安全資產為 1280×210、560×204、1280×128 的真正 PNG；SHA-256 與 PNG magic bytes 已加入自動契約。
- Final GREEN：`bash scripts/check-site-content.sh full`、tidy HTML validation 與 `git diff --check` 全數 exit 0；adversarial review 的 PNG MIME 與截圖隱私兩項 Medium finding 修正後復核清零，無剩餘 High／Medium finding。
- 下一個 meaningful action：由使用者做最後視覺確認；技術實作、隱私 review 與驗證已完成。仍未 commit、push 或部署。

## Open questions

- 使用者是否確認目前網站與 App 已無重大視覺落差；在取得這個主觀驗收前，狀態維持 `Ready for visual review`，不自動進入 commit、push 或 deployment。

## Decision log

- 2026-07-15 — 使用者由「先別實作」切換為「實作這份計畫」；狀態由 Ready 改為 Implementing，原先 assumptions 全數視為已核准，但 Git／deployment 權限不擴張。
- 2026-07-15 — Phase 1／2 實作、完整驗證與 adversarial review 完成；狀態由 Implementing 改為 Complete，保留人工 keyboard smoke 作部署前建議，不阻擋本輪交付。
- 2026-07-15 — 使用者確認可沿用 App 匯出 HTML 的 Trace signature 字形，並接受重拍 Google AI Studio 教學截圖；狀態由 Complete 改為 Clarifying，等待實作授權與可用登入 session，既有 Git／deployment 權限不擴張。
- 2026-07-15 — 使用者確認目前顏色與設計尚未完全對齊 App；撤回以 exact token 與自動 GREEN 代表視覺完成的判定，新增 side-by-side parity 與使用者視覺確認作為完成 gate。
- 2026-07-15 — 使用者授權「先盤點、然後執行」；fresh Simulator／source／website evidence 已收斂 Phase 3，狀態由 Clarifying 改為 Implementing，Git／deployment 與 Google 狀態變更權限不擴張。
- 2026-07-15 — Phase 3 parity correction、安全重拍、10-route responsive／dark QA 與二次 adversarial review 完成；狀態由 Implementing 改為 Ready for visual review。截圖改採 task-specific crop，優先讓私人資料完全不入鏡；Git／deployment 權限仍不擴張。
