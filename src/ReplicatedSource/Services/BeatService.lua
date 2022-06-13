local BeatService = {
    parts = {};
    bpm = 120;
}

function BeatService:Bind(part)
    self.parts[part] = part.Size;
end

function BeatService:Reset()
    self.parts = {}
end

function BeatService:Start(bpm)
    self.bpm = bpm
end

function BeatService:Update()
    local currentTime = os.clock()
    local bps = self.bpm / 60
    local beatPower = (math.sin(currentTime * bps * math.pi) ^ 2)

    for part, size in pairs(self.parts) do
        part.Size = size * math.max(beatPower, 0.1)
    end
end

return BeatService