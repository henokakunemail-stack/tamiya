---@class RaceSelfChapterView : ViewBase
RaceSelfChapterView = class("RaceSelfChapterView", ViewBase)

function RaceSelfChapterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfChapterViewAction")
end
local _TogState = -1
local _PageIndex = 0
local _Data = nil
function RaceSelfChapterView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)
    self.BtnNext = CommonHelper:HButtonSetCallback("BtnNext", self.gameObject, function(hbtn)
        _PageIndex = RaceSelfChapterDataManager:Get():GetPageIndex()
        _TogState = -1
        RaceSelfChapterSubsystem:Get():SendMsg_GetAllSelfChapter(false)
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(data)
        CommonHelper:ShowHelpView(PageDetailType.RaceSelfChapter)
    end)
    CommonHelper:HButtonSetCallback("BtnCreate", self.gameObject, function(hbtn)
        UIManager:Get():OpenView("RaceSelfChapterCreateView", CanvasType.MainCanvas, "RaceSelfChapterCreateView")
    end)
    self.TogAll = CommonHelper:HButtonSetCallback("TogAll", self.gameObject, function(hbtn)
        -- RaceSelfChapterSubsystem:Get():SendMsg_GetAllSelfChapter(_PageIndex)
    end)
    self.TogJoin = CommonHelper:HButtonSetCallback("TogJoin", self.gameObject, function(hbtn)
        -- RaceSelfChapterSubsystem:Get():SendMsg_GetAllJoinSelfChapter()
    end)
    self.ScrollView = self:GetChildWight("MoreRowScrollView_V", typeof(MoreRowScrollView))


end

function RaceSelfChapterView:OnOpen()
    _PageIndex = 0
    self:CheckNewBieGuide()
end

function RaceSelfChapterView:SetData()
    ---@type table<number,RaceSelfChapterData>
    _Data = RaceSelfChapterDataManager:Get():GetAllRace()
    self.TimeTable={}
    if _Data then
        local count = #_Data >= 6 and #_Data or 6
        CommonHelper:SetHButtonClick(self.BtnNext, #_Data >= 6, true)
        CommonHelper:InitMoreRowScrollView(self.ScrollView, count, 3, function(index, itemObj, scroll)
            self:SetItem(index, itemObj, scroll)
        end, false)
        CommonHelper:MoreRowView_EnterAniRace(self.ScrollView, 0.12)
    end
    --self:StartTime()
end


function RaceSelfChapterView:SetItem(index, itemObj, scroll)
    -----@type RaceSelfChapterData
    local temp = _Data[index + 1]
    CommonHelper:SetGameObjectActive("empty", itemObj, temp == nil)
    CommonHelper:SetGameObjectActive("race", itemObj, temp ~= nil)
    if temp and temp.cfg then
        CommonHelper:SetText("bgtittlejoin/###racename", itemObj, CommonHelper:GetTempStr_Default(temp.cfg.mapname))
        CommonHelper:SetText("bgtittlenormal/###racename", itemObj, CommonHelper:GetTempStr_Default(temp.cfg.mapname))
        CommonHelper:SetText("lvlimithit/###lv", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevel, temp.cfg.needlev))
        CommonHelper:SetText("numlimit/###num", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterJoin, temp.FinishPeople))
        --CommonHelper:SetText("###racetime",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterDuration,temp.subDay,temp.subHour))
        CommonHelper:SetPlayerIconById("PlayerIcon", itemObj, temp.masterIcon, nil, nil, UIModuleID.RaceSelfChapter)

        local btn = CommonHelper:HButtonSetCallback("BtnJoin", itemObj, function(btnData)
            UIManager:Get():OpenView("RaceSelfChapterListView", CanvasType.MainCanvas, "RaceSelfChapterListView")
            UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterListView_SetLevelList, _Data[btnData.intData + 1].id)
            PlayerPrefsHelper:SetValue_SelfChapterId(_Data[btnData.intData + 1].id)
        end, index)
        --local btnDone = CommonHelper:HButtonSetCallback("BtnDone", itemObj, function(btnData)
        --    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterDone))
        --end, index)
        CommonHelper:SetToggleState(btn, false)
        CommonHelper:SetGameObjectActive("BtnDone",itemObj,false)
        CommonHelper:SetGameObjectActive("RedPointModule",itemObj,temp:GetSelfChapterHasRedPoint())
       -- CommonHelper:SetHButtonClick(btn, not temp.isDone, true)
        --CommonHelper:SetHButtonClick(btnDone, temp.isDone, true)
        if temp.subDay >= 1 then
            CommonHelper:SetText("###racetime", itemObj,
                    CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, temp.subDay, temp.subHour, temp.subMinute))
        else
            CommonHelper:SetText("###racetime", itemObj,
                    CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, temp.subHour, temp.subMinute,temp.subSecond))
        end
        self.TimeTable[temp.id]={itemObj,temp.subTime}
        -- CommonHelper:SetGameObjectActive("bgtittlejoin",itemObj,temp.isJoin)
        --  CommonHelper:SetGameObjectActive("bgtittlenormal",itemObj,not temp.isJoin)
    end
end
function RaceSelfChapterView:StartTime()
    if self.raceTimerID ~= 0 then
        TimerManager:Get():StopTimer(self.raceTimerID)
    end
    self.raceTimerID = TimerManager:Get():CreateTimerLoop(1, function()
            self:RefreshItemProgress()
    end, nil, true)
end
function RaceSelfChapterView:EndTime()
    if self.raceTimerID ~= 0 then
        TimerManager:Get():StopTimer(self.raceTimerID)
    end
end

function RaceSelfChapterView:RefreshItemProgress()
    for k, v in pairs(self.TimeTable) do
        local itemObj=v[1]
        local subTime=v[2]
        local subDay = math.abs(math.modf(subTime / TimeMilliSecond_Day))
        local subHour = math.abs(math.modf((subTime - (subDay * TimeMilliSecond_Day)) / TimeMilliSecond_Hour))
        local subMinute = math.abs(math.modf((subTime - (subDay * TimeMilliSecond_Day) - (subHour * TimeMilliSecond_Hour)) / TimeMilliSecond_Minute))
        local subSecond = math.abs(subTime - (subDay * TimeMilliSecond_Day) - (subHour * TimeMilliSecond_Hour) - (subMinute * TimeMilliSecond_Minute))

        if subDay >= 1 then
            CommonHelper:SetText("###racetime", itemObj,
                    CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, subDay, subHour, subMinute))
        else
            CommonHelper:SetText("###racetime", itemObj,
                    CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, subDay, subMinute, subSecond))
        end
        v[2]=v[2]-1
    end
end

function RaceSelfChapterView:OnClose()
    _TogState = -1
    self:EndTime()
    CommonHelper:ReleasePool(UIModuleID.RaceSelfChapter)
end

function RaceSelfChapterView:OnAutoClose()
    _TogState = -1
    self:EndTime()
end
