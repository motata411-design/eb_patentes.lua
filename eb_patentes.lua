-- ==========================================
-- PATENTES E DIVISÕES EB (KAIZER V18) + DRONE PIXEL + KART
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

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
_G.AntiAFK = false

-- ================= FUNÇÕES GERAIS =================
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
                            if rawTxt:find(Player.Name) or rawTxt:find(Player.DisplayName) then role = "Name"
                            elseif txt == "n/a" or txt:find("sem divisão") then role = "Division"
                            elseif txt:find("aspirante") or txt:find("tenente") or txt:find("capitão") or txt:find("coronel") or txt:find("major") or txt:find("general") or txt:find("elite") or txt:find("marechal") or txt:find("recruta") or txt:find("soldado") or txt:find("cabo") or txt:find("sargento") or txt:find("cadete") or txt:find("criador") or txt:find("administrador") or txt:find("supervisor") or txt:find("moderador") or txt:find("sócio") or txt:find("comandante") then role = "Rank"
                            end
                            if not role then
                                for _, div in ipairs(Divisoes) do if txt:find(div.Tag:lower(), 1, true) then role = "Division" break end end
                            end
                            if not role then
                                for _, pat in ipairs(Patentes) do if txt:find(pat.Tag:lower(), 1, true) then role = "Rank" break end end
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
    while task.wait(1.5) do ScanForLabels() end
end)

-- ================= LOOP VISUAL COM REGRA DE CORES =================
RunService.RenderStepped:Connect(function()
    if not lastPatente or not lastDivisao then return end
    
    local textoRank = lastPatente.Tag .. " " .. lastPatente.Nome
    local textoDiv = lastDivisao.Tag == "[N/A]" and "N/A" or (lastDivisao.Tag .. " " .. lastDivisao.Nome)
    
    local corAplicada = (lastDivisao.Tag ~= "[N/A]") and lastDivisao.Cor or lastPatente.Cor

    for _, data in ipairs(labelsCache) do
        local label = data.instance
        if label and label.Parent then
            if data.isNameLine then
                if label.TextColor3 ~= corAplicada then label.TextColor3 = corAplicada end
            elseif data.isRankLine then
                if label.TextColor3 ~= corAplicada then label.TextColor3 = corAplicada end
                if label.Text ~= textoRank then label.Text = textoRank end
            elseif data.isDivLine then
                if label.TextColor3 ~= corAplicada then label.TextColor3 = corAplicada end
                if label.Text ~= textoDiv then label.Text = textoDiv end
            end
        end
    end
end)

Player.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- ================= BOTÃO FLUTUANTE ARRASTÁVEL =================
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "KaizerMobileToggle"
ToggleGui.ResetOnSpawn = false
local success = pcall(function() ToggleGui.Parent = game:GetService("CoreGui") end)
if not success then ToggleGui.Parent = PlayerGui end

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.5, -22, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "🛡️"
ToggleBtn.TextSize = 22
ToggleBtn.Active = false 
ToggleBtn.Parent = ToggleGui
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.5, 0)
Corner.Parent = ToggleBtn

local dragging, dragInput, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local vim = game:GetService("VirtualInputManager")
local clickTime = 0
ToggleBtn.MouseButton1Down:Connect(function() clickTime = tick() end)
ToggleBtn.MouseButton1Up:Connect(function()
    if tick() - clickTime < 0.3 then
        vim:SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
        task.wait(0.05)
        vim:SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
        GuiService.SelectedObject = nil 
    end
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
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Main = Window:AddTab({ Title = "Gerenciar", Icon = "shield" }),
    TP = Window:AddTab({ Title = "Teleporte", Icon = "map-pin" }),
    Utils = Window:AddTab({ Title = "Úteis", Icon = "wrench" }),
    Settings = Window:AddTab({ Title = "Configurações", Icon = "settings" })
}

-- ================= ABA 1: GERENCIAR PATENTES =================
local nomesPatentes = {}
for _, p in ipairs(Patentes) do table.insert(nomesPatentes, p.Tag .. " " .. p.Nome) end
local nomesDivisoes = {}
for _, d in ipairs(Divisoes) do table.insert(nomesDivisoes, d.Tag .. " " .. d.Nome) end

Tabs.Main:AddDropdown("DropPatente", { Title = "Selecione sua Patente", Values = nomesPatentes, Multi = false, Default = 1 }):OnChanged(function(Value)
    for _, p in ipairs(Patentes) do if (p.Tag .. " " .. p.Nome) == Value then lastPatente = p; ScanForLabels(); break end end
end)
Tabs.Main:AddDropdown("DropDivisao", { Title = "Selecione sua Divisão", Values = nomesDivisoes, Multi = false, Default = 1 }):OnChanged(function(Value)
    for _, d in ipairs(Divisoes) do if (d.Tag .. " " .. d.Nome) == Value then lastDivisao = d; ScanForLabels(); break end end
end)

