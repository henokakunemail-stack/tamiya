







--{{{设置矩形配件item
---@class Param_PartItem
Param_PartItem = class("Param_PartItem")
function Param_PartItem:initialize()
    self.moduleId = UIModuleID.None
    self.partId = -1
    self.star = -1
    self.quality = -1
    self.funClick = nil
    self.funClickParam = nil
    self.generation=1
end

---@param param Param_PartItem
function CommonHelper:SetPartItem(gameObject, param)
    ---@type parts_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, param.partId)
    local star = param.star
    local quality = param.quality
    local generation=param.generation
    local icon = ""
    if param.star == -1 then star = 0 end
    if param.quality == -1 and cfg then quality = cfg.quality end
    if cfg then icon = cfg.icon
        if generation and generation>2 then
            if generation==2 then icon=cfg.icon2 end
            if generation==3 then icon=cfg.icon3 end
            if generation==4 then icon=cfg.icon4 end
        end
    end


    CommonHelper:SetComponentPartStar("PartStar",gameObject,star)
    --CommonHelper:GetComponentSetImage("quality", gameObject, CommonHelper:GetAssembleMapPartQualityImage(quality), param.moduleId)
    CommonHelper:GetComponentSetUITexture("icon", gameObject, icon, param.moduleId)

    for i = 1, 6 do
        CommonHelper:SetGameObjectActive("itemquality"..i, gameObject, quality == i)
    end

    for i = 2,4  do
        CommonHelper:SetGameObjectActive("generation_"..i,gameObject,generation==i)
    end

    local btnitem = CommonHelper:HButtonSetCallback("BtnItem",gameObject,function (hbtn)
        if param.funClick then param.funClick(param.partId, param.funClickParam) end
    end)
    CommonHelper:SetHButtonClick(btnitem, param.funClick ~= nil, true)
end
--}}}



--{{{设置正方形配件item
---@class Param_PartItemSquare
Param_PartItemSquare = class("Param_PartItemSquare")
function Param_PartItemSquare:initialize()
    self.moduleId = UIModuleID.None
    self.partId = -1
    self.star = -1
    self.quality = -1
    self.funClick = nil
    self.funClickParam = nil
end

---@param param Param_PartItemSquare
function CommonHelper:SetPartItemSquare(gameObject, param)
    ---@type parts_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, param.partId)
    local star = param.star
    local quality = param.quality
    local icon = ""
    if param.star == -1 then star = 0 end
    if param.quality == -1 and cfg then quality = cfg.quality end
    if cfg then icon = cfg.icon end

    CommonHelper:SetComponentPartStar("PartStar",gameObject,star)
    CommonHelper:GetComponentSetImage("quality", gameObject, CommonHelper:GetSquareQualityImage(quality), param.moduleId)
    CommonHelper:GetComponentSetUITexture("icon", gameObject, icon, param.moduleId)


    local btnitem = CommonHelper:HButtonSetCallback("BtnItem",gameObject,function (hbtn)
        if param.funClick then param.funClick(param.partId, param.funClickParam) end
    end)
    CommonHelper:SetHButtonClick(btnitem, param.funClick ~= nil, true)
end
--}}}

























---------------------------------------------------填充部件item
---@class Param_PartGroup
Param_PartGroup = class("Param_PartGroup")
function Param_PartGroup:initialize()
    self.moduleId = nil
    self.partId = nil
    self.star = 1
    self.strongLv = nil

    self.isShowPartFeature = false
    self.carIdx = -1

    self.carIcon = nil
    self.carName = ""
    self.quality = 1

    self.isGray=false
    self.ClickShowTips=false
end

---@param param Param_PartGroup
function CommonHelper:SetPartGroup(gameObject, param)
    if param == nil then return end

    if param.moduleId == nil then param.moduleId = UIModuleID.None end

    ---@field tableData parts_config_cell
     local tableData=CommonHelper:GetTableDataByID(ConfigNames.parts_config,param.partId)
    param.carIcon=tableData.icon
    param.carName=tableData.name
    param.quality=  param.quality or tableData.fabric
    local rewImage= CommonHelper:GetComponentSetUITexture("icon", gameObject, param.carIcon, param.moduleId)
    local quality =nil
    if param.quality ~= nil then
        quality=  CommonHelper:GetComponentSetImage("quality", gameObject, CommonHelper:GetPartQualityImage(param.quality), param.moduleId)
    end
    local PartFeature=UIUtil.GetChild("PartFeature",gameObject)
    if PartFeature then
        PartFeature:SetActive(param.isShowPartFeature)
    end
    CommonHelper:SetText("###name",gameObject,ClientDataManager:Get():GetTemplateString(param.carName) or "")

    CommonHelper:SetText("###strongLv",gameObject,param.strongLv or "")

    CommonHelper:SetComponentPartStar("PartStar",gameObject,param.star or 0)

    if quality ~= nil then
        CommonHelper:ImageSetGray(quality,param.isGray)
    end
    CommonHelper:ImageSetGray(rewImage,param.isGray)

    for i = 1, 5 do
        CommonHelper:SetGameObjectActive("flag_"..i, gameObject, i == (param.carIdx + 1))
    end

end
---------------------------------------------------






