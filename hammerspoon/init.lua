-------------------------------------------------
-- init.lua  ·  Hammerspoon 翻譯＋潤稿巨集（F19）
-- ------------------------------------------------
-- 1. 反白文字 → F19 → 自動複製、呼叫 OpenAI
--    完成後潤稿＋中英互譯並貼回原處，
--    同時在通知中心顯示成功／失敗訊息。
-- 2. 需要：
--    • Hammerspoon 0.9x 以上
--    • 啟用 Hammerspoon 通知
--    • macOS Monterey 12+（建議 Sequoia 15.5）
--    • 金鑰已存入 Keychain： security add-generic-password -a "$USER" -s openai_api_key -w 'sk-...'
-- -------------------------------------------------

-------------------------------------------------
-- 全域設定
-------------------------------------------------
local hotkey  = {}          -- 無修飾鍵（直接 F19）
local key     = "F19"       -- 觸發鍵
local model   = "gpt-4o-mini"     -- OpenAI 模型
local timeout = 0.3               -- 複製剪貼簿等待 (秒)

-------------------------------------------------
-- 取出 OpenAI API Key（優先 Keychain，其次環境變數）
-------------------------------------------------
local apiKey = hs.execute([[security find-generic-password -s openai_api_key -w]]):gsub("%s+$","")
if apiKey == "" then apiKey = os.getenv("OPENAI_API_KEY") or "" end
if apiKey == "" then
  hs.notify.new({
    title           = "OpenAI 金鑰未設定 ❌",
    informativeText = "請將 openai_api_key 存入鑰匙圈或匯出環境變數",
    withdrawAfter   = 8
  }):send()
  return
end

-------------------------------------------------
-- 指令提示詞（可自行調整語氣或策略）
-------------------------------------------------
local systemPrompt = table.concat({
  "You are a professional translator and copy‑editor.",
  "Detect language; if the source is Chinese translate to English, if the source is English translate to Traditional Chinese.",
  "When translating to Chinese, always output in Traditional Chinese characters (繁體中文).",
  "Keep meaning, polish wording, fix typos. Do not add or omit content."
}, " ")

-------------------------------------------------
-- 主流程函式
-------------------------------------------------
local function translateAndReplace()
  -------------------------------------------------
  -- 1) 複製選取文字
  -------------------------------------------------
  hs.eventtap.keyStroke({"cmd"}, "c")
  hs.timer.usleep(timeout * 1e6)
  local src = hs.pasteboard.getContents()
  if not src or src == "" then
    hs.notify.new({title="未選取文字 ⚠️", informativeText="請先選取要翻譯的文字", withdrawAfter=4}):send()
    return
  end

  -------------------------------------------------
  -- 2) 組 JSON Payload
  -------------------------------------------------
  local payload = hs.json.encode({
    model = model,
    temperature = 0.2,
    messages = {
      {role = "system", content = systemPrompt},
      {role = "user",   content = src}
    }
  })

  -------------------------------------------------
  -- 3) 呼叫 OpenAI (非同步)
  -------------------------------------------------
  hs.http.asyncPost(
    "https://api.openai.com/v1/chat/completions",
    payload,
    {
      ["Content-Type"]  = "application/json",
      ["Authorization"] = "Bearer " .. apiKey
    },
    function(status, body, _)
      -------------------------------------------------
      -- A. HTTP 層回應檢查
      -------------------------------------------------
      if status ~= 200 then
        local msg = "HTTP " .. tostring(status)
        local ok, errObj = pcall(hs.json.decode, body or "")
        if ok and errObj and errObj.error and errObj.error.message then
          msg = msg .. " – " .. errObj.error.message
        elseif body and #body > 0 then
          msg = msg .. " – " .. body:sub(1,120)
        end
        hs.notify.new({
          title           = "翻譯失敗 ❌",
          informativeText = msg,
          withdrawAfter   = 8
        }):send()
        return
      end

      -------------------------------------------------
      -- B. JSON 解析
      -------------------------------------------------
      local ok, resp = pcall(hs.json.decode, body)
      if not ok or not resp or not resp.choices then
        hs.notify.new({
          title           = "翻譯失敗 ⚠️",
          informativeText = "解析回應失敗，請檢查 JSON 格式",
          withdrawAfter   = 8
        }):send()
        return
      end

      local out = resp.choices[1].message.content or ""
      if out == "" then
        hs.notify.new({title="翻譯失敗 ⚠️", informativeText="API 回傳空白", withdrawAfter=6}):send()
        return
      end

      -------------------------------------------------
      -- 4) 成功：寫剪貼簿、覆蓋前後文
      -------------------------------------------------
      hs.pasteboard.setContents(out)
      hs.eventtap.keyStroke({"cmd"}, "v")
      hs.notify.new({
        title           = "翻譯完成 ✅",
        informativeText = out:sub(1, 90),
        withdrawAfter   = 5
      }):send()
    end
  )
end

-------------------------------------------------
-- 綁定熱鍵 & 其他初始化
-------------------------------------------------
hs.hotkey.bind(hotkey, key, translateAndReplace)

-- 載入 IPC 模組並安裝 CLI (一次性)
require("hs.ipc")
hs.ipc.cliInstall()

hs.notify.new({
  title           = "Hammerspoon 已載入",
  informativeText = "F19 = 翻譯＆潤稿",
  withdrawAfter   = 4
}):send()
