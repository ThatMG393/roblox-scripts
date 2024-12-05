local NotificationModule = {}

local TweenService = game:GetService("TweenService")

NotificationModule.DefaultConfig = {
    Duration = 5,
    AnimationDuration = 0.5,
    Parent = nil
}

function NotificationModule.Create(Parent: GuiObject)
    local NotificationGui = Instance.new("Frame")
    NotificationGui.Name = "NotificationGui"
    NotificationGui.Size = UDim2.fromScale(1, 1)
    NotificationGui.Parent = Parent

    local M = { }
    function M:ShowNotification(Options)
    	Options = Options or NotificationModule.DefaultConfig

    	local M2 = {
    		Task = nil,
    	}

    	local UIReferences = Options.UIReferences

    	UIReferences.Notification.Parent = NotificationGui

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
