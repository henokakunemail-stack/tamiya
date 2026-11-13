function PageBattleResult:Trot_InitResultInfo(playerData)
    self:Trot_SetPersonScore(playerData)
end

---@param playerData BattleResultPlayerData
function PageBattleResult:Trot_SetPersonScore(playerData)
    local Root=self.pageTrotCG.gameObject
    CommonHelper:SetTrotGroupByData("Page_RaceTrotInfo", Root, RaceTrotManager:Get().RaceTrot)
    CommonHelper:SetSlider("SliderBaseColorBox", Root,0)
    CommonHelper:SetSliderAni("SliderBaseColorBox",Root,RaceTrotManager:Get():GetBoxScore()/RaceTrotManager:Get():GetMaxBoxScore())
    CommonHelper:SetText("###boxscore",Root,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotBoxNextScore,RaceTrotManager:Get():GetMaxBoxScore()-RaceTrotManager:Get():GetBoxScore()))

    local scrollView=UIUtil.GetTypeChildWightByParent("MoreRowScrollView_V",Root,typeof(MoreRowScrollView))
    local data=RaceTrotManager:Get():GetSourceBoxPoint()
    CommonHelper:SetGameObjectActive("MoreRowScrollView_V",Root,#data>0)
    CommonHelper:SetGameObjectActive("noscore",Root,#data==0)
    CommonHelper:InitMoreRowScrollView(scrollView,#data,1,function(index, itemObj,scroll)
        if data[index+1]==CommonCfgKey.RaceTrotContinueWin then
            local  value=CommonHelper:GetDictCalcData(data[index+1],true)
            value=stringSplit(value,":")
            local score=0
            if RaceTrotManager:Get():GetContinueWinSum()-1>#value then
                score=value[#value]
            else
                score=value[RaceTrotManager:Get():GetContinueWinSum()-1]
            end
            CommonHelper:SetText("###FailReasonText",itemObj,CommonHelper:GetTempStr_Default(string.format("dictcalc_%d",data[index+1]),RaceTrotManager:Get():GetContinueWinSum(),score   ))
        else
            local  value=CommonHelper:GetDictCalcData(data[index+1],false)
            CommonHelper:SetText("###FailReasonText",itemObj,CommonHelper:GetTempStr_Default(string.format("dictcalc_%d",data[index+1]),value))
        end

    end)
end
