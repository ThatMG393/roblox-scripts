local ServersAmount = 25 -- 10, 25, 50, 100
local PlaceServers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=" .. ServersAmount
local PingRequire = 300 -- ~100ms
local PingRequireDiff = 60
local PlayerMax = 3

function ShowNotif(opts, callback)
    local Bindable = Instance.new("BindableFunction")
    Bindable.OnInvoke = callback
    opts.Callback = Bindable

    game.GetService("StarterGui"):SetCore("SendNotification", opts)
end

function ListServers(cursor)
   local Response = game:GetService("HttpService"):GetAsync(PlaceServers .. ((cursor and "&cursor=" .. cursor) or ""))
   return game:GetService("HttpService"):JSONDecode(Response)
end

function FindServerMeetsRequire()
    local Servers = ListServers(nil)
    
    for _, v in pairs(Servers.data) do
        print("Server ID: " .. v.id)
        print("Server Ping: " .. v.ping)
        print("Server Playing: " .. v.playing)
        
        local minPingRequire = math.clamp(PingRequire - PingRequireDiff, 10, 9999)
        local maxPingRequire = PingRequire + PingRequireDiff
        
        print(minPingRequire)
        print(maxPingRequire)
        
        if v.playing <= PlayerMax then
            if v.ping >= minPingRequire and v.ping <= maxPingRequire then
                print("Found server! " .. v.id)
                return v
            end
        end
    end
    
    return nil
end


function Main()
    local FoundServer = FindServerMeetsRequire()
    
    if FoundServer then
        ShowNotif({
            Title = "Found Server!",
            Text = "Ping: " .. FoundServer.ping .. ", Players: " .. FoundServer.playing,
            Duration = 520,
            Button1 = "Join",
            Button2 = "Again"
        }, function (answer)
            if answer == "Join" then	
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, FoundServer.id, game.GetService("Players").LocalPlayer)
            elseif answer == "Again" then
                Main()
            end
        end)
    end
end

Main()
