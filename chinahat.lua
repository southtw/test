local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local head = character:WaitForChild("Head")

local hatConfig = {
    Enabled = true,
    Transparency = 0.5,
    Material = Enum.Material.Neon,
    Color = Color3.fromRGB(255, 255, 255),
    Size = Vector3.new(3, 0.3, 3),
    Position = Vector3.new(0, 0.6, 0)
}

for _, obj in ipairs(character:GetDescendants()) do
    if obj.Name == "ChinaHat" or obj.Name == "ChinaHat" then
        obj:Destroy()
    end
end

local chinaHat = Instance.new("Part")
chinaHat.Name = "ChinaHat"
chinaHat.Size = hatConfig.Size
chinaHat.Transparency = hatConfig.Transparency
chinaHat.CanCollide = false
chinaHat.Anchored = false
chinaHat.Material = hatConfig.Material
chinaHat.TopSurface = Enum.SurfaceType.Smooth
chinaHat.BottomSurface = Enum.SurfaceType.Smooth
chinaHat.Parent = character

local mesh = Instance.new("SpecialMesh")
mesh.MeshType = Enum.MeshType.FileMesh
mesh.MeshId = "rbxassetid://1778999"
mesh.Scale = Vector3.new(3.5, 0.7, 3.5)
mesh.Parent = chinaHat

local weld = Instance.new("Weld")
weld.Part0 = head
weld.Part1 = chinaHat
weld.C0 = CFrame.new(hatConfig.Position)
weld.Parent = chinaHat

local hue = 0
local speed = 1

local colorConnection
colorConnection = RunService.Heartbeat:Connect(function(dt)
    if not chinaHat or not chinaHat.Parent then
        if colorConnection then
            colorConnection:Disconnect()
        end
        return
    end

    hue = (hue + (dt * speed * 20)) % 360

    local color = Color3.fromHSV(hue / 360, 1, 1)
    chinaHat.Color = color
end)

local function onCharacterAdded(newCharacter)
    task.wait(0.5)
    character = newCharacter
    head = newCharacter:WaitForChild("Head")

    for _, obj in ipairs(newCharacter:GetDescendants()) do
        if obj.Name == "ChinaHat" or obj.Name == "ChinaHat" then
            obj:Destroy()
        end
    end

    chinaHat = Instance.new("Part")
    chinaHat.Name = "ChinaHat"
    chinaHat.Size = hatConfig.Size
    chinaHat.Transparency = hatConfig.Transparency
    chinaHat.CanCollide = false
    chinaHat.Anchored = false
    chinaHat.Material = hatConfig.Material
    chinaHat.TopSurface = Enum.SurfaceType.Smooth
    chinaHat.BottomSurface = Enum.SurfaceType.Smooth
    chinaHat.Parent = newCharacter
    
    mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://1778999"
    mesh.Scale = Vector3.new(3.5, 0.7, 3.5)
    mesh.Parent = chinaHat
    
    weld = Instance.new("Weld")
    weld.Part0 = head
    weld.Part1 = chinaHat
    weld.C0 = CFrame.new(hatConfig.Position)
    weld.Parent = chinaHat
end

player.CharacterAdded:Connect(onCharacterAdded)
