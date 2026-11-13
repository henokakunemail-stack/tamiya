---@class RaceRankTrackView : ViewBase
RaceRankTrackView = class("RaceRankTrackView", ViewBase)
local _RaceType=nil
local _SelectIndex=nil
function RaceRankTrackView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRankTrackViewAction")

end
function RaceRankTrackView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelper",self.gameObject,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceRank)
    end)
    self.Toggle_Type1=CommonHelper:HButtonSetCallback("Toggle_Page1",self.gameObject,function (hbtn)
        if _RaceType~=RaceProtectType.Protect then
            _RaceType=RaceProtectType.Protect
            _SelectIndex=0
            self:SetToggleState()
            self:SetSelectTrackData()
        end
    end)
    self.Toggle_Type2=CommonHelper:HButtonSetCallback("Toggle_Page2",self.gameObject,function (hbtn)
        if _RaceType~=RaceProtectType.Normal then
            _RaceType=RaceProtectType.Normal
            _SelectIndex=0
            self:SetToggleState()
            self:SetSelectTrackData()
        end
    end)
    CommonHelper:HButtonSetCallback("BtnBegin",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("RaceRankNewView", CanvasType.MainCanvas, "RaceRankNewView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceRankNew_SetData, self.SelectTrack)
    end)
    self.TestRun=CommonHelper:HButtonSetCallback("BtnTestRun",self.gameObject,function (hbtn)
        RaceAssembleAddSubsystem:Get():SendMsg_RaceAssembleInfo(self.SelectTrack.TrackData:GetId(),RaceRankManager:Get():GetScenes(),self.SelectTrack.RaceType,self.SelectTrack.RaceStyleType,UIModuleID.RaceRank)
    end)
    CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        TaskSubsystem:Get():SendMsg_GetTaskList(TaskType.DailyRank,UIModuleID.RaceRank)
    end)
    CommonHelper:HButtonSetCallback("BtnRankList",self.gameObject,function (hbtn)

        RankingListSubsystem:Get():SendMsg_RankingListInfo(RankingListType.Speed,self.SelectTrack.TrackData:GetId())
        RaceRankSubsystem:Get().RankingListFlag = RankingListOpenType.RaceRankListOpen
    end)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))
end

function RaceRankTrackView:OnOpen()
    RedPointManager:Get():UpdateValue(RedPointID.S_TaskRank,true)
    self:CheckNewBieGuide()
end

function RaceRankTrackView:OnClose()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId = nil
    end
end
function RaceRankTrackView:OnAutoClose()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId = nil
    end
end
function RaceRankTrackView:SetSelectTrackData()
    ---@type RaceRankMoreTrackTrackData
    self.SelectTrack= self.TrackList[_SelectIndex+1]
    CommonHelper:SetHButtonClick(self.TestRun,self.SelectTrack.RaceStyleType~=RaceStyleType.Relay,true)
end
function RaceRankTrackView:SetData()
    _RaceType=PlayerPrefsHelper:GetValue_RaceRankRaceType()
    _SelectIndex=0
    self:SetToggleState()
    self:SetSelectTrackData()
end

function RaceRankTrackView:SetView()
    self:SetSeasonInfo()
    self:SetTrackData()
end

function RaceRankTrackView:SetSeasonInfo()

    local starttime = CommonHelper:ConvertIntToDataTime(RaceRankManager:Get():GetBeginTime()*1000)
    local endtime = CommonHelper:ConvertIntToDataTime(RaceRankManager:Get():GetEndTime()*1000)

    local temp = ClientDataManager:Get():GetTemplateString(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankDateFromat))
    local str1 = string.format(temp, starttime.Year, starttime.Month, starttime.Day)
    local str2 = string.format(temp, endtime.Year, endtime.Month, endtime.Day)
    CommonHelper:SetText("###time2", self.gameObject, str1.."~"..str2)
    self:SetLastOpenTime()
end
function RaceRankTrackView:SetLastOpenTime()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
    self:SetOpenTime()
