---@class VerifyCarHistoryData
---@field CarId
---@field id
---@field Name
---@field Time
---@field verifyAttr VerifyCarAttrData[]

---@class VerifyCarAttrData
---@field Name
---@field Desc
---@field Attr
---@field value
---@field id




---@class CarData
CarData = class("CarData")

function CarData:initialize()
    self.ID = -1
    self.CarIdx = -1
    self.Score = -1
    self.Name = ""
    ---@type table<number, PartAttrData>
    self.attrs = {}
    self.BatterAttr={}
    self.assembleMgr = AssembleManager()
    ---@type carshell_config_cell
    self.carshellcfg = nil
    self.carshellPartcfg = nil

    ---@type table<number, PartAttrData>
    self.fiveAttrs = {}
    ---@type table<number, PartAttrData>
    self.secondAttrs = {}
    ---@type table<number, PartAttrData>
    self.referenceAttrs = {}
    ---@type table<number, PartAttrData>
    self.attrFeatures = {}
    ---@type VerifyCarHistoryData[]
    self.VerifyAttrHistoryList={}
    self.FocusX= 0
    self.FocusY=   0
    self.FocusZ= 0
    self.RedFlag=false
end
---@param msg SC_UserCar
---@param msg KnapsackData
function CarData:SetData(msg,knapsackData)
    self.ID = msg.planseq
    if knapsackData==nil then
        self.KnapsackDataManager=KnapsackDataManager:Get().PartKnapsack
    else
        self.KnapsackDataManager=knapsackData
    end

    self.Name = msg.carplanname
    self.LockState=msg.unlockflag
    self.isUse=msg.ifuse==1
    self.fiveAttrs = {}
    self.FocusX= 0
    self.FocusY=   0
    self.FocusZ= 0
    if  self.LockState ==ParkingLotState.UnOpen then return end
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.CarFiveAttr)
    self.FiveAttrTypes = stringSplitToNumber(cfg.varval, ':')
    for i = 1, #self.FiveAttrTypes  do
        local temp = PartAttrData()
        temp:SetData(self.FiveAttrTypes [i], 0)
        self.fiveAttrs[self.FiveAttrTypes [i]] = temp
    end

    self.secondAttrs = {}
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.CarSecondAttr)
    local list = stringSplitToNumber(cfg.varval, ',')
    for i = 1, #list do
        local temp = PartAttrData()
        temp:SetData(list[i], 0)
        self.secondAttrs[list[i]] = temp
    end


    self.referenceAttrs = {}
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.CarReferenceAttr)
    list = stringSplitToNumber(cfg.varval, ':')
    for i = 1, #list do
        local temp = PartAttrData()
        temp:SetData(list[i], 0)
        self.referenceAttrs[list[i]] = temp
    end
    if self.LockState==ParkingLotState.Open then
        self:SetHistoryVerifyCar(msg.verifyAttr)
        self:SetParts(msg.carDetails)
        self:SetShellCfg()
        self:UpdateAttrs(msg.carAttrs)
    end

end
---@param msg SC_UserCar
function CarData:UpdateData(msg)
    self.ID = msg.planseq
    self.Name = msg.carplanname
    self.LockState=msg.unlockflag
    self.isUse=msg.ifuse==1
    self.fiveAttrs = {}
    self.attrs = {}
    self.assembleMgr = AssembleManager()
    self.carshellcfg = nil
    self.fiveAttrs = {}
    self.secondAttrs = {}
    self.referenceAttrs = {}
    self.attrFeatures = {}
    self.FocusX= 0
    self.FocusY=   0
    self.FocusZ= 0
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.CarFiveAttr)
    local list = stringSplitToNumber(cfg.varval, ':')
    for i = 1, #list do
        local temp = PartAttrData()
        temp:SetData(list[i], 0)
        self.fiveAttrs[list[i]] = temp
    end

    self.secondAttrs = {}
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.CarSecondAttr)
    local list = stringSplitToNumber(cfg.varval, ',')
    for i = 1, #list do
        local temp = PartAttrData()
        temp:SetData(list[i], 0)
        self.secondAttrs[list[i]] = temp
    end


    self.referenceAttrs = {}
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.CarReferenceAttr)
    list = stringSplitToNumber(cfg.varval, ':')
    for i = 1, #list do
        local temp = PartAttrData()
        temp:SetData(list[i], 0)
        self.referenceAttrs[list[i]] = temp
    end
    if self.LockState==ParkingLotState.Open then
        self:SetHistoryVerifyCar(msg.verifyAttr)
        self:SetParts(msg.carDetails)
        self:SetShellCfg()
        self:UpdateAttrs(msg.carAttrs)
    end
