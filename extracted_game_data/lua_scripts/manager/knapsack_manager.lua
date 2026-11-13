
---@class KnapsackDataManager
KnapsackDataManager = class("KnapsackDataManager")

function KnapsackDataManager:initialize()
    self.ArticleKnapsack = KnapsackData(BagType.Article)
    self.PartKnapsack = KnapsackData(BagType.Part)
    self.AllKnapsack = nil
    self.New=false
    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end

---@return KnapsackDataManager
function KnapsackDataManager:Get()
    if self._instance == nil then
        self._instance = KnapsackDataManager()
    end
    return self._instance
end
---@param msg SC_UserProp[]
function KnapsackDataManager:SetPropsKnapsack(msg)
    self.ArticleKnapsack = KnapsackData(BagType.Article)
    self.ArticleKnapsack:SetPropData(msg)
    RedPointManager:Get():UpdateValue(RedPointID.Garage)
    self:SetRedPointData()
end
---@param msg SC_UserPart[]
function KnapsackDataManager:SetPartsData(msg)
    self.PartKnapsack = KnapsackData(BagType.Part)
    self.PartKnapsack:SetPartData(msg,false)
    RedPointManager:Get():UpdateValue(RedPointID.Garage)
    self:SetRedPointData()
end
---@return table<number, ArticleCell>
function KnapsackDataManager:GetArticleListByType(type)
    local result = {}
    for i = 1, #self.ArticleKnapsack.ArticleCells do
        local temp = self.ArticleKnapsack.ArticleCells[i]
        if temp:GetArticleConfig() then
            if temp:GetArticleConfig().propstype == type then
                table.insert(result, temp)
            end
        else
            print("article--->>>>",temp:GetID())
        end

    end

    return result
end
---@return table<number, ArticleCell>
function KnapsackDataManager:GetArticleListByTypes(types)
    local result = {}
    for k, v in pairs(types) do
        for i = 1, #self.ArticleKnapsack.ArticleCells do
            local temp = self.ArticleKnapsack.ArticleCells[i]
            if temp:GetArticleConfig() then
                if temp:GetArticleConfig().propstype == v then
                    table.insert(result, temp)
                end
            else

            end

        end
    end
    return result
end

function KnapsackDataManager:GetAllArticleSubCost()
    local result={}
    for i = 1, #self.ArticleKnapsack.ArticleCells do
        local temp=self.ArticleKnapsack.ArticleCells[i]
        if temp:GetArticleConfig() then
            if CommonHelper:GetBagTypeByProp(temp:GetArticleConfig().propstype) and  temp:GetCount()>0 then
                table.insert(result, temp)
            end
        else
            print("article--->>>>",temp:GetID())
        end
    end
    return result
end
function KnapsackDataManager:GetAllArticleSticker(_SelectType)
    local result={}
    for i = 1, #self.ArticleKnapsack.ArticleCells do
        local temp=self.ArticleKnapsack.ArticleCells[i]
        if temp:GetArticleConfig() then
            if CommonHelper:GetBagTypeBySticker(temp:GetArticleConfig().propstype) and temp:GetArticleConfig().subtype==_SelectType and  temp:GetCount()>0 then
                table.insert(result, temp)
            end
        else
            print("article--->>>>",temp:GetID())
        end
    end
    return result
end

function KnapsackDataManager:GetAllArticleSubConsumables()
    local result={}
    for i = 1, #self.ArticleKnapsack.ArticleCells do
        local temp=self.ArticleKnapsack.ArticleCells[i]
        if temp:GetArticleConfig() then
            if CommonHelper:GetBagTypeByConsumables(temp:GetArticleConfig().propstype) and  temp:GetCount()>0 then
                table.insert(result, temp)
            end
        else
            print("article--->>>>",temp:GetID())
        end
    end
    return result
end
---@return ArticleCell[]
function KnapsackDataManager:GetEquipmentList()
    return self.PartKnapsack.ArticleCells
