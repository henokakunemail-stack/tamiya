function PageBattleResult:StoryReward_InitResultInfo(isFail,playerData,Page_BattleResultRank)
    self.Page_BattleResultRank=Page_BattleResultRank
    if BattleDataManager:Get():GetBattleType()==RaceModel.Battle or BattleDataManager:Get():GetBattleType()==RaceModel.NewBieChapter or BattleDataManager:Get():GetBattleType()==RaceModel.RaceSeniorTrain or BattleDataManager:Get():GetBattleType()==RaceModel.RaceSelfChapter then
        isFail =  playerData:GetError() ~= BattleFailError.None or playerData:GetTime() == 0
    end
    local levelId = BattleDataManager:Get():GetLevelId()
    self.LevelData =nil
    if BattleDataManager:Get():GetBattleType()==RaceModel.Battle then
        self.LevelData = PVEChapterDataManager:Get():GetLevelDataByLevelId(levelId)
    end
    if BattleDataManager:Get():GetBattleType()==RaceModel.NewBieChapter then
        self.LevelData = NewBieChapterDataManager:Get():GetLevelDataByLevelId(levelId)
    end
    if BattleDataManager:Get():GetBattleType()==RaceModel.RaceSeniorTrain then
        self.LevelData = RaceSeniorTrainManager:Get():GetLevelDataByLevelId(levelId)
    end
    CommonHelper:SetGameObjectActive("battleresult_bg_win", self.pageStoryRewardCG.gameObject, not isFail)
    CommonHelper:SetGameObjectActive("battleresult_bg_lose", self.pageStoryRewardCG.gameObject, isFail)

    local one= CommonHelper:SetGameObjectActive("BattleResultOne",self.pageStoryRewardCG.gameObject,  self.LevelData==nil or not( self.LevelData and #self.LevelData:GetBattleInfo()>1 and PVEChapterDataManager:Get():GetLastFlag()))
    local more=CommonHelper:SetGameObjectActive("BattleResultMore", self.pageStoryRewardCG.gameObject,   self.LevelData and #self.LevelData:GetBattleInfo()>1 and PVEChapterDataManager:Get():GetLastFlag())
    if self.LevelData and  #self.LevelData:GetBattleInfo()>1 and PVEChapterDataManager:Get():GetLastFlag() then
        self:InitLevelDataMore(more,isFail)
    else
        self:InitOneLevelData(one,isFail,1)
    end
end

function PageBattleResult:InitOneLevelData(root,isFail,idx)
    local win= CommonHelper:SetGameObjectActive("win", root, not isFail)
    local lose=CommonHelper:SetGameObjectActive("lose", root, isFail)
    if BattleDataManager:Get():GetBattleType()==RaceModel.Battle or BattleDataManager:Get():GetBattleType()==RaceModel.NewBieChapter or BattleDataManager:Get():GetBattleType()==RaceModel.RaceSeniorTrain or  BattleDataManager:Get():GetBattleType()==RaceModel.RaceSelfChapter and not isFail then
        if ReturnOldPlayerDataManager:Get():GetReturnState() and PVEChapterDataManager:Get():GetIsMoreExp() and PVEChapterDataManager:Get():GetLastFlag() then
            CommonHelper:SetText("###ExpReturn",root,CommonHelper:GetTempStr_Default(TemplateStringID.ReturnOldPlayerPveChapterExp))
        else
            CommonHelper:SetText("###ExpReturn",root,"")
        end
        if BattleDataManager:Get():GetBattleType()==RaceModel.RaceSelfChapter and not isFail then
            self:InitTasKList(root,idx)
        else
            self:InitLevelData(root,idx)
        end
    else
        CommonHelper:SetText("###ExpReturn",root,"")
    end
    local battleType= BattleDataManager:Get():GetBattleType()
    CommonHelper:SetGameObjectActive("ActivityReward2",root,CommonFestivalDataManager:Get():GetActActive(CommonFestivalType.DualOutput) and (battleType==RaceModel.Battle or battleType==RaceModel.Challenge) and  PVEChapterDataManager:Get():GetLastFlag())

    CommonHelper:SetGameObjectActive("items",root,BattleDataManager:Get():GetBattleType()==RaceModel.Battle or BattleDataManager:Get():GetBattleType()==RaceModel.RaceSeniorTrain or BattleDataManager:Get():GetBattleType()==RaceModel.NewBieChapter)
    CommonHelper:SetGameObjectActive("TaskList",root,BattleDataManager:Get():GetBattleType()==RaceModel.RaceSelfChapter and RaceSelfChapterDataManager:Get():GetCurChapterData().HasTask )


    local dropData = self.battleResultData:GetOtherResultData()
    CommonHelper:SetGameObjectActive("Reward",root,   PVEChapterDataManager:Get():GetLastFlag() )
    CommonHelper:SetGameObjectActive("MiddleResult",root, not  PVEChapterDataManager:Get():GetLastFlag() )

    if dropData ~= nil then
        self:StoryReward_InitDropDownScroll(dropData.items,root,idx)
    end
    dropData = dropData ~= nil and dropData.data or dropData
    self:InitBaseData(root, dropData, not isFail)
    local PlayerData=BattleDataManager:Get():GetDefaultPlayerBattleResultData()
    CommonHelper:HButtonSetCallback("BtnHelp", root, function()
        CommonHelper:OpenEncyclopedia(EncyclopediaPage.Parts)
    end)
    self.BtnHelpError= CommonHelper:HButtonSetCallback("BtnHelpError", root, function()
        CommonHelper:ShowHelpView(PlayerData:GetError())
    end)
    local battleType=  BattleDataManager:Get():GetBattleType()
    CommonHelper:SetGameObjectActive("ActivityReward2",root,CommonFestivalDataManager:Get():GetActActive(CommonFestivalType.DualOutput) and (battleType==RaceModel.Battle or battleType==RaceModel.Challenge) and  PVEChapterDataManager:Get():GetLastFlag())

    CommonHelper:SetHButtonClick(self.BtnHelpError,false,true)
    CommonHelper:SetText("###FailReasonText", root, CommonHelper:GetTempStr_BattleFailM_ErrorTips(PlayerData:GetError()))

end
function PageBattleResult:InitLevelDataMore(root,isFail)

    self.BannerScroll = UIUtil.GetTypeChildWightByParent("CarouselScrollView",root, typeof(CarouselScrollView))
    CommonHelper:HButtonSetCallback("BtnLeft", root, function()
        CommonHelper:InitCarouselScrollView_MoveLastPage(self.BannerScroll)
    end)
    CommonHelper:HButtonSetCallback("BtnRight", root, function()
        CommonHelper:InitCarouselScrollView_MoveNextPage(self.BannerScroll)
    end)

    self.ScrollPoint = UIUtil.GetTypeChildWightByParent("ScrollPoint",root, typeof(ScrollPoint))
    self.BannerScrollRect = UIUtil.GetGameobjectComponent(self.BannerScroll.gameObject, typeof(RectTransform))
    self.BannerScroll.itemSize=Vector2(UIUtil.GetUIWidth(self.BannerScrollRect),self.BannerScroll.itemSize.y)
    self.ItemGroupRect= UIUtil.GetTypeChildWightByParent("ItemGroup",self.BannerScroll.gameObject, typeof(RectTransform))
    UIUtil.SetUIWidth(self.ItemGroupRect,UIUtil.GetUIWidth(self.BannerScrollRect))

    CommonHelper:InitCarouselScrollView(self.BannerScroll,  #self.LevelData:GetBattleInfo(), 0,function(dataIndex, itemObj, scroll)
        self.ScrollPoint:SetPoint(dataIndex)
        local  resultdata=PVEChapterDataManager:Get():GetBattleResult()[dataIndex+1]
        local  rewardObj=UIUtil.GetChildInputPath("BattleResultOne", itemObj)
        local  RankView=UIUtil.GetChildInputPath("RankView", itemObj)
        resultdata.tittle=CommonHelper:GetBattleTittleNameByName(dataIndex+1)
        local  battleResultData=resultdata.result
        self.Page_BattleResultRank:InitPlayerRank(RankView,true,battleResultData,{resultdata},self.moduleId)
        local isFail=false
        for i = 1, #battleResultData.PlayerList do
            local playerData= battleResultData.PlayerList[i]
            if playerData:GetPid() == BattleDataManager:Get():GetDefaultPlayerId() then
                isFail = playerData:GetError() ~= BattleFailError.None or playerData:GetTime() == 0
                break
            end
        end
        self:InitOneLevelData(rewardObj,isFail,dataIndex+1)
    end)

end




function PageBattleResult:InitLevelData(root,idx)

    local lastflag=  PVEChapterDataManager:Get():GetLastFlag()
    --self.TogGroup={}
    --for i = 1, 5 do
    --    self.TogGroup[i]=CommonHelper:HButtonSetCallback("ToggleYellow"..i, root,function (hbtn)
    --        self:SetLevelTips(hbtn.intData,root)
    --    end,i)
    --end
    --for i = 1, 5 do
    --    CommonHelper:SetHButtonClick(self.TogGroup[i],self.LevelData:GetBattleInfo()[i]~=nil and #self.LevelData:GetBattleInfo()>1 and lastflag,true)
    --end
    self:SetLevelTips(idx,root)
end
function PageBattleResult:InitTasKList(root,idx)

    --self.TogGroup={}
    --for i = 1, 5 do
    --    self.TogGroup[i]=CommonHelper:HButtonSetCallback("ToggleYellow"..i, root,function (hbtn)
    --        self:SetLevelTips(hbtn.intData,root)
    --    end,i)
    --end
    --for i = 1, 5 do
    --    CommonHelper:SetHButtonClick(self.TogGroup[i],self.LevelData:GetBattleInfo()[i]~=nil and #self.LevelData:GetBattleInfo()>1 and lastflag,true)
    --end
    self:SetTaskList(idx,root)
end
function PageBattleResult:SetLevelTips(idx,root)
    local lastflag=  PVEChapterDataManager:Get():GetLastFlag()
    --for i = 1, 5 do
    --    CommonHelper:SetToggleState(self.TogGroup[i],idx==i)
    --end
    for i = 1, 3 do
        if self.LevelData.starParam[idx] then
            local leveltip = CommonHelper:SetGameObjectActive("leveltip".. i, root, true)
            local limititem = CommonHelper:SetGameObjectActive("limititem".. i, root,  true)
            local textContent = string.format("%d.%s", i,  self.LevelData.starParam[idx][i])
            local lvText = CommonHelper:SetText("###leveltip", leveltip, textContent)
            local lvShadowText = CommonHelper:SetText("###leveltipShadow", leveltip, textContent)

            CommonHelper:SetGameObjectActive("lock", limititem, not  self.LevelData:CheckStarState(i+((idx-1)*3)) or not lastflag)
            CommonHelper:SetGameObjectActive("unlock", limititem,  self.LevelData:CheckStarState(i+((idx-1)*3))  and lastflag)
            CommonHelper:CSGameObjectSetActive(lvText.gameObject, not  self.LevelData:CheckStarState(i+((idx-1)*3)) )
            CommonHelper:CSGameObjectSetActive(lvShadowText.gameObject,  self.LevelData:CheckStarState(i+((idx-1)*3)) )
        else
            CommonHelper:SetGameObjectActive("leveltip".. i, root, false)
            CommonHelper:SetGameObjectActive("limititem".. i, root,  false)
        end

    end
end
function PageBattleResult:SetTaskList(idx,root)
   local curLevel=RaceSelfChapterDataManager:Get():GetCurCopyData()
    local TaskView=UIUtil.GetTypeChildWightByParent("TaskList",root,typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(TaskView,#curLevel.taskList,1,function(dataIndex, itemObj, scroll)
        ---@type RaceSelfChapterTaskData
        local data=curLevel.taskList[dataIndex+1]
        local state=""

        if data.State==RaceSelfChapterTaskState.Get then
            state=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskState4)
        elseif data.State==RaceSelfChapterTaskState.Rally then
            state=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskState2)
        elseif data.State==RaceSelfChapterTaskState.Done then
            state=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskState3)
        end
        CommonHelper:SetText("###leveltip",itemObj,CommonHelper:GetLevelPassDesc(tonumber(data.Cfg.cond),data.Cfg.succval))
        CommonHelper:SetText("###leveltipShadow",itemObj,CommonHelper:GetLevelPassDesc(tonumber(data.Cfg.cond),data.Cfg.succval))
        CommonHelper:SetText("###state",itemObj,state)
        CommonHelper:SetText("###state2",itemObj,state)
        CommonHelper:SetGameObjectActive("###leveltip",itemObj,data.State==RaceSelfChapterTaskState.Rally)
        CommonHelper:SetGameObjectActive("###state2",itemObj,data.State==RaceSelfChapterTaskState.Rally)
        CommonHelper:SetGameObjectActive("###leveltipShadow",itemObj,data.State~=RaceSelfChapterTaskState.Rally)
        CommonHelper:SetGameObjectActive("###state",itemObj,data.State~=RaceSelfChapterTaskState.Rally)
    end)
end



local __Items = {}
---@param items SC_SomeDown
function PageBattleResult:StoryReward_InitDropDownScroll(items,root,idx)
    if items == nil then
        items={}
    end

    __Items =  CommonHelper:GetRewardDataBySomeDown(items)
    local funcUpdateItem = function(dataIndex, itemObj, scroll)
        local data = __Items[dataIndex + 1]
        if data then
            local param = Param_ItemArticleParam()
            param.count = data.num
            local type=ItemPartUIType.Simple
            local cell=nil
            if data.partIdx~=nil then
                cell=KnapsackDataManager:Get():GetArticleByCellID(data.partIdx)
                if cell then
                    param.quality = cell:GetPartQuality()
                    param.star = cell:GetStar()
                    param.lv = cell:GetPartLV()
                    param.using = cell:GetCarId()
                    param.lock = cell:GetPartLock()
                    param.awaken=cell:GetAwaken()
                    param.generation=cell:GetGeneration()
                    param.downType=cell:GetPartDownType()
                    param.source = cell:GetPartSource()
                    param.expireTime = cell:GetPartExpTime()
                    type=ItemPartUIType.Normal
                end
            end
            CommonHelper:SetItemComGroup(itemObj, UIModuleID.BattleResult, tonumber(data.id), param, function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.BattleResult, false,nil,cell)
            end, tonumber(data.id),type)
        end
        CommonHelper:SetGameObjectActive("ItemCom_118", itemObj, data ~= nil)
    end

    self.rewardList = UIUtil.GetTypeChildWightByParent("RewardList", root, typeof(MoreRowScrollView))

    local dataCount = #__Items > 6 and #__Items or 6
    CommonHelper:InitMoreRowScrollView(self.rewardList, dataCount, 1, funcUpdateItem, true)
end

----获得当前得到多少金币
function PageBattleResult:GetAwardGold(currencyTable)
    if #currencyTable > 0 then
        for i = 1, #currencyTable do
            if currencyTable[i].num1 == CurrencyType.Gold then
                return currencyTable[i].num2
            end
        end
    else
        return 0
    end
end