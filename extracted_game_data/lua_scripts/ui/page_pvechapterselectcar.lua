---@class Page_PveChapterSelectCar :Page_SelectCarBase
Page_PveChapterSelectCar = class("Page_PveChapterSelectCar", Page_SelectCarBase)
function Page_PveChapterSelectCar:initialize()

end
---@param page_selectCar Page_SelectCar
function Page_PveChapterSelectCar:SetData(root, param, page_selectCar)
    ---@type PVELevelData
    local levelData = param
    local page_more=  CommonHelper:SetGameObjectActive("page_more",root,#levelData:GetBattleInfo()>1)
    local page_one= CommonHelper:SetGameObjectActive("page_one",root,#levelData:GetBattleInfo()<=1)
    if #levelData:GetBattleInfo()<=1 then
        root=page_one
        self:SetOne(root, param, page_selectCar)
    end
    if #levelData:GetBattleInfo()>1 then
        root=page_more
        self:SetMore(root, param, page_selectCar)
    end

    CommonHelper:HButtonSetCallback("BtnFight", root, function(data)
        if PlayerDataManager:Get():GetPlayerStamina()>=levelData.levelCfg.paypower then
            if page_selectCar then
                if levelData.levelCfg.maxenter>0 and levelData.count>= levelData.levelCfg.maxenter  then
                    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChapterLevelNoPassNum))
                else
                    if #levelData:GetBattleInfo()>1 then
                        local flag=true
                        for i = 1, #levelData:GetBattleInfo() do
                            if self.Cars[i].CarIdx>0 then
                                if CarDataManager:Get():CheckCarCompleteness(self.Cars[i].CarIdx) then
                                else
                                    flag=false
                                    break
                                end
                            else
                                if CarDataManager:Get():GetCarNum()<#levelData:GetBattleInfo() then
                                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarPleaseOpenCar))
                                    return
                                end
                                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChapterMoreCarNoCar))
                                return
                            end
                        end
                        if flag then
                            local caridx=""
                            for i = 1, #levelData:GetBattleInfo() do
                                if i>=#levelData:GetBattleInfo() then
                                    caridx=caridx..self.Cars[i].CarIdx
                                else
                                    caridx=caridx..self.Cars[i].CarIdx..":"
                                end
                            end
                            StoryHelper:TouchStory_SelectTeam(levelData.id, function()
                                ChapterSubsystem:Get():SendMsg_BattleBegin(levelData.id, caridx)
                            end)
                        else

                        end
                    else
                        if CarDataManager:Get():CheckCarCompleteness(page_selectCar:GetCurCar():GetID()) then
                            PlayerPrefsHelper:SetValue_PveChapterSelectTeam(page_selectCar:GetCurCar():GetID())
                            StoryHelper:TouchStory_SelectTeam(levelData.id, function()
                                if levelData and page_selectCar and  page_selectCar:GetCurCar() then
                                    ChapterSubsystem:Get():SendMsg_BattleBegin(levelData.id, page_selectCar:GetCurCar():GetID())
                                end
                            end)
                        end
                    end
                end
        else
            StoryHelper:TouchStory_SelectTeam(levelData.id, function()
                ChapterSubsystem:Get():SendMsg_BattleBegin(levelData.id, 1)
            end)
        end

        else
              CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.PowerNotEnough))
        end
    end)
    self.BtnSwap = CommonHelper:HButtonSetCallback("BtnSwap", root, function(data)

        if levelData.starNum < 3*#levelData:GetBattleInfo() then
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
                --end
                CommonHelper:SetUnlockFunc({ GameFunction.Swap }, function()
                    UIManager:Get():OpenPopup("SwapView", CanvasType.FrontCanvas, "SwapView")
                    UINotify:Get():SendNotification(UINotifyEvent.SwapView_SetData, levelData)
                end)
            end
        end
    end)
    self.BtnRankList = CommonHelper:HButtonSetCallback("BtnRankList", root, function(data)
        if #levelData.PveRankData > 0 and  levelData.PveRankData[1].times[1] and  levelData.PveRankData[1].times[1]>0 then
            ChapterSubsystem:Get():SendMsg_ChapterRankList(levelData.id,RankingListType.PveChapter)
        else
           CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterNoPlayerPass))
        end
    end)
    --  CommonHelper:SetHButtonClick(self.BtnSwap, levelData.starNum >= 3, false)

    CommonHelper:SetText("###tili", root, tostring(levelData.levelCfg.paypower))
    if levelData.levelCfg.maxenter>0 then
        CommonHelper:SetText("###passvalue", root, CommonHelper:GetTempStr_Default(TemplateStringID.ChapterLevelPassNum,levelData.count,levelData.levelCfg.maxenter))
    else
        CommonHelper:SetText("###passvalue", root, "")
    end

end