end
---@return table<number, ArticleCell>
function KnapsackDataManager:GetEquipmentsByType(type)
    local result = {}
    for i = 1, #self.PartKnapsack.ArticleCells do
        local temp = self.PartKnapsack.ArticleCells[i]
        if temp:GetPartType() == type then
            table.insert(result, temp)
        end
    end

    return result
end

function KnapsackDataManager:GetEquipmentsByGroove(grooveid)
    return self.PartKnapsack:GetEquipmentsByGroove(grooveid)
end
---@return ArticleCell
function KnapsackDataManager:GetArticleByCellID(cellid)
    return self.PartKnapsack:GetArticleByCellID(cellid)
end

---@return ArticleCell
function KnapsackDataManager:GetArticleByID(id)
    return self.PartKnapsack:GetArticleByCellID(id)
end
---@param para SC_Consume
function KnapsackDataManager:UpdatePropByConsume(para)
    if para then
        if para.propsid>SegmentMaxId then
            self:TrackConsumeEvent(para)
            ---@type ArticleCell
            local data= self.ArticleKnapsack:GetArticleByID(para.propsid)
            data:SetCount(para.propsnum)
            CommonHelper:PlaySfxByCostArticle(para.propsid)
            self.ArticleKnapsack:UpdateArticleDict()
            UINotify:Get():SendNotification(UINotifyEvent.Msg_PlayerCurrency)
            UINotify:Get():SendNotification(UINotifyEvent.BagViewRefresh)
        else
            SegmentDataManager:Get():UpdateTrackSegmentNum(para)
        end
    end
end



---@param para SC_ConsumGroup
function KnapsackDataManager:UpdatePropByConsumeGroup(para)
    for i = 1, #para do
        self:UpdatePropByConsume(para[i])
    end
end

function KnapsackDataManager:GetArticleCountByCfgid(id)
    if id and id<SegmentMaxId then
      return  SegmentDataManager:Get():GetNumById(id)
    else
        return self.ArticleKnapsack:GetArticleCountByCfgid(id)
    end

end
function KnapsackDataManager:GetArticleByCfgid(id)
   return self.ArticleKnapsack:GetArticleByID(id)
end


---@param msg SC_SomeDown
function KnapsackDataManager:AddPropAndPartBySomeDown(msg)
    if msg then
        if msg.downProps and #msg.downProps>0 then
            self:TrackGetPropEvent(msg.downProps)
            self.ArticleKnapsack:AddProp(msg.downProps)
        end

        if msg.downProps and #msg.downProps>0 then
            for i = 1, #msg.downProps do
                SegmentDataManager:Get():UpdateTrackSegmentNum(msg.downProps[i])
            end
        end
        if msg.downFurniture and #msg.downFurniture>0 then
            for i = 1, #msg.downFurniture do
                PersonalHomeDataManager:Get():UpdatePersonalHomeData(msg.downFurniture)
            end
        end
        if msg.downHeadFrame then
            PlayerDataManager:Get():AddHeadList(msg.downHeadFrame)
        end
        if msg.downParts and #msg.downParts>0 then
            self:TrackGetPartEvent(msg.downParts)
            self.PartKnapsack:AddPart(msg.downParts,true)
        end
        self:SetRedPointData()
        UINotify:Get():SendNotification(UINotifyEvent.Msg_PlayerCurrency)
        UINotify:Get():SendNotification(UINotifyEvent.BagViewRefresh)

        if msg.toMail and msg.toMail==1 then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.BagSlowToMail))
        end
    end

end

---@param parts SC_UserPart[]
function KnapsackDataManager:AddPart(parts)
    if parts and #parts > 0 then
        self.PartKnapsack:AddPart(parts,true)
    end
    self:SetRedPointData()
end

function KnapsackDataManager:DelArticleByPartsId(parts)
    self.PartKnapsack:DelArticleByPartsId(parts)
    self:SetRedPointData()
end














