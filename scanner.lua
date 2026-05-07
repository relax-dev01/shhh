-- [[ Backdoor Scanner & Highlighter V1.0 ]] --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. Görsel Efekt (Kalın Çizgiler ve Etiket)
local function applyESP(object)
    if object:FindFirstChild("BackdoorHighlight") then return end
    
    -- Komple Kırmızı Çizgi Kaplaması (SelectionBox)
    local highlight = Instance.new("SelectionBox")
    highlight.Name = "BackdoorHighlight"
    highlight.Adornee = object
    highlight.Color3 = Color3.fromRGB(255, 0, 0)
    highlight.LineThickness = 0.15 -- Çizgiyi kalınlaştırdım
    highlight.AlwaysOnTop = true
    highlight.SurfaceColor3 = Color3.fromRGB(255, 0, 0)
    highlight.SurfaceTransparency = 0.6 -- İçini de hafif kırmızı yapar
    highlight.Parent = object

    -- "backdoor" Yazısı
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BackdoorLabel"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Adornee = object
    billboard.Parent = object

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "backdoor"
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.Parent = billboard
end

-- 2. Otomatik Bağlantı Kurma ve Tarama
local function startScanner()
    print("🛡️ Tarama ve Baglanti baslatildi...")
    
    for _, v in pairs(game:GetDescendants()) do
        -- Oyunun donmaması için her 100 nesnede bir çok kısa bekleme
        if _ % 100 == 0 then task.wait() end
        
        local success, result = pcall(function()
            local isSuspicious = false
            local name = string.lower(v.Name)
            
            -- Kriter 1: Isim (Backdoor, virus vb.)
            if string.find(name, "backdoor") or string.find(name, "virus") or string.find(name, "remote") then
                isSuspicious = true
            end
            
            -- Kriter 2: Yanlış yerdeki RemoteEvent (Otomatik Bağlantı Kur)
            if v:IsA("RemoteEvent") then
                if not v:IsDescendantOf(ReplicatedStorage) then
                    isSuspicious = true
                    -- OTOMATİK BAĞLANTI: Remote'u uyandırıyoruz
                    pcall(function() v:FireServer("checking") end)
                end
            end

            if isSuspicious then
                -- Eğer Remote ise onun üst modelini veya partını işaretle
                local target = v
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                    target = v.Parent
                end
                
                if target:IsA("Model") or target:IsA("BasePart") then
                    applyESP(target)
                end
            end
        end)
    end
    print("✅ Tarama bitti.")
end

-- Calistir
task.spawn(startScanner)
