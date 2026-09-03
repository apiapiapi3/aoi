-- =========================================================
-- AOI HUB - FINAL ABSOLUTE ESP (STEAL AN EGG)
-- Host: github.com/apiapiapi3/aoi
-- =========================================================

local Workspace = game:GetService("Workspace")

-- 1. Hapus semua ESP lama agar bersih total
for _, v in pairs(Workspace:GetDescendants()) do
    if v.Name == "AoiAbsoluteESP" then
        v:Destroy()
    end
end

-- 2. Fungsi ESP Pintar & Teliti Per Telur
local function applyESP(prompt)
    local eggPart = prompt.Parent
    if not eggPart or not eggPart:IsA("BasePart") or eggPart:FindFirstChild("AoiAbsoluteESP") then 
        return 
    end

    -- Ambil Nama Telur Langsung dari Prompt Game
    local eggName = prompt.ObjectText ~= "" and prompt.ObjectText or "Telur"
    local rawTexts = {}

    -- Ambil SEMUA teks unik yang ada di dalam model telur ini
    local parentModel = eggPart.Parent or eggPart
    for _, desc in pairs(parentModel:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text ~= "" and desc.Text ~= prompt.ActionText and desc.Text ~= prompt.ObjectText then
            -- Hindari teks duplikat
            if not table.find(rawTexts, desc.Text) then
                table.insert(rawTexts, desc.Text)
            end
        end
    end

    -- Format Tampilan
    local finalString = "🥚 " .. eggName
    if #rawTexts > 0 then
        finalString = finalString .. "\n" .. table.concat(rawTexts, " | ")
    else
        -- Jika tidak ada TextLabel bawaan, ambil atribut jika ada
        local attrInfo = {}
        for attrName, attrValue in pairs(parentModel:GetAttributes()) do
            table.insert(attrInfo, tostring(attrName) .. ": " .. tostring(attrValue))
        end
        if #attrInfo > 0 then
            finalString = finalString .. "\n" .. table.concat(attrInfo, " | ")
        end
    end

    -- Buat UI Billboard ESP Tunggal
    local bg = Instance.new("BillboardGui")
    bg.Name = "AoiAbsoluteESP"
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 220, 0, 50)
    bg.StudsOffset = Vector3.new(0, 2.5, 0)
    bg.Adornee = eggPart
    bg.Parent = eggPart

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255, 215, 0) -- Warna Emas
    txt.TextStrokeTransparency = 0
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.TextScaled = true
    txt.Font = Enum.Font.SourceSansBold
    txt.Text = finalString
    txt.Parent = bg
end

-- 3. Eksekusi Sekali ke Semua Telur
for _, prompt in pairs(Workspace:GetDescendants()) do
    if prompt:IsA("ProximityPrompt") then
        local act = (prompt.ActionText or ""):lower()
        local obj = (prompt.ObjectText or ""):lower()
        
        if act:find("mencuri") or act:find("steal") or obj:find("telur") or obj:find("egg") then
            applyESP(prompt)
        end
    end
end
