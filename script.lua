-- =========================================================
-- AOI HUB - ULTRA ACCURATE ESP (STEAL AN EGG)
-- Host: github.com/apiapiapi3/aoi
-- =========================================================

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hapus ESP lama
for _, v in pairs(Workspace:GetDescendants()) do
    if v:FindFirstChild("AoiUltraESP") then
        v.AoiUltraESP:Destroy()
    end
end

-- Fungsi Pemindai Data Super Teliti
local function getDetailedEggData(eggPart)
    local eggName = "Telur"
    local petName = "?"
    local rarity = "Common"
    local weight = "?"
    local value = "?"

    -- Target pencarian: Model Telur (Parent dari Part / Part itu sendiri)
    local targets = {eggPart, eggPart.Parent, (eggPart.Parent and eggPart.Parent.Parent)}

    for _, obj in pairs(targets) do
        if obj then
            -- 1. Pindai Atribut internal Roblox
            if obj:GetAttribute("Egg") then eggName = tostring(obj:GetAttribute("Egg")) end
            if obj:GetAttribute("Pet") then petName = tostring(obj:GetAttribute("Pet")) end
            if obj:GetAttribute("Rarity") then rarity = tostring(obj:GetAttribute("Rarity")) end
            if obj:GetAttribute("Weight") then weight = tostring(obj:GetAttribute("Weight")) end
            if obj:GetAttribute("Value") then value = tostring(obj:GetAttribute("Value")) end
            if obj:GetAttribute("Money") then value = tostring(obj:GetAttribute("Money")) end

            -- 2. Pindai Value Instance (StringValue / NumberValue / IntValue)
            for _, child in pairs(obj:GetChildren()) do
                local cName = child.Name:lower()
                if child:IsA("ValueBase") then
                    if cName:find("egg") or cName:find("nama") then eggName = tostring(child.Value) end
                    if cName:find("pet") then petName = tostring(child.Value) end
                    if cName:find("rarity") or cName:find("kelangkaan") then rarity = tostring(child.Value) end
                    if cName:find("weight") or cName:find("kg") or cName:find("berat") then weight = tostring(child.Value) end
                    if cName:find("val") or cName:find("price") or cName:find("money") or cName:find("duit") then value = tostring(child.Value) end
                end
            end

            -- 3. Pindai TextLabel bawaan UI game di dalam model
            for _, guiElement in pairs(obj:GetDescendants()) do
                if guiElement:IsA("TextLabel") and guiElement.Text ~= "" then
                    local txt = guiElement.Text
                    local lowerTxt = txt:lower()

                    if lowerTxt:find("egg:") or lowerTxt:find("telur:") then
                        eggName = txt:gsub("Egg:", ""):gsub("Telur:", ""):match("^%s*(.-)%s*$")
                    elseif lowerTxt:find("pet:") then
                        petName = txt:gsub("Pet:", ""):match("^%s*(.-)%s*$")
                    elseif lowerTxt:find("rarity:") then
                        rarity = txt:gsub("Rarity:", ""):match("^%s*(.-)%s*$")
                    elseif lowerTxt:find("kg") and weight == "?" then
                        weight = txt
                    elseif (txt:find("%$") or lowerTxt:find("/s")) and value == "?" then
                        value = txt
                    end
                end
            end
        end
    end

    return eggName, petName, rarity, weight, value
end

local function scanAndCreateESP()
    for _, prompt in pairs(Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local actionText = (prompt.ActionText or ""):lower()
            local objectText = (prompt.ObjectText or ""):lower()
            
            -- Filter prompt interaksi telur (Bilingual)
            if actionText:find("mencuri") or actionText:find("steal") or objectText:find("telur") or objectText:find("egg") then
                local eggPart = prompt.Parent
                
                if eggPart and eggPart:IsA("BasePart") and not eggPart:FindFirstChild("AoiUltraESP") then
                    
                    local eName, pName, rText, wText, vText = getDetailedEggData(eggPart)

                    -- Warna Rarity Dinamis
                    local rarityColor = Color3.fromRGB(255, 255, 255) -- Default Putih
                    local rLower = rText:lower()
                    if rLower:find("rare") or rLower:find("langka") then rarityColor = Color3.fromRGB(80, 170, 255)
                    elseif rLower:find("epic") then rarityColor = Color3.fromRGB(170, 80, 255)
                    elseif rLower:find("legend") then rarityColor = Color3.fromRGB(255, 170, 0)
                    elseif rLower:find("mythic") then rarityColor = Color3.fromRGB(255, 50, 100)
                    elseif rLower:find("secret") or rLower:find("divine") then rarityColor = Color3.fromRGB(255, 215, 0)
                    end

                    -- Buat BillboardGui ESP
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "AoiUltraESP"
                    bg.AlwaysOnTop = true
                    bg.Size = UDim2.new(0, 200, 0, 70)
                    bg.StudsOffset = Vector3.new(0, 3, 0)
                    bg.Adornee = eggPart
                    bg.Parent = eggPart

                    local txt = Instance.new("TextLabel")
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = rarityColor
                    txt.TextStrokeTransparency = 0
                    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    txt.TextScaled = true
                    txt.Font = Enum.Font.SourceSansBold
                    
                    -- Tampilan Rapi 3 Baris
                    txt.Text = "Egg: " .. eName .. "\nPet: " .. pName .. " | Rarity: " .. rText .. "\n⚖️ " .. wText .. " | 💰 " .. vText
                    txt.Parent = bg
                end
            end
        end
    end
end

-- Refresh berkala tiap 0.8 detik
task.spawn(function()
    while task.wait(0.8) do
        pcall(scanAndCreateESP)
    end
end)
