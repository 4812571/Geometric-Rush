local Bootloader = {}

function Bootloader:Initialize()
    -- Wait Objects
    local Models = workspace:WaitForChild("Models")
    local Avatars = Models:WaitForChild("Avatars")

    -- Transfer Objects
    Models.Parent = game.ReplicatedStorage

    -- Transfer Cached Levels
    for _, levelTemplate in ipairs(game.ReplicatedStorage.Levels:GetChildren()) do
        levelTemplate.Parent = game.ReplicatedStorage.Models.Levels
    end
end

return Bootloader