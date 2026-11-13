---@class TrackMainView:ViewBase
TrackMainView = class("TrackMainView", ViewBase)

function TrackMainView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "TrackMainViewAction")
end

function TrackMainView:Awake()
    self:CacheViewData()
    self:InitBtnFunc()
    self.cmpTimerID = 0
end

function TrackMainView:OnOpen()
    self:InitViewInfo()

    if self.cmpTimerID ~= 0 then
        TimerManager:Get():StopTimer(self.cmpTimerID)
    end
    self.cmpTimerID = TimerManager:Get():CreateTimerLoop(1, function()
        if UIManager:Get():IsViewShow("TrackMainView") then
            self:RefreshItemProgress()
        end
    end, nil, true)

end

function TrackMainView:ReOpen()
    self:InitViewInfo()
end

function TrackMainView:CacheViewData()
    self.TimeScroll = self:GetChildWight("TimeScroll", typeof(MoreRowScrollView))
    self.TimeScrollContentTrans = self:GetChildByParent("Content", self.TimeScroll.gameObject).transform

    self.CmpUpgBaseCG = self:GetChildWight("CmpUpgBaseCG", typeof(CanvasGroup))
    self.MouldCG = self:GetChildWight("MouldCG", typeof(CanvasGroup))
    self.ManufactureCG = self:GetChildWight("ManufactureCG", typeof(CanvasGroup))

    self.ManufactureScroll = self:GetChildWight("ManufactureScroll", typeof(MoreRowScrollView))

    self.TitleBtnScroll = self:GetChildWight("TitleBtnScroll", typeof(MoreRowScrollView))
    self.MouldBtnScroll = self:GetChildWight("MouldBtnScroll", typeof(MoreRowScrollView))

end

function TrackMainView:InitBtnFunc()

    self.BtnClose = CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(data)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(param)
        CommonHelper:ShowHelpView(PageDetailType.Lab)
    end)

    self.TogMould = CommonHelper:HButtonSetCallback("TogMould", self.gameObject, function(data)
        self:InitTogState(LabToggleType.SegTech, function()
            UINotify:Get():SendNotification(UINotifyEvent.TrackScienceMenuView_InitTimeData, TrackDataManager:Get():GetTrackTagType())
        end)
    end)

    self.TogManufacture = CommonHelper:HButtonSetCallback("TogManufacture", self.gameObject, function(data)
        self:InitTogState(LabToggleType.SegProduct, function()
            UINotify:Get():SendNotification(UINotifyEvent.TrackScienceMenuView_InitTimeData, TrackDataManager:Get():GetTrackTagType())
        end)
    end)


end

---@param labExpType LabExpType
function TrackMainView:InitTogState(labExpType, func)
    if TrackDataManager:Get():GetTrackTagType() ~= labExpType then
        TrackDataManager:Get():SetTrackTagType(labExpType)

        CommonHelper:SetToggleState(self.TogMould, labExpType == LabToggleType.SegTech)
        CommonHelper:SetToggleState(self.TogManufacture, labExpType == LabToggleType.SegProduct)

        UIUtil.ShowCanvasGroup(self.CmpUpgBaseCG, labExpType == LabToggleType.SegTech or labExpType == LabToggleType.SegProduct)
        UIUtil.ShowCanvasGroup(self.MouldCG, labExpType == LabToggleType.SegTech)
        UIUtil.ShowCanvasGroup(self.ManufactureCG, labExpType == LabToggleType.SegProduct)

        self:InitTypeList(labExpType)

        if func then
            func()
        end
    end
end

function TrackMainView:InitViewInfo()
    self:InitTogState(LabToggleType.SegTech, function()
        TrackDataManager:GetTrackTagType()
        UINotify:Get():SendNotification(UINotifyEvent.TrackScienceMenuView_InitTimeData, TrackDataManager:Get():GetTrackTagType())
    end)
end

function TrackMainView:InitTypeList(labExpType)
    if labExpType == LabToggleType.SegTech then
        self:InitMouldBaseInfo()
    elseif labExpType == LabToggleType.SegProduct then
        self:InitManufactureBaseInfo()
    end
end

---@param labExpType LabExpType
function TrackMainView:OnTagBtnClick(labExpType)
    if labExpType == LabToggleType.SegTech then
        self:InitMouldBaseInfo()
    elseif labExpType == LabToggleType.SegProduct then
        self:InitManufactureInfo()
    end

    UIUtil.ShowCanvasGroup(self.MouldCG, labExpType == LabToggleType.SegTech)
    UIUtil.ShowCanvasGroup(self.ManufactureCG, labExpType == LabToggleType.SegProduct)

    --CommonHelper:SetGameObjectActive("selectTire", self.ComposeCG.gameObject, tag == LabComposeTag.MixedTire and labExpType == LabExpType.Compose)

end

function TrackMainView:OnClose()
    TimerManager:Get():StopTimer(self.cmpTimerID)
    CommonHelper:ReleasePool(UIModuleID.track)
end
