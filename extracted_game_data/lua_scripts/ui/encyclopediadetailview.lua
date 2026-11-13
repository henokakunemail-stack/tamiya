---@class EncyclopediaDetailView : ViewBase
EncyclopediaDetailView = class("EncyclopediaDetailView", ViewBase)

function EncyclopediaDetailView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "EncyclopediaDetailViewAction")
end

function EncyclopediaDetailView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask1",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("EncyclopediaDetailView")
    end)

end

function EncyclopediaDetailView:OnOpen()
end

function EncyclopediaDetailView:OnClose()
end
function EncyclopediaDetailView:SetData(name,imageName,desc)
    CommonHelper:SetText("###name", self.gameObject,  CommonHelper:GetTempStr_Default(name))
    CommonHelper:SetNewLineText("###desc", self.gameObject,  CommonHelper:GetTempStr_Default(desc))
    CommonHelper:GetComponentSetUITexture("Iocn", self.gameObject, imageName, UIModuleID.Encyclopedia)
end