end
---@param msg SC_UserCarDetail[]
function CarData:SetParts(parts)
    self.assembleMgr:SetData( self.ID,parts,true,self.KnapsackDataManager)
end
function CarData:UpdateParts()
    self.assembleMgr:UpdatePartList()
end


---@param attrs SC_Attr[]
function CarData:UpdateAttrs(attrs)
    table.sort(attrs,function(a, b)
        return a.attrId<b.attrId
    end)
    self.BatterAttr={}
    for i = 1, 105 do
        table.insert(self.BatterAttr,"0")
    end
    for i = 1, #attrs do
        local key = attrs[i].attrId
        local value = attrs[i].attrVal
        self.BatterAttr[attrs[i].attrId+1]=tostring(value)
        if self.attrs[key] == nil then
            local temp = PartAttrData()
            temp:SetData(key, value)
            self.attrs[key] = temp
        else
            self.attrs[key]:SetData(key, value)
        end
    end

    self:UpdateFiveAttrs()
    self:UpdateSecondAttrs()
   -- self:UpdateReferenceAttrs()
    self:SetScore()
    self:UpdateFocus()

end

function CarData:SetShellCfg()
    self.BuffIds = {}
    self.ShowBuffIds = {}
    local node = self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell)
    if node then
        local cfg= node:GetPartCfg()
        if cfg then
            ---@type dictpartbase_config_cell
            local partBaseCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, cfg.baseid)
            if partBaseCfg and partBaseCfg.NewSkillIds then
                for _, buffId in ipairs(partBaseCfg.NewSkillIds) do
                    if buffId > 0 then
                        table.insert(self.BuffIds, buffId)
                    end
                end
                if partBaseCfg.NewSkillIds[1] and partBaseCfg.NewSkillIds[1]>0 then
                    local data = ShellBuffData()
                    data:SetData(partBaseCfg.NewSkillIds[1])
                    table.insert(self.ShowBuffIds, data)
                end
            end
            self.carshellPartcfg=cfg
            ---@type dictpartcell_config_cell
            self.carshellcfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartcell_config, partBaseCfg.NewShellId)
            self.ShellBean=self.carshellcfg.bean
        end
    end
    for k,v in pairs(PartGrooveID) do
        if v~=PartGrooveID.Shell then
            local node = self.assembleMgr:GetNodeByGrooveID(v)
            if node then
                local cfg= node:GetPartCfg()
                if cfg then
                    local partBaseCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, cfg.baseid)
                    if partBaseCfg and partBaseCfg.NewSkillIds then
                        for _, buffId in ipairs(partBaseCfg.NewSkillIds) do
                            if buffId > 0 then
                                table.insert(self.BuffIds, buffId)
                            end
                        end
                        if partBaseCfg.NewSkillIds[1] and partBaseCfg.NewSkillIds[1]>0 then
                            local data = ShellBuffData()
                            data:SetData(partBaseCfg.NewSkillIds[1])
                            table.insert(self.ShowBuffIds, data)
                        end
                    end
                end
            end
        end
    end


end

