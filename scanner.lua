-- [[ Backdoor Scanner - Notifications & Safety ]] --

-- 1. ÇİFT ÇALIŞMA KONTROLÜ (Oyundan atılmanı engeller)
if _G.ScannerRunning then 
    warn("⚠️ Script zaten calisiyor, ikinci kez calistirma engellendi!")
    return 
end
_G.ScannerRunning = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local suspiciousNames = {"backdoor", "infection", "virus", "remote", "module", "mainmodule"}

-- Bildirim Fonksiyonu
local function sendNotification(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 5;
        })
    end)
end

-- İşaretleme Fonksiyonu
local function highlightBackdoor(object, fullPath)
    if object:FindFirstChild("BackdoorVisual") then return end
    
    local folder = Instance.new("Folder")
    folder.Name = "BackdoorVisual"
    folder.Parent = object

    local sBox = Instance.new("SelectionBox")
    sBox.Adornee = object
    sBox.Color3 = Color3.fromRGB(255, 0, 0)
    sBox.LineThickness = 0.1
    sBox.AlwaysOnTop = true
    sBox.Parent = folder

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 250, 0, 80)
    billboard.AlwaysOnTop = true
    billboard.Adornee = object
    billboard.Parent = folder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🚨 backdoor 🚨\n" .. fullPath
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 12
    label.TextWrapped = true
    label.Parent = billboard
end

-- Tarama ve Bağlantı Fonksiyonu
local function scan()
    sendNotification("Scanner", "Tarama baslatildi...")
    local detectedCount = 0

    for _, v in pairs(game:GetDescendants()) do
        -- Her 150 nesnede bir bekle (Atılmanı engellemek için hızı dengeledik)
        if _ % 150 == 0 then task.wait() end
        
        local success = pcall(function()
            local isSuspicious = false
            local nameLower = string.lower(v.Name)
            
            for _, sName in pairs(suspiciousNames) do
                if string.find(nameLower, sName) then
                    isSuspicious = true
                    break
                end
            end

            if v:IsA("RemoteEvent") and not v:IsDescendantOf(ReplicatedStorage) then
                isSuspicious = true
                -- OTOMATİK BAĞLANTI VE BİLDİRİM
                pcall(function() 
                    v:FireServer("probe_connection") 
                    sendNotification("🔍 Bağlantı Kuruldu!", "Remote: " .. v.Name)
                end)
            end

            if isSuspicious then
                local target = v
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then target = v.Parent end

                if target:IsA("Model") or target:IsA("BasePart") then
                    detectedCount = detectedCount + 1
                    highlightBackdoor(target, v:GetFullName())
                end
            end
        end)
    end
    sendNotification("✅ Tarama Tamamlandı", "Toplam " .. detectedCount .. " tehdit bulundu.")
    -- Script bittiğinde tekrar çalıştırılabilir olması için (isteğe bağlı)
    _G.ScannerRunning = false 
end

-- Başlat
task.spawn(scan)
