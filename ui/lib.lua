local Library = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create ScreenGui
local function CreateGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "femboyhookUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")
    return ScreenGui
end

-- Utility Functions
local function CreateElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Main Window Creation
function Library:CreateWindow(title)
    local gui = CreateGui()
    
    -- Main Frame
    local MainFrame = CreateElement("Frame", {
        Name = "MainFrame",
        Parent = gui,
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -325, 0.5, -250),
        Size = UDim2.new(0, 650, 0, 500),
        Active = true,
        Draggable = true
    })
    
    CreateElement("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Title Bar
    local TitleBar = CreateElement("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    CreateElement("UICorner", {
        Parent = TitleBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Title Text
    local TitleLabel = CreateElement("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title or "femboyhook",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true
    })
    
    -- Icons Container
    local IconsFrame = CreateElement("Frame", {
        Name = "Icons",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -180, 0, 0),
        Size = UDim2.new(0, 180, 1, 0)
    })
    
    CreateElement("UIListLayout", {
        Parent = IconsFrame,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Create icon buttons
    for i = 1, 5 do
        local IconButton = CreateElement("TextButton", {
            Parent = IconsFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 0, 20),
            Text = "⚙",
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 14
        })
        
        IconButton.MouseEnter:Connect(function()
            Tween(IconButton, {TextColor3 = Color3.fromRGB(255, 255, 255)})
        end)
        
        IconButton.MouseLeave:Connect(function()
            Tween(IconButton, {TextColor3 = Color3.fromRGB(150, 150, 150)})
        end)
    end
    
    -- Content Frame
    local ContentFrame = CreateElement("Frame", {
        Name = "Content",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40)
    })
    
    local Window = {}
    Window.Tabs = {}
    
    function Window:CreateTab(name)
        local Tab = {}
        local TabFrame = CreateElement("Frame", {
            Name = name,
            Parent = ContentFrame,
            BackgroundColor3 = Color3.fromRGB(15, 15, 15),
            BorderSizePixel = 0,
            Size = UDim2.new(0.5, -1, 1, 0),
            Position = UDim2.new(#Window.Tabs * 0.5, 0, 0, 0)
        })
        
        -- Tab Header
        local TabHeader = CreateElement("Frame", {
            Name = "Header",
            Parent = TabFrame,
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 35)
        })
        
        local HeaderLabel = CreateElement("TextLabel", {
            Parent = TabHeader,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 13
        })
        
        -- Separator Line
        CreateElement("Frame", {
            Parent = TabHeader,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, 0),
            Size = UDim2.new(1, 0, 0, 1)
        })
        
        -- Scrolling Frame
        local ScrollFrame = CreateElement("ScrollingFrame", {
            Name = "Container",
            Parent = TabFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 35),
            Size = UDim2.new(1, 0, 1, -35),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            BorderSizePixel = 0,
            ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)
        })
        
        local ListLayout = CreateElement("UIListLayout", {
            Parent = ScrollFrame,
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
        end)
        
        CreateElement("UIPadding", {
            Parent = ScrollFrame,
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingTop = UDim.new(0, 10)
        })
        
        -- Toggle
        function Tab:AddToggle(name, default, callback)
            local toggled = default or false
            
            local ToggleFrame = CreateElement("TextButton", {
                Name = name,
                Parent = ScrollFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = name,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {TextColor3 = Color3.fromRGB(255, 255, 255)})
            end)
            
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {TextColor3 = Color3.fromRGB(200, 200, 200)})
            end)
            
            ToggleFrame.MouseButton1Click:Connect(function()
                toggled = not toggled
                Tween(ToggleFrame, {TextColor3 = toggled and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(200, 200, 200)})
                if callback then callback(toggled) end
            end)
            
            if toggled then
                ToggleFrame.TextColor3 = Color3.fromRGB(255, 105, 180)
            end
        end
        
        -- Dropdown
        function Tab:AddDropdown(name, options, default, callback)
            local selected = default or options[1]
            local open = false
            
            local DropdownFrame = CreateElement("Frame", {
                Name = name,
                Parent = ScrollFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20)
            })
            
            local DropdownButton = CreateElement("TextButton", {
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = name,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Arrow = CreateElement("TextLabel", {
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -15, 0, 0),
                Size = UDim2.new(0, 15, 1, 0),
                Font = Enum.Font.Gotham,
                Text = "▼",
                TextColor3 = Color3.fromRGB(150, 150, 150),
                TextSize = 10
            })
            
            local SelectedLabel = CreateElement("TextLabel", {
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 1, 2),
                Size = UDim2.new(1, -15, 0, 18),
                Font = Enum.Font.Gotham,
                Text = selected,
                TextColor3 = Color3.fromRGB(150, 150, 150),
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = false
            })
            
            DropdownButton.MouseEnter:Connect(function()
                Tween(DropdownButton, {TextColor3 = Color3.fromRGB(255, 255, 255)})
            end)
            
            DropdownButton.MouseLeave:Connect(function()
                Tween(DropdownButton, {TextColor3 = Color3.fromRGB(200, 200, 200)})
            end)
            
            DropdownButton.MouseButton1Click:Connect(function()
                open = not open
                SelectedLabel.Visible = open
                DropdownFrame.Size = open and UDim2.new(1, 0, 0, 40) or UDim2.new(1, 0, 0, 20)
            end)
        end
        
        -- Slider
        function Tab:AddSlider(name, min, max, default, callback)
            local value = default or min
            local dragging = false
            
            local SliderFrame = CreateElement("Frame", {
                Name = name,
                Parent = ScrollFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 45)
            })
            
            local SliderLabel = CreateElement("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = name,
                TextColor3 = Color3.fromRGB(255, 105, 180),
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = CreateElement("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.7, 0, 0, 0),
                Size = UDim2.new(0.3, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(value),
                TextColor3 = Color3.fromRGB(150, 150, 150),
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local SliderBack = CreateElement("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 4)
            })
            
            CreateElement("UICorner", {
                Parent = SliderBack,
                CornerRadius = UDim.new(0, 2)
            })
            
            local SliderFill = CreateElement("Frame", {
                Parent = SliderBack,
                BackgroundColor3 = Color3.fromRGB(255, 105, 180),
                BorderSizePixel = 0,
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            })
            
            CreateElement("UICorner", {
                Parent = SliderFill,
                CornerRadius = UDim.new(0, 2)
            })
            
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                ValueLabel.Text = tostring(value)
                if callback then callback(value) end
            end
            
            SliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            SliderBack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    return Window
end

return Library
