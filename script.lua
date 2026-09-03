-- ======================================================
-- SERVER HOP CIAOHUB - KEYLESS VERSION (TANPA KEY)
-- ======================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- Bikin ScreenGui UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CiaoHUB_ServerHOP_Keyless"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
	syn.protect_gui(ScreenGui)
	ScreenGui.Parent = game.CoreGui
elseif gethui then
	ScreenGui.Parent = gethui()
else
	ScreenGui.Parent = game.CoreGui
end

-- Tampilan Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -145, 0.5, -110)
MainFrame.Size = UDim2.new(0, 290, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(80, 80, 200)
Stroke.Thickness = 1.5

-- Judul UI
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.Text = "CiaoHUB ServerHop (Keyless)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

-- Tombol Close (Silang)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -28, 0, 6)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.TextSize = 13
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Info Jumlah Player Real-time
local NowLabel = Instance.new("TextLabel", MainFrame)
NowLabel.Position = UDim2.new(0, 10, 0, 44)
NowLabel.Size = UDim2.new(1, -20, 0, 22)
NowLabel.BackgroundTransparency = 1
NowLabel.Font = Enum.Font.GothamBold
NowLabel.TextXAlignment = Enum.TextXAlignment.Left
NowLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
NowLabel.TextSize = 13

-- Label Status Hop
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Position = UDim2.new(0, 10, 0, 70)
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true

-- Input Max Player
local MaxLabel = Instance.new("TextLabel", MainFrame)
MaxLabel.Position = UDim2.new(0, 10, 0, 105)
MaxLabel.Size = UDim2.new(1, -20, 0, 18)
MaxLabel.BackgroundTransparency = 1
MaxLabel.Font = Enum.Font.Gotham
MaxLabel.TextXAlignment = Enum.TextXAlignment.Left
MaxLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
MaxLabel.TextSize = 11
MaxLabel.Text = "Hop jika player di server LEBIH dari:"

local MaxBox = Instance.new("TextBox", MainFrame)
MaxBox.Position = UDim2.new(0, 10, 0, 126)
MaxBox.Size = UDim2.new(1, -20, 0, 28)
MaxBox.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
MaxBox.BorderSizePixel = 0
MaxBox.Font = Enum.Font.GothamBold
MaxBox.Text = "1"
MaxBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MaxBox.TextSize = 14
MaxBox.ClearTextOnFocus = false
Instance.new("UICorner", MaxBox).CornerRadius = UDim.new(0, 6)

-- Tombol Hop Sekali
local HopBtn = Instance.new("TextButton", MainFrame)
HopBtn.Position = UDim2.new(0, 10, 0, 162)
HopBtn.Size = UDim2.new(0, 125, 0, 45)
HopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
HopBtn.BorderSizePixel = 0
HopBtn.Font = Enum.Font.GothamBold
HopBtn.Text = "Hop Sekali"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 13
Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 6)

-- Tombol Auto Hop
local AutoBtn = Instance.new("TextButton", MainFrame)
AutoBtn.Position = UDim2.new(0, 145, 0, 162)AutoBtn.Size = UDim2.new(0, 135, 0, 45)
AutoBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 70)
AutoBtn.BorderSizePixel = 0
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.Text = "Auto Hop: OFF"
AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBtn.TextSize = 13
Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0, 6)

-- ==============================
-- LOGIKA / LOGIC (KEYLESS)
-- ==============================
local autoEnabled = false
local autoThread = nil

-- Loop realtime info player
task.spawn(function()
	while ScreenGui.Parent do
		local count = #Players:GetPlayers()
		NowLabel.Text = "Player di server ini sekarang: " .. count
		task.wait(1)
	end
end)

local function getRandomServer()
	local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
	local ok, raw = pcall(function() return game:HttpGet(url) end)
	if not ok or not raw or raw == "" then return nil end
	local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
	if not ok2 or not data or not data.data or #data.data == 0 then return nil end
	
	local currentId = tostring(game.JobId)
	local candidates = {}
	for _, s in ipairs(data.data) do
		if s.id and tostring(s.id) ~= currentId then
			table.insert(candidates, tostring(s.id))
		end
	end
	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

local function hopOnce()
	local threshold = math.max(1, math.floor(tonumber(MaxBox.Text) or 1))
	local currentCount = #Players:GetPlayers()
	
	if currentCount <= threshold then
		StatusLabel.Text = "✓ Server ini " .. currentCount .. " player. Tidak perlu hop."
		StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
		return false
	end
	
	StatusLabel.Text = "Server ini " .. currentCount .. " player. Mencari server lain..."
	StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
	task.wait(0.5)
	
	local serverId = getRandomServer()
	if not serverId then
		StatusLabel.Text = "Gagal mengambil list server!"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
		return false
	end
	
	StatusLabel.Text = "Teleport ke server lain..."
	StatusLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
	task.wait(0.5)
	
	pcall(function()
		TeleportService:TeleportToPlaceInstance(PlaceId, serverId, LocalPlayer)
	end)
	return true
end

-- Event Klik Tombol
HopBtn.MouseButton1Click:Connect(function()
	HopBtn.Active = false
	hopOnce()
	task.wait(2)
	HopBtn.Active = true
end)

AutoBtn.MouseButton1Click:Connect(function()
	autoEnabled = not autoEnabled
	if autoEnabled then
		AutoBtn.Text = "Auto Hop: ON"
		AutoBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		autoThread = task.spawn(function()
			while autoEnabled and ScreenGui.Parent do
				local threshold = math.max(1, math.floor(tonumber(MaxBox.Text) or 1))
				local count = #Players:GetPlayers()
				if count <= threshold then
					StatusLabel.Text = "✓ " .. count .. " player di sini. Menunggu..."
					StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
					task.wait(3)
				else
					hopOnce()
					task.wait(5)
				end
			end
		end)
	else
		AutoBtn.Text = "Auto Hop: OFF"
		AutoBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 70)
		if autoThread then
			task.cancel(autoThread)
			autoThread = nil
		end
		StatusLabel.Text = "Auto Hop dihentikan."
		StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	end
end)

StatusLabel.Text = "Siap! Langsung klik Hop tanpa Key."
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
