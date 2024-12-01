local UILibrary = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local ClickableFrames = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/ClickableFrame.luau"))()
local ColorUtil = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/ColorUtil.luau"))()

UILibrary.Themes = {
    Dark = {
        Primary = Color3.fromRGB(0, 120, 255),
        Secondary = Color3.fromRGB(0, 95, 200),
        Background = Color3.fromRGB(30, 30, 30),
        AboveBackground = Color3.fromRGB(50, 50, 50),
        TextColor = Color3.fromRGB(255, 255, 255),
    }
}

function UILibrary.CreateWindow(WindowTitle, Theme, ResetOnSpawn)
	local UserInterface = Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("UILibrary-"..WindowTitle, false)
    if UserInterface then UserInterface:Destroy() end

    local Window = {}
    local CurrentTheme = Theme or UILibrary.Themes.Dark
    local CurrentTab = nil
    
    local IsCollapsed = false
    local IsCollapsing = false
    
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "UILibrary-" .. WindowTitle
    GUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    GUI.ResetOnSpawn = ResetOnSpawn or true
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 350, 0, 330)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    MainFrame.BackgroundColor3 = CurrentTheme.Background
    MainFrame.Parent = GUI
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
    TitleText.Text = WindowTitle
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
    
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, 0, 0, 30)
    TabButtons.BackgroundColor3 = CurrentTheme.AboveBackground
    TabButtons.Parent = TabContainer
    TabButtons.Visible = false
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

    CollapseButton.MouseButton1Click:Connect(function() 
    	if IsCollapsing then return end

		IsCollapsed = not IsCollapsed
		IsCollapsing = true

		local AnimationInfo = TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

        local TargetHeight = IsCollapsed and 24 or 330
        local TargetTitleHeight = IsCollapsed and 24 or 30
		local TargetWidth = IsCollapsed and 200 or 350
        local TargetTextSize = IsCollapsed and 14 or 16 

        TweenService:Create(MainFrame, AnimationInfo, {
            Size = UDim2.new(0, TargetWidth, 0, TargetHeight)
        }):Play()

        TweenService:Create(TitleBar,  AnimationInfo, {
            Size = UDim2.new(1, 0, 0, TargetTitleHeight)
        }):Play()
        
        TweenService:Create(TitleText, AnimationInfo, {
            TextSize = TargetTextSize
        }):Play()
 
        local tmp = TweenService:Create(CollapseButton, AnimationInfo, {
            Rotation = CollapseButton.Rotation + 180
        })

        tmp:Play()
        tmp.Completed:Connect(function() 
        	if CollapseButton.Rotation >= 360 then CollapseButton.Rotation = 0 end
        	IsCollapsing = false
        end)

        Container.Visible = not IsCollapsed
    end)

    loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/MakeDraggable.luau"))():MakeDraggableFromWithAnim(0.10, TitleBar, MainFrame)

    local TabList = {}
    
    function Window:CreateTab(TabName)
        local Tab = {
        	Disabled = false
        }

        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabName
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.BackgroundColor3 = CurrentTheme.AboveBackground
        TabButton.Text = TabName
        TabButton.TextColor3 = CurrentTheme.TextColor
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabButtons
        TabButton.BorderSizePixel = 0
        
        local Elements = Instance.new("ScrollingFrame")
        Elements.Name = "Elements"
        Elements.Size = UDim2.new(1, -20, 1, -20)
        Elements.Position = UDim2.new(0, 10, 0, 10)
        Elements.BackgroundTransparency = 1
        Elements.ScrollBarThickness = 1
        Elements.ScrollingDirection = Enum.ScrollingDirection.Y
        Elements.ElasticBehavior = Enum.ElasticBehavior.Never
        Elements.Visible = false
        Elements.Parent = TabContent
        Elements.BorderSizePixel = 0
        
        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Parent = Elements
        ListLayout.Padding = UDim.new(0, 5)
        
        if #TabList >= 1 then
            TabButtons.Visible = true
            TabContent.Size = UDim2.new(1, 0, 1, -30)
            TabContent.Position = UDim2.new(0, 0, 0, 30)
        end
        
        function Tab:Select()
            if Tab.Disabled then return end
            if CurrentTab then
                CurrentTab.Button.BackgroundColor3 = CurrentTheme.AboveBackground
                CurrentTab.Elements.Visible = false
            end
            
            TabButton.BackgroundColor3 = CurrentTheme.Background
            TabButton.TextColor3 = CurrentTheme.TextColor
            Elements.Visible = true
            CurrentTab = { Button = TabButton, Elements = Elements }
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

            function Section:CreateLabel(LabelText)
            	local Label = {}
            	Label.UI = Instance.new("Frame")
            	Label.UI.Size = UDim2.new(1, 0, 0.4, 0)
            	Label.UI.AutomaticSize = Enum.AutomaticSize.Y
            	Label.UI.BackgroundColor3 = CurrentTheme.AboveBackground
            	Label.UI.Parent = SectionContent
            	Label.UI.BorderSizePixel = 0

            	local TextLabel = Instance.new("TextLabel")
            	TextLabel.Size = UDim2.new(0.95, 0, 1, 0)
            	TextLabel.Position = UDim2.new(0.05, 0, 0, 0)
            	TextLabel.AutomaticSize = Enum.AutomaticSize.XY
            	TextLabel.BackgroundTransparency = 1
            	TextLabel.Text = LabelText
            	TextLabel.TextSize = 12
            	TextLabel.TextColor3 = CurrentTheme.TextColor
            	TextLabel.Font = Enum.Font.GothamBold
            	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            	TextLabel.Parent = Label.UI
            	TextLabel.BorderSizePixel = 0

            	function Label:UpdateLabel(NewText)
            		TextLabel.Text = NewText
            	end

            	return Label
            end

			function Section:CreateButton(ButtonText, Callback)
                local Button = {
                	Disabled = false
            	}
                
                Button.UI = Instance.new("TextButton")
                Button.UI.Name = "Button"
                Button.UI.Size = UDim2.new(1, 0, 0, 30)
                Button.UI.BackgroundColor3 = CurrentTheme.AboveBackground
                Button.UI.Text = ButtonText
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
                    if not Button.Disabled then
                        TweenService:Create(Button.UI, TweenInfo.new(0.2), {
                            BackgroundColor3 = CurrentTheme.Secondary
                        }):Play()
                    end
                end)
                
                Button.UI.MouseLeave:Connect(function()
                    if not Button.Disabled then
                        TweenService:Create(Button.UI, TweenInfo.new(0.2), {
                            BackgroundColor3 = CurrentTheme.AboveBackground
                        }):Play()
                    end
                end)
                
                Button.UI.MouseButton1Click:Connect(function()
                    if not Button.Disabled then Callback() end
                end)
                
                return Button
            end
            
            function Section:CreateToggle(ToggleText, DefaultState, Callback)
                local Toggle = {
                	Disabled = false,
                	State = DefaultState or false
            	}

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
                Label.Text = ToggleText
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
                        BackgroundColor3 = Toggle.State and CurrentTheme.Primary or CurrentTheme.Background
                    }):Play()
                end

                function Toggle:ToggleState()
					Toggle:SetState(not Toggle.State)
                end

                ToggleButton.MouseButton1Click:Connect(function()
                	if not Toggle.Disabled then Toggle:ToggleState() end
                end)

                ClickableFrames:MouseButton1ClickConnect(Toggle.UI, function()
                	if not Toggle.Disabled then Toggle:ToggleState() end
                end)

                return Toggle
            end
            
            function Section:CreateSlider(SliderText, MinValue, MaxValue, DefaultValue, Callback)
                local Slider = {
                	Disabled = false
                }

                Slider.UI = Instance.new("Frame")
                Slider.UI.Name = "Slider"
                Slider.UI.Size = UDim2.new(1, 0, 0, 45)
                Slider.UI.BackgroundColor3 = CurrentTheme.AboveBackground
                Slider.UI.Parent = SectionContent
                Slider.UI.BorderSizePixel = 0
                
                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.Size = UDim2.new(0.69, 0, 0.5, 0)
                Label.Position = UDim2.new(0.05, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = SliderText
                Label.TextColor3 = CurrentTheme.TextColor
                Label.TextSize = 14
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Slider.UI
                Label.BorderSizePixel = 0
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "SliderBar"
                SliderBar.Size = UDim2.new(1, -26, 0, 12)
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

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Name = "Value"
                ValueLabel.Size = UDim2.new(0, 50, 0.5, 0)
                ValueLabel.Position = UDim2.new(1, -60, 0, 0)
                ValueLabel.BackgroundTransparency = 1
				ValueLabel.Text = tostring(DefaultValue)
                ValueLabel.TextColor3 = CurrentTheme.TextColor
                ValueLabel.TextSize = 14
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.Parent = Slider.UI
                ValueLabel.BorderSizePixel = 0
                
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

					Fill.Size = UDim2.new(SliderValue / 100, 0, 1, 0)
                    ValueLabel.Text = tostring(SliderValue)

                    Callback(SliderValue)
                end
                            
                SliderBar.InputBegan:Connect(function(Input)
                	if self.Disabled then return end
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch and not Slider.Disabled then
                        local Connection
                        Connection = RunService.RenderStepped:Connect(function()
                            Slider:SetPercentage(
                            	MinValue + ((MaxValue - MinValue) * ((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X))
                            )
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
            return Section
        end
        table.insert(TabList, Tab)

        if #TabList == 1 then Tab:Select() end
        return Tab
    end
    
    function Window:CreateSection(SectionName)
        if #TabList == 0 then
            local MainTab = Window:CreateTab("Main")
            return MainTab:CreateSection(SectionName)
        else
            return CurrentTab and TabList[1]:CreateSection(SectionName)
        end
    end
    
    return Window
end

function UILibrary:ShowTestUI()
    local MainWindow = UILibrary.CreateWindow("MGUI Test UI", UILibrary.Themes.Dark, false)
    local MainSection = MainWindow:CreateSection("Test section")
    MainSection:CreateToggle("hello", true, function(State) print("damn") end)
    
    local ping = MainSection:CreateLabel("Ping: "..math.floor(Players.LocalPlayer:GetNetworkPing() * 2000))
    RunService.RenderStepped:Connect(function(a0: number)
    	ping:UpdateLabel("Ping: "..math.floor(Players.LocalPlayer:GetNetworkPing() * 2000))
    end)

    local TestTab = MainWindow:CreateTab("More tests tab")

    local TestSection = TestTab:CreateSection("MOARRRRR")
    TestSection:CreateSlider("whaaa", 0, 100, 69, function(Value) print(Value) end)
	TestSection:CreateSlider("whaaa (dis)", 0, 100, 69, function(Value) print(Value) end):SetDisabled(true)
    TestSection:CreateToggle("hello", true, function(State) print("damn") end)
    TestSection:CreateToggle("hello (dis)", true, function(State) print("damn") end):SetDisabled(true)
    TestSection:CreateButton("nuh uh", function() end)
    TestSection:CreateButton("nuh uh (dis)", function() end)
end

if _G.UI_Debug then UILibrary:ShowTestUI() end

return UILibrary
