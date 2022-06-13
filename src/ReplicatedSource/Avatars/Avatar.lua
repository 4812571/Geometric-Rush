local TweenService = game:GetService("TweenService")

local Physics = require(game.ReplicatedStorage.Source.Game.Physics)
local Scroller = require(game.ReplicatedStorage.Source.Game.Scroller)
local Event = require(game.ReplicatedStorage.Source.Core.Event)

local Avatar = {}
Avatar.__index = Avatar

function Avatar.new(model, AvatarType)
    local self = {
        -- Type
        avatarType = AvatarType;

        -- Model
        model = model;

        -- Boxes
        hurtBoxes = model.HurtBoxes:GetChildren();
        collisionBoxes = model.CollisionBoxes:GetChildren();

        -- State
        interacting = false;
        alive = true;

        -- Events
        died = Event.new();
    }

    -- Bind Physics
    Physics:AddModel(self.model)

    return setmetatable(self, Avatar)
end

function Avatar:GetAvatarType()
    return self.avatarType
end

function Avatar:Update()
    -- Alive Check
    if not self.alive then return end

    -- Height Check
    local height = self.model.PrimaryPart.Position.Y

    -- Kill
    if height > 100 or height < -100 then
        self:Kill()
        return false
    end

    Scroller:SetScroll(self.model.Cube.Position.X)
    Scroller:Update()

    -- Reset Interaction
    self.interacting = false

    -- Pass State
    return true
end

-- State Methods
function Avatar:Interact()
    self.interacting = true
end

function Avatar:IsInteracting()
    return self.interacting
end

-- Physics Methods
function Avatar:InvertGravity()
    local acceleration = Physics:GetAcceleration(self.model)
    Physics:SetAcceleration(self.model, Vector3.new(acceleration.X, -acceleration.Y, acceleration.Z))
end

function Avatar:Boost(boost)
    local gravitySign = math.sign(Physics:GetAcceleration(self.model).Y)

    -- Get Velocity
    local velocity = Physics:GetVelocity(self.model)
    Physics:SetVelocity(self.model, Vector3.new(velocity.X, boost * -gravitySign, velocity.Z))
end

function Avatar:GetModel()
    return self.model
end

function Avatar:GetHurtBoxes()
    return self.hurtBoxes
end

function Avatar:GetCollisionBoxes()
    return self.collisionBoxes
end

function Avatar:IsAlive()
    return self.alive
end

function Avatar:Destroy()
    self.alive = false
    Physics:RemoveModel(self.model)
    self.model:Destroy()
end

function Avatar:Kill()
    -- Play Explosion Effect
    local explosion = game.ReplicatedStorage.Models.Effects.Explosion:Clone()
    explosion.Position = self.model.Cube.Position

    -- Load Explosion
    explosion.Parent = game.Workspace

    -- Create Tween
    local tween = TweenService:Create(explosion, TweenInfo.new(0.4), {Size = Vector3.new(0.5, 7, 7), Transparency = 1})

    -- Tween Clean
    local function onTweenComplete()
        -- Destroy Instances
        explosion:Destroy()
        tween:Destroy()

        -- Cinematic Wait
        task.wait(0.3)

        -- Fire Event
        self.died:Fire()
    end

    -- Play Tween
    tween:Play()

    -- Pulse Emitter
    local function pulseEmmitter()
        -- Disable Emitter
        task.wait()
        explosion.Emitter.Enabled = false

        -- Enable Emitter
        task.wait()
        explosion.Emitter.Enabled = true
    end

    -- Start Pulse
    task.spawn(pulseEmmitter)

    -- Connect Tween
    tween.Completed:Connect(onTweenComplete)

    self:Destroy()
end

return Avatar