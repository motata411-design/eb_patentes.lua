-- ==========================================
-- PATENTES E DIVISÕES EB (KAIZER V14 - CORREÇÃO DE CORES)
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ================= SISTEMA DE KEY SEGURO =================
local ValidKeys = {
    ["NATHAN22"] = 3600,
    ["VIPZEP"] = 999999999
}

local KEY_FILE = "VG_RLK_KeySystem_V2.json"
local authorized = false

local function checkSavedKey()
    if readfile and pcall(function() return readfile(KEY_FILE) end) then
        local content = readfile(KEY_FILE)
        local success, data = pcall(function()
            local sep = content:find("|")
            if sep then
                local expiration = tonumber(content:sub(sep + 1))
                if expiration and os.time() < expiration then
                    return true
                end
            end
        end)
        if success and data then return true end
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
            local expirationTime = os.time() + duracao
            if writefile then
                pcall(function() writefile(KEY_FILE, digitada .. "|" .. expirationTime) end)
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

-- ================= BANCO DE DADOS =================
local Patentes = {
    -- Criadores
    {Tag = "[CR]", Nome = "Criador", Cor = Color3.fromRGB(233, 116, 81)}, 
    {Tag = "[SCR]", Nome = "Sub Criador", Cor = Color3.fromRGB(233, 116, 81)}, 
    
    -- Administração
    {Tag = "[ADM-G]", Nome = "Administrador Geral", Cor = Color3.fromRGB(255, 255, 255)},
    {Tag = "[ADM]", Nome = "Administrador", Cor = Color3.fromRGB(255, 255, 255)},
    {Tag = "[SUP]", Nome = "Supervisor", Cor = Color3.fromRGB(255, 255, 255)},
    {Tag = "[MOD]", Nome = "Moderador", Cor = Color3.fromRGB(255, 255, 255)},
    
    -- Supremacia
    {Tag = "[SC]", Nome = "Sócio", Cor = Color3.fromRGB(255, 255, 255)},
    
    -- Alto Comando
    {Tag = "[CMT]", Nome = "Comandante", Cor = Color3.fromRGB(255, 60, 60)},
    {Tag = "[SCMT]", Nome = "Subcomandante", Cor = Color3.fromRGB(255, 60, 60)},
    
    -- Oficiais da Elite
    {Tag = "[ER]", Nome = "Elite Real", Cor = Color3.fromRGB(255, 125, 0)},
    {Tag = "[ES]", Nome = "Elite Secreta", Cor = Color3.fromRGB(255, 125, 0)},
    {Tag = "[EM]", Nome = "Elite Militar", Cor = Color3.fromRGB(255, 125, 0)},
    
    -- Oficiais Generais (Corrigido para o tom acobreado/laranja escuro do Discord)
    {Tag = "[GEN EX]", Nome = "General de Exército", Cor = Color3.fromRGB(210, 130, 50)},
    {Tag = "[GEN DV]", Nome = "General de Divisão", Cor = Color3.fromRGB(210, 130, 50)},
    {Tag = "[GEN BDA]", Nome = "General de Brigada", Cor = Color3.fromRGB(210, 130, 50)},
    
    -- Oficiais Superiores
    {Tag = "[CEL]", Nome = "Coronel", Cor = Color3.fromRGB(255, 255, 0)},
    {Tag = "[TEN-CEL]", Nome = "Tenente Coronel", Cor = Color3.fromRGB(255, 255, 0)},
    {Tag = "[MAJ]", Nome = "Major", Cor = Color3.fromRGB(255, 255, 0)},
    
    -- Oficiais Intermediários (Corrigido para Laranja)
    {Tag = "[CAP]", Nome = "Capitão", Cor = Color3.fromRGB(255, 165, 0)},
    
    -- Oficiais Subalternos
    {Tag = "[1º TEN]", Nome = "Primeiro Tenente", Cor = Color3.fromRGB(155, 89, 182)},
    {Tag = "[2º TEN]", Nome = "Segundo Tenente", Cor = Color3.fromRGB(155, 89, 182)},
    {Tag = "[ASP]", Nome = "Aspirante a Oficial", Cor = Color3.fromRGB(155, 89, 182)}
}

