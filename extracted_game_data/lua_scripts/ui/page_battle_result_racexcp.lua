function PageBattleResult:XCP_InitResultInfo(playerData)
    self:XCP_SetPersonScore(playerData)
end

---@param playerData BattleResultPlayerData
function PageBattleResult:XCP_SetPersonScore(playerData)
    --local battleResultScore = playerData:GetRank() <= 3 and 3 - playerData:GetRank() + 1 or 3 - playerData:GetRank()
    local Root=self.pageJCPCG.gameObject

    CommonHelper:SetGameObjectActive("battleresult_bg_win", Root, playerData:GetError() <= BattleFailError.None)
    CommonHelper:SetGameObjectActive("battleresult_bg_lose", Root, playerData:GetError() > BattleFailError.None)
    CommonHelper:SetText("###FailReasonText1", Root, CommonHelper:GetTempStr_BattleFailM_ErrorTips(playerData:GetError()))
    CommonHelper:HButtonSetCallback("BtnHelp", Root, function()
        CommonHelper:OpenEncyclopedia(EncyclopediaPage.Parts)
    end)
    self.BtnHelpError= CommonHelper:HButtonSetCallback("BtnHelpError", Root, function()
        CommonHelper:ShowHelpView(playerData:GetError())
    end)
    CommonHelper:SetHButtonClick(self.BtnHelpError,false,true)

end