function Page_PveChapterSelectCar:Refresh(root,levelId)
    local levelData=PVEChapterDataManager:Get():GetLevelDataByLevelId(levelId)
    if levelData.levelCfg.maxenter>0 then
        CommonHelper:SetText("###passvalue",root, CommonHelper:GetTempStr_Default(TemplateStringID.ChapterLevelPassNum,levelData.count,levelData.levelCfg.maxenter))
        CommonHelper:SetGameObjectActive("myrecord_bg (1)/tittle",root,true)
    else
        CommonHelper:SetText("###passvalue", root, "")
        CommonHelper:SetGameObjectActive("myrecord_bg (1)/tittle",root,false)
    end
end
function Page_PveChapterSelectCar:SetOne(root, param, page_selectCar)
    ---@type PVELevelData
    local levelData = param
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
        if #levelData.PveRankData > 0 and levelData.PveRankData[1].times[1]>0 then
            PVEChapterDataManager:Get():BeginHistoryBattle(levelData.id,levelData.PveRankData[1])
        else
            CommonTipsHelper:Get():ShowCenterTips( CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterNoPlayerPass))
        end
    end)
    if #levelData.PveRankData > 0 and  levelData.PveRankData[1].times[1] and  levelData.PveRankData[1].times[1]>0 then
        local second=CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterDefaultTime)
        if levelData.PveRankData[1].times[1]>0 then
            second = self:ParseTime(levelData.PveRankData[1].times[1])
        end
        CommonHelper:SetGameObjectActive("playericongroup/default", root, false)
        CommonHelper:SetGameObjectActive("playericongroup/icon", root, true)
        CommonHelper:SetText("###fastplayername", root, levelData.PveRankData[1].name)
        CommonHelper:SetText("###fastplayertime", root, second)
        CommonHelper:SetPlayerIconById("playericongroup", root, levelData.PveRankData[1].icon,levelData.PveRankData[1].IconFrame,nil,UIModuleID.SelectTeam)
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
    local superparts= CommonHelper:GetSuperPartsByItemId(levelData.levelCfg.GiftPartId)
    local copydownids = stringSplitToNumber(levelData.levelCfg.copydowns,':')
    local ccpydowns={}
    for i = 1, #copydownids do
        table.insert(ccpydowns,CommonHelper:GetRewardByDictDownId(copydownids[i]))
    end
    ---@type table<number, table<number, RewardData>>
    local datalist = {}
    if levelData.winSum<=0 then
        if superparts then
            for i = 1, levelData.levelCfg.GiftPartNum do
                for k, v in pairs(superparts) do
                    local temp=RewardData()
                    temp:SetDataIdNum(v.partid,1,0)
                    table.insert(datalist, { true, temp,levelData.levelCfg.GiftPartId})
                end
            end
        else
            for i = 1, #firstdown do
                table.insert(datalist, { true, firstdown[i]})
            end
        end
    end
    for i = 1, #ccpydowns do
        for j = 1, #ccpydowns[i] do
            table.insert(datalist,{ false, ccpydowns[i][j]})
        end
    end
    ---@type dictgiftpart_config
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictgiftpart_config)
    local count=#datalist>=4 and #datalist or 4
    local moreRowScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(moreRowScrollView, count, 1, function(index, itemObj, scroll)
        local temp = datalist[index + 1]
        if temp then
            local isfirst = temp[1]
            local reward = temp[2]
            local giftId = temp[3]
            local obj = UIUtil.GetChild("ItemCom_118", itemObj)

            local param = Param_ItemArticleParam()
            param.count = reward.num
            local type=ItemPartUIType.Simple
            if giftId then
                local reform= cfg.GetPartDataByGiftId(giftId,reward.id)
                if reform then
                    param.generation=reform.partage
                    param.star=reform.partstart
                    param.lv=reform.partlev
                    param.awaken=reform.partbreak==1
                    type=ItemPartUIType.Normal
                end
            end
            CommonHelper:SetItemComGroup(itemObj, UIModuleID.SelectTeam, reward.id, param, function(btnData)
                local reform= cfg.GetPartDataByGiftId(giftId,btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.SelectTeam, false,reform)
            end, reward.id,type)
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
function Page_PveChapterSelectCar:SetMore(root, param, page_selectCar)
    self.PreCarFive=page_selectCar
    ---@type PVELevelData
    local levelData = param
    local BattleInfo=levelData:GetBattleInfo()
    self.Cars={{CarIdx=0,State=CarSelectStatus.None},{CarIdx=0,State=CarSelectStatus.None},{CarIdx=0,State=CarSelectStatus.None},{CarIdx=0,State=CarSelectStatus.None},{CarIdx=0,State=CarSelectStatus.None}}
    self.TogGroup={}
    self.CarTogGroup={}
    self.SelectCarGroup={}
    self.NpcObjGroup={}
    for i = 1, 5 do
        local item=UIUtil.GetChild("NpcGroup"..i,root)
        CommonHelper:SetGameObjectActive("bgplayer",item,BattleInfo[i]~=nil)
        CommonHelper:SetGameObjectActive("bgnull",item,BattleInfo[i]==nil)
        if BattleInfo[i] then
            self.NpcObjGroup[i]=item
            CommonHelper:SetGameObjectActive("normal_bg",item,levelData.levelCfg.copytype==1)
            CommonHelper:SetGameObjectActive("elite_bg",item,levelData.levelCfg.copytype==2)
            CommonHelper:SetGameObjectActive("boss_bg",item,levelData.levelCfg.copytype==3)
            local name,icon = CommonHelper:AnalyseNPCNameAndIconById(BattleInfo[i].NpcIds[1])
            CommonHelper:GetComponentSetUITexture("npcicon",item,icon,UIModuleID.SelectTeam)
            self.TogGroup[i]=CommonHelper:HButtonSetCallback("Toggle",item,function(hbtn)
                if self.Cars[self.CurSelectTrack].CarIdx~=0 then
                    self.PreCarFive:SetState(self.Cars[self.CurSelectTrack].CarIdx,CarSelectStatus.Use)
                    self:SetCarState(self.CurSelectTrack,self.Cars[self.CurSelectTrack].CarIdx,CarSelectStatus.Use)
                end
                self:SetTogState(hbtn.intData)
            end,i)
            self.CarTogGroup[i]={}
            for j = 1, 5 do
                self.CarTogGroup[i][j]=CommonHelper:HButtonSetCallback("Pos"..j.."/open/BtnPos",item,function(hbtn)

                end,j)
            end
            self.SelectCarGroup[i]=CommonHelper:HButtonSetCallback("BtnSelect",item,function(hbtn)
                if self.Cars[hbtn.intData].CarIdx~=0 and self.Cars[hbtn.intData].State==CarSelectStatus.Use  then
                    if self.Cars[hbtn.intData].CarIdx~=0 then
                        if hbtn.intData==self.CurSelectTrack then
                            self.PreCarFive:SetState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Select)
                            self:SetCarState(hbtn.intData,self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Select)
                        else
                            self.PreCarFive:SetState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Normal)
                            self:SetCarState(hbtn.intData,0,CarSelectStatus.None)
                        end

                    end
                else
                    if self.Cars[hbtn.intData].CarIdx~=0 then
                        self.PreCarFive:SetState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Use)
                        self:SetCarState(hbtn.intData,self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Use)
                    else
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChapterMoreCarNoOneCar))
                    end
                end
            end,i)
        end
    end
    self:SetTogState(1)
