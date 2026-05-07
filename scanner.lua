-- [[ High-Visibility Scanner with Notifications ]] --

local StarterGui = game:GetService("StarterGui")

-- Bildirim Fonksiyonu
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 5;
        })
    end)
end

local suspiciousNames = {"backdoor", "infection", "virus", "remote", "module", "mainmodule"}

-- Görsel Efekt
local function applyGlow(object, path)
    if object:FindFirstChild("BackdoorGlow") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "BackdoorGlow"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = object

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Adornee = object
    billboard.Parent = object
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🚨 backdoor 🚨\n" .. path
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 11
    label.TextWrapped = true
    label.Parent = billboard
end

-- Tarama ve Bildirim
local function startScan()
    notify("🛡️ Scanner", "Tarama baslatildi...")
    local count = 0
    
    for _, v in pairs(workspace:GetDescendants()) do
        pcall(function()
            if v:IsA("Model") or v:IsA("BasePart") or v:IsA("RemoteEvent") then
                local isFound = false
                local name = string.lower(v.Name)
                
                for _, sName in pairs(suspiciousNames) do
                    if string.find(name, sName) then
                        isFound = true
                        break
                    end
                end
                
                if not isFound and v:IsA("RemoteEvent") then
                    if not v:IsDescendantOf(game:GetService("ReplicatedStorage")) then
                        isFound = true
                    end
                end

                if isFound then
                    local target = v
                    if v:IsA("RemoteEvent") then target = v.Parent end
                    
                    if target:IsA("Model") or target:IsA("BasePart") then
                        applyGlow(target, v:GetFullName())
                        count = count + 1
                    end
                end
            end
        end)
    end
    
    if count > 0 then
        notify("⚠️ TEHDİT BULUNDU!", "Toplam " .. count .. " adet backdoor isaretlendi.")
    else
        notify("✅ TEMİZ", "Herhangi bir backdoor bulunamadi.")
    end
end

-- Baslat
startScan()
