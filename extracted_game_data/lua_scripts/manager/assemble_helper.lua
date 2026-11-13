


---@class AssembleHelper 组装系统的通用计算方法
AssembleHelper = class("AssembleHelper")

function AssembleHelper:initialize()
end


--{{{从背包中筛选配件
---@param grooveNode AssembleNode
---@return table<number, AssembleSiftData>
function AssembleHelper:GetPartsByGroove(grooveNode)
    local hublimit = self:PartCalculate_HubLimit(grooveNode)
    local result = AssembleHelper:PartCalculate_FindPartsAtBag(grooveNode, hublimit)
    return result
end


---@param port PartPort_Groove
---@param type PartType
---@param node AssembleNode
---@return table<number, AssembleSiftData>
function AssembleHelper:PartCalculate_FindPartsAtBag(node, hublimit)
    -- 查找背包中可用的配件，检查端口是否匹配，检查槽位id是否匹配，检查需要配件id
    local result = {}
    ---@type table<number, ArticleCell>
    local templist = KnapsackDataManager:Get():GetEquipmentsByGroove(node:GetGrooveId())
    for i = 1, #templist do
        local temp = AssembleHelper:Fitter(node, templist[i], hublimit)
        table.insert(result, temp)
    end
    return result
end
--}}}
---@param data ArticleCell
---@return table<number, dictparts_config[]>
function AssembleHelper:GetPartCfgsByBaseId(data)
    ---@type dictparts_config
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.parts_config)
    local result={}
    ---@type dictparts_config_cell[]
    local list=cfg.GetPartListByBaseIdCanCopy(data:GetPartBaseCfg().C_ID)
    local otherdict={}
    otherdict[1] = CommonHelper:GetTempStr_Default(TemplateStringID.GarageOtherColorSubheading)
    otherdict[2] = {}
    for i = 1, #list do
        if list[i].C_ID~=data:GetID() then
           table.insert(otherdict[2],list[i])
        end
    end
    table.insert(result,otherdict)
    return result
end
---@param data ArticleCell
---@param defaultcost ArticleCell
---@return table<number, ArticleCell[]>
function AssembleHelper:GetArticleListByBaseId(data,defaultcost)
    ---@type ArticleCell[]
    local templist=KnapsackDataManager:Get():GetPartListByBaseId(data:GetPartBaseCfg().C_ID)
    local list1={}
    local list2={}
    local result={}
          result[TemplateStringID.AdvancedCostUseArticle]=list1
          result[TemplateStringID.AdvancedCostNotUseArticle]=list2
    for i = 1, #templist do
        local temp=templist[i]
        if temp:GetPartDownType()==PartDownType.Self and temp:GetCellID()~=data:GetCellID() then
            if not temp:GetAwaken() and temp:GetStar()==1 and temp:GetPartLV()==1 and temp:GetGeneration()==1 and #temp:GetCurPartInheritList()<1 and  temp:GetPartLock()==0 and temp:GetCarId()==0 then
                local select=false
                local selectIndex=0
                for i = 1, #defaultcost do
                    if temp:GetCellID()==defaultcost[i] then
                        select=true
                        selectIndex=i
                        break
                    end
                end
                table.insert(list1,{data=temp,select=select,type=AdvancedPartType.Use,desc="",selectIndex=selectIndex})
            else
                local errors={}
                if temp:GetAwaken() then table.insert(errors,CommonHelper:GetTempStr_Default(TemplateStringID.PartAwake)) end
                if temp:GetStar()>1 then table.insert(errors,CommonHelper:GetTempStr_Default(TemplateStringID.PartStar)) end
                if temp:GetPartLV()>1 then table.insert(errors,CommonHelper:GetTempStr_Default(TemplateStringID.PartLevel)) end
                if temp:GetGeneration()>1 then table.insert(errors,CommonHelper:GetTempStr_Default(TemplateStringID.PartGeneration)) end
                if #temp:GetCurPartInheritList()>0 then table.insert(errors,CommonHelper:GetTempStr_Default(TemplateStringID.PartInherit)) end
                if temp:GetPartLock()~=0 then table.insert(errors,CommonHelper:GetTempStr_Default(TemplateStringID.PartLock)) end
                if temp:GetCarId()~=0 then table.insert(errors,CommonHelper:GetTempStr_Default(TemplateStringID.PartUse,temp:GetCarId())) end
                local desc=""
                for i = 1, #errors do
                    if i==#errors then
                        desc=desc..errors[i]
                    else
                        desc=desc..errors[i]..","
                    end
                end
                desc= CommonHelper:GetTempStr_Default(TemplateStringID.PartNotUse,desc)
                table.insert(list2,{data=temp,select=false,type=AdvancedPartType.NotUse,desc=desc,selectIndex=0})
            end
        end
    end
    return result
end

