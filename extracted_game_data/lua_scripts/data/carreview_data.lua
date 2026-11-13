


---@class CarReviewData
CarReviewData = class("CarReviewData")

function CarReviewData:initialize()
    ---@type table<number, Lua_PartData>
    self.PartList = {}
    self.Lightweight = 0 -- 轻量化数据
    self.Grid = {} -- 纱网数据
    self.Colorid = 0 -- 车壳染色数据
    self.Stickerid = 0 -- 贴纸数据

    ---@type carshell_config_cell
    self.ShellCfg = nil
    self.ShellBean=0
end


function CarReviewData:SetDataByNPC(npcid)
    self.ID=npcid
    self.OwnerId=npcid
    self.PartList = RoomInitDataHelper:AnalyseNpcIdToPartInfo(npcid)
    local shellInfo= RoomInitDataHelper:AnalyseNpcIdToShellInfo(npcid)
    self.Lightweight = shellInfo:GetLightweight()
    self.Grid = shellInfo:GetGrids()
    self.Colorid = shellInfo:GetColorid()
    self.Stickerid = shellInfo:GetStickerid()
    self:AnalyseShellCfg()
    self.assembleMgr=AssembleManager()
    self.assembleMgr:SetDataByPartList(self.ID, self.PartList, false)
    self:SetAttr()
    self:SetSecondAttr()
    self:SetFiveAttr()
    self:UpdateFocus()
end
function CarReviewData:SetDataBySuit(suit)
    self.PartList = RoomInitDataHelper:AnalyseSuitIdToPartInfo(suit)
    local shellInfo= RoomInitDataHelper:AnalyseSuitIdToShellInfo(suit)
    self.Lightweight = shellInfo:GetLightweight()
    self.Grid = shellInfo:GetGrids() -- 纱网数据
    self.Colorid = shellInfo:GetColorid() -- 车壳染色数据
    self.Stickerid = shellInfo:GetStickerid() -- 贴纸数据
    self.assembleMgr=AssembleManager()
    self.assembleMgr:SetDataByPartList(self.ID, self.PartList, false)
    self:AnalyseShellCfg()
end
---@param data CarData
function CarReviewData:SetDataByCarData(data)
    self.OwnerId=PlayerDataManager:Get():GetPlayerRID()
    self.PartList = data:GetPartDataList()
    self.Lightweight = data:GetLightweight()
    self.Grid = data:GetShellGridList()
    self.BatterAttr=data:GetBatterAttr()
    self.Colorid = data:GetShellColor()
    self.Stickerid = data:GetShellSticker()
    self.ShellCfg = data:GetShellCfg()
    self.assembleMgr=AssembleManager()
    self.assembleMgr:SetDataByPartList(self.ID, self.PartList, false)
    self:SetShellCfg(data:GetShellPartCfg().C_ID)
end

---@param data Lua_CarInitData
function CarReviewData:SetDataByLuaCarInitData(data)
    self.PartList = data.PartDataList
    self.Lightweight = data.Lightweight
    self.Grid = data.Grids
    self.Colorid = data.Colorid
    self.Stickerid = data.Stickerid
    self.ShellCfg = data.CarshellCfg
    self.assembleMgr=AssembleManager()
    self.assembleMgr:SetDataByPartList(self.ID, self.PartList, false)
    self:AnalyseShellCfg()
end

---@param msg SC_UserCar
function CarReviewData:SetDataByMsg(msg,isChange)
    self.ID = msg.planseq
    self.OwnerId=msg.rid
    self.Name = msg.carplanname
    isChange = isChange==nil and true or isChange
    self.IsChange = isChange
    self:SetParts(msg.carDetails)
    self:UpdateAttrs(msg.carAttrs)
    self:AnalyseShellCfg()

end

function CarReviewData:SetDataByJson(attr,part,pid,isChange)
    local attrs=Dll_JSON.decode(attr)
    local parts=Dll_JSON.decode(part)
    self.ID = 111
    self.OwnerId=pid
    self.Name = "saa"
    isChange = isChange==nil and true or isChange
    self.IsChange = isChange
    self:SetPartsByJson(parts)
    self:UpdateAttrsByJson(attrs)
    self:AnalyseShellCfg()
end
function CarReviewData:BuildPartListFromNode(node)
    local partid,orgId = node:GetPartId(self.IsChange)
    local sticker = node:GetSticker(self.IsChange)
    local composeids = {}
    local generation=node:GetGeneration()
    local quality = 0

    local partBase=CommonHelper:GetPartBaseCfg(partid)
    if partBase then
        quality =partBase.fabric
    end

    local data = Lua_PartData()
    data:SetData(partid, composeids, quality,generation,1,orgId,sticker)
    return data
end

