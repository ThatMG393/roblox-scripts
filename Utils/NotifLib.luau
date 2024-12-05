local NotificationModule = {}

local TweenService = game:GetService("TweenService")

local DefaultConfig = {
    Duration = 5,
    AnimationDuration = 0.5,
    Parent = nil
}

function NotificationModule.Create(Options)
	Options = Options or DefaultConfig

    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "NotificationGui"
    NotificationGui.Parent = Options.Parent

    local M = { }
    function M:ShowNotification(UIReferences)
    	local M2 = {
    		Task = nil,
    	}

        local SlideInTween = TweenService:Create(UIReferences.Notification,
            TweenInfo.new(Options.AnimationDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Position = UDim2.fromScale(0, 0), }
        )
        SlideInTween:Play()
        
        function M2:CloseNotification()
        	if M2.Task then
        		task.cancel(M2.Task)
        	end

            local SlideOutTween = TweenService:Create(UIReferences.Notification,
                TweenInfo.new(Options.AnimationDuration, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
                { Position = UDim2.fromScale(2, 0), }
            )
            SlideOutTween:Play()
            SlideOutTween.Completed:Wait()
            UIReferences.Notification:Destroy()
        end
        
        UIReferences.Close.MouseButton1Click:Connect(M2.CloseNotification)
        
        M2.Task = task.delay(Options.Duration, M2.CloseNotification)
        return M2
    end
    
    return M
end

return NotificationModule
