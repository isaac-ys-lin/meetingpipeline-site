# Trace

- 隱私政策：`/privacy/`
- 支援頁：`/support/`
- Gemini API Key 教學：`/gemini-api-key/`
- 模型與成本說明：`/models/`
- 模型目錄：`/model-catalog.json`

這個 repo 不放 app source code、API key、token、analytics 或 server-side logic。

## 品牌資產與前端邊界

- `app-icon.png` 的唯一來源是 iOS App asset catalog 的 `MeetingPipelineIOS/Assets.xcassets/AppIcon.appiconset/AppIcon.png`，網站只把它用於 favicon 與平台圖示。
- `brand-icon.png` 的唯一來源是 iOS App asset catalog 的 `MeetingPipelineIOS/Assets.xcassets/BrandIcon.imageset/BrandIcon.png`，用於網站 header 品牌 lockup。
- 網站的獨立品牌 lockup 依 App HTML export 使用 Baskerville `Trace`，並在同一基線接上較小的 system sans、teal `Audio Notes & Insights`，視覺上不顯示冒號；教學、支援、隱私與模型內文仍使用短名 `Trace`。
- 同步品牌資產時，直接從 App asset catalog 複製，並用 `shasum -a 256` 比對網站檔與 App source；兩邊 SHA-256 必須完全相同才算同步完成。
- 不得依 PNG 自行描摹、重畫或產生替代 SVG。若未來取得正式 vector source，須另行驗收後才能取代。
- 網站維持原生靜態 HTML／CSS，不載入第三方 web font、第三方 JavaScript，也不加入手動 theme toggle；light／dark 只跟隨系統 `prefers-color-scheme`。

## Gemini API Key 教學頁

`/gemini-api-key/` 是給 Trace 使用者看的公開教學頁，說明如何在 Google AI Studio 建立 Gemini API key、免費額度與費率的來源限制、音訊 token 粗估方式，以及 Trace 會送到 Gemini 的資料。

教學頁使用 2026-07-15 重新拍攝的 Google AI Studio 當前介面。截圖只保留操作所需區域，帳號、完整或局部 key、專案 ID、付款資訊與實際用量數字均不入鏡；更新截圖時也必須維持這個安全裁切契約。

## English pages and Gemini errors

The English public pages live under `/en/`. The support error anchor is:

- Traditional Chinese: `/support/#gemini-errors`
- English: `/en/support/#gemini-errors`

The iOS app should link Gemini/API failures to the support anchor instead of embedding the full error-code table in the app UI.
