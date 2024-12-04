local M = {}

function M:AutoResizeTexts(element: Instance)
	local minYFactor

	for _, container in element:GetChildren() do
		if not container:IsA("TextLabel") then
			continue
		end

		local isDoneCalculatingTextBounds = container.TextBounds ~= Vector2.zero

		if not isDoneCalculatingTextBounds then
			container:GetPropertyChangedSignal("TextBounds"):Wait()
		end

		local yAxisFactor = container.TextBounds.Y / container.AbsoluteSize.Y
		if not minYFactor or yAxisFactor < minYFactor then
			minYFactor = yAxisFactor
		end
	end

	for _, child in element:GetChildren() do
		if not child:IsA("TextLabel") then
			continue
		end

		local function handleChildChanged()
			child.TextSize = math.floor(minYFactor * child.AbsoluteSize.Y) - 1
		end

		child.TextScaled = false
		child:GetPropertyChangedSignal("AbsoluteSize"):Connect(handleChildChanged)
		handleChildChanged()
	end
end

return M
