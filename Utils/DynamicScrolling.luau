local DynamicScrolling = {}
DynamicScrolling.__index = DynamicScrolling

function DynamicScrolling.Attach(ScrollingFrame: ScrollingFrame, ScrollBarThicknessWhenEnabled: number?)
	local self = setmetatable({}, DynamicScrolling)

	self.ScrollingFrame = ScrollingFrame
	self.ScrollBarThicknessWhenEnabled = ScrollBarThicknessWhenEnabled or 12
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
			totalHeight = totalHeight + child.Size.Y.Offset
			totalWidth = math.max(totalWidth, child.Size.X.Offset)
		end
	end

	self.ScrollingFrame.CanvasSize = UDim2.new(0, totalWidth, 0, totalHeight)
	self.ScrollingFrame.ScrollBarThickness = (totalHeight > self.ScrollingFrame.AbsoluteSize.Y) and self.ScrollBarThicknessWhenEnabled or 0
end

return DynamicScrolling
