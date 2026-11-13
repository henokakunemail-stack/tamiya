---@class WelfareView : ViewBase
WelfareView = class("WelfareView", ViewBase)

function WelfareView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "WelfareViewAction")
end

function WelfareView:Awake()
    self.ChooseBtnSVC = UIUtil.GetTypeChildWightByParent("ChooseBtnSVC", self.gameObject, typeof(MoreRowScrollView))
    self.PageView = {}
    self.CommonPageObj = {}
    self.CurActId = -1
    self:CacheData()
end

function WelfareView:CacheData()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function()
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome", self.gameObject, function(hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(false)
    end)

    self.selectIdx = nil

end

local _selectID = 1

function WelfareView:OnOpen()
    self:ViewFixScreen()

    _selectID = 1

    self:RefreshChooseBtn()
    self:ToggleOnClick(1)
    self:CheckNewBieGuide()
end

function WelfareView:ReOpen()
    if self:GetPageView(self.CurActId) then
        self:GetPageView(self.CurActId):RequestOpen()
    else
        _selectID = 1
        local _Data = WelfareVideoDataManager:Get():GetAllBtnData()
        self:GetPageView(_Data[1].C_ID):RequestOpen()
    end
    self:RefreshChooseBtn()
end

function WelfareView:RefreshChooseBtn()
    local allWelfareData = WelfareVideoDataManager:Get():GetAllBtnData()

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local welfareData = allWelfareData[dataIndex + 1]
        CommonHelper:SetGameObjectActive("choose", itemObj, _selectID == dataIndex + 1)
        CommonHelper:SetGameObjectActive("common", itemObj, _selectID ~= dataIndex + 1)
        local redPointActive = self:GetPageView(welfareData.C_ID):GetRedPointActive()
        CommonHelper:SetGameObjectActive("RedPoint1", itemObj, redPointActive)
        CommonHelper:SetText("choose/###Text", itemObj, CommonHelper:GetTempStr_Default(welfareData.actname))
        CommonHelper:SetText("common/###Text", itemObj, CommonHelper:GetTempStr_Default(welfareData.actname))

        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(btn)
            self:ToggleOnClick(btn.intData)
            _selectID = dataIndex + 1
            UINotify:Get():SendNotification(UINotifyEvent.WelfareVideoRefreshBtn)
        end, welfareData.C_ID)

    end
    CommonHelper:InitMoreRowScrollView(self.ChooseBtnSVC, #allWelfareData, 1, UpdateFunc, true, nil, false)

end

function WelfareView:ToggleOnClick(actId)
    if actId ~= self.CurActId and self:GetPageView(actId) then
        local lastActId = self.CurActId
        self.CurActId = actId
        self:GetPageView(actId):RequestOpen()
        print("lastActId  ----",lastActId)
        if self:GetPageView(lastActId) then
            self:GetPageView(lastActId):Close()
        end

    elseif actId ~= self.CurActId and actId == -1 then
        if self:GetPageView(self.CurActId) then
            self:GetPageView(self.CurActId):Close()
        end
        self.CurActId = actId
    end
end

function WelfareView:AutoClose()
    self.selectIdx = nil
    CommonHelper:ReleasePool(UIModuleID.Welfare)
end

function WelfareView:PageRunAction(data)
    local actId = data[1]
    if actId and self:GetPageView(actId) then
        table.remove(data, 1)
        self:GetPageView(actId):RunAction(data)
    end
end

function WelfareView:OpenActPage(actId)
    if actId ~= -1 then
        if self.CurActId == actId and self:GetPageView(actId) then
            self:GetPageView(actId):Open()
        end
    end
end

---@return Page_WelfareViewBase
function WelfareView:GetPageView(actId)
    if actId == -1 then
        return nil
    end
    return self.PageView[actId] and self.PageView[actId] or self:CreatePageView(actId)
end

function WelfareView:CreatePageView(actId)
    self.PageView[actId] = Page_WelfareViewBase.CreatePageActView(actId, self.gameObject)
    return self.PageView[actId]
end

function WelfareView:OnClose()
    self:ToggleOnClick(-1)

    self.selectIdx = nil

    CommonHelper:ReleasePool(UIModuleID.Welfare)
    PopupManager:Get():FirstPopupOnClose()
end



