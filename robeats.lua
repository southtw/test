-- some claude's shit
--// Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

--// Variables
local player = Players.LocalPlayer

local accuracy_bounds = {
    Perfect = -0, 
    Great = -100,
    Okay = -100
};

local accuracy_names = {"Perfect", "Great", "Okay"};

-- Config
local config = {
    enabled = false,
    accuracy = "Perfect"
}

local note_time_target = accuracy_bounds[config.accuracy];
local track_system;
local connection;

--// GUI Creation
local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AutoplayerGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 320, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 12)
    TopbarCorner.Parent = Topbar
    
    local TopbarCover = Instance.new("Frame")
    TopbarCover.Size = UDim2.new(1, 0, 0, 12)
    TopbarCover.Position = UDim2.new(0, 0, 1, -12)
    TopbarCover.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TopbarCover.BorderSizePixel = 0
    TopbarCover.Parent = Topbar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Autoplayer"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Topbar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(1, -30, 0, 30)
    StatusLabel.Position = UDim2.new(0, 15, 0, 55)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Status: Disabled"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = MainFrame
    
    -- Toggle Button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(1, -30, 0, 40)
    ToggleButton.Position = UDim2.new(0, 15, 0, 90)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    ToggleButton.Text = "Enable Autoplayer"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 15
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = MainFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleButton
    
    -- Accuracy Label
    local AccuracyLabel = Instance.new("TextLabel")
    AccuracyLabel.Name = "AccuracyLabel"
    AccuracyLabel.Size = UDim2.new(0.5, -20, 0, 20)
    AccuracyLabel.Position = UDim2.new(0, 15, 0, 145)
    AccuracyLabel.BackgroundTransparency = 1
    AccuracyLabel.Text = "Accuracy:"
    AccuracyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    AccuracyLabel.TextSize = 13
    AccuracyLabel.Font = Enum.Font.Gotham
    AccuracyLabel.TextXAlignment = Enum.TextXAlignment.Left
    AccuracyLabel.Parent = MainFrame
    
    -- Accuracy Dropdown
    local AccuracyButton = Instance.new("TextButton")
    AccuracyButton.Name = "AccuracyButton"
    AccuracyButton.Size = UDim2.new(0.5, -10, 0, 35)
    AccuracyButton.Position = UDim2.new(0.5, 5, 0, 150)
    AccuracyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    AccuracyButton.Text = config.accuracy .. " ▼"
    AccuracyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AccuracyButton.TextSize = 13
    AccuracyButton.Font = Enum.Font.GothamBold
    AccuracyButton.Parent = MainFrame
    
    local AccuracyCorner = Instance.new("UICorner")
    AccuracyCorner.CornerRadius = UDim.new(0, 6)
    AccuracyCorner.Parent = AccuracyButton
    
    -- Dropdown Frame
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "DropdownFrame"
    DropdownFrame.Size = UDim2.new(0.5, -10, 0, 0)
    DropdownFrame.Position = UDim2.new(0.5, 5, 0, 188)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Visible = false
    DropdownFrame.Parent = MainFrame
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = DropdownFrame
    
    local dropdownOptions = {"Perfect", "Great", "Okay", "Random"}
    local dropdownButtons = {}
    
    for i, option in ipairs(dropdownOptions) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Name = option
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        OptionButton.BackgroundTransparency = option == config.accuracy and 0 or 0.3
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 12
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.BorderSizePixel = 0
        OptionButton.Parent = DropdownFrame
        
        table.insert(dropdownButtons, OptionButton)
    end
    
    -- Make draggable
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Parent to CoreGui
    if syn then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
    
    return ScreenGui, MainFrame, StatusLabel, ToggleButton, AccuracyButton, DropdownFrame, dropdownButtons, CloseButton
end

--// Core Functions

local function get_track_action_functions(track_system)
    local press_track, release_track; 
    
    for index, track_function in next, track_system do 
        if type(track_function) == "function" then 
            local constants = getconstants(track_function);
            
            if table.find(constants, "press") then 
                press_track = track_function;
                
                if release_track then 
                    break; 
                end;
            elseif table.find(constants, "release") then 
                release_track = track_function;
                
                if press_track then 
                    break; 
                end;
            end;
        end;
    end;
    
    return press_track, release_track;
end;

local function get_local_track_system(session)
    local local_slot_index = getupvalue(session.set_local_game_slot, 1);
    
    for index, session_function in next, session do 
        if type(session_function) == "function" then 
            local object = getupvalues(session_function)[1];
            
            if type(object) == "table" and rawget(object, "count") and object:count() <= 4 then 
                return object:get(local_slot_index);
            end;
        end;
    end;
