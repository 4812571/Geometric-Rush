local CoreCamera = require(script.Parent.Core)
local Scroller = require(game.ReplicatedStorage.Source.Game.Scroller)

local CubeCamera = {
    height = 5;
}

function CubeCamera:Update(delta, shipPosition)
    -- Update Camera Scroll
    local cameraScroll = shipPosition.X

    -- Update Camera CFrame
    CoreCamera:Update(delta, Vector3.new(cameraScroll, self.height + Scroller:GetFloorHeight(), 0))
end

return CubeCamera