local MakeDraggable = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/MakeDraggable.luau"))()
local Players = game:GetService("Players")

local SimpleSexGUI = Instance.new("ScreenGui") 
local FGUI = Instance.new("Frame")
local btnSex = Instance.new("TextButton")
local tbxVictim = Instance.new("TextBox")
local lblFUCKEMALL = Instance.new("TextLabel")
local ImageLabel = Instance.new("ImageLabel")
local lbltitle = Instance.new("TextLabel")

SimpleSexGUI.Name = "SimpleSexGUI"
SimpleSexGUI.Parent = game.CoreGui

FGUI.Name = "FGUI"
FGUI.Parent = SimpleSexGUI
FGUI.BackgroundColor3 = Color3.new(255,255,255)
FGUI.BorderSizePixel = 1
FGUI.Position = UDim2.new(0.2, 0, 0.5, 0)
FGUI.Size = UDim2.new(0,317, 0,271)
MakeDraggable.MakeDraggable(FGUI)

lbltitle.Name = "Title"
lbltitle.Parent = FGUI
lbltitle.BackgroundColor3 = Color3.new(255,255,255)
lbltitle.BorderSizePixel = 1
lbltitle.Position = UDim2.new (0, 0,-0.122, 0)
lbltitle.Size = UDim2.new (0, 317,0, 33)
lbltitle.Visible = true
lbltitle.Active = true
lbltitle.Draggable = false
lbltitle.Selectable = false
lbltitle.Font = Enum.Font.SourceSansBold
lbltitle.Text = "A Simple Fuck(ing) GUI!!"
lbltitle.TextColor3 = Color3.new(0, 0, 0)
lbltitle.TextSize = 20

btnSex.Name = "Sex"
btnSex.Parent = FGUI
btnSex.BackgroundColor3 = Color3.new(255,255,255)
btnSex.BorderSizePixel = 1
btnSex.Position = UDim2.new (0.044, 0,0.229, 0)
btnSex.Size = UDim2.new (0, 99,0, 31)
btnSex.Visible = true
btnSex.Active = true
btnSex.Draggable = false
btnSex.Selectable = true
btnSex.Font = Enum.Font.SourceSansBold
btnSex.Text = "Let's FUCK!!"
btnSex.TextColor3 = Color3.new(0, 0, 0)
btnSex.TextSize = 20

tbxVictim.Name = "VictimTEXT"
tbxVictim.Parent = FGUI
tbxVictim.BackgroundColor3 = Color3.new(255,255,255)
tbxVictim.BorderSizePixel = 1
tbxVictim.Position = UDim2.new (0.533, 0,0.229, 0)
tbxVictim.Size = UDim2.new (0, 133,0, 27)
tbxVictim.Visible = true
tbxVictim.Active = true
tbxVictim.Draggable = false
tbxVictim.Selectable = true
tbxVictim.Font = Enum.Font.SourceSansBold
tbxVictim.Text = "[NAME]"
tbxVictim.TextColor3 = Color3.new(0, 0, 0)
tbxVictim.TextSize = 20
 
lblFUCKEMALL.Name = "FUCKEMALL"
lblFUCKEMALL.Parent = FGUI
lblFUCKEMALL.BackgroundColor3 = Color3.new(255,255,255)
lblFUCKEMALL.BorderSizePixel = 1
lblFUCKEMALL.Position = UDim2.new (0.025, 0,0.856, 0)
lblFUCKEMALL.Size = UDim2.new (0, 301,0, 27)
lblFUCKEMALL.Visible = true
lblFUCKEMALL.Font = Enum.Font.SourceSansBold
lblFUCKEMALL.Text = "FUCK AND FUCK"
lblFUCKEMALL.TextColor3 = Color3.new(0, 0, 0)
lblFUCKEMALL.TextSize = 20
 
ImageLabel.Name = "ImageLabel"
ImageLabel.Parent = FGUI
ImageLabel.Image = "http://www.roblox.com/asset/?id=4283774086"
ImageLabel.BorderSizePixel = 1
ImageLabel.Position = UDim2.new (0.274, 0,0.358, 0)
ImageLabel.Size = UDim2.new (0, 106,0, 121)

btnSex.MouseButton1Click:Connect(function() 
	local TargetPlayer: Player = Players:FindFirstChild(tbxVictim.Text)
	local CurrentHumanoid = Players.LocalPlayer.Character:WaitForChild("Humanoid")

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

	local BodyPosition = Instance.new("BodyPosition")
	local BodyGyro = Instance.new("BodyGyro")

	-- Apply BodyPosition and BodyGyro to the local player's character
	BodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	BodyPosition.Parent = CurrentHumanoid:WaitForChild("HumanoidRootPart")

	BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	BodyGyro.CFrame = CFrame.new()
	BodyGyro.Parent = CurrentHumanoid:WaitForChild("HumanoidRootPart")

	local TargetPlayerHumanoid = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
	while CurrentHumanoid.Parent.Parent ~= nil do
		wait()

		if TargetPlayerHumanoid then
			local offset = Vector3.new(0, 0, -2)
			local desiredPosition = TargetPlayerHumanoid.CFrame:PointToWorldSpace(offset)

			BodyPosition.Position = desiredPosition
			BodyGyro.CFrame = CFrame.new(BodyPosition.Position, TargetPlayerHumanoid.Position)    
		end
	end
end)
