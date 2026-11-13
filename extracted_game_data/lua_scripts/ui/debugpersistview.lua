---@class DebugPersistView : ViewBase
DebugPersistView = class("DebugPersistView", ViewBase)

function DebugPersistView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "DebugPersistViewAction")
end

function DebugPersistView:Awake()

    self.leftCount = 0
    self.rightCount = 0

    self:InitBtnFunc()
end

function DebugPersistView:InitBtnFunc()
    CommonHelper:HButtonSetCallback("LeftBtn", self.gameObject, function()
        self:OnBtnClick(self.leftCount)
    end)

    CommonHelper:HButtonSetCallback("RightBtn", self.gameObject, function()
        self:OnBtnClick(self.rightCount)
    end)
end

function DebugPersistView:OnBtnClick(count)
    count = count + 1
    if self.leftCount == 3 and self.rightCount == 3 then
        Debug.unityLogger.logEnabled = true
        PlayerPrefsHelper:SetValue_IsDebug("true")
        print("开启debug模式")
    end
end



