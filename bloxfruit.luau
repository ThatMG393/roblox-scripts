local GHRepo = "https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master"

local HttpService = game:GetService('HttpService')
local Players = game:GetService('Players')

local EngoLib = loadstring(game:HttpGet(GHRepo .. "/Utils/engo-lib.lua"))()
local ThreadLib = loadstring(game:HttpGet(GHRepo .. "/Utils/ThreadLib.luau"))()
local UtilLib = loadstring(game:HttpGet(GHRepo .. "/Utils/NecesarryUtils.luau"))()

local Main = EngoLib.new(
	"Blox Fruits | ThatMG393",
	"",
	Enum.KeyCode.LeftControl
)

--------------------INFORMATION---------------------

local InformationTab = Main:CreateTab("Information")

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

local FarmTab = Main:CreateTab("AutoFarm")

local AutoFarmToggle = FarmTab:CreateToggle("Auto Farm Level", function(state)  end)

--------------------COMBAT---------------------

local CombatTab = Main:NewTab("Combat")

local SelectedPlayer: Player = nil

local PlayerSelector = CombatTab:CreateDropdown("Players", Players:GetPlayers(), function(selected)
	SelectedPlayer = selected
end)

CombatTab:CreateButton("Refresh Players", function()
	PlayerSelector:Refresh(Players.GetPlayers())
end)



