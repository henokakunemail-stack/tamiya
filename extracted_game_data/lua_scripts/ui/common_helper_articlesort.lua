


---@param list table<number, ArticleCell>
---@return table<number, table<number, ArticleCell>>[]
function CommonHelper:SortPart_Default(list)
    if list == nil then return nil end

    ---@type table<number, table<number, ArticleCell>>[]
    local result = {}

    local tempList = {}
    for i = 1, #list do
        local article = list[i]
        local type1 = GoodsType1.Part
        local type2 = article:GetPartType()
        local type3 = article:GetPartSubType()
        if tempList[type3] == nil then tempList[type3] = {} end
        table.insert(tempList[type3], list[i])
    end

    local dictsort = {}
    for k,v in pairs(tempList) do
        table.insert(dictsort, k)
    end
    table.sort(dictsort)

    for i = 1, #dictsort do
        local key = dictsort[i]
        local value = tempList[key]
        local data = {key, value}
        table.insert(result, data)
    end

    for i = 1, #result do
        local partlist = result[i][2]
        partlist = table.sort(partlist,function (a, b)

            --配件二级分类
            if a:GetPartType() > b:GetPartType() then return true end
            if a:GetPartType() < b:GetPartType() then return false end

            --配件三级分类
            if a:GetPartSubType() > b:GetPartSubType() then return true end
            if a:GetPartSubType() < b:GetPartSubType() then return false end
            --配件代
            if a:GetGeneration() > b:GetGeneration() then return true end
            if a:GetGeneration() < b:GetGeneration() then return false end
            --配件觉醒
            if not a:GetAwaken() and b:GetAwaken() then return true end
            if a:GetAwaken() and not b:GetAwaken() then return false end
            --配件星级
            if a:GetStar() > b:GetStar() then return true end
            if a:GetStar() < b:GetStar() then return false end

            --配件品质
            if a:GetPartQuality() > b:GetPartQuality() then return true end
            if a:GetPartQuality() < b:GetPartQuality() then return false end

            --配件cellid
            return a:GetCellID() > b:GetCellID()
        end)
    end

    return result
end


---@param list table<number, ArticleCell>
function CommonHelper:SortPart_1(list)
    ---@type table<number, ArticleCell>
    table.sort(list,function (a, b)

        --配件品质
        if a:GetPartQuality() > b:GetPartQuality() then return true end
        if a:GetPartQuality() < b:GetPartQuality() then return false end

        --配件二级分类
        if a:GetPartType() > b:GetPartType() then return false end
        if a:GetPartType() < b:GetPartType() then return true end

        --配件三级分类
        if a:GetPartSubType() > b:GetPartSubType() then return true end
        if a:GetPartSubType() < b:GetPartSubType() then return false end
        --配件代
        if a:GetGeneration() > b:GetGeneration() then return true end
        if a:GetGeneration() < b:GetGeneration() then return false end
        --配件觉醒
        if not a:GetAwaken() and b:GetAwaken() then return true end
        if a:GetAwaken() and not b:GetAwaken() then return false end

        --配件星级
        if a:GetStar() > b:GetStar() then return true end
        if a:GetStar() < b:GetStar() then return false end

        --配件cellid
        return a:GetCellID() > b:GetCellID()
    end)
    return list
end