function CarData:SetHistoryVerifyCar(verifyAttr)
    ---@type VerifyCarAttrData[]
    self.CurVerifyAttr={}
    self.CurHistoryCount=0
    for i = 1, #verifyAttr do
        self.CurVerifyAttr[i]={}
        ---@type carinspectattr_config_cell
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.carinspectattr_config,i)
        self.CurVerifyAttr[i].id=i
        self.CurVerifyAttr[i].Name=CommonHelper:GetTempStr_Default(cfg.attrname)
        self.CurVerifyAttr[i].Desc=CommonHelper:GetTempStr_Default(cfg.attrdesc)
        self.CurVerifyAttr[i].Attr=CommonHelper:GetTempStr_Default(cfg.attr)
        self.CurVerifyAttr[i].value=string.format("%.2f",verifyAttr[i]/1000)
    end
    local value=PlayerPrefsHelper:GetValue_CarVerifyHistory(self.ID)
    if not CommonHelper:IsNullOrEmpty(value) then
        self.VerifyAttrHistoryList=Dll_JSON.decode(value)
    end
    for i = 1, CommonHelper:GetDictCalcData(CommonCfgKey.VerifyCarMaxCount, false) do
        if self.VerifyAttrHistoryList[i]==nil then
            self.VerifyAttrHistoryList[i]={}
            self.VerifyAttrHistoryList[i].CarId=0
            self.VerifyAttrHistoryList[i].id=0
            self.VerifyAttrHistoryList[i].Name=""
            self.VerifyAttrHistoryList[i].verifyAttr={}
            self.VerifyAttrHistoryList[i].Time=""
        end
        if self.VerifyAttrHistoryList[i].id~=0 then
            self.CurHistoryCount=self.CurHistoryCount+1
        end
    end
end
function CarData:SaveHistoryVerifyCar(idx,name)
    self.CurHistoryCount=0
    self.VerifyAttrHistoryList[idx]={}
    self.VerifyAttrHistoryList[idx].CarId=self.ID
    self.VerifyAttrHistoryList[idx].Name=name
    self.VerifyAttrHistoryList[idx].verifyAttr=self.CurVerifyAttr
    self.VerifyAttrHistoryList[idx].Time=CommonHelper:FormatDataString(CommonHelper:GetNowTime(),"yyyy-MM-dd")
    self.VerifyAttrHistoryList[idx].Show=1
    local data= Dll_JSON.encode(self.VerifyAttrHistoryList)
    PlayerPrefsHelper:SetValue_CarVerifyHistory(self.CarIdx,data)
    for i = 1, CommonHelper:GetDictCalcData(CommonCfgKey.VerifyCarMaxCount, false) do
        if self.VerifyAttrHistoryList[i]~=0 and i~=idx then
            self.VerifyAttrHistoryList[i].Show=0
        end
        if self.VerifyAttrHistoryList[i].id~=0 then
            self.CurHistoryCount=self.CurHistoryCount+1
        end
    end
end
function CarData:GetVerifyAttrHistoryDataByIdx(idx)
    return  self.VerifyAttrHistoryList[idx]
end
function CarData:GetVerifyAttrHistoryDataRecommend()
    for k, v in pairs(self.VerifyAttrHistoryList) do
        if v.Show==1 then
            return v
        end
    end
    return self:GetVerifyAttrHistoryDataByIdx(1)
end
function CarData:GetVerifyAttrHistoryDataList()
    return self.VerifyAttrHistoryList
end
function CarData:GetCurHistoryCount()
    return self.CurHistoryCount
end





































---@param msg SC_GetCarPlanDetailRes
function CarData:InitSuitData(msg)
    self:SetParts(msg.parts, msg.openPos)
    self:SetShellCfg()
end



function CarData:GetID() return self.ID end
function CarData:GetCarIdx() return self.CarIdx end
function CarData:SetCarIdx(value)  self.CarIdx = value end

---@return dictpartcell_config_cell
function CarData:GetShellCfg(isorg)
    local partId = self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetPartId(isorg)
    if CommonHelper:GetPartBaseCfg(partId) then
        local carshellcfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartcell_config, CommonHelper:GetPartBaseCfg(partId).NewShellId)
        return carshellcfg
    else
        return self.carshellcfg
    end

end
function CarData:GetShellPartCfg() return self.carshellPartcfg end
function CarData:GetAttrList() return self.attrs end
function CarData:GetScore() return self.Score end
function CarData:GetBatterAttr() return self.BatterAttr end
function CarData:GetBuffIds() return self.BuffIds end
function CarData:GetShowBuffIds() return self.ShowBuffIds end
function CarData:GetShellBean() return self.ShellBean end
function CarData:GetCurVerifyAttr() return self.CurVerifyAttr end
function CarData:GetName()
    local partId = self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetPartId(true)
    self.Name = CommonHelper:GetPartOrArticleName(partId)
    return self.Name
