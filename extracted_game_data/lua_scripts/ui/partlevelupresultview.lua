


---@class PartLevelupResultView : ViewBase
PartLevelupResultView = class("PartLevelupResultView", ViewBase)

function PartLevelupResultView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PartLevelupResultViewAction")
end

function PartLevelupResultView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.ScrollView = self:GetChildWight("ScrollView", typeof(MoreRowScrollView))
end

function PartLevelupResultView:OnOpen()
    self:CheckNewBieGuide()
end

function PartLevelupResultView:OnClose()
   self:CheckExitNewBieGuide()
    CommonHelper:ReleasePool(UIModuleID.PartStarResult)
end

---@param oldattrs table<number, PartAttrData>
---@param article ArticleCell
function PartLevelupResultView:SetData(article,oldlv,oldattrs)
    local curlv = article:GetPartLV()
    CommonHelper:SetText("###partname", self.gameObject, CommonHelper:GetTempStr_Default(article:GetPartConfig().partname))
    CommonHelper:SetText("###lvold", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.PartLevelUpLVFormat,oldlv))
    CommonHelper:SetText("###lvnew", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.PartLevelUpLVFormat,curlv))
    CommonHelper:GetComponentSetUITexture("partIcon", self.gameObject, article:GetPartConfig().icon, UIModuleID.PartAwakeSuccess)
    CommonHelper:SetComponentUIParticleSetColor("fx_ui_part_level_bg",self.gameObject,CommonHelper:GetColorByQuality(article:GetPartQuality()))
    local changeAttr={}
    for i = 1, #oldattrs do
        if oldattrs[i].value~=article:GetPartAttr(oldattrs[i].type) then
            table.insert(changeAttr,oldattrs[i])
        end
    end
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        CommonHelper:SetText("###name", itemObj, CommonHelper:GetAttrName(changeAttr[dataIndex+1].type))
        CommonHelper:SetText("###old", itemObj, string.format("%0.2f",changeAttr[dataIndex+1].value))
        CommonHelper:SetText("###new", itemObj, string.format("%0.2f",article:GetPartAttr(changeAttr[dataIndex+1].type)))
    end
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #changeAttr, 1, UpdateFunc, true)
end


