local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ESP Settings
local tracerColor = Color3.fromRGB(255, 105, 180) -- Rosa
local boxColor = Color3.fromRGB(255, 0, 0) -- Vermelho
local lineThickness = 1

-- Função para criar uma linha (Drawing API)
local function createLine()
	local line = Drawing.new("Line")
	line.Thickness = lineThickness
	line.Transparency = 1
	line.Visible = true
	return line
end

-- Função para criar uma caixa (com 4 linhas)
local function createBox()
	return {
		Top = createLine(),
		Bottom = createLine(),
		Left = createLine(),
		Right = createLine(),
	}
end

-- Armazena os desenhos por jogador
local drawings = {}

-- Atualização por frame
RunService.RenderStepped:Connect(function()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
			local hrp = player.Character.HumanoidRootPart
			local humanoid = player.Character:FindFirstChild("Humanoid")

			if humanoid.Health > 0 then
				local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

				if onScreen then
					-- Criar/desenhar se ainda não existe
					if not drawings[player] then
						drawings[player] = {
							tracer = createLine(),
							box = createBox()
						}
					end

					local height = 3
					local width = 2

					local topLeft = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(-width, height, 0))
					local topRight = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(width, height, 0))
					local bottomLeft = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(-width, -height, 0))
					local bottomRight = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(width, -height, 0))

					-- Tracer (linha do meio da tela ao pé do player)
					local tracer = drawings[player].tracer
					tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
					tracer.To = Vector2.new(pos.X, pos.Y)
					tracer.Color = tracerColor
					tracer.Visible = true

					-- Caixa (4 linhas)
					local box = drawings[player].box
					box.Top.From = Vector2.new(topLeft.X, topLeft.Y)
					box.Top.To = Vector2.new(topRight.X, topRight.Y)
					box.Top.Color = boxColor
					box.Top.Visible = true

					box.Bottom.From = Vector2.new(bottomLeft.X, bottomLeft.Y)
					box.Bottom.To = Vector2.new(bottomRight.X, bottomRight.Y)
					box.Bottom.Color = boxColor
					box.Bottom.Visible = true

					box.Left.From = Vector2.new(topLeft.X, topLeft.Y)
					box.Left.To = Vector2.new(bottomLeft.X, bottomLeft.Y)
					box.Left.Color = boxColor
					box.Left.Visible = true

					box.Right.From = Vector2.new(topRight.X, topRight.Y)
					box.Right.To = Vector2.new(bottomRight.X, bottomRight.Y)
					box.Right.Color = boxColor
					box.Right.Visible = true
				else
					-- Fora da tela, ocultar
					if drawings[player] then
						drawings[player].tracer.Visible = false
						for _, line in pairs(drawings[player].box) do
							line.Visible = false
						end
					end
				end
			end
		elseif drawings[player] then
			-- Jogador morreu ou não carregado, remover/desativar desenho
			drawings[player].tracer.Visible = false
			for _, line in pairs(drawings[player].box) do
				line.Visible = false
			end
		end
	end
end)