end

function Page_PveChapterSelectCar:SetTogState(idx)
    self.CurSelectTrack=idx
    if self.Cars[self.CurSelectTrack].CarIdx~=0 then
        self.PreCarFive:SetState(self.Cars[self.CurSelectTrack].CarIdx,CarSelectStatus.Select)
    end
    for i = 1, #self.TogGroup do
        CommonHelper:SetToggleState(self.TogGroup[i],idx==i)
    end
end
function Page_PveChapterSelectCar:GetCurTrackCar()
    return self.Cars[self.CurSelectTrack].CarIdx
end
function Page_PveChapterSelectCar:SetCurCarState(carIdx,state)
    if self.Cars[self.CurSelectTrack]~=0 then
        self.PreCarFive:SetState(self.Cars[self.CurSelectTrack].CarIdx,CarSelectStatus.Normal)
    end
    self:SetCarState(self.CurSelectTrack,carIdx,state)
end
function Page_PveChapterSelectCar:ReOpen()
    local carIdx=0
    if self.Cars then
        for i = 1, #self.Cars do
            if i~=self.CurSelectTrack then
                if self.Cars[i].CarIdx>0 then
                    carIdx=self.Cars[i].CarIdx
                    carIdx=i
                    self.PreCarFive:SetState(self.Cars[i].CarIdx,CarSelectStatus.Use)
                end
            end
        end
        self:SetTogState(self.CurSelectTrack)
    end

end
function Page_PveChapterSelectCar:SetCarState(idx,carIdx,state)
    self.Cars[idx].CarIdx=carIdx
    self.Cars[idx].State=state
    for i = 1, #self.NpcObjGroup do
        CommonHelper:SetGameObjectActive("carid",self.NpcObjGroup[i], self.Cars[i].CarIdx~=0)
        for j = 1, #self.CarTogGroup[i] do
            CommonHelper:SetToggleState(self.CarTogGroup[i][j],self.Cars[i].CarIdx==j and self.Cars[i].State==CarSelectStatus.Use)
            CommonHelper:SetGameObjectActive("Pos"..j,self.NpcObjGroup[i],self.Cars[i].CarIdx==j)
        end
    end
    for i = 1, #self.SelectCarGroup do
        CommonHelper:SetToggleState(self.SelectCarGroup[i],self.Cars[i].CarIdx~=0 and self.Cars[i].State==CarSelectStatus.Use)
    end
end

