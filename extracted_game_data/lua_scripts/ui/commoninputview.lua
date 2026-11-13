---@class CommonInputViewParam
CommonInputViewParam = class("CommonInputViewParam")
function CommonInputViewParam:initialize()
    self.UIColor = UIColor.Blue
    self.TitleName = ClientDataManager:Get():GetTemplateString(TemplateStringID.CommonInputDefaultHit)
    self.DefaultValue = ClientDataManager:Get():GetTemplateString(TemplateStringID.CommonInputDefaultTittle)
    self.InputHit = ""
    self.Func = nil
    self.FuncClass = nil
    self.FuncParam = nil
    self.CharacterLimit = 10
    self.CheckNull=true
end

---@class CommonInputView : ViewBase
CommonInputView = class("CommonInputView", ViewBase)

function CommonInputView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "CommonInputViewAction")
end

function CommonInputView:Awake()
    self.TitleGroup = UIUtil.GetChild("TitleCompoentWhite_2", self.gameObject)
    self.BgGroup = UIUtil.GetChild("WindowBgWhite_1", self.gameObject)

    self.BtnSure = CommonHelper:HButtonSetCallback("BtnSure", self.gameObject, function(hbtn)
        self:OnClickBtn_Sure()
    end)
    self.BtnCancel = CommonHelper:HButtonSetCallback("BtnCancel", self.gameObject, function(hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:SetInputFieldOnValueChanged("Input75/Input75", self.gameObject,function(str)
        local  text=CommonHelper:GetInputFieldText("Input75/Input75", self.gameObject)
        local  str=string.sub(text,#text,#text)
        if str=="\n" then
            text=string.sub(text,1,#text-1)
        end
        CommonHelper:SetInputFieldText("Input75/Input75", self.gameObject,text)
    end)
    self.Func = nil
    self.FuncClass = nil
    self.FuncParam = nil
end

function CommonInputView:OnOpen()

end

function CommonInputView:OnClose()

end

---@param param CommonInputViewParam
function CommonInputView:SetData(param)


    CommonHelper:SetText("###title", self.gameObject, param.TitleName)
    CommonHelper:SetText("###hit", self.gameObject, param.InputHit)
    CommonHelper:SetInputFieldText("Input75/Input75", self.gameObject, param.DefaultValue)
    CommonHelper:SetInputFieldCharacterLimit("Input75/Input75", self.gameObject, param.CharacterLimit)
    self.Func = param.Func
    self.FuncClass = param.FuncClass
    self.FuncParam = param.FuncParam
    self.CheckNull=param.CheckNull
end

function CommonInputView:OnClickBtn_Sure()
    local value = CommonHelper:GetInputFieldText("Input/Input75", self.gameObject)

    if self.CheckNull and CommonHelper:IsNullOrEmpty(value) then
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InputFiledNoBeNull))
    else

        if  not CommonHelper:ReviewNicknameV2(value) then
            return
        end

        if self.FuncClass then
            self.Func(self.FuncClass, self.FuncParam, value)
        else
            self.Func(self.FuncParam, value)
        end
        UIManager:Get():ClosePopup()
    end
end