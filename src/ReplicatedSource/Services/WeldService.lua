local WeldService = {}

local function weld(part1, part2)
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = part1
    weld.Part1 = part2

    return weld
end

function WeldService:WeldModel(model)
    local weldFolder = Instance.new("Folder")

    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            local weld = weld(v, model.PrimaryPart)
            weld.Parent = weldFolder
        end
    end

    weldFolder.Parent = model
end

function WeldService:UnanchorModel(model)
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") and v ~= model.PrimaryPart then
            v.Anchored = false
        end
    end
end

return WeldService