end;

--// Get tracksystem 

for index, module in next, getloadedmodules() do 
    local module_value = require(module);
    
    if type(module_value) == "table" then 
        local new_function = rawget(module_value, "new");
        
        if new_function then 
            local first_upvalue = getupvalues(new_function)[1];
            
            if type(first_upvalue) == "table" and rawget(first_upvalue, "twister") then 
                track_system = module_value;
                break;
            end;
        end;
    end;
end;

--// Autoplayer Logic

local old_track_system_new;

local function enableAutoplayer()
    if not track_system or old_track_system_new then return end
    
    old_track_system_new = track_system.new;
    track_system.new = function(...)
        local track_functions = old_track_system_new(...);
        local arguments = {...};
        
        if arguments[2]._players._slots:get(arguments[3])._name == player.Name then
            for index, track_function in next, track_functions do 
                local upvalues = getupvalues(track_function);
                
                if type(upvalues[1]) == "table" and rawget(upvalues[1], "profilebegin") then 
                    local notes_table = upvalues[2];
                    
                    track_functions[index] = function(self, slot, session)
                        local local_track_system = get_local_track_system(session);
                        local press_track, release_track = get_track_action_functions(local_track_system);
                        
                        local test_press_name = getconstant(press_track, 10);
                        local test_release_name = getconstant(release_track, 6);
                        
                        if config.accuracy == "Random" then 
                            note_time_target = accuracy_bounds[accuracy_names[math.random(1, 3)]];
                        end;
        
                        for note_index = 1, notes_table:count() do 
                            local note = notes_table:get(note_index);
                            
                            if note then 
                                local test_press, test_release = note[test_press_name], note[test_release_name];
                                
                                local note_track_index = note:get_track_index(note_index);
                                local pressed, press_result, press_delay = test_press(note);
                                
                                if pressed and press_delay >= note_time_target then
                                    press_track(local_track_system, session, note_track_index);
                                    
                                    session:debug_any_press();
                                    
                                    if rawget(note, "get_time_to_end") then
                                        delay(math.random(5, 18) / 100, function()
                                            release_track(local_track_system, session, note_track_index);
                                        end);
                                    end;
                                end;
                                
                                if test_release then 
                                    local released, release_result, release_delay = test_release(note);
                                    
                                    if released and release_delay >= note_time_target then 
                                        delay(math.random(2, 5) / 100, function()
                                            release_track(local_track_system, session, note_track_index);
                                        end);
                                    end;
                                end;
                            end;
                        end;
                        
                        return track_function(self, slot, session);
                    end;
                end;
            end;
        end;
        
        return track_functions;
    end;
end

local function disableAutoplayer()
    if old_track_system_new and track_system then
        track_system.new = old_track_system_new;
        old_track_system_new = nil;
    end
end

--// GUI Setup

local ScreenGui, MainFrame, StatusLabel, ToggleButton, AccuracyButton, DropdownFrame, dropdownButtons, CloseButton = createGUI()

-- Toggle functionality
ToggleButton.MouseButton1Click:Connect(function()
    config.enabled = not config.enabled
    
    if config.enabled then
        enableAutoplayer()
        StatusLabel.Text = "Status: Enabled"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        ToggleButton.Text = "Disable Autoplayer"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
    else
        disableAutoplayer()
        StatusLabel.Text = "Status: Disabled"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        ToggleButton.Text = "Enable Autoplayer"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    end
end)

-- Accuracy dropdown
local dropdownOpen = false

AccuracyButton.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    
    if dropdownOpen then
        DropdownFrame.Visible = true
        TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(0.5, -10, 0, 120)}):Play()
        AccuracyButton.Text = config.accuracy .. " ▲"
    else
        TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(0.5, -10, 0, 0)}):Play()
        AccuracyButton.Text = config.accuracy .. " ▼"
        wait(0.2)
        DropdownFrame.Visible = false
    end
end)

-- Dropdown options
for _, button in ipairs(dropdownButtons) do
    button.MouseButton1Click:Connect(function()
        config.accuracy = button.Text
        note_time_target = accuracy_bounds[config.accuracy] or accuracy_bounds["Perfect"]
        AccuracyButton.Text = config.accuracy .. " ▼"
        
        for _, btn in ipairs(dropdownButtons) do
            btn.BackgroundTransparency = 0.3
        end
        button.BackgroundTransparency = 0
        
        dropdownOpen = false
        TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(0.5, -10, 0, 0)}):Play()
        wait(0.2)
        DropdownFrame.Visible = false
    end)
end

-- Close button
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if config.enabled then
        disableAutoplayer()
    end
end)

print("Autoplayer GUI loaded!")
