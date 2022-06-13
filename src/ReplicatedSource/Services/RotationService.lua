local RotationService = {
    models = {};
    rotations = {};
    positions = {};
    bobbingAmount = {};
}

function RotationService:AddItem(model, rotationAngles, bobbingAmount)
    self.models[model] = true
    self.rotations[model] = rotationAngles
    self.bobbingAmount[model] = bobbingAmount
    self.positions[model] = model.PrimaryPart.Position
end

function RotationService:Update(delta)
    -- Get Current Time
    local currentTime = os.clock()

    for model, _ in pairs(self.models) do
        -- Calcuylate Bobbing Scalar
        local bobbingScalar = math.sin(currentTime * 4 + model.PrimaryPart.Position.X * 0.33)

        -- Get Current CFrame
        local currentCFrame = model.PrimaryPart.CFrame

        -- Calculate Rotation Amount
        local rotationAmount = self.rotations[model] * delta
        local rotationCFrame = CFrame.Angles(rotationAmount.X, rotationAmount.Y, rotationAmount.Z)

        -- Extract Angles
        local currentAngles = currentCFrame - currentCFrame.Position

        -- Generate New CFrame
        local newCFrame = CFrame.new(self.positions[model]) * currentAngles * rotationCFrame + Vector3.new(0, self.bobbingAmount[model] * bobbingScalar, 0)

        -- Set New CFrame
        model:SetPrimaryPartCFrame(newCFrame)
    end
end

return RotationService