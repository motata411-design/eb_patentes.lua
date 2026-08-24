local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ================= SISTEMA DE KEY SEGURO =================
-- Tempo em segundos (Ex: 3600 = 1 hora, 86400 = 1 dia, 999999999 = Permanente)
local ValidKeys = {
    ["NATHAN22"] = 3600,
    ["VIPZEP"] = 999999999
}

local KEY_FILE = "VG_RLK_KeySystem_V2.json"
local authorized = false

-- Função para ler e verificar se o tempo da key ainda é válido
local function checkSavedKey()
    if readfile and pcall(function() return readfile(KEY_FILE) end) then
        local content = readfile(KEY_FILE)
        local success, data = pcall(function()
            -- O formato salvo será: "Chave|TimestampDeExpiracao"
            local sep = content:find("|")
            if sep then
                local expiration = tonumber(content:sub(sep + 1))
                if expiration and os.time() < expiration then
                    return true
                end
            end
        end)
        if success and data then
            return true
        end
    end
    return false
end

if checkSavedKey() then
    authorized = true
else
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "VG_RLK_KeySystem"
    KeyGui.ResetOnSpawn = false
    KeyGui.Parent = PlayerGui

    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 300, 0, 160)
    KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Parent = KeyGui

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 40)
    KeyTitle.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    KeyTitle.Text = "🔑 SISTEMA DE KEY"
    KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTitle.TextSize = 16
    KeyTitle.Font = Enum.Font.GothamBold
    KeyTitle.Parent = KeyFrame

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -20, 0, 40)
    KeyBox.Position = UDim2.new(0, 10, 0, 55)
    KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.PlaceholderText = "Insira sua Key aqui..."
    KeyBox.Text = ""
    KeyBox.TextSize = 14
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.Parent = KeyFrame

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(1, -20, 0, 35)
    SubmitBtn.Position = UDim2.new(0, 10, 0, 105)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    SubmitBtn.Text = "VERIFICAR KEY"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 14
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = KeyFrame

    local function verificar()
        local digitada = KeyBox.Text
        local duracao = ValidKeys[digitada]
        
        if duracao then
            -- Calcula o tempo exato que vai expirar baseado no horário atual do sistema
            local expirationTime = os.time() + duracao
            if writefile then
                pcall(function() 
                    writefile(KEY_FILE, digitada .. "|" .. expirationTime) 
                end)
            end
            KeyGui:Destroy()
            authorized = true
        else
            SubmitBtn.Text = "KEY INVÁLIDA!"
            SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(1)
            SubmitBtn.Text = "VERIFICAR KEY"
            SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        end
    end

    SubmitBtn.MouseButton1Click:Connect(verificar)
    KeyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then verificar() end
    end)

    repeat task.wait() until authorized
end

-- ================= SEU SCRIPT PRINCIPAL =================
local Patentes = {
    {Tag = "[ER]", Nome = "Elite Real", Cor = Color3.fromRGB(255, 50, 50)},
    {Tag = "[ES]", Nome = "Elite Secreta", Cor = Color3.fromRGB(255, 215, 0)},
    {Tag = "[EM]", Nome = "Elite Militar", Cor = Color3.fromRGB(255, 140, 0)},
    {Tag = "[GEN EX]", Nome = "General de Exército", Cor = Color3.fromRGB(255, 215, 0)},
    {Tag = "[GEN DV]", Nome = "General de Divisão", Cor = Color3.fromRGB(255, 215, 0)},
    {Tag = "[GEN BDA]", Nome = "General de Brigada", Cor = Color3.fromRGB(255, 215, 0)},
    {Tag = "[CEL]", Nome = "Coronel", Cor = Color3.fromRGB(255, 165, 0)},
    {Tag = "[TEN-CEL]", Nome = "Tenente Coronel", Cor = Color3.fromRGB(255, 165, 0)},
    {Tag = "[MAJ]", Nome = "Major", Cor = Color3.fromRGB(255, 165, 0)},
    {Tag = "[CAP]", Nome = "Capitão", Cor = Color3.fromRGB(0, 255, 255)},
    {Tag = "[1º TEN]", Nome = "Primeiro Tenente", Cor = Color3.fromRGB(150, 100, 255)},
    {Tag = "[2º TEN]", Nome = "Segundo Tenente", Cor = Color3.fromRGB(150, 100, 255)},
    {Tag = "[ASP]", Nome = "Aspirante a Oficial", Cor = Color3.fromRGB(150, 100, 255)},
}

local lastPatente = Patentes[13]
local labelsCache = {}

local function ScanForLabels()
    local char = Player.Character
    if not char then return end
    
    local newCache = {}
    local locais = {char}
    if PlayerGui then table.insert(locais, PlayerGui) end
    
    for _, localBusca in ipairs(locais) do
        for _, obj in ipairs(localBusca:GetDescendants()) do
            if obj:IsA("TextLabel") then
                local bg = obj:FindFirstAncestorWhichIsA("BillboardGui")
                if bg then
                    local belongsToPlayer = false
                    if bg:IsDescendantOf(char) then
                        belongsToPlayer = true
                    elseif bg.Adornee and bg.Adornee:IsDescendantOf(char) then
                        belongsToPlayer = true
                    end
                    
                    if belongsToPlayer and obj.Text ~= "" then
                        local txt = obj.Text
                        local isRank = false
                        if txt:find("%[") or txt:find("Aspirante") or txt:find("Tenente") or txt:find("Capitão") or txt:find("Coronel") or txt:find("Major") or txt:find("General") or txt:find("Elite") or txt:find("Recruta") or txt:find("Soldado") or txt:find("Cabo") or txt:find("Sargento") or txt:find(lastPatente.Tag) then
                            if not txt:find(Player.Name) and not txt:find(Player.DisplayName) and not txt:find("N/A") and not txt:find("n/a") then
                                isRank = true
                            end
                        end
                        table.insert(newCache, {instance = obj, isRankLine = isRank})
                    end
                end
            end
        end
    end
    labelsCache = newCache
end

task.spawn(function()
    while task.wait(1) do
        ScanForLabels()
    end
end)

RunService.RenderStepped:Connect(function()
    if not lastPatente then return end
    local textoCerto = lastPatente.Tag .. " " .. lastPatente.Nome
    for _, data in ipairs(labelsCache) do
        local label = data.instance
        if label and label.Parent then
            if label.TextColor3 ~= lastPatente.Cor then
                label.TextColor3 = lastRPatenteCor or lastPatente.Cor
            end
            if data.isRankLine then
                if label.Text ~= textoCerto then
                    label.Text = textoCerto
                end
            end
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VG_RLK_Patente_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(1, -65, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "🎖️"
ToggleBtn.TextSize = 25
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.85, 0, 0.7, 0)
MainFrame.Position = UDim2.new(0.075, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.Text = "⚔️ PATENTES EB\nCreator: VG RLK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -70)
ScrollFrame.Position = UDim2.new(0, 5, 0, 65)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = MainFrame

local currentY = 10
for _, patente in ipairs(Patentes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.Position = UDim2.new(0, 5, 0, currentY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = ScrollForm or ScrollFrame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = patente.Cor
    bar.BorderSizePixel = 0
    bar.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = patente.Tag .. "  " .. patente.Nome
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    btn.MouseButton1Click:Connect(function()
        lastPatente = patente
        ScanForLabels()
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        task.wait(0.2)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end)

    currentY = currentY + 55
end
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, currentY)

local isOpen = false
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
end)

CloseBtn.MouseButton1Click:Connect(function()
    isOpen = false
    MainFrame.Visible = false
end)

print("✅ VG RLK - Key com Tempo Real Carregada!")
