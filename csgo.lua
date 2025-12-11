-- https://www.roblox.com/games/10622006440/
-- based on airhub

if getgenv().AirHubV2Loaded then
    return
end

getgenv().AirHub = {}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/Modules/Aimbot.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/Modules/Wall%20Hack.lua"))()

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Aimbot = getgenv().AirHub.Aimbot
local WallHack = getgenv().AirHub.WallHack
local Parts = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

local Window = Library:CreateWindow({
    Title = 'buxinho',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local AimbotTab = Window:AddTab('Aimbot')

local AimbotMain = AimbotTab:AddLeftGroupbox('Main')

AimbotMain:AddToggle('AimbotEnabled', {
    Text = 'Enable Aimbot',
    Default = Aimbot.Settings.Enabled,
    Callback = function(val) Aimbot.Settings.Enabled = val end
})

AimbotMain:AddToggle('AimbotToggle', {
    Text = 'Toggle Mode',
    Default = Aimbot.Settings.Toggle,
    Tooltip = 'Toggle instead of hold',
    Callback = function(val) Aimbot.Settings.Toggle = val end
})

AimbotMain:AddDropdown('LockPart', {
    Values = Parts,
    Default = 1,
    Text = 'Target Part',
    Callback = function(val) Aimbot.Settings.LockPart = val end
})

AimbotMain:AddInput('AimbotKey', {
    Default = Aimbot.Settings.TriggerKey,
    Text = 'Hotkey',
    Placeholder = 'MouseButton2',
    Callback = function(val) Aimbot.Settings.TriggerKey = val end
})

AimbotMain:AddSlider('Sensitivity', {
    Text = 'Sensitivity',
    Default = Aimbot.Settings.Sensitivity,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(val) Aimbot.Settings.Sensitivity = val end
})

local AimbotChecks = AimbotTab:AddRightGroupbox('Checks')

AimbotChecks:AddToggle('TeamCheck', {
    Text = 'Team Check',
    Default = Aimbot.Settings.TeamCheck,
    Callback = function(val) Aimbot.Settings.TeamCheck = val end
})

AimbotChecks:AddToggle('WallCheck', {
    Text = 'Wall Check',
    Default = Aimbot.Settings.WallCheck,
    Callback = function(val) Aimbot.Settings.WallCheck = val end
})

AimbotChecks:AddToggle('AliveCheck', {
    Text = 'Alive Check',
    Default = Aimbot.Settings.AliveCheck,
    Callback = function(val) Aimbot.Settings.AliveCheck = val end
})

local FOV = AimbotTab:AddLeftGroupbox('Field of View')

FOV:AddToggle('FOVEnabled', {
    Text = 'Enable FOV',
    Default = Aimbot.FOVSettings.Enabled,
    Callback = function(val) Aimbot.FOVSettings.Enabled = val end
})

FOV:AddToggle('FOVVisible', {
    Text = 'Visible',
    Default = Aimbot.FOVSettings.Visible,
    Callback = function(val) Aimbot.FOVSettings.Visible = val end
})

FOV:AddSlider('FOVSize', {
    Text = 'Size',
    Default = Aimbot.FOVSettings.Amount,
    Min = 10,
    Max = 300,
    Rounding = 0,
    Callback = function(val) Aimbot.FOVSettings.Amount = val end
})

FOV:AddToggle('FOVFilled', {
    Text = 'Filled',
    Default = Aimbot.FOVSettings.Filled,
    Callback = function(val) Aimbot.FOVSettings.Filled = val end
})

FOV:AddLabel('Color'):AddColorPicker('FOVColor', {
    Default = Aimbot.FOVSettings.Color,
    Title = 'FOV Color',
    Callback = function(val) Aimbot.FOVSettings.Color = val end
})

local WeaponMods = AimbotTab:AddRightGroupbox('Weapon Mods')

local ModStates = {
    Recoil = false,
    InfAmmo = false,
    ReloadTime = false,
    FireRate = false,
    Spread = false
}

local function ApplyWeaponMods()
    local gc = getgc(true)
    for i, tbl in pairs(gc) do
        if type(tbl) == "table" then
            if ModStates.Spread and rawget(tbl, "Spread") then
                rawset(tbl, "Spread", 0)
            end
            if ModStates.Recoil and rawget(tbl, "Recoil") then
                rawset(tbl, "Recoil", 0)
            end
            if ModStates.InfAmmo and rawget(tbl, "MaxAmmo") then
                rawset(tbl, "MaxAmmo", 999)
                if rawget(tbl, "AmmoPerMag") then
                    rawset(tbl, "AmmoPerMag", 999)
                end
            end
            if ModStates.ReloadTime and rawget(tbl, "ReloadTime") then
                rawset(tbl, "ReloadTime", 0)
            end
            if ModStates.FireRate and rawget(tbl, "FireRate") then
                rawset(tbl, "FireRate", 0)
            end
        end
    end
end

WeaponMods:AddToggle('NoRecoil', {
    Text = 'No Recoil',
    Default = false,
    Callback = function(val)
        ModStates.Recoil = val
        if val then ApplyWeaponMods() end
    end
})

WeaponMods:AddToggle('InfAmmo', {
    Text = 'Infinite Ammo',
    Default = false,
    Callback = function(val)
        ModStates.InfAmmo = val
        if val then ApplyWeaponMods() end
    end
})

WeaponMods:AddToggle('NoReload', {
    Text = 'No Reload Time',
    Default = false,
    Callback = function(val)
        ModStates.ReloadTime = val
        if val then ApplyWeaponMods() end
    end
})

WeaponMods:AddToggle('RapidFire', {
    Text = 'Rapid Fire',
    Default = false,
    Callback = function(val)
        ModStates.FireRate = val
        if val then ApplyWeaponMods() end
    end
})

WeaponMods:AddToggle('NoSpread', {
    Text = 'No Spread',
    Default = false,
    Callback = function(val)
        ModStates.Spread = val
        if val then ApplyWeaponMods() end
    end
})

WeaponMods:AddButton({
    Text = 'Apply All Mods',
    Func = ApplyWeaponMods,
    Tooltip = 'you need to re-apply when you died'
})


local VisualsTab = Window:AddTab('Visuals')

local VisualsMain = VisualsTab:AddLeftGroupbox('Main')

VisualsMain:AddToggle('VisualsEnabled', {
    Text = 'Enable Visuals',
    Default = WallHack.Settings.Enabled,
    Callback = function(val) WallHack.Settings.Enabled = val end
})

VisualsMain:AddToggle('TeamCheck', {
    Text = 'Team Check',
    Default = WallHack.Settings.TeamCheck,
    Callback = function(val) WallHack.Settings.TeamCheck = val end
})

VisualsMain:AddToggle('AliveCheck', {
    Text = 'Alive Check',
    Default = WallHack.Settings.AliveCheck,
    Callback = function(val) WallHack.Settings.AliveCheck = val end
})

local ESP = VisualsTab:AddLeftGroupbox('ESP')

ESP:AddToggle('ESPEnabled', {
    Text = 'Enable ESP',
    Default = WallHack.Visuals.ESPSettings.Enabled,
    Callback = function(val) WallHack.Visuals.ESPSettings.Enabled = val end
})

ESP:AddToggle('Distance', {
    Text = 'Show Distance',
    Default = WallHack.Visuals.ESPSettings.DisplayDistance,
    Callback = function(val) WallHack.Visuals.ESPSettings.DisplayDistance = val end
})

ESP:AddToggle('Health', {
    Text = 'Show Health',
    Default = WallHack.Visuals.ESPSettings.DisplayHealth,
    Callback = function(val) WallHack.Visuals.ESPSettings.DisplayHealth = val end
})

ESP:AddToggle('Name', {
    Text = 'Show Name',
    Default = WallHack.Visuals.ESPSettings.DisplayName,
    Callback = function(val) WallHack.Visuals.ESPSettings.DisplayName = val end
})

ESP:AddSlider('TextSize', {
    Text = 'Text Size',
    Default = WallHack.Visuals.ESPSettings.TextSize,
    Min = 8,
    Max = 24,
    Rounding = 0,
    Callback = function(val) WallHack.Visuals.ESPSettings.TextSize = val end
})

ESP:AddLabel('Color'):AddColorPicker('ESPColor', {
    Default = WallHack.Visuals.ESPSettings.TextColor,
    Title = 'ESP Color',
    Callback = function(val) WallHack.Visuals.ESPSettings.TextColor = val end
})

local Boxes = VisualsTab:AddRightGroupbox('Boxes')

Boxes:AddToggle('BoxEnabled', {
    Text = 'Enable Boxes',
    Default = WallHack.Visuals.BoxSettings.Enabled,
    Callback = function(val) WallHack.Visuals.BoxSettings.Enabled = val end
})

Boxes:AddDropdown('BoxType', {
    Values = {'3D', '2D'},
    Default = 1,
    Text = 'Type',
    Callback = function(val) WallHack.Visuals.BoxSettings.Type = val == "3D" and 1 or 2 end
})

Boxes:AddToggle('BoxFilled', {
    Text = 'Filled',
    Default = WallHack.Visuals.BoxSettings.Filled,
    Callback = function(val) WallHack.Visuals.BoxSettings.Filled = val end
})

Boxes:AddSlider('BoxThickness', {
    Text = 'Thickness',
    Default = WallHack.Visuals.BoxSettings.Thickness,
    Min = 1,
    Max = 5,
    Rounding = 0,
    Callback = function(val) WallHack.Visuals.BoxSettings.Thickness = val end
})

Boxes:AddLabel('Color'):AddColorPicker('BoxColor', {
    Default = WallHack.Visuals.BoxSettings.Color,
    Title = 'Box Color',
    Callback = function(val) WallHack.Visuals.BoxSettings.Color = val end
})

local Tracers = VisualsTab:AddRightGroupbox('Tracers')

Tracers:AddToggle('TracersEnabled', {
    Text = 'Enable Tracers',
    Default = WallHack.Visuals.TracersSettings.Enabled,
    Callback = function(val) WallHack.Visuals.TracersSettings.Enabled = val end
})

Tracers:AddDropdown('TracersFrom', {
    Values = {'Bottom', 'Center', 'Mouse'},
    Default = 1,
    Text = 'Start From',
    Callback = function(val)
        local types = {Bottom = 1, Center = 2, Mouse = 3}
        WallHack.Visuals.TracersSettings.Type = types[val]
    end
})

Tracers:AddSlider('TracersThickness', {
    Text = 'Thickness',
    Default = WallHack.Visuals.TracersSettings.Thickness,
    Min = 1,
    Max = 5,
    Rounding = 0,
    Callback = function(val) WallHack.Visuals.TracersSettings.Thickness = val end
})

Tracers:AddLabel('Color'):AddColorPicker('TracersColor', {
    Default = WallHack.Visuals.TracersSettings.Color,
    Title = 'Tracers Color',
    Callback = function(val) WallHack.Visuals.TracersSettings.Color = val end
})

local Chams = VisualsTab:AddLeftGroupbox('Chams')

Chams:AddToggle('ChamsEnabled', {
    Text = 'Enable Chams',
    Default = WallHack.Visuals.ChamsSettings.Enabled,
    Callback = function(val) WallHack.Visuals.ChamsSettings.Enabled = val end
})

Chams:AddToggle('ChamsFilled', {
    Text = 'Filled',
    Default = WallHack.Visuals.ChamsSettings.Filled,
    Callback = function(val) WallHack.Visuals.ChamsSettings.Filled = val end
})

Chams:AddSlider('ChamsTransparency', {
    Text = 'Transparency',
    Default = WallHack.Visuals.ChamsSettings.Transparency,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(val) WallHack.Visuals.ChamsSettings.Transparency = val end
})

Chams:AddLabel('Color'):AddColorPicker('ChamsColor', {
    Default = WallHack.Visuals.ChamsSettings.Color,
    Title = 'Chams Color',
    Callback = function(val) WallHack.Visuals.ChamsSettings.Color = val end
})

local SettingsTab = Window:AddTab('Settings')

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('buxinho')
SaveManager:SetFolder('buxinho/configs')

SaveManager:BuildConfigSection(SettingsTab)
ThemeManager:ApplyToTab(SettingsTab)

SaveManager:SetIgnoreIndexes({'MenuKeybind'})

task.spawn(function()
    SaveManager:LoadAutoloadConfig()
end)

getgenv().AirHubV2Loaded = true
