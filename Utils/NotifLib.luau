local NotificationModule = {}

local TweenService = game:GetService("TweenService")

NotificationModule.DefaultConfig = {
	StayTime = 5,
	EnterDuration = 0.5,
	LeaveDuration = 0.5,
}

function NotificationModule.Create(Parent: GuiObject)
    local NotificationGui = Instance.new("Frame")
    NotificationGui.Name = "NotificationGui"
    NotificationGui.Size = UDim2.fromScale(1, 1)
    NotificationGui.Position = UDim2.fromScale(0.7, 0)
    NotificationGui.BackgroundTransparency = 1
    NotificationGui.Parent = Parent

    local AdjustAnimInfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)

    local M = { }
    function M:ShowNotification(Options)
    	Options = Options or NotificationModule.DefaultConfig

    	local EnterAnimInfo = TweenInfo.new(Options.EnterDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    	local LeaveAnimInfo = TweenInfo.new(Options.LeaveDuration, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)

    	local M2 = {
    		Task = nil,
    	}

		local Notifications = NotificationGui:GetChildren()
		if #Notifications > 1 then
    		for _, v in ipairs(Notifications) do
    			TweenService:Create(
    				v, AdjustAnimInfo, {
    					Position = UDim2.fromScale(
    						v.Position.X.Scale,
    						(v.Position.Y.Scale + v.Size.Y.Scale) + 0.1
    					)
    				}
    			):Play()
    		end
    	end

		local UIReferences = Options.UIReferences
    	UIReferences.Notification.Parent = NotificationGui
    	UIReferences.Notification.Position = UDim2.fromScale(1, 0)

        TweenService:Create(UIReferences.Notification, EnterAnimInfo, { Position = UDim2.fromScale(0, 0), }):Play()
        
        function M2:CloseNotification()
        	if M2.Task then
        		pcall(function() task.cancel(M2.Task) end)
        	end

            local SlideOutTween = TweenService:Create(UIReferences.Notification, LeaveAnimInfo, { Position = UDim2.fromScale(2, 0), })
            SlideOutTween:Play()
            SlideOutTween.Completed:Wait()

            UIReferences.Notification:Destroy()
        end
        
        UIReferences.Close.MouseButton1Click:Connect(M2.CloseNotification)
        
        M2.Task = task.delay(Options.StayTime, M2.CloseNotification)
        return M2
    end
    
    return M
end

return NotificationModule
