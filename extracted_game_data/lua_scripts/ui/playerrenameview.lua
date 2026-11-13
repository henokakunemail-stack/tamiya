
---@class PlayerRenameView : ViewBase
PlayerRenameView = class("PlayerRenameView", ViewBase)

function PlayerRenameView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PlayerRenameViewAction")
end

function PlayerRenameView:Awake()
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

function PlayerRenameView:OnOpen()
    self:SetData()
end

function PlayerRenameView:OnClose()

end


function PlayerRenameView:SetData(param)


    CommonHelper:SetText("###name", self.gameObject, PlayerDataManager:Get():GetPlayerName())
    CommonHelper:SetText("###value", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.PlayerRenameCost,KnapsackDataManager:Get():GetArticleCountByCfgid(12040401)))
    CommonHelper:SetInputFieldText("Input/Input75", self.gameObject,"")

end

function PlayerRenameView:OnClickBtn_Sure()
    local value = CommonHelper:GetInputFieldText("Input/Input75", self.gameObject)

    if  CommonHelper:IsNullOrEmpty(value) then
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InputFiledNoBeNull))
    else

        if  not CommonHelper:ReviewNicknameV2(value) then
            return
        end
        if value== PlayerDataManager:Get():GetPlayerName() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangeNameCardNoChange))
            return
        end
        if getStringLength(value)>16 then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangeNameNotLength))
            return
        end
        if KnapsackDataManager:Get():GetArticleCountByCfgid(ArticleIdDefine.ReNameCard) > 0 then
            PlayerInfoSubsystem:Get():SendMsg_ChangePlayerName(value)
        else
            --CommonHelper:OpenBuyDirectView( ArticleIdDefine.ReNameCard,1)
            CommonHelper:OpenBuyDirectView(ArticleIdDefine.ReNameCard, 1, false, BuyDirectType.rename)
        end

    end
end