function CarReviewData:SetPartsByJson(parts)
    self.assembleMgr=AssembleManager()
    self.assembleMgr:SetData(self.ID, parts, self.OwnerId==PlayerDataManager:Get():GetPlayerRID())
    self.PartList = self:BuildPartListResult()
end

---@param msg SC_UserCarDetail[]
function CarReviewData:SetParts(parts)
    self.assembleMgr=AssembleManager()
    self.assembleMgr:SetData(self.ID, parts, self.OwnerId==PlayerDataManager:Get():GetPlayerRID())
    self.PartList = self:BuildPartListResult()
end

function CarReviewData:BuildPartListResult()
    local result = {}
    for k,v in pairs(PartGrooveID) do
        local node= self.assembleMgr:GetNodeByGrooveID(v)
        if node then
            local data = self:BuildPartListFromNode(node)
            local idx = AssembleHelper:GrooveIDToMsgIdx(v)
            result[idx] = data
            if v==PartGrooveID.Shell then
                self:SetShellCfg(node.PartId)
                self.Grid=node:GetGrid(not self.IsChange)
                self.Lightweight=node:GetLightWeight(not self.IsChange)
                self.Colorid = node:GetColor(not self.IsChange)
                self.Stickerid = node:GetSticker(not self.IsChange)
            end
        end
    end
    return result
end
function CarReviewData:UpdateAttrsByJson(attrs)
    self.BatterAttr={}
    table.sort(attrs,function(a, b)
        return a.attid<b.attid
    end)
    for i = 1, 105 do
        table.insert(self.BatterAttr,"0")
    end
    local tempAttr={}
    for m, n in pairs(attrs) do
        tempAttr[n.attid+1]=n.attval
    end
    for k, v in pairs(tempAttr) do
        self.BatterAttr[k]=tostring(v)
    end
end

---@param attrs SC_Attr[]
function CarReviewData:UpdateAttrs(attrs)
    table.sort(attrs,function(a, b)
        return a.attrId<b.attrId
    end)
    self.BatterAttr={}
    for i = 1, 105 do
        table.insert(self.BatterAttr,"0")
    end
    local tempAttr={}
    for m, n in pairs(attrs) do
        tempAttr[n.attrId+1]=n.attrVal
    end
    for k, v in pairs(tempAttr) do
        self.BatterAttr[k]=tostring(v)
    end
end



function CarReviewData:SetShellCfg(id)
    self.BuffIds,self.ShowBuffIds = self:CollectBuffIds(self.PartList)

    local cfg= CommonHelper:GetTableDataByID(ConfigNames.parts_config,id)
    if cfg then
        ---@type dictpartbase_config_cell
        local partBaseCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, cfg.baseid)
        self.carshellPartcfg=cfg
        self.ShellCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartcell_config, partBaseCfg.NewShellId)
        if self.ShellCfg then
            self.ShellBean=self.ShellCfg.bean
        end
    end
end


function CarReviewData:AnalyseShellCfg()
    if self.PartList == nil or #self.PartList == 0 then
        return
    end
    self.BuffIds,self.ShowBuffIds = self:CollectBuffIds(self.PartList)

    local idx = AssembleHelper:GrooveIDToMsgIdx(PartGrooveID.Shell)
    local partData = self.PartList[idx]
    if partData then
        ---@type dictparts_config_cell
        local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partData.PartOrgCfgID)
        ---@type dictpartbase_config_cell
        local partBaseCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, partCfg.baseid)
        if partBaseCfg then
            self.ShellCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartcell_config, partBaseCfg.NewShellId)
            if self.ShellCfg then
                self.ShellBean=self.ShellCfg.bean
            end
        end
    end
end

function CarReviewData:CollectBuffIds(partList)
    local buffIds = {}
    local showbuffIds = {}
    local idx = AssembleHelper:GrooveIDToMsgIdx(PartGrooveID.Shell)
    local partData = self.PartList[idx]
    if partData then
        ---@type dictparts_config_cell
        local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partData.PartOrgCfgID)
        local partBaseCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, partCfg.baseid)
        if partBaseCfg and partBaseCfg.NewSkillIds then
            for _, buffId in ipairs(partBaseCfg.NewSkillIds) do
                table.insert(buffIds, buffId)
            end
            if partBaseCfg.NewSkillIds[1] and partBaseCfg.NewSkillIds[1]>0 then
                local data = ShellBuffData()
                data:SetData(partBaseCfg.NewSkillIds[1])
                table.insert(showbuffIds, data)
            end

        end
    end

    for k, v in pairs(partList) do
        if k~=idx then
            if v then
                local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, v.PartOrgCfgID)
                if partCfg then
                    local partBaseCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, partCfg.baseid)
                    if partBaseCfg and partBaseCfg.NewSkillIds then
                        for _, buffId in ipairs(partBaseCfg.NewSkillIds) do
                            table.insert(buffIds, buffId)
                        end
                        if partBaseCfg.NewSkillIds[1] and partBaseCfg.NewSkillIds[1]>0 then
                            local data = ShellBuffData()
                            data:SetData(partBaseCfg.NewSkillIds[1])
                            table.insert(showbuffIds, data)
                        end

                    end
                end
            end
        end

    end
    return buffIds,showbuffIds
