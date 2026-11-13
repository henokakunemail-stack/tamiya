
---@class ClubRenameView : ViewBase
ClubRenameView = class("ClubRenameView", ViewBase)

function ClubRenameView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ClubRenameViewAction")
end

function ClubRenameView:Awake()
    self.TitleGroup = UIUtil.GetChild("TitleCompoentWhite_2", self.gameObject)
    self.BgGroup = UIUtil.GetChild("WindowBgWhite_1", self.gameObject)

    self.BtnSure = CommonHelper:HButtonSetCallback("BtnSure", self.gameObject, function(hbtn)
        self:OnClickBtn_Sure()
    end)
    self.BtnSure = CommonHelper:HButtonSetCallback("BtnBuy", self.gameObject, function(hbtn)

    end)
    self.BtnCancel = CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(hbtn)
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
end

function ClubRenameView:OnOpen()
    self:SetData()
end

function ClubRenameView:OnClose()

end


function ClubRenameView:SetData(param)


    CommonHelper:SetText("###name", self.gameObject, ClubDataManager:Get():GetCurSelectClubData():GetName())
    CommonHelper:SetText("###value", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.PlayerRenameCost,KnapsackDataManager:Get():GetArticleCountByCfgid(ArticleIdDefine.ClubReNameCard)))
    CommonHelper:SetInputFieldText("Input/Input75", self.gameObject,"")

end

function ClubRenameView:OnClickBtn_Sure()
    local value = CommonHelper:GetInputFieldText("Input/Input75", self.gameObject)

    if  CommonHelper:IsNullOrEmpty(value) then
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InputFiledNoBeNull))
    else

        if  not CommonHelper:ReviewNicknameV2(value) then
            return
        end
        if value== ClubDataManager:Get():GetCurSelectClubData():GetName() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangeNameCardNoChange))
            return
        end
        if getStringLength(value)>16 then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangeNameNotLength))
            return
        end
      if PlayerDataManager:Get():CheckCurrencyEnough(ArticleIdDefine.ClubReNameCard,1) then
            ClubSubsystem:Get():SendMsg_GuildChangeName(ClubDataManager:Get():GetCurSelectClubData():GetId(), value)
      end

    end
end