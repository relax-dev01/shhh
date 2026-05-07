-- [[ Stealth Backdoor Scanner - Anti-Kick Version ]] --

if _G.ScannerRunning then return end
_G.ScannerRunning = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local suspiciousNames = {"backdoor", "infection", "virus", "remote", "module", "mainmodule"}

local function sendNotification(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 3;
        })
    end)
end

local function applyESP(object, path)
    if object:FindFirstChild("BackdoorVisual") then return end
    
    local folder = Instance.new("Folder")
    folder.Name = "BackdoorVisual"
    folder.Parent = object

    local sBox = Instance.new("SelectionBox")
    sBox.Adornee = object
    sBox.Color3 = Color3.fromRGB(255, 0, 0)
    sBox.LineThickness = 0.08
    sBox.AlwaysOnTop = true
    sBox.Parent = folder

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Adornee = object
    billboard.Parent = folder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🚨 backdoor 🚨\n" .. path
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 10
    label.TextWrapped = true
    label.Parent = billboard
end

-- GÜVENLİ TARAMA (Sadece Workspace ve ReplicatedStorage)
local function stealthScan()
    sendNotification("Scanner", "Gizli tarama baslatildi... (Yavas Mod)")
    
    -- Sadece riskli yerleri tara, tüm 'game'i degil
    local locations = {Workspace, ReplicatedStorage}
    local detectedCount = 0

    for _, location in pairs(locations) do
        local descendants = location:GetDescendants()
        
        for i, v in pairs(descendants) do
            -- Her 30 nesnede bir bekle (Daha yavas ama sifir kasma)
            if i % 30 == 0 then task.wait() end
            
            pcall(function()
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
                    -- REMOTE'A YAVASCA DOKUN (Anti-Cheat'e yakalanmadan)
                    task.delay(0.5, function()
                        pcall(function() v:FireServer("check") end)
                    end)
                end

                if isSuspicious then
                    local target = v
                    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then target = v.Parent end
                    if target:IsA("Model") or target:IsA("BasePart") then
                        detectedCount = detectedCount + 1
                        applyESP(target, v:GetFullName())
                    end
                end
            end)
        end
    end
    
    sendNotification("✅ Bitti", "Tarama güvenle tamamlandi.")
    _G.ScannerRunning = false
end

task.spawn(stealthScan)
