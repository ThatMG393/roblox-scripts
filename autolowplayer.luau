local HttpService = game:GetService("HttpService")

local ServersAmount = _G.ServersAmount or 25 -- 10, 25, 50, 100
local PlaceServers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=" .. ServersAmount
local PingRequire = _G.PingRequire or 360
local PingRequireDiff = _G.PingRequireDiff or 60
local PlayerMinMax = _G.PlayerMax or { 3, 3 }

function ShowNotif(opts, callback)
    local Bindable = Instance.new("BindableFunction")
    Bindable.OnInvoke = callback
    opts.Callback = Bindable

    return game:GetService("StarterGui"):SetCore("SendNotification", opts)
end

function ListServers(cursor)
   local Response = game:HttpGet(PlaceServers .. ((cursor and "&cursor=" .. cursor) or ""))
   return HttpService:JSONDecode(Response)
end

function FindServerMeetsRequire(noGiveUp, nextPage, debug)
	debug = _G.debug_server or debug or false
	ShowNotif({
		Title = "Searching for servers...",
		Duration = 5
	})

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
		return FindServerMeetsRequire(noGiveUp, Servers.nextPageCursor, debug)
	else
    	return nil
	end
end


function Main()
    local FoundServer = FindServerMeetsRequire(true, false)
    
    if FoundServer then
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
    end
end

Main()
