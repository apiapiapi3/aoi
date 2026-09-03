-- Simple GUI Auto Steal & ESP (apiapiapi3/aoi)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Steal an Egg - Minimal", "DarkTheme")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- TAB UTAMA
local Main = Window:NewTab("Main")
local Section = Main:NewSection("Features")

-- 1. TOGGLE AUTO STEAL & AUTO TP BALIK
Section:NewToggle("Auto Steal (No Cooldown + TP Back)", "Ambil instan lalu TP balik", function(state)
    getgenv().AutoSteal = state
    while getgenv().AutoSteal do
        task.wait(0.05)
        pcall(function()
            for _, prompt in pairs(Workspace:GetDescendants()) do
                if not getgenv().AutoSteal then break end
                if prompt:IsA("ProximityPrompt") and prompt.Parent and prompt.Parent.Name:lower():find("egg") then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if hrp then
                        local distance = (hrp.Position - prompt.Parent.Position).Magnitude
                        if distance <= prompt.MaxActivationDistance + 5 then
                            prompt.HoldDuration = 0 -- Hapus cooldown hold
                            local oldCFrame = hrp.CFrame -- Simpan posisi awal
                            
                            fireproximityprompt(prompt)
                            task.wait(0.05)
                            
                            hrp.CFrame = oldCFrame -- TP balik instan
                        end
                    end
                end
            end
        end)
    end
end)

-- 2. TOGGLE ESP (KG & DUIT)
Section:NewToggle("ESP Egg (Kg & Value)", "Tampilkan info Kg dan Duit", function(state)
    getgenv().ESPActive = state
    if not state then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:FindFirstChild("EggBillboard") then
                v.EggBillboard:Destroy()
            end
        end
    else
        task.spawn(function()
            while getgenv().ESPActive do
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Parent and v.Parent.Name:lower():find("egg") then
                        local eggModel = v.Parent
                        if not eggModel:FindFirstChild("EggBillboard") then
                            local weight = eggModel:FindFirstChild("Weight") or eggModel:GetAttribute("Weight") or "?"
                            local value = eggModel:FindFirstChild("Value") or eggModel:GetAttribute("Value") or "?"
                            
                            if typeof(weight) == "Instance" then weight = weight.Value end
                            if typeof(value) == "Instance" then value = value.Value end

                            local bg = Instance.new("BillboardGui")
                            bg.Name = "EggBillboard"
                            bg.AlwaysOnTop = true
                            bg.Size = UDim2.new(0, 150, 0, 50)
                            bg.StudsOffset = Vector3.new(0, 3, 0)
                            bg.Adornee = eggModel
                            bg.Parent = eggModel

                            local txt = Instance.new("TextLabel")
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.TextColor3 = Color3.fromRGB(255, 215, 0)
                            txt.TextStrokeTransparency = 0
                            txt.TextScaled = true
                            txt.Text = "🥚 " .. eggModel.Name .. "\n⚖️ " .. tostring(weight) .. " Kg | 💰 $" .. tostring(value)
                            txt.Parent = bg
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

-- 3. SLIDER SPEED KENCANG
Section:NewSlider("WalkSpeed", "Atur Kecepatan Jalan", 200, 16, function(s)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = s
    end
end)

-- 4. BUTTON SERVER HOP
Section:NewButton("Server Hop (Server Sepi)", "Pindah ke server sepi", function()
    local PlaceId = game.PlaceId
    local Servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    for _, server in pairs(Servers) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
            break
        end
    end
end)
