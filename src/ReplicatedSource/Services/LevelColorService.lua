local TweenService = game:GetService("TweenService")

local LevelColorService = {
    parts = {};
}

function LevelColorService:Tween(color)
    -- Create tweens for every part. Tween their color to color.
    for part, _ in pairs(self.parts) do
        TweenService:Create(part.Texture, TweenInfo.new(3), {Color3 = color}):Play()
    end
end

function LevelColorService:StoreInitialColor(part)
    if not part:FindFirstChild("Texture") then return end

    self.parts[part] = part.Texture.Color3
end

function LevelColorService:Reset()
    for part, color in pairs(self.parts) do
        part.Texture.Color3 = color
    end
end

return LevelColorService