end

function CarReviewData:CollectBuffIdsFromNodes()
    local buffIds = {}
    local seen = {}
    for _, v in pairs(PartGrooveID) do
        local node = self.assembleMgr:GetNodeByGrooveID(v)
        if node then
            local partBaseCfg = node:GetPartBaseCfg()
            if partBaseCfg and partBaseCfg.NewSkillIds then
                for _, buffId in ipairs(partBaseCfg.NewSkillIds) do
                    if buffId > 0 and not seen[buffId] then
                        seen[buffId] = true
                        table.insert(buffIds, buffId)
                    end
                end
            end
        end
    end
    return buffIds
end




function CarReviewData:GetPartList() return self.PartList end
function CarReviewData:GetLightweight() return self.Lightweight end
function CarReviewData:GetColorId() return self.Colorid end
function CarReviewData:GetGrids() return self.Grid end
function CarReviewData:GetStickerid() return self.Stickerid end
function CarReviewData:GetShellCfg() return self.ShellCfg end
function CarReviewData:GetBatterAttr() return self.BatterAttr end
function CarReviewData:GetBuffIds() return self.BuffIds end
function CarReviewData:GetShowBuffIds() return self.ShowBuffIds end
function CarReviewData:GetShellBean() return self.ShellBean end

---@return table<number, Lua_PartData>
function CarReviewData:GetMainParts()
    local result = {}
    for i = 1, #self.PartList do
        local data = self.PartList[i]
        if data then
            if data.PartCfgID > 0 then
                ---@type parts_config_cell
                local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, data.PartCfgID)
                if cfg then
                    if cfg.type == PartType.Shell then result[1] = data end
                    if cfg.type == PartType.Chassis then result[2] = data end
                    if cfg.type == PartType.Motor then result[3] = data end
                    if cfg.type == PartType.Gears then result[4] = data end
                end
            end
        end
    end
    return result
end
---@return table<number, Lua_PartData>
function CarReviewData:GetJsonData()
    local result={}
    --result.parts={}
    result.attrs={}
    for i = 1, #self.BatterAttr do
        result.attrs[tostring(i)]=self.BatterAttr[i]
    end
    for i = 1, #self.PartList do
        local data = self.PartList[i]
        if data then
            if data.PartCfgID > 0 then
                ---@type dictparts_config_cell
                local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, data.PartCfgID)
                if cfg then
                    local partData={}
                    partData.part_inx=0
                    partData.part_entry={}
                    partData.part_star=0
                    partData.part_lev=0
                    partData.part_id=cfg.C_ID
                    partData.carplan=0
                    partData.part_grooveid=AssembleHelper:MsgIdxToGrooveID(i)
                    result["groove"..tostring(partData.part_grooveid)]=partData
                end
            end
        end
    end
    return result
end
function CarReviewData:SetAttr()
    local  attrs=RoomInitDataHelper:BuildMsg_Npc_GetNpcAttr(self.ID)
    self.Attr={}
    if attrs then
        for i = 2, #attrs do
            local temp=Part_Attr()
            temp.id=i-1
            temp.value=tonumber(attrs[i])/1000
            self.Attr[temp.id]=temp
        end
    end
end
function CarReviewData:SetSecondAttr()
    self.secondAttrs={}
    for i = 1, #self.Attr do
        self.secondAttrs[i]= PartAttrData()
        self.secondAttrs[i]:SetData(i, self.Attr[i].value)
    end
end

function CarReviewData:SetFiveAttr()
    ---@type table<number, PartAttrData>
    self.FiveAttrs = {}
    ---@type dictcalc_config_cell
    local calc=CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config,CommonCfgKey.CarFiveAttr)
    local fiveAttrId=stringSplitToNumber(calc.varval,':')
    for k,v in pairs(PartGrooveID) do
        local node=self.assembleMgr:GetNodeByGrooveID(v)
        if node then
            local partCfg = node:GetPartBaseCfg()
            local partAgeCfg=CommonHelper:GetPartAgeCfg(node:GetPartId(false),1)
            if partCfg then
                for k, v in pairs(fiveAttrId) do
                    local data = PartAttrData()
                    table.insert(self.FiveAttrs, data)
                    local startValue=0
                    if partCfg and partAgeCfg.NewAttr[v] then
                        startValue=partAgeCfg.NewAttr[v].value
                    end
                    if v==101 then
                        data:SetData(v, 1400)
                    elseif v==102 then
                        data:SetData(v, 1400)
                    else
                        data:SetData(v, math.abs(CommonHelper:AttrFormulaCalculate(v, startValue, self.Attr, partCfg)))
                    end

                end
            end
        end
    end
