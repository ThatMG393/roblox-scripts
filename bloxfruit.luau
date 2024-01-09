local GHRepo = "https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master"

local KavoUI = require('Utils/kavo-ui') or loadstring(GHRepo .. "/Utils/kavo-ui.lua")
local ThreadLib = require('Utils/ThreadLib') or loadstring(GHRepo .. "/Utils/ThreadLib.luau")
local UtilLib = require('Utils/NecesarryUtils') or loadstring(GHRepo .. "/Utils/NecesarryUtils.luau")

local Players = game:GetService('Players')

local Main = KavoUI.CreateLib(
	"Blox Fruits | ThatMG393",
	"Sentinel"
)

--------------------INFORMATION---------------------

local InformationTab = Main:NewTab("Information")

local InfoSection = InformationTab:NewSection("Info")
local PlayersLabel = InfoSection:NewLabel("Players: 2")
local PingLabel = InfoSection:NewLabel("Ping: 69ms")

local AboutSection = InformationTab:NewSection("About")
AboutSection:NewLabel("Made by ThatMG393")

ThreadLib.New(function (thread)
	while thread.active do
		PlayersLabel:UpdateLabel(#Players:GetPlayers())

		PingLabel:UpdateLabel(Players.LocalPlayer:GetNetworkPing() * 1000)

		wait(1500)
	end
end).Start()

--------------------AUTOFARM---------------------

local FarmTab = Main:NewTab("AutoFarm")
local GeneralSection = FarmTab:NewSection("General")

local AutoFarmToggle = GeneralSection:NewToggle("Auto Farm Level", "Auto farms level", function(state)  end)

--------------------COMBAT---------------------

local CombatTab = Main:NewTab("Combat")
local PlayerSection = CombatTab:NewSection("Player")

local SelectedPlayer: Player = nil


local PlayerESPThread = nil

local PlayerSelector = PlayerSection:NewDropdown("Players", "Select a Player to target", Players.GetPlayers(), function(selected)
	SelectedPlayer = selected
end)

PlayerSection:NewButton("Refresh Players", "Refresh Player selector", function()
	PlayerSelector:Refresh(Players.GetPlayers())
end)

local ESPSection = CombatTab:NewSection("ESP")

local ESPAllPlayer = nil
local ESPTargetPlayer = ESPSection:NewToggle("ESP Target", "ESP Selected Player", function(state)
	if state then
		PlayerESPThread.Start()
		ESPAllPlayer:UpdateToggle(nil, false)
	else
		PlayerESPThread.Stop()
		ESPAllPlayer:UpdateToggle(nil, false)
	end
end)

ESPAllPlayer = ESPSection:NewToggle("ESP Player", "ESP All Player", function (state)
	if state then
		PlayerESPThread.Start()
		ESPTargetPlayer:UpdateToggle(nil, false)
	else
		PlayerESPThread.Stop()
		ESPTargetPlayer:UpdateToggle(nil, false)
	end
end)

PlayerESPThread = ThreadLib.New(function (thread)
	while thread.active do
		if not UtilLib.IsNil(SelectedPlayer) and ESPTargetPlayer:GetToggleState() then
			if not SelectedPlayer.Character:WaitForChild("Head"):FindFirstChild('FrameESP') then
				MakeESPUI(SelectedPlayer)
			else
				ChangeESPValues(SelectedPlayer)
			end
		else
			for _, player: Player in pairs(Players:GetPlayers()) do
				if not UtilLib.IsNil(player) then
					if not player.Character:WaitForChild("Head"):FindFirstChild('FrameESP') then
						MakeESPUI(player)
					else
						ChangeESPValues(player)
					end
				end
			end
		end
	end
end)



