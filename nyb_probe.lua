--[[ NYB HUB — PROBE ON SCREEN
     Load hub yg udah di-fix + di-instrument, tunggu, terus taruh HASILNYA di layar.
     Gak perlu baca log. Screenshot panelnya, kirim ke chat. ]]

local RAW = "https://raw.githubusercontent.com/xnotyours/nyb-hub/main/nyb_hub_dbg2.lua"

local ok, err = pcall(function()
	loadstring(game:HttpGet(RAW))()
end)

local NYB = (getgenv and getgenv().NYB_HUB_DEBUG) or nil

local function guiParent()
	if gethui then local p = gethui() if p then return p end end
	local lp = game:GetService("Players").LocalPlayer
	return lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui")
end

local function line(k, v) return string.format("%-16s %s", k, tostring(v)) end
local L = {}
local function T(s) L[#L + 1] = tostring(s) end

T("===== NYB HUB PROBE =====")
T(line("load hub", ok and "OK" or ("GAGAL: " .. tostring(err))))
if not NYB then
	T("")
	T("NYB_HUB_DEBUG = NIL -> script gak selesai load.")
	T("(chunk error sebelum baris terakhir)")
	if not ok then T("load error: " .. tostring(err)) end
else
	local function cnt(t) local n = 0 for _ in pairs(t or {}) do n = n + 1 end return n end
	T(line("alive", NYB.alive))
	T(line("conns bind", #(NYB.conns or {})))
	T(line("toggle reg", cnt(NYB.ui and NYB.ui.reg)))
	T(line("section", #(NYB.SECLOG or {})))
	T("")
	T("-- ERROR yg ditelan pcall --")
	local any = false
	for n, e in pairs(NYB.DBG_ERR or {}) do any = true T("  " .. n .. ": " .. tostring(e)) end
	if not any then T("  (kosong -- main loop gak error)") end
	T("")
	T("-- hasil scan map --")
	local c = NYB.cache or {}
	T(line("gens", #(c.gens or {})))
	T(line("hooks", #(c.hooks or {})))
	T(line("pallets", #(c.pallets or {})))
	T(line("windows", #(c.windows or {})))
	T(line("gates", #(c.gates or {})))
	T("")
	T("-- PEMBEDA: loop vs toggle --")
	local function pool() return cnt((NYB.esp or {}).pool) end
	local b4 = pool()
	NYB.setCfg("EspPlayers", true)
	T(line("CFG.EspPlayers", CFG and tostring(CFG.EspPlayers) or "?"))
	task.wait(3)
	local af = pool()
	T(line("objek ESP", b4 .. " -> " .. af))
	T("")
	T(af > 0 and ">>> LOOP OK. Yang putus: wiring toggle."
	            or ">>> LOOP/espFrame RUSAK (bukan toggle).")
end
T("=========================")

local txt = table.concat(L, "\n")
print(txt)
if setclipboard then pcall(setclipboard, txt) end

-- panel di layar
local sg = Instance.new("ScreenGui")
sg.Name = "NYB_PROBE"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 9999
pcall(function() sg.Parent = guiParent() end)

local f = Instance.new("Frame")
f.Size = UDim2.new(1, -20, 0, 430)
f.Position = UDim2.new(0, 10, 0, 80)
f.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
f.BackgroundTransparency = 0.08
f.BorderSizePixel = 0
f.Parent = sg
local uc = Instance.new("UICorner") uc.CornerRadius = UDim.new(0, 10) uc.Parent = f
local us = Instance.new("UIStroke") us.Color = Color3.fromRGB(0, 210, 190) us.Thickness = 2 us.Parent = f

local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(1, -16, 1, -40)
lbl.Position = UDim2.new(0, 8, 0, 6)
lbl.BackgroundTransparency = 1
lbl.Text = txt
lbl.TextColor3 = Color3.fromRGB(230, 235, 240)
lbl.TextSize = 15
lbl.Font = Enum.Font.Code
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.TextYAlignment = Enum.TextYAlignment.Top
lbl.TextWrapped = true
lbl.Parent = f

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -16, 0, 28)
btn.Position = UDim2.new(0, 8, 1, -34)
btn.BackgroundColor3 = Color3.fromRGB(0, 210, 190)
btn.Text = "TUTUP (hasil udah di clipboard)"
btn.TextColor3 = Color3.fromRGB(10, 12, 16)
btn.TextSize = 14
btn.Font = Enum.Font.GothamBold
btn.Parent = f
local uc2 = Instance.new("UICorner") uc2.CornerRadius = UDim.new(0, 6) uc2.Parent = btn
btn.MouseButton1Click:Connect(function() sg:Destroy() end)

warn("[PROBE] panel muncul di layar. Screenshot, kirim ke chat.")
