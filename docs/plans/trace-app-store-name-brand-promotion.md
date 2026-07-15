# Trace App Store 名稱與網站品牌簽名對齊

Status: Complete
Last updated: 2026-07-15

## Goal

依 `/Users/isaacyslin/Code/iOSapp/output/html/Trace-export-sample.html` 的品牌簽名概念，在網站現有獨立 `Trace` wordmark 後加入小字 `: Audio Notes & Insights`，讓網站與 App Store 公開名稱 `Trace: Audio Notes & Insights` 建立直接關聯。

## Confirmed scope

- 修改 10 頁 header 的獨立品牌 lockup。
- 修改繁中與英文首頁 hero 的獨立 `Trace` 主標。
- 修改 10 頁 footer 的獨立品牌 lockup。
- `Trace` 保留 Baskerville、既有尺寸與主要視覺權重。
- `: Audio Notes & Insights` 使用 system sans、小字、teal accent、同一基線且不換行。
- Header home link 的 accessible name 改為 exact `Trace: Audio Notes & Insights home`。
- 更新 CSS cache version 與 `scripts/check-site-content.sh` 品牌契約。
- README 與既有設計計畫只同步新的 lockup 規則。

## Explicit non-goals

- 不機械替換教學、支援、隱私、模型頁內文中的 `Trace`。
- 不修改內容頁 H1、頁面 `<title>`、meta description、Open Graph 或 SEO 架構。
- 不新增 App Store badge、下載 CTA、share image 或 App Store URL。
- 不修改 App、BrandIcon、路由、資料、截圖或既有功能。

## Reference values

App export sample：

- `.trace-brand-lockup`：`inline-flex`、baseline alignment、`white-space: nowrap`。
- `.trace-signature`：Baskerville SemiBold、ink、600 weight、0.04em tracking。
- `.trace-descriptor`：system sans、accent、600 weight、較小字級、0.025em tracking。

Website mapping：

- Header：現有 28px `Trace` 不變，descriptor 約 11px。
- Hero：現有 responsive `Trace` 不變，descriptor 約 12 至 16px。
- Footer：現有 18px `Trace` 不變，descriptor 約 10px。
- Descriptor 不單獨動畫、不另加背景、不做 badge。

## Implementation sequence

1. 在 `scripts/check-site-content.sh` 先加入 brand descriptor contract，確認現行網站真實 RED。
2. 更新 10 頁 header markup 與 aria label。
3. 更新兩個首頁 hero lockup。
4. 更新 10 頁 footer lockup。
5. 在 `styles.css` 加入共用 `.brand-lockup`、`.brand-signature`、`.brand-descriptor`，以 context modifier控制 header、hero、footer 尺度。
6. 更新 CSS cache version、README 與既有設計計畫。
7. 跑 automated 與 rendered QA，修正後再 commit、push 到 `origin/main`。

## Verification

- `bash scripts/check-site-content.sh full`
- HTML tidy validation
- `git diff --check`
- 10 route internal link／asset smoke
- 320、390、768、1280px light／dark rendered QA
- Header nav、hero 與 footer 無水平 overflow
- Descriptor 在 320px 不被隱藏、不截斷、不讓 `Insights` 成為 orphan line
- BrandIcon 維持 `alt=""`，header link 只有一個完整 accessible name
- 一般內容中的短名 `Trace` 保持原樣

## Approval boundary

使用者已授權實作、commit 與 push。未授權網站部署、App 修改或 App Store Connect 狀態變更。

## Completion evidence

- 新品牌契約先在舊畫面以 `Missing required content in index.html: aria-label="Trace: Audio Notes &amp; Insights home"` 真實失敗，實作後 `bash scripts/check-site-content.sh full` 轉為 GREEN。
- 10 頁 header、兩個首頁 hero、10 頁 footer 都使用完整 lockup；首頁 heading 與 header link 的 accessible name 也使用 exact 公開名稱。
- 320px 的 10 個中英文 route 全數無水平 overflow、無 broken image、lockup 保持單行；390、768、1280px 與 light／dark 代表畫面均通過實際渲染檢查。
- 一般內容、頁面 title、SEO metadata、App、路由、截圖與產品資料均未修改。
