local UILibrary = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local DynamicScrolling = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/DynamicScrolling.luau"))()
local ColorUtil = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/ColorUtil.luau"))()
local NotifLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/NotifLib.luau"))()

UILibrary.Themes = {
	Dark = {
		Primary = Color3.fromRGB(0, 120, 255),
		Secondary = Color3.fromRGB(0, 95, 200),
		Background = Color3.fromRGB(30, 30, 30),
		AboveBackground = Color3.fromRGB(50, 50, 50),
		TextColor = Color3.fromRGB(255, 255, 255),
		PlaceholderColor = Color3.fromRGB(50, 50, 50),
	},
}

UILibrary.DefaultWindowOptions = {
	WindowTitle = "MGUI",
	WindowTheme = UILibrary.Themes.Dark,
	WindowSize = { X = 500, Y = 330 },
	CollapsedWindowSize = { X = 24, Y = 200 },
	ResetOnSpawn = true,
	CollapseOnStart = false,
}

local function CreatePadding(Padding, Parent)
	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingTop = UDim.new(0, Padding)
	UIPadding.PaddingBottom = UDim.new(0, Padding)
	UIPadding.PaddingLeft = UDim.new(0, Padding)
	UIPadding.PaddingRight = UDim.new(0, Padding)
	UIPadding.Parent = Parent

	return UIPadding
end

local function CreatePaddingScaled(Padding, Parent)
	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingTop = UDim.new(Padding, 0)
	UIPadding.PaddingBottom = UDim.new(Padding, 0)
	UIPadding.PaddingLeft = UDim.new(Padding, 0)
	UIPadding.PaddingRight = UDim.new(Padding, 0)
	UIPadding.Parent = Parent

	return UIPadding
end

