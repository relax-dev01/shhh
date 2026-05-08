-- [[ Backdoor Skaner - Yol və Skript Axtarışı ]] --

local StarterGui = game:GetService("StarterGui")

-- Bildiriş Funksiyası
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 4;
        })
    end)
end

local suspiciousNames = {"backdoor", "infection", "virus", "remote", "module", "mainmodule"}

-- Vizual Effekt və Xüsusi Yol (Path) Formatı
local function applyGlow(object, detectedObj)
    if object:FindFirstChild("BackdoorGlow") then return end
    
    -- Yol Formatı: Nöqtə (.) yerinə Slash (/) istifadə et və (skript) əlavə et
    local fullPath = detectedObj:GetFullName()
    local formattedPath = string.gsub(fullPath, "%.", "/") -- Nöqtələri Slash et
    
    if detectedObj:IsA("LuaSourceContainer") or string.find(string.lower(detectedObj.ClassName), "script") then
        formattedPath = formattedPath .. " (skript)"
    end

    -- Parlama (Highlight)
    local highlight = Instance.new("Highlight")
    highlight.Name = "BackdoorGlow"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = object

    -- Yazı Etiketi (BillboardGui)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.AlwaysOnTop = true
    billboard.Adornee = object
    billboard.Parent = object
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🚨 TƏHLÜKƏ (BACKDOOR) 🚨\n" .. formattedPath
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 10 -- Yol uzun ola biləcəyi üçün ölçü kiçildildi
    label.TextWrapped = true
    label.Parent = billboard
end

-- Axtarış Funksiyası
local function startScan()
    notify("🔍 Skaner", "Ətraflı axtarış başladıldı...")
    local count = 0
    
    -- Bütün oyunu skan et (StarterPack, Workspace və s.)
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            local isFound = false
            local name = string.lower(v.Name)
            
            -- Adın yoxlanılması
            for _, sName in pairs(suspiciousNames) do
                if string.find(name, sName) then
                    isFound = true
                    break
                end
            end
            
            -- Remote yoxlanılması (Səhv yerdə olan remote-lar)
            if v:IsA("RemoteEvent") and not v:IsDescendantOf(game:GetService("ReplicatedStorage")) then
                isFound = true
            end

            if isFound then
                -- İşarələnəcək əsas obyekti tap
                local target = v
                if v:IsA("RemoteEvent") or v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then
                    target = v.Parent
                end
                
                -- Yalnız fiziki qarşılığı olanları (Model, Part və s.) işarələ
                if target:IsA("Model") or target:IsA("BasePart") or target:IsA("Tool") then
                    applyGlow(target, v)
                    count = count + 1
                end
            end
        end)
        
        -- Oyunun donmaması üçün hər 200 obyektdən bir qısa fasilə ver
        if _ % 200 == 0 then task.wait() end
    end
    
    notify("✅ Axtarış Bitdi", "Cəmi " .. count .. " təhlükə tapıldı.")
end

startScan()
