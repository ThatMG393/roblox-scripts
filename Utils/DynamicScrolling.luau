local DynamicScrolling = {}
DynamicScrolling.__index = DynamicScrolling

local function GetScaleFromOffset(guiObject: Instance, offsetX: number, offsetY: number): UDim2
	if guiObject and guiObject:IsA("GuiObject") and guiObject.Parent and guiObject.Parent:IsA("GuiObject") then
		local parentSize = guiObject.Parent.AbsoluteSize

		local scaleX = offsetX / parentSize.X
		local scaleY = offsetY / parentSize.Y

		return UDim2.new(scaleX, 0, scaleY, 0)
	else
		error("Invalid GuiObject provided.")
	end
end

function DynamicScrolling.Attach(scrollingFrame: ScrollingFrame, scrollBarThicknessWhenEnabled: number?)
	local self = setmetatable({}, DynamicScrolling)

	self.ScrollingFrame = scrollingFrame
	self.ScrollBarThicknessWhenEnabled = scrollBarThicknessWhenEnabled or 12
	self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

	self.ScrollingFrame.ChildAdded:Connect(function()
		self:UpdateCanvasSize()
	end)

	self.ScrollingFrame.ChildRemoved:Connect(function()
		self:UpdateCanvasSize()
	end)

	self:UpdateCanvasSize()

	return self
end

function DynamicScrolling:UpdateCanvasSize()
	local totalHeight = 0
	local totalWidth = 0

	for _, child in ipairs(self.ScrollingFrame:GetChildren()) do
		if child:IsA("GuiObject") then
			totalHeight = totalHeight + child.Size.Y.Scale
			totalWidth = math.max(totalWidth, child.Size.X.Scale)
		end
	end

	self.ScrollingFrame.CanvasSize = UDim2.new(totalWidth, 0, totalHeight, 0)
	self.ScrollingFrame.ScrollBarThickness = (totalHeight > GetScaleFromOffset(self.ScrollingFrame, 0, self.ScrollingFrame.AbsoluteSize.Y).Y.Scale) and self.ScrollBarThicknessWhenEnabled or 0
end

return DynamicScrolling
