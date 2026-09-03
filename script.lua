-- STEAL AN EGG - ULTIMATE ACCURATE FIX
-- Host: github.com/apiapiapi3/aoi

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local AutoSteal = false
local ESPActive = false

-- GUI SETUP
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("StealEggGuiFix2") then
    CoreGui.StealEggGuiFix2:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealEggGuiFix2"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 210, 0, 230)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "AOI HUB - STEAL AN EGG"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local function createButton(text, pos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. BUTTON AUTO STEAL
local btnSteal = createButton("Auto Steal: OFF", 40, Color3.fromRGB(180, 50, 50), function()
    AutoSteal = not AutoSteal
    btnSteal.Text = "Auto Steal: " .. (AutoSteal and "ON" or "OFF")
    btnSteal.BackgroundColor3 = AutoSteal and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
end)

-- 2. BUTTON ESP
local btnESP = createButton("ESP Egg: OFF", 85, Color3.fromRGB(180, 50, 50), function()
    ESPActive = not ESPActive
    btnESP.Text = "ESP Egg: " .. (ESPActive and "ON" or "OFF")
    btnESP.BackgroundColor3 = ESPActive and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    
    if not ESPActive then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:FindFirstChild("EggBillboard") then
                v.EggBillboard:Destroy()
            end
        end
    end
end)

-- 3. BUTTON SPEED
local btnSpeed = createButton("Speed (100): OFF", 130, Color3.fromRGB(180, 50, 50), function()
    _G.SpeedOn = not _G.SpeedOn
    btnSpeed.Text = "Speed (100): " .. (_G.SpeedOn and "ON" or "OFF")
    btnSpeed.BackgroundColor3 = _G.SpeedOn and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
end)

-- 4. BUTTON SERVER HOP
createButton("Cari Server Sepi (<8 orang)", 175, Color3.fromRGB(80, 80, 180), function()
    pcall(function()
        local PlaceId = game.PlaceId
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local body = HttpService:JSONDecode(req)
        
        for _, server in pairs(body.data) do
            if server.playing < 8 and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end)
end)

-- =========================================================
-- LOGIC
-- =========================================================

-- WalkSpeed Loop
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if _G.SpeedOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 100
            end
        end)
    end
end)

-- Fungsi Cek Apakah Prompt Adalah Telur
local function isEggPrompt(prompt)
    local actionText = (prompt.ActionText or ""):lower()
    local objectText = (prompt.ObjectText or ""):lower()
    local parentName = (prompt.Parent and prompt.Parent.Name or ""):lower()
    
    return actionText:find("mencuri") or actionText:find("steal") or objectText:find("telur") or objectText:find("egg") or parentName:find("egg")
end

-- Auto Steal (Filter khusus prompt telur)
task.spawn(function()
    while task.wait(0.1) do
        if AutoSteal then
            pcall(function()
                for _, prompt in pairs(Workspace:GetDescendants()) do
                    if not AutoSteal then break end
                    if prompt:IsA("ProximityPrompt") and isEggPrompt(prompt) then
                        local eggPart = prompt.Parent
                        local char = LocalPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        
                        if hrp and eggPart and eggPart:IsA("BasePart") then
                            prompt.HoldDuration = 0
                            
                            local savedCFrame = hrp.CFrame
                            
                            -- TP persis di atas telur
                            hrp.CFrame = eggPart.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.05)
                            
                            fireproximityprompt(prompt)
                            task.wait(0.1)
                            
                            -- TP Balik
                            hrp.CFrame = savedCFrame
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end
end)

-- ESP Egg (Mencari Data Asli Model Telur)
task.spawn(function()
    while task.wait(1) do
        if ESPActive then
            pcall(function()
                for _, prompt in pairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and isEggPrompt(prompt) then
                        local eggPart = prompt.Parent
                        
                        -- Cari model paling atas yang menampung telur ini
                        local eggModel = eggPart
                        if eggPart.Parent and eggPart.Parent ~= Workspace then
                            eggModel = eggPart.Parent
                        end

                        if not eggPart:FindFirstChild("EggBillboard") then
                            
                            -- Ambil nama tampilan asli dari ProximityPrompt
                            local displayName = (prompt.ObjectText ~= "" and prompt.ObjectText) or eggModel.Name
                            
                            -- Pembacaan Kg & Value
                            local kg = eggModel:GetAttribute("Weight") or eggModel:GetAttribute("Kg") or prompt:GetAttribute("Weight") or "?"
                            local val = eggModel:GetAttribute("Value") or eggModel:GetAttribute("Price") or prompt:GetAttribute("Value") or "?"
                            
                            if eggModel:FindFirstChild("Weight") then kg = eggModel.Weight.Value end
                            if eggModel:FindFirstChild("Value") then val = eggModel.Value.Value end

                            local bg = Instance.new("BillboardGui")
                            bg.Name = "EggBillboard"
                            bg.AlwaysOnTop = true
                            bg.Size = UDim2.new(0, 160, 0, 45)
                            bg.StudsOffset = Vector3.new(0, 3, 0)
                            bg.Adornee = eggPart
                            bg.Parent = eggPart

                            local txt = Instance.new("TextLabel")
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.TextColor3 = Color3.fromRGB(255, 215, 0)
                            txt.TextStrokeTransparency = 0
                            txt.TextScaled = true
                            txt.Text = "🥚 " .. tostring(displayName) .. "\n⚖️ " .. tostring(kg) .. " Kg | 💰 $" .. tostring(val)
                            txt.Parent = bg
                        end
                    end
                end
            end)
        end
    end
end)