local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player then table.insert(names, p.Name) end
    end
    return names
end

local CopyDrop = Tabs.Main:AddDropdown("CopyPlayer", { Title = "Copiar de Jogador", Values = getPlayerNames(), Multi = false, Default = 1 })
Tabs.Main:AddButton({ Title = "Aplicar Cópia", Callback = function()
    local targetName = CopyDrop.Value
    local target = Players:FindFirstChild(targetName)
    
    if target and target.Character then
        local foundPat, foundDiv = false, false
        local locaisBusca = {target.Character, PlayerGui}
        
        for _, area in ipairs(locaisBusca) do
            if area then
                for _, obj in ipairs(area:GetDescendants()) do
                    if obj:IsA("TextLabel") and obj.Text ~= "" then
                        local bg = obj:FindFirstAncestorWhichIsA("BillboardGui")
                        if bg and (bg:IsDescendantOf(target.Character) or (bg.Adornee and bg.Adornee:IsDescendantOf(target.Character))) then
                            local txt = obj.Text:lower()
                            if not foundPat then
                                for _, p in ipairs(Patentes) do if txt:find(p.Tag:lower(), 1, true) then lastPatente = p; foundPat = true; break end end
                            end
                            if not foundDiv then
                                for _, d in ipairs(Divisoes) do if txt:find(d.Tag:lower(), 1, true) then lastDivisao = d; foundDiv = true; break end end
                            end
                        end
                    end
                end
            end
        end
        ScanForLabels()
        if foundPat or foundDiv then
            Fluent:Notify({ Title = "Sucesso!", Content = "Patente copiada de " .. target.Name, Duration = 3 })
        else
            Fluent:Notify({ Title = "Erro", Content = "As tags desse jogador não foram identificadas.", Duration = 4 })
        end
    else
        Fluent:Notify({ Title = "Erro", Content = "Jogador não encontrado ou morto.", Duration = 3 })
    end
end})
Tabs.Main:AddButton({ Title = "🔄 Atualizar Lista de Jogadores", Callback = function() CopyDrop:SetValues(getPlayerNames()) end })

-- ================= ABA 2: TELEPORTE =================
local TPDrop = Tabs.TP:AddDropdown("TPPlayerDrop", { Title = "Selecione o Jogador", Values = getPlayerNames(), Multi = false, Default = 1 })
Tabs.TP:AddButton({ Title = "Teleportar para Jogador", Callback = function()
    local targetName = TPDrop.Value
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
    end
end})
Tabs.TP:AddButton({ Title = "🔄 Atualizar Lista de Jogadores", Callback = function() TPDrop:SetValues(getPlayerNames()) end })

