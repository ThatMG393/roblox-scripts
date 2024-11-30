local UILibrary = {}
UILibrary.__index = UILibrary

local TweenService = game:GetService("TweenService")

local MakeDraggable = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatMG393/roblox-scripts/master/Utils/MakeDraggable.luau"))()

UILibrary.Themes = {
	Dark = {
        Primary = Color3.fromRGB(0, 120, 255),
        Secondary = Color3.fromRGB(0, 95, 200),
        Tertiary = Color3.fromRGB(0, 255, 0),
        Background = Color3.fromRGB(30, 30, 30),  
        AboveBackground = Color3.fromRGB(50, 50, 50),
        TextColor = Color3.fromRGB(255, 255, 255)
    }
}

-- Function to create a UI container with theming support
function UILibrary:CreateUIContainer(theme)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibraryUI"
    ScreenGui.ResetOnSpawn = false

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0.3, 0, 0.5, 0)
    Container.BackgroundTransparency = 1
    Container.Parent = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.Position = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundColor3 = theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = Container

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- Create a table to hold methods
    local UIContainer = {
        gui = ScreenGui,
        mainFrame = MainFrame,
        currentY = 0, -- Track the current Y position for stacking
        theme = theme -- Store the theme for later use
    }

    -- Method to add a button
    function UIContainer:AddButton(name, text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(0.4, 0, 0.08, 0)
        Button.Position = UDim2.new(0.05, 0, self.currentY, 0)
        Button.BackgroundColor3 = self.theme.Primary
        Button.Text = text
        Button.TextColor3 = self.theme.TextColor
        Button.TextSize = 18
        Button.Font = Enum.Font.GothamBold
        Button.Parent = MainFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button

        -- Button hover effects
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = self.theme.Secondary
            }):Play()
        end)

        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = self.theme.Primary
            }):Play()
        end)

        Button.MouseButton1Click:Connect(callback)

        -- Update currentY for next button
        self.currentY = self.currentY + 0.1 -- Adjust based on button height and margin
    end

    -- Method to create an input field
    function UIContainer:AddInput(name, placeholder)
        local InputFrame = Instance.new("Frame")
        InputFrame.Size = UDim2.new(1, 0, 0.15, 0)
        InputFrame.Position = UDim2.new(0, 0, self.currentY, 0)
        InputFrame.BackgroundTransparency = 1
        InputFrame.Parent = MainFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0.3, 0)
        Label.Position = UDim2.new(0, 0, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 16
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.Gotham
        Label.Parent = InputFrame

        local TextBox = Instance.new("TextBox")
        TextBox.Name = name .. "Input"
        TextBox.Size = UDim2.new(0.9, 0, 0.6, 0)
        TextBox.Position = UDim2.new(0.05, 0, 0.35, 0 )
        TextBox.BackgroundColor3 = self.theme.AboveBackground
        TextBox.Text = placeholder
        TextBox.PlaceholderText = placeholder
        TextBox.TextColor3 = self.theme.TextColor
        TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        TextBox.TextSize = 18
        TextBox.Font = Enum.Font.Gotham
        TextBox.Parent = InputFrame

        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 6)
        InputCorner.Parent = TextBox

        -- Update currentY for next input
        self.currentY = self.currentY + 0.2 -- Adjust based on input height and margin
        return TextBox
    end

    -- Parent the ScreenGui to the Player's PlayerGui
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    return UIContainer
end

local con = UILibrary:CreateUIContainer(UILibrary.Themes.Dark)
con:AddButton("test", "test", function() print("clicked") end)

return UILibrary
