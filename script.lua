-- =========================================================
-- AOI HUB - FIXED PLACED EGG ESP (EXACT MATCH)
-- Host: github.com/apiapiapi3/aoi
-- =========================================================

local Workspace = game:GetService("Workspace")

-- 1. Hapus ESP lama
for _, v in pairs(Workspace:GetDescendants()) do
    if v.Name == "AoiPlacedESP" then
        v:Destroy()
    end
end

-- 2. Fungsi Pembaca Data Telur dari PlacedEggRenders
local function processEgg(eggModel)
    -- Pastikan punya Part fisik untuk nempel ESP
    local targetPart = eggModel:IsA("BasePart") and eggModel or eggModel:FindFirstChildWhichIsA("BasePart")
    if not targetPart or targetPart:FindFirstChild("AoiPlacedESP") then return end

    local eggName = eggModel.Name
    local rarity = "Common"
    local weight = "?"
    local value = "?"

    -- Baca Atribut dari Model Telur Fisik
    if eggModel:GetAttribute("Egg") then eggName = tostring(eggModel:GetAttribute("Egg")) end
    if eggModel:GetAttribute("Rarity") then rarity = tostring(eggModel:GetAttribute("Rarity")) end
    if eggModel:GetAttribute("Weight") then weight = tostring(eggModel:GetAttribute("Weight")) end
    if eggModel:GetAttribute("Value") then value = tostring(eggModel:GetAttribute("Value")) end

    -- Baca TextLabel di dalam model fisik jika ada
    for _, gui in pairs(eggModel:GetDescendants()) do
        if gui:IsA("TextLabel") and gui.Text ~= "" then
            local t = gui.Text
            local lt = t:lower()
            if lt:find("kg") then weight = t
            elseif t:find("%$") or lt:find("/s") then value = t
            elseif lt:find("common") or lt:find("rare") or lt:find("epic") or lt:find("legend") or lt:find("mythic") or lt:find("secret") then rarity = t
            end
        end
    end

    -- Buat BillboardGui Tepat di Atas Telur Fisik
    local bg = Instance.new("BillboardGui")
    bg.Name = "AoiPlacedESP"
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 180, 0, 55)
    bg.StudsOffset = Vector3.new(0, 2.5, 0)
    bg.Adornee = targetPart
    bg.Parent = targetPart

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255, 215, 0)
    txt.TextStrokeTransparency = 0
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.TextScaled = true
    txt.Font = Enum.Font.SourceSansBold
    txt.Text = "🥚 " .. eggName .. "\n✨ [" .. rarity .. "]\n⚖️ " .. weight .. " | 💰 " .. value
    txt.Parent = bg
end

-- 3. Scan Khusus Folder Fisik (PlacedEggRenders & AreaEggSlotsClient)
local function scanEggs()
    local targetFolders = {Workspace:FindFirstChild("PlacedEggRenders"), Workspace:FindFirstChild("AreaEggSlotsClient")}
    
    for _, folder in pairs(targetFolders) do
        if folder then
            for _, egg in pairs(folder:GetChildren()) do
                processEgg(egg)
            end
        end
    end
end

-- Eksekusi
pcall(scanEggs)
