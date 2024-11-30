local ServerHopper = {}

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local SERVERS_PER_PAGE = 100
local MAX_PAGES = 10

function ServerHopper:FindServer(minPlayer, maxPlayer, minPing, maxPing)
	local function GetServersAPI(cursor)
		local url = string.format(
			"https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=%d%s",
			game.PlaceId,
			SERVERS_PER_PAGE,
			cursor and "&cursor=" .. cursor or ""
		)
		return HttpService:JSONDecode(game:HttpGet(url))
	end
	
	local function FilterServers()
		local function FilterServersInternal(servers)
			for _, server in ipairs(servers) do
				if server.playing >= minPlayer and server.playing <= maxPlayer
				and server.ping >= minPing and server.ping <= maxPing then
					return { serverInfo = server }
				end
			end

			return { serverInfo = nil }
		end

		local servers = GetServersAPI()
		
		for i = 0, MAX_PAGES do
			local server = FilterServersInternal(servers)
			if server.serverInfo ~= nil then return server end

			servers = GetServersAPI(servers.nextPageCursor)
		end

		return { serverInfo = nil }
	end

	return FilterServers()
end

function ServerHopper:InitUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ServerHopperUI"
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Server Hopper"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    local function createInputGroup(name, placeholder, yPosition)
        local GroupFrame = Instance.new("Frame")
        GroupFrame.Name = name .. "Group"
        GroupFrame.Size = UDim2.new(0.9, 0, 0, 70)
        GroupFrame.Position = UDim2.new(0.05, 0, 0, yPosition)
        GroupFrame.BackgroundTransparency = 1
        GroupFrame.Parent = MainFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.Position = UDim2.new(0, 0, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.Gotham
        Label.Parent = GroupFrame
        
        local InputFrame = Instance.new("Frame")
        InputFrame.Size = UDim2.new(1, 0, 0, 40)
        InputFrame.Position = UDim2.new(0, 0, 0, 25)
        InputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        InputFrame.Parent = GroupFrame
        
        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 6)
        InputCorner.Parent = InputFrame
        
        local TextBox = Instance.new("TextBox")
        TextBox.Name = name .. "Input"
        TextBox.Size = UDim2.new(0.9, 0, 1, 0)
        TextBox.Position = UDim2.new(0.05, 0, 0, 0)
        TextBox.BackgroundTransparency = 1
        TextBox.Text = ""
        TextBox.PlaceholderText = placeholder
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        TextBox.TextSize = 14
        TextBox.Font = Enum.Font.Gotham
        TextBox.Parent = InputFrame
        
        return TextBox
    end
    
    local MinPlayersInput = createInputGroup("Min Players", "3", 60)
    local MaxPlayersInput = createInputGroup("Max Players", "5", 140)
    local MinPingInput = createInputGroup("Min Ping", "300", 220)
    local MaxPingInput = createInputGroup("Max Ping", "400", 300)
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0.05, 0, 0, 370)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = MainFrame
    
    local function createButton(name, text, position)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(0.4, 0, 0, 40)
        Button.Position = position
        Button.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.Font = Enum.Font.GothamBold
        Button.Parent = MainFrame
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 100, 210)
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 122, 255)
            }):Play()
        end)
        
        return Button
    end
    
    local SearchButton = createButton("SearchButton", "Search", UDim2.new(0.05, 0, 0.85, 0))
	local TeleportButton = createButton("TeleportButton", "Teleport", UDim2.new(0.55, 0, 0.55, 0))
   
	local MakeDraggable = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/MakeDraggable.luau"))
	MakeDraggable(MainFrame)
    
    return {
        gui = ScreenGui,
        minPlayersInput = MinPlayersInput,
        maxPlayersInput = MaxPlayersInput,
        minPingInput = MinPingInput,
        maxPingInput = MaxPingInput,
        searchButton = SearchButton,
		teleportButton = TeleportButton,
        statusLabel = StatusLabel
    }
end

-- Create and handle the UI
function ServerHopper:HandleUI()
    local ui = ServerHopper:InitUI() 
	local foundServer = nil
    local searching = false
    
    -- Function to update status
    local function updateStatus(message, isError)
        ui.statusLabel.Text = message
        ui.statusLabel.TextColor3 = isError and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(200, 200, 200)
    end
    
    -- Function to validate inputs
    local function validateInputs()
        local minPlayers = tonumber(ui.minPlayersInput.Text)
        local maxPlayers = tonumber(ui.maxPlayersInput.Text)
        local minPing = tonumber(ui.minPingInput.Text)
        local maxPing = tonumber(ui.maxPingInput.Text)
        
        if not (minPlayers and maxPlayers and minPing and maxPing) then
            updateStatus("Please enter valid numbers", true)
            return false
        end
        
        if minPlayers > maxPlayers then
            updateStatus("Min players must be less than max players", true)
            return false
        end
        
        if minPing > maxPing then
            updateStatus("Min ping must be less than max ping", true)
            return false
        end
        
        return true
    end
    
    ui.searchButton.MouseButton1Click:Connect(function()
        if not validateInputs() then return end
        if searching then return end
        searching = true

		ui.searchButton.Text = "..."
        ui.searchButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		ui.teleportButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

        updateStatus("Searching for server...", false)

		local result = ServerHopper:FindServer(
			tonumber(ui.minPlayersInput.Text),
			tonumber(ui.maxPlayersInput.Text),
			tonumber(ui.minPingInput.Text),
			tonumber(ui.maxPingInput.Text)
		)

		searching = false

		ui.searchButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
		ui.teleportButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
		ui.searchButton.Text = "Retry"

		if result.serverInfo ~= nil then
			foundServer = result.serverInfo
			updateStatus("Found server! Ping: " .. foundServer.ping .. ", Players: " .. foundServer.playing)
		else
			updateStatus("Failed to find a server", true)
		end
    end)

	ui.teleportButton.MouseButton1Click:Connect(function()
		if searching then return end
		if foundServer ~= nil then return end

		TeleportService:TeleportToPlaceInstance(
			game.PlaceId, foundServer.id, Players.LocalPlayer
		)
	end)
    
    ui.gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

ServerHopper:HandleUI()