---@param data ArticleCell
---@return table<number, dictparts_config[]>
function AssembleHelper:GetPartsBySubType(data)
    local result={}
    ---@type table<number, ArticleCell>
    local list = KnapsackDataManager:Get():GetEquipmentsByPartChildType(data:GetPartType(),data:GetPartSubType())
    ---@type goodstype_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
    local otherdict={}
    otherdict[1] = tab.GetDataType3(GoodsType1.Part, data:GetPartType(), data:GetPartSubType())
    otherdict[2] = {}
    for i = 1, #list do
        if list[i]:GetCellID()~=data:GetCellID() then
            table.insert(otherdict[2],list[i])
        end
    end
    --{{{同类配件排序
    table.sort(otherdict[2],function (a, b)
        local articleA = a
        local articleB = b
        --配件代
        if a:GetGeneration() > b:GetGeneration() then return true end
        if a:GetGeneration() < b:GetGeneration() then return false end
        --配件觉醒
        if not a:GetAwaken() and b:GetAwaken() then return true end
        if a:GetAwaken() and not b:GetAwaken() then return false end
        --配件评分
        if articleA:GetPartScore() > articleB:GetPartScore() then return true end
        if articleA:GetPartScore() < articleB:GetPartScore() then return false end

        --配件星级
        if articleA:GetStar() > articleB:GetStar() then return true end
        if articleA:GetStar() < articleB:GetStar() then return false end

        --配件品质
        if articleA:GetPartQuality() > articleB:GetPartQuality() then return true end
        if articleA:GetPartQuality() < articleB:GetPartQuality() then return false end

        --配件配置表id
        return articleA:GetPartConfig().C_ID > articleB:GetPartConfig().C_ID
    end)
        --}}}
    table.insert(result,otherdict)
    return result
end



--{{{计算轮毂的半径限制条件
---@param node CarDetailData
function AssembleHelper:PartCalculate_HubLimit(node) --
    if node:GetGrooveId() ~= PartGrooveID.FHub and node:GetGrooveId() ~= PartGrooveID.BHub then
        return nil
    end

    local fhub = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.FHub)
    local bhub = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.BHub)
    if fhub:GetBagId() == -1 and bhub:GetBagId() == -1 then
        return -1
    end
    if fhub:GetPartBaseCfg() and bhub:GetPartBaseCfg() then
        if fhub:GetPartBaseCfg().PortData.HubRadius == bhub:GetPartBaseCfg().PortData.HubRadius then
            return -1
        end
    end


    if fhub:GetGrooveId() == node:GetGrooveId() then
        if fhub:GetBagId() ~= -1 then
            return -1
        else
            return bhub:GetPartBaseCfg().PortData.HubRadius
        end
    end
    if bhub:GetGrooveId() == node:GetGrooveId() then
        if bhub:GetBagId() ~= -1 then
            return -1
        else
            return fhub:GetPartBaseCfg().PortData.HubRadius
        end
    end

    print("---   error:PartCalculate_HubLimit, 检测算法异常")
    return -1
end
--}}}


--{{{检测算法，判定槽位是不是固定槽位,固定槽位不需要开启限制  默认开启的槽位
---@param grooveId PartGrooveID
function AssembleHelper:Check_StaticNode(grooveId)
    local result = false
    if grooveId == PartGrooveID.Chassis then result = true
    elseif grooveId == PartGrooveID.Shell then result = true
    elseif grooveId == PartGrooveID.Gears then result = true
    elseif grooveId == PartGrooveID.Motor then result = true
    elseif grooveId == PartGrooveID.FHub then result = true
    elseif grooveId == PartGrooveID.BHub then result = true
    elseif grooveId == PartGrooveID.FTyre then result = true
    elseif grooveId == PartGrooveID.BTyre then result = true
    elseif grooveId == PartGrooveID.Head then result = true
        --elseif grooveId == PartGrooveID.Tail then result = true
    elseif grooveId == PartGrooveID.PulleyFrontButtom then result = true
    elseif grooveId == PartGrooveID.Strong1 then result = true
    elseif grooveId == PartGrooveID.Strong2 then result = true
        --elseif grooveId == PartGrooveID.FBrake then result = true
        --elseif grooveId == PartGrooveID.BBrake then result = true
    elseif grooveId == PartGrooveID.Strong3 then result = true
    elseif grooveId == PartGrooveID.Strong4 then result = true
    elseif grooveId == PartGrooveID.GP then result = true
    end

    return result
end
--}}}


--{{{配件安装在车上后，开启的槽位列表
---@param cfg parts_config_cell
function AssembleHelper:AnalysePartOpenGrooveID(grooveid, cfg)
    local result = {}
    if cfg then
        local temp = cfg.NewPosrelation[grooveid]
        if temp then
            for i = 1, #temp do
                if temp[i] ~= -1 then table.insert(result, temp[i]) end
            end
        end
    end
    return result
end
--}}}




--{{{组装适配算法
---@param node AssembleNode
---@param articledata ArticleCell
function AssembleHelper:Fitter(node, articledata, hublimit)
    if articledata and node then
        local temp = AssembleSiftData()
        temp.Article = articledata
        temp.File_Using = not AssembleHelper:Fitter_CompareUsing(node, articledata)
        temp.File_OnlyOne = not AssembleHelper:Fitter_CompareOnlyOne(node, articledata)
        temp.File_Stronger = not AssembleHelper:Fitter_CompareStrongPart(node, articledata)
        temp.File_Tail = not AssembleHelper:Fitter_CompareTail(node, articledata)
        temp.File_Hub = not AssembleHelper:Fitter_CompareHub(hublimit, node, articledata)
        temp.File_Tyre = not AssembleHelper:Fitter_CompareTyre( node, articledata)
        temp.File_Motor = not AssembleHelper:Fitter_CompareMotor( node, articledata)
        temp.File_DingDing = not AssembleHelper:Fitter_CompareDingDing( node, articledata)
        temp.File_Exp =  AssembleHelper:Fitter_IsExp( node, articledata)
        return temp
    end
    return nil
end
--}}}

