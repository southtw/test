local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Config = {
	HitboxSize = Vector3.new(10, 10, 10),
	Transparency = 1,
	Notifications = false,
	ESPEnabled = true,
	HitboxEnabled = true,
	ESPBoxes = true,
	ESPNames = false,
	ESPTracers = false,
	ESPColor = Color3.fromRGB(255, 0, 4)
}

local start = os.clock()

local esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/andrewc0de/Roblox/main/Dependencies/ESP.lua"))()
esp:Toggle(Config.ESPEnabled)

esp.Boxes = Config.ESPBoxes
esp.Names = Config.ESPNames
esp.Tracers = Config.ESPTracers
esp.Players = false

esp:AddObjectListener(workspace, {
	Name = "soldier_model",
	Type = "Model",
	Color = Config.ESPColor,

	PrimaryPart = function(obj)
		local root
		repeat
			root = obj:FindFirstChild("HumanoidRootPart")
			task.wait()
		until root
		return root
	end,

	Validator = function(obj)
		task.wait(1)
		if obj:FindFirstChild("friendly_marker") then
			return false
		end
		return true
	end,

	CustomName = "Enemy",

	IsEnabled = "enemy"
})

esp.enemy = true

local function applyHitbox(model)
	if not Config.HitboxEnabled then return end
	
	local hrp = model:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	local pos = hrp.Position
	for _, bp in pairs(workspace:GetChildren()) do
		if bp:IsA("BasePart") then
			local distance = (bp.Position - pos).Magnitude
			if distance <= 5 then
				bp.Transparency = Config.Transparency
				bp.Size = Config.HitboxSize
			end
		end
	end
end

task.wait(1)

for _, v in pairs(workspace:GetDescendants()) do
	if v.Name == "soldier_model" and v:IsA("Model") and not v:FindFirstChild("friendly_marker") then
		applyHitbox(v)
	end
end

local function handleDescendantAdded(descendant)
	task.wait(1)

	if descendant.Name == "soldier_model" and descendant:IsA("Model") and not descendant:FindFirstChild("friendly_marker") then
		if Config.Notifications then
			game.StarterGui:SetCore("SendNotification", {
				Title = "Script",
				Text = "[Warning] New Enemy Spawned! Applied hitboxes.",
				Icon = "",
				Duration = 3
			})
		end

		applyHitbox(descendant)
	end
end

task.spawn(function()
	game.Workspace.DescendantAdded:Connect(handleDescendantAdded)
end)

local Window = Library.CreateLib("FRONTLINES", "DarkTheme")

local ESPTab = Window:NewTab("ESP Settings")
local ESPSection = ESPTab:NewSection("ESP Configuration")

ESPSection:NewToggle("Enable ESP", "Toggle ESP on/off", function(state)
	Config.ESPEnabled = state
	esp:Toggle(state)
end)

ESPSection:NewToggle("ESP Boxes", "Show boxes around enemies", function(state)
	Config.ESPBoxes = state
	esp.Boxes = state
end)

ESPSection:NewToggle("ESP Names", "Show enemy names", function(state)
	Config.ESPNames = state
	esp.Names = state
end)

ESPSection:NewToggle("ESP Tracers", "Show tracers to enemies", function(state)
	Config.ESPTracers = state
	esp.Tracers = state
end)

ESPSection:NewColorPicker("ESP Color", "Change ESP color", Config.ESPColor, function(color)
	Config.ESPColor = color
end)

local HitboxTab = Window:NewTab("Hitbox Settings")
local HitboxSection = HitboxTab:NewSection("Hitbox Configuration")

HitboxSection:NewToggle("Enable Hitbox", "Toggle hitbox expansion", function(state)
	Config.HitboxEnabled = state
end)

HitboxSection:NewSlider("Hitbox Size X", "Adjust hitbox X size", 50, 1, function(value)
	Config.HitboxSize = Vector3.new(value, Config.HitboxSize.Y, Config.HitboxSize.Z)
end)

HitboxSection:NewSlider("Hitbox Size Y", "Adjust hitbox Y size", 50, 1, function(value)
	Config.HitboxSize = Vector3.new(Config.HitboxSize.X, value, Config.HitboxSize.Z)
end)

HitboxSection:NewSlider("Hitbox Size Z", "Adjust hitbox Z size", 50, 1, function(value)
	Config.HitboxSize = Vector3.new(Config.HitboxSize.X, Config.HitboxSize.Y, value)
end)

HitboxSection:NewSlider("Transparency", "Adjust hitbox transparency (0=visible, 100=invisible)", 100, 0, function(value)
	Config.Transparency = value / 100
end)

local PresetSection = HitboxTab:NewSection("Quick Presets")

PresetSection:NewButton("Small Hitbox (5x5x5)", "Set hitbox to small size", function()
	Config.HitboxSize = Vector3.new(5, 5, 5)
end)

PresetSection:NewButton("Medium Hitbox (10x10x10)", "Set hitbox to medium size", function()
	Config.HitboxSize = Vector3.new(10, 10, 10)
end)

PresetSection:NewButton("Large Hitbox (20x20x20)", "Set hitbox to large size", function()
	Config.HitboxSize = Vector3.new(20, 20, 20)
end)

PresetSection:NewButton("Huge Hitbox (30x30x30)", "Set hitbox to huge size", function()
	Config.HitboxSize = Vector3.new(30, 30, 30)
end)

local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Other Settings")

MiscSection:NewToggle("Enemy Spawn Notifications", "Get notified when enemies spawn", function(state)
	Config.Notifications = state
end)

MiscSection:NewButton("Refresh All Hitboxes", "Reapply hitboxes to all enemies", function()
	for _, v in pairs(workspace:GetDescendants()) do
		if v.Name == "soldier_model" and v:IsA("Model") and not v:FindFirstChild("friendly_marker") then
			applyHitbox(v)
		end
	end
	game.StarterGui:SetCore("SendNotification", {
		Title = "Script",
		Text = "All hitboxes refreshed!",
		Icon = "",
		Duration = 3
	})
end)

local InfoSection = MiscTab:NewSection("Information")

InfoSection:NewLabel("Script Version: 2.0")
InfoSection:NewLabel("Target: soldier_model")
InfoSection:NewLabel("Excludes: friendly_marker")

InfoSection:NewKeybind("Toggle UI", "Toggle the UI visibility", Enum.KeyCode.RightControl, function()
	Library:ToggleUI()
end)

local finish = os.clock()

local time = finish - start
local rating
if time < 3 then
	rating = "fast"
elseif time < 5 then
	rating = "acceptable"
else
	rating = "slow"
end
