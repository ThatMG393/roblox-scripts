local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local MGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/UI/MGUI.luau"))()

local function FindServer(Options)
	local function GetServers(Cursor: string?)
		local url = string.format(
			"https://games.roproxy.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=%d%s",
			game.PlaceId,
			Options.ServersPerPage,
			Cursor and "&cursor=" .. Cursor or ""
		)

		if Options.Debug then
			print("Pinging " .. url)
		end

		return HttpService:JSONDecode(game:HttpGet(url))
	end

	local function GetCandidateServer(servers)
		for _, server in ipairs(servers.data) do
			if server.playing >= Options.MinPlayer 
			and server.playing <= Options.MaxPlayer
			and server.ping >= Options.MinPing
			and server.ping <= Options.MaxPing then
				return { serverInfo = server }
			end
		end
		return { serverInfo = nil }
	end

	local servers = GetServers()
	if servers.error or #servers.data == 0 then
		Options.Callback(false, servers)
	end
	
	for i = 0, Options.ServerPages do
		local server = GetCandidateServer(servers)
		if server.serverInfo ~= nil then
			Options.Callback(true, server.serverInfo)
			return
		end
		servers = GetServers(servers.nextPageCursor)
	end
	Options.Callback(false, nil)
end

local function TableToString(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. TableToString(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function Main()
	local WinOpt = MGUI.DefaultWindowOptions
	WinOpt.WindowTitle = "AutoLowPlayer"
	WinOpt.WindowSize = { X = 340, Y = 300 }
	WinOpt.ResetOnSpawn = false
	
	local MainWindow = MGUI.CreateWindow(WinOpt)

	local FoundServer = nil
	local function DoTeleport()
		MainWindow:Notify("Teleporting to " .. tostring(FoundServer.id) .. "!")

		task.wait(1)
		TeleportService:TeleportToPlaceInstance(
			game.PlaceId, FoundServer.id, Players.LocalPlayer
		)
	end
	
	local MainTab = MainWindow:CreateTab("Main")
	local ConfigTab = MainWindow:CreateTab("Config")
	local ConfigSection = ConfigTab:CreateSection("Config")
	local MinPlayer = ConfigSection:CreateInputField("Max server players", 20, 20)
	local MaxPlayer = ConfigSection:CreateInputField("Min server players", 0, 0)
	local MinPing = ConfigSection:CreateInputField("Min server ping", 0, 0)
	local MaxPing = ConfigSection:CreateInputField("Max server ping", 1000, 1000)
	local JoinWhenFound = ConfigSection:CreateToggle("Join when server found", false)

	local ExtrasSection = ConfigTab:CreateSection("Extras")
	local ServersPerPage = ExtrasSection:CreateInputField("Servers per page", 100, 100) --dropdown would be much better
	local ServerPages = ExtrasSection:CreateInputField("Server pages", 3, 3)

	local DebugSection = ConfigTab:CreateSection("Debug")
	local DebugToggle = DebugSection:CreateToggle("Debug logs", false)

	local MainSection = MainTab:CreateSection("Main")
	local StatusLabel = MainSection:CreateLabel("Hello!")
	local ServerInfoLabel = MainSection:CreateLabel("Server Info: nil")
	local function UpdateServerInfo(Server)
		ServerInfoLabel:UpdateLabel("Server Info: Players = " .. tostring(Server.players) .. ", Ping: " .. tostring(Server.ping))
	end

	local TeleportButton = MainSection:CreateButton("Teleport!!", DoTeleport)
	TeleportButton:SetDisabled(true)

	MainSection:CreateButton("Search!", function(Button)
		Button:SetDisabled(true)
		TeleportButton:SetDisabled(true)

		FindServer {
			MinPlayer = MinPlayer:GetText(), MaxPlayer = MaxPlayer:GetText(),
			MinPing = MinPing:GetText(), MaxPing = MaxPing:GetText(),
			ServersPerPage = ServersPerPage:GetText(), ServerPages = ServerPages:GetText(),
			Debug = DebugToggle:GetState(),
			Callback = function(success: boolean, result: any)
				if success then
					UpdateServerInfo(result)
					FoundServer = result

					if not JoinWhenFound:GetState() then
						StatusLabel:UpdateLabel("Found server!")
						TeleportButton:SetDisabled(false)
						MainWindow:Notify("AutoLowPlayer", "Found server! Check the GUI!")
					else
						DoTeleport()
					end
				else
					StatusLabel:UpdateLabel("Failed to find servers.")
					TeleportButton:SetDisabled(true)
					MainWindow:Notify("AutoLowPlayer", "Failed to find server! Check the GUI!")
				end

				Button:SetDisabled(false)
			end
		}
	end)

	MainTab:Select()
end

Main()
