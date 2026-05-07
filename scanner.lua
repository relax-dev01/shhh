-- [[ Zero-Risk Ultra-Stealth Scanner ]] --

if _G.ScannerRunning then return end
_G.ScannerRunning = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui") -- Görselleri buraya gizleyecegiz
local Workspace = game:GetService("Workspace")

local suspiciousNames = {"backdoor", "infection", "virus", "remote", "module", "mainmodule"}

-- Görseller için gizli bir klasör oluştur
local espFolder = CoreGui:FindFirstChild("Hidden_ESP_Folder")
if not espFolder then
    espFolder = Instance.new("Folder")
    espFolder.Name = "Hidden_ESP_Folder"
    espFolder.Parent = CoreGui
end

local function applySafeESP(object, path)
    -- Çizgi (SelectionBox)
    local sBox = Instance.new("SelectionBox")
    sBox.Adornee = object
    sBox.Color3 = Color3.fromRGB(255, 0, 0)
    sBox.LineThickness = 0.05
    sBox.AlwaysOnTop = true
    sBox.Parent = espFolder -- Modelin içine değil, gizli klasöre koyuyoruz

    -- Yazı (Billboard)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.Adornee = object
    billboard.Parent = espFolder -- Gizli klasöre koyuyoruz
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "backdoor\n" .. path
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 10
    label.Parent = billboard
end

local function passiveScan()
    local descendants = Workspace:GetDescendants()
    local count = 0

    for i, v in pairs(descendants) do
        -- Her 20 nesnede bir bekle (En güvenli hız)
        if i % 20 == 0 then task.wait() end
        
        pcall(function()
            local isFound = false
            local nameLower = string.lower(v.Name)
            
            -- Sadece isimden tespit (En güvenli yol)
            for _, sName in pairs(suspiciousNames) do
                if string.find(nameLower, sName) then
                    isFound = true
                    break
                end
            end
            
            -- Remote kontrolü (Sadece yerini bul, ASLA dokunma)
            if v:IsA("RemoteEvent") and not v:IsDescendantOf(ReplicatedStorage) then
                isFound = true
            end

            if isFound then
                local target = v
                if v:IsA("RemoteEvent") then target = v.Parent end
                if target:IsA("Model") or target:IsA("BasePart") then
                    count = count + 1
                    applySafeESP(target, v:GetFullName())
                end
            end
        end)
    end
    print("🛡️ Tarama bitti. Bulunan: " .. count)
    _G.ScannerRunning = false
end

task.spawn(passiveScan)
