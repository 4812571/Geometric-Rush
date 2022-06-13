local ElementRegistry = require(game.ReplicatedStorage.Source.Game.ElementRegistry)

local Collisions = {
    -- Boxes
    hurtBoxes = {};

    -- Caches
    colliding = {};
    touching = {};
}

function Collisions:Update()
    -- Clear Caches
    self.colliding = {}
    self.touching = {}

    local collidedElements = {}
    local touchingElements = {}

    -- Check for Collision
    for hurtBox, _ in pairs(self.hurtBoxes) do
        for _, part in ipairs(workspace:GetPartsInPart(hurtBox)) do
            -- Get element
            local element = ElementRegistry:GetElementFromInstance(part)

            -- Touch Detected
            if element then
                touchingElements[element] = true
            end

            -- Collision Detected
            if part.CanTouch and element then
                collidedElements[element] = true
            end
        end
    end

    -- Update Cache
    for element, _ in pairs(collidedElements) do self.colliding[element] = true end
    for element, _ in pairs(touchingElements) do self.touching[element] = true end
end

function Collisions:GetColliding()
    return self.colliding
end

function Collisions:GetTouching()
    return self.touching
end

function Collisions:AddHurtBox(hurtBox)
    self.hurtBoxes[hurtBox] = true
end

function Collisions:ClearBoxes()
    self.hurtBoxes = {}
end

return Collisions