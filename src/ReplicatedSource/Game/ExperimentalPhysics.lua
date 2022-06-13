local Event = require(game.ReplicatedStorage.Source.Core.Event)

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

    -- Cache parts
    parts = {};
}

function Physics:AddModel(model)
    self.objects[model] = true
    self.velocities[model] = Vector3.new(0, 0, 0)
    self.accelerations[model] = Vector3.new(0, 0, 0)
    self.groundedStates[model] = false
    self.colliders[model] = model.CollisionBoxes:GetChildren()
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
    model:SetPrimaryPartCFrame(CFrame.new(position))
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

function Physics:SetVelocityRestriction(model, min, max)
    self.velocityRestrictions[model] = {
        min = min,
        max = max
    }
end

function Physics:GetVelocity(model)
    return self.velocities[model]
end

function Physics:GetAcceleration(model)
    return self.accelerations[model]
end

function Physics:SetVelocityRange(model, min, max)
    self.velocityRestrictions[model] = {min, max}
end

-- Vector Helpers
local function vAbs(v0) return Vector3.new(math.abs(v0.X), math.abs(v0.Y), math.abs(v0.Z)) end

function Physics:Update(delta)
    -- Delete Visuals
    for part, _ in pairs(self.parts) do
        part:Destroy()
    end
    self.parts = {}

    -- Update Velocities
    for model, _ in pairs(self.objects) do
        self.velocities[model] += self.accelerations[model] * delta
    end

    -- Handle Constraints
    for model, _ in pairs(self.objects) do
        -- Skip Non-Restricted
        if not self.velocityRestrictions[model] then continue end

        -- Get Min/Max
        local min = self.velocityRestrictions[model].min or Vector3.new(-math.huge, -math.huge, -math.huge)
        local max = self.velocityRestrictions[model].max or Vector3.new( math.huge,  math.huge,  math.huge)

        -- Clamp Function
        local function vClamp(v, min, max)
            return Vector3.new(
                math.max(math.min(v.X, max.X), min.X),
                math.max(math.min(v.Y, max.Y), min.Y),
                math.max(math.min(v.Z, max.Z), min.Z)
            )
        end

        -- Clamp Velocities
        self.velocities[model] = vClamp(self.velocities[model], min, max)
    end

    -- Move Models
    for model, _ in pairs(self.objects) do
        -- Get Velocity
        local velocity = self.velocities[model]

        -- Calculate Delta
        local positionChange = velocity * delta

        -- Get Positions
        local currentPosition = model.PrimaryPart.Position
        local nextPosition = currentPosition + positionChange

        -- Check Collisions
        for _, collider in ipairs(self.colliders[model]) do
            -- Get Collider Info
            local colliderPosition = collider.Position
            local colliderSize = collider.Size

            -- Calculate Collision Span
            print(colliderSize, positionChange)
            local spanSize = colliderSize + vAbs(positionChange)
            local spanPosition = (colliderPosition + colliderPosition + positionChange) / 2

            -- Grounded State
            local grounded = false

            -- Display Parts
            local visual = collider:Clone()
            visual.Color = Color3.new(1, 0, 0)
            visual.Transparency = 0.5
            visual.CFrame = CFrame.new(spanPosition)
            visual.Size = spanSize
            visual.CanCollide = false
            visual.Parent = collider.Parent
            self.parts[visual] = true

            -- Check Collision
            for _, part in ipairs(workspace:GetPartBoundsInBox(CFrame.new(spanPosition), spanSize)) do
                -- Ignore
                if part:IsDescendantOf(model) then continue end
                if not part.CanCollide then continue end

                -- Print
                print("Collision Detected", part.Name)

                -- Get Collision Direction
                local collisionDirection = part.Position - colliderPosition

                -- Handle Bounce
                self.velocities[model] = Vector3.new(
                    velocity.X,
                    math.sign(velocity.Y) == math.sign(collisionDirection.Y) and 0 or velocity.Y,
                    velocity.Z
                )

                -- Calculate Overlap
                local overlap = (part.Size) - vAbs(collisionDirection)

                -- Set New Position
                print("[Physics]", math.sign(velocity.Y), overlap.Y)

                nextPosition = Vector3.new(
                    nextPosition.X,
                    nextPosition.Y - math.sign(velocity.Y) * overlap.Y,
                    nextPosition.Z
                )

                -- Print
                print("Adjusting Position", - math.sign(velocity.Y) * overlap.Y)

                -- Update Grounded State
                grounded = true

                break
            end

            -- Update Position
            model:SetPrimaryPartCFrame(CFrame.new(nextPosition))

            -- Update Grounded State
            self.groundedStates[model] = grounded

            -- Fire Event
            if grounded ~= self.groundedStates[model] and self.groundedEvents[model] then
                self.groundedEvents[model]:Fire(grounded)
            end
        end
    end
end

return Physics