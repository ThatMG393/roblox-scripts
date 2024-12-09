local MGUI = _G.NoGUI and nil or loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/UI/MGUI.luau"))()
local RunService = game:GetService("RunService")

local GarbageCollector = {}
GarbageCollector.__index = GarbageCollector

function GarbageCollector.new(notifyFunc)
    local self = setmetatable({}, GarbageCollector)
    self.notify = notifyFunc
    self._running = false
    self._elapsedTime = 0
    return self
end

function GarbageCollector:Start(interval, thresholdMB)
    if self._running then return end
    self._running = true
    self._elapsedTime = 0

    local thresholdKB = thresholdMB * 1024

    self.notify("Garbage collection monitor started.")

    RunService:BindToRenderStep("AutoCollectGarbage", Enum.RenderPriority.Last.Value, function(delta: number)
        self._elapsedTime += delta

        if self._elapsedTime >= interval then
            self._elapsedTime = 0

            local memUsage = collectgarbage("count")
            if memUsage > thresholdKB then
                collectgarbage("collect")
                self.notify("Memory cleaned up!")
            end
        end
    end)
end

function GarbageCollector:Stop()
    if not self._running then return end
    self._running = false
    RunService:UnbindFromRenderStep("AutoCollectGarbage")
    self.notify("Garbage collection monitor stopped.")
end

local function runWithoutGUI()
    local gcMonitor = GarbageCollector.new(print)
    local defaultInterval = 20
    local defaultThreshold = 1200
    gcMonitor:Start(defaultInterval, defaultThreshold)
end

local function runWithGUI()
    local WinOpt = MGUI.DefaultWindowOptions
    WinOpt.WindowTitle = "AutoCollectGarbage"
    WinOpt.WindowSize = { X = 340, Y = 300 }
    WinOpt.ResetOnSpawn = false

    local MainWindow = MGUI.CreateWindow(WinOpt)
    local MainSection = MainWindow:CreateSection("Main")

    local RunEvery = MainSection:CreateInputField("Run GC every (in seconds)", 20, 20)
    local Threshold = MainSection:CreateInputField("GC Threshold (in MB)", 1200, 1200)

    local StartButton = nil
    local StopButton = nil

    local gcMonitor = GarbageCollector.new(function(a)
    	MainWindow:Notify(a)
    end)

    local function LogicStop(Button)
        Button:SetDisabled(true)
        if StartButton then
            StartButton:SetDisabled(false)
        end
        gcMonitor:Stop()
    end

    local function LogicStart(Button)
        Button:SetDisabled(true)
        if StopButton then
            StopButton:SetDisabled(false)
        end

        local interval = tonumber(RunEvery:GetText()) or 20
        local thresholdMB = tonumber(Threshold:GetText()) or 1200

        gcMonitor:Start(interval, thresholdMB)
    end

    StartButton = MainSection:CreateButton("Start!", LogicStart)
    StopButton = MainSection:CreateButton("Stop", LogicStop)
    StopButton:SetDisabled(true)
end

function Main()
    if _G.NoGUI then
        runWithoutGUI()
    else
        runWithGUI()
    end
end

Main()
