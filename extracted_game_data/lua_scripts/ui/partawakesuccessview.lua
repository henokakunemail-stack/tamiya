---@class PartAwakeSuccessView : ViewBase
PartAwakeSuccessView = class("PartAwakeSuccessView", ViewBase)

function PartAwakeSuccessView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PartAwakeSuccessViewAction")

end

function PartAwakeSuccessView:Awake()
    self.ScrollView = self:GetChildWight("ScrollView", typeof(MoreRowScrollView))
    self.BtnClose = CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)
    self.OldAge=self:GetChild("oldage")
    self.Age=self:GetChild("age")
end
---@param article ArticleCell
function PartAwakeSuccessView:SetData(article,oldData,type)
    CommonHelper:SetGameObjectActive("Awake", self.gameObject, type==1)
    CommonHelper:SetGameObjectActive("Up", self.gameObject, type==2)
    if type==2 then
        self:SetAge(article:GetGeneration()-1,self.OldAge)
        self:SetAge(article:GetGeneration(),self.Age)
    end
    CommonHelper:SetText("###partname", self.gameObject, CommonHelper:GetTempStr_Default(article:GetPartConfig().partname))
    CommonHelper:GetComponentSetUITexture("partIcon", self.gameObject, article:GetPartConfig().icon, UIModuleID.PartAwakeSuccess)
    CommonHelper:SetComponentUIParticleSetColor("fx_ui_part_jinjie_succesd_bg",self.gameObject,CommonHelper:GetColorByQuality(article:GetPartQuality()))
    local changeAttr={}
    for i = 1, #oldData do
        if oldData[i][2]~=article:GetPartAttr(oldData[i][1]) then
           table.insert(changeAttr,oldData[i])
        end
    end
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        CommonHelper:SetText("###name", itemObj, CommonHelper:GetAttrName(changeAttr[dataIndex+1][1]))
        CommonHelper:SetText("###old", itemObj, string.format("%0.2f",changeAttr[dataIndex+1][2]))
        CommonHelper:SetText("###new", itemObj, string.format("%0.2f",article:GetPartAttr(changeAttr[dataIndex+1][1])))
    end
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #changeAttr, 1, UpdateFunc, true)
end

function PartAwakeSuccessView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.PartAwakeSuccess)
end
function PartAwakeSuccessView:SetAge(age,parent)
    for i = 1, 4 do
        CommonHelper:SetGameObjectActive("age"..i,parent,age==i)
    end
end