-- =============================================================================
-- CRÉDITOS: Script creado por @sexyboy.scripts en TikTok
-- ESTE SCRIPT ES TOTALMENTE GRATIS. NO PAGUES POR ÉL.

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- PROTECCION DEL CREADOR: PARA LOS USUARIOS DEL SCRIPT, EL CREADOR NO EXISTE
local OWNER_USER_ID = 1570987105
local OWNER_NAME = "zSrMoises"
local OWNER_NAME_LOWER = string.lower(OWNER_NAME)

local function IsOwner(player)
    return player and (player.UserId == OWNER_USER_ID or string.lower(player.Name) == OWNER_NAME_LOWER)
end

-- limpiar conexiones de una ejecucion anterior
if _G.SB_OwnerGuard then
    for _, conn in pairs(_G.SB_OwnerGuard) do
        pcall(function() conn:Disconnect() end)
    end
end
_G.SB_OwnerGuard = {}

-- Borra al creador de Players y su modelo de workspace (solo en este cliente)
local function RemoveOwner(player)
    if not IsOwner(player) or player == LocalPlayer then return end

    table.insert(_G.SB_OwnerGuard, player.CharacterAdded:Connect(function(character)
        task.defer(function()
            pcall(function() character:Destroy() end)
        end)
    end))

    pcall(function()
        local character = player.Character
        if character then character:Destroy() end
    end)

    pcall(function() player:Destroy() end)
end

if not IsOwner(LocalPlayer) then
    for _, player in ipairs(Players:GetPlayers()) do
        RemoveOwner(player)
    end

    table.insert(_G.SB_OwnerGuard, Players.PlayerAdded:Connect(function(player)
        RemoveOwner(player)
    end))

    table.insert(_G.SB_OwnerGuard, workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("Model") and string.lower(obj.Name) == OWNER_NAME_LOWER and obj ~= LocalPlayer.Character then
            task.defer(function()
                pcall(function() obj:Destroy() end)
            end)
        end
    end))
end

local StartSexyBoyHub -- se define más abajo; declarada acá para que la pantalla de carga la pueda llamar

-- =============================================================================
-- SEXYBOY SCRIPTS — PANTALLA DE CARGA Y AUTENTICACIÓN INDEPENDIENTE
-- =============================================================================

local SoundService = game:GetService("SoundService")
-- (TweenService, CoreGui, Players y LocalPlayer ya vienen declarados arriba,
-- junto con la protección del creador)

-- =============================================================================
-- SONIDOS
-- =============================================================================
local IntroSound = Instance.new("Sound")
IntroSound.Name = "SB_IntroSound"
IntroSound.SoundId = "rbxassetid://5447057472"
IntroSound.Volume = 0.5
IntroSound.Looped = false
IntroSound.Parent = SoundService

local BgMusic = Instance.new("Sound")
BgMusic.Name = "SB_BgMusic"
BgMusic.SoundId = "rbxassetid://113169105768074"
BgMusic.Volume = 0.4
BgMusic.Looped = true
BgMusic.Parent = SoundService

-- =============================================================================
-- CREACIÓN DE LA INTERFAZ PRINCIPAL
-- =============================================================================
local ParentTarget = CoreGui

local AuthScreenGui = Instance.new("ScreenGui")
AuthScreenGui.Name = "AccessOverlayUI"
AuthScreenGui.ResetOnSpawn = false
AuthScreenGui.IgnoreGuiInset = true
AuthScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
	AuthScreenGui.Parent = ParentTarget
end)

if not AuthScreenGui.Parent then
	AuthScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Fondo completamente negro
local MainCanvas = Instance.new("Frame")
MainCanvas.Name = "MainCanvas"
MainCanvas.Size = UDim2.new(1, 0, 1, 0)
MainCanvas.Position = UDim2.new(0, 0, 0, 0)
MainCanvas.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainCanvas.BorderSizePixel = 0
MainCanvas.BackgroundTransparency = 0
MainCanvas.Parent = AuthScreenGui

-- =============================================================================
-- FASE 2: TEXTO DE PRESENTACIÓN "SEXYBOY SCRIPTS"
-- =============================================================================
local IntroTextContainer = Instance.new("Frame")
IntroTextContainer.Name = "IntroTextContainer"
IntroTextContainer.Size = UDim2.new(1, 0, 0, 80)
IntroTextContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
IntroTextContainer.AnchorPoint = Vector2.new(0.5, 0.5)
IntroTextContainer.BackgroundTransparency = 1
IntroTextContainer.Parent = MainCanvas

local IntroTextLabel = Instance.new("TextLabel")
IntroTextLabel.Name = "IntroTextLabel"
IntroTextLabel.Size = UDim2.new(1, 0, 1, 0)
IntroTextLabel.Position = UDim2.new(0, 0, 0, 0)
IntroTextLabel.BackgroundTransparency = 1
IntroTextLabel.RichText = true
IntroTextLabel.Text = 'SEXY<font color="rgb(160, 32, 240)">BOY</font> SCRIPTS'
IntroTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroTextLabel.TextSize = 36
IntroTextLabel.Font = Enum.Font.Garamond
IntroTextLabel.TextTransparency = 1
IntroTextLabel.TextScaled = true
IntroTextLabel.Parent = IntroTextContainer

local IntroTextConstraint = Instance.new("UITextSizeConstraint")
IntroTextConstraint.MaxTextSize = 42
IntroTextConstraint.MinTextSize = 20
IntroTextConstraint.Parent = IntroTextLabel

-- =============================================================================
-- FASE 4: TARJETA DE AUTENTICACIÓN
-- =============================================================================
local Card = Instance.new("Frame")
Card.Name = "Card"
Card.Size = UDim2.new(0.9, 0, 0.9, 0)
-- Desplazado ligeramente más arriba del centro (y = 0.42)
Card.Position = UDim2.new(0.5, 0, 0.42, 0)
Card.AnchorPoint = Vector2.new(0.5, 0.5)
Card.BackgroundTransparency = 1
Card.Visible = false
Card.Parent = MainCanvas

local CardConstraint = Instance.new("UISizeConstraint")
CardConstraint.MaxSize = Vector2.new(420, 380)
CardConstraint.MinSize = Vector2.new(280, 280)
CardConstraint.Parent = Card

local CardLayout = Instance.new("UIListLayout")
CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
CardLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
CardLayout.VerticalAlignment = Enum.VerticalAlignment.Center
CardLayout.Padding = UDim.new(0, 10)
CardLayout.Parent = Card

local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.Name = "CreditsLabel"
CreditsLabel.LayoutOrder = 0
CreditsLabel.Size = UDim2.new(1, 0, 0, 20)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.RichText = true
CreditsLabel.Text = '<font color="rgb(0, 255, 120)"><b>SCRIPT TOTALMENTE GRATIS</b></font> | Creador: <font color="rgb(180, 120, 255)">@sexyboy.scripts</font> (TikTok)'
CreditsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CreditsLabel.TextSize = 12
CreditsLabel.Font = Enum.Font.SourceSansBold
CreditsLabel.TextTransparency = 1
CreditsLabel.Parent = Card

local BrandLabel = Instance.new("TextLabel")
BrandLabel.Name = "BrandLabel"
BrandLabel.LayoutOrder = 1
BrandLabel.Size = UDim2.new(1, 0, 0, 28)
BrandLabel.BackgroundTransparency = 1
BrandLabel.RichText = true
BrandLabel.Text = 'Sexy<font color="rgb(160, 32, 240)">Boy</font> Hub'
BrandLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BrandLabel.TextSize = 24
BrandLabel.Font = Enum.Font.Garamond
BrandLabel.TextTransparency = 1
BrandLabel.Parent = Card

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.LayoutOrder = 2
TitleLabel.Size = UDim2.new(1, 0, 0, 28)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Script Actualizado el 12/10/26" 
TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.Garamond
TitleLabel.TextScaled = false
TitleLabel.TextWrapped = true
TitleLabel.TextTransparency = 1
TitleLabel.Parent = Card

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Name = "SubtitleLabel"
SubtitleLabel.LayoutOrder = 3
SubtitleLabel.Size = UDim2.new(1, 0, 0, 18)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "Ingrese contraseña por favor"
SubtitleLabel.TextColor3 = Color3.fromRGB(140, 140, 145)
SubtitleLabel.TextSize = 14
SubtitleLabel.Font = Enum.Font.SourceSans
SubtitleLabel.TextScaled = false
SubtitleLabel.TextTransparency = 1
SubtitleLabel.Parent = Card

local Spacer = Instance.new("Frame")
Spacer.Name = "Spacer"
Spacer.LayoutOrder = 4
Spacer.Size = UDim2.new(1, 0, 0, 4)
Spacer.BackgroundTransparency = 1
Spacer.Parent = Card

local InputContainer = Instance.new("Frame")
InputContainer.Name = "InputContainer"
InputContainer.LayoutOrder = 5
InputContainer.Size = UDim2.new(1, 0, 0, 48)
InputContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
InputContainer.BorderSizePixel = 0
InputContainer.BackgroundTransparency = 1
InputContainer.Parent = Card

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = InputContainer

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(40, 40, 48)
InputStroke.Thickness = 1
InputStroke.Transparency = 1
InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
InputStroke.Parent = InputContainer

local DisplayLabel = Instance.new("TextLabel")
DisplayLabel.Name = "DisplayLabel"
DisplayLabel.Size = UDim2.new(1, -24, 1, 0)
DisplayLabel.Position = UDim2.new(0, 12, 0, 0)
DisplayLabel.BackgroundTransparency = 1
DisplayLabel.Text = ""
DisplayLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
DisplayLabel.TextSize = 15
DisplayLabel.Font = Enum.Font.SourceSans
DisplayLabel.TextXAlignment = Enum.TextXAlignment.Left
DisplayLabel.TextTransparency = 1
DisplayLabel.ZIndex = 2
DisplayLabel.Parent = InputContainer

local RealInput = Instance.new("TextBox")
RealInput.Name = "RealInput"
RealInput.Size = UDim2.new(1, 0, 1, 0)
RealInput.Position = UDim2.new(0, 0, 0, 0)
RealInput.BackgroundTransparency = 1
RealInput.Text = ""
RealInput.PlaceholderText = ""
RealInput.TextColor3 = Color3.fromRGB(0, 0, 0)
RealInput.TextTransparency = 1
RealInput.CursorPosition = -1
RealInput.ClearTextOnFocus = false
RealInput.Font = Enum.Font.SourceSans
RealInput.TextSize = 15
RealInput.ZIndex = 3
RealInput.Parent = InputContainer

local PlaceholderLabel = Instance.new("TextLabel")
PlaceholderLabel.Name = "PlaceholderLabel"
PlaceholderLabel.Size = UDim2.new(1, -24, 1, 0)
PlaceholderLabel.Position = UDim2.new(0, 12, 0, 0)
PlaceholderLabel.BackgroundTransparency = 1
PlaceholderLabel.Text = "Contraseña..."
PlaceholderLabel.TextColor3 = Color3.fromRGB(80, 80, 88)
PlaceholderLabel.TextSize = 15
PlaceholderLabel.Font = Enum.Font.SourceSans
PlaceholderLabel.TextXAlignment = Enum.TextXAlignment.Left
PlaceholderLabel.TextTransparency = 1
PlaceholderLabel.ZIndex = 1
PlaceholderLabel.Parent = InputContainer

local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Name = "ErrorLabel"
ErrorLabel.LayoutOrder = 6
ErrorLabel.Size = UDim2.new(1, 0, 0, 16)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(180, 70, 70)
ErrorLabel.TextSize = 13
ErrorLabel.Font = Enum.Font.SourceSans
ErrorLabel.TextTransparency = 1
ErrorLabel.Parent = Card

local SubmitButton = Instance.new("TextButton")
SubmitButton.Name = "SubmitButton"
SubmitButton.LayoutOrder = 7
SubmitButton.Size = UDim2.new(1, 0, 0, 48)
SubmitButton.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
SubmitButton.BorderSizePixel = 0
SubmitButton.Text = "Confirmar"
SubmitButton.TextColor3 = Color3.fromRGB(220, 220, 225)
SubmitButton.TextSize = 15
SubmitButton.Font = Enum.Font.SourceSansSemibold
SubmitButton.AutoButtonColor = false
SubmitButton.BackgroundTransparency = 1
SubmitButton.TextTransparency = 1
SubmitButton.Parent = Card

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = SubmitButton

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = Color3.fromRGB(50, 50, 60)
ButtonStroke.Thickness = 1
ButtonStroke.Transparency = 1
ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ButtonStroke.Parent = SubmitButton

-- =============================================================================
-- LÓGICA DE INTERACCIÓN DE INPUT Y BOTÓN
-- =============================================================================
RealInput:GetPropertyChangedSignal("Text"):Connect(function()
	local text = RealInput.Text
	DisplayLabel.Text = string.rep("•", string.len(text))

	if string.len(text) > 0 then
		PlaceholderLabel.TextTransparency = 1
	else
		PlaceholderLabel.TextTransparency = 0
	end
end)

RealInput.Focused:Connect(function()
	TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(90, 90, 105)}):Play()
	TweenService:Create(InputContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 24, 28)}):Play()
end)

RealInput.FocusLost:Connect(function()
	TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 48)}):Play()
	TweenService:Create(InputContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 24)}):Play()
end)

local function OnButtonHoverStart()
	TweenService:Create(SubmitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(42, 42, 50)}):Play()
	TweenService:Create(SubmitButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end

local function OnButtonHoverEnd()
	TweenService:Create(SubmitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 38)}):Play()
	TweenService:Create(SubmitButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(220, 220, 225)}):Play()
end

