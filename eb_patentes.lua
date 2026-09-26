-- ==========================================
-- PATENTES E DIVISÕES EB (KAIZER V14) + FLUENT UI (CORRIGIDO)
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ================= BANCO DE DADOS =================
local Patentes = {
    {Tag = "[CR]", Nome = "Criador", Cor = Color3.fromRGB(233, 116, 81)}, 
    {Tag = "[SCR]", Nome = "Sub Criador", Cor = Color3.fromRGB(233, 116, 81)}, 
    {Tag = "[ADM-G]", Nome = "Administrador Geral", Cor = Color3.fromRGB(255, 255, 255)},
    {Tag = "[ADM]", Nome = "Administrador", Cor = Color3.fromRGB(255, 255, 255)},
    {Tag = "[SUP]", Nome = "Supervisor", Cor = Color3.fromRGB(255, 255, 255)},
    {Tag = "[MOD]", Nome = "Moderador", Cor = Color3.fromRGB(255, 255, 255)},
    {Tag = "[SC]", Nome = "Sócio", Cor = Color3.fromRGB(255, 255, 255)},
    {Tag = "[CMT]", Nome = "Comandante", Cor = Color3.fromRGB(255, 60, 60)},
    {Tag = "[SCMT]", Nome = "Subcomandante", Cor = Color3.fromRGB(255, 60, 60)},
    {Tag = "[ER]", Nome = "Elite Real", Cor = Color3.fromRGB(255, 125, 0)},
    {Tag = "[ES]", Nome = "Elite Secreta", Cor = Color3.fromRGB(255, 125, 0)},
    {Tag = "[EM]", Nome = "Elite Militar", Cor = Color3.fromRGB(255, 125, 0)},
    {Tag = "[GEN EX]", Nome = "General de Exército", Cor = Color3.fromRGB(210, 130, 50)},
    {Tag = "[GEN DV]", Nome = "General de Divisão", Cor = Color3.fromRGB(210, 130, 50)},
    {Tag = "[GEN BDA]", Nome = "General de Brigada", Cor = Color3.fromRGB(210, 130, 50)},
    {Tag = "[CEL]", Nome = "Coronel", Cor = Color3.fromRGB(255, 255, 0)},
    {Tag = "[TEN-CEL]", Nome = "Tenente Coronel", Cor = Color3.fromRGB(255, 255, 0)},
    {Tag = "[MAJ]", Nome = "Major", Cor = Color3.fromRGB(255, 255, 0)},
    {Tag = "[CAP]", Nome = "Capitão", Cor = Color3.fromRGB(255, 165, 0)},
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

                            if role then labelRoles[obj] = role end
                        end
                        
                        if role == "Name" then table.insert(newCache, {instance = obj, isNameLine = true})
                        elseif role == "Rank" then table.insert(newCache, {instance = obj, isRankLine = true})
                        elseif role == "Division" then table.insert(newCache, {instance = obj, isDivLine = true})
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

-- ================= BOTÃO FLUTUANTE PARA MOBILE =================
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "KaizerMobileToggle"
ToggleGui.ResetOnSpawn = false
local success = pcall(function() ToggleGui.Parent = game:GetService("CoreGui") end)
if not success then ToggleGui.Parent = PlayerGui end

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.5, -22, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "🛡️"
ToggleBtn.TextSize = 20
ToggleBtn.Parent = ToggleGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.5, 0)
Corner.Parent = ToggleBtn

local vim = game:GetService("VirtualInputManager")
ToggleBtn.MouseButton1Click:Connect(function()
    vim:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    vim:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
end)

-- ================= CARREGAMENTO DA INTERFACE FLUENT =================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Patentes & Divisões EB",
    SubTitle = "by KAIZER",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- CORRIGIDO: Usando AddTab em vez de CreateTab
local Tabs = {
    Main = Window:AddTab({ Title = "Gerenciar", Icon = "shield" })
}

-- ================= CRIANDO AS OPÇÕES =================
local nomesPatentes = {}
for _, p in ipairs(Patentes) do table.insert(nomesPatentes, p.Tag .. " " .. p.Nome) end

local nomesDivisoes = {}
for _, d in ipairs(Divisoes) do table.insert(nomesDivisoes, d.Tag .. " " .. d.Nome) end

local DropdownPatente = Tabs.Main:AddDropdown("DropPatente", {
    Title = "Selecione sua Patente",
    Values = nomesPatentes,
    Multi = false,
    Default = 1,
})

DropdownPatente:OnChanged(function(Value)
    for _, p in ipairs(Patentes) do
        if (p.Tag .. " " .. p.Nome) == Value then
            lastPatente = p
            ScanForLabels()
            break
        end
    end
end)

local DropdownDivisao = Tabs.Main:AddDropdown("DropDivisao", {
    Title = "Selecione sua Divisão",
    Values = nomesDivisoes,
    Multi = false,
    Default = 1,
})

DropdownDivisao:OnChanged(function(Value)
    for _, d in ipairs(Divisoes) do
        if (d.Tag .. " " .. d.Nome) == Value then
            lastDivisao = d
            ScanForLabels()
            break
        end
    end
end)

Window:SelectTab(1)