--{{{组装适配算法,检查配件是否使用了
---@param node CarDetailData
---@param articledata ArticleCell
function AssembleHelper:Fitter_CompareUsing(node, articledata)
    if articledata == nil then
        return false
    end

    if articledata:IsPart() == false then
        return false
    end


    if articledata:GetCarId() > 0 and node:GetCarIdx() ~= articledata:GetCarId() then
        return false
    end

    return true
end
--}}}

--{{{组装适配算法，检查当前配件是不是在当前车的其他槽位上使用了
---@param node AssembleNode
---@param articledata ArticleCell
function AssembleHelper:Fitter_CompareOnlyOne(node, articledata)
    if articledata == nil then
        return false
    end

    if articledata:IsPart() == false then
        return false
    end

    for k,v in pairs(PartGrooveID) do
        local temp = node.assembleMgr:GetNodeByGrooveID(v)
        if temp then
            if temp:GetBagId() > 0 and temp:GetBagId() == articledata:GetCellID() and node:GetGrooveId() ~= v then
                return false
            end
        end
    end
    return true
end
--}}}

--{{{组装适配算法,检查增强位配件是否使用过相同类型
---@param node AssembleNode
---@param articledata ArticleCell
function AssembleHelper:Fitter_CompareStrongPart(node, articledata) --
    local childtype = articledata:GetPartSubType()
    local curgrooveid = node:GetGrooveId()
    if curgrooveid ~= PartGrooveID.Strong1 and curgrooveid ~= PartGrooveID.Strong2 and curgrooveid ~= PartGrooveID.Strong3 and curgrooveid ~= PartGrooveID.Strong4
       and curgrooveid ~= PartGrooveID.Strong5 and curgrooveid ~= PartGrooveID.Strong6 and curgrooveid ~= PartGrooveID.Strong7 and curgrooveid ~= PartGrooveID.Strong8 then
        return true
    end

    if curgrooveid ~= PartGrooveID.Strong1 then
        local strongnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Strong1)
        if strongnode:GetPartBaseCfg() and childtype == strongnode:GetPartBaseCfg().subtype then
            return false
        end
    end

    if curgrooveid ~= PartGrooveID.Strong2 then
        local strongnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Strong2)
        if strongnode:GetPartBaseCfg() and childtype == strongnode:GetPartBaseCfg().subtype then
            return false
        end
    end

    if curgrooveid ~= PartGrooveID.Strong3 then
        local strongnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Strong3)
        if strongnode:GetPartBaseCfg() and childtype == strongnode:GetPartBaseCfg().subtype then
            return false
        end
    end

    if curgrooveid ~= PartGrooveID.Strong4 then
        local strongnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Strong4)
        if strongnode:GetPartBaseCfg() and childtype == strongnode:GetPartBaseCfg().subtype then
            return false
        end
    end
  if curgrooveid ~= PartGrooveID.Strong5 then
        local strongnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Strong5)
        if strongnode:GetPartBaseCfg() and childtype == strongnode:GetPartBaseCfg().subtype then
            return false
        end
    end
  if curgrooveid ~= PartGrooveID.Strong6 then
        local strongnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Strong6)
        if strongnode:GetPartBaseCfg() and childtype == strongnode:GetPartBaseCfg().subtype then
            return false
        end
    end
  if curgrooveid ~= PartGrooveID.Strong7 then
        local strongnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Strong7)
        if strongnode:GetPartBaseCfg() and childtype == strongnode:GetPartBaseCfg().subtype then
            return false
        end
    end
  if curgrooveid ~= PartGrooveID.Strong8 then
        local strongnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Strong8)
        if strongnode:GetPartBaseCfg() and childtype == strongnode:GetPartBaseCfg().subtype then
            return false
        end
    end

    return true
end
--}}}

--{{{组装适配算法，特殊配件适配算法,检查凤尾是否可以安装到底盘上
---@param node AssembleNode
---@param articledata ArticleCell
function AssembleHelper:Fitter_CompareTail(node, articledata) -- 检查凤尾是否可以安装到底盘上
    if node:GetGrooveId() ~= PartGrooveID.Tail then return true end

    local tailFag = articledata:GetPartBaseCfg().PortData.TailHoldType

    local chassisNode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Chassis)
    local chassisFag = chassisNode:GetPartBaseCfg().PortData.Chassis_TailType

    if tailFag == PartCfgParamType.Tail_Hole1 then
        if (chassisFag == PartCfgParamType.Chassis_TailOne or chassisFag == PartCfgParamType.Chassis_TailBoth) then
            return true
        end
    end
    if tailFag == PartCfgParamType.Tail_Hole2 then
        if (chassisFag == PartCfgParamType.Chassis_TailTwo or chassisFag == PartCfgParamType.Chassis_TailBoth) then
            return true
        end
    end
    if tailFag == PartCfgParamType.Tail_S2 and chassisNode:GetPartCfg().type1 == 2 then
        return true
    end
    return false
end
--}}}

