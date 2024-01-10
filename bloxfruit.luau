local GHRepo = "https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master"

local HttpService = game:GetService('HttpService')
local Players = game:GetService('Players')

local EngoLib = loadstring(game:HttpGet(GHRepo .. "/Utils/engo-lib.lua"))
EngoLib = EngoLib()
local ThreadLib = loadstring(game:HttpGet(GHRepo .. "/Utils/ThreadLib.luau"))()
local UtilLib = loadstring(game:HttpGet(GHRepo .. "/Utils/NecesarryUtils.luau"))()

local Main = EngoLib.new(
	"Blox Fruits | ThatMG393",
	"",
	Enum.KeyCode.LeftControl
)

--------------------INFORMATION---------------------

local InformationTab = Main:CreateTab("Information")

local PlayersLabel = InformationTab:NewLabel("Players: 0")
local PingLabel = InformationTab:NewLabel("Ping: 0ms")

local AboutSection = InformationTab:NewSection("About")
AboutSection:NewLabel("Made by ThatMG393")

ThreadLib.NewThread(function ()
	while true do
		PlayersLabel:UpdateLabel("Players: " .. #Players:GetPlayers())
		PingLabel:UpdateLabel("Ping : " .. Players.LocalPlayer:GetNetworkPing() * 1000 .. "ms")

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



