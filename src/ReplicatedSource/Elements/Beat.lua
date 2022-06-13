local BeatService = require(game.ReplicatedStorage.Source.Services.BeatService)
local Element = require(game.ReplicatedStorage.Source.Elements.Element)

-- Class: Beat inherits from Element
local Beat = {}
setmetatable(Beat, Element)
Beat.__index = Beat

function Beat.new(model)
    -- Create Object
    local self = Element.new(model)

    -- Bind to BeatService
    BeatService:Bind(self.model.Beat)

    return setmetatable(self, Beat)
end

return Beat