--{{{组装适配算法，特殊配件适配算法,检查前后轮毂匹配
---@param node AssembleNode
---@param articledata ArticleCell
function AssembleHelper:Fitter_CompareHub(limit, node, articledata)
    if limit == nil then return true end -- 不是轮毂
    if limit == -1 then return true end -- 轮毂没有尺寸限制

    if articledata:GetPartBaseCfg().PortData.HubRadius == limit then
        return true
    end

    return false
end
--}}}

--{{{组装适配算法，特殊配件适配算法,检查轮胎是否可以装在轮毂上
---@param node AssembleNode
---@param articledata ArticleCell
function AssembleHelper:Fitter_CompareTyre(node, articledata) --

    if node:GetGrooveId() ~= PartGrooveID.FTyre and node:GetGrooveId() ~= PartGrooveID.BTyre then return true end

    local hubR
    local hubW
    if node:GetGrooveId() == PartGrooveID.FTyre then
        local hub = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.FHub)

        if hub:GetBagId() <= 0 then return false end
        hubR = hub:GetPartBaseCfg().PortData.HubRadius
        hubW = hub:GetPartBaseCfg().PortData.HubWidth
    end

    if node:GetGrooveId() == PartGrooveID.BTyre then
        local hub = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.BHub)

        if hub:GetBagId() <= 0 then return false end
        hubR = hub:GetPartBaseCfg().PortData.HubRadius
        hubW = hub:GetPartBaseCfg().PortData.HubWidth
    end

    local r = articledata:GetPartBaseCfg().PortData.TyreRadius
    local w = articledata:GetPartBaseCfg().PortData.TyreWidth


    if r == hubR and w <= hubW then
        return true
    end

    return false
end
--}}}

--{{{组装适配算法，特殊配件适配算法，检查马达是否可以安装到底盘上
---@param node AssembleNode
---@param articledata ArticleCell
function AssembleHelper:Fitter_CompareMotor(node, articledata) --
    if node:GetGrooveId() ~= PartGrooveID.Motor then return true end

    local motorFlag = articledata:GetPartBaseCfg().PortData.MotorType

    local chassisNode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Chassis)
    local chassisFfag = chassisNode:GetPartBaseCfg().PortData.Chassis_MotorType

    if motorFlag == chassisFfag then
        return true
    end

    return false
end
--}}}
--{{{组装适配算法，特殊配件适配算法，检查中翼是否装配平衡杆
---@param node AssembleNode
---@param articledata ArticleCell
function AssembleHelper:Fitter_CompareDingDing(node, articledata) --
    if node:GetGrooveId() ~= PartGrooveID.PulleyMiddleButtom1 then return true end
    if articledata:GetPartBaseCfg().parttype==PartType.Pulley then return true end
    local MiddleNode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Middle)
    if MiddleNode:GetPartId(false)==0 then
        return false
    end
    if articledata:GetPartBaseCfg().parttype==PartType.Nail then
        if articledata:GetPartBaseCfg().subtype==PartDingDingType.DingDing1 or
           articledata:GetPartBaseCfg().subtype==PartDingDingType.DingDing2 or
           articledata:GetPartBaseCfg().subtype==PartDingDingType.DingDing3 or
           articledata:GetPartBaseCfg().subtype==PartDingDingType.DingDing4 or
           articledata:GetPartBaseCfg().subtype==PartDingDingType.DingDing6 then
           return true

        end 
    end
    return false
end
--}}}
--{{{组装适配算法，特殊配件适配算法，检查中翼是否装配平衡杆
---@param node AssembleNode
---@param articledata ArticleCell
function AssembleHelper:Fitter_IsExp(node, articledata) --
    if articledata == nil then
        return false
    end

    if articledata:IsPart() == false then
        return false
    end

    return articledata:IsExp()
end
--}}}