end

function CarReviewData:UpdateFocus()
    self.FocusX= self.Attr[CarFocusKey.X]
    self.FocusY=   self.Attr[CarFocusKey.Y]
    self.FocusZ=  self.Attr[CarFocusKey.Z]
end
function CarReviewData:GetFocusX()
    return self.FocusX
end
function CarReviewData:GetFocusY()
    return self.FocusY
end
function CarReviewData:GetFocusZ()
    return self.FocusZ
end
function CarReviewData:GetFiveAttrs()
    return self.FiveAttrs
end
function CarReviewData:GetSecondAttrs()
    return self.secondAttrs
end
function CarReviewData:GetScore()
    self.Score = 0
    for k,v in pairs(PartGrooveID) do
        local node=self.assembleMgr:GetNodeByGrooveID(v)
        if node then
            local cfg = node:GetPartCfg()
            if cfg then
                self.Score = self.Score + cfg.score
            end
        end
    end
    return math.abs(self.Score)
end

function CarReviewData:GetAttrFeatures()

    ---@type table<number, PartFeatureData[]>
    local tempResult = {}
    for k,v in pairs(PartGrooveID) do
        local node=self.assembleMgr:GetNodeByGrooveID(v)
        if node then
            local cfg = node:GetPartCfg()
            local basecfg=node:GetPartBaseCfg()
            if cfg and basecfg then
                local list = self:GetFeatureList(cfg,basecfg)
                for i = 1, #list do
                    local temp=list[i]
                       if temp then
                            local id = temp:GetID()
                            if tempResult[id] == nil then tempResult[id] = {} end
                            table.insert(tempResult[id] ,list[i])
                       end
                end
            end
        end
    end


    local result = {}
    for k,v in pairs(tempResult) do
        local data = {}
        local key = v[1]
        local value = v
        data[1] = key
        data[2] = value
        table.insert(result, data)
    end
    table.sort(result, function(a,b)
        ---@type PartFeatureData
        local A = a[1]
        ---@type PartFeatureData
        local B = b[1]
        if A:GetFeatureType() < B:GetFeatureType() then
            return true
        end
        if A:GetFeatureType() > B:GetFeatureType() then
            return false
        end
        return  A:GetID() < B:GetID()
    end)
    return result
end
function CarReviewData:SetDataByGrooveId(grooveid,partId)
    local idx= AssembleHelper:GrooveIDToMsgIdx(grooveid)
    local data = Lua_PartData()
    if partId>0 then
        data:SetData(partId, {}, CommonHelper:GetPartBaseCfg(partId).fabric,1,1,partId,0)
    else
        data:SetData(partId, {}, 1,1,1,partId,0)
    end

    self.PartList[idx] = data
    local shellInfo= RoomInitDataHelper:AnalyseNpcIdToShellInfo(self.ID)
    if grooveid==PartGrooveID.Shell then
        self.Lightweight = {true,true,true,true,true}  -- 轻量化数据
        self.Grid = {} -- 纱网数据
        self.Colorid = 0
        self.Stickerid = 0
    else
        self.Lightweight = shellInfo:GetLightweight()
        self.Grid = shellInfo:GetGrids() -- 纱网数据
        self.Colorid = shellInfo:GetColorid() -- 车壳染色数据
        self.Stickerid = shellInfo:GetStickerid() -- 贴纸数据
    end
    self:AnalyseShellCfg()
    self.assembleMgr=AssembleManager()
    self.assembleMgr:SetDataByPartList(self.ID, self.PartList)
    self:SetAttr()
    self:SetSecondAttr()
    self:SetFiveAttr()
    self:UpdateFocus()
end
function CarReviewData:GetFeatureList(cfg,partBaseConfig)
    --解析配件特性
    local FeatureList = {}
    for i = 1, #partBaseConfig.NewAttrFeature do
        local temp = partBaseConfig.NewAttrFeature[i]
        if temp~=-1 then
            ---@type attrfeature_config_cell
            local feature = CommonHelper:GetTableDataByID(ConfigNames.attrfeature_config, temp)
            local value=0
            if self.Attr[feature.attr] then
                value=self.Attr[feature.attr].value
            end
            local data = PartFeatureData()
            data:SetDataByCfg(cfg,partBaseConfig , feature, value)
            table.insert(FeatureList, data)
        end
    end
    table.sort(FeatureList, function(a,b) return a:GetFeatureType() < b:GetFeatureType() end)

    return FeatureList
end

