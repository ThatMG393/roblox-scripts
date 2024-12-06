local PlayerGetter = {}
PlayerGetter.__index = PlayerGetter
PlayerGetter.DisplayNameCache = {}

local Players = game:GetService("Players")

function PlayerGetter.Init()
	local self = setmetatable({}, PlayerGetter)

	for _, Player in Players:GetPlayers() do
		self.DisplayNameCache[Player.DisplayName] = Player.DisplayName
	end

	Players.PlayerAdded:Connect(function(NewPlayer: Player)
		self.DisplayNameCache[NewPlayer.DisplayName] = NewPlayer.Name
	end)

	Players.PlayerRemoving:Connect(function(Player: Player)
		self.DisplayNameCache[Player.DisplayName] = nil
	end)

	return self
end

function PlayerGetter:GetPlayerFromDisplayName(DisplayName: string): Player
	return Players:FindFirstChild(self.DisplayNameCache[DisplayName])
end
