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
	Callback = function (selected)
		if selected == "" then
			SelectedPlayer = nil
		else
			SelectedPlayer = Players:FindFirstChild(selected)
		end
	end,
	Default = 1
})

PlayerSection:AddButton({
	Title = "Refresh",
	Callback = function ()
		PlayersDropdown:SetValues(BuildPlayerDropdown())
	end 
})

RunService.Heartbeat:ConnectParallel(function()
	if not UtilLib.IsNil(SelectedPlayer) then
		local PlayerCharacter = SelectedPlayer.Character

		if PlayerCharacter then
			if PlayerCharacter:FindFirstChildWhichIsA("Highlight") then
				PlayerCharacter:FindFirstChildWhichIsA("Highlight"):Destroy()
			end

			local Highlight = Instance.new("Highlight")
			Highlight.FillColor = Color3.new(0, 1)
			Highlight.Parent = PlayerCharacter
		end
	else
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= Players.LocalPlayer then
				local PlayerCharacter = player.Character

				if PlayerCharacter then
					if PlayerCharacter:FindFirstChildWhichIsA("Highlight") then
						PlayerCharacter:FindFirstChildWhichIsA("Highlight"):Destroy()
					end

					local Highlight = Instance.new("Highlight")
					Highlight.FillColor = Color3.new(0, 1)
					Highlight.Parent = PlayerCharacter
				end
			end
		end
	end
end)




