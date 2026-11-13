


---@class ReformResultView : ViewBase
ReformResultView = class("ReformResultView", ViewBase)

function ReformResultView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ReformResultViewAction")
end

function ReformResultView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.ScrollView = self:GetChildWight("ScrollView", typeof(MoreRowScrollView))
end

function ReformResultView:OnOpen()
    self:CheckNewBieGuide()
end

function ReformResultView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.PartStarResult)
    self:CheckNewBieGuide("GarageView")
end

function ReformResultView:SetData(iswin, bagid, reformid, oldattr,openType)

    local data = KnapsackDataManager:Get():GetArticleByID(bagid)
    local quality=0
    if data then
        if data:GetPartReformByEntryId(reformid) then
            quality=data:GetPartReformByEntryId(reformid).quality
        else
            iswin=false
        end
    end
    CommonHelper:PlaySfxByReform(quality)
    CommonHelper:SetGameObjectActive("normal", self.gameObject, iswin and quality == 1)
    CommonHelper:SetGameObjectActive("hight", self.gameObject, iswin and quality == 2)
    CommonHelper:SetGameObjectActive("perfact", self.gameObject, iswin and quality == 3)
    CommonHelper:SetGameObjectActive("reformfailgroup", self.gameObject,not iswin and openType==1)
    CommonHelper:SetGameObjectActive("reformreplacefailgroup", self.gameObject,not iswin and openType==2)
    CommonHelper:SetGameObjectActive("groupattr", self.gameObject, iswin)
    CommonHelper:SetGameObjectActive("groupattrfail", self.gameObject, not iswin and openType==2)
    CommonHelper:GetComponentSetUITexture("particon", self.gameObject, data:GetPartConfig().icon, UIModuleID.ReformResult)
    CommonHelper:SetComponentUIParticleSetColor("fx_ui_part_jinjie_succesd_bg",self.gameObject,CommonHelper:GetColorByQuality(data:GetPartQuality()))

    CommonHelper:SetText("###partname", self.gameObject, CommonHelper:GetTempStr_Default(data:GetPartConfig().partname))

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        CommonHelper:SetText("###name", itemObj, CommonHelper:GetAttrName(oldattr[dataIndex+1][1]))
        CommonHelper:SetText("###old", itemObj, string.format("%0.2f",oldattr[dataIndex+1][3]))
        CommonHelper:SetText("###new", itemObj, string.format("%0.2f",oldattr[dataIndex+1][2]))
    end
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #oldattr, 1, UpdateFunc, true)
end

