-- [[ Ultra-Bold Backdoor ESP - No Connection Needed ]] --

local workspace = game:GetService("Workspace")
local suspiciousNames = {"backdoor", "infection", "virus", "remote", "module", "mainmodule", "vape", "cmd"}

local function applyBoldESP(object)
    if object:FindFirstChild("UltraBackdoorESP") then return end
    
    local folder = Instance.new("Folder")
    folder.Name = "UltraBackdoorESP"
    folder.Parent = object

    -- 1. KALIN KIRMIZI ÇERÇEVE (Duvar arkası bile sırıtır)
    local box = Instance.new("SelectionBox")
    box.Adornee = object
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.LineThickness = 0.1 -- Çizgiyi iyice kalınlaştırdım
    box.SurfaceColor3 = Color3.fromRGB(255, 0, 0)
    box.SurfaceTransparency = 0.4 -- İçini de belirgin kırmızı yapar
    box.AlwaysOnTop = true
    box.Parent = folder

    -- 2. PARLAMA EFEKTİ (Highlight - Komple kırmızı blok yapar)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = object
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.2 -- Çok daha az şeffaf, daha çok kırmızı
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = folder

    -- 3. BÜYÜK YAZI ETİKETİ
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.AlwaysOnTop = true
    billboard.Parent = folder
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "!!! BACKDOOR !!!"
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.FredokaOne -- Daha kalın bir font
    label.TextSize = 25
    label.Parent = billboard
end

-- AGRESİF TARAMA (Hemen Çalışır)
local function aggressiveScan()
    -- Sadece Workspace değil, tüm oyunu tara (Hemen gösterir)
    for _, v in pairs(game:GetDescendants()) do
        pcall(function() -- Hata almamak için (Erişim engeli olan yerler için)
            if v:IsA("Model") or v:IsA("BasePart") then
                local name = string.lower(v.Name)
                local found = false
                
                -- Kriter 1: İsim kontrolü
                for _, sName in pairs(suspiciousNames) do
                    if string.find(name, sName) then
                        found = true
                        break
                    end
                end
                
                -- Kriter 2: İçinde RemoteEvent var mı? (Görünmez backdoorların çoğu bunu taşır)
                if not found and v:FindFirstChildOfClass("RemoteEvent") then
                    -- Eğer RemoteEvent ReplicatedStorage dışında bir yerdeyse şüphelidir
                    found = true
                end

                if found then
                    applyBoldESP(v)
                end
            end
        end)
    end
end

-- BAĞLANTI BEKLEMEDEN ÇALIŞTIR
print("🔴 Ultra Scanner Başlatıldı!")
aggressiveScan()

-- Oyun boyu yeni gelenleri takip et
game.DescendantAdded:Connect(function(v)
    pcall(function()
        if v:IsA("Model") or v:IsA("BasePart") then
            local name = string.lower(v.Name)
            if string.find(name, "backdoor") or v:FindFirstChildOfClass("RemoteEvent") then
                applyBoldESP(v)
            end
        end
    end)
end)
