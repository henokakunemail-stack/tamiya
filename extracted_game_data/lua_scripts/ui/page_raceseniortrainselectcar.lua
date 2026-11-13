---@class Page_RaceSeniorTrainSelectCar :Page_SelectCarBase
Page_RaceSeniorTrainSelectCar = class("Page_RaceSeniorTrainSelectCar", Page_SelectCarBase)
function Page_RaceSeniorTrainSelectCar:initialize()

end
---@param page_selectCar Page_SelectCar
function Page_RaceSeniorTrainSelectCar:SetData(root, param, page_selectCar)
    ---@type PVELevelData
    local levelData = param
    CommonHelper:HButtonSetCallback("BtnFight", root, function(data)
        if PlayerDataManager:Get():GetPlayerStamina()>=levelData.levelCfg.paypower then
            if page_selectCar then
                if levelData.levelCfg.copytype~=LevelType.GuideLevel then
                    if CarDataManager:Get():CheckCarCompleteness(page_selectCar:GetCurCar():GetID()) then
                        PlayerPrefsHelper:SetValue_PveChapterSelectTeam(page_selectCar:GetCurCar():GetID())
                        if levelData.levelCfg.maxenter>0 and levelData.count>= levelData.levelCfg.maxenter  then
                            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChapterLevelNoPassNum))
                        else
                            StoryHelper:TouchStory_SelectTeam(levelData.id, function()
                                RaceSeniorTrainSubsystem:Get():SendMsg_BattleBegin(levelData.id, page_selectCar:GetCurCar():GetID())
                            end)
                        end
                    end
                else
                    StoryHelper:TouchStory_SelectTeam(levelData.id, function()
                        RaceSeniorTrainSubsystem:Get():SendMsg_BattleBegin(levelData.id, 1)
                    end)
                end

            else
                StoryHelper:TouchStory_SelectTeam(levelData.id, function()
                    RaceSeniorTrainSubsystem:Get():SendMsg_BattleBegin(levelData.id, 1)
                end)
            end

        else
            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.PowerNotEnough))
        end

    end)
    self.BtnSwap = CommonHelper:HButtonSetCallback("BtnSwap", root, function(data)

        if levelData.starNum < 3 then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SwapLock))
        else
            if levelData.levelCfg.maxenter>0 and levelData.count>= levelData.levelCfg.maxenter  then
                CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChapterLevelNoPassNum))
            else
                -----@type dictcalc_config_cell
                --local value = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.SwapTicket)
                --local costcount = KnapsackDataManager:Get():GetArticleCountByCfgid(tonumber(value.varval))
                --if GameProperties.AreaType~=AreaType.AreaTypeCN then
                --    if costcount <= 0 then
                --        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SwapNoMoney))
                --        return
                --    end
               -- end
                CommonHelper:SetUnlockFunc({ GameFunction.Swap }, function()
                    UIManager:Get():OpenPopup("SwapView", CanvasType.FrontCanvas, "SwapView")
                    UINotify:Get():SendNotification(UINotifyEvent.SwapView_SetData, levelData)
                end)
            end
        end
    end)
    --  CommonHelper:SetHButtonClick(self.BtnSwap, levelData.starNum >= 3, false)

    CommonHelper:SetText("###tili", root, tostring(levelData.levelCfg.paypower))
    if levelData.levelCfg.maxenter>0 then
        CommonHelper:SetText("###passvalue", root, CommonHelper:GetTempStr_Default(TemplateStringID.ChapterLevelPassNum,levelData.count,levelData.levelCfg.maxenter))
    else
        CommonHelper:SetText("###passvalue", root, "")
    end

    local second=CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterDefaultTime)
    if levelData.personRecord>0 then
        second = self:ParseTime(levelData.personRecord)
    end
    CommonHelper:SetText("###playertime", root, second)
    if ReturnOldPlayerDataManager:Get():GetReturnState() and PlayerDataManager:Get():CheckReturnState() then
        local datetime = CommonHelper:ConvertIntToDataTime(ReturnOldPlayerDataManager:Get():GetReturnTime()*1000)
        CommonHelper:SetText("###returnoldplayer",root,CommonHelper:GetTempStr_Default(TemplateStringID.ReturnOldPlayerPveChapter,datetime.Year,datetime.Month,datetime.Day))
    else
        CommonHelper:SetText("###returnoldplayer",root,"")
    end
    CommonHelper:HButtonSetCallback("BtnLook",root,function(btnData)
        if #levelData.PveRankData > 0 and #levelData.PveRankData[1].times>0 then
            if  levelData.PveRankData[1].times[1]>0 then
                RaceSeniorTrainManager:Get():BeginHistoryBattle(levelData.id,levelData.PveRankData[1])
            end
        else
            CommonTipsHelper:Get():ShowCenterTips( CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterNoPlayerPass))
        end
    end)
    if levelData.PveRankData and #levelData.PveRankData > 0 and #levelData.PveRankData[1].times>0 and levelData.PveRankData[1].times[1]>0 then
        local second=CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterDefaultTime)
        if levelData.PveRankData[1].times[1]>0 then
            second = self:ParseTime(levelData.PveRankData[1].times[1])
        end
        CommonHelper:SetGameObjectActive("playericongroup/default", root, false)
        CommonHelper:SetGameObjectActive("playericongroup/icon", root, true)
        CommonHelper:SetText("###fastplayername", root, levelData.PveRankData[1].name)
        CommonHelper:SetText("###fastplayertime", root, second)
        CommonHelper:SetPlayerIconById("playericongroup", root, levelData.PveRankData[1].icon,levelData.PveRankData[1].ic,nil,UIModuleID.SelectTeam)
    else
        local second = self:ParseTime(0)
        CommonHelper:SetText("###fastplayername", root, CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterNoPlayerPass))
        CommonHelper:SetText("###fastplayertime", root, CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterDefaultTime))
        CommonHelper:SetGameObjectActive("playericongroup/default", root, true)
        CommonHelper:SetGameObjectActive("playericongroup/icon", root, false)
    end

    for i = 1, 3 do
        local leveltip = UIUtil.GetChild("leveltip" .. i, root)
        CommonHelper:SetText("###leveltip", leveltip, levelData.starParam[1][i])
        CommonHelper:SetText("###leveltippass", leveltip, levelData.starParam[1][i])
        CommonHelper:SetGameObjectActive("nopass", leveltip, not levelData:CheckStarState(i))
        CommonHelper:SetGameObjectActive("pass", leveltip, levelData:CheckStarState(i))
        CommonHelper:SetGameObjectActive("leveltip", leveltip, not levelData:CheckStarState(i))
        CommonHelper:SetGameObjectActive("leveltippass", leveltip, levelData:CheckStarState(i))
    end
    local firstdown= CommonHelper:GetRewardByDictDownId(levelData.levelCfg.firstdown)
    local copydownids = stringSplitToNumber(levelData.levelCfg.copydowns,':')
    local ccpydowns={}
    for i = 1, #copydownids do
        table.insert(ccpydowns,CommonHelper:GetRewardByDictDownId(copydownids[i]))
    end
    ---@type table<number, table<number, RewardData>>
    local datalist = {}
    if firstdown then
        for i = 1, #firstdown do
            table.insert(datalist, { true, firstdown[i]})
        end
    end
    if ccpydowns then
        for i = 1, #ccpydowns do
            for j = 1, #ccpydowns[i] do
                table.insert(datalist,{ false, ccpydowns[i][j]})
            end
        end
    end
    local count=#datalist>=4 and #datalist or 4
    local moreRowScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(moreRowScrollView, count, 1, function(index, itemObj, scroll)
        local temp = datalist[index + 1]
        if temp then
            local isfirst = temp[1]
            local reward = temp[2]
            local obj = UIUtil.GetChild("ItemCom_118", itemObj)
            local param = Param_ItemArticleParam()
            param.count = reward.num
            CommonHelper:SetItemComGroup(obj, UIModuleID.SelectTeam,reward.id,param,function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.SelectTeam)
            end,reward.id)
            CommonHelper:SetGameObjectActive("ItemCom_118", itemObj, true)
            CommonHelper:SetGameObjectActive("first", itemObj, isfirst)
            CommonHelper:SetGameObjectActive("odd", itemObj, false)
        else
            CommonHelper:SetGameObjectActive("ItemCom_118", itemObj, false)
            CommonHelper:SetGameObjectActive("first", itemObj, false)
            CommonHelper:SetGameObjectActive("odd", itemObj, false)
        end

    end)

end

function Page_RaceSeniorTrainSelectCar:Refresh(root,levelId)
    local levelData=RaceSeniorTrainManager:Get():GetLevelDataByLevelId(levelId)
    if levelData.levelCfg.maxenter>0 then
        CommonHelper:SetText("###passvalue",root, CommonHelper:GetTempStr_Default(TemplateStringID.ChapterLevelPassNum,levelData.count,levelData.levelCfg.maxenter))
        CommonHelper:SetGameObjectActive("myrecord_bg (1)/tittle",root,true)
    else
        CommonHelper:SetText("###passvalue", root, "")
        CommonHelper:SetGameObjectActive("myrecord_bg (1)/tittle",root,false)
    end
end