end


--function CarData:SetParts(msg, groovemsg)
--    self.assembleMgr:InitData( self.ID,msg, groovemsg)
--end

---@return table<number, PartAttrData>
function CarData:GetFiveAttrs()
    local result = {}
    for i = 1, #self.FiveAttrTypes  do
        local key = self.FiveAttrTypes [i]
        table.insert(result, self.fiveAttrs[key])
    end
    return result
end

---@return table<number, PartAttrData>
function CarData:GetSecondAttrs()
    local result = {}
    local temp = {}
    for k,v in pairs(self.secondAttrs)  do
        table.insert(temp, k)
    end
    table.sort(temp)
    for i = 1, #temp do
        local key = temp[i]
        if self.secondAttrs[key].value>0 then
            table.insert(result, self.secondAttrs[key])
        end
    end
    return result
end

---@return table<number, PartAttrData>
function CarData:GetReferenceAttrs()
    local result = {}
    local temp = {}
    for k,v in pairs(self.referenceAttrs)  do
        table.insert(temp, k)
    end
    table.sort(temp)
    for i = 1, #temp do
        local key = temp[i]
        table.insert(result, self.referenceAttrs[key])
    end
    return result
end


function CarData:GetShellArticle()
    local bagid = self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetBagId()
    return self.KnapsackDataManager:GetArticleByCellID(bagid)
end

function CarData:SetCopyShellId(sellid)
    self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):UpdateCopyShellId(sellid)
end

function CarData:SetCopyShellSticker(stickerid)
    self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):UpdateCopySticker(stickerid)
end
function CarData:SetShellSticker(stickerid)
    self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):UpdateSticker(stickerid)
end

function CarData:GetShellSticker(org)
    return self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetSticker(org)
end


function CarData:SetShellColor(colorid)
    self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):UpdateColor(colorid)
end
function CarData:SetCopyShellColor(colorid)
    self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):UpdateCopyColor(colorid)
end

function CarData:GetShellColor(org)
    return self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetColor(org)
end



function CarData:SetLightweight(lightweight)
    self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):UpdateLightweight(lightweight)
end

function CarData:SetCopyLightweight(grid,hole)
    self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):UpdateCopyLightweight(grid,hole)
end

function CarData:GetLightweight(org)
    return self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetLightWeight(org)
end





function CarData:SetShellGrid(lightweight)
    self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):UpdateLightweight(lightweight)
end
function CarData:GetShellGridList(org)
    return self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetGrid(org)
end




---@return table<number, Lua_PartData>
function CarData:GetPartDataList()
    local result = {}
    for k,v in pairs(PartGrooveID) do
        local node=  self.assembleMgr:GetNodeByGrooveID(v)
        if node then
            local partid,orgId = node:GetPartId(true)
            local sticker = node:GetSticker(true)
            local composeids = {}
            local quality = 0
            local generation=1
            local articledata = self.KnapsackDataManager:GetArticleByCellID(self.assembleMgr:GetNodeByGrooveID(v):GetBagId())
            if articledata then
                --  composeids = articledata:GetPartComposeIds()
                quality = articledata:GetPartQuality()
                generation=articledata:GetGeneration()
            end
            local data = Lua_PartData()
            data:SetData(partid, composeids, quality,generation,1,orgId,sticker)
            local idx = AssembleHelper:GrooveIDToMsgIdx(v)
            result[idx] = data
        end
    end
    return result
end

---@return ArticleCell
function CarData:GetPartByGrooveID(grooveid)
    local result = self.KnapsackDataManager:GetArticleByCellID(self.assembleMgr:GetNodeByGrooveID(grooveid):GetBagId())
    return result
end
---@return CarDetailData
function CarData:GetPartByBagID(bagId)
    return self.assembleMgr:GetPartByBagID(bagId)
end


