local __ToggleState = false

---@class MessageBoxView : ViewBase
MessageBoxView = class("MessageBoxView", ViewBase)

MessageBoxView.BtnLayout = {
    OkCancel = 1,
    Ok = 2,
}


function MessageBoxView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "MessageBoxViewAction")

    print("---   MessageBoxView 初始化完成")
end

function MessageBoxView:Awake()
    print("---   MessageBoxView awake")

    --self.TitleGroup = UIUtil.GetChild("TitleCompoentWhite_2", self.gameObject)
    --self.BgGroup = UIUtil.GetChild("WindowBgWhite_1", self.gameObject)
    self.ArticleGroup = UIUtil.GetChild("Article", self.gameObject)
    self.TipsGroup = UIUtil.GetChild("Tips", self.gameObject)


end

function MessageBoxView:OnOpen()
    __ToggleState = true
    CommonHelper:SetToggleState(self.Toggle, __ToggleState)
end

function MessageBoxView:SetColorSystem(type)
    --CommonHelper:SetColorSystem_Btn(self.OkBtn.gameObject, type)
    --CommonHelper:SetColorSystem_Btn(self.CancelBtn.gameObject, type)
    --CommonHelper:SetColorSystem_Title2(self.TitleGroup, type)
    --CommonHelper:SetColorSystem_WindowBg1(self.BgGroup, type)
end

---@param param BoxParam
function MessageBoxView:SetLayout(param)
    self:SetColorSystem(param.color)
    local parent=self.TipsGroup
    if param.ViewType==MessageBoxHelp.ViewType.Article then
        parent=self.ArticleGroup
        if param.param then
            self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H",parent, typeof(MoreRowScrollView))
            CommonHelper:InitMoreRowScrollView(self.ScrollView, #param.param, 1,function(dataIndex, itemObj, scroll)
                local Itemparam = Param_ItemArticleParam()
                Itemparam.count = param.param[dataIndex+1].num
                CommonHelper:SetItemComGroup(itemObj, UIModuleID.MessageBoxView, param.param[dataIndex+1].id, Itemparam, function(btnData)
                    CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.MessageBoxView, false)
                end, param.param[dataIndex+1].id)
            end)
        end
    end
    CommonHelper:SetGameObjectActive("Article", self.gameObject,param.ViewType==MessageBoxHelp.ViewType.Article)
    CommonHelper:SetGameObjectActive("Tips", self.gameObject,param.ViewType==MessageBoxHelp.ViewType.Tips)
    self.BtnClose = CommonHelper:HButtonSetCallback("BtnClose", parent, function()
        MessageBoxHelp.Get():OnClickBtn(MessageBoxHelp.BtnType.Cancel, __ToggleState)
    end)
    self.OkBtn = CommonHelper:HButtonSetCallback("OkBtn", parent, function()
        MessageBoxHelp.Get():OnClickBtn(MessageBoxHelp.BtnType.OK, __ToggleState)
    end)
    self.CancelBtn = CommonHelper:HButtonSetCallback("CancelBtn", parent, function()
        MessageBoxHelp.Get():OnClickBtn(MessageBoxHelp.BtnType.Cancel, __ToggleState)
    end)
    self.MaskBtn = CommonHelper:HButtonSetCallback("MaskBtn", parent, function()
        MessageBoxHelp.Get():OnClickBtn(MessageBoxHelp.BtnType.Cancel, __ToggleState)
    end)
    self.Toggle = CommonHelper:HButtonSetCallback("ToggleState", parent, function()
        UINotify:Get():SendNotification(UINotifyEvent.MessageBoxView_ClickToggle)
    end)

    self.LeftPoint = UIUtil.GetChild("btnleftpoint", parent)
    self.RightPoint = UIUtil.GetChild("btnrightpoint", parent)
    self.CenterPoint = UIUtil.GetChild("btncenterpoint", parent)
    self.HidePoint = UIUtil.GetChild("btnhidepoint", parent)

    CommonHelper:SetText("title1", parent, param.title)
    CommonHelper:SetNewLineText("###DesTex", parent, param.text)
    CommonHelper:SetText("OkBtn/###text", parent, param.OkName)
    CommonHelper:SetText("CancelBtn/###text", parent, param.CancelName)
    self.BtnType=param.btntype
    if param.btntype == MessageBoxView.BtnLayout.OkCancel then
        UIUtil.SetParentGameObject(self.LeftPoint, self.CancelBtn.gameObject)
        UIUtil.SetParentGameObject(self.RightPoint, self.OkBtn.gameObject)
    else
        UIUtil.SetParentGameObject(self.HidePoint, self.CancelBtn.gameObject)
        UIUtil.SetParentGameObject(self.CenterPoint, self.OkBtn.gameObject)
    end

    CommonHelper:SetHButtonClick(self.BtnClose, param.isclose == true, true)
    self.Toggle.gameObject:SetActive(false)
end

function MessageBoxView:ClickToggle()
    __ToggleState = not __ToggleState
    CommonHelper:SetToggleState(self.Toggle, __ToggleState)
end
function MessageBoxView:OnBackKey()
    if self.BtnType == MessageBoxView.BtnLayout.OkCancel then
        MessageBoxHelp.Get():OnClickBtn(MessageBoxHelp.BtnType.Cancel, __ToggleState)
    end
end