function UILibrary.CreateWindow(Options)
	Options = Options or UILibrary.DefaultWindowOptions

	local UserInterface = Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("UILibrary-" .. Options.WindowTitle, false)
	if UserInterface then
		UserInterface:Destroy()
	end

	local TabList = {}

	local CurrentTheme = Options.Theme or UILibrary.Themes.Dark

	local IsCollapsed = false
	local IsCollapsing = false

	local Window = {
		Options = Options,
		CurrentTheme = CurrentTheme,
		CurrentTab = nil,
	}

	local GUI = Instance.new("ScreenGui")
	GUI.Name = "UILibrary-" .. Options.WindowTitle
	GUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	GUI.ResetOnSpawn = Options.ResetOnSpawn

	local NotificationInstance = NotifLib.Create(GUI)

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "Main"
	MainFrame.Size = UDim2.new(0, Options.WindowSize.X, 0, Options.WindowSize.Y)
	MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
	MainFrame.BackgroundColor3 = CurrentTheme.Background
	MainFrame.Parent = GUI
	MainFrame.Visible = false
	MainFrame.BorderSizePixel = 0

	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, 30)
	TitleBar.BackgroundColor3 = CurrentTheme.Primary
	TitleBar.Parent = MainFrame
	TitleBar.BorderSizePixel = 0

	local TitleText = Instance.new("TextLabel")
	TitleText.Name = "Title"
	TitleText.Size = UDim2.new(1, 0, 1, 0)
	TitleText.BackgroundTransparency = 1
	TitleText.Text = Options.WindowTitle
	TitleText.TextColor3 = CurrentTheme.TextColor
	TitleText.TextSize = 16
	TitleText.Font = Enum.Font.GothamMedium
	TitleText.Parent = TitleBar
	TitleText.BorderSizePixel = 0

	local CollapseButton = Instance.new("TextButton")
	CollapseButton.Name = "Collapse"
	CollapseButton.Size = UDim2.new(0.1, 0, 1, 0)
	CollapseButton.Text = "▲"
	CollapseButton.TextColor3 = CurrentTheme.TextColor
	CollapseButton.BackgroundTransparency = 1
	CollapseButton.Font = Enum.Font.GothamBold
	CollapseButton.TextSize = 20
	CollapseButton.Parent = TitleBar
	CollapseButton.BorderSizePixel = 0

	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.Size = UDim2.new(1, 0, 1, -30)
	Container.Position = UDim2.new(0, 0, 0, 30)
	Container.BackgroundColor3 = CurrentTheme.Background
	Container.Parent = MainFrame
	Container.BorderSizePixel = 0

	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.Size = UDim2.new(1, 0, 1, 0)
	TabContainer.BackgroundTransparency = 1
	TabContainer.Parent = Container
	TabContainer.BorderSizePixel = 0

	local TabButtons = Instance.new("ScrollingFrame")
	TabButtons.Name = "TabButtons"
	TabButtons.Size = UDim2.new(1, 0, 0, 30)
	TabButtons.BackgroundColor3 = CurrentTheme.AboveBackground
	TabButtons.ScrollBarThickness = 0
	TabButtons.ScrollingDirection = Enum.ScrollingDirection.X
	TabButtons.ElasticBehavior = Enum.ElasticBehavior.Never
	TabButtons.AutomaticCanvasSize = Enum.AutomaticSize.X
	TabButtons.ScrollingEnabled = false
	TabButtons.Visible = false
	TabButtons.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	TabButtons.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	TabButtons.BottomImage = ""
	TabButtons.ScrollBarImageTransparency = 0.5

	TabButtons.Parent = TabContainer
	TabButtons.BorderSizePixel = 0

	local TabButtonsList = Instance.new("UIListLayout")
	TabButtonsList.Parent = TabButtons
	TabButtonsList.FillDirection = Enum.FillDirection.Horizontal
	TabButtonsList.Padding = UDim.new(0, 0)

	local TabContent = Instance.new("Frame")
	TabContent.Name = "TabContent"
	TabContent.Size = UDim2.new(1, 0, 1, 0)
	TabContent.BackgroundTransparency = 1
	TabContent.Parent = TabContainer
	TabContent.BorderSizePixel = 0

	local MIN_TAB_WIDTH = 120
	local function UpdateTabButtonSizes()
		local TabCount = #TabList

		if TabCount > 1 then
			TabButtons.Visible = true
			TabContent.Size = UDim2.new(1, 0, 1, -30)
			TabContent.Position = UDim2.new(0, 0, 0, 30)
		elseif TabCount <= 1 then
			TabButtons.Visible = false
			TabContent.Size = UDim2.new(1, 0, 1, 0)
			TabContent.Position = UDim2.new(0, 0, 0, 0)
			return
		end

		local AnimationOpts = TweenInfo.new(0.40, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		local TotalWidth = TabButtons.AbsoluteSize.X
		local CalculatedButtonWidth = math.max(MIN_TAB_WIDTH, TotalWidth / TabCount)
		local TotalRequiredWidth = CalculatedButtonWidth * TabCount

		TabButtons.ScrollingEnabled = TotalRequiredWidth > TotalWidth
		TabButtons.ScrollBarThickness = TabButtons.ScrollingEnabled and 1 or 0

		if not (TotalRequiredWidth > TotalWidth) then
			for _, tab in ipairs(TabList) do
				TweenService:Create(tab.Button, AnimationOpts, { Size = UDim2.new(0, CalculatedButtonWidth, 0, 30) }):Play()
			end
		end
	end

	function Window:Collapse()
		if IsCollapsing then
			return
		end

		IsCollapsed = not IsCollapsed
		Container.Visible = not IsCollapsed

		IsCollapsing = true

		local AnimationInfo = TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		local TargetHeight = IsCollapsed and Options.CollapsedWindowSize.X or Options.WindowSize.Y
		local TargetWidth = IsCollapsed and Options.CollapsedWindowSize.Y or Options.WindowSize.X
		local TargetTitleHeight = IsCollapsed and 24 or 30
		local TargetTextSize = IsCollapsed and 14 or 16

		TweenService:Create(MainFrame, AnimationInfo, { Size = UDim2.new(0, TargetWidth, 0, TargetHeight) }):Play()
		TweenService:Create(TitleBar, AnimationInfo, { Size = UDim2.new(1, 0, 0, TargetTitleHeight) }):Play()
		TweenService:Create(TitleText, AnimationInfo, { TextSize = TargetTextSize }):Play()

		local CollapseAnim = TweenService:Create(CollapseButton, AnimationInfo, { Rotation = CollapseButton.Rotation + 180 })

		CollapseAnim:Play()
		CollapseAnim.Completed:Connect(function()
			CollapseButton.Rotation = CollapseButton.Rotation >= 360 and 0 or CollapseButton.Rotation
			IsCollapsing = false
		end)
	end

	if Options.CollapseOnStart then
		Window:Collapse()
	end

	function Window:CreateTab(TabName)
		local Tab = {
			Disabled = false,
		}

		local TabButton = Instance.new("TextButton")
		TabButton.Name = TabName
		TabButton.Size = UDim2.new(0, 120, 0, 30)
		TabButton.BackgroundColor3 = CurrentTheme.AboveBackground
		TabButton.Text = TabName
		TabButton.TextColor3 = CurrentTheme.TextColor
		TabButton.TextSize = 14
		TabButton.Font = Enum.Font.Gotham
		TabButton.Parent = TabButtons
		TabButton.BorderSizePixel = 0

		Tab.Button = TabButton

		local Elements = Instance.new("ScrollingFrame")
		Elements.Name = "Elements-" .. TabName
		Elements.Size = UDim2.new(1, -20, 1, -20)
		Elements.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Elements.Position = UDim2.new(0, 10, 0, 10)
		Elements.BackgroundTransparency = 1
		Elements.ScrollingDirection = Enum.ScrollingDirection.Y
		Elements.ScrollBarThickness = 1
		Elements.ElasticBehavior = Enum.ElasticBehavior.Never
		Elements.Visible = false
		Elements.Parent = TabContent
		Elements.BorderSizePixel = 0	

		local ListLayout = Instance.new("UIListLayout")
		ListLayout.Parent = Elements
		ListLayout.Padding = UDim.new(0, 5)

		function Tab:Select()
			if Tab.Disabled then
				return
			end
			if Window.CurrentTab then
				Window.CurrentTab.Button.BackgroundColor3 = CurrentTheme.AboveBackground
				Window.CurrentTab.Elements.Visible = false
			end

			TabButton.BackgroundColor3 = CurrentTheme.Background
			TabButton.TextColor3 = CurrentTheme.TextColor
			Elements.Visible = true
			Window.CurrentTab = { Button = TabButton, Elements = Elements }
		end

		TabButton.MouseButton1Click:Connect(function()
			Tab:Select()
		end)

		function Tab:SetDisabled(State)
			self.Disabled = State
			TabButton.BackgroundColor3 = CurrentTheme.DisabledBackground
			TabButton.TextColor3 = CurrentTheme.DisabledText
		end

		function Tab:CreateSection(SectionName)
			local Section = {}

			local SectionFrame = Instance.new("Frame")
			SectionFrame.Name = "Section"
			SectionFrame.Size = UDim2.new(1, 0, 0, 30)
			SectionFrame.BackgroundTransparency = 1
			SectionFrame.Parent = Elements
			SectionFrame.BorderSizePixel = 0

			local SectionTitle = Instance.new("TextLabel")
			SectionTitle.Name = "Title"
			SectionTitle.Size = UDim2.new(1, 0, 0, 0)
			SectionTitle.AutomaticSize = Enum.AutomaticSize.Y
			SectionTitle.Position = UDim2.new(0, 0, 0.003, 0)
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Text = SectionName
			SectionTitle.TextColor3 = CurrentTheme.TextColor
			SectionTitle.TextSize = 16
			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Center
			SectionTitle.Parent = SectionFrame
			SectionTitle.BorderSizePixel = 0

			local SectionContent = Instance.new("Frame")
			SectionContent.Name = "Content"
			SectionContent.Size = UDim2.new(1, -20, 0, 0)
			SectionContent.Position = UDim2.new(0, 10, 0, 24)
			SectionContent.BackgroundTransparency = 1
			SectionContent.AutomaticSize = Enum.AutomaticSize.Y
			SectionContent.Parent = SectionFrame
			SectionContent.BorderSizePixel = 0

			local SectionList = Instance.new("UIListLayout")
			SectionList.Parent = SectionContent
			SectionList.Padding = UDim.new(0, 8)
			SectionList.SortOrder = Enum.SortOrder.LayoutOrder

			SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y + 40)
			end)

			function Section:CreateLabel(LabelText, LabelTextSize)
				local Label = {}
				Label.UI = Instance.new("Frame")
				Label.UI.Size = UDim2.new(1, 0, 0, 0)
				Label.UI.AutomaticSize = Enum.AutomaticSize.Y
				Label.UI.BackgroundColor3 = CurrentTheme.AboveBackground
				Label.UI.Parent = SectionContent
				Label.UI.BorderSizePixel = 0

				CreatePaddingScaled(0.1, Label.UI)

				local TextLabel = Instance.new("TextLabel")
				TextLabel.Size = UDim2.new(1, 0, 1, 0)
				TextLabel.Position = UDim2.new(0, 0, 0, 0)
				TextLabel.BackgroundTransparency = 1
				TextLabel.Text = tostring(LabelText)
				TextLabel.TextSize = tonumber(LabelTextSize) or 12
				TextLabel.TextWrapped = true
				TextLabel.TextColor3 = CurrentTheme.TextColor
				TextLabel.Font = Enum.Font.GothamBold
				TextLabel.TextXAlignment = Enum.TextXAlignment.Center
				TextLabel.Parent = Label.UI
				TextLabel.BorderSizePixel = 0

				function Label:UpdateLabel(NewText)
					TextLabel.Text = NewText
				end

				return Label
			end

			function Section:CreateButton(ButtonText, Callback)
				local Button = {
					Disabled = false,
				}

				Button.UI = Instance.new("TextButton")
				Button.UI.Name = "Button"
				Button.UI.Size = UDim2.new(1, 0, 0, 30)
				Button.UI.BackgroundColor3 = CurrentTheme.AboveBackground
				Button.UI.Text = tostring(ButtonText)
				Button.UI.TextColor3 = CurrentTheme.TextColor
				Button.UI.TextSize = 14
				Button.UI.Font = Enum.Font.Gotham
				Button.UI.Parent = SectionContent
				Button.UI.BorderSizePixel = 0

				function Button:SetDisabled(State)
					self.Disabled = State
					self.UI.BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.Background) or CurrentTheme.AboveBackground
					self.UI.TextColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.TextColor) or CurrentTheme.TextColor
				end

				Button.UI.MouseEnter:Connect(function()
					TweenService:Create(Button.UI, TweenInfo.new(0.2), {
						BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.Secondary) or CurrentTheme.Secondary,
					}):Play()
				end)

				Button.UI.MouseLeave:Connect(function()
					TweenService:Create(Button.UI, TweenInfo.new(0.2), {
						BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.AboveBackground) or CurrentTheme.AboveBackground,
					}):Play()
				end)

				Button.UI.MouseButton1Click:Connect(function()
					if not Button.Disabled then
						Callback(Button)
					end
				end)

				return Button
			end

			function Section:CreateToggle(ToggleText, DefaultState, Callback)
				local Toggle = {
					Disabled = false,
					State = DefaultState or false,
				}

				Callback = Callback or function (s) end

				Toggle.UI = Instance.new("Frame")
				Toggle.UI.Name = "Toggle"
				Toggle.UI.Size = UDim2.new(1, 0, 0, 30)
				Toggle.UI.BackgroundColor3 = CurrentTheme.AboveBackground
				Toggle.UI.Parent = SectionContent
				Toggle.UI.BorderSizePixel = 0

				local Label = Instance.new("TextLabel")
				Label.Name = "Label"
				Label.Size = UDim2.new(1, -80, 1, 0)
				Label.Position = UDim2.new(0.05, 0, 0, 0)
				Label.BackgroundTransparency = 1
				Label.Text = tostring(ToggleText)
				Label.TextColor3 = CurrentTheme.TextColor
				Label.TextSize = 14
				Label.Font = Enum.Font.Gotham
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Toggle.UI
				Label.BorderSizePixel = 0

				local ToggleButton = Instance.new("TextButton")
				ToggleButton.Name = "Button"
				ToggleButton.Size = UDim2.new(0, 20, 0, 20)
				ToggleButton.Position = UDim2.new(1, -30, 0.5, -10)
				ToggleButton.BackgroundColor3 = Toggle.State and CurrentTheme.Primary or CurrentTheme.Background
				ToggleButton.Text = ""
				ToggleButton.Parent = Toggle.UI
				ToggleButton.BorderSizePixel = 0

				function Toggle:SetDisabled(State)
					self.Disabled = State
					self.UI.BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.AboveBackground) or CurrentTheme.AboveBackground
					Label.TextColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.TextColor) or CurrentTheme.TextColor
					ToggleButton.BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(Toggle.State and CurrentTheme.Primary or CurrentTheme.Background) or (Toggle.State and CurrentTheme.Primary or CurrentTheme.Background)
				end

				function Toggle:SetState(State)
					self.State = State
					Callback(State)

					TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
						BackgroundColor3 = Toggle.State and CurrentTheme.Primary or CurrentTheme.Background,
					}):Play()
				end

				function Toggle:ToggleState()
					Toggle:SetState(not Toggle.State)
				end

				function Toggle:GetState()
					return self.State
				end

				ToggleButton.MouseButton1Click:Connect(function()
					if not Toggle.Disabled then
						Toggle:ToggleState()
					end
				end)

				Toggle.UI.MouseEnter:Connect(function()
					TweenService:Create(Toggle.UI, TweenInfo.new(0.2), {
						BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.Secondary) or CurrentTheme.Secondary,
					}):Play()
				end)

				Toggle.UI.MouseLeave:Connect(function()
					TweenService:Create(Toggle.UI, TweenInfo.new(0.2), {
						BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.AboveBackground) or CurrentTheme.AboveBackground,
					}):Play()
				end)

				return Toggle
			end

			function Section:CreateSlider(SliderText, MinValue, MaxValue, DefaultValue, Callback)
				local Slider = {
					Disabled = false,
				}

				Slider.UI = Instance.new("Frame")
				Slider.UI.Name = "SliderUI"
				Slider.UI.Size = UDim2.new(1, 0, 0, 45)
				Slider.UI.BackgroundColor3 = CurrentTheme.AboveBackground
				Slider.UI.Parent = SectionContent
				Slider.UI.BorderSizePixel = 0

				local Label = Instance.new("TextLabel")
				Label.Name = "Label"
				Label.Size = UDim2.new(0.69, 0, 0.5, 0)
				Label.Position = UDim2.new(0.07, 0, 0.05, 0)
				Label.BackgroundTransparency = 1
				Label.Text = tostring(SliderText)
				Label.TextColor3 = CurrentTheme.TextColor
				Label.TextSize = 14
				Label.Font = Enum.Font.GothamBold
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Slider.UI
				Label.BorderSizePixel = 0

				local ValueLabel = Instance.new("TextLabel")
				ValueLabel.Name = "Value"
				ValueLabel.Size = UDim2.new(0, 50, 0.5, 0)
				ValueLabel.Position = UDim2.new(0.85, 0, 0.05, 0)
				ValueLabel.BackgroundTransparency = 1
				ValueLabel.Text = tostring(DefaultValue)
				ValueLabel.TextColor3 = CurrentTheme.TextColor
				ValueLabel.TextSize = 14
				ValueLabel.Font = Enum.Font.GothamBold
				ValueLabel.Parent = Slider.UI
				ValueLabel.BorderSizePixel = 0

				local SliderBar = Instance.new("Frame")
				SliderBar.Name = "SliderBar"
				SliderBar.Size = UDim2.new(0.90, 0, 0, 12)
				SliderBar.Position = UDim2.new(0.05, 0, 0.55, 0)
				SliderBar.BackgroundColor3 = CurrentTheme.Secondary
				SliderBar.Parent = Slider.UI
				SliderBar.BorderSizePixel = 0

				local Fill = Instance.new("Frame")
				Fill.Name = "Fill"
				Fill.Size = UDim2.new((DefaultValue - MinValue) / (MaxValue - MinValue), 0, 1, 0)
				Fill.BackgroundColor3 = CurrentTheme.Primary
				Fill.Parent = SliderBar
				Fill.BorderSizePixel = 0

				function Slider:SetDisabled(State)
					self.Disabled = State
					self.UI.BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.AboveBackground) or CurrentTheme.AboveBackground
					Label.TextColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.TextColor) or CurrentTheme.TextColor
					ValueLabel.TextColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.TextColor) or CurrentTheme.TextColor
					SliderBar.BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.Secondary) or CurrentTheme.Secondary
					Fill.BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.Primary) or CurrentTheme.Primary
				end

				function Slider:SetPercentage(Percentage: number)
					local SliderValue = math.floor(math.clamp(Percentage, MinValue, MaxValue))

					TweenService:Create(Fill, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Size = UDim2.new(SliderValue / 100, 0, 1, 0) }):Play()
					ValueLabel.Text = tostring(SliderValue)

					Callback(SliderValue)
				end

				SliderBar.InputBegan:Connect(function(Input)
					if self.Disabled then
						return
					end
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch and not Slider.Disabled then
						local Connection
						Connection = RunService.RenderStepped:Connect(function()
							Slider:SetPercentage(MinValue + ((MaxValue - MinValue) * ((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X)))
						end)

						Input.Changed:Connect(function()
							if Input.UserInputState == Enum.UserInputState.End then
								Connection:Disconnect()
							end
						end)
					end
				end)
				return Slider
			end

			function Section:CreateInputField(InputLabel, InputPlaceholder, DefaultValue)
				local InputField = {
					Disabled = false,
				}

				InputField.UI = Instance.new("Frame")
				InputField.UI.Name = "InputField"
				InputField.UI.Size = UDim2.new(1, 0, 0, 70)
				InputField.UI.BackgroundColor3 = CurrentTheme.AboveBackground
				InputField.UI.Parent = SectionContent
				InputField.UI.BorderSizePixel = 0

				CreatePaddingScaled(0.05, InputField.UI).PaddingTop = UDim.new(0.1, 0)

				local TextLabel = Instance.new("TextLabel")
				TextLabel.Position = UDim2.new(0.05, 0, 0, 0)
				TextLabel.AutomaticSize = Enum.AutomaticSize.XY
				TextLabel.BackgroundTransparency = 1
				TextLabel.Text = tostring(InputLabel)
				TextLabel.TextColor3 = CurrentTheme.TextColor
				TextLabel.TextSize = 14
				TextLabel.Font = Enum.Font.GothamBold
				TextLabel.Parent = InputField.UI
				TextLabel.BorderSizePixel = 0

				local TextBox = Instance.new("TextBox")
				TextBox.Position = UDim2.new(0, 0, 0.4, 0)
				TextBox.Size = UDim2.new(1, 0, 0.5, 0)
				TextBox.PlaceholderText = InputPlaceholder and tostring(InputPlaceholder) or ""
				TextBox.Text = DefaultValue and tostring(DefaultValue) or ""
				TextBox.TextColor3 = CurrentTheme.TextColor
				TextBox.PlaceholderColor3 = CurrentTheme.PlaceholderColor
				TextBox.BackgroundColor3 = CurrentTheme.Background
				TextBox.Parent = InputField.UI
				TextBox.BorderSizePixel = 0

				function InputField:SetDisabled(State)
					self.Disabled = State
					TextBox.Active = not State
					self.UI.BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.AboveBackground) or CurrentTheme.AboveBackground
					TextLabel.TextColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.TextColor) or CurrentTheme.TextColor
					TextBox.TextColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.TextColor) or CurrentTheme.TextColor
					TextBox.PlaceholderColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.PlaceholderColor) or CurrentTheme.PlaceholderColor
					TextBox.BackgroundColor3 = self.Disabled and ColorUtil.GetDisabledColor(CurrentTheme.Background) or CurrentTheme.Background
				end

				function InputField:SetText(NewText)
					TextBox.Text = tostring(NewText)
				end

				function InputField:GetText()
					return TextBox.Text
				end

				return InputField
			end
			return Section
		end
		table.insert(TabList, Tab)

		if #TabList == 1 then
			Tab:Select()
		end

		UpdateTabButtonSizes()
		MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if not IsCollapsing then
				UpdateTabButtonSizes()
			end
		end)
		return Tab
	end

	function Window:RemoveTab(Index: number)
		if #TabList == 1 or Index <= 0 or Index > #TabList then
			UpdateTabButtonSizes()
			return
		end

		local TabAtIndex = table.remove(TabList, Index)
		if TabAtIndex then
			local TabButton = TabAtIndex.Button
			TabContent["Elements-" .. TabButton.Name]:Destroy()
			TabButton:Destroy()
			UpdateTabButtonSizes()
		end
	end

	function Window:CreateSection(SectionName)
		if #TabList == 0 then
			local MainTab = Window:CreateTab("Main")
			return MainTab:CreateSection(SectionName)
		else
			return Window.CurrentTab and TabList[1]:CreateSection(SectionName)
		end
	end

	function Window:GetTabCount()
		return #TabList
	end

	function Window:Notify(Title: string, Message: string?)
		local NotificationFrame = Instance.new("Frame")
		NotificationFrame.Size = UDim2.fromScale(0.3, 0.25)
		NotificationFrame.BackgroundColor3 = CurrentTheme.Background
		NotificationFrame.BorderSizePixel = 0

		local NotificationFramePadding = CreatePaddingScaled(0.05, NotificationFrame)
		NotificationFramePadding.PaddingTop = UDim.new(0.1, 0)
		NotificationFramePadding.PaddingBottom = UDim.new(0.1, 0)

		local TitleLabel = Instance.new("TextLabel")
		TitleLabel.Name = "TitleLabel"
		TitleLabel.Size = UDim2.fromScale(0.9, 0.15)
		TitleLabel.Position = UDim2.fromScale(0, 0)
		TitleLabel.Font = Enum.Font.GothamBold
		TitleLabel.Text = Title
		TitleLabel.TextColor3 = CurrentTheme.TextColor
		TitleLabel.TextSize = Message and 16 or 18
		TitleLabel.TextWrapped = true
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Parent = NotificationFrame

		local CloseButton = Instance.new("TextButton")
		CloseButton.Name = "CloseButton"
		CloseButton.Size = UDim2.fromScale(0.1, 0.15)
		CloseButton.Position = UDim2.fromScale(0.9, 0)
		CloseButton.Text = "×"
		CloseButton.TextSize = 20
		CloseButton.TextColor3 = CurrentTheme.TextColor
		CloseButton.BackgroundTransparency = 1
		CloseButton.Parent = NotificationFrame

		if Message then
			local MessageScroll = Instance.new("ScrollingFrame")
			MessageScroll.Size = UDim2.fromScale(0.9, 0.75)
			MessageScroll.Position = UDim2.fromScale(0, 0.25)
			MessageScroll.ElasticBehavior = Enum.ElasticBehavior.Never
			MessageScroll.BackgroundTransparency = 1
			MessageScroll.Parent = NotificationFrame
			MessageScroll.BorderSizePixel = 0

			DynamicScrolling.Attach(MessageScroll)

			local MessageLabel = Instance.new("TextLabel")
			MessageLabel.Name = "MessageLabel"
			MessageLabel.Size = UDim2.fromScale(1, 0)
			MessageLabel.AutomaticSize = Enum.AutomaticSize.Y
			MessageLabel.Position = UDim2.fromScale(0, 0)
			MessageLabel.Font = Enum.Font.Gotham
			MessageLabel.Text = tostring(Message)
			MessageLabel.TextColor3 = CurrentTheme.TextColor
			MessageLabel.TextSize = 14
			MessageLabel.TextWrapped = true
			MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
			MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
			MessageLabel.BackgroundTransparency = 1
			MessageLabel.Parent = MessageScroll
		else
			TitleLabel.Size = UDim2.fromScale(0.9, 1)
			TitleLabel.Position = UDim2.fromScale(0.05, 0)
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
			TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
		end

		local NotifOpts = NotifLib.DefaultConfig
		NotifOpts.UIReferences = {
			Notification = NotificationFrame,
			Close = CloseButton,
		}

		return NotificationInstance:ShowNotification(NotifOpts)
	end

	CollapseButton.MouseButton1Click:Connect(Window.Collapse)

	loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/MakeDraggable.luau"))():MakeDraggableFromWithAnim(0.10, TitleBar, MainFrame)

	MainFrame.Visible = true

	return Window
