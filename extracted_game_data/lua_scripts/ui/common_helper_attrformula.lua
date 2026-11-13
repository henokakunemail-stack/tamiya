



---@param partcfg dictpartbase_config_cell
---@param attrCfg attrtype_config_cell
local getStaticParam = function(attrCfg, partcfg)
    local result={}
    if attrCfg then
        local param=stringSplit(attrCfg.formulaparm,',')
        for i = 1, #param do
            local temp=0
            if param[i] and param[i]=="parm1" then temp=partcfg.parm1 end
            if param[i] and param[i]=="parm2" then temp=partcfg.parm2 end
            if param[i] and param[i]=="parm3" then temp=partcfg.parm3 end
            if param[i] and param[i]=="parm4" then temp=partcfg.parm4 end
            if param[i] and param[i]=="parm5" then temp=partcfg.parm5 end
            table.insert(result,temp)
        end
    end
    return result
end
---@param param PartAttrData[]
local getAttrValue=function(param,id)
    local result =CommonHelper:GetTableDataByID(ConfigNames.attrtype_config,id).init
    if param[id] and param[id].value~=0 then
        result=param[id].value
    end
    return result
end


---@param param table<number, PartAttrData>
---@param partcfg dictpartbase_config_cell
---@param attrCfg attrtype_config_cell
local formula1 = function(attrCfg,startvalue, param, partcfg)
    --速度=初始值+【转速/10+空气下压力/2+传动效率/100+（6000-轮胎滚动摩擦）/100+（4000-转速损失）/10】*3.5/齿轮比
    local p = getStaticParam(attrCfg, partcfg)
    local v1 = getAttrValue(param,1)  --转速
    local v2 = getAttrValue(param,6)  --空气下压力
    local v3 = getAttrValue(param,9)  --传动效率
    local v4 = p[1]				--轮胎滚动摩擦系数
    local v5 = getAttrValue(param,13) --轮胎滚动摩擦
    local v6 = p[2]				--转速损失系数
    local v7 = getAttrValue(param,14) --转速损失
    local v8 = getAttrValue(param,19)--齿轮比

	local v9 = p[3]				--导轮摩擦系数
	local v10 =getAttrValue(param,16) --导轮摩擦

    local result = startvalue + ( v1 * 0.1 + v2 * 0.5 + v3 * 0.01 + (v4 - v5) * 0.01 + (v6 - v7) * 0.1 +(v9 - v10)*0.1) * 3.5 / v8

    return result
end


---@param param table<number, PartAttrData>
---@param partcfg parts_config_cell
---@param attrCfg attrtype_config_cell
local formula2 = function(attrCfg,startvalue, param, partcfg)
    --加速=初始值+【扭矩+（1200-空气阻力）/4+传动效率/100+轮胎抓地力/5+（4000-扭矩损失）/10】*齿轮比/3.5
    local p = getStaticParam(attrCfg, partcfg)
    local v1 = getAttrValue(param,2)  --扭矩
    local v2 = p[1]				--空气阻力系数
    local v3 = getAttrValue(param,7)  --空气阻力
    local v4 = getAttrValue(param,9)  --传动效率
    local v5 = getAttrValue(param,12) --轮胎抓地力
    local v6 = p[2]				--扭矩损失系数
    local v7 = getAttrValue(param,15) --扭矩损失
    local v8 = getAttrValue(param,19) --齿轮比

    local result = startvalue + ( v1 + (v2 - v3) * 0.25 + v4 * 0.01 + v5 * 0.2 + (v6 - v7) * 0.1 ) * v8 / 3.5
    return result
end


---@param param table<number, PartAttrData>
---@param partcfg parts_config_cell
---@param attrCfg attrtype_config_cell
local formula3 = function(attrCfg,startvalue, param, partcfg)
    --气动外形=初始值+空气下压力/2+（1200-空气阻力）/4
    local p = getStaticParam(attrCfg, partcfg)
    local v1 = getAttrValue(param,6)  --空气下压力
    local v2 = p[1]
    local v3 = getAttrValue(param,7)  --空气阻力

    --local result = startvalue + v1 * 0.5 + (v2 - v3) * 0.25
	local result = 1
    return result
end


---@param param table<number, PartAttrData>
---@param partcfg parts_config_cell
---@param attrCfg attrtype_config_cell
local formula4 = function(attrCfg,startvalue, param, partcfg)
    --动力损失=初始值+传动效率/100+（4000-转速损失）/10+（4000-扭矩损失）/10
    local p = getStaticParam(attrCfg, partcfg)
    local v1 = getAttrValue(param,9)  --传动效率
    local v2 = p[1]
    local v3 = getAttrValue(param,14)  --转速损失
    local v4 = p[2]
    local v5 = getAttrValue(param,15)  --扭矩损失

    --local result = startvalue + v1 * 0.01 + (v2 - v3) * 0.1 + (v4 - v5) * 0.1
	local result = 1
    return result
end


---@param param table<number, PartAttrData>
---@param partcfg parts_config_cell
---@param attrCfg attrtype_config_cell
local formula5 = function(attrCfg,startvalue, param, partcfg)
    --轮胎摩擦=初始值+轮胎抓地力/5+（6000-轮胎滚动摩擦）/100
    local p = getStaticParam(attrCfg, partcfg)
    local v1 = getAttrValue(param,12)  --轮胎抓地力
    local v2 = p[1]
    local v3 =getAttrValue(param,19)   --轮胎滚动摩擦

    --local result = startvalue + v1 * 0.2 + (v2 - v3) * 0.01
	local result = 1
    return result
end


---@param param table<number, PartAttrData>
---@param partcfg parts_config_cell
---@param attrCfg attrtype_config_cell
local formula6 = function(attrCfg,startvalue, param, partcfg)
    --稳定=稳定
    local v1 = getAttrValue(param,3)  --稳定

    local result = startvalue + v1
    return result
end


---@param param table<number, PartAttrData>
---@param partcfg parts_config_cell
---@param attrCfg attrtype_config_cell
local formula7 = function(attrCfg,startvalue, param, partcfg)
    --耐久=耐久
    local v1 = getAttrValue(param,4)  --耐久

    local result = startvalue + v1
    return result
end


---@param param table<number, PartAttrData>
---@param partcfg parts_config_cell
---@param attrCfg attrtype_config_cell
local formula8 = function(attrCfg,startvalue, param, partcfg)
    --重量=重量
    local v1 = getAttrValue(param,5)  --重量

    local result = startvalue + v1
    return result
end



local FormulaTab = {}
FormulaTab[1] = formula1
FormulaTab[2] = formula2
FormulaTab[3] = formula3
FormulaTab[4] = formula4
FormulaTab[5] = formula5
FormulaTab[6] = formula6
FormulaTab[7] = formula7
FormulaTab[8] = formula8
















---@param param table<number, PartAttrData>
---@param partcfg dictpartbase_config_cell
function CommonHelper:AttrFormulaCalculate(type, startvalue, param, partcfg)
    local result = 0
    if param[type] then result = param[type].value end

    ---@type attrtype_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, type)
    if cfg == nil then
        return result
    end

    if cfg.formula == -1 then
        return result
    end

    local func = FormulaTab[cfg.formula]
    if func then
        result = func(cfg,startvalue, param, partcfg)
        return result
    end

    logError("---   error:缺少属性计算公式...   type = ",cfg.formula)
    return result
end