function CarData:UpdateFiveAttrs()
    for k,v in pairs(self.fiveAttrs) do
        if self.attrs[k] then
            v:SetData(k, self.attrs[k].value/1000)
        else
            print("Car_Idx",self.ID,k)
        end

    end
end
function CarData:UpdateFocus()
    self.FocusX= self.attrs[CarFocusKey.X]
    self.FocusY=   self.attrs[CarFocusKey.Y]
    self.FocusZ=  self.attrs[CarFocusKey.Z]
end
function CarData:GetAttrValueById(id)
    return self.attrs[id]
end

function CarData:GetFocusX()
    return self.FocusX
end
function CarData:GetFocusY()
    return self.FocusY
end
function CarData:GetFocusZ()
    return self.FocusZ
end
function CarData:UpdateSecondAttrs()
    for k,v in pairs(self.secondAttrs) do
        if self.attrs[k] then
            v:SetData(k, self.attrs[k].value/1000)
        else
            print("Car_Idx",self.ID,k)
        end
    end
end

function CarData:UpdateReferenceAttrs()
    for k,v in pairs(self.referenceAttrs) do
        v:SetData(k, 0)
    end

    for k,v in pairs(PartGrooveID) do
        local bagid = self.assembleMgr:GetNodeByGrooveID(v):GetBagId()
        if bagid > -1 then
            local article = self.KnapsackDataManager:GetArticleByCellID(bagid)
            if article then
                local attrs = article:GetPartReferenceAttrs()
                for i = 1, #attrs do
                    local temp = attrs[i]
                    local type = temp.type
                    local data = self.referenceAttrs[type]
                    if data then
                        local value = data.value + temp.value
                        self.referenceAttrs[type]:SetData(type, value)
                    end
                end
            end
        end
    end
end

function CarData:SetScore()
    self.Score = 0
    for k,v in pairs(PartGrooveID) do
        local node=self.assembleMgr:GetNodeByGrooveID(v)
        if node then
            local bagid = node:GetBagId()
            if bagid > -1 then
                local article = self.KnapsackDataManager:GetArticleByCellID(bagid)
                if article then
                    local score = article:GetPartScore()
                    self.Score = self.Score + score
                end
            end
        end
    end
end

function CarData:CheckArticleAdaptationChassis()
     return self.assembleMgr:CheckArticleAdaptationChassis()
end

function CarData:CheckArticleIsExp()
    local result={}
    for k,v in pairs(PartGrooveID) do
        if self.assembleMgr:GetNodeByGrooveID(v) then
            local bagid = self.assembleMgr:GetNodeByGrooveID(v):GetBagId()
            if bagid > -1 then
                local article = self.KnapsackDataManager:GetArticleByCellID(bagid)
                if article and article:IsExp() then
                    table.insert(result,v)
                end
            end
        end
    end
    return result
end
function CarData:SetRedPointState(value)
    self.RedFlag=value
end
function CarData:GetRedPointState()
   return self.RedFlag
end

function CarData:GetAttrFeatures()

    ---@type table<number, PartFeatureData[]>
    local tempResult = {}
    for k,v in pairs(PartGrooveID) do
        local node=self.assembleMgr:GetNodeByGrooveID(v)
        if node then
            local bagid = node:GetBagId()
            if bagid > 0 then
                local article = self.KnapsackDataManager:GetArticleByCellID(bagid)
                if article then
                    local list = article:GetPartFeatureList()
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

function CarData:GetJsonData()
    local data={}
    data.attrs={}
    for i = 1, #self.BatterAttr do
       data.attrs[tostring(i)]=self.BatterAttr[i]
    end
    for k,v in pairs(PartGrooveID) do
        local node=self.assembleMgr:GetNodeByGrooveID(v)
        if node then
            local bagid = node:GetBagId()
            if bagid > -1 then
                local article = self.KnapsackDataManager:GetArticleByCellID(bagid)
                if article then
                    local partData={}
                    partData.part_inx=article:GetCellID()
                    partData.part_entry={}
                    for i = 1, #article:GetPartReformList() do
                        partData.part_entry[tostring(article:GetPartReformList()[i].id)]={entry_lev=article:GetPartReformList()[i].lv,
                                                                                          entry_quality=article:GetPartReformList()[i].quality,
                                                                                          entry_id=article:GetPartReformList()[i].id}
                    end
                    partData.part_star=article:GetStar()
                    partData.part_lev=article:GetPartLV()
                    partData.part_id=article:GetID()
                    partData.carplan=article:GetCarId()
                    --partData.part_grooveid=v
                    data["groove"..tostring(v)]=partData
                end
            end
        end
    end
    return data