end

function UILibrary:ShowTestUI()
	local Opts = UILibrary.DefaultWindowOptions
	Opts.WindowTitle = "MGUI Test UI"

	local MainWindow = UILibrary.CreateWindow(Opts)
	local MainSection = MainWindow:CreateSection("Test section")
	MainSection:CreateToggle("hello", true, function(State)
		print("damn")
	end)

	local ping = MainSection:CreateLabel("Ping: " .. math.floor(Players.LocalPlayer:GetNetworkPing() * 2000))
	RunService.RenderStepped:Connect(function(a0: number)
		ping:UpdateLabel("Ping: " .. math.floor(Players.LocalPlayer:GetNetworkPing() * 2000))
	end)

	MainSection:CreateButton("New tab-uh", function()
		MainWindow:CreateTab("Newtab-uh #" .. MainWindow:GetTabCount() + 1)
	end)

	MainSection:CreateButton("Remove tab-uh", function()
		if MainWindow:GetTabCount() <= 2 then
			return
		end
		MainWindow:RemoveTab(MainWindow:GetTabCount())
	end)

	MainSection:CreateButton("Show notif", function()
		MainWindow:Notify("Hello", "World")
	end)

	MainSection:CreateButton("Show notif (title)", function()
		MainWindow:Notify("Hello")
	end)

	local TestTab = MainWindow:CreateTab("More tests tab")

	local TestSection = TestTab:CreateSection("Enabled Elements")
	local TestSection2 = TestTab:CreateSection("Disabled Elements")
	TestSection:CreateSlider("whaaa", 0, 100, 69, function(Value)
		print(Value)
	end)
	TestSection2:CreateSlider("whaaa (dis)", 0, 100, 69, function(Value)
		print(Value)
	end):SetDisabled(true)
	TestSection:CreateToggle("hello", true, function(State)
		print("damn")
	end)
	TestSection2:CreateToggle("hello (dis)", true, function(State)
		print("damn")
	end):SetDisabled(true)
	TestSection:CreateButton("nuh uh", function() end)
	TestSection2:CreateButton("nuh uh (dis)", function() end):SetDisabled(true)
	TestSection:CreateInputField("idk bro", "hihi", 9)
	TestSection2:CreateInputField("idk bro (dis)", "hihi", 9):SetDisabled(true)
end

if _G.UI_Debug then
	UILibrary:ShowTestUI()
end

return UILibrary
