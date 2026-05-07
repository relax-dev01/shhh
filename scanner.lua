-- [[ Guaranteed Backdoor Finder - Updated Label ]] --

local function applyGuaranteedESP(object)
    if object:FindFirstChild("BackdoorVisual") then return end
    
    local visualFolder = Instance.new("Folder")
    visualFolder.Name = "BackdoorVisual"
    visualFolder.Parent = object

    -- 1. Kırmızı Kutu (BoxHandleAdornment)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = (object:IsA("Model") and object:GetExtentsSize() or object.Size) + Vector3.new(0.2, 0.2, 0.2)
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Adornee = object
    box.Transparency = 0.6
    box.Parent = visualFolder

    -- 2. Kalın Kenar Çizgileri
    local sBox = Instance.new("SelectionBox")
    sBox.Adornee = object
    sBox.Color3 = Color3.fromRGB(255, 0, 0)
    sBox.LineThickness = 0.1
    sBox.AlwaysOnTop = true
    sBox.Parent = visualFolder

    -- 3. Yazı Etiketi (İstediğin "backdoor" yazısı)
    local bgui = Instance.new("BillboardGui")
    bgui.Size = UDim2.new(0, 100, 0, 40)
    bgui.AlwaysOnTop = true
    bgui.Adornee = object
    bgui.Parent = visualFolder
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.Text = "backdoor" -- Sadece backdoor yazısı
    txt.TextColor3 = Color3.fromRGB(255, 0, 0) -- Kırmızı yazı
    txt.TextStrokeColor3 = Color3.fromRGB(255, 255, 255) -- Beyaz dış hat (okunurluk için)
    txt.TextStrokeTransparency = 0
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 20
    txt.Parent = bgui
end

-- Diğer tarama ve bağlantı kodları aynı kalıyor...
