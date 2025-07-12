-- Script local em StarterPlayer -> StarterPlayerScripts -> LocalScript

-- Criando o GUI principal
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Criando o ícone flutuante
local ninjaIcon = Instance.new("ImageLabel")
ninjaIcon.Size = UDim2.new(0, 50, 0, 50)
ninjaIcon.Position = UDim2.new(0.5, -25, 0.5, -25)
ninjaIcon.BackgroundTransparency = 1
ninjaIcon.Image = "rbxassetid://ID_DO_ICONE_AQUI" -- Substitua pelo ID do seu ícone
ninjaIcon.Parent = screenGui

-- Função para mover o ícone flutuante
game:GetService("RunService").RenderStepped:Connect(function()
    local targetPosition = mouse.Hit.p
    ninjaIcon.Position = UDim2.new(0, targetPosition.X / 10, 0, targetPosition.Y / 10) -- Ajuste conforme necessário
end)

-- Função para criar o ESP (tracers e caixa)
local function createESP(target)
    if not target:IsA("Model") or not target:FindFirstChild("Humanoid") then return end
    
    -- Criando a caixa
    local espFrame = Instance.new("Frame")
    espFrame.Size = UDim2.new(0, 50, 0, 50)  -- Ajuste o tamanho da caixa
    espFrame.BackgroundColor3 = target.TeamColor.Color  -- Cor do time
    espFrame.BackgroundTransparency = 0.5
    espFrame.BorderSizePixel = 0
    espFrame.Parent = screenGui

    -- Criando o tracer (linha)
    local tracerLine = Instance.new("LineHandleAdornment")
    tracerLine.Adornee = target.HumanoidRootPart
    tracerLine.Length = (target.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
    tracerLine.Color3 = target.TeamColor.Color
    tracerLine.Parent = workspace

    -- Atualizando posição da caixa e da linha
    game:GetService("RunService").RenderStepped:Connect(function()
        local screenPosition = workspace.CurrentCamera:WorldToScreenPoint(target.HumanoidRootPart.Position)
        espFrame.Position = UDim2.new(0, screenPosition.X - 25, 0, screenPosition.Y - 25)
        tracerLine.WorldPosition = player.Character.HumanoidRootPart.Position
    end)
end

-- Atualizando o ESP para todos os inimigos
game:GetService("Players").PlayerAdded:Connect(function(newPlayer)
    if newPlayer.Team ~= player.Team then
        createESP(newPlayer.Character)
    end
end)

-- Função de auto subir nível (Exemplo: Aumentando a saúde)
local autoLevelingEnabled = true
local function autoLevel()
    while autoLevelingEnabled do
        wait(1)
        if player.Character then
            -- Exemplo: Aumentar a saúde
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.Health + 10  -- Incrementa saúde
            end
        end
    end
end

-- Iniciar o auto-leveling quando o script rodar
autoLevel()

-- Seleção de Arma (Melee, Weapon, Blox Fruit, Sword)
local armas = {"Melee", "Weapon", "Blox Fruit", "Sword"}  -- Lista de armas
local armaSelecionada = armas[1]  -- Arma padrão

-- Criando o botão da GUI para seleção de armas
local weaponButton = Instance.new("TextButton")
weaponButton.Size = UDim2.new(0, 200, 0, 50)
weaponButton.Position = UDim2.new(0, 50, 0, 100)
weaponButton.Text = "Selecionar Arma"
weaponButton.Parent = screenGui

-- Função para trocar a arma
local function trocarArma()
    local currentIndex = table.find(armas, armaSelecionada)
    currentIndex = currentIndex % #armas + 1  -- Vai para a próxima arma
    armaSelecionada = armas[currentIndex]
    weaponButton.Text = "Arma: " .. armaSelecionada
    -- Aqui, você pode adicionar a lógica para trocar de arma no jogo
    trocarArmaNoJogo(armaSelecionada)  -- Chama a função para equipar a arma
end

-- Função chamada ao clicar no botão
weaponButton.MouseButton1Click:Connect(trocarArma)

-- Função para trocar a arma no jogo
local function trocarArmaNoJogo(armaSelecionada)
    if armaSelecionada == "Melee" then
        -- Exemplo: equipar uma arma de soco ou melee
        print("Equipando arma de Melee")
        -- Código para equipar a arma melee
    elseif armaSelecionada == "Weapon" then
        -- Exemplo: equipar uma arma de longo alcance, como uma pistola
        print("Equipando arma de Weapon (ex: pistola)")
        -- Código para equipar a arma de ranged
    elseif armaSelecionada == "Blox Fruit" then
        -- Exemplo: adicionar poder de Blox Fruit
        print("Usando poder de Blox Fruit")
        -- Código para equipar o poder de uma Blox Fruit
    elseif armaSelecionada == "Sword" then
        -- Exemplo: equipar uma espada
        print("Equipando Sword")
        -- Código para equipar uma espada
    end
end
