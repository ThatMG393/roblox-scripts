local GHRepo = "https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master"

local HttpService = game:GetService('HttpService')
local Players = game:GetService('Players')

local Fluent = loadstring(game:HttpGet(GHRepo .. "/UI/fluent-ui.lua"))()
local ThreadLib = loadstring(game:HttpGet(GHRepo .. "/Utils/ThreadLib.luau"))()
local UtilLib = loadstring(game:HttpGet(GHRepo .. "/Utils/NecesarryUtils.luau"))()

local MainWin = Fluent:CreateWindow({
	Title = "Blox Fruits | ThatMG393",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true,
	Theme = "Dark"
})

--------------------INFORMATION---------------------

local InformationTab = MainWin:AddTab({
	Title = "Information", Icon = ""
})

local PlayersLabel = InformationTab:AddParagraph({
	Title = "Developers",
	Content = "ThatMG393"
})

--------------------COMBAT--------------------

local CombatTab = MainWin:AddTab({
	Title = "Combat", Icon = ""
})

local PlayerSection = CombatTab:AddSection("Player")

local PlayersDropdown = PlayerSection:AddDropdown("Dropdown", {
	Title = "Select Player",
	Values = Players:GetPlayers(),
	Multi = false,
	Callback = function (selected)
		print(selected)
	end
})

local PlayersDropdownRefreshButton = PlayerSection:AddButton({
	Title = "Refresh",
	Callback = function ()
		PlayersDropdown:SetValues(Players:GetPlayers())
	end
})


