-- [[ Backdoor Scanner & Highlighter ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui") -- UI'ları gizli tutmak için

-- Tespit edilecek şüpheli isimler listesi
local suspiciousNames = {"backdoor", "infection", "virus", "remote", "module", "mainmodule"}

-- İşaretleme fonksiyonu
local function highlightBackdoor(object)
    -- 1. Kırmızı Çizgi (Highlight)
    local highlight = Instance.new("Highlight")
    highlight.Name = "BackdoorHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- İç dolgu kırmızı
    highlight.FillTransparency = 0.5 -- Yarı şeffaf
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Dış çizgi beyaz (daha belirgin olması için)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Duvar arkasından bile görünür
    highlight.Parent = object

    -- 2. "Backdoor" Yazısı (BillboardGui)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BackdoorLabel"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true -- Her zaman üstte
    billboard.Adornee = object -- Modeli hedefle
    billboard.Parent = object

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🚨 BACKDOOR 🚨"
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.Parent = billboard
end

-- Tarama fonksiyonu
local function scan()
    print("🛡️ Tarama başlatıldı...")
    local detectedCount = 0

    for _, v in pairs(game:GetDescendants()) do
        -- Sadece Model veya Part olan nesneleri ve bizim oluşturmadığımız işaretleri tara
        if (v:IsA("Model") or v:IsA("BasePart")) and not v:FindFirstChild("BackdoorHighlight") then
            local isSuspicious = false
            
            -- İsim kontrolü
            for _, name in pairs(suspiciousNames) do
                if string.find(string.lower(v.Name), name) then
                    isSuspicious = true
                    break
                end
            end

            -- İçinde şüpheli script kontrolü (Bazı backdoorlar isimsizdir)
            if not isSuspicious then
                local scriptIn = v:FindFirstChildOfClass("Script") or v:FindFirstChildOfClass("ModuleScript")
                if scriptIn and (string.find(string.lower(scriptIn.Name), "backdoor") or string.find(string.lower(scriptIn.Name), "virus")) then
                    isSuspicious = true
                end
            end

            if isSuspicious then
                detectedCount = detectedCount + 1
                highlightBackdoor(v)
                print("⚠️ Tespit Edildi: " .. v:GetFullName())
            end
        end
    end
    print("✅ Tarama bitti. Toplam tespit edilen: " .. detectedCount)
end

-- Scripti çalıştırınca taramayı başlat
scan()

-- Yeni eklenen nesneleri de anlık olarak takip et (Canlı Koruma)
game.DescendantAdded:Connect(function(descendant)
    task.wait(1) -- Tam yüklenmesi için kısa bir bekleme
    local isSuspicious = false
    for _, name in pairs(suspiciousNames) do
        if string.find(string.lower(descendant.Name), name) then
            isSuspicious = true
            break
        end
    end
    
    if isSuspicious and (descendant:IsA("Model") or descendant:IsA("BasePart")) then
        highlightBackdoor(descendant)
    end
end)
