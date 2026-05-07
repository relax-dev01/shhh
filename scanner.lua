-- [[ Backdoor Scanner - Path & Script Detection ]] --

local StarterGui = game:GetService("StarterGui")

-- Bildirim Fonksiyonu
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

-- Görsel Efekt ve Özel Path Formatı
local function applyGlow(object, detectedObj)
    if object:FindFirstChild("BackdoorGlow") then return end
    
    -- Path Formatlama: . yerine / kullan ve (script) ekle
    local fullPath = detectedObj:GetFullName()
    local formattedPath = string.gsub(fullPath, "%.", "/") -- Noktaları Slash yap
    
    if detectedObj:IsA("LuaSourceContainer") or string.find(string.lower(detectedObj.ClassName), "script") then
        formattedPath = formattedPath .. " (script)"
    end

    -- Parlama (Highlight)
    local highlight = Instance.new("Highlight")
    highlight.Name = "BackdoorGlow"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = object

    -- Yazı Etiketi
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.AlwaysOnTop = true
    billboard.Adornee = object
    billboard.Parent = object
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🚨 backdoor 🚨\n" .. formattedPath
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 10 -- Path uzun olabileceği için biraz küçülttüm
    label.TextWrapped = true
    label.Parent = billboard
end

-- Tarama Fonksiyonu
local function startScan()
    notify("🔍 Scanner", "Detayli tarama baslatildi...")
    local count = 0
    
    -- Tüm oyunu tara (StarterPack, Workspace vb.)
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            local isFound = false
            local name = string.lower(v.Name)
            
            -- Isim Kontrolü
            for _, sName in pairs(suspiciousNames) do
                if string.find(name, sName) then
                    isFound = true
                    break
                end
            end
            
            -- Remote Kontrolü (Yanlış yerdeki remotelar)
            if v:IsA("RemoteEvent") and not v:IsDescendantOf(game:GetService("ReplicatedStorage")) then
                isFound = true
            end

            if isFound then
                -- İşaretlenecek ana objeyi bul
                local target = v
                if v:IsA("RemoteEvent") or v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then
                    target = v.Parent
                end
                
                -- Sadece fiziksel bir karşılığı olanları işaretle
                if target:IsA("Model") or target:IsA("BasePart") or target:IsA("Tool") then
                    applyGlow(target, v)
                    count = count + 1
                end
            end
        end)
        -- Donmayı engellemek için her 200 nesnede bir çok kısa bekleme
        if _ % 200 == 0 then task.wait() end
    end
    
    notify("✅ Tarama Bitti", "Toplam " .. count .. " tehdit bulundu.")
end

startScan()
