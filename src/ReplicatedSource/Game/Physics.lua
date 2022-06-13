local Event = require(game.ReplicatedStorage.Source.Core.Event)

local DebrisService = game:GetService("Debris")

local DebugPart = Instance.new("Part")
DebugPart.Anchored = true
DebugPart.CanCollide = false
DebugPart.Transparency = 0.5
DebugPart.Size = Vector3.new(0.1, 0.1, 0.1)
DebugPart.Shape = Enum.PartType.Ball

local function createDebugPart(position, color)
    local part = DebugPart:Clone()
    part.Parent = workspace
    part.CFrame = CFrame.new(position)
    part.BrickColor = color
    DebrisService:AddItem(part, 0.1)
end

local Physics = {
    objects = {};

    -- Physics
    velocities = {};
    accelerations = {};

    -- Constraints
    velocityRestrictions = {};

    -- Collisions
    colliders = {};

    -- Grounded
    groundedStates = {};
    groundedEvents = {};
}

function Physics:AddModel(model)
    self.objects[model] = true
    self.velocities[model] = Vector3.new(0, 0, 0)
    self.accelerations[model] = Vector3.new(0, 0, 0)
    self.groundedStates[model] = false
end

function Physics:RemoveModel(model)
    self.objects[model] = nil
    self.velocities[model] = nil
    self.accelerations[model] = nil
    self.velocityRestrictions[model] = nil
    self.colliders[model] = nil
    self.groundedStates[model] = nil
    self.groundedEvents[model] = nil
end

function Physics:Update(delta)
    -- Update Velocities
    for model, _ in pairs(self.objects) do
        self.velocities[model] = self.velocities[model] + self.accelerations[model] * delta
    end

    -- Helper Functions
    local function vMin(v0, v1) return Vector3.new(math.min(v0.X, v1.X), math.min(v0.Y, v1.Y), math.min(v0.Z, v1.Z)) end
    local function vMax(v0, v1) return Vector3.new(math.max(v0.X, v1.X), math.max(v0.Y, v1.Y), math.max(v0.Z, v1.Z)) end
    local function vClamp(v0, v1, v2) return vMin(vMax(v0, v1), v2) end

    -- Clamp Velocities
    for model, _ in pairs(self.objects) do
        local min = self.velocityRestrictions[model] and self.velocityRestrictions[model].min or Vector3.new(-math.huge, -math.huge, -math.huge)
        local max = self.velocityRestrictions[model] and self.velocityRestrictions[model].max or Vector3.new( math.huge,  math.huge,  math.huge)
        self.velocities[model] = vClamp(self.velocities[model], min, max)
    end

    -- Update Positions
    for model, _ in pairs(self.objects) do
        local currentPosition = model.PrimaryPart.Position
        local positionChange = self.velocities[model] * delta
        local newPosition = currentPosition + positionChange

        -- Generate Parameters
        local parameters = RaycastParams.new()
        parameters.FilterType = Enum.RaycastFilterType.Blacklist
        local filter = {model}

        -- Custom Raycast
        local function customCast(startPos, endPos)
            -- Cast Loop
            while true do
                -- Settings
                parameters.FilterDescendantsInstances = filter

                -- Raycast
                local result = workspace:Raycast(startPos, endPos - startPos, parameters)

                -- Check Result
                if not result then return nil end

                -- Ignore Non-Collidable
                if not result.Instance.CanCollide then
                    table.insert(filter, result.Instance)
                    continue
                end

                -- Return Result
                return result
            end
        end

        -- Ground State Tracking
        local groundState = false

        -- Check for collisions
        for _, collisionBox in ipairs(model.CollisionBoxes:GetChildren()) do
            local collisionBoxSize = collisionBox.Size

            -- Collision Detection
            local function CollisionHandler(rayOffset)
                -- Get Collider Position
                local colliderPosition = collisionBox.Position

                -- Raycast Calculations
                local rayStart = currentPosition + rayOffset
                local rayEnd = colliderPosition + positionChange + rayOffset

                -- Raycast
                local result = customCast(rayStart, rayEnd)

                -- Floor Handling
                if result then
                    -- Update Ground State
                    groundState = true

                    -- Calculate New Position
                    local colliderOffset = collisionBox.Position - currentPosition
                    newPosition = Vector3.new(newPosition.X, result.Position.Y, newPosition.Z) - Vector3.new(0, colliderOffset.Y, 0)

                    -- Calculate Collision Direction
                    local collisionDirection = result.Position - currentPosition

                    -- Arrest Velocity
                    if math.sign(self.velocities[model].Y) == math.sign(collisionDirection.Y) then
                        self.velocities[model] = Vector3.new(self.velocities[model].X, 0, self.velocities[model].Z)
                    end
                end
            end

            -- 2D Iterate
            for x = -collisionBoxSize.X / 2, collisionBoxSize.X / 2, 0.1 do
                for z = -collisionBoxSize.Z / 2, collisionBoxSize.Z / 2, 0.1 do
                    CollisionHandler(Vector3.new(x, 0, z))
                end
            end
        end

        -- Update Position
        self:SetPosition(model, newPosition)

        -- Propagate Grounded Events
        if self.groundedStates[model] ~= groundState then
            self.groundedStates[model] = groundState

            -- Fire Event
            if self.groundedEvents[model] then self.groundedEvents[model]:Fire(groundState) end
        end
    end
end

function Physics:IsGrounded(model)
    return self.groundedStates[model]
end

function Physics:GetGroundedEvent(model)
    if not self.groundedEvents[model] then
        self.groundedEvents[model] = Event.new()
    end

    return self.groundedEvents[model]
end

function Physics:SetPosition(model, position)
    -- Calculate Orientation
    local primaryCFrame = model.PrimaryPart.CFrame
    local primaryOrientation = primaryCFrame - primaryCFrame.Position

    -- Set CFrame
    model:SetPrimaryPartCFrame(primaryOrientation + position)
end

function Physics:GetPosition(model)
    return model.PrimaryPart.Position
end

function Physics:SetVelocity(model, velocity)
    self.velocities[model] = velocity
end

function Physics:SetAcceleration(model, acceleration)
    self.accelerations[model] = acceleration
end

function Physics:GetVelocity(model)
    return self.velocities[model]
end

function Physics:GetAcceleration(model)
    return self.accelerations[model]
end

function Physics:SetVelocityRange(model, min, max)
    self.velocityRestrictions[model] = {min = min, max = max}
end

return Physics