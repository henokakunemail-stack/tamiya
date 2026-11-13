---@class LabMainView : ViewBase
LabMainView = class("LabMainView", ViewBase)

function LabMainView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "LabMainViewAction")
end

function LabMainView:Awake()
    self.Page_LabRestore = Page_LabRestore(self:GetChild("RestoreCG"))
    self.Page_LabResolve = Page_LabResolve(self:GetChild("ResolveCG"))
    self.Page_LabCompound = Page_LabCompound(self:GetChild("CompoundCG"))
    self.Page_LabLimitCompound = Page_LabLimitCompound(self:GetChild("LimitCompoundCG"))
    self.TogResolve = CommonHelper:HButtonSetCallback("TogResolve", self.gameObject, function(data)
        self:SetToggleState(LabToggleType.Resolve)
    end)

    self.TogNewCompose = CommonHelper:HButtonSetCallback("TogCompose", self.gameObject, function(data)
        self:SetToggleState(LabToggleType.Compose)
    end)
    self.TogLimitCompose = CommonHelper:HButtonSetCallback("TogLimitCompose", self.gameObject, function(data)
        self:SetToggleState(LabToggleType.LimitCompose)
    end)
    self.TogGTCompose = CommonHelper:HButtonSetCallback("TogGTCompose", self.gameObject, function(data)
        self:SetToggleState(LabToggleType.GTCompose)
    end)

    self.TogRestore = CommonHelper:HButtonSetCallback("TogRestore", self.gameObject, function(data)
        self:SetToggleState(LabToggleType.Restore)
    end)

    self.BtnClose = CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(data)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(param)
        CommonHelper:ShowHelpView(PageDetailType.Lab)
    end)
end

function LabMainView:OnOpen()
    self:CheckNewBieGuide()
end

function LabMainView:ReOpen()
end
---@param labExpType LabExpType
function LabMainView:SetToggleState(labExpType, sendOpen, check)
    if sendOpen == nil then
        sendOpen = true
    end
    if check == nil then
        check = false
    end
    if LabDataManager:Get():GetLabToggleType() ~= labExpType or check then
        LabDataManager:Get():SetLabToggleType(labExpType)
        CommonHelper:SetToggleState(self.TogResolve, labExpType == LabToggleType.Resolve)
        CommonHelper:SetToggleState(self.TogNewCompose, labExpType == LabToggleType.Compose)
        CommonHelper:SetToggleState(self.TogLimitCompose, labExpType == LabToggleType.LimitCompose)
        CommonHelper:SetToggleState(self.TogRestore, labExpType == LabToggleType.Restore)
        CommonHelper:SetToggleState(self.TogGTCompose, labExpType == LabToggleType.GTCompose)
        self.LastView = self.CurView
        if labExpType == LabToggleType.Resolve then
            self.CurView = self.Page_LabResolve
        elseif labExpType == LabToggleType.Restore then
            self.CurView = self.Page_LabRestore
        elseif labExpType == LabToggleType.Compose then
            self.CurView = self.Page_LabCompound
        elseif labExpType == LabToggleType.LimitCompose then
            self.CurView = self.Page_LabLimitCompound
        elseif labExpType == LabToggleType.GTCompose then
            self.CurView = self.Page_LabLimitCompound
        end
        if self.LastView then
            ---@type Page_LabViewBase
            self.LastView:Close()
        end
        if sendOpen then
            self.CurView:SendOpen()
        end
    end
end
function LabMainView:InitViewInfo(_type)
    if _type then
        self:SetToggleState(_type, false, true)
    end
end
function LabMainView:OpenCurView()
    if self.CurView then
        ---@type Page_LabViewBase
        self.CurView:Open()
    end
end
function LabMainView:RefreshCurView()
    if self.CurView then
        ---@type Page_LabViewBase
        self.CurView:Refresh()
    end
end

function LabMainView:OnClose()
    if self.LastView then
        ---@type Page_LabViewBase
        self.LastView:Close()
        self.LastView = nil
    end
    CommonHelper:ReleasePool(UIModuleID.Lab)
end

