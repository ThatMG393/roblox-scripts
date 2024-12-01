local M = { }

local UserInputService = game:GetService("UserInputService")

function M:MakeDraggableFromWithAnim(inputRecv: GuiObject, guiToMove: GuiObject, animDelay: number)
	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart

		if animDelay ~= nil or animDelay > 0 then
			game:GetService("TweenService"):Create(guiToMove, TweenInfo.new(animDelay), {
				Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			}):Play()
		end
	end

	inputRecv.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = guiToMove.Position

			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false

					UserInputService.MouseBehavior = Enum.MouseBehavior.Default
				end
			end)
		end
	end)

	inputRecv.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function M:MakeDraggableFrom(inputRecv: GuiObject, guiToMove: GuiObject)
	self.MakeDraggableFromWithAnim(inputRecv, guiToMove, .25)
end

function M:MakeDraggable(gui: GuiObject)
	self.MakeDraggableFrom(gui, gui)
end

return M
