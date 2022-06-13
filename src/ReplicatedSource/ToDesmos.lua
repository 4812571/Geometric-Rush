local Grapher = {}
Grapher.__index = Grapher

function Grapher:AddPoint(x, y)
    table.insert(self.points, Vector2.new(x, y))
end

function Grapher:GetString()
    local str = ""

    for _, v in ipairs(self.points) do
        str = str .. (v.X .. "\t" .. v.Y .. "\n")
    end

    return str
end

function Grapher.new()
    local object = {
        points = {};
    }

    return setmetatable(object, Grapher)
end

return Grapher