--{{{数据构建模板，服务器索引号转客户端槽位id
function AssembleHelper:MsgIdxToGrooveID(idx)
    if idx == 4              then return   PartGrooveID.Shell end
    if idx ==  1 then return PartGrooveID.Chassis             end
    if idx ==  2 then return PartGrooveID.Gears               end
    if idx ==  3 then return PartGrooveID.Motor               end
    if idx ==  5 then return PartGrooveID.GP                  end
    if idx ==  6 then return PartGrooveID.FHub                end
    if idx ==  7 then return PartGrooveID.BHub                end
    if idx ==  8 then return PartGrooveID.FTyre               end
    if idx ==  9 then return PartGrooveID.BTyre               end
    if idx == 10 then return PartGrooveID.Head                end
    if idx == 11 then return PartGrooveID.Wing                end
    if idx == 12 then return PartGrooveID.Tail                end
    if idx == 13 then return PartGrooveID.Front               end
    if idx == 14 then return PartGrooveID.Middle              end
    if idx == 15 then return PartGrooveID.Rear                end
    if idx == 16 then return PartGrooveID.PulleyRearCenter    end
    if idx == 17 then return PartGrooveID.PulleyFrontButtom   end
    if idx == 18 then return PartGrooveID.PulleyMiddleButtom1 end
    if idx ==19              then return   PartGrooveID.PulleyRearButtom end
    if idx == 20 then return PartGrooveID.PulleyFrontMinus    end
    if idx == 21 then return PartGrooveID.PulleyMiddleMinus   end
    if idx == 22 then return PartGrooveID.PulleyMiddleButtom2 end
    if idx == 23 then return PartGrooveID.PulleyRearMinus     end
    if idx ==24              then return   PartGrooveID.PulleyShell end
    if idx == 25 then return PartGrooveID.FBrake              end
    if idx == 26 then return PartGrooveID.BBrake              end
    if idx == 27 then return PartGrooveID.Strong1             end
    if idx == 28 then return PartGrooveID.Strong2             end
    if idx == 29 then return PartGrooveID.Strong3             end
    if idx == 30 then return PartGrooveID.Strong4             end
    if idx == 31 then return PartGrooveID.PulleyFrontCenter   end
    if idx == 32 then return PartGrooveID.PulleyMiddleCenter  end
    if idx == 33 then return PartGrooveID.Front2              end
    if idx == 34 then return PartGrooveID.Front3              end
    if idx == 35 then return PartGrooveID.Rear2               end
    if idx == 36 then return PartGrooveID.Rear3               end
    if idx == 37 then return PartGrooveID.FrontExtr2          end
    if idx == 38 then return PartGrooveID.RearExtr2           end
    if idx == 39 then return PartGrooveID.FrontExtr3          end
    if idx == 40 then return PartGrooveID.RearExtr3           end
    if idx == 41 then return PartGrooveID.TopRailRear           end
    if idx == 42 then return PartGrooveID.TopRailFront           end
    if idx == 43 then return PartGrooveID.Strong5           end
    if idx == 44 then return PartGrooveID.Strong6           end
    if idx == 45 then return PartGrooveID.Strong7           end
    if idx == 46 then return PartGrooveID.Strong8           end
    if idx == 47 then return PartGrooveID.RearWing           end
end
--}}}


--{{{数据构建模板，客户端槽位id转服务器索引号
function AssembleHelper:GrooveIDToMsgIdx(grooveid)
    if grooveid == PartGrooveID.Shell               then return  4  end
    if grooveid == PartGrooveID.Chassis             then return  1 end
    if grooveid == PartGrooveID.Gears               then return  2 end
    if grooveid == PartGrooveID.Motor               then return  3 end
    if grooveid == PartGrooveID.GP                  then return  5 end
    if grooveid == PartGrooveID.FHub                then return  6 end
    if grooveid == PartGrooveID.BHub                then return  7 end
    if grooveid == PartGrooveID.FTyre               then return  8 end



    if grooveid == PartGrooveID.BTyre               then return  9 end
    if grooveid == PartGrooveID.Head                then return 10 end
    if grooveid == PartGrooveID.Wing                then return 11 end
    if grooveid == PartGrooveID.Tail                then return 12 end
    if grooveid == PartGrooveID.Front               then return 13 end
    if grooveid == PartGrooveID.Middle              then return 14 end
    if grooveid == PartGrooveID.Rear                then return 15 end
    if grooveid == PartGrooveID.PulleyRearCenter    then return 16 end
    if grooveid == PartGrooveID.PulleyFrontButtom   then return 17 end
    if grooveid == PartGrooveID.PulleyMiddleButtom1 then return 18 end
    if grooveid == PartGrooveID.PulleyRearButtom    then return 19  end
    if grooveid == PartGrooveID.PulleyFrontMinus    then return 20 end
    if grooveid == PartGrooveID.PulleyMiddleMinus   then return 21 end
    if grooveid == PartGrooveID.PulleyMiddleButtom2 then return 22 end
    if grooveid == PartGrooveID.PulleyRearMinus     then return 23 end
    if grooveid == PartGrooveID.PulleyShell         then return 24  end
    if grooveid == PartGrooveID.FBrake              then return 25 end
    if grooveid == PartGrooveID.BBrake              then return 26 end
    if grooveid == PartGrooveID.Strong1             then return 27 end
    if grooveid == PartGrooveID.Strong2             then return 28 end
    if grooveid == PartGrooveID.Strong3             then return 29 end
    if grooveid == PartGrooveID.Strong4             then return 30 end





    if grooveid == PartGrooveID.PulleyFrontCenter   then return 31 end
    if grooveid == PartGrooveID.PulleyMiddleCenter  then return 32 end
    if grooveid == PartGrooveID.Front2              then return 33 end
    if grooveid == PartGrooveID.Front3              then return 34 end



    if grooveid == PartGrooveID.Rear2               then return 35 end
    if grooveid == PartGrooveID.Rear3               then return 36 end
    if grooveid == PartGrooveID.FrontExtr2          then return 37 end
    if grooveid == PartGrooveID.RearExtr2           then return 38 end
    if grooveid == PartGrooveID.FrontExtr3          then return 39 end
    if grooveid == PartGrooveID.RearExtr3           then return 40 end

    if grooveid == PartGrooveID.TopRailRear         then return 41 end
    if grooveid == PartGrooveID.TopRailFront        then return 42 end

    if grooveid == PartGrooveID.Strong5             then return 43 end
    if grooveid == PartGrooveID.Strong6             then return 44 end
    if grooveid == PartGrooveID.Strong7             then return 45 end
    if grooveid == PartGrooveID.Strong8             then return 46 end

    if grooveid == PartGrooveID.RearWing            then return  47 end

    return -1
end
--}}}


