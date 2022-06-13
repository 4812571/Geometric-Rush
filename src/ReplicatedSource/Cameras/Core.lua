local Scroller = require(game.ReplicatedStorage.Source.Game.Scroller)

local CoreCamera = {
    viewHeight = 11;
    viewAngle = 1;

    -- Camera Data
    cameraFocus = Vector3.new(0, 5, 0);
    cameraSpeed = 5;

    -- Shutter Data
    shutterOpeningSize = 10;
    shutterOpeningSpeed = 10;

    -- Shutter Maxes
    shutterOpeningMax = 10;

    -- ShutterOpen
    shutterOpen = true;

    -- Shutter References
    shutterTop = workspace.Scene.Shutter.U;
    shutterBottom = workspace.Scene.Shutter.D;
}

function CoreCamera:InstantOpenShutter()
    self.shutterOpen = true
    self.shutterOpeningSize = self.shutterOpeningMax
end

function CoreCamera:CloseShutter()
    self.shutterOpen = false
end

function CoreCamera:OpenShutter()
    self.shutterOpen = true
end

function CoreCamera:Update(delta, position)
    -- Index Camera
    local camera = workspace.currentCamera

    -- Set Camera Properties
    camera.CameraType = Enum.CameraType.Scriptable
    camera.FieldOfView = self.viewAngle

    -- Calculate Camera Distance
    local cameraRadians = math.rad(self.viewAngle)
    local cameraDistance = self.viewHeight / math.tan(cameraRadians)

    -- Camera Target Position
    local cameraTargetPosition = position * Vector3.new(1, 1, 0)

    -- Calculate Next Camera Position
    local cameraNextY = self.cameraFocus.Y + (cameraTargetPosition.Y - self.cameraFocus.Y) * math.min(1, delta * self.cameraSpeed)
    local cameraNextPosition = Vector3.new(cameraTargetPosition.X + 4, cameraNextY, 0)

    -- Update Camera CFrame
    camera.CFrame = CFrame.lookAt(cameraNextPosition + Vector3.new(0, 0, cameraDistance), cameraNextPosition)
    self.cameraFocus = cameraNextPosition

    -- Update Shutter Data
    if self.shutterOpen then
        self.shutterOpeningSize = math.clamp(self.shutterOpeningSize + self.shutterOpeningSpeed * delta, 0, self.shutterOpeningMax)
    else
        self.shutterOpeningSize = math.clamp(self.shutterOpeningSize - self.shutterOpeningSpeed * delta, 0, self.shutterOpeningMax)
    end

    -- Calculate Positions
    local centerPosition = Vector3.new(camera.CFrame.Position.X, camera.CFrame.Position.Y, 0)
    local offset = Vector3.new(0, self.shutterOpeningSize + 0.5 * self.shutterTop.Size.Y, 0)

    -- Set Shutter Properties
    local forwardOffset = Vector3.new(0, 0, 10)
    self.shutterTop.Position = centerPosition + forwardOffset + offset
    self.shutterBottom.Position = centerPosition + forwardOffset - offset
end

return CoreCamera