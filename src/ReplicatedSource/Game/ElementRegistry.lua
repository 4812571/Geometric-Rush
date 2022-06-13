local ElementRegistry = {
    -- Class Cache
    classes = {};

    -- Part Cache
    models = {};

    -- Element Cache
    elements = {};
}

function ElementRegistry:Initialize()
    for _, v in ipairs(game.ReplicatedStorage.Source.Elements:GetChildren()) do
        self.classes[v.Name] = require(v)
    end
end

function ElementRegistry:Register(elementModel)
    -- Check
    if self:GetElementFromModel(elementModel) then return end

    -- Create Object
    local object = self.classes[elementModel.Element.Value].new(elementModel)

    -- Register Element
    self.elements[elementModel] = object

    -- Register Parts
    for _, v in ipairs(elementModel:GetChildren()) do
        self.models[v] = elementModel
    end

    return object
end

function ElementRegistry:GetElementFromModel(elementModel)
    return self.elements[elementModel]
end

function ElementRegistry:GetElementFromInstance(elementInstance)
    local model = self.models[elementInstance]
    local element = model and self.elements[model]

    return element
end

return ElementRegistry