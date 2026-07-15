# Gemini API Key guide assets

這個資料夾保存 `/gemini-api-key/` 教學頁共用的 Google AI Studio 當前介面截圖。現行三張資產於 2026-07-15 重拍，並以安全裁切排除私人資料。

截圖隱私規則：

- 不得露出完整 Gemini API key、Google 帳號 email、專案識別資訊或付款資訊。
- 如果畫面上有 key、帳號、專案或付款相關欄位，優先以裁切讓資料完全不入鏡；不得以可還原的模糊或半透明覆蓋取代。
- 檔名與 alt text 只能描述步驟，不要包含任何真實識別資訊。
- 截圖應只呈現 Google AI Studio 建 key 所需的通用 UI，不要呈現私人專案資料。

現行安全資產：

- `01-ai-studio-api-keys-redacted.png`：1280×210，API Keys 通用控制與欄位標題。
- `02-create-key-redacted.png`：560×204，建立 key 名稱欄位與專案選擇提示，不含實際專案。
- `03-active-limits-redacted.png`：1280×128，模型限制欄位標題，不含專案、帳務與實際用量。

`scripts/check-site-content.sh` 會驗證 PNG magic bytes 與這三張已通過隱私檢查的 SHA-256；更新資產時必須重新做人工隱私 review，再同步 checksum。
