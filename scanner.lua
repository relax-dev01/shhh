-- [[ Backdoor Scanner - Advanced Path & Connection ]] --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tespit edilecek şüpheli isimler
local suspiciousNames = {"backdoor", "infection", "virus", "remote", "module", "mainmodule", "vape", "cmd"}

-- İşaretleme fonksiyonu
local function highlightBackdoor(object, fullPath)
    if object:FindFirstChild("BackdoorVisual") then return end
    
    local visualFolder = Instance.new("Folder")
    visualFolder.Name = "BackdoorVisual"
    visualFolder.Parent = object

    -- 1. Kırmızı Çizgi (SelectionBox - Görünmez olsa bile gözükür)
    local sBox = Instance.new("SelectionBox")
    sBox.Adornee = object
    sBox.Color3 = Color3.fromRGB(255, 0, 0)
    sBox.LineThickness = 0.1
    sBox.AlwaysOnTop = true
    sBox.SurfaceColor3 = Color3.fromRGB(255, 0, 0)
    sBox.SurfaceTransparency = 0.7
    sBox.Parent = visualFolder

    -- 2. Detaylı Bilgi Etiketi (BillboardGui)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 300, 0, 100) -- Daha geniş alan
    billboard.AlwaysOnTop = true
    billboard.Adornee = object
    billboard.Parent = visualFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    -- İstediğin format: backdoor + Tam Konum
    label.Text = "🚨 backdoor 🚨\n" .. fullPath
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.TextWrapped = true
    label.Parent = billboard
end

-- Tarama fonksiyonu
local function scan()
    print("🛡️ Agresif Tarama ve Baglanti baslatildi...")
    local detectedCount = 0

    for _, v in pairs(game:GetDescendants()) do
        -- Donmayı engellemek için kısa bekleme
        if _ % 100 == 0 then task.wait() end
        
        local success, result = pcall(function()
            local isSuspicious = false
            
            -- Kriter 1: Isim kontrolü
            local nameLower = string.lower(v.Name)
            for _, sName in pairs(suspiciousNames) do
                if string.find(nameLower, sName) then
                    isSuspicious = true
                    break
                end
            end

            -- Kriter 2: RemoteEvent Taraması ve Otomatik Bağlantı
            if v:IsA("RemoteEvent") then
                -- Eğer RemoteEvent ReplicatedStorage dışında bir yerdeyse (Gizli Backdoor)
                if not v:IsDescendantOf(ReplicatedStorage) then
                    isSuspicious = true
                    -- OTOMATİK BAĞLANTI KURMA
                    pcall(function() v:FireServer("checking_connection") end)
                end
            end

            if isSuspicious then
                -- İşaretlenecek ana objeyi bul (Remote ise parent'ını işaretle)
                local target = v
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                    target = v.Parent
                end

                if target:IsA("Model") or target:IsA("BasePart") then
                    detectedCount = detectedCount + 1
                    -- Nesnenin tam konumunu (Path) al
                    local fullPath = v:GetFullName()
                    highlightBackdoor(target, fullPath)
                end
            end
        end)
    end
    print("✅ Tarama bitti. Toplam tespit edilen: " .. detectedCount)
end

-- Baslat
task.spawn(scan)

-- Yeni eklenen nesneleri anlık izle
game.DescendantAdded:Connect(function(v)
    pcall(function()
        if v:IsA("RemoteEvent") and not v:IsDescendantOf(ReplicatedStorage) then
            pcall(function() v:FireServer("new_connection_check") end)
            if v.Parent:IsA("Model") or v.Parent:IsA("BasePart") then
                highlightBackdoor(v.Parent, v:GetFullName())
            end
        end
    end)
end)
