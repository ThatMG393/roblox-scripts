local MGUI = { }
MGUI.Themes = {
	["Dark"] = {
		Primary = Color3.new(0, 0, 1),
		Secondary = Color3.new(0, 0, .6),
		Tertiary = Color3.new(0, 1, 0),
		Background = Color3.new(0.12, 0.12, 0.12),
		AboveBackground = Color3.new(0.24, 0.24, 0.24),
		TextColor = Color3.new(1, 1, 1)
	}
}

local function ParseOption(opts)
	local pOpts = { }

	if opts.Theme then
		pOpts.Theme = MGUI.Themes.Dark -- [opts.Theme]
	end

	return pOpts
end

function MGUI.CreateWindow(opts)
	local ParsedOption = ParseOption(opts)

	local mGuI = Instance.new("ScreenGui")
	local ContainerFrame = Instance.new("Frame")
	local MainFrame = Instance.new("Frame")
	local Toolbar = Instance.new("Frame")
	local SidePanel = Instance.new("Frame")

	mGuI.Parent = game:GetService("CoreGui")
	mGuI.ResetOnSpawn = false
	mGuI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	mGuI.Name = opts.Name or "mGuI"

	ContainerFrame.Parent = mGuI
	ContainerFrame.Position = UDim2.fromScale(260, 230)
	ContainerFrame.Size = UDim2.fromOffset(opts.SizeX or 1, opts.SizeY or 1)
	ContainerFrame.BackgroundTransparency = 1

	MainFrame.Parent = ContainerFrame
	MainFrame.BackgroundTransparency = 1
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.fromScale(0.353, 0.349)
	MainFrame.Size = UDim2.fromOffset(563, 323)

	Toolbar.Parent = ContainerFrame
	Toolbar.BackgroundColor3 = ParsedOption.Theme.AboveBackground
	Toolbar.Position = UDim2.fromScale(0.015, -0.002)
	Toolbar.Size = UDim2.fromOffset(323, 99)

	SidePanel.Parent = ContainerFrame
	SidePanel.Position = UDim2.fromScale(0.015, -0.002)
	SidePanel.Size = UDim2.fromOffset(157, 324)

	local Tab = { }

	function Tab:NewTab(name, icon)
	end

	return Tab
end

return MGUI
