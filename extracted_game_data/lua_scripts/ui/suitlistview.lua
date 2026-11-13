


---@class SuitListViewParam
SuitListViewParam = class("SuitListViewParam")

function SuitListViewParam:initialize()
    self.UIColor = UIColor.Blue
    self.CarIdx = -1
end



---@class SuitListView : ViewBase
SuitListView = class("SuitListView", ViewBase)

function SuitListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SuitListViewAction")
end

function SuitListView:Awake()
    self.TitleGroup = UIUtil.GetChild("TitleCompoentWhite_2", self.gameObject)
    self.BgGroup = UIUtil.GetChild("WindowBgWhite_1", self.gameObject)

    self.BtnSure = CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("SuitListView")
        --UINotify:Get():SendNotification(UINotifyEvent.GarageView_UpdateViewCache, false)
    end)
    self.BtnCancel = CommonHelper:HButtonSetCallback("BtnCancel",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("SuitListView")
        --UINotify:Get():SendNotification(UINotifyEvent.GarageView_UpdateViewCache, false)
    end)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))

end

function SuitListView:OnOpen()
    self.SelectCarIdx = -1
    self.SuitList = {}
end

function SuitListView:OnClose()

end

---@param param SuitListViewParam
function SuitListView:SetData(param)
    self.SelectCarIdx = param.CarIdx
    self.UIColor = param.UIColor

    CommonHelper:SetColorSystem_Btn(self.BtnSure.gameObject, param.UIColor)
    CommonHelper:SetColorSystem_Btn(self.BtnCancel.gameObject, param.UIColor)
    CommonHelper:SetColorSystem_Title2(self.TitleGroup, param.UIColor)
    CommonHelper:SetColorSystem_WindowBg1(self.BgGroup, param.UIColor)
end

function SuitListView:SetMsgData()
    self.SuitList = SuitDataManager:Get():GetSuitList()
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.SuitList, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)
end

function SuitListView:RefreshScroll()
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
end

function SuitListView:UpdateScrollView(dataIndex, itemObj)
    local data = self.SuitList[dataIndex + 1]
    if data == nil then return end

    CommonHelper:SetText("name", itemObj, data:GetName())

    CommonHelper:SetGameObjectActive("NotBlankPart", itemObj, data:IsBlank() == false)

    CommonHelper:SetGameObjectActive("StateLock", itemObj, data:GetLock())
    CommonHelper:SetGameObjectActive("StateUnlock", itemObj, not data:GetLock())

    CommonHelper:HButtonSetCallback("BtnUse",itemObj,function (hbtn)
        self:ClickItemUse(hbtn.intData)
    end, dataIndex)

    CommonHelper:HButtonSetCallback("BtnEditor",itemObj,function (hbtn)
        self:ClickItemEditor(hbtn.intData)
    end, dataIndex)

    CommonHelper:HButtonSetCallback("BtnUnlock",itemObj,function (hbtn)
        self:ClickItemUnlock(hbtn.intData)
    end, dataIndex)

    CommonHelper:HButtonSetCallback("BtnChangeName",itemObj,function (hbtn)
        self:ClickItemChangeName(hbtn.intData)
    end, dataIndex)
end

function SuitListView:ClickItemUse(dataIndex)
    local data = self.SuitList[dataIndex + 1]
    local iswarning, parts = self:CheckUsingParts(data, self.SelectCarIdx)
    if iswarning then
        UIManager:Get():OpenPopup("SuitWarningView", CanvasType.FrontCanvas, "SuitWarningView")
        local param = {self.UIColor, data:GetIdx(), self.SelectCarIdx, parts}
        UINotify:Get():SendNotification(UINotifyEvent.SuitWarningView_SetData, param)
    else
        SuitSubsystem:Get():SendMsg_UseSuit(self.SelectCarIdx, data:GetIdx())
    end

end

function SuitListView:ClickItemUnlock(dataIndex)
    local data = self.SuitList[dataIndex + 1]
    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SuitNotLock))
end

function SuitListView:ClickItemEditor(dataIndex)
    local data = self.SuitList[dataIndex + 1]
    SuitSubsystem:Get():SendMsg_GetDetail(data:GetIdx())

end

function SuitListView:ClickItemChangeName(dataIndex)
    local data = self.SuitList[dataIndex + 1]
    UIManager:Get():OpenPopup("CommonInputView", CanvasType.FrontCanvas, "CommonInputView")
    local param = CommonInputViewParam()
    param.TitleName = "更换方案名字"
    param.DefaultValue = data:GetName()
    param.Func = self.ChangeNameCB
    param.FuncClass = self
    param.FuncParam = data:GetIdx()
    UINotify:Get():SendNotification(UINotifyEvent.CommonInputView_SetData, param)

end

function SuitListView:ChangeNameCB(param, value)
    SuitSubsystem:Get():SendMsg_ChangeName(param, value)

    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
end








---@param suit SuitData
function SuitListView:CheckUsingParts(suit, caridx)
    if suit == nil then
        print("---   error:CheckUsingParts   suit = nil")
        return
    end

    local result = {}
    local parts = suit:GetParts()
    for i = 1, #parts do
        local temp = KnapsackDataManager:Get():GetArticleByID(parts[i])
        if temp and temp:GetCarId() ~= 0 and temp:GetCarId() ~= caridx then
            table.insert(result, temp)
        end
    end
    local iswarning = #result > 0
    return iswarning, result
end