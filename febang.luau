local MGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/UI/MGUI.luau"))()
local AnimationController = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/AnimationController.luau"))()
local PlayerGetter = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/PlayerGetter.luau"))()


local Players = game:GetService("Players")

local function Main()
	PlayerGetter.Init()

	local WinOpt = MGUI.DefaultWindowOptions
	WinOpt.WindowTitle = "Simple Sex GUI"
	WinOpt.WindowSize = { X = 317, Y = 280 }
	WinOpt.ResetOnSpawn = false

	local MainWin = MGUI.CreateWindow(WinOpt)

	local MainSec = MainWin:CreateSection("Sex")
	local Status = MainSec:CreateLabel("you freaky 😈❓️")
	local TargetPlayer = MainSec:CreateInputField("Target Player", Players.LocalPlayer:GetFullName().split(".")[2], nil)
	local BangSpeed = MainSec:CreateInputField("Bang Speed", 10, 10)

	local function redir(a)
		Status:UpdateLabel(a)
	end

	local WeStoppingNow = false
	local A = nil
	MainSec:CreateButton("Commence 😈", function()
		if WeStoppingNow or A ~= nil then
			A:Stop()
			A = nil
			Status:UpdateLabel("stopped banging 😈")
			workspace.FallenPartsDestroyHeight = -500
		else
			A = AnimationController.new {
				Speed = BangSpeed:GetText(),
				R6AnimId = "rbxassetid://148840371",
				R15AnimId = "rbxassetid://5918726674",
				OnError = redir,
				OnStatusChange = redir,
			}
			if A ~= nil then
				A:Start()
				
				local PlayerName = Players:FindFirstChild(TargetPlayer:GetText())
				if not PlayerName then
					PlayerName = Players:FindFirstChild(PlayerGetter:GetPlayerFromDisplayName(TargetPlayer:GetText()))
				end

				A:FollowTarget(PlayerName.Name, CFrame.new(0, 0, 1.1))
				Status:UpdateLabel("we fucking now 😈😈😈")
			end
			workspace.FallenPartsDestroyHeight = -1000
		end
		WeStoppingNow = not WeStoppingNow
	end)
end

Main()