end

function CarData:CheckCarCompleteness(isshowtips)
    if isshowtips == nil then isshowtips = true end
    local result = true
    local temp = {}
    ---@type grooveid_config_cell[]
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.grooveid_config).Get_BaseGrooveCfg()
    for k, v in pairs(cfg) do
        local tempResult=true
        if self.assembleMgr:GetNodeByGrooveID(v.C_ID):GetBagId() == 0 then
            tempResult = false
        end
        if tempResult==false and v.ReplacePartType then
            for m, n in pairs(v.ReplacePartType) do
                if self.assembleMgr:GetNodeByGrooveID(n.GrooveId):GetBagId() ~= 0 then
                    local id= self.assembleMgr:GetNodeByGrooveID(PartGrooveID.Front):GetBagId()
                    local cell= self.KnapsackDataManager:GetArticleByCellID(id)
                    if cell:GetPartType()==n.PartType and cell:GetPartSubType()==n.PartSubType then
                        tempResult=true
                        break
                    end
                end
            end
        end
        if result then
            result=tempResult
        end
        if tempResult==false then
            table.insert(temp, ClientDataManager:Get():GetTemplateString(v.name))
        end
    end
    if isshowtips then
        if result == false then
            local str = string.format("%s%s",CommonHelper:GetTempStr_Default(string.format("caridx_%d",self.ID)),CommonHelper:GetTempStr_Default(TemplateStringID.NoHasParts))
            for i = 1, #temp do
                if i==#temp then
                    str = string.format("%s%s。",str,temp[i])
                else
                    str = string.format("%s%s,",str,temp[i])
                end
            end
            CommonTipsHelper:ShowCenterTips(str)
        end
    end
    temp= self:CheckArticleAdaptationChassis()
    if isshowtips then
        if #temp>0 then
            result=false
            local goodsType=ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
            local str =""
            for i = 1, #temp do
                local node= self.assembleMgr:GetNodeByGrooveID(temp[i])
                local cell=self.KnapsackDataManager:GetArticleByCellID(node:GetBagId())
                if i==#temp then
                    str = string.format("%s%s",str,CommonHelper:GetTempStr_Default(goodsType.GetDataType2(GoodsType1.Part,cell:GetPartType())))
                else
                    str = string.format("%s%s,",str,CommonHelper:GetTempStr_Default(goodsType.GetDataType2(GoodsType1.Part,cell:GetPartType())))
                end
            end
            str = string.format("%s%s%s",CommonHelper:GetTempStr_Default(string.format("caridx_%d",self.ID)),str,CommonHelper:GetTempStr_Default(TemplateStringID.PartNotAdaptationChassis))
            CommonTipsHelper:ShowCenterTips(str)
        end
    end
    temp= self:CheckArticleIsExp()
    if isshowtips then
        if #temp>0 then
            result=false
            local goodsType=ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
            local str =""
            for i = 1, #temp do
                local node= self.assembleMgr:GetNodeByGrooveID(temp[i])
                local cell=self.KnapsackDataManager:GetArticleByCellID(node:GetBagId())
                if i==#temp then
                    str = string.format("%s%s",str,CommonHelper:GetTempStr_Default(goodsType.GetDataType2(GoodsType1.Part,cell:GetPartType())))
                else
                    str = string.format("%s%s,",str,CommonHelper:GetTempStr_Default(goodsType.GetDataType2(GoodsType1.Part,cell:GetPartType())))
                end
            end
            str = string.format("%s%s%s",CommonHelper:GetTempStr_Default(string.format("caridx_%d",self.ID)),str,CommonHelper:GetTempStr_Default(TemplateStringID.PartIsExp))
            CommonTipsHelper:ShowCenterTips(str)
        end
    end
    return result
end