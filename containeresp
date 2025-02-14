local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Active = true
local Keybind = Enum.KeyCode.P
local RenderDistance = 200

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = CoreGui

local TextLabel = Instance.new("TextLabel")
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.02, 0, 0.2, 0)
TextLabel.Size = UDim2.new(0, 0, 0, 0)
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.RobotoMono
TextLabel.RichText = true
TextLabel.TextSize = 20
TextLabel.TextStrokeTransparency = 0
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = ScreenGui

local ValueCache = {
    ["6B45"] = 16,
    ["AS Val"] = 16,
    ["ATC Key"] = 4,
    ["Airfield Key"] = 6,
    ["Altyn"] = 16,
    ["Altyn Visor"] = 8,
    ["Attak-5 60L"] = 16,
    ["Bolts"] = 1,
    ["Crane Key"] = 6,
    ["DAGR"] = 8,
    ["Duct Tape"] = 1,
    ["Fast MT"] = 10,
    ["Flare Gun"] = 8,
    ["Fueling Station Key"] = 4,
    ["Garage Key"] = 4,
    ["Hammer"] = 1,
    ["JPC"] = 10,
    ["Lighthouse Key"] = 6,
    ["M4A1"] = 12,
    ["Nails"] = 1,
    ["Nuts"] = 1,
    ["Saiga 12"] = 8,
    ["Super Glue"] = 1,
    ["Village Key"] = 4,
    ["Wrench"] = 1
}

local ValueSettings = {
    [0] = Color3.fromRGB(255, 255, 255),
    [4] = Color3.fromRGB(76, 187, 23),
    [8] = Color3.fromRGB(218, 112, 214),
    [16] = Color3.fromRGB(233, 116, 81),
    [32] = Color3.fromRGB(255, 36, 0)
}

local Camera = Workspace.CurrentCamera
local Containers = Workspace:WaitForChild("Containers")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

local function updateTextLabel()
    TextLabel.Text = string.format("Render Distance: %d<br /><font color='rgb(255, 0, 0)'>[↓]</font> Decrease render distance by 100<br /><font color='rgb(0, 255, 0)'>[↑]</font> Increase render distance by 100<br /><font color='rgb(255, 255, 0)'>[%s]</font> Enable / Disable ESP (%s)",
        RenderDistance, Keybind.Name, (Active and "Enabled" or "Disabled"))
end

-- Update initial text label
updateTextLabel()

-- Function to handle input events
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Keybind and not gameProcessed then
        Active = not Active
        updateTextLabel()
    elseif input.KeyCode == Enum.KeyCode.Down or input.KeyCode == Enum.KeyCode.Up then
        RenderDistance = math.clamp(RenderDistance + (input.KeyCode == Enum.KeyCode.Down and -100 or 100), 100, 1200)
        updateTextLabel()
    end
end)

-- Function to draw ESP
local function draw(Container)
    local Drawing = Drawing.new("Text")
    Drawing.Center = true
    Drawing.Font = 2
    Drawing.Outline = true
    Drawing.Size = 14

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not Active then
            Drawing.Visible = false
            return
        end

        if not Container.PrimaryPart or not Container.PrimaryPart.Parent then
            Drawing.Visible = false
            return
        end

        local rootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            Drawing.Visible = false
            return
        end

        local distance = (Container.PrimaryPart.Position - rootPart.Position).Magnitude
        if distance > RenderDistance then
            Drawing.Visible = false
            return
        end

        local position, visible = Camera:WorldToViewportPoint(Container.PrimaryPart.Position)
        if not visible then
            Drawing.Visible = false
            return
        end

        local amount, itemName, nextSpawn, totalPrice, value, loot = 0, "", 0, 0, 0, ""

        for _, item in pairs(Container.Inventory:GetChildren()) do
            amount = item.ItemProperties:GetAttribute("Amount") or 1
            itemName = item.ItemProperties:GetAttribute("CallSign")
            totalPrice = totalPrice + (item.ItemProperties:GetAttribute("Price") or 0)
            value = value + (ValueCache[itemName] or 0) * amount
            loot = loot .. itemName .. " (x" .. amount .. ")\n"
        end

        local color, highest = nil, -1

        for val, col in pairs(ValueSettings) do
            if value >= val and val > highest then
                color = col
                highest = val
            end
        end

        Drawing.Color = color or Color3.fromRGB(255, 255, 255)
        Drawing.Position = Vector2.new(position.X, position.Y)
        Drawing.Text = "$" .. totalPrice .. "\n" .. Container:GetAttribute("DisplayName") .. "\n" ..
                       (nextSpawn < 0 and "Not loaded" or loot .. "Next Spawn: " .. nextSpawn .. "s") .. "\n" ..
                       math.round(distance)
        Drawing.ZIndex = value
        Drawing.Visible = true
    end)
end

-- Function to initialize drawing for existing containers
local function initializeDrawing()
    for _, container in pairs(Containers:GetChildren()) do
        if container:IsA("Model") then
            draw(container)
        end
    end
end

initializeDrawing()

-- Event handler for new containers being added
Containers.ChildAdded:Connect(function(container)
    if container:IsA("Model") then
        draw(container)
    end
end)

-- Event handler for character loading
LocalPlayer.CharacterAdded:Connect(function(character)
    Character = character
end)
