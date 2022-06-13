local MusicService = {
    currentMusic = nil;
}

function MusicService:Stop()
    if not self.currentMusic then return end

    self.currentMusic:Stop()
    self.currentMusic = nil
end

function MusicService:Play(musicName)
    self.currentMusic = workspace.Music:FindFirstChild(musicName)
    if self.currentMusic then 
        self.currentMusic:Stop()
        self.currentMusic:Play()
    end
end

return MusicService