--{{{数据构建模板，配置表转服务器配件列表
---@param cfg dictcardetail_config_cell
function AssembleHelper:AnalyseCfgToMsgParts(cfg)
    local result = {}
    result[ 4] = cfg.car[PartGrooveID.Shell]
    result[ 1] = cfg.car[PartGrooveID.Chassis]
    result[ 2] = cfg.car[PartGrooveID.Gears]
    result[ 3] = cfg.car[PartGrooveID.Motor]
    result[ 5] = -1 --cfg.car[PartGrooveID.GP]
    result[ 6] = cfg.car[PartGrooveID.FHub]
    result[ 7] = cfg.car[PartGrooveID.BHub]
    result[ 8] = cfg.car[PartGrooveID.FTyre]
    result[ 9] = cfg.car[PartGrooveID.BTyre]
    result[10] = cfg.car[PartGrooveID.Head]
    result[11] = cfg.car[PartGrooveID.Wing]
    result[12] = cfg.car[PartGrooveID.Tail]
    result[13] = cfg.car[PartGrooveID.Front]
    result[14] = cfg.car[PartGrooveID.Middle]
    result[15] = cfg.car[PartGrooveID.Rear]
    result[16] = cfg.car[PartGrooveID.PulleyRearCenter]
    result[17] = cfg.car[PartGrooveID.PulleyFrontButtom]
    result[18] = cfg.car[PartGrooveID.PulleyMiddleButtom1]
    result[19] = cfg.car[PartGrooveID.PulleyRearButtom]
    result[20] = cfg.car[PartGrooveID.PulleyFrontMinus]
    result[21] = cfg.car[PartGrooveID.PulleyMiddleMinus]
    result[22] =-1 --cfg.car[PartGrooveID.PulleyMiddleButtom2]
    result[23] = cfg.car[PartGrooveID.PulleyRearMinus]
    result[24] = cfg.car[PartGrooveID.PulleyShell]
    result[25] = cfg.car[PartGrooveID.FBrake]
    result[26] = cfg.car[PartGrooveID.BBrake]
    result[27] = cfg.car[PartGrooveID.Strong1]
    result[28] = cfg.car[PartGrooveID.Strong2]
    result[29] = cfg.car[PartGrooveID.Strong3]
    result[30] = cfg.car[PartGrooveID.Strong4]
    result[31] = cfg.car[PartGrooveID.PulleyFrontCenter]
    result[32] = cfg.car[PartGrooveID.PulleyMiddleCenter]
    result[33] = cfg.car[PartGrooveID.Front2]
    result[34] = cfg.car[PartGrooveID.Front3]
    result[35] = cfg.car[PartGrooveID.Rear2]
    result[36] = cfg.car[PartGrooveID.Rear3]
    result[37] = cfg.car[PartGrooveID.FrontExtr2]
    result[38] = cfg.car[PartGrooveID.RearExtr2]
    result[39] = cfg.car[PartGrooveID.FrontExtr3]
    result[40] = cfg.car[PartGrooveID.RearExtr3]
    result[41] = cfg.car[PartGrooveID.TopRailRear]
    result[42] = cfg.car[PartGrooveID.TopRailFront]
    result[43] = cfg.car[PartGrooveID.Strong5]
    result[44] = cfg.car[PartGrooveID.Strong6]
    result[45] = cfg.car[PartGrooveID.Strong7]
    result[46] = cfg.car[PartGrooveID.Strong8]
    result[47] = cfg.car[PartGrooveID.RearWing]
    --result[27] = cfg.car[PartGrooveID.Strong5]
    --result[28] = cfg.car[PartGrooveID.Strong6]
    --result[29] = cfg.car[PartGrooveID.Strong7]
    --result[30] = cfg.car[PartGrooveID.Strong8]
    return result
end
--}}}









