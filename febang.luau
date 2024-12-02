local MGUI = require("UI/MGUI") -- loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/UI/MGUI.luau"))()
local Players = game:GetService("Players")

local function Main()
	local WinOpt = MGUI.DefaultOption
	WinOpt.WindowTitle = "Simple Sex GUI"
	WinOpt.WindowSize = { X = 317, Y = 271 }
	WinOpt.ResetOnSpawn = false

	local MainWin = MGUI.CreateWindow(WinOpt)
	
	local MainSec = MainWin:CreateSection("Sex")
	local TargetPlayer = MainSec:CreateInputField("Target Player", Players.LocalPlayer:GetFullName(), nil)
	local Commence = MainSec:CreateButton("Commence 😈", function()
		local TargetPlayer: Player = Players:FindFirstChild(TargetPlayer:GetText())
		if TargetPlayer == nil then return end

		local TargetPlayerHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
		local CurrentPlayer = Players.LocalPlayer
		local CurrentHumanoid = CurrentPlayer.Character:WaitForChild("Humanoid")
		local CurrentHRP = CurrentPlayer.Character:FindFirstChild("HumanoidRootPart")

		local BangAnimSrc = Instance.new('Animation')
		BangAnimSrc.AnimationId = 'rbxassetid://148840371'
		
		local BangAnimLoader = CurrentHumanoid:LoadAnimation(BangAnimSrc)
		BangAnimLoader:Play()
		BangAnimLoader:AdjustSpeed(2)

		pcall(function()
			CurrentHumanoid.Parent.Pants:Destroy()	
			CurrentHumanoid.Parent.Shirt:Destroy()
		end)

		while CurrentHumanoid.Parent.Parent ~= nil do
			wait()
			local pos = TargetPlayerHRP.Position + TargetPlayerHRP.CFrame.LookVector * -1
			CurrentHRP.CFrame = CFrame.new(pos, TargetPlayerHRP.Position)
		end
	end)
end

Main()
