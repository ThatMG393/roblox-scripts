local HttpService = game:GetService("HttpService")

local ServersAmount = _G.ServersAmount or 25 -- 10, 25, 50, 100
local PlaceServers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=" .. ServersAmount
local PingRequire = _G.PingRequire or 390
local PingRequireDiff = _G.PingRequireDiff or 60
local PlayerMinMax = _G.PlayerMinMax or { 3, 5 }

function ShowNotif(opts, callback)
    local Bindable = Instance.new("BindableFunction")
    Bindable.OnInvoke = callback or function (a) end
    opts.Callback = Bindable
	
    return game:GetService("StarterGui"):SetCore("SendNotification", opts)
end

function ListServers(cursor)
   local Response = game:HttpGet(PlaceServers .. ((cursor and "&cursor=" .. cursor) or ""))
   return HttpService:JSONDecode(Response)
end

function FindServerMeetsRequire(noGiveUp, debug, nextPage)
	debug = _G.debug_server or debug or false
	local Servers = ListServers(nextPage)

	local minPingRequire = math.clamp(PingRequire - PingRequireDiff, 10, 9999)
	local maxPingRequire = PingRequire + PingRequireDiff
	
	print(minPingRequire)
	print(maxPingRequire)
    
    for _, v in pairs(Servers.data) do
		if v then
			if debug then
				print("Server ID: " .. v.id)
				print("Server Ping: " .. v.ping)
				print("Server Playing: " .. v.playing)
			end

			if v.playing >= PlayerMinMax[1] and v.playing <= PlayerMinMax[2] then
				if _G.debug_server then print(v.ping .. " >= " .. minPingRequire .. " and " .. v.ping .. " <= " .. maxPingRequire) end
				if v.ping >= minPingRequire and v.ping <= maxPingRequire then
					print("Found server! " .. v.id)
					return v
				end
			end
		end
    end
	
	if noGiveUp then
		return FindServerMeetsRequire(noGiveUp, debug, Servers.nextPageCursor)
	else
		return nil
	end
end


function Main()
	ShowNotif({
		Title = "Searching for servers...",
		Text = "Sit back & chillax",
		Duration = 5
	})

    local Success, FoundServer = pcall(FindServerMeetsRequire, true, false)
    
    if Success and FoundServer then
        ShowNotif({
            Title = "Found Server!",
            Text = "Ping: " .. FoundServer.ping .. ", Players: " .. FoundServer.playing,
            Duration = 240,
            Button1 = "Join",
            Button2 = "Again"
		}, function (answer)
            if answer == "Join" then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, FoundServer.id, game:GetService("Players").LocalPlayer)
            elseif answer == "Again" then
                Main()
            end
        end)
	else
		ShowNotif({
			Title = "Cannot find any server :(",
			Text = "",
			Duration = 5,
			Button1 = "Again"
		}, function (answer)
			Main()
		end)
	end
end

Main()