--{{{更换配件导致关联配件失效，自动查找基础配件(废弃)
---@param node AssembleNode
function AssembleHelper:AutoSelectBasePart(node)
    -- 如果该槽位允许拆除装备，则不查找基础配件


    --if node:GetGrooveId() == PartGrooveID.Motor then
    --    AssembleHelper:AutoSelectBasePart_Motor(node)
    --elseif node:GetGrooveId() == PartGrooveID.Battery then
    --    AssembleHelper:AutoSelectBasePart_Battery(node)
    --elseif node:GetGrooveId() == PartGrooveID.Gears then
    --    AssembleHelper:AutoSelectBasePart_Gears(node)
    --elseif node:GetGrooveId() == PartGrooveID.FHub then
    --    AssembleHelper:AutoSelectBasePart_FHub(node)
    --elseif node:GetGrooveId() == PartGrooveID.BHub then
    --    AssembleHelper:AutoSelectBasePart_BHub(node)
    --elseif node:GetGrooveId() == PartGrooveID.FTyre then
    --    AssembleHelper:AutoSelectBasePart_FTyre(node)
    --elseif node:GetGrooveId() == PartGrooveID.BTyre then
    --    AssembleHelper:AutoSelectBasePart_BTyre(node)
    --end

end

-----@param node AssembleNode
--function AssembleHelper:AutoSelectBasePart_Motor(node)
--    local parentnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Chassis)
--    if parentnode == nil or parentnode:GetPartCfg() == nil then
--        print("---   error：数据异常，自动选择马达失败，底盘上没有装备")
--        return
--    end
--
--    CommonTipsHelper:Get():ShowCenterTips("马达不符合安装规则，自动替换为默认马达")
--    local node = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Motor)
--    --node:SetEquipmentData(parentnode:GetPartCfg().NewDefaultPart[1])
--end
-----@param node AssembleNode
--function AssembleHelper:AutoSelectBasePart_Battery(node)
--    local parentnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Chassis)
--    if parentnode == nil or parentnode:GetPartCfg() == nil then
--        print("---   error：数据异常，自动选择电池失败，底盘上没有装备")
--        return
--    end
--end
-----@param node AssembleNode
--function AssembleHelper:AutoSelectBasePart_Gears(node)
--    local parentnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Chassis)
--    if parentnode == nil or parentnode:GetPartCfg() == nil then
--        print("---   error：数据异常，自动选择齿轮组失败，底盘上没有装备")
--        return
--    end
--end
-----@param node AssembleNode
--function AssembleHelper:AutoSelectBasePart_FHub(node)
--    local parentnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Chassis)
--    if parentnode == nil or parentnode:GetPartCfg() == nil then
--        print("---   error：数据异常，自动选择前轮毂失败，底盘上没有装备")
--        return
--    end
--
--    CommonTipsHelper:Get():ShowCenterTips("前轮毂不符合安装规则，自动替换为默认前轮毂")
--    local node = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.FHub)
--    --node:SetEquipmentData(parentnode:GetPartCfg().NewDefaultPart[2])
--end
-----@param node AssembleNode
--function AssembleHelper:AutoSelectBasePart_BHub(node)
--    local parentnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.Chassis)
--    if parentnode == nil or parentnode:GetPartCfg() == nil then
--        print("---   error：数据异常，自动选择后轮毂失败，底盘上没有装备")
--        return
--    end
--
--    CommonTipsHelper:Get():ShowCenterTips("后轮毂不符合安装规则，自动替换为默认后轮毂")
--    local node = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.BHub)
--    --node:SetEquipmentData(parentnode:GetPartCfg().NewDefaultPart[3])
--end
-----@param node AssembleNode
--function AssembleHelper:AutoSelectBasePart_FTyre(node)
--    local parentnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.FHub)
--    if parentnode == nil or parentnode:GetPartCfg() == nil then
--        print("---   error：数据异常，自动选择前轮胎失败，前轮毂上没有装备")
--        return
--    end
--
--    CommonTipsHelper:Get():ShowCenterTips("前轮胎不符合安装规则，自动替换为默认轮胎")
--    local node = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.FTyre)
--    --node:SetEquipmentData(parentnode:GetPartCfg().NewDefaultPart[1])
--end
-----@param node AssembleNode
--function AssembleHelper:AutoSelectBasePart_BTyre(node)
--    local parentnode = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.BHub)
--    if parentnode == nil or parentnode:GetPartCfg() == nil then
--        print("---   error：数据异常，自动选择后轮胎失败，后轮毂上没有装备")
--        return
--    end
--
--    CommonTipsHelper:Get():ShowCenterTips("后轮胎不符合安装规则，自动替换为默认轮胎")
--    local node = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.BTyre)
--    --node:SetEquipmentData(parentnode:GetPartCfg().NewDefaultPart[1])
--end
--}}}

---@param grooveNode AssembleNode
---@return table<number, AssembleSiftData>
function AssembleHelper:GetPartsConfigByGroove(grooveNode)
    local hublimit = self:PartCalculate_HubLimit(grooveNode)
    local result = AssembleHelper:PartCalculate_FindPartsAtCfg(grooveNode, hublimit)
    return result
end

---@param port PartPort_Groove
---@param type PartType
---@param node AssembleGrooveData
---@return table<number, AssembleSiftData>
function AssembleHelper:PartCalculate_FindPartsAtCfg(node, hublimit)
    -- 查找背包中可用的配件，检查端口是否匹配，检查槽位id是否匹配，检查需要配件id
    local result = {}
    ---@type table<number, {}>
    local templist ={}
    ---@type grooveid_config_cell
    local groovecfg = CommonHelper:GetTableDataByID(ConfigNames.grooveid_config, node.GrooveId)
    if groovecfg == nil then return result end
    local tableData=ClientDataManager:Get():GetDataTable(ConfigNames.parts_config).GetConfigData()
    for k, v in pairs(tableData) do
        for loop = 1, #groovecfg.NewTypes do
            local type = groovecfg.NewTypes[loop][1]
            local type2 = groovecfg.NewTypes[loop][2]
            local type3 = groovecfg.NewTypes[loop][3]
            local PartBaseCfg=CommonHelper:GetPartBaseCfg(v.C_ID)
            if PartBaseCfg.parttype == type then
                if type2 == -1 or PartBaseCfg.subtype == type2 then
                    table.insert(result, {PartCfg=v,PartBaseCfg=PartBaseCfg} )
                end
            end
        end
    end

    for i = 1, #templist do
        local temp = AssembleHelper:Fitter(node, templist[i], hublimit)
        table.insert(result, temp)
    end
    return result
