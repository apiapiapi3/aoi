-- =========================================================
-- AOI HUB - PERFECT ESP EGG (Nama, Rarity, Kg, Uang)
-- Host: github.com/apiapiapi3/aoi
-- =========================================================

local Workspace = game:GetService("Workspace")

-- Hapus ESP lama jika ada
for _, v in pairs(Workspace:GetDescendants()) do
    if v:FindFirstChild("AoiEggESP") then
        v.AoiEggESP:Destroy()
    end
end

local function scanAndCreateESP()
    for _, prompt in pairs(Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local actionText = (prompt.ActionText or ""):lower()
            local objectText = (prompt.ObjectText or ""):lower()
            
            -- Filter tombol interaksi telur (Indo & Inggris)
            if actionText:find("mencuri") or actionText:find("steal") or objectText:find("telur") or objectText:find("egg") then
                local eggPart = prompt.Parent
                
                if eggPart and eggPart:IsA("BasePart") and not eggPart:FindFirstChild("AoiEggESP") then
                    
                    local eggName = prompt.ObjectText ~= "" and prompt.ObjectText or "Telur"
                    local rarityText = "Biasa"
                    local kgText = "? Kg"
                    local valText = "$?"

                    -- Pindai seluruh isi model/folder tempat telur ini berada
                    local parentModel = eggPart.Parent
                    if parentModel then
                        
                        -- 1. Cek dari atribut internal
                        if parentModel:GetAttribute("Rarity") then rarityText = tostring(parentModel:GetAttribute("Rarity")) end
                        if parentModel:GetAttribute("Weight") then kgText = tostring(parentModel:GetAttribute("Weight")) .. " Kg" end
                        if parentModel:GetAttribute("Value") then valText = "$" .. tostring(parentModel:GetAttribute("Value")) end

                        -- 2. Pindai TextLabel dari UI bawaan game di sekitar telur
                        for _, guiElement in pairs(parentModel:GetDescendants()) do
                            if guiElement:IsA("TextLabel") and guiElement.Text ~= "" then
                                local text = guiElement.Text
                                local lowerText = text:lower()

                                -- Cari Label Kg
                                if lowerText:find("kg") then
                                    kgText = text
                                -- Cari Label Uang ($)
                                elseif text:find("%$") or lowerText:find("k") or lowerText:find("m") or lowerText:find("b") or lowerText:find("t") then
                                    if not lowerText:find("kg") then
                                        valText = text
                                    end
                                -- Cari Label Rarity
                                elseif lowerText:find("common") or lowerText:find("rare") or lowerText:find("epic") or lowerText:find("legendary") or lowerText:find("mythic") or lowerText:find("secret") or lowerText:find("divine") or lowerText:find("rahasia") then
                                    rarityText = text
                                end
                            end
                        end
                    end

                    -- Buat BillboardGui melayang di atas telur
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "AoiEggESP"
                    bg.AlwaysOnTop = true
                    bg.Size = UDim2.new(0, 180, 0, 60)
                    bg.StudsOffset = Vector3.new(0, 3.5, 0)
                    bg.Adornee = eggPart
                    bg.Parent = eggPart

                    local txt = Instance.new("TextLabel")
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(255, 215, 0) -- Warna Emas
                    txt.TextStrokeTransparency = 0
                    txt.TextScaled = true
                    txt.Font = Enum.Font.SourceSansBold
                    txt.Text = "🥚 " .. tostring(eggName) .. "\n✨ [" .. tostring(rarityText) .. "]\n⚖️ " .. tostring(kgText) .. " | 💰 " .. tostring(valText)
                    txt.Parent = bg
                end
            end
        end
    end
end

-- Loop scan otomatis setiap detik
task.spawn(function()
    while task.wait(1) do
        pcall(scanAndCreateESP)
    end
end)