Tabs.TP:AddButton({ Title = "📍 Pegar Tool de Click TP", Description = "Equipe a ferramenta e clique em qualquer lugar da tela para se teleportar.", Callback = function()
    local tpTool = Instance.new("Tool")
    tpTool.Name = "Click TP"
    tpTool.RequiresHandle = false
    tpTool.Parent = Player.Backpack

    tpTool.Activated:Connect(function()
        local mouse = Player:GetMouse()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    Fluent:Notify({ Title = "Click TP Gerado!", Content = "Abra seu inventário, equipe e clique no chão.", Duration = 4 })
end})

-- ================= ABA 3: ÚTEIS =================
Tabs.Utils:AddToggle("AntiAFKToggle", { Title = "Anti-AFK", Default = false }):OnChanged(function(Value) _G.AntiAFK = Value end)

Tabs.Utils:AddSlider("JumpPowerSlider", { Title = "Pulo (JumpPower)", Default = 50, Min = 50, Max = 200, Rounding = 0,
    Callback = function(Value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.UseJumpPower = true
            Player.Character.Humanoid.JumpPower = Value
        end
    end
})

-- KART RESTAURADO
Tabs.Utils:AddButton({ Title = "🏎️ Gerar Mini Kart (Anti-Kick)", Description = "Equipe no inventário para andar de kart.", Callback = function()
    local tool = Instance.new("Tool")
    tool.Name = "Mini Kart"
    tool.RequiresHandle = false
    tool.Parent = Player.Backpack

    local connection, speedGui, bv, kartModel

    tool.Equipped:Connect(function()
        local char = Player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not hrp or not humanoid then return end

        speedGui = Instance.new("ScreenGui")
        speedGui.Parent = PlayerGui
        local kmText = Instance.new("TextLabel")
        kmText.Size = UDim2.new(0, 150, 0, 50)
        kmText.Position = UDim2.new(0.5, -75, 0.8, 0)
        kmText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        kmText.BackgroundTransparency = 0.5
        kmText.TextColor3 = Color3.fromRGB(0, 255, 100)
        kmText.TextSize = 20
        kmText.Font = Enum.Font.GothamBold
        kmText.Text = "0 KM/H"
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.3, 0)
        corner.Parent = kmText
        kmText.Parent = speedGui

        kartModel = Instance.new("Model")
        kartModel.Name = "CustomKart"

        local rootCFrame = hrp.CFrame

        local chassis = Instance.new("Part")
        chassis.Name = "Chassis"
        chassis.Size = Vector3.new(4, 0.4, 6)
        chassis.Color = Color3.fromRGB(25, 25, 25)
        chassis.Material = Enum.Material.SmoothPlastic
        chassis.CanCollide = false
        chassis.CFrame = rootCFrame * CFrame.new(0, -2, 0)
        chassis.Parent = kartModel
        kartModel.PrimaryPart = chassis

        local corpo = Instance.new("Part")
        corpo.Size = Vector3.new(3.5, 0.8, 3.5)
        corpo.Color = Color3.fromRGB(200, 30, 30)
        corpo.Material = Enum.Material.SmoothPlastic
        corpo.CanCollide = false
        corpo.CFrame = chassis.CFrame * CFrame.new(0, 0.6, -0.8)
        corpo.Parent = kartModel

        local weldCorpo = Instance.new("WeldConstraint")
        weldCorpo.Part0 = chassis
        weldCorpo.Part1 = corpo
        weldCorpo.Parent = chassis

        local banco = Instance.new("Part")
        banco.Size = Vector3.new(2.6, 1.4, 0.4)
        banco.Color = Color3.fromRGB(10, 10, 10)
        banco.Material = Enum.Material.SmoothPlastic
        banco.CanCollide = false
        banco.CFrame = chassis.CFrame * CFrame.new(0, 0.9, 1.2)
        banco.Parent = kartModel

        local weldBanco = Instance.new("WeldConstraint")
        weldBanco.Part0 = chassis
        weldBanco.Part1 = banco
        weldBanco.Parent = chassis

        local offsetRodas = {
            Vector3.new(2.1, 0, 1.8),
            Vector3.new(-2.1, 0, 1.8),
            Vector3.new(2.1, 0, -1.8),
            Vector3.new(-2.1, 0, -1.8)
        }

        for _, offset in ipairs(offsetRodas) do
            local roda = Instance.new("Part")
            roda.Shape = Enum.PartType.Cylinder
            roda.Size = Vector3.new(0.8, 1.4, 1.4)
            roda.Color = Color3.fromRGB(15, 15, 15)
            roda.Material = Enum.Material.SmoothPlastic
            roda.CanCollide = false
            roda.CFrame = chassis.CFrame * CFrame.new(offset) * CFrame.Angles(0, 0, math.rad(90))
            roda.Parent = kartModel

            local weldRoda = Instance.new("WeldConstraint")
            weldRoda.Part0 = chassis
            weldRoda.Part1 = roda
            weldRoda.Parent = chassis
        end

        kartModel.Parent = char

        local mainWeld = Instance.new("Weld")
        mainWeld.Part0 = hrp
        mainWeld.Part1 = chassis
        mainWeld.C0 = CFrame.new(0, -1.8, 0)
        mainWeld.Parent = chassis

        humanoid.Sit = true

        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(100000, 0, 100000)
        bv.Parent = hrp

        connection = RunService.RenderStepped:Connect(function()
            if char:FindFirstChild("Humanoid") then
                local moveDir = char.Humanoid.MoveDirection
                bv.Velocity = moveDir * 110
                kmText.Text = math.floor(hrp.Velocity.Magnitude) .. " KM/H"

                if not humanoid.Sit then 
                    humanoid.Sit = true 
                end
            end
        end)
    end)

    tool.Unequipped:Connect(function()
        if connection then connection:Disconnect() end
        if speedGui then speedGui:Destroy() end
        if bv then bv:Destroy() end
        if kartModel then kartModel:Destroy() end
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.Sit = false
        end
    end)

    Fluent:Notify({ Title = "Kart Estabilizado", Content = "Equipe o item para testar.", Duration = 4 })
end})

-- ================= DRONE 100% MOBILE & COM MODELO CUSTOMIZADO =================
Tabs.Utils:AddButton({ Title = "🚁 Gerar Drone Mobile (Pixel)", Description = "Equipe para pilotar. Modelo idêntico à imagem de referência.", Callback = function()
    local tool = Instance.new("Tool")
    tool.Name = "Drone"
    tool.RequiresHandle = false
    tool.Parent = Player.Backpack

    local droneGui, goBtn, droneModel, droneRoot, droneSound, upBtn, downBtn
    local flightLoop
    local isFlying = false
    local flySpeed = 60
    local isAscending = false
    local isDescending = false

    local function stopDrone()
        isFlying = false
        if goBtn then 
            goBtn.Text = "GO (VOAR)"
            goBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        end
        if upBtn then upBtn.Visible = false end
        if downBtn then downBtn.Visible = false end
        
        if flightLoop then flightLoop:Disconnect() flightLoop = nil end
        if droneSound then droneSound:Destroy() droneSound = nil end
        if droneModel then droneModel:Destroy() droneModel = nil end
        
        local cam = workspace.CurrentCamera
        local char = Player.Character
        if char then 
            if char:FindFirstChild("Humanoid") then
                cam.CameraSubject = char.Humanoid
            end
            if char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Anchored = false
            end
        end
    end

    tool.Equipped:Connect(function()
        if droneGui then return end
        
        droneGui = Instance.new("ScreenGui")
        droneGui.Name = "DroneHUD_Mobile"
        droneGui.ResetOnSpawn = false
        droneGui.Parent = PlayerGui

        -- Botão GO/STOP agora posicionado mais para a direita (esquivando do centro)
        goBtn = Instance.new("TextButton")
        goBtn.Size = UDim2.new(0, 140, 0, 45)
        goBtn.Position = UDim2.new(0.70, -70, 0.15, 0) -- Ajustado para direita e topo
        goBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        goBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        goBtn.Font = Enum.Font.GothamBold
        goBtn.TextSize = 16
        goBtn.Text = "GO (VOAR)"
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.3, 0)
        corner.Parent = goBtn
        goBtn.Parent = droneGui

        -- Botão Subir (Mobile)
        upBtn = Instance.new("TextButton")
        upBtn.Size = UDim2.new(0, 60, 0, 60)
        upBtn.Position = UDim2.new(0.85, -30, 0.45, -35)
        upBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        upBtn.Font = Enum.Font.GothamBold
        upBtn.TextSize = 24
        upBtn.Text = "⬆️"
        upBtn.Visible = false
        local uCorner = Instance.new("UICorner")
        uCorner.CornerRadius = UDim.new(0.5, 0)
        uCorner.Parent = upBtn
        upBtn.Parent = droneGui

        -- Botão Descer (Mobile)
        downBtn = Instance.new("TextButton")
        downBtn.Size = UDim2.new(0, 60, 0, 60)
        downBtn.Position = UDim2.new(0.85, -30, 0.45, 35)
        downBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        downBtn.Font = Enum.Font.GothamBold
        downBtn.TextSize = 24
        downBtn.Text = "⬇️"
        downBtn.Visible = false
        local dCorner = Instance.new("UICorner")
        dCorner.CornerRadius = UDim.new(0.5, 0)
        dCorner.Parent = downBtn
        downBtn.Parent = droneGui

        upBtn.MouseButton1Down:Connect(function() isAscending = true end)
        upBtn.MouseButton1Up:Connect(function() isAscending = false end)
        downBtn.MouseButton1Down:Connect(function() isDescending = true end)
        downBtn.MouseButton1Up:Connect(function() isDescending = false end)

        goBtn.MouseButton1Click:Connect(function()
            if not isFlying then
                isFlying = true
                goBtn.Text = "STOP (VOLTAR)"
                goBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                upBtn.Visible = true
                downBtn.Visible = true

                local char = Player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                
                char.HumanoidRootPart.Anchored = true

                -- CRIANDO O MODELO DO DRONE BASEADO NA REFERÊNCIA PIXEL ART
                droneModel = Instance.new("Model")
                droneModel.Name = "KaizerDronePixel"
                droneModel.Parent = workspace

                -- Base invisível para controle de movimento
                droneRoot = Instance.new("Part")
                droneRoot.Name = "Root"
                droneRoot.Size = Vector3.new(2, 1, 2)
                droneRoot.Transparency = 1
                droneRoot.Anchored = true
                droneRoot.CanCollide = false
                droneRoot.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 6, -3)
                droneRoot.Parent = droneModel
                droneModel.PrimaryPart = droneRoot

                -- Função auxiliar para montar blocos grudados no Root
                local function createBlock(name, size, color, offset)
                    local p = Instance.new("Part")
                    p.Name = name
                    p.Size = size
                    p.Color = color
                    p.Material = Enum.Material.SmoothPlastic
                    p.Anchored = false
                    p.CanCollide = false
                    p.CFrame = droneRoot.CFrame * CFrame.new(offset)
                    p.Parent = droneModel
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = droneRoot
                    weld.Part1 = p
                    weld.Parent = droneRoot
                    return p
                end

                -- Corpo principal (Azul escuro)
                createBlock("CorpoMain", Vector3.new(1.2, 0.4, 1.8), Color3.fromRGB(13, 82, 214), Vector3.new(0, 0, 0))
                -- Cabine/Vidro (Azul claro)
                createBlock("Vidro", Vector3.new(0.8, 0.5, 1.2), Color3.fromRGB(115, 185, 255), Vector3.new(0, 0.15, -0.2))
                -- Ponta traseira / Frente
                createBlock("DetalheTrás", Vector3.new(0.6, 0.3, 0.6), Color3.fromRGB(20, 20, 20), Vector3.new(0, 0, 1.1))

                -- Posições das 4 hastes/rotores
                local posicoes = {
                    Vector3.new(1.2, 0, -1.2), -- Frente Direita
                    Vector3.new(-1.2, 0, -1.2), -- Frente Esquerda
                    Vector3.new(1.2, 0, 1.2), -- Traz Direita
                    Vector3.new(-1.2, 0, 1.2) -- Traz Esquerda
                }

                for i, pos in ipairs(posicoes) do
                    -- Hastes (Cinza escuro) ligando ao centro
                    createBlock("Haste"..i, Vector3.new(1.5, 0.2, 0.2), Color3.fromRGB(50, 50, 50), Vector3.new(pos.X/1.5, 0, pos.Z/1.5))
                    
                    -- Rotor (Base Branca/Azul clara simulando o círculo)
                    createBlock("Rotor"..i, Vector3.new(1, 0.1, 1), Color3.fromRGB(220, 230, 255), pos)
                    
                    -- Miolo Preto do Rotor (A cruz/ponto preto do meio)
                    createBlock("Miolo"..i, Vector3.new(0.4, 0.15, 0.4), Color3.fromRGB(10, 10, 10), pos)
                end

                -- Som
                droneSound = Instance.new("Sound")
                droneSound.SoundId = "rbxassetid://9114397531" 
                droneSound.Looped = true
                droneSound.Volume = 0.5
                droneSound.Parent = droneRoot
                droneSound:Play()

                -- Câmera acompanhando o Root do Drone
                local cam = workspace.CurrentCamera
                cam.CameraType = Enum.CameraType.Custom
                cam.CameraSubject = droneRoot

                -- Controle e Movimento
                flightLoop = RunService.RenderStepped:Connect(function(dt)
                    if not droneRoot or not droneRoot.Parent then return end
                    
                    local moveVector = Vector3.new(0,0,0)
                    if char and char:FindFirstChild("Humanoid") then
                        moveVector = char.Humanoid.MoveDirection
                    end

                    local vertical = 0
                    if isAscending then vertical = vertical + 1 end
                    if isDescending then vertical = vertical - 1 end

                    local finalMove = moveVector * flySpeed * dt
                    local verticalMove = Vector3.new(0, vertical * (flySpeed * 0.7) * dt, 0)

                    droneRoot.CFrame = droneRoot.CFrame + finalMove + verticalMove
                end)

            else
                stopDrone()
            end
        end)
    end)

    tool.Unequipped:Connect(function()
        if droneGui then droneGui:Destroy() droneGui = nil end
        stopDrone()
    end)

    Fluent:Notify({ Title = "Drone Pixel", Content = "Equipe a Tool para ver seu novo drone.", Duration = 4 })
end})

Tabs.Utils:AddButton({ Title = "Rejoin (Reconectar)", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player) end })
Tabs.Utils:AddButton({ Title = "Server Hop", Callback = function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in ipairs(servers.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Player)
            break
        end
    end
end})

-- ================= ABA 4: CONFIGURAÇÕES =================
Tabs.Settings:AddDropdown("ThemeDrop", { Title = "Tema da Interface", Values = {"Light", "Dark", "Darker", "Aqua", "Amethyst", "Rose"}, Multi = false, Default = 2 }):OnChanged(function(Value) Fluent:SetTheme(Value) end)

-- ================= NOTIFICAÇÃO DE INÍCIO =================
Fluent:Notify({
    Title = "Bem-vindo!",
    Content = "E O KAIZER BB",
    Duration = 5
})

Window:SelectTab(1)
