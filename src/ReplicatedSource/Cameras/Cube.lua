local CoreCamera = require(script.Parent.Core)

local CubeCamera = {
    minHeight = 2.3;
}

function CubeCamera:Update(delta, cubePosition)
    -- Update Camera Scroll
    local cameraScroll = cubePosition.X

    -- Update Camera Height
    local cameraHeight = math.max(self.minHeight, cubePosition.Y - 3)

    -- Update Camera CFrame
    CoreCamera:Update(delta, Vector3.new(cameraScroll, cameraHeight, 0))
end

return CubeCamera