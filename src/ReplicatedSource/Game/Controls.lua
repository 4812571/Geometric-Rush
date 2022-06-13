-- Game Services
local ContextActionService = game:GetService("ContextActionService")

local Controls = {}

function Controls:Update()
    if self.interacting then self.avatar:Interact() end
end

function Controls:Bind(avatar)
    -- Set Avatar
    self.avatar = avatar

    local function onInteract(actionName, inputState, inputObject)
        -- Input Processing
        if inputState == Enum.UserInputState.Begin then self.interacting = true end
        if inputState == Enum.UserInputState.End then self.interacting = false end
    end

    ContextActionService:BindAction("onInteract", onInteract, false, Enum.KeyCode.Space, Enum.KeyCode.Up, Enum.UserInputType.MouseButton1)
end

function Controls:Unbind()
    ContextActionService:UnbindAction("onInteract")
end

return Controls