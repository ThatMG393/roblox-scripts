local DebrisService = game:GetService("Debris")
local PlayersService = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local Toast = {}
local MAX_TOASTS = 5 -- Maximum number of toasts displayed at one time
local activeToasts = {} -- Table to store active toast instances

function AnimateToast(toast, anim)
	-- Notification sound
	local sound = Instance.new("Sound", toast)
	sound.SoundId = "rbxassetid://6026984224"
	sound.SoundGroup = SoundService.BassBoost
	sound.RollOffMode = Enum.RollOffMode.LinearSquare
	sound.Volume = 5

	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
	local open = anim == "open"

	local imgParams = { ImageTransparency = open and 0 or 1 }
	local txtParams = { TextTransparency = open and 0 or 1 }

	if sound.Loaded then
		sound:Play()
	end

	local toastSize = open and UDim2.new(0, 326, 0, 58) or UDim2.new(0, 0, 0, 0)
	local imgTransparency = open and 0.4 or 1

	local iconTween = TweenService:Create(toast.IconBuffer.Icon, tweenInfo, imgParams)
	local upperTextTween = TweenService:Create(toast.TextBuffer.Upper, tweenInfo, txtParams)
	local lowerTextTween = TweenService:Create(toast.TextBuffer.Lower, tweenInfo, txtParams)
	local toastTween = TweenService:Create(toast, tweenInfo, { Size = toastSize, ImageTransparency = imgTransparency })

	toastTween:Play()
	iconTween:Play()
	upperTextTween:Play()
	lowerTextTween:Play()

	if not open then
		-- Add the toast to debris for removal
		DebrisService:AddItem(toast, 0.25)
		activeToasts[toast] = nil -- Remove the toast from active toasts

		-- Create a new array with remaining toasts
		local remainingToasts = {}
		for toast in pairs(activeToasts) do
			table.insert(remainingToasts, toast)
		end

		-- Sort the array based on LayoutOrder
		table.sort(remainingToasts, function(a, b)
			return a.LayoutOrder < b.LayoutOrder
		end)

		-- Rearrange LayoutOrder values of the remaining toasts
		for i, t in ipairs(remainingToasts) do
			t.LayoutOrder = i
		end
	end
end

function GetGui()
	local Player = PlayersService.LocalPlayer
	local ScreenGui = Player:WaitForChild("PlayerGui", 5):FindFirstChild("Toasts") or Instance.new("ScreenGui", Player.PlayerGui)

	ScreenGui.DisplayOrder = 2147483647
	ScreenGui.Name = "Toasts"
	ScreenGui.IgnoreGuiInset = true

	if ScreenGui:FindFirstChild("ToastFrame") then
		return ScreenGui:FindFirstChild("ToastFrame")
	else
		local Frame = Instance.new("Frame", screenGui)
		Frame.BackgroundTransparency = 1
		Frame.Size = UDim2.new(0, 500, 0, 500)
		Frame.AnchorPoint = Vector2.new(0.5, 0)
		Frame.Position = UDim2.new(0.5, 0, 0.03, 0)
		Frame.Name = "ToastFrame"

		local UIListLayout = Instance.new("UIListLayout", Frame)
		UIListLayout.Padding = UDim.new(0, 5)
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

		return Frame
	end
end

Toast.CreateToast = function(ToastId, TopText, BottomText, IconId, IconColor, DisplayTime)
	local newToast = script.Toast:Clone()
	newToast.TextBuffer.Upper.Text = TopText
	newToast.TextBuffer.Lower.Text = BottomText
	newToast.IconBuffer.Icon.Image = IconId
	newToast.IconBuffer.Icon.ImageColor3 = IconColor or Color3.fromRGB(255, 255, 255)
	newToast.Name = ToastId
	newToast.LayoutOrder = #activeToasts + 1

	local oldToast = GetGui():FindFirstChild(ToastId)
	local run = false

	if oldToast then
		run = oldToast.ImageTransparency < 0.4
	end

	if not run then
		DebrisService:AddItem(newToast, DisplayTime or math.huge)
		AnimateToast(newToast, "open")
		newToast.Parent = GetGui()

		activeToasts[newToast] = true -- Add the new toast to the active toasts table
		CheckMaxToasts() -- Check if the maximum number of toasts is exceeded
		UpdateToastPositions() -- Update the positions of the toasts

		return {
			CancelToast = function()
				AnimateToast(newToast, "cancel")
			end,

			DestroyToast = function(delaytime)
				DebrisService:AddItem(newToast, delaytime or 0)
			end,

			HideToast = function()
				newToast.Visible = false
			end,

			ShowToast = function()
				newToast.Visible = true
			end,
		}
	else
		return { CancelToast = empty(), DestroyToast = empty(), HideToast = empty(), ShowToast = empty() }
	end
end

function empty()
	return function() end
end

Toast.GetToast = function(id)
	local gui = GetGui()
	local toast = gui:FindFirstChild(id)

	if toast then
		return {
			CancelToast = function()
				AnimateToast(toast, "cancel")
			end,

			DestroyToast = function(delaytime)
				DebrisService:AddItem(toast, delaytime or 0)
			end,

			HideToast = function()
				toast.Visible = false
			end,

			ShowToast = function()
				toast.Visible = true
			end,
		}
	else
		return { CancelToast = empty(), DestroyToast = empty(), HideToast = empty(), ShowToast = empty() }
	end
end

Toast.CancelAllToasts = function()
	for i, toast in pairs(GetGui():GetChildren()) do
		AnimateToast(toast, "cancel")
	end
end

function UpdateToastPositions()
	local gui = GetGui()
	local children = gui:GetChildren()
	local yPos = 0

	for i, toast in ipairs(children) do
		-- Check if the toast is an instance of Frame, which has a Position property
		if toast:IsA("Frame") then
			toast.Position = UDim2.new(0, 0, 0, yPos)
			yPos = yPos + toast.Size.Y.Offset
		end
	end
end

function CheckMaxToasts()
	local gui = GetGui()
	local children = {}

	-- Add only ImageLabel instances to the children table
	for _, child in ipairs(gui:GetChildren()) do
		if child:IsA("ImageLabel") then
			table.insert(children, child)
		end
	end

	-- Sort children by LayoutOrder
	table.sort(children, function(a, b)
		return a.LayoutOrder < b.LayoutOrder
	end)

	while #children > MAX_TOASTS do
		AnimateToast(children[1], "cancel")
		table.remove(children, 1)
	end
end

return Toast
