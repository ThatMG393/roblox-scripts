local MGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/UI/MGUI.luau"))()
local RunService = game:GetService("RunService")

function Main()
    local WinOpt = MGUI.DefaultWindowOptions
    WinOpt.WindowTitle = "AutoCollectGarbage"
    WinOpt.WindowSize = { X = 340, Y = 300 }
    WinOpt.ResetOnSpawn = false

    local MainWindow = MGUI.CreateWindow(WinOpt)
    local MainSection = MainWindow:CreateSection("Main")

    local RunEvery = MainSection:CreateInputField("Run GC every (in seconds)", 20, 20)
    local Threshold = MainSection:CreateInputField("GC Threshold (in MB)", 1200, 1200)
    
    local Start = nil
    local Stop = nil

    local function LogicStop(Button)
        Button:SetDisabled(true)
        if Start then
            Start:SetDisabled(false)
        end
        
        RunService:UnbindFromRenderStep("AutoCollectGarbage")
        MainWindow:Notify("Stopped.")
    end

    local function LogicStart(Button)
        Button:SetDisabled(true)
        if Stop then
            Stop:SetDisabled(false)
        end
        
        local interval = tonumber(RunEvery:GetText()) or 20
        local thresholdMB = tonumber(Threshold:GetText()) or 1200
        local thresholdKB = thresholdMB * 1024

        local elapsedTime = 0
        local once = false

        RunService:BindToRenderStep("AutoCollectGarbage", Enum.RenderPriority.Last.Value, function(delta: number)
            if not once then
                MainWindow:Notify("Registered cleaning")
                once = true
            end

            elapsedTime = elapsedTime + delta
            if elapsedTime >= interval then
                elapsedTime = 0

                local memUsage = collectgarbage("count")
                if memUsage > thresholdKB then
                    collectgarbage("collect")
                    MainWindow:Notify("Cleared memory!")
                end
            end
        end)

        MainWindow:Notify("Started monitor.")
    end

    Start = MainSection:CreateButton("Start!", LogicStart)
    Stop = MainSection:CreateButton("Stop", LogicStop)
    Stop:SetDisabled(true)
end

Main()
