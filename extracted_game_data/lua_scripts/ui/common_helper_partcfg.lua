




---@param cfg parts_config_cell
local AnalyseChassis = function(cfg) --底盘
    local params = stringSplitToNumber(cfg.para, ',')
    local PortDown = PartPort_Groove()
    PortDown.Chassis_TailType = params[1]
    PortDown.Chassis_MotorType = params[2]
    return PortDown
end

---@param cfg parts_config_cell
local AnalyseTyre = function(cfg) --轮胎
    local params = stringSplitToNumber(cfg.para, ',')
    local PortDown = PartPort_Groove()
    PortDown.TyreRadius = params[1]
    PortDown.TyreWidth = params[2]
    return PortDown
end

---@param cfg parts_config_cell
local AnalyseHub = function(cfg) --轮毂
    local params = stringSplitToNumber(cfg.para, ',')
    local PortDown = PartPort_Groove()
    PortDown.HubRadius = params[1]
    PortDown.HubWidth = params[2]
    return PortDown
end

---@param cfg parts_config_cell
local AnalyseTail = function(cfg) --凤尾
    local params = tonumber(cfg.para)
    local PortDown = PartPort_Groove()
    PortDown.TailHoldType = params
    return PortDown
end

---@param cfg parts_config_cell
local AnalyseMotor = function(cfg) --马达
    local params = tonumber(cfg.para)
    local PortDown = PartPort_Groove()
    PortDown.MotorType = params
    return PortDown
end

---@param cfg parts_config_cell
local AnalysePulley = function(cfg) --马达
    local params = tonumber(cfg.para)
    local PortDown = PartPort_Groove()
    PortDown.PulleyType = params
    return PortDown
end



---@class PartPort_Groove 槽位数据
PartPort_Groove = class("PartPort_Groove")
function PartPort_Groove:initialize()
    self.Chassis_TailType = nil -- 底盘属性，凤尾类型 1.只有单孔凤尾挂点  2.只有双孔凤尾挂点  3.单双孔凤尾挂点
    self.Chassis_MotorType = nil -- 底盘属性，马达类型 1.单头马达 2.双头马达
    self.HubRadius = nil -- 轮毂属性，半径
    self.HubWidth = nil  -- 轮毂属性，宽度
    self.TyreRadius = nil -- 轮胎属性，半径
    self.TyreWidth = nil  -- 轮胎属性，宽度
    self.TailHoldType = nil  -- 凤尾属性， 1.单孔凤尾  2.双孔凤尾  3.特殊孔凤尾(s2)
    self.MotorType = nil  -- 马达属性，1.单头马达 2.双头马达
    self.PulleyType = nil  -- 导轮属性，直径，类型越大直径越大
end


---@param cfg dictpartbase_config_cell 解析装备配置表，构建端口数据
function CommonHelper:PartCalculate_AnalysePort(cfg)
    if cfg.parttype == PartType.Hub then
        cfg.PortData = AnalyseHub(cfg)
    elseif cfg.parttype == PartType.Tyre then
        cfg.PortData = AnalyseTyre(cfg)
    elseif cfg.parttype == PartType.Tail then
        cfg.PortData = AnalyseTail(cfg)
    elseif cfg.parttype == PartType.Chassis then
        cfg.PortData = AnalyseChassis(cfg)
    elseif cfg.parttype == PartType.Motor then
        cfg.PortData = AnalyseMotor(cfg)
    elseif cfg.parttype == PartType.Pulley then
        cfg.PortData = AnalysePulley(cfg)
    end

    return cfg
end

---@param cfg dictpartbase_config_cell 装备基础数据表
---@return dictpartbase_config_cell
function CommonHelper:GetPartBaseCfg(id)
    local result=nil
    ---@type dictparts_config_cell
    local  partCfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,id)
    if partCfg then
        result=CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config,partCfg.baseid)
    end
    return result
end

function CommonHelper:GetPartOrArticleName(id)
    ---@type dictparts_config_cell
    local  partCfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,id)
    if partCfg then
        return CommonHelper:GetTempStr_Default(partCfg.partname)
    end
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, id)
    if cfg then
        return CommonHelper:GetTempStr_Default(cfg.name)
    end
    return ""
end


---@return dictpartage_config_cell
function CommonHelper:GetPartAgeCfg(id,age)
    local result=nil
    ---@type dictparts_config_cell
    local  partCfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,id)
    if partCfg then
        ---@type dictpartage_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictpartage_config)
        result=cfg.GetAgeDataById(partCfg.baseid,age)
    end
    return result
end

---@param cfg dictpartbase_config_cell 装备基础数据表
function CommonHelper:GetPartCellCfg(id)
    local result=nil
    ---@type dictparts_config_cell
    local  partCfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,id)
    if partCfg then
        result=CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config,partCfg.baseid)
    end
    if result and result.parttype==2 then --2是车壳
        result=CommonHelper:GetTableDataByID(ConfigNames.dictpartcell_config,tonumber(result.para))
    end
    return result
end

---@return dictconsume_config_cell[]
function CommonHelper:GetConsumeGroup(id)
    ---@type dictconsume_config
    local  dropCfg=ClientDataManager:GetDataTable(ConfigNames.dictconsume_config)
   return dropCfg.GetCfgDataByDropId(id)
end
---@return dictpartsdevelop_config_cell
function CommonHelper:GetDevelopByEntryId(id)
    ---@type dictpartsdevelop_config
    local develop=ClientDataManager:Get():GetDataTable(ConfigNames.dictpartsdevelop_config)
    ---@type dictpartsdevelop_config_cell
    local cfg = develop.GetDevelopByEntryId(id)
    return cfg
end












