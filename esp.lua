-- Get the necessary services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")


local function createESP(npc)
    
    if npc and npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
        -- Create a new Highlight object for visual indication
        local highlight = Instance.new("Highlight")
        highlight.Parent = npc
        highlight.Adornee = npc -- The object that the highlight will surround
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0) -- Red outline
        highlight.FillColor = Color3.fromRGB(0, 0, 0) -- Black fill
        highlight.FillTransparency = 0.5 -- Semi-transparent fill color
        highlight.OutlineTransparency = 0 -- No transparency for the outline
        highlight.Enabled = true -- Enable the highlight effect

        -- Optional: Set the highlight's zIndex to make sure it's rendered above other objects
        highlight.ZIndex = 10
    end
end

local function detectNPCs()
    
    for _, object in pairs(workspace:GetChildren()) do
        
        if object:IsA("Model") and object:FindFirstChild("Humanoid") then
            -- Check if this NPC doesn't already have a highlight
            if not object:FindFirstChildOfClass("Highlight") then
                
                createESP(object)
            end
        end
    end
end

workspace.ChildAdded:Connect(function(child)
    -- Check if the new child is an NPC (model with humanoid)
    if child:IsA("Model") and child:FindFirstChild("Humanoid") then
        createESP(child) -- Apply ESP to the newly spawned NPC
    end
end)

RunService.Heartbeat:Connect(function()
    detectNPCs() -- Continuously check for NPCs and apply ESP
end)

detectNPCs()

