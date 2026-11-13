function PageBattleResult:RaceGVG_InitResultInfo(playerData)
    self:RaceGVG_SetPersonScore(playerData)
end

---@param playerData BattleResultPlayerData
function PageBattleResult:RaceGVG_SetPersonScore(playerData)
    local Root=self.pageClubGVGCG.gameObject
    CommonHelper:SetGameObjectActive("battleresult_bg_win", Root, playerData:GetError() <= BattleFailError.None)
    CommonHelper:SetGameObjectActive("battleresult_bg_lose", Root, playerData:GetError() > BattleFailError.None)
    CommonHelper:SetText("###FailReasonText1", Root, CommonHelper:GetTempStr_BattleFailM_ErrorTips(playerData:GetError()))
   if playerData:GetError() <= BattleFailError.None then
       CommonHelper:SetText("###ExpCountText",Root,CommonHelper:GetTempStr_Default(TemplateStringID.Club3V3AddScore,RaceGVGManager:Get():GetAddScore()))
       ---@type SC_RetGvgPointStart
        local value= RaceGVGManager:Get():GetCurBattle()
        ---@type dictgvgpointspeed_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictgvgpointspeed_config)
        ---@type dictgvgpointspeed_config_cell[]
        local data=table.GetSpeedTableByTrackId(value.trackid)
       if data then
           local scrollView=UIUtil.GetTypeChildWightByParent("MoreRowScrollView_V",Root,typeof(MoreRowScrollView))
           CommonHelper:InitMoreRowScrollView(scrollView,#data,1,function(index, itemObj,scroll)
               local startTime=""
               local endTime=""
               --时间达到%s 加%d分
               if data[index+1].begintime == 0 then
                   startTime=CommonHelper:GetTempStr_Default(TemplateStringID.BattleResultTime)
               else
                   startTime = CommonHelper:TransferTimeToString(CommonHelper:TransferTime(data[index+1].begintime))
               end
               if data[index+1].endtime == 0 then
                   endTime=CommonHelper:GetTempStr_Default(TemplateStringID.BattleResultTime)
               else
                   endTime = CommonHelper:TransferTimeToString(CommonHelper:TransferTime(data[index+1].endtime))
               end
               if data[index+1].begintime==0 then
                   CommonHelper:SetText("###FailReasonText",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.Club3V3HighAddScore,endTime,data[index+1].pointnum))
               else
                   CommonHelper:SetText("###FailReasonText",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.Club3V3TimeAddScore,endTime,data[index+1].pointnum))
               end
               CommonHelper:SetGameObjectActive("unlock",itemObj,RaceGVGManager:Get():GetAddScore()==data[index+1].pointnum)
               CommonHelper:SetGameObjectActive("lock",itemObj,RaceGVGManager:Get():GetAddScore()~=data[index+1].pointnum)
           end)
       end

    end
    CommonHelper:HButtonSetCallback("BtnHelp", Root, function()
        CommonHelper:OpenEncyclopedia(EncyclopediaPage.Parts)
    end)
    self.BtnHelpError= CommonHelper:HButtonSetCallback("BtnHelpError", Root, function()
        CommonHelper:ShowHelpView(playerData:GetError())
    end)
    CommonHelper:SetHButtonClick(self.BtnHelpError,false,true)
    CommonHelper:SetText("###FailReasonText", Root, CommonHelper:GetTempStr_BattleFailM_ErrorTips(playerData:GetError()))

end
