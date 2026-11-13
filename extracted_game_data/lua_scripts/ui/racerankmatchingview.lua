



---@class RaceRankMatchingView : ViewBase
RaceRankMatchingView = class("RaceRankMatchingView", ViewBase)

function RaceRankMatchingView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRankMatchingViewAction")

    self.TimerID = -1
    self.Time = -1
end

function RaceRankMatchingView:Awake()
    CommonHelper:HButtonSetCallback("BtnCancel",self.gameObject,function (hbtn)
        RaceRankSubsystem:Get():SendMsg_MatchCancel()
        UIManager:Get():HidePersistentView("RaceRankMatchingView")
    end)
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        self:SetUIGroup(false)
    end)
    CommonHelper:HButtonSetCallback("BtnTime",self.gameObject,function (hbtn)
        self:SetUIGroup(true)
    end)

end

function RaceRankMatchingView:OnOpen()
    self:SetUIGroup(true)
    self:StartTimer()
end

function RaceRankMatchingView:OnClose()
    self:StopTimer()
end

function RaceRankMatchingView:SetUIGroup(ismax)
    self.MaxUI = CommonHelper:SetGameObjectActive("max", self.gameObject, ismax)
    self.MinUI = CommonHelper:SetGameObjectActive("min", self.gameObject, not ismax)
end

function RaceRankMatchingView:SetTime()
    local temp = ClientDataManager:Get():GetTemplateString(TemplateStringID.RaceRankMatchTimeFromat)
    CommonHelper:SetText("###waitingvalue", self.MaxUI, string.format(temp, self.Time))
    CommonHelper:SetText("###waitingvalue", self.MinUI, string.format(temp, self.Time))
end



function RaceRankMatchingView:StartTimer()
    self:StopTimer()
    self:SetTime()
    self.TimerID = TimerManager:Get():CreateTimerLoop(1, function()
        self:TimerGoing()
    end)
end

function RaceRankMatchingView:TimerGoing()
    self.Time = self.Time + 1
    self:SetTime()
end

function RaceRankMatchingView:StopTimer()
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = -1
    self.Time = 1
end