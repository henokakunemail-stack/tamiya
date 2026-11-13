


---@class DevelopStarResultView : ViewBase
DevelopStarResultView = class("DevelopStarResultView", ViewBase)

function DevelopStarResultView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "DevelopStarResultViewAction")
end

function DevelopStarResultView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
end

function DevelopStarResultView:OnOpen()

end

function DevelopStarResultView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.PartStarResult)
end

---@param data ArticleCell
function DevelopStarResultView:SetData(data)
    if data == nil then return end
    CommonHelper:SetText("###partname", self.gameObject, CommonHelper:GetTempStr_Default(data:GetPartConfig().partname))
    CommonHelper:SetComponentUIParticleSetColor("fx_ui_part_level_bg",self.gameObject,CommonHelper:GetColorByQuality(data:GetPartQuality()))
    CommonHelper:GetComponentSetUITexture("particon", self.gameObject, data:GetPartConfig().icon, UIModuleID.PartStarResult)

    CommonHelper:SetPartStar("PartStar",self.gameObject,data:GetStar(),data:GetPartBaseCfg().maxstar)

    CommonHelper:SetText("###attrname", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.PartStarAttr))
    CommonHelper:SetText("###attrvalue", self.gameObject, tostring(data:GetPartReformPosCount(data:GetStar() - 1)))
    CommonHelper:SetText("###attrvaluenew", self.gameObject, tostring(data:GetPartReformPosCount(data:GetStar())))


end