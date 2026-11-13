---@class PveChapterLevelInfoView : ViewBase
PveChapterLevelInfoView = class("PveChapterLevelInfoView", ViewBase)

function PveChapterLevelInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PveChapterLevelInfoViewAction")
end

function PveChapterLevelInfoView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.PVEChapterListView_SetViewInfo,{"PveChapterLevelInfoView",false})
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnRefit",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
        SkipModuleHelper:Get():ToSelectCarView(RaceModel.Battle, self.LevelData)
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceChapterLevelInfo,nil,nil,true)
    end)
    CommonHelper:HButtonSetCallback("BtnReview",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
        CommonHelper:LoadReviewTrack(nil, self.TrackData)
    end)
    CommonHelper:HButtonSetCallback("BtnLook",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
        if #self.LevelData.PveRankData > 0 and  self.LevelData.PveRankData[1].times[1] and self.LevelData.PveRankData[1].times[1]>0 then
            PVEChapterDataManager:Get():BeginHistoryBattle(self.LevelData.id,self.LevelData.PveRankData[1])
        else
            CommonTipsHelper:Get():ShowCenterTips( CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterNoPlayerPass))
        end
    end)
    self.TogGroup={}
    for i = 1, 5 do
        self.TogGroup[i]=CommonHelper:HButtonSetCallback("ToggleYellow"..i,self.gameObject,function (hbtn)
            self:SetCarInfo(hbtn.intData)
        end,i)
    end
    self.items={}
    for i = 1, 4 do
        self.items[i]=UIUtil.GetChild("Item"..i,self.gameObject)
    end
    self.PartsItem={4,1,2,3}
    self.moreRowScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))
end

function PveChapterLevelInfoView:OnOpen()