function KnapsackDataManager:SetMsgData(msg)


    self.AllKnapsack:SetData(msg)
    self:SetEquipmentKnapsack()
    self:SetGoodsKnapsack()
end
function KnapsackDataManager:SetGoodsKnapsack()
    self.ArticleKnapsack:ClearDict()

    local list = self.AllKnapsack.ArticleCells
    for i = 1, #list do
        if not list[i]:IsPart() then
            table.insert(self.ArticleKnapsack.ArticleCells, list[i])
            self.ArticleKnapsack.CellIdDict[list[i]:GetCellID()] = list[i]
            self.ArticleKnapsack.IDDict[list[i]:GetID()] = list[i]
        end
    end
end

function KnapsackDataManager:SetEquipmentKnapsack()
    self.PartKnapsack:ClearDict()

    local list = self.AllKnapsack.ArticleCells
    for i = 1, #list do
        if list[i]:IsPart() then
            table.insert(self.PartKnapsack.ArticleCells, list[i])
            self.PartKnapsack.CellIdDict[list[i]:GetCellID()] = list[i]
            self.PartKnapsack.IDDict[list[i]:GetID()] = list[i]
        end
    end
end




---@return table<number, ArticleCell>
function KnapsackDataManager:GetPartListByCfgid(id)
    local result = {}
    for i = 1, #self.PartKnapsack.ArticleCells do
        local temp = self.PartKnapsack.ArticleCells[i]
        if temp:GetPartConfig().C_ID == id then
            table.insert(result, temp)
        end
        --print("---   ", type, temp, temp:GetArticleConfig())
    end

    return result
end
---@param filterTable ArticleCell[]
---@return table<number, ArticleCell>
function KnapsackDataManager:GetPartNoChangeListByCfgid(id,filterTable)
    local result = {}
    if filterTable==nil then
        filterTable={}
    end
    for i = 1, #self.PartKnapsack.ArticleCells do
        local temp = self.PartKnapsack.ArticleCells[i]
        if temp:GetPartConfig().C_ID == id then
            if not temp:IsChange() then
                local flag=true
                for j = 1, #filterTable do
                    if temp:GetCellID()==filterTable[j]:GetCellID() then
                        flag=false
                        break
                    end
                end
                if flag then
                    table.insert(result, temp)
                end
            end
        end
        --print("---   ", type, temp, temp:GetArticleConfig())
    end

    return result
end

---@return table<number, ArticleCell>
function KnapsackDataManager:GetPartNoChangeList()
    local result = {}
    for i = 1, #self.PartKnapsack.ArticleCells do
        local temp = self.PartKnapsack.ArticleCells[i]
        if not temp:IsChange() then
            table.insert(result, temp)
        end
    end

    return result
end


---@return table<number, ArticleCell>
function KnapsackDataManager:GetPartListByBaseId(id)
    local result = {}
    for i = 1, #self.PartKnapsack.ArticleCells do
        local temp = self.PartKnapsack.ArticleCells[i]
        if temp:GetPartBaseCfg().C_ID == id then
            table.insert(result, temp)
        end
        --print("---   ", type, temp, temp:GetArticleConfig())
    end

    return result
