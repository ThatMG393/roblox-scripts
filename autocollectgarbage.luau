local MGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/UI/MGUI.luau"))()

function Main()
	local WinOpt = MGUI.DefaultWindowOptions
	WinOpt.WindowTitle = "AutoCollectGarbage"
	WinOpt.WindowSize = { X = 340, Y = 300 }
	WinOpt.ResetOnSpawn = false

	local MainWindow = MGUI.CreateWindow(WinOpt)
	local MainSection = MainWindow:CreateSection("Main")

	local RunEvery = MainSection:CreateInputField("Run GC every (in seconds)", 20, 20)
	local Threshold = MainSection:CreateInputField("GC Threshold (in MB)", 1200, 1200)
	
	local EveryFrameCallback = nil
	local Start = nil
	local Stop = nil

	local function LogicStop(Button)
		Button:SetDisabled(true)
		if Start then
			Start:SetDisabled(false)
		end

		if EveryFrameCallback then
			EveryFrameCallback:Disconnect()
		end
		MainWindow:Notify("Stopped.")
	end

	local function LogicStart(Button)
		Button:SetDisabled(true)
		Stop:SetDisabled(false)
		
		local function EveryFrame()
    		if tick() % tonumber(RunEvery:GetText()) == 0 then
        		local MemUsage = collectgarbage("count")
    			if MemUsage > tonumber(Threshold:GetText()) then
        			collectgarbage("collect")
        			MainWindow:Notify("Cleared memory!")
    			end
    		end
		end

		EveryFrameCallback = game:GetService("RunService").Heartbeat:Connect(EveryFrame)
		MainWindow:Notify("Started monitor.")
	end

	Start = MainSection:CreateButton("Start!", LogicStart)
	Stop = MainSection:CreateButton("Stop", LogicStop)
	Stop:SetDisabled(true)
end

Main()
