local M = { }

function M:MouseButton1ClickConnect(frame: Frame, callback)
	local hovered

	frame.MouseEnter:Connect(function()
		hovered = true
	end)

	frame.MouseLeave:Connect(function()
		hovered = false
	end)

	game:GetService("UserInputService").InputEnded:Connect(function(input: InputObject, gameProcessed: boolean)
		if table.find({
			Enum.UserInputType.MouseButton1,
			Enum.UserInputType.Touch
		}, input.UserInputType) and hovered then callback() end
	end)
end

return M
