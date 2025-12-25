local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Theme Colors
local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    TopBar = Color3.fromRGB(25, 25, 30),
    Sidebar = Color3.fromRGB(22, 22, 27),
    Element = Color3.fromRGB(28, 28, 33),
    ElementHover = Color3.fromRGB(32, 32, 37),
    Accent = Color3.fromRGB(138, 138, 255),
    AccentDark = Color3.fromRGB(100, 100, 200),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 160),
    Border = Color3.fromRGB(40, 40, 45),
    Success = Color3.fromRGB(100, 220, 120),
    Warning = Color3.fromRGB(255, 200, 80)
}

-- Utility Functions
local function tween(obj, props, duration)
    local info = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Create Main Window
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Clarity UI"
    local windowSize = config.Size or UDim2.new(0, 650, 0, 450)
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ClarityUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = windowSize
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main
    
    -- Shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = Main
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Theme.TopBar
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 8)
    TopBarFix.Position = UDim2.new(0, 0, 1, -8)
    TopBarFix.BackgroundColor3 = Theme.TopBar
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = windowName
    Title.TextColor3 = Theme.Text
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -45, 0, 5)
    CloseBtn.BackgroundColor3 = Theme.Element
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Theme.Text
    CloseBtn.TextSize = 24
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = TopBar
    
    local CloseBtnCorner = Instance.new("UICorner")
    CloseBtnCorner.CornerRadius = UDim.new(0, 6)
    CloseBtnCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        tween(CloseBtn, {BackgroundColor3 = Theme.ElementHover})
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        tween(CloseBtn, {BackgroundColor3 = Theme.Element})
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 2)
    SidebarList.Parent = Sidebar
    
    -- Content Area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -160, 1, -60)
    Content.Position = UDim2.new(0, 155, 0, 55)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.Parent = Main
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Window Object
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    function Window:CreateTab(tabName)
        local Tab = {
            Name = tabName,
            Elements = {}
        }
        
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = "TabBtn_" .. tabName
        TabBtn.Size = UDim2.new(1, 0, 0, 40)
        TabBtn.BackgroundColor3 = Theme.Element
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Theme.TextDark
        TabBtn.TextSize = 14
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.BorderSizePixel = 0
        TabBtn.Parent = Sidebar
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn
        
        -- Tab Content Frame
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tabName
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = Content
        
        local TabContentList = Instance.new("UIListLayout")
        TabContentList.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentList.Padding = UDim.new(0, 8)
        TabContentList.Parent = TabContent
        
        TabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab Button Click
        TabBtn.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Theme.Element
                tab.Button.TextColor3 = Theme.TextDark
            end
            
            -- Show this tab
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Theme.Accent
            TabBtn.TextColor3 = Theme.Text
            Window.CurrentTab = Tab
        end)
        
        TabBtn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                tween(TabBtn, {BackgroundColor3 = Theme.ElementHover})
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                tween(TabBtn, {BackgroundColor3 = Theme.Element})
            end
        end)
        
        Tab.Content = TabContent
        Tab.Button = TabBtn
        
        -- Add Toggle
        function Tab:AddToggle(config)
            config = config or {}
            local name = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Theme.Element
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
            ToggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleBtn.BackgroundColor3 = default and Theme.Accent or Theme.Border
            ToggleBtn.Text = ""
            ToggleBtn.BorderSizePixel = 0
            ToggleBtn.Parent = ToggleFrame
            
            local ToggleBtnCorner = Instance.new("UICorner")
            ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
            ToggleBtnCorner.Parent = ToggleBtn
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            ToggleIndicator.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleIndicator.BackgroundColor3 = Theme.Text
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleBtn
            
            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator
            
            local toggled = default
            
            ToggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                tween(ToggleBtn, {BackgroundColor3 = toggled and Theme.Accent or Theme.Border})
                tween(ToggleIndicator, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                
                callback(toggled)
            end)
            
            return {
                SetValue = function(val)
                    toggled = val
                    tween(ToggleBtn, {BackgroundColor3 = toggled and Theme.Accent or Theme.Border})
                    tween(ToggleIndicator, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                end
            }
        end
        
        -- Add Slider
        function Tab:AddSlider(config)
            config = config or {}
            local name = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local increment = config.Increment or 1
            local callback = config.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Theme.Element
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name
            SliderLabel.TextColor3 = Theme.Text
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -60, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Theme.Accent
            SliderValue.TextSize = 14
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 4)
            SliderBar.Position = UDim2.new(0, 10, 1, -15)
            SliderBar.BackgroundColor3 = Theme.Border
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local dragging = false
            
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = round(min + (max - min) * pos, math.log10(1/increment))
                value = math.clamp(value, min, max)
                
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                SliderValue.Text = tostring(value)
                callback(value)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            return {
                SetValue = function(val)
                    val = math.clamp(val, min, max)
                    local pos = (val - min) / (max - min)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderValue.Text = tostring(val)
                end
            }
        end
        
        -- Add Button
        function Tab:AddButton(config)
            config = config or {}
            local name = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = Theme.Accent
            Button.Text = name
            Button.TextColor3 = Theme.Text
            Button.TextSize = 14
            Button.Font = Enum.Font.GothamBold
            Button.BorderSizePixel = 0
            Button.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                callback()
                tween(Button, {BackgroundColor3 = Theme.AccentDark}, 0.1)
                wait(0.1)
                tween(Button, {BackgroundColor3 = Theme.Accent}, 0.1)
            end)
            
            Button.MouseEnter:Connect(function()
                tween(Button, {BackgroundColor3 = Theme.AccentDark})
            end)
            
            Button.MouseLeave:Connect(function()
                tween(Button, {BackgroundColor3 = Theme.Accent})
            end)
        end
        
        -- Add Label
        function Tab:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.TextDark
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Parent = TabContent
            
            return {
                SetText = function(newText)
                    Label.Text = newText
                end
            }
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabBtn.MouseButton1Click:Fire()
        end
        
        return Tab
    end
    
    return Window
end

return Library
