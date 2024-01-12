local MakeDraggable = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/MakeDraggable.luau"))()
local Players = game:GetService("Players")

local SimpleSexGUI = Instance.new("ScreenGui") 
local FGUI = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TargetTextLabel = Instance.new("TextLabel")
local TargetVictimInput = Instance.new("TextBox")
local StartAnim = Instance.new("TextButton")
local BottomTextLabel = Instance.new("TextLabel")

SimpleSexGUI.Name = "SimpleSexGUI"
SimpleSexGUI.Parent = game:GetService("CoreGui")

FGUI.Name = "FGUI"
FGUI.Parent = SimpleSexGUI
FGUI.BackgroundColor3 = Color3.new(255,255,255)
FGUI.BorderSizePixel = 1
FGUI.Position = UDim2.new(0.2, 0, 0.3, 0)
FGUI.Size = UDim2.new(0,317, 0,271)
MakeDraggable.MakeDraggable(FGUI)

Title.Parent = FGUI
Title.BackgroundColor3 = Color3.new(255,255,255)
Title.BorderSizePixel = 1
Title.Position = UDim2.new (0, 0,-0.122, 0)
Title.Size = UDim2.new (0, 317,0, 33)
Title.Visible = true
Title.Active = true
Title.Draggable = false
Title.Selectable = false
Title.Font = Enum.Font.SourceSansBold
Title.Text = "FE Bang 😈"
Title.TextColor3 = Color3.new(0, 0, 0)
Title.TextSize = 20

TargetTextLabel.Parent = FGUI
TargetTextLabel.BackgroundColor3 = Color3.new(255, 255, 255)
TargetTextLabel.BorderSizePixel = 1
TargetTextLabel.Position = UDim2.new (0.10, 0, 0.18, 0)
TargetTextLabel.Size = UDim2.new (0, 99, 0, 31)
TargetTextLabel.Visible = true
TargetTextLabel.Active = true
TargetTextLabel.Draggable = false
TargetTextLabel.Selectable = true
TargetTextLabel.Font = Enum.Font.SourceSansBold
TargetTextLabel.Text = "Input Target:"
TargetTextLabel.TextColor3 = Color3.new(0, 0, 0)
TargetTextLabel.TextSize = 15

TargetVictimInput.Parent = FGUI
TargetVictimInput.BackgroundColor3 = Color3.new(255, 255, 255)
TargetVictimInput.BorderSizePixel = 1
TargetVictimInput.Position = UDim2.new (0.45, 0, 0.18, 0)
TargetVictimInput.Size = UDim2.new (0, 133, 0, 27)
TargetVictimInput.Visible = true
TargetVictimInput.Active = true
TargetVictimInput.Draggable = false
TargetVictimInput.Selectable = true
TargetVictimInput.Font = Enum.Font.SourceSansBold
TargetVictimInput.Text = "[NAME]"
TargetVictimInput.TextColor3 = Color3.new(0, 0, 0)
TargetVictimInput.TextSize = 20

StartAnim.Parent = FGUI
StartAnim.BackgroundColor3 = Color3.new(255, 255, 255)
StartAnim.BorderSizePixel = 1
StartAnim.Position = UDim2.new (0.45, 0, 0.30, 0)
StartAnim.Size = UDim2.new (0, 99,0, 31)
StartAnim.Visible = true
StartAnim.Active = true
StartAnim.Draggable = false
StartAnim.Selectable = true
StartAnim.Font = Enum.Font.SourceSansBold
StartAnim.Text = "Let's FUCK!!"
StartAnim.TextColor3 = Color3.new(0, 0, 0)
StartAnim.TextSize = 20

BottomTextLabel.Name = "FUCKEMALL"
BottomTextLabel.Parent = FGUI
BottomTextLabel.BackgroundColor3 = Color3.new(255,255,255)
BottomTextLabel.BorderSizePixel = 1
BottomTextLabel.Position = UDim2.new (0.025, 0,0.856, 0)
BottomTextLabel.Size = UDim2.new (0, 301,0, 27)
BottomTextLabel.Visible = true
BottomTextLabel.Font = Enum.Font.SourceSansBold
BottomTextLabel.Text = "FUCK AND FUCK"
BottomTextLabel.TextColor3 = Color3.new(0, 0, 0)
BottomTextLabel.TextSize = 20
 
StartAnim.MouseButton1Click:Connect(function() 
	local TargetPlayer: Player = Players:FindFirstChild(TargetVictimInput.Text)
	local TargetPlayerHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
	local CurrentPlayer = Players.LocalPlayer
	local CurrentHumanoid = CurrentPlayer.Character:WaitForChild("Humanoid")
	local CurrentHRP = CurrentPlayer.Character:FindFirstChild("HumanoidRootPart")

	local BangAnimSrc = Instance.new('Animation')
	BangAnimSrc.AnimationId = 'rbxassetid://148840371'
	
	local BangAnimLoader = CurrentHumanoid:LoadAnimation(BangAnimSrc)
	BangAnimLoader:Play()
	BangAnimLoader:AdjustSpeed(20)

	pcall(function()
		CurrentHumanoid.Parent.Pants:Destroy()
	end)
	pcall(function()
		CurrentHumanoid.Parent.Shirt:Destroy()
	end)

	while CurrentHumanoid.Parent.Parent ~= nil do
		wait()
		local pos = TargetPlayerHRP.Position + TargetPlayerHRP.CFrame.LookVector * -1
		CurrentHRP.CFrame = CFrame.new(pos, TargetPlayerHRP.Position)
	end
end)
