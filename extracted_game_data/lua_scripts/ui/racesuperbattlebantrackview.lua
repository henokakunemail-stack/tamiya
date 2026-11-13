---@class RaceSuperBattleBanTrackView : ViewBase
RaceSuperBattleBanTrackView = class("RaceSuperBattleBanTrackView", ViewBase)

function RaceSuperBattleBanTrackView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSuperBattleBanTrackViewAction")
end

function RaceSuperBattleBanTrackView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceSuperBattle)
    end)
    CommonHelper:HButtonSetCallback("BtnFight",self.gameObject,function (hbtn)
        local trackidx=""
        for i = 1, self.BanNum do
            if self.BanTable[i]==0 then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBanTrackMustEnough,self.BanNum))
                return
            end
            if i==self.BanNum then
                trackidx=string.format("%s%d",trackidx,self.BanTable[i])
            else
                trackidx=string.format("%s%d:",trackidx,self.BanTable[i])
            end
        end
        RaceSuperBattleSubsystem:Get():SendMsg_BanTrack(trackidx)
    end)
    self.ScrollView= self:GetChildWightByParent("MoreRowScrollView_V",self.gameObject,typeof(MoreRowScrollView))

end

function RaceSuperBattleBanTrackView:OnOpen()
    cs_coroutine.start(function()
        coroutine.yield()
        coroutine.yield()
        UINotify:Get():SendNotification(UINotifyEvent.RaceSuperBattleBanTrack_SetData)
    end)
end


function RaceSuperBattleBanTrackView:OnClose()
     CommonHelper:ReleasePool(UIModuleID.RaceSuperBattleBanTrack)
end


function RaceSuperBattleBanTrackView:SetData()
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictkillertrack_config)
    self.TrackList=cfg.GetBanTrack()
    self.BanNum=2
    self.BanTable={}
    for i = 1, self.BanNum do
        self.BanTable[i]=0
    end
    self:SetBanNum()
    self:SetPlayerIcon(1)
    CommonHelper:InitMoreRowScrollView(self.ScrollView,#self.TrackList,5,function(index, itemObj,scroll)
        ---@type RaceTrackData
        local data = CommonHelper:GetRacetrackData(self.TrackList[index+1].C_ID)
        CommonHelper:GetComponentSetTrackIconByData("trackicon",itemObj,data,UIModuleID.RaceSuperBattleBanTrack)

        local ReviewBtn= CommonHelper:HButtonSetCallback("BtnReview",itemObj,function(hbtn)
            local date= CommonHelper:GetRacetrackData(self.TrackList[hbtn.intData+1].C_ID)
            CommonHelper:LoadReviewTrack(nil, date)
        end,index)
        CommonHelper:SetTrackFeatureByParent("trackfeature",itemObj,data:GetFeature())
        CommonHelper:SetGameObjectActive("select",itemObj,self:CheckSelect(data:GetId())~=0)
        CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
            local index=self:CheckSelect(self.TrackList[hbtn.intData].C_ID)
            if index~=0 then
                self.BanTable[index]=0
                self:SetBanNum()
                CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
            else
                if self:GetSelectCount()==self.BanNum then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleCheckSelectIsEnough))
                    return
                end
                self.BanTable[self:GetNoSelectIndex()]=self.TrackList[hbtn.intData].C_ID
                self:SetBanNum()
                CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
            end
        end,index+1)
    end)
    CommonHelper:MoreRowView_EnterAni1(self.ScrollView, 0.2)
end
function RaceSuperBattleBanTrackView:SetBanNum()
    CommonHelper:SetText("###bannum",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBanTrackNum,self:GetSelectCount(),self.BanNum))
end
function RaceSuperBattleBanTrackView:CheckSelect(id)
    for i = 1, self.BanNum do
        if self.BanTable[i]==id then
            return i
        end
    end
    return 0
end
function RaceSuperBattleBanTrackView:GetNoSelectIndex()
    for i = 1, self.BanNum do
        if self.BanTable[i]==0 then
            return i
        end
    end
    return 0
end
function RaceSuperBattleBanTrackView:GetSelectCount()
    local count=0
    for i = 1, self.BanNum do
        if self.BanTable[i]~=0 then
            count=count+1
        end
    end
    return count
end

function RaceSuperBattleBanTrackView:SetPlayerIcon(idx)
    local Left=self:GetChild("LeftPlayer")
    local Right=self:GetChild("RightPlayer")
    if RaceSuperBattleManager:Get():GetData():GetMatchRacer(idx) then
        CommonHelper:SetText("###playerNameText", Left, RaceSuperBattleManager:Get():GetData():GetMatchRacer(idx).Name)
        CommonHelper:SetText("###LabLV",  Left, string.format("LV:%d",RaceSuperBattleManager:Get():GetData():GetMatchRacer(idx).Lv))
        --头像
        CommonHelper:SetPlayerIconById("PlayerIcon", Left, RaceSuperBattleManager:Get():GetData():GetMatchRacer(idx).HeadIcon, RaceSuperBattleManager:Get():GetData():GetMatchRacer(idx).IconFrame, nil, UIModuleID.RaceSuperBattleBanTrack)
    else
        CommonHelper:SetText("###playerNameText",  Left, CommonHelper:GetTempStr_Default(TemplateStringID.RacerNull))
        CommonHelper:SetText("###LabLV",  Left, "")
        --头像
        CommonHelper:SetPlayerIconById("PlayerIcon",  Left, 0, 0, nil, UIModuleID.RaceSuperBattleBanTrack)
    end
    CommonHelper:SetText("###playerNameText", Right, PlayerDataManager:Get():GetPlayerName())
    CommonHelper:SetText("###LabLV",  Right, string.format("LV:%d",PlayerDataManager:Get():GetPlayerLV()))
    --头像
    CommonHelper:SetPlayerIconById("PlayerIcon", Right, PlayerDataManager:Get():GetPlayerIcon(), PlayerDataManager:Get():GetPlayerIconFrame(), nil, UIModuleID.RaceSuperBattleBanTrack)

end



