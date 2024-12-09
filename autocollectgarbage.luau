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
        
        local T = tonumber(RunEvery:GetText())
        local MT = tonumber(Threshold:GetText()) * 1024
        local Once = false
        
        RunService:BindToRenderStep("AutoCollectGarbage", Enum.RenderPriority.Last.Value, function()
            if not Once then
                MainWindow:Notify("Registered cleaning")
                Once = true
            end

            if tick() % T == 0 then
                local MemUsage = collectgarbage("count")
                if MemUsage > MT then
                    collectgarbage("collect")
                    MainWindow:Notify("Cleared memory!")
                end
            end
        end)
        
        MainWindow:Notify("Started monitor.")
    end

    MainSection:CreateButton("Start!", LogicStart)
    MainSection:CreateButton("Stop", LogicStop)
    Stop:SetDisabled(true)
end

Main()
