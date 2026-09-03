-- =========================================================
-- STEAL AN EGG SCRIPT - 100% KEYLESS & OPEN SOURCE
-- Hosted on: github.com/apiapiapi3/aoi
-- =========================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Steal an Egg | Keyless Menu",
   LoadingTitle = "Memuat Script...",
   LoadingSubtitle = "by apiapiapi3",
   ConfigurationSaving = { Enabled = false }
})

-- TAB MENU
local TabMain = Window:CreateTab("Auto Steal & ESP", 4483362458)
local TabMisc = Window:CreateTab("Misc / Server", 4483362458)

-- VARIABLES
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SelectedTier = "Semua Tier"
local AutoStealActive = false
local ESPActive = false

-- =========================================================
-- TAB 1: AUTO STEAL & ESP
-- =========================================================

TabMain:CreateDropdown({
   Name = "Pilih Prioritas Tier Telur",
   Options = {"Semua Tier", "Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary"},
   CurrentOption = "Semua Tier",
   Flag = "TierSelect",
   Callback = function(Option)
      SelectedTier = Option[1]
   end,
})

TabMain:CreateToggle({
   Name = "Nyalakan ESP Telur",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      ESPActive = Value
   end,
})

TabMain:CreateToggle({
   Name = "Auto Steal / Teleport ke Telur",
   CurrentValue = false,
   Flag = "StealToggle",
   Callback = function(Value)
      AutoStealActive = Value
   end,
})

-- =========================================================
-- TAB 2: MISC & SERVER HOP
-- =========================================================

TabMisc:CreateButton({
   Name = "Cari Server Sepi (Server Hop)",
   Callback = function()
      local HttpService = game:GetService("HttpService")
      local TeleportService = game:GetService("TeleportService")
      local PlaceId = game.PlaceId
      local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
      
      for _, server in pairs(Servers) do
         if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
            break
         end
      end
   end,
})

TabMisc:CreateSlider({
   Name = "Kecepatan Jalan (WalkSpeed)",
   Range = {16, 120},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- =========================================================
-- LOGIC FUNCTIONS
-- =========================================================

-- Logic ESP Telur
task.spawn(function()
    while task.wait(1) do
        if ESPActive then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name:lower():find("egg") or v.Name:lower():find("telur") then
                    if SelectedTier == "Semua Tier" or v.Name:find(SelectedTier) then
                        if not v:FindFirstChild("EggHighlight") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "EggHighlight"
                            hl.FillColor = Color3.fromRGB(255, 215, 0)
                            hl.Adornee = v
                            hl.Parent = v
                        end
                    end
                end
            end
        end
    end
end)

-- Logic Auto Steal
task.spawn(function()
    while task.wait(0.3) do
        if AutoStealActive then
            for _, v in pairs(Workspace:GetDescendants()) do
                if (v.Name:lower():find("egg") or v.Name:lower():find("telur")) and v:IsA("BasePart") then
                    if SelectedTier == "Semua Tier" or v.Name:find(SelectedTier) then
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = v.CFrame
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end
end)
