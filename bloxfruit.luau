local GHRepo = "https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master"

local KavoUI = loadstring(GHRepo .. "/Utils/kavo-ui.lua")()
local ThreadLib = loadstring(GHRepo .. "/Utils/ThreadLib.luau")()
local UtilLib = loadstring(GHRepo .. "/Utils/NecesarryUtils.luau")()

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

ThreadLib.NewThread(function ()
	while true do
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

local PlayerSelector = PlayerSection:NewDropdown("Players", "Select a Player to target", Players.GetPlayers(), function(selected)
	SelectedPlayer = selected
end)

PlayerSection:NewButton("Refresh Players", "Refresh Player selector", function()
	PlayerSelector:Refresh(Players.GetPlayers())
end)

local ESPSection = CombatTab:NewSection("ESP")
local PlayerESPThread = nil

local CalculateDist = function (player: Player)
	local Origin = Players.LocalPlayer.Character.WaitForChild("Head").Position
	local Target = player.Character:WaitForChild("Head").Position

	local Dist = (Origin - Target).Magnitude / 3
	return "Distance: " .. Dist .. "M"
end
local MakePlayerHealth = function (player: Player)
	local CurrentHealth = player.Character:WaitForChild("Humanoid").Health
	local MaxHealth = player.Character:WaitForChild("Humanoid").MaxHealth
	
	return CurrentHealth .. "/" .. MaxHealth
end

local MakeESPUI = function (player: Player)
	local ESPFrame = Instance.new("BillboardGui")
	ESPFrame.Parent = player.Character:WaitForChild("Head")
	ESPFrame.Adornee = player.Character:WaitForChild("Head")
	ESPFrame.AlwaysOnTop = true
	ESPFrame.Name = "FrameESP"

	local ESPName = Instance.new("TextLabel")
	ESPName.Parent = ESPFrame
	ESPName.Name = "DistanceESP"
	ESPName.TextTransparency = 0
	ESPName.BackgroundTransparency = 1
	ESPName.TextSize = 14
	ESPName.TextWrapped = true
	ESPName.Size = UDim2.new(0, 200, 0, 30)
	ESPName.Position = UDim2.new(0, 25, 0, 0)
	ESPName.Text = CalculateDist(player)

	local ESPHealth = Instance.new('TextLabel')
	ESPHealth.Parent = ESPFrame
	ESPHealth.Name = "HealthESP"
	ESPHealth.Text = MakePlayerHealth(player)
end

local ChangeESPValues = function (player: Player)
	local PlayerHead = player.Character:WaitForChild("Head")

	PlayerHead['FrameESP'].DistanceESP.Text = CalculateDist(player)
	PlayerHead['FrameESP'].HealthESP.Text = MakePlayerHealth(player)
end

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

PlayerESPThread = ThreadLib.NewThread(function ()
	while true do
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