end
--}}}

---@param node AssembleNode
---@param carData CarReviewData
---@return dictfairmatchparts_config_cell[]
function AssembleHelper:GetFairmatchPartListByGrooveId(node,carData)
    local hublimit = self:PartCalculate_HubLimitByCarCarReviewData(node,carData)
    local result = AssembleHelper:PartCalculate_FindPartsAtDictFairMatchCfg(node, hublimit)
    return result

end
---@param node CarDetailData
function AssembleHelper:PartCalculate_HubLimitByCarCarReviewData(node) --
    if node:GetGrooveId() ~= PartGrooveID.FHub and node:GetGrooveId() ~= PartGrooveID.BHub then
        return nil
    end

    local fhub = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.FHub)
    local bhub = node.assembleMgr:GetNodeByGrooveID(PartGrooveID.BHub)
    if fhub:GetPartId() == -1 and bhub:GetPartId() == -1 then
        return -1
    end
    if fhub:GetPartBaseCfg() and bhub:GetPartBaseCfg() then
        if fhub:GetPartBaseCfg().PortData.HubRadius == bhub:GetPartBaseCfg().PortData.HubRadius then
            return -1
        end
    end


    if fhub:GetGrooveId() == node:GetGrooveId() then
        if fhub:GetPartId() ~= -1 then
            return -1
        else
            return bhub:GetPartBaseCfg().PortData.HubRadius
        end
    end
    if bhub:GetGrooveId() == node:GetGrooveId() then
        if bhub:GetPartId() ~= -1 then
            return -1
        else
            return fhub:GetPartBaseCfg().PortData.HubRadius
        end
    end

    print("---   error:PartCalculate_HubLimit, 检测算法异常")
    return -1
end
---@param node CarDetailData
function AssembleHelper:PartCalculate_FindPartsAtDictFairMatchCfg(node,hublimit) --
    -- 查找背包中可用的配件，检查端口是否匹配，检查槽位id是否匹配，检查需要配件id
    local result = {}
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictfairmatchparts_config)
    ---@type grooveid_config_cell
    local groovecfg = CommonHelper:GetTableDataByID(ConfigNames.grooveid_config, node.GrooveId)
    if groovecfg == nil then return result end
    ---@type table<number, {}>
    local templist ={}
    for k, v in pairs(cfg.GetConfigData()) do
        ---@type dictfairmatchparts_config_cell
        local value=v
        local partCfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,v.partid)
        for loop = 1, #groovecfg.NewTypes do
            local type = groovecfg.NewTypes[loop][1]
            local type2 = groovecfg.NewTypes[loop][2]
            local type3 = groovecfg.NewTypes[loop][3]
            local PartBaseCfg=CommonHelper:GetPartBaseCfg(partCfg.C_ID)
            if PartBaseCfg.parttype == type then
                if type2 == -1 or PartBaseCfg.subtype == type2 then
                    local temp={}
                    temp.PartCfg=partCfg
                    temp.PartBaseCfg=PartBaseCfg
                    temp.quality = PartBaseCfg.fabric
                    temp.star = value.partstar
                    temp.lv = value.partlev
                    temp.using = -1
                    temp.lock = -1
                    temp.awaken=value.partbreak==1
                    temp.Generation=value.partage
                    table.insert(templist, temp )
                end
            end
        end
    end
    return templist
end


--}}}

--{{{从某个背包中筛选适配某辆车的配件
---@param grooveNode AssembleNode
---@param carData CarData
---@param bag KnapsackData
---@return table<number, AssembleSiftData>
function AssembleHelper:GetPartsByGrooveAndCarData(grooveNode,carData,bag)
    local hublimit = self:PartCalculate_HubLimit(grooveNode)
    local result = AssembleHelper:PartCalculate_FindPartsByBagData(grooveNode, hublimit,bag)
    return result
end
---@param port PartPort_Groove
---@param type PartType
------@param bag KnapsackData
---@param node AssembleNode
---@return table<number, AssembleSiftData>
function AssembleHelper:PartCalculate_FindPartsByBagData(node, hublimit,bag)
    -- 查找背包中可用的配件，检查端口是否匹配，检查槽位id是否匹配，检查需要配件id
    local result = {}
    ---@type table<number, ArticleCell>
    local templist = bag:GetEquipmentsByGroove(node:GetGrooveId())
    for i = 1, #templist do
        local temp = AssembleHelper:Fitter(node, templist[i], hublimit)
        table.insert(result, temp)
    end
    return result
end
--}}}
--}}}