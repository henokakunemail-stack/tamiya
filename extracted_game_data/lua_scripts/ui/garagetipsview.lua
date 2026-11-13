


---@class GarageTipsView : ViewBase
GarageTipsView = class("GarageTipsView", ViewBase)

function GarageTipsView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "GarageTipsViewAction")
end

function GarageTipsView:Awake()
    self.BaseAttrGroup = UIUtil.GetChild("fiveattrgroup", self.gameObject)
    self.SecondAttrGroup = UIUtil.GetChild("secondattrgroup", self.gameObject)
    self.FeatureAttrGroup = UIUtil.GetChild("featuregroup", self.gameObject)
    self.ReformAttrGroup = UIUtil.GetChild("reformgroup", self.gameObject)
    self.VerifyAttrGroup = UIUtil.GetChild("verifyattrgroup", self.gameObject)
    self.InheritGroup = UIUtil.GetChild("verifyattrgroup", self.gameObject)

    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
end

function GarageTipsView:OnOpen()

end

function GarageTipsView:OnClose()

end

function GarageTipsView:SetData(type, id, value)
    CommonHelper:SetGameObjectActive("fiveattrgroup", self.gameObject, type == GarageTipsTpye.BaseAttr)
    CommonHelper:SetGameObjectActive("secondattrgroup", self.gameObject, type == GarageTipsTpye.SecondAttr)
    CommonHelper:SetGameObjectActive("featuregroup", self.gameObject, type == GarageTipsTpye.Feature)
    CommonHelper:SetGameObjectActive("reformgroup", self.gameObject, type == GarageTipsTpye.Reform)
    CommonHelper:SetGameObjectActive("verifyattrgroup", self.gameObject, type == GarageTipsTpye.VerifyCarAttr)
    CommonHelper:SetGameObjectActive("inheritgroup", self.gameObject, type == GarageTipsTpye.Inherit)

    self:SetBaseAttr(type, id, value)
    self:SetSecondAttr(type, id, value)
    self:SetFeature(type, id, value)
    self:SetReform(type, id)
    self:SetVerifyAttr(type, id, value)
    self:SetInherit(type, id)
end

function GarageTipsView:SetBaseAttr(type, id, value)
    if type ~= GarageTipsTpye.BaseAttr then return end

    CommonHelper:SetText("###value", self.BaseAttrGroup, value)
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.CarFiveAttr)
    local FiveAttrTypes = stringSplitToNumber(cfg.varval, ':')
    for i = 1, #FiveAttrTypes do
        local obj = CommonHelper:SetGameObjectActive("FiveAttrTypes_"..i, self.BaseAttrGroup, FiveAttrTypes[i] == id)
        if id == FiveAttrTypes[i] then
            CommonHelper:SetText("###name", obj, CommonHelper:GetAttrName(FiveAttrTypes[i]))
            self:SetDes(CommonHelper:GetAttrDesc(FiveAttrTypes[i]))
        end
    end
end

function GarageTipsView:SetSecondAttr(type, id, value)
    if type ~= GarageTipsTpye.SecondAttr then return end

    CommonHelper:SetText("###value", self.SecondAttrGroup, value)
    CommonHelper:SetText("###name", self.SecondAttrGroup, CommonHelper:GetAttrName(id))
    self:SetDes(CommonHelper:GetAttrDesc(id))
end
function GarageTipsView:SetVerifyAttr(type, id, value)
    if type ~= GarageTipsTpye.VerifyCarAttr then return end
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.carinspectattr_config,id)
    local name=CommonHelper:GetTempStr_Default(cfg.attrname)
    local Desc=CommonHelper:GetTempStr_Default(cfg.attrdesc)
    CommonHelper:SetText("###value", self.VerifyAttrGroup, value)
    CommonHelper:SetText("###name", self.VerifyAttrGroup, name)
    self:SetDes(Desc)
end

function GarageTipsView:SetFeature(type, id, value)
    if type ~= GarageTipsTpye.Feature then return end

    ---@type attrfeature_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.attrfeature_config, id)

    for i = 1, 3 do
        local tempobj = CommonHelper:SetGameObjectActive("type"..i, self.FeatureAttrGroup, i == cfg.type)
        CommonHelper:GetComponentSetImage("icon", tempobj, cfg.icon, UIModuleID.Garage)
        CommonHelper:SetText("###name", tempobj, CommonHelper:GetTempStr_Default(cfg.char))
    end
    CommonHelper:SetText("###value", self.FeatureAttrGroup, value)
    self:SetDes(CommonHelper:GetTempStr_Default(cfg.desc))
end

function GarageTipsView:SetReform(type, id)
    if type ~= GarageTipsTpye.Reform then return end

    ---@type dictpartsdevelop_config
    local cfg = CommonHelper:GetDevelopByEntryId(id)
    CommonHelper:SetText("###name", self.ReformAttrGroup, CommonHelper:GetTempStr_Default(cfg.name))

    self:SetDes(CommonHelper:GetTempStr_Default(cfg.desc))
end

function GarageTipsView:SetInherit(type, id)
    if type ~= GarageTipsTpye.Inherit then return end

    ---@type dictinherit_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictinherit_config,id)
    CommonHelper:SetText("###name", self.InheritGroup, CommonHelper:GetTempStr_Default(cfg.inheritname))

    self:SetDes(CommonHelper:GetTempStr_Default(cfg.desc))
end




function GarageTipsView:SetDes(str)
    CommonHelper:SetText("###des", self.gameObject, str)
end