local Divisoes = {
    {Tag = "[N/A]", Nome = "N/A", Cor = Color3.fromRGB(180, 180, 180)},
    {Tag = "[BAC]", Nome = "Batalhão de Ações de Comandos", Cor = Color3.fromRGB(40, 50, 110)},
    {Tag = "[BPE]", Nome = "Batalhão da Polícia do Exército", Cor = Color3.fromRGB(40, 90, 190)},
    {Tag = "[BFE]", Nome = "Batalhão de Forças Especiais", Cor = Color3.fromRGB(139, 0, 0)},
    {Tag = "[CIE]", Nome = "Centro de Inteligência do Exército", Cor = Color3.fromRGB(105, 105, 105)},
    {Tag = "[BIP]", Nome = "Brigada de Infantaria Paraquedista", Cor = Color3.fromRGB(128, 0, 0)},
    {Tag = "[CAAT]", Nome = "Batalhão de Infantaria de Caatinga", Cor = Color3.fromRGB(85, 107, 47)},
    {Tag = "[CIGS]", Nome = "Centro de Instrução de Guerra na Selva", Cor = Color3.fromRGB(34, 139, 34)},
    {Tag = "[REC MEC]", Nome = "Regimento de Cavalaria Mecanizado", Cor = Color3.fromRGB(178, 34, 34)},
    {Tag = "[CYBER]", Nome = "Comando de Defesa Cibernética", Cor = Color3.fromRGB(0, 0, 128)}
}

local lastPatente = Patentes[1]
local lastDivisao = Divisoes[1]
local labelsCache = {}
local labelRoles = setmetatable({}, {__mode = "k"})

-- ================= SCANNER INTELIGENTE =================
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
                    local belongsToPlayer = (bg:IsDescendantOf(char) or (bg.Adornee and bg.Adornee:IsDescendantOf(char)))
                    
                    if belongsToPlayer and obj.Text ~= "" then
                        local role = labelRoles[obj]
                        
                        if not role then
                            local txt = obj.Text:lower()
                            local rawTxt = obj.Text
                            
                            if rawTxt:find(Player.Name) or rawTxt:find(Player.DisplayName) then
                                role = "Name"
                            elseif txt == "n/a" or txt:find("sem divisão") then
                                role = "Division"
                            elseif txt:find("aspirante") or txt:find("tenente") or txt:find("capitão") or txt:find("coronel") or txt:find("major") or txt:find("general") or txt:find("elite") or txt:find("marechal") or txt:find("recruta") or txt:find("soldado") or txt:find("cabo") or txt:find("sargento") or txt:find("cadete") or txt:find("criador") or txt:find("administrador") or txt:find("supervisor") or txt:find("moderador") or txt:find("sócio") or txt:find("comandante") then
                                role = "Rank"
                            end
                            
                            if not role then
                                for _, div in ipairs(Divisoes) do
                                    if txt:find(div.Tag:lower(), 1, true) then role = "Division" break end
                                end
                            end
                            if not role then
                                for _, pat in ipairs(Patentes) do
                                    if txt:find(pat.Tag:lower(), 1, true) then role = "Rank" break end
                                end
                            end

                            if role then
                                labelRoles[obj] = role
                            end
                        end
                        
                        if role == "Name" then
                            table.insert(newCache, {instance = obj, isNameLine = true})
                        elseif role == "Rank" then
                            table.insert(newCache, {instance = obj, isRankLine = true})
                        elseif role == "Division" then
                            table.insert(newCache, {instance = obj, isDivLine = true})
                        end
                    end
                end
            end
        end
    end
    labelsCache = newCache
end

task.spawn(function()
    while task.wait(1) do ScanForLabels() end
end)

