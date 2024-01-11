local GHRepo = "https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master"

local HttpService = game:GetService('HttpService')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')

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
	Title = "Information", Icon = "info"
})

local PlayersLabel = InformationTab:AddParagraph({
	Title = "Developers",
	Content = "ThatMG393"
})

--------------------COMBAT--------------------

local CombatTab = MainWin:AddTab({
	Title = "Combat", Icon = "swords"
})

local PlayerSection = CombatTab:AddSection("Player")

function BuildPlayerDropdown()
	local PlayersList = { "" }
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= Players.LocalPlayer then
			table.insert(PlayersList, player.Name)
		end
	end
	return PlayersList
end

local SelectedPlayer: Player? = nil

local PlayersDropdown = PlayerSection:AddDropdown("Dropdown", {
	Title = "Select Player",
	Values = BuildPlayerDropdown(),
	Multi = false,
	Default = 1
})

PlayersDropdown:OnChanged(function (selected)	
	if selected == "" then
		SelectedPlayer = nil
	else
		SelectedPlayer = Players:FindFirstChild(selected)
	end
end)

PlayerSection:AddButton({
	Title = "Refresh",
	Callback = function ()
		PlayersDropdown:SetValues(BuildPlayerDropdown())
	end 
})

local ESPSection = CombatTab:AddSection("ESP")

local function HighlightAPlayer(player: Player)
	local PlayerCharacter = player.Character

	if PlayerCharacter then
		if not PlayerCharacter:FindFirstChildWhichIsA("Highlight") then
			local Highlight = Instance.new("Highlight")	
			Highlight.FillColor = Color3.new(1, 0, 0)
			Highlight.Parent = PlayerCharacter
		end
	end
end

local function HighlightAllPlayers()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= Players.LocalPlayer then
			HighlightAPlayer(player)
		end
	end
end

local function UnhighlightAllPlayers()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= Players.LocalPlayer then
			local PlayerCharacter = player.Character

			if PlayerCharacter then
				local Highlight = PlayerCharacter:FindFirstChildWhichIsA("Highlight")
				if Highlight then
					Highlight:Destroy()
				end
			end
		end
	end
end

ESPSection:AddToggle({
	Title = "ESP Players",
	Callback = function (state)
		if state then
			HighlightAllPlayers()
		else
			UnhighlightAllPlayers()
		end
	end
})

ESPSection:AddToggle({
	Title = "ESP Selected",
	Callback = function (state)
		if state then
			UnhighlightAllPlayers()
			if SelectedPlayer then HighlightAPlayer(SelectedPlayer) end
		else
			UnhighlightAllPlayers()
		end
	end
})