---@param list table<number, AssembleSiftData>
---@param curarticle ArticleCell
---@return table<string, AssembleSiftData[]>[]
function CommonHelper:SortPart_AssembleSift(list, curarticle)
    if list == nil then return {} end

    ---@type table<string, AssembleSiftData[]>[]
    local result = {}
    local firstArticle = nil


    --{{{生成dict
    ---@type table<number, table<number, AssembleSiftData[]>>
    local tempDict = {}
    local sortDict = {}
    for i = 1, #list do
        local article = list[i]:GetArticle()
        local type1 = GoodsType1.Part
        local type2 = article:GetPartType()
        local type3 = article:GetPartSubType()

        if curarticle and curarticle:GetCellID() == article:GetCellID() then
            --正在使用的物品单独拿出来
            firstArticle = list[i]
        else
            if tempDict[type2] == nil then tempDict[type2] = {} end

            local secondDict = tempDict[type2]
            if secondDict[type3] == nil then
                secondDict[type3] = {}
                table.insert(sortDict, {type2, type3})
            end

            local thirdList = secondDict[type3]
            table.insert(thirdList, list[i])
        end
    end
    --}}}


    --{{{dict key 排序
    table.sort(sortDict, function(a, b)
        local AType2 = a[1]
        local AType3 = a[2]
        local BType2 = b[1]
        local BType3 = b[2]

        local Avaluelist = tempDict[AType2][AType3]
        local Bvaluelist = tempDict[BType2][BType3]
        local AEnable = false
        local BEnable = false

        for i = 1, #Avaluelist do
            if not Avaluelist[i]:IsFailDefault() then
                AEnable = true
                break
            end
        end
        for i = 1, #Bvaluelist do
            if not Bvaluelist[i]:IsFailDefault() then
                BEnable = true
                break
            end
        end


        --{{{有可用的配件放前
        if AEnable == true and BEnable == false then return true end
        if AEnable == false and BEnable == true then return false end
        --}}}


        --{{{二级分类
        if AType2 < BType2 then return true end
        if AType2 > BType2 then return false end
        --}}}

        --{{{三级分类
        return AType3 < BType3
        --}}}
    end)
    --}}}


    --for i = 1, #sortDict do
    --    log("---   ^^^   222", sortDict[i][1], sortDict[i][2])
    --end


    --{{{生成结果
    ---@type goodstype_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
    for i = 1, #sortDict do
        local type1 = GoodsType1.Part
        local type2 = sortDict[i][1]
        local type3 = sortDict[i][2]
        local valuelist = tempDict[type2][type3]
        local title = tab.GetDataType3(type1, type2, type3)


        --{{{同类配件排序
        table.sort(valuelist,function (a, b)
            --是否可用
            if not a:IsFail() and b:IsFail() then return true end
            if a:IsFail() and not b:IsFail() then return false end
            ---@type ArticleCell
            local articleA = a:GetArticle()
            local articleB = b:GetArticle()
            --配件品质
            if articleA:GetPartQuality() > articleB:GetPartQuality() then return true end
            if articleA:GetPartQuality() < articleB:GetPartQuality() then return false end
            --配件代
            if articleA:GetGeneration() > articleB:GetGeneration() then return true end
            if articleA:GetGeneration() < articleB:GetGeneration() then return false end
            --配件觉醒
            if not articleA:GetAwaken() and articleA:GetAwaken() then return true end
            if articleA:GetAwaken() and not articleA:GetAwaken() then return false end
            --配件星级
            if articleA:GetStar() > articleB:GetStar() then return true end
            if articleA:GetStar() < articleB:GetStar() then return false end
            --配件评分
            if articleA:GetPartScore() > articleB:GetPartScore() then return true end
            if articleA:GetPartScore() < articleB:GetPartScore() then return false end
            
            --配件配置表id
            return articleA:GetPartConfig().C_ID > articleB:GetPartConfig().C_ID
        end)
        --}}}


        local dict = {}
        dict[1] = title
        dict[2] = valuelist
        table.insert(result, dict)
    end
    --}}}


    --{{{当前使用装备插入最上层
    if firstArticle then
        local dict = {}
        dict[1] = CommonHelper:GetTempStr_Default(TemplateStringID.GaragePartlistSubheading)
        dict[2] = {firstArticle}
        table.insert(result,1, dict)
    end
    --}}}

    --for i = 1, #result do
    --    log("---   ^^^   ", result[i][1], #result[i][2])
    --end


    return result
end

---@return table<string, AssembleSiftData[]>[]
function CommonHelper:SortPartCfg_AssembleSift(list, curarticle)
    if list == nil then return {} end

    ---@type table<string, AssembleSiftData[]>[]
    local result = {}
    local firstArticle = nil


    --{{{生成dict
    ---@type table<number, table<number, AssembleSiftData[]>>
    local tempDict = {}
    local sortDict = {}
    for i = 1, #list do
        local article = list[i].PartBaseCfg
        local type1 = GoodsType1.Part
        local type2 = article.parttype
        local type3 = article.subtype

        if curarticle and curarticle.PartCfg.C_ID == list[i].PartCfg.C_ID then
            --正在使用的物品单独拿出来
            firstArticle = list[i]
        else
            if tempDict[type2] == nil then tempDict[type2] = {} end

            local secondDict = tempDict[type2]
            if secondDict[type3] == nil then
                secondDict[type3] = {}
                table.insert(sortDict, {type2, type3})
            end

            local thirdList = secondDict[type3]
            table.insert(thirdList, list[i])
        end
    end
    --}}}


    --{{{dict key 排序
    table.sort(sortDict, function(a, b)
        local AType2 = a[1]
        local AType3 = a[2]
        local BType2 = b[1]
        local BType3 = b[2]

        --local Avaluelist = tempDict[AType2][AType3]
        --local Bvaluelist = tempDict[BType2][BType3]
        --local AEnable = false
        --local BEnable = false

        --for i = 1, #Avaluelist do
        --    if not Avaluelist[i]:IsFailDefault() then
        --        AEnable = true
        --        break
        --    end
        --end
        --for i = 1, #Bvaluelist do
        --    if not Bvaluelist[i]:IsFailDefault() then
        --        BEnable = true
        --        break
        --    end
        --end
        --
        --
        ----{{{有可用的配件放前
        --if AEnable == true and BEnable == false then return true end
        --if AEnable == false and BEnable == true then return false end
        ----}}}


        --{{{二级分类
        if AType2 < BType2 then return true end
        if AType2 > BType2 then return false end
        --}}}

        --{{{三级分类
        return AType3 < BType3
        --}}}
    end)
    --}}}


    --for i = 1, #sortDict do
    --    log("---   ^^^   222", sortDict[i][1], sortDict[i][2])
    --end


    --{{{生成结果
    ---@type goodstype_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
    for i = 1, #sortDict do
        local type1 = GoodsType1.Part
        local type2 = sortDict[i][1]
        local type3 = sortDict[i][2]
        local valuelist = tempDict[type2][type3]
        local title = tab.GetDataType3(type1, type2, type3)


        --{{{同类配件排序
        table.sort(valuelist,function (a, b)
            --是否可用
            --if not a:IsFail() and b:IsFail() then return true end
            --if a:IsFail() and not b:IsFail() then return false end

            ---@type dictparts_config_cell
            local articleA = a.PartCfg
            local articleB = b.PartCfg
            ---@type dictpartbase_config_cell
            local articleABase = a.PartBaseCfg
            local articleBBase = b.PartBaseCfg

            --配件评分
            if articleA.score > articleB.score then return true end
            if articleA.score < articleB.score then return false end

            ----配件星级
            --if articleA:GetStar() > articleB:GetStar() then return true end
            --if articleA:GetStar() < articleB:GetStar() then return false end

            --配件品质
            if articleABase.fabric > articleBBase.fabric then return true end
            if articleABase.fabric < articleBBase.fabric then return false end

            --配件配置表id
            return articleA.C_ID > articleB.C_ID
        end)
        --}}}


        local dict = {}
        dict[1] = title
        dict[2] = valuelist
        table.insert(result, dict)
    end
    --}}}


    --{{{当前使用装备插入最上层
    if firstArticle then
        local dict = {}
        dict[1] = CommonHelper:GetTempStr_Default(TemplateStringID.GaragePartlistSubheading)
        dict[2] = {firstArticle}
        table.insert(result,1, dict)
    end
    --}}}

    --for i = 1, #result do
    --    log("---   ^^^   ", result[i][1], #result[i][2])
    --end


    return result
end


function CommonHelper:GetBagTypeByProp(type)
    ---@type dictcalc_config_cell
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config,CommonCfgKey.BagShowProp)
    local types=stringSplitToNumber(cfg.varval,':')
    local result=false
    for i = 1, #types do
        if type==types[i] then
            result=true
            break
        end
    end
    return result
end
function CommonHelper:GetBagTypeBySticker(type)
    ---@type dictcalc_config_cell
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config,CommonCfgKey.BagShowSticker)
    local types=stringSplitToNumber(cfg.varval,':')
    local result=false
    for i = 1, #types do
        if type==types[i] then
            result=true
            break
        end
    end
    return result
end

function CommonHelper:GetBagTypeByConsumables(type)
      local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config,CommonCfgKey.BagShowConsumables)
      local types=stringSplitToNumber(cfg.varval,':')
      local result=false
      for i = 1, #types do
        if type==types[i] then
            result=true
            break
        end
      end
      return result
end