end
function RaceRankTrackView:SetOpenTime()
    local string=TemplateStringID.RaceRankOpenTime
    local start=RaceRankManager:Get():GetBeginTime()
    local endTime=RaceRankManager:Get():GetEndTime()
    string=TemplateStringID.RaceRankSeasonDownTime
    self.subTime=CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) - endTime
    if self.subTime>=0 then
        if self.TimeId then
            TimerManager:Get():StopTimer(self.TimeId)
            self.TimeId = nil
        end
    end

    local day,hour,minute,second =CommonHelper:GetConvertSecond(math.abs(self.subTime))
    if day >= 1 then
        CommonHelper:SetText("###time1", self.gameObject,
                CommonHelper:GetTempStr_Default(string,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, day, hour, minute)))
    else
        CommonHelper:SetText("###time1", self.gameObject,
                CommonHelper:GetTempStr_Default(string,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, hour, minute, second)))
    end

end


function RaceRankTrackView:SetToggleState()
    if _RaceType==RaceProtectType.Normal then
        CommonHelper:IsOpenMini4wdRuleView(UIModuleID.RaceRank)
    end
    CommonHelper:SetToggleState(self.Toggle_Type1,_RaceType==RaceProtectType.Protect)
    CommonHelper:SetToggleState(self.Toggle_Type2,_RaceType==RaceProtectType.Normal)
    PlayerPrefsHelper:SetValue_RaceRankRaceType(_RaceType)
    self:SetView()
end
function RaceRankTrackView:SetTrackData()
    ---@type RaceRankMoreTrackTrackData[]
    self.TrackList = RaceRankManager:Get():GetTrackList(_RaceType)
    CommonHelper:InitMoreRowScrollView(self.ScrollView,  #self.TrackList, 1,function(dataIndex, itemObj, scroll)
        local SceneId = RaceRankManager:Get():GetScenes()
        local trackData= self.TrackList[dataIndex+1].TrackData
        CommonHelper:GetComponentSetTrackIconByData("trackicon", itemObj, trackData, UIModuleID.RaceRank)
        CommonHelper:SetTrackFeatureByParent("trackfeature",itemObj, trackData:GetFeature(), true)
        if SceneId ~= -1 then
            ---@type scene_config_cell
            local sceneCfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, SceneId)
            if sceneCfg then
                CommonHelper:GetComponentSetUITexture("scene", itemObj, sceneCfg.icon, UIModuleID.RaceRank)
            end
        end
        local raceStyleType= self.TrackList[dataIndex+1].RaceStyleType
        local carNum= self.TrackList[dataIndex+1].CarNum
        local Index= self.TrackList[dataIndex+1].Index
        CommonHelper:SetGameObjectActive("carnum",itemObj,raceStyleType==RaceStyleType.Relay)
        CommonHelper:SetText("carnum/###value",itemObj,carNum)
        CommonHelper:SetText("HoverTextBg/###trackname",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankTrackTittle,Index))
        CommonHelper:SetText("NormalTextBg/###trackname",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankTrackTittle,Index))
        CommonHelper:HButtonSetCallback("HoverTextBg/BtnReview", itemObj, function(data)
            local trackData=  self.TrackList[data.intData].TrackData
            if trackData:GetIsField() then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
            else
                CommonHelper:LoadReviewTrack(nil, trackData)
            end
        end,dataIndex+1)
        CommonHelper:HButtonSetCallback("NormalTextBg/BtnReview", itemObj, function(data)
            local trackData=  self.TrackList[data.intData].TrackData
            if trackData:GetIsField() then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
            else
                CommonHelper:LoadReviewTrack(nil, trackData)
            end
        end,dataIndex+1)
        CommonHelper:HButtonSetCallback("BtnItem", itemObj, function(data)
            if _SelectIndex~=data.intData then
                _SelectIndex=data.intData
                self:SetSelectTrackData()
                CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
            end
        end,dataIndex)
        CommonHelper:SetGameObjectActive("Hover",itemObj,_SelectIndex==dataIndex)
        CommonHelper:SetGameObjectActive("HoverTextBg",itemObj,_SelectIndex==dataIndex)
        CommonHelper:SetGameObjectActive("Normal",itemObj,_SelectIndex~=dataIndex)
        CommonHelper:SetGameObjectActive("NormalTextBg",itemObj,_SelectIndex~=dataIndex)
    end)
end
