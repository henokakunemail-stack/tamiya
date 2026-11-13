

local __ToggleState = false


---@class ArticleMessageBoxView : ViewBase
ArticleMessageBoxView = class("ArticleMessageBoxView",ViewBase)

ArticleMessageBoxView.BtnLayout = {
    OkCancel = 1,
    Ok = 2,
}
ArticleMessageBoxView.ComponentType = {
    Part = 1,
    Article = 2,
    TrackSegment=3
}

function ArticleMessageBoxView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ArticleMessageBoxView")

    print("---   ArticleMessageBoxView 初始化完成")
end

function ArticleMessageBoxView:Awake()
    print("---   ArticleMessageBoxView awake")

    self.TitleGroup = UIUtil.GetChild("TitleCompoentWhite_2", self.gameObject)
    self.BgGroup = UIUtil.GetChild("WindowBgWhite_1", self.gameObject)

    self.OkBtn = CommonHelper:HButtonSetCallback("OkBtn",self.gameObject,function ()
        MessageBoxHelp.Get():OnClickBtn(MessageBoxHelp.BtnType.OK,__ToggleState)
    end)
    self.CancelBtn = CommonHelper:HButtonSetCallback("CancelBtn",self.gameObject,function ()
        MessageBoxHelp.Get():OnClickBtn(MessageBoxHelp.BtnType.Cancel,__ToggleState)
    end)
    self.CloseBtn = CommonHelper:HButtonSetCallback("CloseBtn",self.gameObject,function ()
        MessageBoxHelp.Get():OnClickBtn(MessageBoxHelp.BtnType.Cancel,__ToggleState)
    end)
    self.MaskBtn = CommonHelper:HButtonSetCallback("MaskBtn",self.gameObject,function ()
        MessageBoxHelp.Get():OnClickBtn(MessageBoxHelp.BtnType.Cancel,__ToggleState)
    end)
    self.Toggle = CommonHelper:HButtonSetCallback("ToggleState",self.gameObject,function ()
        UINotify:Get():SendNotification(UINotifyEvent.ArticleMessageBoxView_ClickToggle)
    end)
    self.articleComponent= self:GetChildWight("ArticleCompoent",typeof(CanvasGroup))
    self.partComponent= self:GetChildWight("PartCompoent",typeof(CanvasGroup))
    self.trackSegmentComponent= self:GetChildWight("TrackSegmentCompoent",typeof(CanvasGroup))

end

function ArticleMessageBoxView:OnOpen()
    __ToggleState = true
    CommonHelper:SetToggleState(self.Toggle, __ToggleState)
end

function ArticleMessageBoxView:SetColorSystem(type)
    CommonHelper:SetColorSystem_Btn(self.OkBtn.gameObject, type)
    CommonHelper:SetColorSystem_Btn(self.CancelBtn.gameObject, type)
    CommonHelper:SetColorSystem_Title2(self.TitleGroup, type)
    CommonHelper:SetColorSystem_WindowBg1(self.BgGroup, type)
end

---@param param ArticleBoxParam
function ArticleMessageBoxView:SetLayout(param)
    self:SetColorSystem(param.color)
    if param.ComponentType==ArticleMessageBoxView.ComponentType.Part then
        UIUtil.ShowCanvasGroup(self.partComponent,true)
        CommonHelper:SetPartGroup(self.partComponent.gameObject,param.ComponentData)
    end
    if param.ComponentType==ArticleMessageBoxView.ComponentType.Article then
        UIUtil.ShowCanvasGroup(self.articleComponent,true)
        CommonHelper:SetPartGroup(self.articleComponent.gameObject,param.ComponentData)
    end
    if param.ComponentType==ArticleMessageBoxView.ComponentType.TrackSegment then
        UIUtil.ShowCanvasGroup(self.trackSegmentComponent,true)
        CommonHelper:SetPartGroup(self.trackSegmentComponent.gameObject,param.ComponentData)
    end


    CommonHelper:SetText("TitleCompoentWhite_2/title1", self.gameObject, param.title)
    local topText= CommonHelper:SetText("TopDesc", self.gameObject, param.topText)
    local bottomText= CommonHelper:SetText("ButtomDesc", self.gameObject, param.bottomText)
    CommonHelper:SetText("OkBtn/text", self.gameObject, param.OkName)
    CommonHelper:SetText("CancelBtn/text", self.gameObject, param.CancelName)

    if param.isShowTop then
        UIUtil:TextLocalPositionY(topText, 719)
        UIUtil:TextLocalPositionY(bottomText, 491)

    else
        CommonHelper:SetText("TopDesc", self.gameObject, "")
        UIUtil:TextLocalPositionY(bottomText, 551)

    end

    if param.isShowBottom ~=false then
        CommonHelper:SetText("ButtomDesc", self.gameObject, "")
    end

    if param.btntype == ArticleMessageBoxView.BtnLayout.OkCancel then
        UIUtil:HButtonLocalPositionX(self.OkBtn, 295)
        UIUtil:HButtonLocalPositionX(self.CancelBtn, -265)
    else
        UIUtil:HButtonLocalPositionX(self.OkBtn, 0)
        UIUtil:HButtonLocalPositionX(self.CancelBtn, 800)
    end

    self.CloseBtn.gameObject:SetActive(param.isclose or false)

    self.Toggle.gameObject:SetActive(false)
end

function ArticleMessageBoxView:ClickToggle()
    __ToggleState = not __ToggleState
    CommonHelper:SetToggleState(self.Toggle, __ToggleState)
end
