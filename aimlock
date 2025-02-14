-- Aim Lock Script for Roblox (Targets Only Enemies)
-- Place this in a LocalScript inside StarterCharacterScripts

local UserInputService = game:GetService("UserInputService")
local Camera = game:GetService("Workspace").CurrentCamera
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local lockOnRange = 700 -- Maximum distance to detect targets
local lockOnKey = Enum.UserInputType.MouseButton2 -- Right Mouse Button (RMB)
local lockedTarget = nil

-- Function to check if a target is an enemy
local function isEnemy(target)
    if player.Team and target.Team then -- Check if teams exist
        return player.Team ~= target.Team -- Only target different team members
    end
    return true -- If no teams exist, assume everyone is an enemy
end

-- Function to check if a target is visible
local function isTargetVisible(target)
    local character = target.Character
    if not character then return false end

    local head = character:FindFirstChild("Head")
    if not head then return false end

    -- Perform a raycast from the Camera to the target's head
    local origin = Camera.CFrame.Position
    local direction = (head.Position - origin).unit * (head.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character} -- Ignore local player
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local rayResult = workspace:Raycast(origin, direction, raycastParams)

    -- If nothing is hit, or if the hit part belongs to the target, it's visible
    if rayResult and rayResult.Instance and not head:IsDescendantOf(rayResult.Instance.Parent) then
        return false -- Something is blocking the target
    end

    return true
end

-- Function to find the best enemy target
local function getBestTarget()
    local bestTarget = nil
    local bestDistance = lockOnRange
    local bestVisibleTarget = nil
    local bestVisibleDistance = lockOnRange

    for _, potentialTarget in pairs(Players:GetPlayers()) do
        if potentialTarget ~= player and potentialTarget.Character and isEnemy(potentialTarget) then
            local head = potentialTarget.Character:FindFirstChild("Head")
            local humanoid = potentialTarget.Character:FindFirstChild("Humanoid")

            -- Ensure target has a head and is alive
            if head and humanoid and humanoid.Health > 0 then
                local distance = (Camera.CFrame.Position - head.Position).Magnitude

                -- Always track the closest enemy
                if distance < bestDistance then
                    bestDistance = distance
                    bestTarget = potentialTarget
                end

                -- Check if the target is visible
                if isTargetVisible(potentialTarget) and distance < bestVisibleDistance then
                    bestVisibleDistance = distance
                    bestVisibleTarget = potentialTarget
                end
            end
        end
    end
    
    -- Prefer visible target over hidden target
    return bestVisibleTarget or bestTarget
end

-- Lock onto a target when RMB is pressed
local function lockOn()
    local target = getBestTarget()
    if target then
        lockedTarget = target
    end
end

-- Unlock the target when RMB is released
local function unlockAim()
    lockedTarget = nil
end

-- Detect mouse button press for locking
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == lockOnKey then
        lockOn()
    end
end)

-- Detect mouse button release for unlocking
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == lockOnKey then
        unlockAim()
    end
end)

-- Function to adjust aim to the locked target
local function updateAim()
    if lockedTarget and lockedTarget.Character then
        local head = lockedTarget.Character:FindFirstChild("Head")
        if head then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    end
end

-- Update aim every frame
game:GetService("RunService").RenderStepped:Connect(updateAim)