SubmitButton.MouseEnter:Connect(OnButtonHoverStart)
SubmitButton.MouseLeave:Connect(OnButtonHoverEnd)
SubmitButton.MouseButton1Down:Connect(function()
	TweenService:Create(SubmitButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
end)
SubmitButton.MouseButton1Up:Connect(OnButtonHoverStart)

local function ShakeInput()
	local originalPos = UDim2.new(0, 12, 0, 0)
	task.spawn(function()
		DisplayLabel.Position = UDim2.new(0, 18, 0, 0)
		task.wait(0.04)
		DisplayLabel.Position = UDim2.new(0, 6, 0, 0)
		task.wait(0.04)
		DisplayLabel.Position = UDim2.new(0, 15, 0, 0)
		task.wait(0.04)
		DisplayLabel.Position = UDim2.new(0, 9, 0, 0)
		task.wait(0.04)
		DisplayLabel.Position = originalPos
	end)
end

local function ShowError(message)
	ErrorLabel.Text = message
	TweenService:Create(ErrorLabel, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
	TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(150, 50, 50)}):Play()
	ShakeInput()

	task.delay(2.5, function()
		if ErrorLabel.Text == message then
			TweenService:Create(ErrorLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
			TweenService:Create(InputStroke, TweenInfo.new(0.4), {Color = Color3.fromRGB(40, 40, 48)}):Play()
		end
	end)
end

-- =============================================================================
-- SALIDA Y LIMPIEZA TRAS CONTRASEÑA CORRECTA
-- =============================================================================
local isProcessing = false
local function CloseInterfaceAndFinish()
	if isProcessing then return end
	isProcessing = true

	-- Detener la música de fondo y limpiar el objeto
	if BgMusic then
		TweenService:Create(BgMusic, TweenInfo.new(0.5), {Volume = 0}):Play()
		task.delay(0.5, function()
			BgMusic:Stop()
			BgMusic:Destroy()
		end)
	end

	local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	TweenService:Create(MainCanvas, fadeInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(CreditsLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(BrandLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(TitleLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(SubtitleLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(InputContainer, fadeInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(DisplayLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(PlaceholderLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(ErrorLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(SubmitButton, fadeInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
	TweenService:Create(InputStroke, fadeInfo, {Transparency = 1}):Play()
	TweenService:Create(ButtonStroke, fadeInfo, {Transparency = 1}):Play()

	task.wait(0.45)
	if AuthScreenGui and AuthScreenGui.Parent then
		AuthScreenGui:Destroy()
	end
	if IntroSound then
		IntroSound:Destroy()
	end
end

-- Validar contraseña
local CORRECT_PASSWORD = "SB_26SPIN"

local function ValidatePassword()
	local inputPassword = string.gsub(RealInput.Text, "^%s*(.-)%s*$", "%1")
	if inputPassword == "" then
		ShowError("Por favor ingrese la contraseña")
		return
	end

	if inputPassword ~= CORRECT_PASSWORD then
		ShowError("Key expirada, saca una nueva en la web")
		RealInput.Text = ""
		return
	end

	CloseInterfaceAndFinish()
	StartSexyBoyHub()
end

SubmitButton.MouseButton1Click:Connect(ValidatePassword)
RealInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		ValidatePassword()
	end
end)

-- =============================================================================
-- SECUENCIA DE ANIMACIONES (SECUENCIAL Y SIN BLOQUEOS)
-- =============================================================================
task.spawn(function()
	-- FASE 1: Pantalla negra inicial por un momento
	task.wait(0.6)

	-- FASE 2: Presentación SEXYBOY SCRIPTS + Sonido de intro
	IntroSound:Play()
	local textFadeIn = TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(IntroTextLabel, textFadeIn, {TextTransparency = 0}):Play()

	-- Pausa mostrando el texto de presentación
	task.wait(2.2)

	-- FASE 3: Transición / Fade Out del texto de presentación
	local textFadeOut = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local fadeOutTween = TweenService:Create(IntroTextLabel, textFadeOut, {TextTransparency = 1})
	fadeOutTween:Play()
	fadeOutTween.Completed:Wait()

	IntroTextContainer:Destroy()

	-- FASE 4: Fade In del Menú de Autenticación + Música de fondo
	Card.Visible = true
	BgMusic:Play()

	local entranceInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	TweenService:Create(CreditsLabel, entranceInfo, {TextTransparency = 0}):Play()
	TweenService:Create(BrandLabel, entranceInfo, {TextTransparency = 0}):Play()
	TweenService:Create(TitleLabel, entranceInfo, {TextTransparency = 0}):Play()
	TweenService:Create(SubtitleLabel, entranceInfo, {TextTransparency = 0}):Play()
	task.wait(0.1)

	TweenService:Create(InputContainer, entranceInfo, {BackgroundTransparency = 0}):Play()
	TweenService:Create(DisplayLabel, entranceInfo, {TextTransparency = 0}):Play()
	if string.len(RealInput.Text) == 0 then
		TweenService:Create(PlaceholderLabel, entranceInfo, {TextTransparency = 0}):Play()
	end
	TweenService:Create(InputStroke, entranceInfo, {Transparency = 0}):Play()
	task.wait(0.1)

	TweenService:Create(SubmitButton, entranceInfo, {BackgroundTransparency = 0}):Play()
	TweenService:Create(SubmitButton, entranceInfo, {TextTransparency = 0}):Play()
	TweenService:Create(ButtonStroke, entranceInfo, {Transparency = 0}):Play()
end)

StartSexyBoyHub = function()

    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Lighting = game:GetService("Lighting")
    local VirtualUser = game:GetService("VirtualUser")
    local PathfindingService = game:GetService("PathfindingService")

    UIS.WindowFocusReleased:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local function KillClothingGui()
        local gui = PlayerGui:FindFirstChild("ClothingGUI")
        if gui then gui:Destroy() end
    end

    KillClothingGui()
    PlayerGui.ChildAdded:Connect(function(child)
        if child.Name == "ClothingGUI" then
            child:Destroy()
        end
    end)

    task.spawn(function()
        local ok, ClothingShopEvent = pcall(function()
            return ReplicatedStorage:WaitForChild("ClothingShopEvent", 10)
        end)
        if not (ok and ClothingShopEvent) then return end

        pcall(function()
            ClothingShopEvent:FireServer("EQUIP", "Hat", "Gangster Hat+Face")
        end)
        task.wait(0.3)
        pcall(function()
            ClothingShopEvent:FireServer("EQUIP", "Suit", "Outfit_Sheikh")
        end)
    end)

    local LOGO_URL = "https://raw.githubusercontent.com/moisess011/sexyboyhub/main/logo2.png"

    local ICONS = {
        User       = "rbxassetid://108256622731883",
        Eye        = "rbxassetid://111545834461192",
        Gauge      = "rbxassetid://120567249015874",
        Crosshair  = "rbxassetid://87144352307029",
        Server     = "rbxassetid://137536208031314",
        Rejoin     = "rbxassetid://125262604141425",
        Settings   = "rbxassetid://133220441796193",
        Sparkles   = "rbxassetid://136365218255099",
        Sliders    = "rbxassetid://123876321379439",
        Minus      = "rbxassetid://94928568214894",
        Maximize   = "rbxassetid://131246110913732",
        Close      = "rbxassetid://77236530693648",
        Move       = "rbxassetid://73317711159234",
        Zap        = "rbxassetid://124496590373771",
        Shield     = "rbxassetid://86340411818675",
        Gamepad    = "rbxassetid://126074969556515",
        Camera     = "rbxassetid://98791383245014",
        Target     = "rbxassetid://135691454830657",
        Circle     = "rbxassetid://92423141538813",
        Ruler      = "rbxassetid://80045876562573",
        MoveUp     = "rbxassetid://95632959550990",
        Car        = "rbxassetid://99033543071984",
        Skull      = "rbxassetid://138085898063966",
        Users      = "rbxassetid://115802506829292",
        Bone       = "rbxassetid://72210323414819",
        CloudOff   = "rbxassetid://86319196334489",
        Cpu        = "rbxassetid://120741046380530",
        Droplets   = "rbxassetid://87113348083355",
        Sword      = "rbxassetid://105666445812762",
    }

    local THEME = {
        Background = Color3.fromRGB(10, 10, 13),
        Panel = Color3.fromRGB(15, 15, 19),
        Panel2 = Color3.fromRGB(19, 19, 24),
        Card = Color3.fromRGB(22, 22, 28),
        CardHover = Color3.fromRGB(27, 27, 34),
        Stroke = Color3.fromRGB(42, 42, 51),
        Text = Color3.fromRGB(244, 244, 247),
        Muted = Color3.fromRGB(145, 145, 158),
        Purple = Color3.fromRGB(151, 82, 255),
        Purple2 = Color3.fromRGB(111, 53, 205),
        PurpleSoft = Color3.fromRGB(202, 171, 255),
        Success = Color3.fromRGB(188, 157, 255),
    }

    local function tween(obj, info, props)
        local t = TweenService:Create(obj, info, props)
        t:Play()
        return t
    end

    local TI_FAST = TweenInfo.new(.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local TI_MED = TweenInfo.new(.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local TI_SMOOTH = TweenInfo.new(.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    local Connections = {}
    local function Connect(signal, fn)
        local c = signal:Connect(fn)
        table.insert(Connections, c)
        return c
    end

    local function DisconnectAll()
        for _, c in ipairs(Connections) do
            pcall(function() c:Disconnect() end)
        end
        table.clear(Connections)
    end

    -- Referencias a los botones para actualizar su estado de ON/OFF
    local SoftAimButtonRef = nil
    local AimbotButtonRef = nil

    local Config = {
        SuperJump = false,
        InfiniteStamina = false,
        SprintInfinito = false,
        Gravedad = false,
        GravedadValor = 16,
        ESPPlayers = false,
        ESPSkeleton = false,
        ESPDroppedItems = false,
        ESPInventories = false,
        NoFog = false,
        CameraFOV = 70,

        SilentAim = false,
        SilentAimFOV = 180,
        SilentAimShowFOV = true,
        SilentAimTeamCheck = false,

        SoftAim = false,
        SoftAimFOV = 120,
        SoftAimSmooth = 12,
        SoftAimPart = "Head",
        SoftAimShowFOV = true,
        SoftAimFOVShape = "Circle",
        SoftAimFOVColor = Color3.fromRGB(120, 200, 255),
        SoftAimFOVRainbow = false,
        SoftAimTeamCheck = true,
        SoftAimAliveCheck = true,

        Aimbot = false,
        AimbotFOV = 180,
        AimbotSmooth = 4,
        AimbotPart = "Head",
        AimbotShowFOV = true,
        AimbotFOVShape = "Circle",
        AimbotFOVColor = Color3.fromRGB(255, 90, 90),
        AimbotFOVRainbow = false,
        AimbotTeamCheck = true,
        AimbotAliveCheck = true,

        AutoAttack = false,
        AutoAttackRadius = 20,

        UnderMap = false,
        UnderMapDepth = 20,
        UnderMapKey = Enum.KeyCode.E,

        PuddleFarm = false,
        FastMove = false,
        AtmFarm = false,
        AtmDriveSpeed = 60,
        AtmLiftSpeed = 12,
    }

    local State = {
        LastDeathCFrame = nil,
        OrigGravity = workspace.Gravity,
        OrigFogStart = Lighting.FogStart,
        OrigFogEnd = Lighting.FogEnd,
        OrigAtmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    }

    -- Guardar la última posición cuando el personaje muere
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then State.LastDeathCFrame = hrp.CFrame end
            end)
        end
    end
    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").Died:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then State.LastDeathCFrame = hrp.CFrame end
        end)
    end)

    -- Muestra visual de la Target Part mediante SelectionBox
    local TargetHighlightBox = Instance.new("SelectionBox")
    TargetHighlightBox.Name = "TargetPartVisualizer"
    TargetHighlightBox.Color3 = Color3.fromRGB(160, 32, 240)
    TargetHighlightBox.LineThickness = 0.04
    TargetHighlightBox.Adornee = nil
    TargetHighlightBox.Parent = workspace

    -- FOV con forma (Circulo/Triangulo/Pentagono/Hexagono/Octagono), color y
    -- rainbow. Se dibuja con líneas (Drawing), así una sola función sirve
    -- para cualquier forma sin depender de ningún GUI.
    local FOV_SHAPE_SIDES = {
        Circle = 48,
        Triangle = 3,
        Pentagon = 5,
        Hexagon = 6,
        Octagon = 8,
    }
    local FOV_MAX_SIDES = 48

    local function CreateFOVPolygon()
        local lines = {}
        for i = 1, FOV_MAX_SIDES do
            local l = Drawing.new("Line")
            l.Thickness = 1.5
            l.Visible = false
            lines[i] = l
        end
        return lines
    end

    local SoftFOVLines = CreateFOVPolygon()
    local AimbotFOVLines = CreateFOVPolygon()

    local function UpdateFOVPolygon(lines, enabled, show, fov, shapeName, color, rainbow)
        local cam = workspace.CurrentCamera
        local on = enabled and show and cam ~= nil
        if not on then
            for _, l in ipairs(lines) do l.Visible = false end
            return
        end

        local sides = FOV_SHAPE_SIDES[shapeName] or FOV_SHAPE_SIDES.Circle
        local vp = cam.ViewportSize
        local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
        local radius = math.max(8, fov)
        local drawColor = rainbow and Color3.fromHSV((tick() * 0.25) % 1, 1, 1) or color

        local points = {}
        local angleOffset = -math.pi / 2 -- para que las formas con pocos lados queden "paradas"
        for i = 1, sides do
            local a = angleOffset + (i - 1) * (2 * math.pi / sides)
            points[i] = center + Vector2.new(math.cos(a), math.sin(a)) * radius
        end

        for i = 1, FOV_MAX_SIDES do
            local line = lines[i]
            if i <= sides then
                line.From = points[i]
                line.To = points[(i % sides) + 1]
                line.Color = drawColor
                line.Visible = true
            else
                line.Visible = false
            end
        end
    end

    local function GetTargetPart(character, partName)
        if not character then return nil end
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then return part end
        if partName == "Torso" or partName == "UpperTorso" then
            part = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
            if part and part:IsA("BasePart") then return part end
        end
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
    end

    local function IsEnemyPlayer(plr)
        if not plr or plr == LocalPlayer then return false end
        if not plr.Character then return false end
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        return true
    end

    local function IsAliveHumanoid(hum, aliveCheck)
        if not hum then return false end
        if hum.Health <= 0 then return false end
        if aliveCheck then
            if hum:GetAttribute("IsDead") == true then return false end
            if hum:GetAttribute("HasBeenDowned") == true then return false end
        end
        return true
    end

    local function SameTeam(plr, teamCheck)
        if not teamCheck then return false end
        if LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then
            return true
        end
        local myGang = LocalPlayer:GetAttribute("CurrentGangId")
        local theirGang = plr:GetAttribute("CurrentGangId")
        if myGang and theirGang and myGang == theirGang then
            return true
        end
        return false
    end

    local function GetBestTarget(fov, partName, teamCheck, aliveCheck)
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local center = cam.ViewportSize * 0.5
        local bestPart, bestDist = nil, fov

        for _, plr in ipairs(Players:GetPlayers()) do
            if IsEnemyPlayer(plr) and not SameTeam(plr, teamCheck) then
                local char = plr.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if IsAliveHumanoid(hum, aliveCheck) then
                    local part = GetTargetPart(char, partName)
                    if part then
                        local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
                        if onScreen and screenPos.Z > 0 then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                            if dist <= fov and dist < bestDist then
                                bestDist = dist
                                bestPart = part
                            end
                        end
                    end
                end
            end
        end
        return bestPart
    end

    local function ApplySoftAim(dt)
        if not Config.SoftAim then return nil end
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local target = GetBestTarget(
            Config.SoftAimFOV,
            Config.SoftAimPart,
            Config.SoftAimTeamCheck,
            Config.SoftAimAliveCheck
        )
        if not target then return nil end
        local smooth = math.max(Config.SoftAimSmooth, 1)
        local alpha = math.clamp((dt or 0.016) * (60 / smooth), 0.01, 1)
        local goal = CFrame.new(cam.CFrame.Position, target.Position)
        cam.CFrame = cam.CFrame:Lerp(goal, alpha)
        return target
    end

    local function ApplyAimbot(dt)
        if not Config.Aimbot then return nil end
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local target = GetBestTarget(
            Config.AimbotFOV,
            Config.AimbotPart,
            Config.AimbotTeamCheck,
            Config.AimbotAliveCheck
        )
        if not target then return nil end
        local smooth = math.max(Config.AimbotSmooth, 1)
        local alpha = math.clamp((dt or 0.016) * (90 / smooth), 0.02, 1)
        local goal = CFrame.new(cam.CFrame.Position, target.Position)
        cam.CFrame = cam.CFrame:Lerp(goal, alpha)
        return target
    end

    local function UpdateAimSystems(dt)
        UpdateFOVPolygon(SoftFOVLines, Config.SoftAim, Config.SoftAimShowFOV, Config.SoftAimFOV, Config.SoftAimFOVShape, Config.SoftAimFOVColor, Config.SoftAimFOVRainbow)
        UpdateFOVPolygon(AimbotFOVLines, Config.Aimbot, Config.AimbotShowFOV, Config.AimbotFOV, Config.AimbotFOVShape, Config.AimbotFOVColor, Config.AimbotFOVRainbow)

        local currentTarget = nil
        if Config.Aimbot then
            currentTarget = ApplyAimbot(dt)
        elseif Config.SoftAim then
            currentTarget = ApplySoftAim(dt)
        end

        if currentTarget then
            TargetHighlightBox.Adornee = currentTarget
        else
            TargetHighlightBox.Adornee = nil
        end
    end

    -- =========================================================================
    -- SISTEMA ESP Y SKELETON (OPTIMIZADO DIRECTO CON PLAYERS Y CACHÉ)
    -- =========================================================================
    local ESPCache = {}
    local SkeletonCache = {}

    local function ClearESP(model)
        if ESPCache[model] then
            for _, obj in pairs(ESPCache[model]) do
                pcall(function() obj:Remove() end)
            end
            ESPCache[model] = nil
        end
    end

    local function ClearSkeleton(model)
        if SkeletonCache[model] then
            for _, line in pairs(SkeletonCache[model]) do
                pcall(function() line:Remove() end)
            end
            SkeletonCache[model] = nil
        end
    end

    local function UpdateESP()
        local cam = workspace.CurrentCamera
        if not cam then return end

        if not Config.ESPPlayers then
            for model, _ in pairs(ESPCache) do ClearESP(model) end
            return
        end

        -- Limpiar registros inválidos
        for model, _ in pairs(ESPCache) do
            if not model or not model.Parent or not model:FindFirstChildOfClass("Humanoid") then
                ClearESP(model)
            end
        end

        -- Recorrido optimizado sobre Jugadores en lugar de todo el workspace
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local model = plr.Character
                local hum = model:FindFirstChildOfClass("Humanoid")
                local hrp = model:FindFirstChild("HumanoidRootPart")

                if hum and hrp and hum.Health > 0 then
                    local screenPos, onScreen = cam:WorldToViewportPoint(hrp.Position)

                    if onScreen and screenPos.Z > 0 then
                        if not ESPCache[model] then
                            local box = Drawing.new("Square")
                            box.Thickness = 1.5
                            box.Filled = false
                            box.Color = Color3.fromRGB(180, 100, 255)
                            box.Transparency = 1

                            local nameTag = Drawing.new("Text")
                            nameTag.Size = 13
                            nameTag.Center = true
                            nameTag.Outline = true
                            nameTag.Color = Color3.fromRGB(255, 255, 255)

                            local healthBarOutline = Drawing.new("Square")
                            healthBarOutline.Thickness = 1.5
                            healthBarOutline.Filled = true
                            healthBarOutline.Color = Color3.fromRGB(0, 0, 0)
                            healthBarOutline.Transparency = 0.6

                            local healthBar = Drawing.new("Square")
                            healthBar.Thickness = 1
                            healthBar.Filled = true
                            healthBar.Transparency = 1

                            ESPCache[model] = {
                                Box = box,
                                Name = nameTag,
                                HealthBarOutline = healthBarOutline,
                                HealthBar = healthBar
                            }
                        end

                        local esp = ESPCache[model]
                        local head = model:FindFirstChild("Head")
                        local topPos = head and head.Position + Vector3.new(0, 1.6, 0) or hrp.Position + Vector3.new(0, 3, 0)
                        local bottomPos = hrp.Position - Vector3.new(0, 3.2, 0)

                        local topScreen = cam:WorldToViewportPoint(topPos)
                        local bottomScreen = cam:WorldToViewportPoint(bottomPos)

                        local boxHeight = math.abs(topScreen.Y - bottomScreen.Y)
                        local boxWidth = boxHeight * 0.65

                        local boxX = screenPos.X - boxWidth / 2
                        local boxY = screenPos.Y - boxHeight / 2

                        esp.Box.Size = Vector2.new(boxWidth, boxHeight)
                        esp.Box.Position = Vector2.new(boxX, boxY)
                        esp.Box.Visible = true

                        esp.Name.Text = plr.Name
                        esp.Name.Position = Vector2.new(screenPos.X, boxY - 28)
                        esp.Name.Visible = true

                        local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local barHeight = math.max(6, math.min(10, boxHeight * 0.08))
                        local barWidth = math.max(boxWidth, 24)
                        local barX = screenPos.X - barWidth / 2
                        local barY = boxY - (barHeight + 6)

                        esp.HealthBarOutline.Size = Vector2.new(barWidth + 2, barHeight + 2)
                        esp.HealthBarOutline.Position = Vector2.new(barX - 1, barY - 1)
                        esp.HealthBarOutline.Visible = true

                        esp.HealthBar.Size = Vector2.new(math.max(1, barWidth * healthPercent), barHeight)
                        esp.HealthBar.Position = Vector2.new(barX, barY)
                        esp.HealthBar.Color = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 100), healthPercent)
                        esp.HealthBar.Visible = true
                    else
                        if ESPCache[model] then
                            for _, obj in pairs(ESPCache[model]) do obj.Visible = false end
                        end
                    end
                else
                    ClearESP(model)
                end
            end
        end
    end

    local SKELETON_PAIRS = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
        -- Compatibilidad R6
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"},
    }

    local function DrawSkeleton()
        local cam = workspace.CurrentCamera
        if not cam then return end

        if not Config.ESPSkeleton then
            for model, _ in pairs(SkeletonCache) do ClearSkeleton(model) end
            return
        end

        for model, _ in pairs(SkeletonCache) do
            if not model or not model.Parent or not model:FindFirstChildOfClass("Humanoid") then
                ClearSkeleton(model)
            end
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local model = plr.Character
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    if not SkeletonCache[model] then
                        SkeletonCache[model] = {}
                    end

                    local lines = SkeletonCache[model]
                    local lineIdx = 1

                    for _, pair in ipairs(SKELETON_PAIRS) do
                        local p1 = model:FindFirstChild(pair[1])
                        local p2 = model:FindFirstChild(pair[2])

                        if p1 and p2 then
                            local pos1, vis1 = cam:WorldToViewportPoint(p1.Position)
                            local pos2, vis2 = cam:WorldToViewportPoint(p2.Position)

                            if vis1 and vis2 and pos1.Z > 0 and pos2.Z > 0 then
                                if not lines[lineIdx] then
                                    local l = Drawing.new("Line")
                                    l.Thickness = 1.5
                                    l.Color = Color3.fromRGB(255, 255, 255)
                                    l.Transparency = 0.8
                                    lines[lineIdx] = l
                                end
                                lines[lineIdx].From = Vector2.new(pos1.X, pos1.Y)
                                lines[lineIdx].To = Vector2.new(pos2.X, pos2.Y)
                                lines[lineIdx].Visible = true
                                lineIdx = lineIdx + 1
                            end
                        end
                    end

                    for i = lineIdx, #lines do
                        lines[i].Visible = false
                    end
                else
                    ClearSkeleton(model)
                end
            end
        end
    end

    local SprintModule
    pcall(function()
        SprintModule = require(game.ReplicatedStorage.Modules.Game.Sprint)
    end)

    -- =========================================================================
    -- SPRINT INFINITO (stamina full + pulse set_sprinting_1 0.5/0.1)
    -- =========================================================================
    local SprintInfiniteOff = nil

    local function SetInfiniteSprint(enabled)
        if SprintInfiniteOff then
            pcall(SprintInfiniteOff)
            SprintInfiniteOff = nil
        end

        if not enabled then
            Config.SprintInfinito = false
            return
        end

        local Sprint = SprintModule
        if not Sprint then
            local ok, result = pcall(function()
                return require(game.ReplicatedStorage.Modules.Game.Sprint)
            end)
            if ok then
                Sprint = result
                SprintModule = result
            end
        end

        if not Sprint then
            Config.SprintInfinito = false
            warn("[Sprint Infinito] No se pudo cargar.... ")
            return
        end

        local Send
        pcall(function()
            Send = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Send")
        end)

        local CounterTable = nil
        pcall(function()
            for _, obj in ipairs(getgc(true)) do
                if typeof(obj) == "table" and rawget(obj, "event") and rawget(obj, "func") then
                    CounterTable = obj
                    break
                end
            end
        end)

        Config.SprintInfinito = true

        local staminaConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                if Sprint.sprint_bar then
                    Sprint.sprint_bar.set(1)
                end
            end)
        end)

        local running = true

        task.spawn(function()
            while running and Config.SprintInfinito do
                pcall(function()
                    if CounterTable and Send then
                        CounterTable.event = (CounterTable.event or 0) + 1
                        Send:FireServer(CounterTable.event, "set_sprinting_1", true)
                    end
                    if Sprint.sprinting then
                        Sprint.sprinting.set(true)
                    end
                end)

                task.wait(0.5)

                if not running or not Config.SprintInfinito then
                    break
                end

                pcall(function()
                    if CounterTable and Send then
                        CounterTable.event = (CounterTable.event or 0) + 1
                        Send:FireServer(CounterTable.event, "set_sprinting_1", false)
                    end
                    if Sprint.sprinting then
                        Sprint.sprinting.set(false)
                    end
                end)

                task.wait(0.1)
            end
        end)

        SprintInfiniteOff = function()
            running = false
            Config.SprintInfinito = false

            if staminaConn then
                pcall(function()
                    staminaConn:Disconnect()
                end)
                staminaConn = nil
            end

            pcall(function()
                if CounterTable and Send then
                    CounterTable.event = (CounterTable.event or 0) + 1
                    Send:FireServer(CounterTable.event, "set_sprinting_1", false)
                end
                if Sprint.sprinting then
                    Sprint.sprinting.set(false)
                end
            end)

            print("[Sprint Infinito] OFF")
        end

        _G.StopInfStamina = SprintInfiniteOff
        _G.SoftSprintOff = SprintInfiniteOff

        print("[Sprint Infinito] ON — pulse 0.5/0.1")
    end

    local function SmoothTeleport(targetCFrame, stepSize, stepDelay)
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        stepSize = stepSize or 12
        stepDelay = stepDelay or 0.05

        local startPos = hrp.Position
        local endPos = targetCFrame.Position
        local distance = (endPos - startPos).Magnitude
        if distance <= stepSize then
            hrp.CFrame = targetCFrame
            return
        end

        local steps = math.ceil(distance / stepSize)
        for i = 1, steps do
            character = LocalPlayer.Character
            hrp = character and character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local alpha = i / steps
            local pos = startPos:Lerp(endPos, alpha)
            local rot = targetCFrame.Rotation
            hrp.CFrame = CFrame.new(pos) * rot
            task.wait(stepDelay)
        end
    end

    Connect(RunService.RenderStepped, function(dt)
        if Config.NoFog then
            Lighting.FogEnd = 9e9
            Lighting.FogStart = 9e9
            local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
            if atmos then atmos.Parent = nil end
        end

        UpdateESP()
        DrawSkeleton()
        UpdateAimSystems(dt)
    end)

    local OriginalJumpPower = nil

    LocalPlayer.CharacterAdded:Connect(function()
        OriginalJumpPower = nil
    end)

    task.spawn(function()
        while true do
            task.wait(0.25)
            if LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    if OriginalJumpPower == nil and not Config.SuperJump then
                        OriginalJumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
                    end
                    if Config.SuperJump then
                        hum.UseJumpPower = true
                        hum.JumpPower = 50
                    end
                end
                if Config.InfiniteStamina then
                    pcall(function()
                        LocalPlayer:SetAttribute("StaminaRegen", 5)
                    end)
                end
            end
        end
    end)

    local old = nil
    pcall(function()
        old = (gethui and gethui():FindFirstChild("SexyBoyHub")) or nil
    end)
    if old then old:Destroy() end

    local GuiParent
    pcall(function()
        if gethui then GuiParent = gethui() end
    end)
    if not GuiParent then
        GuiParent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SexyBoyHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GuiParent


    local function Corner(parent, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 8)
        c.Parent = parent
        return c
    end

    local function Stroke(parent, color, transparency, thickness)
        local s = Instance.new("UIStroke")
        s.Color = color or THEME.Stroke
        s.Transparency = transparency or 0
        s.Thickness = thickness or 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = parent
        return s
    end

    local function Padding(parent, l, r, t, b)
        local p = Instance.new("UIPadding")
        p.PaddingLeft = UDim.new(0, l or 0)
        p.PaddingRight = UDim.new(0, r or 0)
        p.PaddingTop = UDim.new(0, t or 0)
        p.PaddingBottom = UDim.new(0, b or 0)
        p.Parent = parent
        return p
    end

    local function Image(parent, asset, size, position)
        local i = Instance.new("ImageLabel")
        i.BackgroundTransparency = 1
        i.Image = asset
        i.ImageColor3 = Color3.fromRGB(255, 255, 255)
        i.Size = size
        i.Position = position or UDim2.fromOffset(0, 0)
        i.ScaleType = Enum.ScaleType.Fit
        i.Parent = parent
        return i
    end

    local function MakeText(parent, text, size, color, font, align)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextSize = size
        l.TextColor3 = color or THEME.Text
        l.Font = font or Enum.Font.GothamMedium
        l.TextXAlignment = align or Enum.TextXAlignment.Left
        l.TextYAlignment = Enum.TextYAlignment.Center
        l.Parent = parent
        return l
    end

    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Minimized = false
    Window.Maximized = false
    Window.FloatingPos = UDim2.new(.88, 0, .82, 0)

    function Window:CreateWindow()
        local main = Instance.new("Frame")
        main.Name = "Main"
        main.AnchorPoint = Vector2.new(.5, .5)
        main.Position = UDim2.fromScale(.5, .5)
        main.Size = UDim2.new(0, 720, 0, 485)
        main.BackgroundColor3 = THEME.Background
        main.BorderSizePixel = 0
        main.ClipsDescendants = true
        main.Active = true
        main.Parent = ScreenGui

        self.Main = main

        local scale = Instance.new("UIScale")
        scale.Parent = main
        self.Scale = scale

        local function updateScale()
            local cam = workspace.CurrentCamera
            if not cam then return end
            local vp = cam.ViewportSize
            local sx = math.clamp(vp.X / 900, .72, 1)
            local sy = math.clamp(vp.Y / 620, .70, 1)
            scale.Scale = math.min(sx, sy)
        end
        Connect(workspace:GetPropertyChangedSignal("CurrentCamera"), updateScale)
        if workspace.CurrentCamera then
            Connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), updateScale)
        end
        updateScale()

        main.Size = UDim2.new(0, 650, 0, 430)
        main.BackgroundTransparency = 1
        tween(main, TI_SMOOTH, {
            Size = UDim2.new(0, 720, 0, 485),
            BackgroundTransparency = 0
        })

        local header = Instance.new("Frame")
        header.Name = "Header"
        header.Size = UDim2.new(1, 0, 0, 66)
        header.BackgroundColor3 = THEME.Panel
        header.BorderSizePixel = 0
        header.Active = true
        header.Parent = main

        local headerLine = Instance.new("Frame")
        headerLine.Size = UDim2.new(1, -36, 0, 1)
        headerLine.Position = UDim2.new(0, 18, 1, -1)
        headerLine.BackgroundColor3 = THEME.Stroke
        headerLine.BorderSizePixel = 0
        headerLine.Parent = header

        local brand = Instance.new("Frame")
        brand.BackgroundTransparency = 1
        brand.Position = UDim2.fromOffset(20, 0)
        brand.Size = UDim2.new(0, 320, 1, 0)
        brand.Parent = header

        local TITLE_FONT = Enum.Font.FredokaOne

        local sexy = MakeText(brand, "Sexy", 21, THEME.Text, TITLE_FONT)
        sexy.Position = UDim2.fromOffset(0, 8)
        sexy.Size = UDim2.fromOffset(48, 30)

        local boy = MakeText(brand, "Boy", 21, THEME.Purple, TITLE_FONT)
        boy.Position = UDim2.fromOffset(48, 8)
        boy.Size = UDim2.fromOffset(42, 30)

        local hubPill = Instance.new("Frame")
        hubPill.Position = UDim2.fromOffset(92, 11)
        hubPill.Size = UDim2.fromOffset(42, 24)
        hubPill.BackgroundColor3 = THEME.Purple2
        hubPill.Parent = brand
        Corner(hubPill, 7)

        local hubText = MakeText(hubPill, "Hub", 11, Color3.new(1,1,1), Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        hubText.Size = UDim2.fromScale(1,1)

        local credits = MakeText(brand, "AutoFarm And Others", 10, THEME.Muted, Enum.Font.GothamMedium)
        credits.Position = UDim2.fromOffset(0, 38)
        credits.Size = UDim2.fromOffset(250, 16)

        local controls = Instance.new("Frame")
        controls.BackgroundTransparency = 1
        controls.AnchorPoint = Vector2.new(1, 0)
        controls.Position = UDim2.new(1, -14, 0, 13)
        controls.Size = UDim2.fromOffset(105, 40)
        controls.Parent = header

        local function windowControl(icon, callback, hoverColor)
            local b = Instance.new("TextButton")
            b.Text = ""
            b.AutoButtonColor = false
            b.Size = UDim2.fromOffset(32, 32)
            b.BackgroundColor3 = THEME.Card
            b.Parent = controls
            Corner(b, 8)
            Stroke(b, THEME.Stroke, 0, 1)
            local im = Image(b, icon, UDim2.fromOffset(14,14), UDim2.fromOffset(9,9))
            im.ImageColor3 = THEME.Muted
            Connect(b.MouseEnter, function()
                tween(b, TI_FAST, {BackgroundColor3 = THEME.CardHover})
                tween(im, TI_FAST, {ImageColor3 = hoverColor or THEME.Text})
            end)
            Connect(b.MouseLeave, function()
                tween(b, TI_FAST, {BackgroundColor3 = THEME.Card})
                tween(im, TI_FAST, {ImageColor3 = THEME.Muted})
            end)
            Connect(b.MouseButton1Down, function()
                tween(b, TI_FAST, {Size = UDim2.fromOffset(29,29)})
            end)
            Connect(b.MouseButton1Up, function()
                tween(b, TI_FAST, {Size = UDim2.fromOffset(32,32)})
            end)
            Connect(b.Activated, callback)
            return b, im
        end

        local minBtn = windowControl(ICONS.Minus, function() self:Minimize() end)
        minBtn.Position = UDim2.fromOffset(0, 0)

        local maxBtn = windowControl(ICONS.Maximize, function() self:ToggleMaximize() end)
        maxBtn.Position = UDim2.fromOffset(36, 0)

        local closeBtn = windowControl(ICONS.Close, function()
            self:ConfirmClose()
        end)
        closeBtn.Position = UDim2.fromOffset(72, 0)

        local body = Instance.new("Frame")
        body.Name = "Body"
        body.Position = UDim2.fromOffset(0, 66)
        body.Size = UDim2.new(1, 0, 1, -66)
        body.BackgroundTransparency = 1
        body.Active = true
        body.ClipsDescendants = true
        body.Parent = main
        self.Body = body

        local sidebar = Instance.new("Frame")
        sidebar.Name = "Sidebar"
        sidebar.Size = UDim2.new(0, 72, 1, 0)
        sidebar.BackgroundColor3 = THEME.Panel
        sidebar.BorderSizePixel = 0
        sidebar.Active = true
        sidebar.Parent = body
        Padding(sidebar, 12, 12, 14, 12)

        local sideList = Instance.new("UIListLayout")
        sideList.Padding = UDim.new(0, 9)
        sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        sideList.SortOrder = Enum.SortOrder.LayoutOrder
        sideList.Parent = sidebar
        self.Sidebar = sidebar

        local content = Instance.new("Frame")
        content.Name = "Content"
        content.Position = UDim2.fromOffset(72, 0)
        content.Size = UDim2.new(1, -72, 1, 0)
        content.BackgroundColor3 = THEME.Background
        content.BorderSizePixel = 0
        content.ClipsDescendants = true
        content.Active = true
        content.Parent = body
        self.Content = content

        local glowStroke = Instance.new("UIStroke")
        glowStroke.Name = "AnimatedGlowStroke"
        glowStroke.Thickness = 1.5
        glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        glowStroke.Color = Color3.fromRGB(255, 255, 255)
        glowStroke.Parent = main

        local glowGradient = Instance.new("UIGradient")
        glowGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, THEME.Stroke),
            ColorSequenceKeypoint.new(0.45, THEME.Purple),
            ColorSequenceKeypoint.new(0.55, THEME.PurpleSoft),
            ColorSequenceKeypoint.new(1, THEME.Stroke)
        })
        glowGradient.Parent = glowStroke

        Connect(RunService.RenderStepped, function(dt)
            if main and main.Parent then
                glowGradient.Rotation = (glowGradient.Rotation + dt * 60) % 360
            end
        end)

        self:_SetupDragging(header)
        return self
    end

    function Window:_SetupDragging(handle)
        local dragging = false
        local dragStart, startPos

        local function begin(input)
            if self.Maximized then return end
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
        end

        local function move(input)
            if not dragging then return end
            local delta = input.Position - dragStart
            local cam = workspace.CurrentCamera
            if not cam then return end
            local vp = cam.ViewportSize
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            local halfW = (self.Main.AbsoluteSize.X / 2)
            local halfH = (self.Main.AbsoluteSize.Y / 2)
            local margin = 8
            local minX = -vp.X/2 + halfW - margin
            local maxX = vp.X/2 - halfW + margin
            local minY = -vp.Y/2 + halfH - margin
            local maxY = vp.Y/2 - halfH + margin
            newX = math.clamp(newX, minX, maxX)
            newY = math.clamp(newY, minY, maxY)
            self.Main.Position = UDim2.new(.5, newX, .5, newY)
        end

        local function finish()
            dragging = false
        end

        Connect(handle.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                begin(input)
            end
        end)

        Connect(UIS.InputChanged, function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                move(input)
            end
        end)

        Connect(UIS.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                finish()
            end
        end)
    end

    function Window:Minimize()
        if self.Minimized then return end
        self.Minimized = true
        if self.Main then
            tween(self.Main, TI_MED, {
                Size = UDim2.new(0, 720, 0, 0),
                BackgroundTransparency = 1
            })
        end
        task.delay(.18, function()
            if self.Main then self.Main.Visible = false end
            self:_CreateFloating()
        end)
    end

    function Window:_CreateFloating()
        if self.Floating then return end
        local f = Instance.new("TextButton")
        f.Name = "FloatingSexyBoy"
        f.Text = ""
        f.AutoButtonColor = false
        f.AnchorPoint = Vector2.new(.5,.5)
        f.Position = self.FloatingPos
        f.Size = UDim2.fromOffset(62,62)
        f.BackgroundColor3 = THEME.Panel
        f.Active = true
        f.Parent = ScreenGui
        Corner(f, 18)
        Stroke(f, THEME.Purple2, 0, 1.5)

        local logoImage = Instance.new("ImageLabel")
        logoImage.Name = "CustomLogo"
        logoImage.BackgroundTransparency = 1
        logoImage.Size = UDim2.fromOffset(42, 42)
        logoImage.Position = UDim2.fromOffset(10, 10)
        logoImage.ScaleType = Enum.ScaleType.Fit
        logoImage.Parent = f

        pcall(function()
            if writefile and getcustomasset then
                local filename = "SexyBoyLogo.png"
                if not isfile(filename) then
                    writefile(filename, game:HttpGet(LOGO_URL))
                end
                logoImage.Image = getcustomasset(filename)
            else
                logoImage.Image = LOGO_URL
            end
        end)

        self.Floating = f

        Connect(f.MouseEnter, function()
            tween(f, TI_FAST, {Size = UDim2.fromOffset(67,67)})
            tween(logoImage, TI_FAST, {Size = UDim2.fromOffset(46,46), Position = UDim2.fromOffset(10,10)})
        end)
        Connect(f.MouseLeave, function()
            tween(f, TI_FAST, {Size = UDim2.fromOffset(62,62)})
            tween(logoImage, TI_FAST, {Size = UDim2.fromOffset(42,42), Position = UDim2.fromOffset(10,10)})
        end)
        Connect(f.Activated, function()
            self:Restore()
        end)

        local dragging, start, startPos = false, nil, nil
        Connect(f.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                start = input.Position
                startPos = f.Position
            end
        end)
        Connect(UIS.InputChanged, function(input)
            if not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = input.Position - start
            local vp = workspace.CurrentCamera.ViewportSize
            local x = math.clamp(startPos.X.Offset + d.X, -vp.X/2 + 40, vp.X/2 - 40)
            local y = math.clamp(startPos.Y.Offset + d.Y, -vp.Y/2 + 40, vp.Y/2 - 40)
            local newPos = UDim2.new(.5, x, .5, y)
            f.Position = newPos
            self.FloatingPos = newPos
        end)
        Connect(UIS.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    function Window:Restore()
        if not self.Minimized then return end
        self.Minimized = false
        if self.Floating then
            self.Floating:Destroy()
            self.Floating = nil
        end
        self.Main.Visible = true
        self.Main.Size = UDim2.new(0, 720, 0, 0)
        self.Main.BackgroundTransparency = 1
        tween(self.Main, TI_SMOOTH, {
            Size = self.Maximized and UDim2.new(0, 860, 0, 560) or UDim2.new(0, 720, 0, 485),
            BackgroundTransparency = 0
        })
    end

    function Window:ToggleMaximize()
        if self.Minimized then return end
        self.Maximized = not self.Maximized
        if self.Maximized then
            tween(self.Main, TI_SMOOTH, {
                Size = UDim2.new(0, 860, 0, 560),
                Position = UDim2.fromScale(.5,.5)
            })
        else
            tween(self.Main, TI_SMOOTH, {
                Size = UDim2.new(0, 720, 0, 485),
                Position = UDim2.fromScale(.5,.5)
            })
        end
    end

    function Window:Close()
        DisconnectAll()
        if self.Floating then self.Floating:Destroy() end
        if TargetHighlightBox then TargetHighlightBox:Destroy() end
        for model, _ in pairs(ESPCache) do ClearESP(model) end
        for model, _ in pairs(SkeletonCache) do ClearSkeleton(model) end
        tween(self.Main, TI_MED, {
            Size = UDim2.new(0, 650, 0, 0),
            BackgroundTransparency = 1
        }).Completed:Connect(function()
            if ScreenGui then ScreenGui:Destroy() end
        end)
    end

    function Window:ConfirmClose()
        if ScreenGui:FindFirstChild("SB_CloseConfirm") then
            return
        end
        local overlay = Instance.new("Frame")
        overlay.Name = "SB_CloseConfirm"
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.45
        overlay.ZIndex = 200
        overlay.Parent = ScreenGui

        local panel = Instance.new("Frame")
        panel.Size = UDim2.fromOffset(300, 150)
        panel.Position = UDim2.fromScale(0.5, 0.5)
        panel.AnchorPoint = Vector2.new(0.5, 0.5)
        panel.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        panel.BorderSizePixel = 0
        panel.ZIndex = 201
        panel.Parent = overlay
        Corner(panel, 14)
        Stroke(panel, Color3.fromRGB(80, 60, 120), 1, 0)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -24, 0, 28)
        title.Position = UDim2.fromOffset(12, 16)
        title.BackgroundTransparency = 1
        title.Text = "Cerrar SexyBoy Hub?"
        title.TextColor3 = Color3.fromRGB(240, 240, 245)
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 202
        title.Parent = panel

        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -24, 0, 36)
        desc.Position = UDim2.fromOffset(12, 48)
        desc.BackgroundTransparency = 1
        desc.Text = "Se cierra el menu y se apagan las funciones activas."
        desc.TextColor3 = Color3.fromRGB(150, 150, 160)
        desc.TextSize = 12
        desc.Font = Enum.Font.Gotham
        desc.TextWrapped = true
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.ZIndex = 202
        desc.Parent = panel

        local function makeDlgBtn(text, x, bg, cb)
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(120, 34)
            b.Position = UDim2.new(0, x, 1, -48)
            b.BackgroundColor3 = bg
            b.BorderSizePixel = 0
            b.Text = text
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.TextSize = 13
            b.Font = Enum.Font.GothamSemibold
            b.AutoButtonColor = false
            b.ZIndex = 202
            b.Parent = panel
            Corner(b, 8)
            b.Activated:Connect(cb)
            return b
        end

        makeDlgBtn("Cancelar", 20, Color3.fromRGB(40, 40, 48), function()
            overlay:Destroy()
        end)
        makeDlgBtn("Cerrar", 160, Color3.fromRGB(160, 50, 80), function()
            overlay:Destroy()
            self:Close()
        end)
    end

    function Window:ShowColorPicker(titleText, currentColor, onPick, rainbowOn, onRainbow)
        if ScreenGui:FindFirstChild("SB_ColorPicker") then
            ScreenGui.SB_ColorPicker:Destroy()
        end
        local overlay = Instance.new("Frame")
        overlay.Name = "SB_ColorPicker"
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.45
        overlay.ZIndex = 200
        overlay.Parent = ScreenGui

        local panel = Instance.new("Frame")
        panel.Size = UDim2.fromOffset(280, 250)
        panel.Position = UDim2.fromScale(0.5, 0.5)
        panel.AnchorPoint = Vector2.new(0.5, 0.5)
        panel.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        panel.BorderSizePixel = 0
        panel.ZIndex = 201
        panel.Parent = overlay
        Corner(panel, 14)
        Stroke(panel, Color3.fromRGB(80, 60, 120), 1, 0)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -48, 0, 28)
        title.Position = UDim2.fromOffset(14, 12)
        title.BackgroundTransparency = 1
        title.Text = titleText or "Elegir color"
        title.TextColor3 = Color3.fromRGB(240, 240, 245)
        title.TextSize = 15
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 202
        title.Parent = panel

        local xBtn = Instance.new("TextButton")
        xBtn.Size = UDim2.fromOffset(28, 28)
        xBtn.Position = UDim2.new(1, -36, 0, 10)
        xBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        xBtn.Text = "X"
        xBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
        xBtn.TextSize = 13
        xBtn.Font = Enum.Font.GothamBold
        xBtn.AutoButtonColor = false
        xBtn.ZIndex = 202
        xBtn.Parent = panel
        Corner(xBtn, 7)
        xBtn.Activated:Connect(function()
            overlay:Destroy()
        end)

        local preview = Instance.new("Frame")
        preview.Size = UDim2.new(1, -28, 0, 28)
        preview.Position = UDim2.fromOffset(14, 48)
        preview.BackgroundColor3 = currentColor or Color3.fromRGB(255, 255, 255)
        preview.BorderSizePixel = 0
        preview.ZIndex = 202
        preview.Parent = panel
        Corner(preview, 8)

        local colors = {
            { "Rojo", Color3.fromRGB(255, 70, 70) },
            { "Rosa", Color3.fromRGB(255, 110, 180) },
            { "Violeta", Color3.fromRGB(165, 100, 255) },
            { "Celeste", Color3.fromRGB(120, 200, 255) },
            { "Verde", Color3.fromRGB(80, 230, 120) },
            { "Amarillo", Color3.fromRGB(255, 220, 80) },
            { "Naranja", Color3.fromRGB(255, 150, 50) },
            { "Blanco", Color3.fromRGB(255, 255, 255) },
        }

        local grid = Instance.new("Frame")
        grid.Size = UDim2.new(1, -28, 0, 88)
        grid.Position = UDim2.fromOffset(14, 88)
        grid.BackgroundTransparency = 1
        grid.ZIndex = 202
        grid.Parent = panel

        local layout = Instance.new("UIGridLayout")
        layout.CellSize = UDim2.fromOffset(56, 36)
        layout.CellPadding = UDim2.fromOffset(8, 8)
        layout.Parent = grid

        for _, c in ipairs(colors) do
            local cell = Instance.new("TextButton")
            cell.BackgroundColor3 = c[2]
            cell.Text = ""
            cell.AutoButtonColor = false
            cell.ZIndex = 203
            cell.Parent = grid
            Corner(cell, 8)
            cell.Activated:Connect(function()
                preview.BackgroundColor3 = c[2]
                if onPick then
                    onPick(c[2])
                end
            end)
        end

        if onRainbow then
            local rb = Instance.new("TextButton")
            rb.Size = UDim2.new(1, -28, 0, 34)
            rb.Position = UDim2.fromOffset(14, 190)
            rb.BackgroundColor3 = rainbowOn and Color3.fromRGB(80, 50, 120) or Color3.fromRGB(40, 40, 48)
            rb.BorderSizePixel = 0
            rb.Text = rainbowOn and "Rainbow: ON" or "Rainbow: OFF"
            rb.TextColor3 = Color3.fromRGB(240, 240, 245)
            rb.TextSize = 13
            rb.Font = Enum.Font.GothamSemibold
            rb.AutoButtonColor = false
            rb.ZIndex = 202
            rb.Parent = panel
            Corner(rb, 8)
            local state = rainbowOn and true or false
            rb.Activated:Connect(function()
                state = not state
                rb.Text = state and "Rainbow: ON" or "Rainbow: OFF"
                rb.BackgroundColor3 = state and Color3.fromRGB(80, 50, 120) or Color3.fromRGB(40, 40, 48)
                onRainbow(state)
            end)
        end
    end

    function Window:CreateTab(id, iconAsset, title)
        local tab = {
            Id = id,
            Title = title or id,
            Buttons = {},
        }

        local b = Instance.new("TextButton")
        b.Name = "Tab_" .. id
        b.Text = ""
        b.AutoButtonColor = false
        b.Size = UDim2.fromOffset(46, 44)
        b.BackgroundColor3 = THEME.Panel
        b.Parent = self.Sidebar
        Corner(b, 11)

        local stroke = Stroke(b, THEME.Stroke, 1, 1)
        local icon = Image(b, iconAsset or ICONS.Sparkles, UDim2.fromOffset(20,20), UDim2.fromOffset(13,12))
        icon.ImageColor3 = THEME.Muted
        tab.Button = b
        tab.Icon = icon
        tab.Stroke = stroke

        Connect(b.MouseEnter, function()
            if self.CurrentTab ~= tab then
                tween(b, TI_FAST, {BackgroundColor3 = THEME.CardHover})
                tween(icon, TI_FAST, {ImageColor3 = THEME.Text})
            end
        end)
        Connect(b.MouseLeave, function()
            if self.CurrentTab ~= tab then
                tween(b, TI_FAST, {BackgroundColor3 = THEME.Panel})
                tween(icon, TI_FAST, {ImageColor3 = THEME.Muted})
            end
        end)
        Connect(b.Activated, function()
            self:SelectTab(tab)
        end)

        local page = Instance.new("ScrollingFrame")
        page.Name = "Page_" .. id
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = THEME.Purple2
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.Active = true
        page.ScrollingEnabled = true
        page.ElasticBehavior = Enum.ElasticBehavior.Always
        page.ClipsDescendants = true
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = self.Content
        Padding(page, 22, 22, 22, 40)

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 10)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = page

        tab.Page = page
        self.Tabs[id] = tab
        if not self.CurrentTab then self:SelectTab(tab) end
        return tab
    end

    function Window:SelectTab(tab)
        if self.CurrentTab == tab then return end
        local previous = self.CurrentTab
        self.CurrentTab = tab

        for _, t in pairs(self.Tabs) do
            local active = t == tab
            t.Page.Visible = active
            tween(t.Button, TI_MED, {
                BackgroundColor3 = active and Color3.fromRGB(34, 24, 48) or THEME.Panel
            })
            tween(t.Icon, TI_MED, {
                ImageColor3 = active and THEME.PurpleSoft or THEME.Muted
            })
            tween(t.Stroke, TI_MED, {
                Transparency = active and .25 or 1,
                Color = active and THEME.Purple2 or THEME.Stroke
            })
        end

        if previous and previous.Page then
            previous.Page.Position = UDim2.fromOffset(-8,0)
            tween(previous.Page, TI_FAST, {Position = UDim2.fromOffset(0,0)})
        end
    end

    function Window:CreateLabel(parent, text, description)
        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1,0,0,description and 44 or 28)
        holder.Parent = parent

        local title = MakeText(holder, text, 19, THEME.Text, Enum.Font.GothamBold)
        title.Size = UDim2.new(1,0,0,25)

        if description then
            local desc = MakeText(holder, description, 11, THEME.Muted, Enum.Font.GothamMedium)
            desc.Position = UDim2.fromOffset(0,25)
            desc.Size = UDim2.new(1,0,0,18)
        end
        return holder
    end

    function Window:CreateDivider(parent, text)
        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1,0,0,30)
        holder.Parent = parent

        local line = Instance.new("Frame")
        line.BackgroundColor3 = THEME.Stroke
        line.BorderSizePixel = 0
        line.Position = UDim2.new(0,0,.55,0)
        line.Size = UDim2.new(1,0,0,1)
        line.Parent = holder

        if text then
            local pill = Instance.new("Frame")
            pill.BackgroundColor3 = THEME.Background
            pill.Size = UDim2.fromOffset(120,22)
            pill.Position = UDim2.fromOffset(0,4)
            pill.Parent = holder
            local l = MakeText(pill, text:upper(), 9, THEME.Muted, Enum.Font.GothamBold)
            l.Size = UDim2.fromScale(1,1)
        end
        return holder
    end

    function Window:CreateSection(parent, title, description)
        local holder = Instance.new("Frame")
        holder.BackgroundColor3 = THEME.Panel
        holder.Size = UDim2.new(1,0,0,0)
        holder.AutomaticSize = Enum.AutomaticSize.Y
        holder.ClipsDescendants = false
        holder.Parent = parent
        Corner(holder, 11)
        Stroke(holder, THEME.Stroke, 0, 1)
        Padding(holder, 12, 12, 12, 12)

        local head = Instance.new("Frame")
        head.BackgroundTransparency = 1
        head.Size = UDim2.new(1,0,0,description and 43 or 26)
        head.Parent = holder

        local t = MakeText(head, title, 13, THEME.Text, Enum.Font.GothamBold)
        t.Size = UDim2.new(1,0,0,22)

        if description then
            local d = MakeText(head, description, 10, THEME.Muted, Enum.Font.GothamMedium)
            d.Position = UDim2.fromOffset(0,21)
            d.Size = UDim2.new(1,0,0,18)
        end

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0,8)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = holder

        head.LayoutOrder = 0
        return holder
    end

    function Window:CreateButton(parent, data)
        local isToggleButton = data.IsToggle ~= false
        local b = Instance.new("TextButton")
        b.Name = data.Name or data.Title or "Button"
        b.Text = ""
        b.AutoButtonColor = false
        b.Size = UDim2.new(1,0,0,62)
        b.BackgroundColor3 = THEME.Card
        b.Parent = parent
        Corner(b, 9)
        local s = Stroke(b, THEME.Stroke, 0, 1)

        -- Icono sin fondo oscuro
        local icon = Image(b, data.Icon or ICONS.Sparkles, UDim2.fromOffset(22,22), UDim2.fromOffset(14,20))
        icon.ImageColor3 = THEME.PurpleSoft

        local title = MakeText(b, data.Title or "Demo Button", 12, THEME.Text, Enum.Font.GothamBold)
        title.Position = UDim2.fromOffset(50,9)
        title.Size = UDim2.new(1,-140,0,20)

        local desc = MakeText(b, data.Description or "", 9, THEME.Muted, Enum.Font.GothamMedium)
        desc.Position = UDim2.fromOffset(50,29)
        desc.Size = UDim2.new(1, (isToggleButton and -140 or -60), 0, 18)

        local state = MakeText(b, "OFF", 8, THEME.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        state.Position = UDim2.new(1,-78,0,22)
        state.Size = UDim2.fromOffset(58,18)
        state.Visible = isToggleButton

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.fromOffset(3,30)
        indicator.Position = UDim2.new(1,-7,.5,-15)
        indicator.BackgroundColor3 = THEME.Stroke
        indicator.BorderSizePixel = 0
        indicator.Visible = isToggleButton
        indicator.Parent = b
        Corner(indicator, 2)

        Connect(b.MouseEnter, function()
            tween(b, TI_FAST, {BackgroundColor3 = THEME.CardHover})
            tween(s, TI_FAST, {Color = THEME.Purple2, Transparency = .45})
        end)
        Connect(b.MouseLeave, function()
            tween(b, TI_FAST, {BackgroundColor3 = THEME.Card})
            tween(s, TI_FAST, {Color = THEME.Stroke, Transparency = 0})
        end)
        Connect(b.MouseButton1Down, function()
            tween(b, TI_FAST, {Size = UDim2.new(1,-2,0,60)})
        end)
        Connect(b.MouseButton1Up, function()
            tween(b, TI_FAST, {Size = UDim2.new(1,0,0,62)})
        end)

        local active = data.Default or false
        if active and isToggleButton then
            state.Text = "ON"
            state.TextColor3 = THEME.PurpleSoft
            indicator.BackgroundColor3 = THEME.Purple
            icon.ImageColor3 = THEME.Text
            b.BackgroundColor3 = Color3.fromRGB(28,22,38)
        end

        local buttonObj = {
            SetState = function(self, newState)
                active = newState
                if isToggleButton then
                    state.Text = active and "ON" or "OFF"
                    state.TextColor3 = active and THEME.PurpleSoft or THEME.Muted
                    indicator.BackgroundColor3 = active and THEME.Purple or THEME.Stroke
                    tween(icon, TI_FAST, {ImageColor3 = active and THEME.Text or THEME.PurpleSoft})
                    tween(b, TI_FAST, {BackgroundColor3 = active and Color3.fromRGB(28,22,38) or THEME.Card})
                end
            end,
            GetState = function(self) return active end
        }

        Connect(b.Activated, function()
            if isToggleButton then
                active = not active
                buttonObj:SetState(active)
            end
            if data.Callback then
                pcall(data.Callback, active)
            end
        end)

        return buttonObj
    end

    function Window:CreateSlider(parent, data)
        local holder = Instance.new("Frame")
        holder.Size = UDim2.new(1,0,0,70)
        holder.BackgroundColor3 = THEME.Card
        holder.Parent = parent
        Corner(holder, 9)
        Stroke(holder, THEME.Stroke, 0, 1)

        local title = MakeText(holder, data.Title or "Slider", 11, THEME.Text, Enum.Font.GothamBold)
        title.Position = UDim2.fromOffset(12,8)
        title.Size = UDim2.new(1,-90,0,20)

        local valueLabel = MakeText(holder, "", 10, THEME.PurpleSoft, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        valueLabel.Position = UDim2.new(1,-70,0,8)
        valueLabel.Size = UDim2.fromOffset(58,20)

        local desc = MakeText(holder, data.Description or "", 9, THEME.Muted, Enum.Font.GothamMedium)
        desc.Position = UDim2.fromOffset(12,28)
        desc.Size = UDim2.new(1,-24,0,16)

        local track = Instance.new("Frame")
        track.Position = UDim2.new(0,12,1,-16)
        track.Size = UDim2.new(1,-24,0,4)
        track.BackgroundColor3 = THEME.Stroke
        track.BorderSizePixel = 0
        track.Parent = holder
        Corner(track, 3)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.fromScale(.5,1)
        fill.BackgroundColor3 = THEME.Purple2
        fill.BorderSizePixel = 0
        fill.Parent = track
        Corner(fill, 3)

        local knob = Instance.new("Frame")
        knob.AnchorPoint = Vector2.new(.5,.5)
        knob.Position = UDim2.fromScale(.5,.5)
        knob.Size = UDim2.fromOffset(12,12)
        knob.BackgroundColor3 = THEME.Text
        knob.Parent = track
        Corner(knob, 6)
        Stroke(knob, THEME.Purple2, 0, 2)

        local min = data.Min or 0
        local max = data.Max or 100
        local value = math.clamp(data.Default or min, min, max)
        local dragging = false

        local function setValueFromX(x)
            local ratio = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local raw = min + (max-min)*ratio
            local step = data.Step or 1
            value = math.floor(raw/step + .5)*step
            value = math.clamp(value, min, max)
            local r = (value-min)/(max-min)
            fill.Size = UDim2.fromScale(r,1)
            knob.Position = UDim2.fromScale(r,.5)
            valueLabel.Text = tostring(value)
            if data.Callback then pcall(data.Callback, value) end
        end

        local function begin(input)
            dragging = true
            setValueFromX(input.Position.X)
            tween(knob, TI_FAST, {Size = UDim2.fromOffset(15,15)})
        end

        Connect(track.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                begin(input)
            end
        end)
        Connect(UIS.InputChanged, function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
                setValueFromX(input.Position.X)
            end
        end)
        Connect(UIS.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    tween(knob, TI_FAST, {Size = UDim2.fromOffset(12,12)})
                end
            end
        end)

        local r = (value-min)/(max-min)
        fill.Size = UDim2.fromScale(r,1)
        knob.Position = UDim2.fromScale(r,.5)
        valueLabel.Text = tostring(value)

        return holder
    end

    function Window:CreateDropdown(parent, data)
        local options = data.Options or {}
        local isOpen = false

        local holder = Instance.new("Frame")
        holder.Name = "Dropdown_" .. (data.Title or "Option")
        holder.Size = UDim2.new(1, 0, 0, 60)
        holder.BackgroundColor3 = THEME.Card
        holder.ClipsDescendants = true
        holder.Parent = parent
        Corner(holder, 9)
        Stroke(holder, THEME.Stroke, 0, 1)

        local title = MakeText(holder, data.Title or "Dropdown", 11, THEME.Text, Enum.Font.GothamBold)
        title.Position = UDim2.fromOffset(12, 8)
        title.Size = UDim2.new(1, -24, 0, 20)

        local dropBtn = Instance.new("TextButton")
        dropBtn.Name = "DropButton"
        dropBtn.Text = ""
        dropBtn.AutoButtonColor = false
        dropBtn.Size = UDim2.new(1, -24, 0, 26)
        dropBtn.Position = UDim2.fromOffset(12, 28)
        dropBtn.BackgroundColor3 = THEME.Panel
        dropBtn.Parent = holder
        Corner(dropBtn, 6)
        Stroke(dropBtn, THEME.Stroke, 0, 1)

        local selectedText = MakeText(dropBtn, data.Default or "Seleccionar...", 10, THEME.PurpleSoft, Enum.Font.GothamMedium)
        selectedText.Position = UDim2.fromOffset(10, 0)
        selectedText.Size = UDim2.new(1, -30, 1, 0)

        local arrow = Image(dropBtn, ICONS.Sliders, UDim2.fromOffset(12, 12), UDim2.new(1, -18, 0.5, -6))
        arrow.ImageColor3 = THEME.Muted

        local container = Instance.new("Frame")
        container.Name = "OptionsContainer"
        container.Size = UDim2.new(1, -24, 0, #options * 28)
        container.Position = UDim2.fromOffset(12, 60)
        container.BackgroundTransparency = 1
        container.ClipsDescendants = true
        container.Parent = holder

        local list = Instance.new("UIListLayout")
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 2)
        list.Parent = container

        local function toggleDropdown()
            isOpen = not isOpen
            local targetHeight = isOpen and (64 + (#options * 28)) or 60
            tween(holder, TI_FAST, {Size = UDim2.new(1, 0, 0, targetHeight)})
            tween(arrow, TI_FAST, {Rotation = isOpen and 180 or 0})
        end

        Connect(dropBtn.Activated, toggleDropdown)

        for _, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Text = ""
            optBtn.Size = UDim2.new(1, 0, 0, 26)
            optBtn.BackgroundColor3 = THEME.Panel
            optBtn.AutoButtonColor = false
            optBtn.Parent = container
            Corner(optBtn, 4)

            local txt = MakeText(optBtn, opt.Name, 10, THEME.Text, Enum.Font.GothamMedium)
            txt.Position = UDim2.fromOffset(10, 0)
            txt.Size = UDim2.new(1, -10, 1, 0)

            Connect(optBtn.MouseEnter, function()
                tween(optBtn, TI_FAST, {BackgroundColor3 = THEME.CardHover})
            end)
            Connect(optBtn.MouseLeave, function()
                tween(optBtn, TI_FAST, {BackgroundColor3 = THEME.Panel})
            end)
            Connect(optBtn.Activated, function()
                selectedText.Text = opt.Name
                toggleDropdown()
                if data.Callback then
                    pcall(data.Callback, opt.Value)
                end
            end)
        end

        return holder
    end

    Window:CreateWindow()

    local tabs = {
        Home = Window:CreateTab("Home", "rbxassetid://108256622731883", "Home"),
        Visual = Window:CreateTab("Visual", "rbxassetid://111545834461192", "Visuales"),
        Autofarm = Window:CreateTab("Autofarm", "rbxassetid://131492848525143", "Autofarm"),
    }

    -- ===================== HOME =====================
    do
        local p = tabs.Home.Page
        Window:CreateLabel(p, "Home", "Bienvenido a SexyBoy Hub.")
        Window:CreateDivider(p, "Info")

        local sec = Window:CreateSection(p, "Informacion", "Creditos y estado del script.")
        Window:CreateButton(sec, {
            Title = "Informacion del Script",
            Description = "Creado por @sexyboy.scripts en TikTok. No pagues por este script gratis!!",
            Icon = "rbxassetid://95298693214604",
            IsToggle = false,
            Callback = function()
            end
        })
        Window:CreateButton(sec, {
            Title = "Novedad",
            Description = "Este script va estar descontinuado por el momento :(",
            Icon = "rbxassetid://123130994927055",
            IsToggle = false,
            Callback = function()
            end
        })
    end

    -- ===================== VISUALES =====================
    do
        local p = tabs.Visual.Page
        Window:CreateLabel(p, "Visuales", "Ver jugadores detras de paredes y mejoras del mapa.")
        Window:CreateDivider(p, "ESP")

        local sec = Window:CreateSection(p, "ESP", "Ver a traves de las paredes.")
        Window:CreateButton(sec, {
            Title = "Ver Jugadores",
            Description = "Ver jugadores/enemigos a traves de las paredes.",
            Icon = "rbxassetid://78032763246209",
            Default = Config.ESPPlayers,
            Callback = function(v) Config.ESPPlayers = v end
        })
        Window:CreateButton(sec, {
            Title = "Ver Esqueleto de Jugadores",
            Description = "Dibuja lineas con la forma del cuerpo (brazos, piernas y torso) de los demás.",
            Icon = "rbxassetid://128632166110674",
            Default = Config.ESPSkeleton,
            Callback = function(v) Config.ESPSkeleton = v end
        })

        ---------------------------------------------------------------
        -- VER ITEMS DROPEADOS
        ---------------------------------------------------------------
        local droppedESP_UI = {}
        local droppedESPConn = nil
        local droppedDB = {}
        local droppedRarityColors = {
            Common = Color3.fromRGB(220, 220, 220),
            Uncommon = Color3.fromRGB(99, 255, 52),
            Rare = Color3.fromRGB(51, 170, 255),
            Epic = Color3.fromRGB(237, 44, 255),
            Legendary = Color3.fromRGB(255, 150, 0),
            Omega = Color3.fromRGB(255, 20, 51),
        }

        local function getDroppedHui()
            local ok, h = pcall(function()
                return gethui()
            end)
            if ok and h then
                return h
            end
            return LocalPlayer:WaitForChild("PlayerGui")
        end

        local DroppedGuiContainer = getDroppedHui():FindFirstChild("DroppedItemESP_Container")
        if not DroppedGuiContainer then
            DroppedGuiContainer = Instance.new("Folder")
            DroppedGuiContainer.Name = "DroppedItemESP_Container"
            DroppedGuiContainer.Parent = getDroppedHui()
        end

        local function formatDroppedImageId(id)
            if not id then
                return nil
            end
            if type(id) == "number" or (type(id) == "string" and tonumber(id)) then
                return "rbxassetid://" .. tostring(id)
            end
            if type(id) == "string" and (id:find("rbxassetid://") or id:find("http")) then
                return id
            end
            return nil
        end

        pcall(function()
            local ItemsFolder = ReplicatedStorage:FindFirstChild("Items")
            if not ItemsFolder then
                return
            end
            for _, folder in ipairs(ItemsFolder:GetChildren()) do
                for _, item in ipairs(folder:GetChildren()) do
                    local dispName = item:GetAttribute("DisplayName") or item.Name
                    local rarity = item:GetAttribute("RarityName") or "Common"
                    local img = formatDroppedImageId(item:GetAttribute("ImageId"))
                    if not img then
                        local h = item:FindFirstChild("Handle")
                        if h then
                            if h:IsA("MeshPart") and h.TextureID ~= "" then
                                img = formatDroppedImageId(h.TextureID)
                            else
                                local m = h:FindFirstChildOfClass("SpecialMesh")
                                if m and m.TextureId ~= "" then
                                    img = formatDroppedImageId(m.TextureId)
                                end
                            end
                        end
                    end
                    img = img or "rbxassetid://7072725737"
                    droppedDB[string.lower(item.Name)] = {
                        Name = dispName,
                        Rarity = rarity,
                        ImageId = img,
                    }
                end
            end
        end)

        local function createDroppedBillboard(model)
            local target = model:FindFirstChild("PickUpZone")
                or model:FindFirstChildWhichIsA("BasePart")
                or model.PrimaryPart
            if not target then
                return nil
            end

            local isMoney = (string.lower(model.Name) == "money")
            local info = droppedDB[string.lower(model.Name)]
            local rarityColor = isMoney and Color3.fromRGB(50, 255, 50)
                or (info and droppedRarityColors[info.Rarity] or Color3.fromRGB(220, 220, 220))
            local imageId = info and info.ImageId or "rbxassetid://7072725737"
            local displayName = isMoney and "Money" or (info and info.Name or model.Name)
            local amount = model:GetAttribute("Amount") or 1

            local bb = Instance.new("BillboardGui")
            bb.Name = "DroppedESP_" .. model.Name
            bb.Adornee = target
            bb.Size = UDim2.new(0, 160, 0, 22)
            bb.StudsOffset = Vector3.new(0, 2, 0)
            bb.AlwaysOnTop = true
            bb.MaxDistance = math.huge
            bb.Parent = DroppedGuiContainer

            local main = Instance.new("Frame")
            main.Name = "Main"
            main.Size = UDim2.new(1, 0, 1, 0)
            main.BackgroundTransparency = 1
            main.Parent = bb

            local layout = Instance.new("UIListLayout")
            layout.FillDirection = Enum.FillDirection.Horizontal
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.Padding = UDim.new(0, 4)
            layout.Parent = main

            if not isMoney then
                local iconF = Instance.new("Frame")
                iconF.Name = "IconFrame"
                iconF.Size = UDim2.new(0, 20, 0, 20)
                iconF.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                iconF.BackgroundTransparency = 0.1
                iconF.BorderSizePixel = 0
                iconF.LayoutOrder = 1
                iconF.Parent = main

                local strokeIcon = Instance.new("UIStroke")
                strokeIcon.Color = rarityColor
                strokeIcon.Thickness = 1.2
                strokeIcon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                strokeIcon.Parent = iconF

                local imgLbl = Instance.new("ImageLabel")
                imgLbl.Size = UDim2.new(1, -4, 1, -4)
                imgLbl.Position = UDim2.new(0, 2, 0, 2)
                imgLbl.BackgroundTransparency = 1
                imgLbl.Image = imageId
                imgLbl.Parent = iconF
            end

            local badge = Instance.new("Frame")
            badge.Name = "Badge"
            badge.AutomaticSize = Enum.AutomaticSize.X
            badge.Size = UDim2.new(0, 0, 0, 20)
            badge.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
            badge.BackgroundTransparency = 0.15
            badge.BorderSizePixel = 0
            badge.LayoutOrder = 2
            badge.Parent = main

            local strokeBadge = Instance.new("UIStroke")
            strokeBadge.Color = rarityColor
            strokeBadge.Thickness = 1.2
            strokeBadge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            strokeBadge.Parent = badge

            local pad = Instance.new("UIPadding")
            pad.PaddingLeft = UDim.new(0, 6)
            pad.PaddingRight = UDim.new(0, 6)
            pad.Parent = badge

            local lbl = Instance.new("TextLabel")
            lbl.Name = "TextInfo"
            lbl.AutomaticSize = Enum.AutomaticSize.X
            lbl.Size = UDim2.new(0, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.RobotoMono
            lbl.TextSize = 11
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            local baseText = (amount > 1) and (displayName .. " x" .. tostring(amount)) or displayName
            lbl.Text = baseText .. " [0m]"
            lbl.Parent = badge

            return bb
        end

        local function clearDroppedESP()
            if droppedESPConn then
                droppedESPConn:Disconnect()
                droppedESPConn = nil
            end
            for model, gui in pairs(droppedESP_UI) do
                if gui and gui.Parent then
                    gui:Destroy()
                end
                droppedESP_UI[model] = nil
            end
            Config.ESPDroppedItems = false
        end

        local function startDroppedESP()
            if droppedESPConn then
                return
            end
            Config.ESPDroppedItems = true
            droppedESPConn = RunService.RenderStepped:Connect(function()
                if not Config.ESPDroppedItems then
                    return
                end

                for model, gui in pairs(droppedESP_UI) do
                    if not model or not model.Parent then
                        if gui and gui.Parent then
                            gui:Destroy()
                        end
                        droppedESP_UI[model] = nil
                    end
                end

                local dropped = workspace:FindFirstChild("DroppedItems")
                if not dropped then
                    return
                end

                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                for _, model in ipairs(dropped:GetChildren()) do
                    if model:IsA("Model") and not model:GetAttribute("Locked") then
                        local target = model:FindFirstChild("PickUpZone")
                            or model:FindFirstChildWhichIsA("BasePart")
                            or model.PrimaryPart
                        if target then
                            local gui = droppedESP_UI[model]
                            if not gui or not gui.Parent then
                                gui = createDroppedBillboard(model)
                                droppedESP_UI[model] = gui
                            end

                            if gui then
                                gui.Enabled = true
                                if root then
                                    local dist = math.floor((target.Position - root.Position).Magnitude)
                                    local isMoney = (string.lower(model.Name) == "money")
                                    local info = droppedDB[string.lower(model.Name)]
                                    local displayName = isMoney and "Money" or (info and info.Name or model.Name)
                                    local amount = model:GetAttribute("Amount") or 1
                                    local mainFrame = gui:FindFirstChild("Main")
                                    local badgeFrame = mainFrame and mainFrame:FindFirstChild("Badge")
                                    local textLabel = badgeFrame and badgeFrame:FindFirstChild("TextInfo")
                                    if textLabel then
                                        local baseText = (amount > 1) and (displayName .. " x" .. tostring(amount)) or displayName
                                        textLabel.Text = baseText .. " [" .. tostring(dist) .. "m]"
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end

        Window:CreateButton(sec, {
            Title = "Ver Items Dropeados",
            Description = "Ver todos los items dropeados del mapa a tiempo real",
            Icon = "rbxassetid://79335733735718",
            Default = Config.ESPDroppedItems,
            Callback = function(v)
                if v then
                    startDroppedESP()
                else
                    clearDroppedESP()
                end
            end
        })

        ---------------------------------------------------------------
        -- VER INVENTARIOS (Inventory ESP)
        ---------------------------------------------------------------
        local WeaponRegistry = {}
        local InvBillboards = {}
        local invUpdateConnections = {}
        local invCharConns = {}
        local invLoopRunning = false

        local INV_RARITY_COLORS = {
            Common = Color3.fromRGB(255, 255, 255),
            Uncommon = Color3.fromRGB(99, 255, 52),
            Rare = Color3.fromRGB(51, 170, 255),
            Epic = Color3.fromRGB(237, 44, 255),
            Legendary = Color3.fromRGB(255, 150, 0),
            Omega = Color3.fromRGB(255, 20, 51),
        }

        local function invRegisterItems(folder)
            for _, tool in ipairs(folder:GetChildren()) do
                if tool:IsA("Tool") then
                    local handle = tool:FindFirstChild("Handle")
                    local displayName = tool:GetAttribute("DisplayName") or tool.Name
                    local itemId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
                    local rarity = tool:GetAttribute("RarityName") or "Common"
                    local imageId = tool:GetAttribute("ImageId") or "rbxassetid://7072725737"
                    local key
                    if handle then
                        local mesh = handle:FindFirstChildOfClass("SpecialMesh")
                        if mesh and mesh.MeshId ~= "" then
                            key = mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity
                        elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
                            key = handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity
                        end
                    end
                    if not key and itemId and itemId ~= "" and itemId ~= tool.Name then
                        key = "ITEMID_" .. itemId .. "_RARITY_" .. rarity
                    end
                    if not key then
                        key = "NAME_" .. displayName .. "_" .. tool.Name .. "_RARITY_" .. rarity
                    end
                    WeaponRegistry[key] = {
                        Name = displayName,
                        Rarity = rarity,
                        ImageId = imageId,
                        ToolName = tool.Name,
                    }
                end
            end
        end

        pcall(function()
            local itemsRoot = ReplicatedStorage:FindFirstChild("Items")
                or ReplicatedStorage:WaitForChild("Items", 5)
            if itemsRoot then
                for _, fname in ipairs({
                    "gun", "melee", "throwable", "consumable", "farming", "misc", "rod", "fish",
                }) do
                    local f = itemsRoot:FindFirstChild(fname)
                    if f then
                        invRegisterItems(f)
                    end
                end
            end
        end)

        local function invGetItemKey(tool)
            local handle = tool:FindFirstChild("Handle")
            local displayName = tool:GetAttribute("DisplayName") or tool.Name
            local itemId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
            local rarity = tool:GetAttribute("RarityName") or "Common"
            if handle then
                local mesh = handle:FindFirstChildOfClass("SpecialMesh")
                if mesh and mesh.MeshId ~= "" then
                    return mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity
                end
                if handle:IsA("MeshPart") and handle.MeshId ~= "" then
                    return handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity
                end
            end
            if itemId and itemId ~= "" and itemId ~= tool.Name then
                return "ITEMID_" .. itemId .. "_RARITY_" .. rarity
            end
            return "NAME_" .. displayName .. "_" .. tool.Name .. "_RARITY_" .. rarity
        end

        local function invGetWeaponInfo(tool)
            if not tool or not tool:IsA("Tool") then
                return nil
            end
            return WeaponRegistry[invGetItemKey(tool)]
        end

        local function invGetPlayerTools(player)
            local tools = {}
            local char = player.Character
            for _, bag in ipairs({ "Backpack", "StarterGear", "StarterPack" }) do
                local b = player:FindFirstChild(bag)
                if b then
                    for _, t in ipairs(b:GetChildren()) do
                        if t:IsA("Tool") and t.Name ~= "Fists" then
                            table.insert(tools, t)
                        end
                    end
                end
            end
            if char then
                for _, t in ipairs(char:GetChildren()) do
                    if t:IsA("Tool") and t.Name ~= "Fists" then
                        table.insert(tools, t)
                    end
                end
            end
            return tools
        end

        local function invRemoveBillboard(player)
            if InvBillboards[player] then
                pcall(function()
                    InvBillboards[player]:Destroy()
                end)
                InvBillboards[player] = nil
            end
        end

        local function invBuildBillboard(player)
            invRemoveBillboard(player)
            if not Config.ESPInventories then
                return
            end
            local char = player.Character
            if not char then
                return
            end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then
                return
            end

            local tools = invGetPlayerTools(player)
            local infos = {}
            for _, t in ipairs(tools) do
                local info = invGetWeaponInfo(t)
                if info then
                    table.insert(infos, info)
                end
            end
            if #infos == 0 then
                return
            end

            local ICON = 26
            local GAP = 4
            local totalW = #infos * (ICON + GAP) - GAP

            local bb = Instance.new("BillboardGui")
            bb.Name = "InvESP_" .. player.Name
            bb.Adornee = hrp
            bb.Size = UDim2.new(0, totalW + 16, 0, ICON + 4)
            bb.StudsOffset = Vector3.new(0, 5.0, 0)
            bb.AlwaysOnTop = true
            bb.ResetOnSpawn = false
            bb.Parent = char

            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 1, 0)
            row.Position = UDim2.new(0, 0, 0, 0)
            row.BackgroundTransparency = 1
            row.Parent = bb

            local layout = Instance.new("UIListLayout")
            layout.FillDirection = Enum.FillDirection.Horizontal
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, GAP)
            layout.Parent = row

            for i, info in ipairs(infos) do
                local rarityColor = INV_RARITY_COLORS[info.Rarity] or Color3.fromRGB(255, 255, 255)
                local slot = Instance.new("Frame")
                slot.Size = UDim2.new(0, ICON, 0, ICON)
                slot.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                slot.BackgroundTransparency = 0.2
                slot.LayoutOrder = i
                slot.Parent = row
                Instance.new("UICorner", slot).CornerRadius = UDim.new(0, 5)

                local stroke = Instance.new("UIStroke")
                stroke.Color = rarityColor
                stroke.Thickness = 1.8
                stroke.Parent = slot

                local img = Instance.new("ImageLabel")
                img.Size = UDim2.new(1, -4, 1, -4)
                img.Position = UDim2.new(0, 2, 0, 2)
                img.BackgroundTransparency = 1
                img.Image = info.ImageId
                img.ScaleType = Enum.ScaleType.Fit
                img.Parent = slot
            end

            InvBillboards[player] = bb
        end

        local function invSetupWatch(player)
            if invUpdateConnections[player] then
                pcall(function()
                    invUpdateConnections[player]:Disconnect()
                end)
                invUpdateConnections[player] = nil
            end
            local function refresh()
                if Config.ESPInventories then
                    invBuildBillboard(player)
                end
            end
            local bp = player:FindFirstChild("Backpack")
            if bp then
                invUpdateConnections[player] = bp.ChildAdded:Connect(function()
                    task.wait(0.1)
                    refresh()
                end)
                bp.ChildRemoved:Connect(function()
                    task.wait(0.1)
                    refresh()
                end)
            end
        end

        local function invClearPlayer(player)
            invRemoveBillboard(player)
            if invUpdateConnections[player] then
                pcall(function()
                    invUpdateConnections[player]:Disconnect()
                end)
                invUpdateConnections[player] = nil
            end
        end

        local function invClearAll()
            for _, plr in ipairs(Players:GetPlayers()) do
                invClearPlayer(plr)
            end
            for plr in pairs(InvBillboards) do
                invClearPlayer(plr)
            end
        end

        local function invStart()
            Config.ESPInventories = true
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    if p.Character then
                        invBuildBillboard(p)
                        invSetupWatch(p)
                    end
                    if not invCharConns[p] then
                        invCharConns[p] = p.CharacterAdded:Connect(function()
                            task.wait(0.5)
                            if Config.ESPInventories then
                                invBuildBillboard(p)
                                invSetupWatch(p)
                            end
                        end)
                    end
                end
            end
            if not invLoopRunning then
                invLoopRunning = true
                task.spawn(function()
                    while Config.ESPInventories do
                        task.wait(1.5)
                        if not Config.ESPInventories then
                            break
                        end
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character then
                                invBuildBillboard(p)
                            end
                        end
                    end
                    invLoopRunning = false
                end)
            end
        end

        local function invStop()
            Config.ESPInventories = false
            invClearAll()
        end

        if not _G._SB_InvPlayerAdded then
            _G._SB_InvPlayerAdded = Players.PlayerAdded:Connect(function(p)
                if p == LocalPlayer then
                    return
                end
                invCharConns[p] = p.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if Config.ESPInventories then
                        invBuildBillboard(p)
                        invSetupWatch(p)
                    end
                end)
            end)
            Players.PlayerRemoving:Connect(function(p)
                invClearPlayer(p)
                if invCharConns[p] then
                    pcall(function()
                        invCharConns[p]:Disconnect()
                    end)
                    invCharConns[p] = nil
                end
            end)
        end

        Window:CreateButton(sec, {
            Title = "Ver Inventarios",
            Description = "Ver inventarios de los demas jugadores",
            Icon = "rbxassetid://117589225473403",
            Default = Config.ESPInventories,
            Callback = function(v)
                if v then
                    invStart()
                else
                    invStop()
                end
            end
        })

        ---------------------------------------------------------------
        -- VER ALMACENAMIENTOS (SAFE ESP)
        ---------------------------------------------------------------
        local SAFE_TARGET_NAME = "Safe"
        local SAFE_ICON_TEXTURE = "rbxassetid://115879134681827"
        local SAFE_ICON_SIZE = UDim2.new(0, 10, 0, 10)
        local safeConnection = nil

        local function getSafeTargetPart(model)
            if model:IsA("BasePart") then
                return model
            elseif model:IsA("Model") then
                return model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
            end
            return nil
        end

        local function createSafeESP(object)
            if object.Name ~= SAFE_TARGET_NAME then return end

            local targetPart = getSafeTargetPart(object)
            if not targetPart then return end

            if targetPart:FindFirstChild("Safe_ESP") then return end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "Safe_ESP"
            billboard.Adornee = targetPart
            billboard.Size = SAFE_ICON_SIZE
            billboard.AlwaysOnTop = true
            billboard.ExtentsOffset = Vector3.new(0, 2, 0)

            local imageLabel = Instance.new("ImageLabel")
            imageLabel.Name = "Icon"
            imageLabel.Size = UDim2.new(1, 0, 1, 0)
            imageLabel.BackgroundTransparency = 1
            imageLabel.Image = SAFE_ICON_TEXTURE
            imageLabel.Parent = billboard

            billboard.Parent = targetPart
        end

        local function clearSafeESP()
            if safeConnection then
                safeConnection:Disconnect()
                safeConnection = nil
            end
            for _, descendant in ipairs(workspace:GetDescendants()) do
                local targetPart = getSafeTargetPart(descendant)
                if targetPart then
                    local esp = targetPart:FindFirstChild("Safe_ESP")
                    if esp then esp:Destroy() end
                end
            end
        end

        Window:CreateButton(sec, {
            Title = "Ver Almacenamientos",
            Description = "Ver todas las cajas fuertes de todo el mapa",
            Icon = "rbxassetid://115879134681827",
            Default = false,
            Callback = function(v)
                if v then
                    for _, descendant in ipairs(workspace:GetDescendants()) do
                        createSafeESP(descendant)
                    end
                    safeConnection = workspace.DescendantAdded:Connect(function(descendant)
                        createSafeESP(descendant)
                    end)
                else
                    clearSafeESP()
                end
            end
        })

        ---------------------------------------------------------------
        -- VER CAJEROS
        ---------------------------------------------------------------
        local CAJERO_TARGET_NAME = "Meshes/at_Cube.002 (2)"
        local CAJERO_ICON = "rbxassetid://75802427826962"
        local CAJERO_BADGE = "rbxassetid://71722118135407"
        local CAJERO_ICON_SIZE = UDim2.new(0, 50, 0, 50)
        local CAJERO_BADGE_SIZE = UDim2.new(0, 20, 0, 20)
        local cajeroConnection = nil

        local function CreateCajeroESP(part)
            if not part:IsA("BasePart") or part:FindFirstChild("ESP_Billboard") then
                return
            end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESP_Billboard"
            billboard.Adornee = part
            billboard.Size = CAJERO_ICON_SIZE
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true

            local imageLabel = Instance.new("ImageLabel")
            imageLabel.Name = "ESP_Image"
            imageLabel.Size = UDim2.new(1, 0, 1, 0)
            imageLabel.BackgroundTransparency = 1
            imageLabel.Image = CAJERO_ICON
            imageLabel.Parent = billboard

            local badge = Instance.new("ImageLabel")
            badge.Name = "ESP_Badge"
            badge.Size = CAJERO_BADGE_SIZE
            badge.AnchorPoint = Vector2.new(1, 0)
            badge.Position = UDim2.new(1, 2, 0, -2)
            badge.BackgroundTransparency = 1
            badge.Image = CAJERO_BADGE
            badge.ZIndex = 2
            badge.Parent = billboard

            billboard.Parent = part
        end

        local function ClearCajeroESP()
            if cajeroConnection then
                cajeroConnection:Disconnect()
                cajeroConnection = nil
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part.Name == CAJERO_TARGET_NAME then
                    local billboard = part:FindFirstChild("ESP_Billboard")
                    if billboard then billboard:Destroy() end
                end
            end
        end

        Window:CreateButton(sec, {
            Title = "Ver Cajeros",
            Description = "Marca la ubicacion de cada cajero automatico del mapa",
            Icon = "rbxassetid://71722118135407",
            Default = false,
            Callback = function(v)
                if v then
                    for _, descendant in ipairs(workspace:GetDescendants()) do
                        if descendant.Name == CAJERO_TARGET_NAME then
                            CreateCajeroESP(descendant)
                        end
                    end
                    cajeroConnection = workspace.DescendantAdded:Connect(function(descendant)
                        if descendant.Name == CAJERO_TARGET_NAME then
                            CreateCajeroESP(descendant)
                        end
                    end)
                else
                    ClearCajeroESP()
                end
            end
        })

        local sec2 = Window:CreateSection(p, "Ambiente", "Vista limpia y rendimiento.")
        Window:CreateButton(sec2, {
            Title = "Quitar Niebla del Mapa",
            Description = "Borra toda la niebla para que puedas ver super claro a larga distancia.",
            Icon = "rbxassetid://86319196334489",
            Default = Config.NoFog,
            Callback = function(v)
                Config.NoFog = v
                if not v then
                    Lighting.FogEnd = State.OrigFogEnd
                    Lighting.FogStart = State.OrigFogStart
                    if State.OrigAtmosphere then State.OrigAtmosphere.Parent = Lighting end
                end
            end
        })
        Window:CreateSlider(sec2, {
            Title = "Zoom de Camara (FOV)",
            Description = "Aumenta el angulo de vision para ver mas espacio a tus costados.",
            Min = 50, Max = 120, Default = Config.CameraFOV, Step = 1,
            Callback = function(v)
                Config.CameraFOV = v
                if workspace.CurrentCamera then
                    workspace.CurrentCamera.FieldOfView = v
                end
            end
        })
        Window:CreateButton(sec2, {
            Title = "Quitar Lag (Optimizar)",
            Description = "Elimina basura del mapa entre otros.",
            Icon = "rbxassetid://99491557009012",
            IsToggle = false,
            Callback = function()
                local TARGET_NAMES = {
                    Tree = true,
                    Palms1 = true,
                    bush2 = true,
                    StreetLight2 = true,
                    Fence = true,
                    Generator = true,
                    PalmsTall = true,
                    Enclosured = true,
                    PowerLines = true,
                    DecidTree = true,
                }

                pcall(function()
                    Lighting.GlobalShadows = false
                    Lighting.FogEnd = 9e9
                    Lighting.FogStart = 0
                    Lighting.Brightness = 2
                    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
                    if atm then
                        atm:Destroy()
                    end
                    for _, fx in ipairs(Lighting:GetChildren()) do
                        if fx:IsA("BloomEffect")
                            or fx:IsA("BlurEffect")
                            or fx:IsA("SunRaysEffect")
                            or fx:IsA("DepthOfFieldEffect")
                            or fx:IsA("ColorCorrectionEffect") then
                            fx.Enabled = false
                        end
                    end
                end)

                for _, obj in ipairs(workspace:GetDescendants()) do
                    pcall(function()
                        if TARGET_NAMES[obj.Name] then
                            obj:Destroy()
                            return
                        end
                        if obj:IsA("BasePart") then
                            obj.Material = Enum.Material.SmoothPlastic
                            obj.CastShadow = false
                        elseif obj:IsA("Decal") or obj:IsA("Texture") then
                            obj.Transparency = 1
                        elseif obj:IsA("ParticleEmitter")
                            or obj:IsA("Trail")
                            or obj:IsA("Smoke")
                            or obj:IsA("Fire")
                            or obj:IsA("Sparkles") then
                            obj.Enabled = false
                        elseif obj:IsA("PointLight")
                            or obj:IsA("SpotLight")
                            or obj:IsA("SurfaceLight") then
                            obj.Enabled = false
                        end
                    end)
                end

                if not _G._SB_AntiLagDescendantConn then
                    _G._SB_AntiLagDescendantConn = workspace.DescendantAdded:Connect(function(obj)
                        if TARGET_NAMES[obj.Name] then
                            task.defer(function()
                                pcall(function()
                                    obj:Destroy()
                                end)
                            end)
                        end
                    end)
                end
            end
        })
    end

    -- ===================== AUTOFARM =====================
    do
        local p = tabs.Autofarm.Page
        Window:CreateLabel(p, "Autofarm", "Farms automaticos del mapa.")
        Window:CreateDivider(p, "Trabajos")

        local farmSec = Window:CreateSection(p, "Conserje", "Limpieza de charcos y movimiento.")

        -- Puddle farm logic (pathfinding, sin noclip)
        local PF_SMALL_WAIT = 5.2
        local PF_LARGE_WAIT = 10.2
        local PF_ARRIVE = 4
        local PF_TIMEOUT = 35
        local PF_CLEAN_T = 0.85
        local PF_WP_DIST = 3.5

        local function pfGetHRP()
            local c = LocalPlayer.Character
            return c and c:FindFirstChild("HumanoidRootPart")
        end
        local function pfGetHum()
            local c = LocalPlayer.Character
            return c and c:FindFirstChildOfClass("Humanoid")
        end
        local function pfGetPart(obj)
            if obj:IsA("BasePart") then
                return obj
            end
            if obj:IsA("Model") then
                return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
            end
            return obj:FindFirstChildWhichIsA("BasePart", true)
        end
        local function pfIsDirty(part)
            return part and part.Parent and part.Transparency < PF_CLEAN_T
        end
        local function pfFindDirty()
            local list = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "SmallPuddle" or obj.Name == "LargePuddle" then
                    local part = pfGetPart(obj)
                    if part and pfIsDirty(part) then
                        table.insert(list, {
                            name = obj.Name,
                            part = part,
                            waitTime = (obj.Name == "LargePuddle") and PF_LARGE_WAIT or PF_SMALL_WAIT,
                        })
                    end
                end
            end
            return list
        end
        local function pfCompute(fromPos, toPos)
            local path = PathfindingService:CreatePath({
                AgentRadius = 2.0,
                AgentHeight = 5,
                AgentCanJump = true,
                AgentCanClimb = false,
                WaypointSpacing = 4,
                Costs = { Water = 20 },
            })
            local ok = pcall(function()
                path:ComputeAsync(fromPos, toPos)
            end)
            if not ok or path.Status ~= Enum.PathStatus.Success then
                return nil
            end
            return path:GetWaypoints()
        end
        local function pfWalkTo(part)
            local hum = pfGetHum()
            local hrp = pfGetHRP()
            if not hum or not hrp or not part then
                return false
            end
            local goal = part.Position + Vector3.new(0, 1, 0)
            local waypoints = pfCompute(hrp.Position, goal)

            if not waypoints or #waypoints == 0 then
                hum:MoveTo(goal)
                local start = os.clock()
                while os.clock() - start < 12 do
                    if not Config.PuddleFarm then
                        return false
                    end
                    hrp = pfGetHRP()
                    hum = pfGetHum()
                    if not hrp or not hum then
                        return false
                    end
                    if not pfIsDirty(part) then
                        return false
                    end
                    if (hrp.Position - part.Position).Magnitude <= PF_ARRIVE then
                        return true
                    end
                    if (os.clock() - start) > 2 then
                        hum.Jump = true
                        local right = hrp.CFrame.RightVector * (math.random() > 0.5 and 5 or -5)
                        hum:MoveTo(hrp.Position + right)
                        task.wait(0.4)
                        hum:MoveTo(goal)
                    end
                    task.wait(0.15)
                end
                local root = pfGetHRP()
                return root and (root.Position - part.Position).Magnitude <= PF_ARRIVE
            end

            local startAll = os.clock()
            for _, wp in ipairs(waypoints) do
                if not Config.PuddleFarm then
                    return false
                end
                if os.clock() - startAll > PF_TIMEOUT then
                    return false
                end
                if not pfIsDirty(part) then
                    return false
                end
                hum = pfGetHum()
                hrp = pfGetHRP()
                if not hum or not hrp then
                    return false
                end
                if wp.Action == Enum.PathWaypointAction.Jump then
                    hum.Jump = true
                end
                hum:MoveTo(wp.Position)
                local wpStart = os.clock()
                while os.clock() - wpStart < 8 do
                    if not Config.PuddleFarm then
                        return false
                    end
                    hrp = pfGetHRP()
                    hum = pfGetHum()
                    if not hrp or not hum then
                        return false
                    end
                    if (hrp.Position - wp.Position).Magnitude <= PF_WP_DIST then
                        break
                    end
                    if os.clock() - wpStart > 3.5 then
                        hum.Jump = true
                        local newWps = pfCompute(hrp.Position, goal)
                        if newWps and #newWps > 0 then
                            return pfWalkTo(part)
                        end
                        local side = hrp.CFrame.RightVector * (math.random() > 0.5 and 6 or -6)
                        hum:MoveTo(hrp.Position + side)
                        task.wait(0.45)
                        hum:MoveTo(wp.Position)
                        wpStart = os.clock()
                    end
                    task.wait(0.12)
                end
                if (hrp.Position - part.Position).Magnitude <= PF_ARRIVE then
                    return true
                end
            end
            hrp = pfGetHRP()
            return hrp ~= nil and (hrp.Position - part.Position).Magnitude <= PF_ARRIVE
        end
        local function pfWaitClean(part, maxWait)
            local start = os.clock()
            while os.clock() - start < maxWait do
                if not Config.PuddleFarm then
                    return false
                end
                if not part or not part.Parent or not pfIsDirty(part) then
                    return true
                end
                task.wait(0.2)
            end
            return not pfIsDirty(part)
        end

        task.spawn(function()
            while true do
                task.wait(0.25)
                if not Config.PuddleFarm then
                    continue
                end
                local hrp = pfGetHRP()
                local hum = pfGetHum()
                if not hrp or not hum or hum.Health <= 0 then
                    continue
                end
                local puddles = pfFindDirty()
                if #puddles == 0 then
                    task.wait(1.5)
                    continue
                end
                table.sort(puddles, function(a, b)
                    return (a.part.Position - hrp.Position).Magnitude
                        < (b.part.Position - hrp.Position).Magnitude
                end)
                local target = puddles[1]
                local arrived = pfWalkTo(target.part)
                if not Config.PuddleFarm then
                    continue
                end
                if not arrived then
                    task.wait(0.4)
                    continue
                end
                local stay = pfGetHRP()
                if stay and pfGetHum() then
                    pfGetHum():MoveTo(stay.Position)
                end
                pfWaitClean(target.part, target.waitTime + 2)
                task.wait(0.35)
            end
        end)

        Window:CreateButton(farmSec, {
            Title = "AutoFarm Charcos",
            Description = "Limpia los charcos cercanos sin que hagas nada",
            Icon = "rbxassetid://87113348083355",
            Default = Config.PuddleFarm,
            Callback = function(v)
                Config.PuddleFarm = v
                if not v then
                    local hum = pfGetHum()
                    local hrp = pfGetHRP()
                    if hum and hrp then
                        pcall(function()
                            hum:MoveTo(hrp.Position)
                        end)
                    end
                end
            end
        })


        Window:CreateButton(farmSec, {
            Title = "Moverte Rapido",
            Description = "Velocidad de movimiento",
            Icon = "rbxassetid://88401619016130",
            Default = Config.FastMove,
            Callback = function(v)
                Config.FastMove = v
                SetInfiniteSprint(v)
            end
        })

        ---------------------------------------------------------------
        -- AUTOFARM ATM (bajo el mapa + minijuego)
        ---------------------------------------------------------------
        local atmSec = Window:CreateSection(p, "Cajeros ATM", "Experimental, funciona bien con el cuatriciclo solo ( HackToolBasic )")

        local ATM_LOCATIONS = {
            Vector3.new(-226, 255, 487),
            Vector3.new(-199, 255, -250),
            Vector3.new(180, 252, -241),
            Vector3.new(96, 256, 167),
            Vector3.new(453, 256, 37),
            Vector3.new(-133, 256, 104),
            Vector3.new(-200, 255, -569),
        }
        local HACK_TOOL = "HackToolBasic"
        local ATM_MATCH_DIST = 30
        local HACK_ATTEMPTS = 3
        local MINIGAME_START_WAIT = 3
        local MINIGAME_END_GRACE = 3
        local MINIGAME_MAX_TIME = 90
        local AFTER_HACK_WAIT = 1.0
        local CLICK_COOLDOWN = 0.4
        local REACTION_MIN = 0.05
        local REACTION_MAX = 0.15
        local UNDER_DEPTH = 20
        local CARPET_SIZE = 6000
        local ACCEL = 40
        local BRAKE_ACCEL = 45
        local TURN_GAIN = 5
        local MAX_TURN = 3.5
        local TURN_ACCEL = 20
        local REVERSE_FRONT = false
        local SURFACE_RADII = { 10, 14, 18 }
        local FALLBACK_PARK = 12
        local TUNNEL_ROUTES = {
            {
                atm = Vector3.new(96, 256, 167),
                points = {
                    Vector3.new(61, 235, 158),
                    Vector3.new(60, 235, 253),
                    Vector3.new(171, 235, 250),
                    Vector3.new(203, 235, 107),
                    Vector3.new(91, 235, 103),
                    Vector3.new(96, 256, 167),
                },
                stop = Vector3.new(94, 235, 165),
            },
        }
        local TUNNEL_FLOOR_OFFSET = 4
        local TUNNEL_SPEED = 25
        local TUNNEL_CAPTURE = 4
        local TUNNEL_SLAB_RATE = 6
        local WAYPOINT_SPACING = 8
        local LOOKAHEAD = 16
        local SENSE_MIN = 15
        local SENSE_MAX = 90
        local STOP_DIST = 9
        local RAY_HEIGHT = 2
        local MIN_BLOCK_SLOPE = 0.55
        local BLOCKED_TIMEOUT = 5
        local UNDER_ARRIVE = 4
        local UNDER_TIMEOUT = 150
        local PLAYER_SHAFT = 8
        local HACK_WALK_DIST = 5
        local WALK_TIMEOUT = 15
        local PROMPT_RADIUS = 20
        local SIT_ATTEMPTS = 3

        local atmRunId = 0
        local atmBusy = false
        local atmSolverOn = false
        local atmLastClick = 0
        local atmPendingClick = false
        local atmLastResultAt = 0
        local atmCarpet, atmElevator, atmCarpetTop, atmStdCarpetTop
        local atmChanged = {}
        local VirtualInputManager = game:GetService("VirtualInputManager")

        local function atmStatus(txt)
            pcall(function()
                if _G.SB_AtmStatus then
                    _G.SB_AtmStatus.Text = tostring(txt)
                end
            end)
        end

        local function atmFlat(v)
            return Vector3.new(v.X, 0, v.Z)
        end
        local function atmApproach(cur, target, maxDelta)
            if cur < target then
                return math.min(cur + maxDelta, target)
            end
            return math.max(cur - maxDelta, target)
        end
        local function atmDriveSpeed()
            return Config.AtmDriveSpeed or 60
        end
        local function atmLiftSpeed()
            return Config.AtmLiftSpeed or 12
        end

        local function atmGetSeatAndVehicle()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local seat = hum and hum.SeatPart
            if not seat then return nil, nil, nil end
            local model = seat:FindFirstAncestorWhichIsA("Model")
            if not model then return nil, nil, nil end
            while model.Parent and model.Parent:IsA("Model") do
                model = model.Parent
            end
            if model == char then return nil, nil, nil end
            return seat, model, hum
        end

        local atmSend = nil
        pcall(function()
            atmSend = ReplicatedStorage:WaitForChild("Remotes", 8):WaitForChild("Send", 8)
        end)
        local atmCounter = nil
        pcall(function()
            for _, obj in ipairs(getgc(true)) do
                if typeof(obj) == "table"
                    and type(rawget(obj, "event")) == "number"
                    and type(rawget(obj, "func")) == "number" then
                    atmCounter = obj
                    break
                end
            end
        end)
        task.spawn(function()
            if _G.__sbAtmHook then return end
            if not (atmSend and hookmetamethod and getnamecallmethod and newcclosure) then return end
            _G.__sbAtmHook = true
            local old
            old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                if self == atmSend and getnamecallmethod() == "FireServer" then
                    local a1 = ...
                    if typeof(a1) == "number" then
                        _G.__sbAtmLastSendId = a1
                    end
                end
                return old(self, ...)
            end))
        end)
        local function atmNextEventId()
            local id
            if atmCounter and type(atmCounter.event) == "number" then
                id = atmCounter.event + 1
            end
            local seen = _G.__sbAtmLastSendId
            if seen and (not id or seen >= id) then
                id = seen + 1
            end
            if id and atmCounter and type(atmCounter.event) == "number" then
                atmCounter.event = id
            end
            return id
        end

        local atmSliderMG, atmSliderCS
        pcall(function()
            atmSliderCS = require(ReplicatedStorage.Modules.Game.Minigames.SliderConstants)
            atmSliderMG = require(ReplicatedStorage.Modules.Game.Minigames.SliderMinigame)
        end)
        local function atmMinigameActive()
            local ok, en = pcall(function()
                return atmSliderMG and atmSliderMG.enabled.get()
            end)
            return ok and en == true
        end
        local function atmIsInTarget()
            if not atmSliderCS or not atmSliderMG then return false end
            local ok, hit = pcall(function()
                if not atmSliderMG.enabled.get() then return false end
                local t = workspace:GetServerTimeNow()
                local needle = atmSliderCS.needle_at(t)
                return atmSliderCS.is_hit(needle, atmSliderMG.target_pos.get(), atmSliderMG.target_size.get())
            end)
            return ok and hit == true
        end
        local function atmDoClick()
            local now = os.clock()
            if now - atmLastClick < CLICK_COOLDOWN then return end
            atmLastClick = now
            local cam = workspace.CurrentCamera
            local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, true, game, 0)
                task.wait(0.01)
                VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, false, game, 0)
            end)
        end
        RunService.RenderStepped:Connect(function()
            if not atmSolverOn or atmPendingClick then return end
            if atmMinigameActive() and atmIsInTarget() then
                atmPendingClick = true
                local delay = REACTION_MIN + math.random() * (REACTION_MAX - REACTION_MIN)
                task.delay(delay, function()
                    if atmSolverOn and atmMinigameActive() and atmIsInTarget() then
                        atmDoClick()
                    end
                    atmPendingClick = false
                end)
            end
        end)
        if atmSend then
            atmSend.OnClientEvent:Connect(function(kind)
                if kind == "minigame_result" then
                    atmLastResultAt = os.clock()
                end
            end)
        end

        local function atmInstPos(inst)
            if inst:IsA("Model") then return inst:GetPivot().Position end
            if inst:IsA("BasePart") then return inst.Position end
            return nil
        end
        local function atmFindNear(pos)
            local map = workspace:FindFirstChild("Map")
            local props = map and map:FindFirstChild("Props")
            local folder = props and props:FindFirstChild("ATMs")
            if not folder then return nil end
            local best, bestD
            for _, a in ipairs(folder:GetChildren()) do
                local p = atmInstPos(a)
                if p then
                    local d = (p - pos).Magnitude
                    if not bestD or d < bestD then best, bestD = a, d end
                end
            end
            if best and bestD <= ATM_MATCH_DIST then return best end
            return nil
        end

        local function atmHack(name, atmPos, cancelled)
            if not atmSend then atmStatus("No Remotes.Send") return false end
            local atm = atmFindNear(atmPos)
            if not atm then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                atm = hrp and atmFindNear(hrp.Position)
            end
            if not atm then atmStatus(name .. ": ATM no encontrado") return false end
            for attempt = 1, HACK_ATTEMPTS do
                if cancelled() then return false end
                local id = atmNextEventId()
                if not id then atmStatus("Sin contador") return false end
                atmStatus(("%s hack %d id %d"):format(name, attempt, id))
                pcall(function()
                    atmSend:FireServer(id, "request_begin_hacking_3", atm, HACK_TOOL)
                end)
                local t0 = os.clock()
                while not atmMinigameActive() and os.clock() - t0 < MINIGAME_START_WAIT do
                    if cancelled() then return false end
                    task.wait(0.1)
                end
                if atmMinigameActive() then
                    atmStatus(name .. ": minijuego...")
                    local startedAt = os.clock()
                    local inactiveSince = nil
                    while os.clock() - startedAt < MINIGAME_MAX_TIME do
                        if cancelled() then return false end
                        if atmLastResultAt >= startedAt then break end
                        if atmMinigameActive() then
                            inactiveSince = nil
                        else
                            inactiveSince = inactiveSince or os.clock()
                            if os.clock() - inactiveSince > MINIGAME_END_GRACE then break end
                        end
                        task.wait(0.1)
                    end
                    task.wait(AFTER_HACK_WAIT)
                    return true
                end
            end
            atmStatus(name .. ": sin minijuego")
            return false
        end

        local function atmEject(hum, seat)
            hum.PlatformStand = true
            hum.Sit = false
            task.wait(0.15)
            if hum.SeatPart then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.2)
            end
            if hum.SeatPart then
                for _, d in ipairs(seat:GetChildren()) do
                    if d.Name == "SeatWeld" then d:Destroy() end
                end
                task.wait(0.2)
            end
            local t0 = tick()
            while hum.SeatPart and tick() - t0 < 1.5 do task.wait(0.05) end
            hum.PlatformStand = false
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            return hum.SeatPart == nil
        end

        local function atmWalkNear(hum, target, tolerance, cancelled)
            local char = hum.Parent
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return false end
            local rayP = RaycastParams.new()
            rayP.FilterType = Enum.RaycastFilterType.Exclude
            rayP.FilterDescendantsInstances = { char }
            rayP.RespectCanCollide = true
            local t0 = tick()
            local lastPos, lastCheck = hrp.Position, tick()
            while tick() - t0 < WALK_TIMEOUT do
                if cancelled() then return false end
                local toTarget = atmFlat(target) - atmFlat(hrp.Position)
                if toTarget.Magnitude <= tolerance then return true end
                hum:MoveTo(target)
                local origin = hrp.Position - Vector3.new(0, 1.5, 0)
                local hit = workspace:Raycast(origin, toTarget.Unit * 4, rayP)
                if hit and hit.Normal.Y < 0.5 then hum.Jump = true end
                if tick() - lastCheck > 0.5 then
                    if (hrp.Position - lastPos).Magnitude < 1 then hum.Jump = true end
                    lastPos, lastCheck = hrp.Position, tick()
                end
                task.wait(0.1)
            end
            return false
        end

        local function atmPromptPos(prompt)
            local p = prompt.Parent
            if not p then return nil end
            if p:IsA("Attachment") then return p.WorldPosition end
            if p:IsA("BasePart") then return p.Position end
            if p:IsA("Model") then return p:GetPivot().Position end
            return nil
        end
        local function atmFindPrompt(origin, container, radius)
            container = container or workspace
            radius = radius or PROMPT_RADIUS
            local best, bestD
            for _, d in ipairs(container:GetDescendants()) do
                if d:IsA("ProximityPrompt") and d.Enabled then
                    local pos = atmPromptPos(d)
                    if pos then
                        local dd = (pos - origin).Magnitude
                        if dd <= radius and (not bestD or dd < bestD) then
                            best, bestD = d, dd
                        end
                    end
                end
            end
            return best
        end
        local function atmUsePrompt(prompt)
            if typeof(fireproximityprompt) == "function" then
                fireproximityprompt(prompt)
            else
                prompt:InputHoldBegin()
                task.wait(math.max(prompt.HoldDuration, 0) + 0.1)
                prompt:InputHoldEnd()
            end
        end

        local function atmMakeCarpet(topY, cx, cz)
            for _, n in ipairs({ "UM_Carpet", "UM_Elevator" }) do
                local old = workspace:FindFirstChild(n)
                if old then old:Destroy() end
            end
            atmCarpet = Instance.new("Part")
            atmCarpet.Name = "UM_Carpet"
            atmCarpet.Anchored = true
            atmCarpet.CanCollide = true
            atmCarpet.Transparency = 1
            atmCarpet.Size = Vector3.new(CARPET_SIZE, 4, CARPET_SIZE)
            atmCarpet.CFrame = CFrame.new(cx, topY - 2, cz)
            atmCarpet.Parent = workspace
            atmCarpetTop = topY
            atmStdCarpetTop = topY
            atmElevator = Instance.new("Part")
            atmElevator.Name = "UM_Elevator"
            atmElevator.Anchored = true
            atmElevator.CanCollide = true
            atmElevator.Transparency = 1
            atmElevator.Size = Vector3.new(10, 2, 10)
            atmElevator.Parent = workspace
        end
        local function atmSetCarpetTop(y)
            atmCarpetTop = y
            if atmCarpet then
                atmCarpet.CFrame = CFrame.new(atmCarpet.Position.X, y - 2, atmCarpet.Position.Z)
            end
        end
        local function atmSetElevatorTop(x, topY, z)
            atmElevator.CFrame = CFrame.new(x, topY - 1, z)
        end
        local function atmOpenShaft(x, z, half, yLow, yHigh, ignore)
            local params = OverlapParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = ignore
            params.MaxParts = 300
            local size = Vector3.new(half * 2, yHigh - yLow, half * 2)
            local cf = CFrame.new(x, (yLow + yHigh) / 2, z)
            for _, p in ipairs(workspace:GetPartBoundsInBox(cf, size, params)) do
                if p.CanCollide and not atmChanged[p] then
                    atmChanged[p] = true
                    p.CanCollide = false
                end
            end
        end
        local function atmRestoreShaft()
            for p in pairs(atmChanged) do
                if p.Parent then p.CanCollide = true end
            end
            atmChanged = {}
        end
        local function atmGroundAt(x, z, nearY, ignore)
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = ignore
            local r = workspace:Raycast(Vector3.new(x, nearY + 3, z), Vector3.new(0, -14, 0), params)
            if r then return r.Position.Y, r.Instance end
            return nil, nil
        end
        local function atmRunElevator(x, z, fromTop, toTop, speed, half, height, ignore, carry, cancelled)
            local dir = (toTop > fromTop) and 1 or -1
            local y = fromTop
            atmSetElevatorTop(x, y, z)
            while y ~= toTop do
                if cancelled() then return false end
                local dt = RunService.Heartbeat:Wait()
                local newY = y + dir * speed * dt
                if (dir == 1 and newY > toTop) or (dir == -1 and newY < toTop) then newY = toTop end
                local delta = newY - y
                y = newY
                atmSetElevatorTop(x, y, z)
                atmOpenShaft(x, z, half, y - 8, y + height + 4, ignore)
                carry(delta, dir)
            end
            return true
        end
        local function atmVehicleBox(vehicle)
            local bbCF, bbSize = vehicle:GetBoundingBox()
            return bbCF.Position, bbSize, bbCF.Position.Y - bbSize.Y / 2
        end
        local function atmCarryVehicle(root, speed)
            return function(_, dir)
                root.AssemblyLinearVelocity = Vector3.new(0, dir * speed, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end
        local function atmDiveVehicle(seat, vehicle, hum, cancelled, first)
            local root = seat.AssemblyRootPart or seat
            local char = hum.Parent
            local center, size, bottom = atmVehicleBox(vehicle)
            local lift = atmLiftSpeed()
            if first then
                local _, inst = atmGroundAt(center.X, center.Z, bottom + 1, { vehicle, char })
                if inst and inst:IsA("Terrain") then return false, "terrain" end
                _G.__umStartY = bottom
                atmMakeCarpet(bottom - UNDER_DEPTH, center.X, center.Z)
            end
            local side = math.max(size.X, size.Z) + 8
            atmElevator.Size = Vector3.new(side, 2, side)
            local ok = atmRunElevator(center.X, center.Z, bottom - 0.05, atmCarpetTop - 0.05, lift,
                side / 2 + 4, size.Y, { vehicle, char, atmCarpet, atmElevator }, atmCarryVehicle(root, lift), cancelled)
            atmRestoreShaft()
            root.AssemblyLinearVelocity = Vector3.zero
            return ok, nil
        end
        local function atmSurfaceVehicle(seat, vehicle, hum, cancelled, nearY)
            local root = seat.AssemblyRootPart or seat
            local char = hum.Parent
            local center, size = atmVehicleBox(vehicle)
            local ignore = { vehicle, char, atmCarpet, atmElevator }
            local lift = atmLiftSpeed()
            local startY = nearY or _G.__umStartY or (atmCarpetTop + UNDER_DEPTH)
            local gy = atmGroundAt(center.X, center.Z, startY, ignore) or (_G.__umStartY or startY)
            local side = math.max(size.X, size.Z) + 8
            atmElevator.Size = Vector3.new(side, 2, side)
            local ok = atmRunElevator(center.X, center.Z, atmCarpetTop - 0.05, gy, lift,
                side / 2 + 4, size.Y, ignore, atmCarryVehicle(root, lift), cancelled)
            atmRestoreShaft()
            root.AssemblyLinearVelocity = Vector3.zero
            return ok
        end
        local function atmFindSurfaceSpot(atmPos, from, size, ignore)
            local atmXZ = atmFlat(atmPos)
            local back = atmFlat(from) - atmXZ
            if back.Magnitude < 1 then back = Vector3.new(0, 0, 1) end
            back = back.Unit
            local boxSide = math.max(size.X, size.Z) + 2
            local params = OverlapParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = ignore
            params.MaxParts = 20
            for _, r in ipairs(SURFACE_RADII) do
                for _, deg in ipairs({ 0, 30, -30, 60, -60, 90, -90, 120, -120, 150, -150, 180 }) do
                    local dir = CFrame.Angles(0, math.rad(deg), 0) * back
                    local c = atmXZ + dir * r
                    local gy, inst = atmGroundAt(c.X, c.Z, atmPos.Y, ignore)
                    if gy and inst and not inst:IsA("Terrain") and gy <= atmPos.Y + 2 and gy >= atmPos.Y - 8 then
                        local boxCF = CFrame.new(c.X, gy + 1 + size.Y / 2, c.Z)
                        local parts = workspace:GetPartBoundsInBox(boxCF, Vector3.new(boxSide, size.Y, boxSide), params)
                        local solid = false
                        for _, p in ipairs(parts) do
                            if p.CanCollide then solid = true break end
                        end
                        if not solid then return c end
                    end
                end
            end
            return nil
        end

        local function atmDriveUnder(seat, vehicle, hum, target, cancelled)
            local root = seat.AssemblyRootPart or seat
            local char = hum.Parent
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = { vehicle, char }
            rayParams.RespectCanCollide = true
            local _, size = vehicle:GetBoundingBox()
            local halfWidth = math.min(size.X, size.Z) / 2
            local frontOffset = math.max(size.X, size.Z) / 2 + 1
            local baseY = atmCarpetTop
            local corrParams = OverlapParams.new()
            corrParams.FilterType = Enum.RaycastFilterType.Exclude
            corrParams.FilterDescendantsInstances = { vehicle, char, atmCarpet, atmElevator }
            corrParams.MaxParts = 300
            local bandLow = baseY + 0.3
            local bandHigh = baseY + size.Y + 3
            local bandMid = (bandLow + bandHigh) / 2
            local function openCorridor(dir, ahead)
                local mid = atmFlat(root.Position) + dir * (ahead / 2 - 6)
                local center = Vector3.new(mid.X, bandMid, mid.Z)
                local cf = CFrame.lookAt(center, center + dir)
                local boxSize = Vector3.new(math.max(size.X, size.Z) + 12, bandHigh - bandLow, ahead)
                for _, p in ipairs(workspace:GetPartBoundsInBox(cf, boxSize, corrParams)) do
                    if p.CanCollide and not atmChanged[p] then
                        atmChanged[p] = true
                        p.CanCollide = false
                    end
                end
            end
            local function castDist(origin, dir, dist)
                local r = workspace:Raycast(origin, dir * dist, rayParams)
                if r and r.Normal.Y < MIN_BLOCK_SLOPE then return r.Distance end
                return dist
            end
            local function clearance(origin, dir, dist)
                local side = Vector3.new(-dir.Z, 0, dir.X) * halfWidth
                return math.min(castDist(origin, dir, dist), castDist(origin + side, dir, dist), castDist(origin - side, dir, dist))
            end
            local curSpd = atmFlat(root.AssemblyLinearVelocity).Magnitude
            local curAng = 0
            local nearTime, blockedTime = 0, 0
            local checkPos, checkTime = root.Position, tick()
            local bestDist, lastImprove = math.huge, tick()
            local frame = 0
            local t0 = tick()
            while true do
                local dt = RunService.Heartbeat:Wait()
                if cancelled() then return false end
                if hum.SeatPart ~= seat then return false end
                if tick() - t0 > UNDER_TIMEOUT then return false end
                local pos = atmFlat(root.Position)
                local toT = atmFlat(target) - pos
                local dist = toT.Magnitude
                if dist < 40 then nearTime = nearTime + dt else nearTime = 0 end
                if dist < UNDER_ARRIVE + math.min(nearTime * 2, 12) then break end
                if dist < bestDist - 5 then
                    bestDist = dist
                    lastImprove = tick()
                elseif tick() - lastImprove > 25 then
                    return false
                end
                local want = toT.Unit
                local heading = atmFlat(seat.CFrame.LookVector)
                if REVERSE_FRONT then heading = -heading end
                heading = heading.Unit
                frame = frame + 1
                if frame % 2 == 0 then
                    local ahead = math.clamp(curSpd * 1.2 + 30, 35, 100)
                    openCorridor(heading, ahead)
                    if heading:Dot(want) < 0.95 then openCorridor(want, ahead) end
                end
                local origin = Vector3.new(root.Position.X, baseY + RAY_HEIGHT, root.Position.Z) + heading * frontOffset
                local senseDist = math.clamp(curSpd * 1.6 + SENSE_MIN, SENSE_MIN, SENSE_MAX)
                local hit = clearance(origin, heading, senseDist)
                local obstacleFactor = 1
                if hit < senseDist then
                    obstacleFactor = math.clamp((hit - STOP_DIST) / (senseDist - STOP_DIST), 0, 1)
                end
                if obstacleFactor <= 0 then
                    blockedTime = blockedTime + dt
                    if blockedTime > BLOCKED_TIMEOUT then return false, "blocked" end
                else
                    blockedTime = 0
                end
                local angle = math.atan2(heading:Cross(want).Y, heading:Dot(want))
                local align = math.clamp(1 - math.abs(angle) / math.rad(45), 0, 1)
                local spd = atmDriveSpeed() * align * obstacleFactor
                spd = math.min(spd, math.max(8, math.sqrt(2 * BRAKE_ACCEL * 0.6 * math.max(0, dist - UNDER_ARRIVE))))
                if align <= 0 then spd = 0 end
                local rate = (spd < curSpd) and BRAKE_ACCEL or ACCEL
                curSpd = atmApproach(curSpd, spd, rate * dt)
                curAng = atmApproach(curAng, math.clamp(angle * TURN_GAIN, -MAX_TURN, MAX_TURN), TURN_ACCEL * dt)
                local vel = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = Vector3.new(heading.X * curSpd, vel.Y, heading.Z * curSpd)
                root.AssemblyAngularVelocity = Vector3.new(0, curAng, 0)
                if tick() - checkTime > 4 then
                    if obstacleFactor > 0 and align > 0.3 and (root.Position - checkPos).Magnitude < 2 then
                        return false, "stuck"
                    end
                    checkPos = root.Position
                    checkTime = tick()
                end
            end
            for _ = 1, 180 do
                local dt = RunService.Heartbeat:Wait()
                local vel = root.AssemblyLinearVelocity
                local h = atmFlat(vel)
                local mag = atmApproach(h.Magnitude, 0, BRAKE_ACCEL * dt)
                local dir = h.Magnitude > 0.01 and h.Unit or Vector3.zero
                root.AssemblyLinearVelocity = Vector3.new(dir.X * mag, vel.Y, dir.Z * mag)
                root.AssemblyAngularVelocity = Vector3.zero
                if mag < 0.5 then break end
            end
            return true
        end

        local function atmFindTunnelRoute(atmPos)
            for _, r in ipairs(TUNNEL_ROUTES) do
                if (r.atm - atmPos).Magnitude < 5 then return r end
            end
            return nil
        end
        local function atmDriveTunnel(seat, vehicle, hum, points, stopPos, cancelled)
            local root = seat.AssemblyRootPart or seat
            local char = hum.Parent
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = { vehicle, char }
            rayParams.RespectCanCollide = true
            local _, size = vehicle:GetBoundingBox()
            local halfWidth = math.min(size.X, size.Z) / 2
            local frontOffset = math.max(size.X, size.Z) / 2 + 1
            local function castDist(origin, dir, dist)
                local r = workspace:Raycast(origin, dir * dist, rayParams)
                if r and r.Normal.Y < MIN_BLOCK_SLOPE then return r.Distance end
                return dist
            end
            local function clearance(origin, dir, dist)
                local side = Vector3.new(-dir.Z, 0, dir.X) * halfWidth
                return math.min(castDist(origin, dir, dist), castDist(origin + side, dir, dist), castDist(origin - side, dir, dist))
            end
            local idx = 1
            local prev = atmFlat(root.Position)
            local prevFloor = atmCarpetTop
            local curSpd = atmFlat(root.AssemblyLinearVelocity).Magnitude
            local curAng = 0
            local blockedTime = 0
            local checkPos, checkTime = root.Position, tick()
            local t0 = tick()
            while true do
                local dt = RunService.Heartbeat:Wait()
                if cancelled() then return false end
                if hum.SeatPart ~= seat then return false end
                if tick() - t0 > UNDER_TIMEOUT then return false, "timeout" end
                local wp = points[idx]
                local wpFlat = atmFlat(wp)
                local isLast = (idx == #points)
                local pos = atmFlat(root.Position)
                local toWp = wpFlat - pos
                local dist = toWp.Magnitude
                local legVec = wpFlat - prev
                local passed = legVec.Magnitude > 1 and dist < 20 and toWp:Dot(legVec) <= 0
                if dist < TUNNEL_CAPTURE or passed then
                    if isLast then break end
                    prev = wpFlat
                    prevFloor = wp.Y - TUNNEL_FLOOR_OFFSET
                    idx = idx + 1
                    continue
                end
                local t = 1
                if legVec.Magnitude > 1 then
                    t = math.clamp((pos - prev):Dot(legVec) / (legVec.Magnitude ^ 2), 0, 1)
                end
                local targetTop = prevFloor + ((wp.Y - TUNNEL_FLOOR_OFFSET) - prevFloor) * t
                atmSetCarpetTop(atmApproach(atmCarpetTop, targetTop, TUNNEL_SLAB_RATE * dt))
                local want = toWp.Unit
                local heading = atmFlat(seat.CFrame.LookVector)
                if REVERSE_FRONT then heading = -heading end
                heading = heading.Unit
                local origin = Vector3.new(root.Position.X, atmCarpetTop + RAY_HEIGHT, root.Position.Z) + heading * frontOffset
                local senseDist = math.clamp(curSpd * 1.2 + 10, 10, 35)
                local hit = clearance(origin, heading, senseDist)
                local obstacleFactor = 1
                if hit < senseDist then
                    obstacleFactor = math.clamp((hit - 4) / (senseDist - 4), 0, 1)
                end
                if obstacleFactor <= 0 then
                    blockedTime = blockedTime + dt
                    if blockedTime > BLOCKED_TIMEOUT then return false, "blocked" end
                else
                    blockedTime = 0
                end
                local angle = math.atan2(heading:Cross(want).Y, heading:Dot(want))
                local align = math.clamp(1 - math.abs(angle) / math.rad(45), 0, 1)
                local spd = TUNNEL_SPEED * align * obstacleFactor
                if not isLast and dist < 30 then
                    local nextDir = atmFlat(points[idx + 1]) - wpFlat
                    if nextDir.Magnitude > 0 and want:Dot(nextDir.Unit) < 0.7 then
                        spd = math.min(spd, TUNNEL_SPEED * 0.5)
                    end
                end
                if isLast then
                    spd = math.min(spd, math.max(6, math.sqrt(2 * BRAKE_ACCEL * 0.6 * dist)))
                end
                local rate = (spd < curSpd) and BRAKE_ACCEL or ACCEL
                curSpd = atmApproach(curSpd, spd, rate * dt)
                curAng = atmApproach(curAng, math.clamp(angle * TURN_GAIN, -MAX_TURN, MAX_TURN), TURN_ACCEL * dt)
                local vel = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = Vector3.new(heading.X * curSpd, vel.Y, heading.Z * curSpd)
                root.AssemblyAngularVelocity = Vector3.new(0, curAng, 0)
                if tick() - checkTime > 4 then
                    if obstacleFactor > 0 and align > 0.3 and (root.Position - checkPos).Magnitude < 2 then
                        return false, "stuck"
                    end
                    checkPos = root.Position
                    checkTime = tick()
                end
            end
            while true do
                local dt = RunService.Heartbeat:Wait()
                if cancelled() then return false end
                local pos = atmFlat(root.Position)
                local stopFlat = atmFlat(stopPos)
                local dist = (stopFlat - pos).Magnitude
                if dist <= 1.5 then break end
                local want = (stopFlat - pos).Unit
                local heading = atmFlat(seat.CFrame.LookVector)
                if REVERSE_FRONT then heading = -heading end
                heading = heading.Unit
                local angle = math.atan2(heading:Cross(want).Y, heading:Dot(want))
                local spd = math.min(15, math.sqrt(2 * BRAKE_ACCEL * dist))
                curSpd = atmApproach(curSpd, spd, BRAKE_ACCEL * dt)
                curAng = atmApproach(curAng, math.clamp(angle * TURN_GAIN, -MAX_TURN, MAX_TURN), TURN_ACCEL * dt)
                local vel = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = Vector3.new(heading.X * curSpd, vel.Y, heading.Z * curSpd)
                root.AssemblyAngularVelocity = Vector3.new(0, curAng, 0)
            end
            for _ = 1, 180 do
                local dt = RunService.Heartbeat:Wait()
                local vel = root.AssemblyLinearVelocity
                local h = atmFlat(vel)
                local mag = atmApproach(h.Magnitude, 0, BRAKE_ACCEL * 2 * dt)
                local dir = h.Magnitude > 0.01 and h.Unit or Vector3.zero
                root.AssemblyLinearVelocity = Vector3.new(dir.X * mag, vel.Y, dir.Z * mag)
                root.AssemblyAngularVelocity = Vector3.zero
                if mag < 0.1 then break end
            end
            return true
        end

        local function atmCarryPlayer(hrp)
            return function(delta)
                hrp.CFrame = hrp.CFrame + Vector3.new(0, delta, 0)
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end
        local function atmBoard(name, hum, seat, vehicle, cancelled)
            atmStatus(name .. ": al vehiculo...")
            atmWalkNear(hum, seat.Position, 6, cancelled)
            if cancelled() then return false end
            local hrp = hum.Parent and hum.Parent:FindFirstChild("HumanoidRootPart")
            local prompt = hrp and (atmFindPrompt(hrp.Position, vehicle, 60) or atmFindPrompt(seat.Position))
            if not prompt then atmStatus("Sin prompt vehiculo") return false end
            for attempt = 1, SIT_ATTEMPTS do
                if cancelled() then return false end
                pcall(atmUsePrompt, prompt)
                local t0 = tick()
                while not hum.SeatPart and tick() - t0 < 2 do task.wait(0.1) end
                if hum.SeatPart then task.wait(0.5) return true end
            end
            return false
        end
        local function atmVisitSurface(atm, seat, vehicle, hum, cancelled)
            atmStatus(atm.name .. ": bajando...")
            if not atmEject(hum, seat) then return false, false end
            atmStatus(atm.name .. ": al ATM...")
            atmWalkNear(hum, atm.pos, HACK_WALK_DIST, cancelled)
            if cancelled() then return false, false end
            local hacked = atmHack(atm.name, atm.pos, cancelled)
            if cancelled() then return hacked, false end
            local boarded = atmBoard(atm.name, hum, seat, vehicle, cancelled)
            return hacked, boarded
        end
        local function atmDestroyUnder()
            atmRestoreShaft()
            if atmCarpet then atmCarpet:Destroy() end
            if atmElevator then atmElevator:Destroy() end
            atmCarpet, atmElevator, atmCarpetTop = nil, nil, nil
        end
        local function atmSettleCarpet(target, cancelled)
            while atmCarpetTop and math.abs(atmCarpetTop - target) > 0.01 do
                if cancelled() then return false end
                local dt = RunService.Heartbeat:Wait()
                atmSetCarpetTop(atmApproach(atmCarpetTop, target, TUNNEL_SLAB_RATE * dt))
            end
            return true
        end

        local function atmRunUnder(myRun)
            local function cancelled()
                return myRun ~= atmRunId or not Config.AtmFarm
            end
            local seat, vehicle, hum = atmGetSeatAndVehicle()
            if not seat then
                atmStatus("Subite a un vehiculo primero")
                Config.AtmFarm = false
                return
            end
            atmSolverOn = true
            atmStatus("Bajando bajo el mapa...")
            local ok, why = atmDiveVehicle(seat, vehicle, hum, cancelled, true)
            if not ok then
                atmRestoreShaft()
                atmStatus(why == "terrain" and "Piso Terrain" or "No pude bajar")
                return
            end
            local atSurface = false
            local remaining = {}
            for i, p in ipairs(ATM_LOCATIONS) do
                table.insert(remaining, { name = "ATM " .. i, pos = p })
            end
            local done, failed = 0, 0
            while #remaining > 0 do
                if cancelled() then break end
                local curSeat, curVeh, curHum = atmGetSeatAndVehicle()
                if not curSeat then atmStatus("Te bajaste") break end
                local root = curSeat.AssemblyRootPart or curSeat
                local from = atmFlat(root.Position)
                local bi, bd = 1, math.huge
                for i, a in ipairs(remaining) do
                    local d = (atmFlat(a.pos) - from).Magnitude
                    if d < bd then bi, bd = i, d end
                end
                local atm = table.remove(remaining, bi)
                local tunnel = atmFindTunnelRoute(atm.pos)
                local spot
                if tunnel then
                    spot = atmFlat(tunnel.points[1])
                else
                    local _, vsize = atmVehicleBox(curVeh)
                    local ignore = { curVeh, curHum.Parent, atmCarpet, atmElevator }
                    spot = atmFindSurfaceSpot(atm.pos, from, vsize, ignore)
                    if not spot then
                        local atmXZ = atmFlat(atm.pos)
                        local back = from - atmXZ
                        back = back.Magnitude > 1 and back.Unit or Vector3.new(0, 0, 1)
                        spot = atmXZ + back * FALLBACK_PARK
                    end
                end
                atmStatus(atm.name .. ": bajo el mapa...")
                if (spot - from).Magnitude > UNDER_ARRIVE then
                    local drove, why2 = atmDriveUnder(curSeat, curVeh, curHum, spot, cancelled)
                    if not drove then
                        if not cancelled() then atmStatus(atm.name .. ": fallo ruta") end
                        break
                    end
                end
                if cancelled() then break end
                if tunnel then
                    atmRestoreShaft()
                    atmStatus(atm.name .. ": tuneles...")
                    local seq = {}
                    for _, pt in ipairs(tunnel.points) do table.insert(seq, pt) end
                    local okT = atmDriveTunnel(curSeat, curVeh, curHum, seq, tunnel.stop, cancelled)
                    if not okT then
                        if not cancelled() then atmStatus(atm.name .. ": fallo tunel") end
                        break
                    end
                    if cancelled() then break end
                end
                atmStatus(atm.name .. ": subiendo...")
                if not atmSurfaceVehicle(curSeat, curVeh, curHum, cancelled, atm.pos.Y) then break end
                atSurface = true
                local hacked, boarded = atmVisitSurface(atm, curSeat, curVeh, curHum, cancelled)
                if hacked then done = done + 1 else failed = failed + 1 end
                if cancelled() then break end
                if not boarded then atmStatus("No subi de nuevo") break end
                if #remaining > 0 then
                    local s3, v3, h3 = atmGetSeatAndVehicle()
                    if not s3 then break end
                    atmStatus("Bajando de nuevo...")
                    if not atmDiveVehicle(s3, v3, h3, cancelled, false) then break end
                    atSurface = false
                    if tunnel then
                        local back = {}
                        for i = #tunnel.points, 1, -1 do table.insert(back, tunnel.points[i]) end
                        atmDriveTunnel(s3, v3, h3, back, tunnel.points[1], cancelled)
                        atmSettleCarpet(atmStdCarpetTop, cancelled)
                    end
                end
            end
            if atSurface then atmDestroyUnder() end
            if myRun == atmRunId then
                atmSolverOn = false
                atmStatus(("Listo %d ok / %d fail"):format(done, failed))
                Config.AtmFarm = false
            end
        end

        local function atmSurfaceNow(myRun)
            local function cancelled()
                return myRun ~= atmRunId
            end
            if not atmCarpet or not atmCarpetTop then
                atmStatus("Nada bajo el mapa")
                return
            end
            local seat, vehicle, hum = atmGetSeatAndVehicle()
            if seat then
                atmStatus("Subiendo vehiculo...")
                if atmSurfaceVehicle(seat, vehicle, hum, cancelled) then
                    atmDestroyUnder()
                    atmStatus("Arriba")
                end
                return
            end
            local char = LocalPlayer.Character
            local h = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not h or not hrp then return end
            if hrp.Position.Y > atmCarpetTop + 15 then
                atmStatus("Ya estas arriba")
                return
            end
            local lift = atmLiftSpeed()
            local startY = _G.__umStartY or (atmCarpetTop + UNDER_DEPTH)
            local ignore = { char, atmCarpet, atmElevator }
            local gy = atmGroundAt(hrp.Position.X, hrp.Position.Z, startY, ignore) or startY
            atmElevator.Size = Vector3.new(PLAYER_SHAFT, 2, PLAYER_SHAFT)
            h:MoveTo(hrp.Position)
            atmRunElevator(hrp.Position.X, hrp.Position.Z, atmCarpetTop - 0.05, gy, lift,
                PLAYER_SHAFT / 2 + 4, 8, ignore, atmCarryPlayer(hrp), cancelled)
            atmRestoreShaft()
            atmStatus("Arriba")
        end

        local function atmStartAction(fn)
            atmRunId = atmRunId + 1
            local myRun = atmRunId
            task.spawn(function()
                while atmBusy do task.wait(0.05) end
                if myRun ~= atmRunId then return end
                atmBusy = true
                local ok, err = pcall(fn, myRun)
                atmBusy = false
                if myRun == atmRunId then atmSolverOn = false end
                if not ok then
                    atmStatus("Error")
                    warn("ATM farm error:", err)
                end
            end)
        end

        Window:CreateButton(atmSec, {
            Title = "AutoFarm ATM",
            Description = "Subite a un vehiculo y activa. Baja bajo el mapa y te lleva a los ATM",
            Icon = "rbxassetid://71722118135407",
            Default = Config.AtmFarm,
            Callback = function(v)
                Config.AtmFarm = v
                if v then
                    atmStartAction(atmRunUnder)
                else
                    atmRunId = atmRunId + 1
                    atmSolverOn = false
                    atmStatus("Detenido (usa Subir si quedaste abajo)")
                end
            end
        })

        Window:CreateButton(atmSec, {
            Title = "Subir ( Emergencia )",
            Description = "Volves arriba, al suelo normal, por si el anticheat pedorro detecta",
            Icon = "rbxassetid://125262604141425",
            IsToggle = false,
            Callback = function()
                atmStartAction(atmSurfaceNow)
            end
        })

        Window:CreateSlider(atmSec, {
            Title = "Velocidad de recorrido",
            Description = "Velocidad del vehiculo (20-100)",
            Min = 20,
            Max = 100,
            Default = Config.AtmDriveSpeed,
            Step = 1,
            Callback = function(v)
                Config.AtmDriveSpeed = v
            end
        })

        Window:CreateSlider(atmSec, {
            Title = "Velocidad de subida",
            Description = "Velocidad de bajar/subir (10-100)",
            Min = 10,
            Max = 100,
            Default = Config.AtmLiftSpeed,
            Step = 1,
            Callback = function(v)
                Config.AtmLiftSpeed = v
            end
        })

        local statusHolder = Instance.new("Frame")
        statusHolder.Size = UDim2.new(1, 0, 0, 28)
        statusHolder.BackgroundTransparency = 1
        statusHolder.Parent = atmSec
        local statusLbl = Instance.new("TextLabel")
        statusLbl.Size = UDim2.fromScale(1, 1)
        statusLbl.BackgroundTransparency = 1
        statusLbl.Text = "ATM: listo"
        statusLbl.TextColor3 = Color3.fromRGB(150, 150, 165)
        statusLbl.TextSize = 11
        statusLbl.Font = Enum.Font.Gotham
        statusLbl.TextXAlignment = Enum.TextXAlignment.Left
        statusLbl.Parent = statusHolder
        _G.SB_AtmStatus = statusLbl

    end
    print("SexyBoy Hub completo cargado exitosamente, disfruta mi bro")

end
