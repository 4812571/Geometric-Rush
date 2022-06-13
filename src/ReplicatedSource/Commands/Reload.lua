local levelName = "Level Easy"
local level = workspace.Models.Levels[levelName]
local newLevel = Instance.new("Folder")
newLevel.Name = levelName

for _, v in ipairs(level:GetChildren()) do
    if v:IsA("Model") then
        local newModel = workspace.Models.Elements[v.Name]:Clone()
        newModel:SetPrimaryPartCFrame(v.PrimaryPart.CFrame)
        newModel.Parent = newLevel
    else
        v:Clone().Parent = newLevel
    end
end

newLevel.Parent = level.Parent
level:Destroy()