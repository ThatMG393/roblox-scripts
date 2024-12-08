local NotificationModule = {}

local TweenService = game:GetService("TweenService")

NotificationModule.DefaultConfig = {
	StayTime = 10,
	EnterDuration = 0.5,
	LeaveDuration = 0.5,
	UIReferences = {
		Notification = nil,
		Close = nil,
	},
}

function NotificationModule.Create(Parent: GuiObject)
	local NotificationGui = Instance.new("Frame")
	NotificationGui.Name = "NotificationGui"
	NotificationGui.Size = UDim2.fromScale(1, 1)
	NotificationGui.Position = UDim2.fromScale(0.65, 0)
	NotificationGui.BackgroundTransparency = 1
	NotificationGui.Parent = Parent

	local AdjustAnimInfo = TweenInfo.new(0.1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

	local function AdjustNotifications()
		local YOffset = 0
		local Notifications = NotificationGui:GetChildren()
		table.sort(Notifications, function(a, b)
			return a.Position.Y.Scale < b.Position.Y.Scale
		end)

		for _, Notification in ipairs(Notifications) do
			if Notification:GetAttribute("Entering") then
				continue
			end
			TweenService:Create(Notification, AdjustAnimInfo, { Position = UDim2.fromScale(0, YOffset) }):Play()
			YOffset = YOffset + Notification.Size.Y.Scale + 0.03
		end
	end

	local function MoveNotifications(Notification: GuiObject)
		for _, v in ipairs(NotificationGui:GetChildren()) do
			if v == Notification or v:GetAttribute("Entering") then
				continue
			end

			TweenService:Create(v, AdjustAnimInfo, {
				Position = UDim2.fromScale(v.Position.X.Scale, (v.Position.Y.Scale + v.Size.Y.Scale) + 0.03),
			}):Play()
		end
	end

	local M = {}
	function M:ShowNotification(Options)
		Options = Options or NotificationModule.DefaultConfig

		local EnterAnimInfo = TweenInfo.new(Options.EnterDuration, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
		local LeaveAnimInfo = TweenInfo.new(Options.LeaveDuration, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)

		local M2 = {
			Task = nil,
			Closed = false,
		}

		local UIReferences = Options.UIReferences
		UIReferences.Notification.Parent = NotificationGui
		UIReferences.Notification.Position = UDim2.fromScale(1, 0)
		UIReferences.Notification:SetAttribute("Entering", true)

		MoveNotifications(UIReferences.Notification)

		local EnterTween = TweenService:Create(UIReferences.Notification, EnterAnimInfo, { Position = UDim2.fromScale(0, 0) })
		EnterTween:Play()
		EnterTween.Completed:Connect(function()
			UIReferences.Notification:SetAttribute("Entering", false)
			AdjustNotifications()
		end)

		function M2:CloseNotification()
			if M2.Closed then
				return
			end
			M2.Closed = true

			if M2.Task then
				pcall(function()
					task.cancel(M2.Task)
				end)
			end

			local SlideOutTween = TweenService:Create(UIReferences.Notification, LeaveAnimInfo, { Position = UDim2.fromScale(2, UIReferences.Notification.Position.Y.Scale) })
			SlideOutTween:Play()
			SlideOutTween.Completed:Connect(function()
				UIReferences.Notification:Destroy()
				AdjustNotifications()
			end)
		end

		if UIReferences.Close then
			UIReferences.Close.MouseButton1Click:Connect(M2.CloseNotification)
		end

		M2.Task = task.delay(Options.StayTime, M2.CloseNotification)
		return M2
	end

	return M
end

return NotificationModule
