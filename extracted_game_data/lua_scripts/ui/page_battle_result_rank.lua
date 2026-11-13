function PageBattleResult:Rank_InitResultInfo(playerData)
    self:Rank_SetPersonScore(playerData)
end

---@param playerData BattleResultPlayerData
function PageBattleResult:Rank_SetPersonScore(playerData)
    --local battleResultScore = playerData:GetRank() <= 3 and 3 - playerData:GetRank() + 1 or 3 - playerData:GetRank()

    local rank=playerData:GetError() == BattleFailError.None and playerData:GetRank() or 6

    local battleResultScore = RaceRankManager:Get():GetAddScore()

    local score = PlayerDataManager:Get():GetRankScore()
    ---@type qualifyingrank_config_cell
    local curcfg, minscore, maxscore = CommonHelper:GetRankCfgByScore(score)
    local process = (score - minscore) / (maxscore - minscore)
    if score > maxscore then
        CommonHelper:SetSlider("scoreslider", self.pageRankCG.gameObject,0)
        CommonHelper:SetSliderAni("scoreslider", self.pageRankCG.gameObject, 1)
        CommonHelper:SetText("###scoreprocess", self.pageRankCG.gameObject, score)
    else
        CommonHelper:SetSlider("scoreslider", self.pageRankCG.gameObject,0)
        CommonHelper:SetSliderAni("scoreslider", self.pageRankCG.gameObject, process)
        CommonHelper:SetText("###scoreprocess", self.pageRankCG.gameObject, (score - minscore) .. "/" .. (maxscore - minscore))
    end
    CommonHelper:SetRankIconGroup("rankicon_l", self.pageRankCG.gameObject, curcfg)
    CommonHelper:SetRankIconGroup("rankicon_s_4", self.pageRankCG.gameObject, curcfg)
    CommonHelper:SetText("###getscore", self.pageRankCG.gameObject, battleResultScore)
end
