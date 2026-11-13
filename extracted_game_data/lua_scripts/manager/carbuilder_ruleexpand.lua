


--{{{ 高级组装规则，导轮挂点重置
----根据槽位id 获取能装最大半径导轮槽位id，然后获取该槽位id的组装规则，重置其挂点位置 对称挂点位置
function CarBuilder:Expand_PulleyResetPoint(grooveid, point, symhpoint)
    local resultpoint = point
    local resultsymhpoint = symhpoint

    -----------根据槽位id 得到扩展位的 槽位列表， 得到最大的导轮半径的槽位id--------------
    ---@type assembleruleexpand_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.assembleruleexpand_config)
    ---@type assembleruleexpand_config_cell
    local cfgdata = tab.GetRule(grooveid, AssembleRuleExpandType.WheelResetPoint)
    if cfgdata then
        local param = stringSplitToNumber(cfgdata.param1, ',')
        local grooveid = -1
        local temp = -1
        for i = 1, #param do
            local partid = self:GetPartDataID(param[i])
            if partid > 0 then
                local cfg = self:GetPartBaseCfg(partid)
                if cfg and cfg.PortData then
                    local pulleytype = cfg.PortData.PulleyType
                    if pulleytype and pulleytype > temp then
                        temp = pulleytype
                        grooveid = param[i]
                    end
                end
            end
        end

        local cfg = CarAssembleRule:Get():GetAssembleRuleCfg(self.PartDataList, grooveid)
        if cfg then
            resultpoint = cfg.hpoint
            resultsymhpoint = cfg.symhpoint
        end
        if AssembleLogEnable then log("---   <<<<<<< 5 组装扩展机制，导轮挂点重置：",grooveid,point, symhpoint,resultpoint, resultsymhpoint)  end

    end

    return resultpoint, resultsymhpoint
end
--}}}
