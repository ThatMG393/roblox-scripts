local MGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/UI/MGUI.luau"))()
local AnimationController = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/AnimationController.luau"))()
local Players = game:GetService("Players")

local function Main()
	local WinOpt = MGUI.DefaultWindowOptions
	WinOpt.WindowTitle = "Simple Sex GUI"
	WinOpt.WindowSize = { X = 317, Y = 271 }
	WinOpt.ResetOnSpawn = false

	local MainWin = MGUI.CreateWindow(WinOpt)
	
	local MainSec = MainWin:CreateSection("Sex")
	local Status = MainSec:CreateLabel("you freaky 😈❓️")
	local TargetPlayer = MainSec:CreateInputField("Target Player", Players.LocalPlayer:GetFullName().split(".")[2], nil)
	local BangSpeed = MainSec:CreateInputField("Bang Speed", 2, 2)

	local function redir(a) Status:UpdateLabel(a) end

	local WeStoppingNow = false
	local A = nil
	MainSec:CreateButton("Commence 😈", function()
		if WeStoppingNow then
			A:Stop()
			A = nil
		else
			A = AnimationController.new({
				Speed = BangSpeed:GetText(),
				R6AnimId = "rbxassetid://148840371",
				R15AnimId = "rbxassetid://5918726674",
				OnError = redir,
				OnStatusChange = redir
			})
			A:Start()
			A:FollowTarget(TargetPlayer:GetText(), CFrame.new(0, 0, 1))
		end
		WeStoppingNow = not WeStoppingNow
	end)
end

Main()