end
function PveChapterLevelInfoView:SetData()
    ---@type PVELevelData
    self.LevelData=PVEChapterDataManager:Get():GetCurLevelData()
    CommonHelper:SetText("###chaptername",self.gameObject,self.LevelData.name)
    CommonHelper:SetGameObjectActive("normal_bg",self.gameObject,self.LevelData.levelCfg.copytype==1)
    CommonHelper:SetGameObjectActive("elite_bg",self.gameObject,self.LevelData.levelCfg.copytype==2)
    CommonHelper:SetGameObjectActive("boss_bg",self.gameObject,self.LevelData.levelCfg.copytype==3)
    if #self.LevelData.PveRankData > 0 and  self.LevelData.PveRankData[1].times[1] and self.LevelData.PveRankData[1].times[1]>0 then
        if self.LevelData.PveRankData[1].times[1]>-1 then
            local time=0
            for i = 1, #self.LevelData.PveRankData[1].times do
                time=time+self.LevelData.PveRankData[1].times[i]
            end
            CommonHelper:GetComponentTransferTime("###fastplayertime",self.gameObject,time)
        else
            CommonHelper:SetText("###fastplayertime",self.gameObject,"--:--:--")
        end
        CommonHelper:SetGameObjectActive("playericongroup/default", self.gameObject, false)
        CommonHelper:SetGameObjectActive("playericongroup/icon", self.gameObject, true)
        CommonHelper:SetText("###fastplayername", self.gameObject, self.LevelData.PveRankData[1].name)
        CommonHelper:SetPlayerIconById("playericongroup", self.gameObject, self.LevelData.PveRankData[1].icon,self.LevelData.PveRankData[1].IconFrame,nil,UIModuleID.PveChapterLevelInfo)
    else
        CommonHelper:SetText("###fastplayername", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterNoPlayerPass))
        CommonHelper:SetText("###fastplayertime", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterDefaultTime))
        CommonHelper:SetGameObjectActive("playericongroup/default", self.gameObject, true)
        CommonHelper:SetGameObjectActive("playericongroup/icon", self.gameObject, false)
    end
    if self.LevelData.personRecord>-1 then
        CommonHelper:GetComponentTransferTime("###playertime",self.gameObject,self.LevelData.personRecord)
    else
        CommonHelper:SetText("###playertime",self.gameObject,"--:--:--")
    end
    CommonHelper:SetText("###startnum",self.gameObject,string.format("%d/%d",self.LevelData.starNum,self.LevelData.MaxStar))
    local firstdown= CommonHelper:GetRewardByDictDownId(self.LevelData.levelCfg.firstdown)
    local superparts= CommonHelper:GetSuperPartsByItemId(self.LevelData.levelCfg.GiftPartId)
    local copydownids = stringSplitToNumber(self.LevelData.levelCfg.copydowns,':')
    local ccpydowns={}
    for i = 1, #copydownids do
        table.insert(ccpydowns,CommonHelper:GetRewardByDictDownId(copydownids[i]))
    end
    ---@type table<number, table<number, RewardData>>
    local datalist = {}
    if self.LevelData.winSum<=0 then
        if superparts then
            for i = 1, self.LevelData.levelCfg.GiftPartNum do
                for k, v in pairs(superparts) do
                    local temp=RewardData()
                    temp:SetDataIdNum(v.partid,1,0)
                    table.insert(datalist, { true, temp,self.LevelData.levelCfg.GiftPartId})
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
    local count=#datalist>=5 and #datalist or 5
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictgiftpart_config)
    CommonHelper:InitMoreRowScrollView(self.moreRowScrollView, count, 1, function(index, itemObj, scroll)
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
            CommonHelper:SetItemComGroup(obj, UIModuleID.PveChapterLevelInfo,reward.id,param,function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.PveChapterLevelInfo)
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
    for i = 1, 5 do
        CommonHelper:SetHButtonClick(self.TogGroup[i],self.LevelData:GetBattleInfo()[i]~=nil,true)
        CommonHelper:SetGameObjectActive("startrackgroup/star"..i,self.gameObject,self.LevelData:GetBattleInfo()[i]~=nil)
    end
    for i = 1, self.LevelData.MaxStar/3 do
        local count=0
        for j = 1, 3 do
            if self.LevelData:CheckStarState(j+((i-1)*3)) then
                count=count+1
            end
        end
        --for j = 1, 3 do
        --    CommonHelper:SetGameObjectActive("nopassstar/star"..j,self.TogGroup[i].gameObject,count==j)
        --end
        CommonHelper:SetText("startrackgroup/star"..i.."/###num",self.gameObject,count)
        CommonHelper:SetGameObjectActive("startrackgroup/star"..i.."/###num",self.gameObject,count>0)
        CommonHelper:SetGameObjectActive("startrackgroup/star"..i.."/pass",self.gameObject,count>0)
    end
    self:SetCarInfo(1)
end

function PveChapterLevelInfoView:SetCarInfo(idx)
    ---@type PVELevelBattleData
    local data= self.LevelData:GetBattleInfo()[idx]
    for i = 1, 5 do
        CommonHelper:SetToggleState(self.TogGroup[i],idx==i)
        CommonHelper:SetGameObjectActive("startrackgroup/star"..i.."/select",self.gameObject,idx==i)
    end
    local sceneCfg=CommonHelper:GetTableDataByID(ConfigNames.scene_config,data.SceneId)
    if sceneCfg then
        CommonHelper:GetComponentSetUITexture("chapterpic",self.gameObject,sceneCfg.icon,UIModuleID.PveChapterLevelInfo)
    end
    local name,icon = CommonHelper:AnalyseNPCNameAndIconById(data.NpcIds[1])
    CommonHelper:GetComponentSetUITexture("npcgroup/npcicon",self.gameObject,icon,UIModuleID.PveChapterLevelInfo)
    CommonHelper:GetComponentSetUITexture("npcgroup/iconframe",self.gameObject,icon,UIModuleID.PveChapterLevelInfo)
    self.TrackData=CommonHelper:GetRacetrackData(data.TrackId)
    CommonHelper:SetTrackFeatureByParent("trackfeature",self.gameObject, self.TrackData:GetFeature(),true)
    CommonHelper:GetComponentSetTrackIconByData("trackicon",self.gameObject, self.TrackData,UIModuleID.PveChapterLevelInfo)
    CommonHelper:SetGameObjectActive("tips",self.gameObject, self.TrackData:GetRaceType()==MiniTrackType.System or   self.TrackData:GetRaceType()==MiniTrackType.LocalCustomTrack)
    for i = 1, 3 do
        local leveltip = UIUtil.GetChild("leveltip" .. i, self.gameObject)
        CommonHelper:SetText("###leveltip", leveltip, self.LevelData.starParam[idx][i])
        --CommonHelper:SetGameObjectActive("nopass", leveltip, not self.LevelData:CheckStarState(i+((idx-1)*3)))
        --CommonHelper:SetGameObjectActive("pass", leveltip, self.LevelData:CheckStarState(i+((idx-1)*3)))
    end
    local carReviewData=CarReviewData()
    carReviewData:SetDataByNPC(data.NpcIds[1])
    local partsList =carReviewData:GetPartList()
    for i = 1, 4 do
        if partsList[self.PartsItem[i]] then
            ---@type parts_config_cell
            local parts=CommonHelper:GetTableDataByID(ConfigNames.parts_config,partsList[self.PartsItem[i]].PartCfgID)
            if parts then
                print(self.items[i].name,parts.C_ID)
                CommonHelper:SetItemPartGroup(self.items[i],UIModuleID.PveChapterLevelInfo,parts.C_ID)
            end
        end
        CommonHelper:SetGameObjectActive("ItemPart_118", self.items[i],partsList[self.PartsItem[i]]~=nil)
    end
end
function PveChapterLevelInfoView:ReOpen()

end
function PveChapterLevelInfoView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.PveChapterLevelInfo)
end