end
--{{{ 获取已经未改造升级升代的配件
---@return table<number, ArticleCell>
function KnapsackDataManager:GetPartFoundationListByBaseId(id)
    local result = {}
    for i = 1, #self.PartKnapsack.ArticleCells do
        local temp = self.PartKnapsack.ArticleCells[i]
        if temp:GetPartBaseCfg().C_ID == id and not temp:GetAwaken() and temp:GetStar()==1 and temp:GetPartLV()==1 and temp:GetGeneration()==1 then
            table.insert(result, temp)
        end
        --print("---   ", type, temp, temp:GetArticleConfig())
    end

    return result
end
--}}}
--{{{ 获取已经改造升级升代配件
---@return table<number, ArticleCell>
function KnapsackDataManager:GetPartChangeList()
    local result = {}
    for i = 1, #self.PartKnapsack.ArticleCells do
        local temp = self.PartKnapsack.ArticleCells[i]
        if temp:GetAwaken() or temp:GetStar()>1 or temp:GetPartLV()>1 or temp:GetGeneration()>1 then
            table.insert(result, temp)
        end
        --print("---   ", type, temp, temp:GetArticleConfig())
    end

    return result
end


---@return table<number, ArticleCell>
function KnapsackDataManager:GetPartChangeListByType(type)
    local result = {}
    for i = 1, #self.PartKnapsack.ArticleCells do
        local temp = self.PartKnapsack.ArticleCells[i]
        if temp:GetPartType() == type and (temp:GetAwaken() or temp:GetStar()>1 or temp:GetPartLV()>1 or temp:GetGeneration()>1) then
            table.insert(result, temp)
        end
        --print("---   ", type, temp, temp:GetArticleConfig())
    end

    return result
end

--}}}



function KnapsackDataManager:GetEquipmentsByPartChildType(type, childType)
    local result = {}
    for i = 1, #self.PartKnapsack.ArticleCells do
        local temp = self.PartKnapsack.ArticleCells[i]
        if temp:GetPartType() == type then
            if childType and temp:GetPartSubType() ~= childType then

            else
                table.insert(result, temp)
            end
        end
    end

    return result
end




function KnapsackDataManager:UpdatePartBelong(bagid,carid)
    local data = KnapsackDataManager:Get():GetArticleByID(bagid)
    data:SetUserCarId(carid)
end
---@param msg table<number,number>
function KnapsackDataManager:UpdatePartUnload(msg)
    if msg then
        for i = 1, #msg do
            local data = KnapsackDataManager:Get():GetArticleByID(msg[i])
            data:SetUserCarId(0)
        end
    end
end

function KnapsackDataManager:SetRedPointDataOnOpen()
    local costList=self.PartKnapsack.ArticleCells
    self.New=false
    for i = 1, #costList do
         costList[i]:SetNew(false)
    end
end
function KnapsackDataManager:SetRedPointData()
   local costList=self.PartKnapsack.ArticleCells
    self.New=false
    for i = 1, #costList do
        if costList[i]:IsNew() then
            self.New=true
            break
        end
    end
    RedPointManager:Get():UpdateValue(RedPointID.Bag)
    if self.New then
        RedPointManager:Get():UpdateValue(RedPointID.Garage)
    end
end
function KnapsackDataManager:GetIsNew()
   return self.New
end
---@param consumeData SC_Consume
function KnapsackDataManager:TrackConsumeEvent(para)
    QuickTaHelper:Get():TrackConsumeEvent(para)
end
---@param props SC_UserProp[]
function KnapsackDataManager:TrackGetPropEvent(props)
    QuickTaHelper:Get():TrackGetPropEvent(props)
end
---@param parts SC_UserPart[]
function KnapsackDataManager:TrackGetPartEvent(parts)
    QuickTaHelper:Get():TrackGetPartEvent(parts)
end

--function KnapsackDataManager:AnalysePartidByBagid(bagid)
--    local partid = 0
--    if bagid == 0 then
--        return partid
--    end
--
--    local bagdata = self:GetArticleByID(bagid)
--    if bagdata == nil then
--        logError("---   error:背包中没有对应配件，bagid = "..bagid)
--        return partid
--    end
--
--    local cfg = bagdata:GetPartConfig()
--    if cfg == nil then
--        logError("---   error:配件找不到配置表数据，bagid = "..bagid)
--        return
--    end
--
--    partid = cfg.id
--    return partid
--end


function KnapsackDataManager:ClearData()
    -- self.AllKnapsack:ClearDict()
    if self.ArticleKnapsack then self.ArticleKnapsack:ClearDict() end
    if self.PartKnapsack then self.PartKnapsack:ClearDict() end
end

return KnapsackDataManager()