-- ================= LOOP VISUAL =================
RunService.RenderStepped:Connect(function()
    if not lastPatente or not lastDivisao then return end
    
    local textoRank = lastPatente.Tag .. " " .. lastPatente.Nome
    local textoDiv = lastDivisao.Tag == "[N/A]" and "N/A" or (lastDivisao.Tag .. " " .. lastDivisao.Nome)

    for _, data in ipairs(labelsCache) do
        local label = data.instance
        if label and label.Parent then
            if data.isNameLine then
                if label.TextColor3 ~= lastPatente.Cor then label.TextColor3 = lastPatente.Cor end
            elseif data.isRankLine then
                if label.TextColor3 ~= lastPatente.Cor then label.TextColor3 = lastPatente.Cor end
                if label.Text ~= textoRank then label.Text = textoRank end
            elseif data.isDivLine then
                if label.TextColor3 ~= lastDivisao.Cor then label.TextColor3 = lastDivisao.Cor end
                if label.Text ~= textoDiv then label.Text = textoDiv end
            end
        end
    end
end)

-- ================= INTERFACE GRÁFICA =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KAIZER_MENU"
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
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.Text = "⚔️ PATENTES & DIVISÕES\nCreator: KAIZER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local PatTitle = Instance.new("TextLabel")
PatTitle.Size = UDim2.new(0.5, -10, 0, 20)
PatTitle.Position = UDim2.new(0, 5, 0, 55)
PatTitle.BackgroundTransparency = 1
PatTitle.Text = "🛡️ PATENTES / STAFF"
PatTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
PatTitle.Font = Enum.Font.GothamBold
PatTitle.TextSize = 12
PatTitle.Parent = MainFrame

local DivTitle = Instance.new("TextLabel")
DivTitle.Size = UDim2.new(0.5, -10, 0, 20)
DivTitle.Position = UDim2.new(0.5, 5, 0, 55)
DivTitle.BackgroundTransparency = 1
DivTitle.Text = "🔰 DIVISÕES"
DivTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
DivTitle.Font = Enum.Font.GothamBold
DivTitle.TextSize = 12
DivTitle.Parent = MainFrame

local ScrollPatentes = Instance.new("ScrollingFrame")
ScrollPatentes.Size = UDim2.new(0.5, -10, 1, -85)
ScrollPatentes.Position = UDim2.new(0, 5, 0, 75)
ScrollPatentes.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ScrollPatentes.BorderSizePixel = 0
ScrollPatentes.ScrollBarThickness = 4
ScrollPatentes.Parent = MainFrame

local currYPat = 5
for _, patente in ipairs(Patentes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, currYPat)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = ScrollPatentes

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = patente.Cor
    bar.BorderSizePixel = 0
    bar.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = patente.Tag .. " " .. patente.Nome
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 12
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
    currYPat = currYPat + 45
end
ScrollPatentes.CanvasSize = UDim2.new(0, 0, 0, currYPat)

local ScrollDivisoes = Instance.new("ScrollingFrame")
ScrollDivisoes.Size = UDim2.new(0.5, -10, 1, -85)
ScrollDivisoes.Position = UDim2.new(0.5, 5, 0, 75)
ScrollDivisoes.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ScrollDivisoes.BorderSizePixel = 0
ScrollDivisoes.ScrollBarThickness = 4
ScrollDivisoes.Parent = MainFrame

local currYDiv = 5
for _, divisao in ipairs(Divisoes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, currYDiv)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = ScrollDivisoes

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = divisao.Cor
    bar.BorderSizePixel = 0
    bar.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = divisao.Tag .. " " .. divisao.Nome
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    btn.MouseButton1Click:Connect(function()
        lastDivisao = divisao
        ScanForLabels()
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        task.wait(0.2)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end)
    currYDiv = currYDiv + 45
end
ScrollDivisoes.CanvasSize = UDim2.new(0, 0, 0, currYDiv)

local isOpen = false
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
end)

CloseBtn.MouseButton1Click:Connect(function()
    isOpen = false
    MainFrame.Visible = false
end)
