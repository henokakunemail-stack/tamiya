


---@class ReformStrongResultView : ViewBase
ReformStrongResultView = class("ReformStrongResultView", ViewBase)

function ReformStrongResultView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ReformStrongResultViewAction")
end

function ReformStrongResultView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.ScrollView = self:GetChildWight("ScrollView", typeof(MoreRowScrollView))
end

function ReformStrongResultView:OnOpen()

end

function ReformStrongResultView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.PartStrongResult)
end

function ReformStrongResultView:SetData(bagid, oldattr, idx)

    local article = KnapsackDataManager:Get():GetArticleByID(bagid)

    CommonHelper:SetComponentUIParticleSetColor("fx_ui_part_level_bg",self.gameObject,CommonHelper:GetColorByQuality(article:GetPartQuality()))


    CommonHelper:GetComponentSetUITexture("particon", self.gameObject, article:GetPartConfig().icon, UIModuleID.PartStrongResult)

    CommonHelper:SetText("###partname", self.gameObject, CommonHelper:GetTempStr_Default(article:GetPartConfig().partname))

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        CommonHelper:SetText("###name", itemObj, CommonHelper:GetAttrName(oldattr[dataIndex+1][1]))
        CommonHelper:SetText("###old", itemObj, string.format("%0.2f",oldattr[dataIndex+1][3]))
        CommonHelper:SetText("###new", itemObj, string.format("%0.2f",oldattr[dataIndex+1][2]))
    end
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #oldattr, 1, UpdateFunc, true)
end