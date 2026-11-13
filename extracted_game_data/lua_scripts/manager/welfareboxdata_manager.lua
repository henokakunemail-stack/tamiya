---@class WelfareBoxDataManager
WelfareBoxDataManager = class("WelfareBoxDataManager")

---@class BoxAwardData---------------------------------------
BoxAwardData = class("BoxAwardData")
function BoxAwardData:initialize()
    self.BoxId = -1
    self.BoxLoc = -1
    self.ExpTime = -1
    self.OpenTime = -1
    self.UnlockFlag = -1
end

function BoxAwardData:InitBaseData(data)
    self.BoxId = data.boxId
    self.BoxLoc = data.boxLoc
    self.ExpTime = data.expTime
    self.OpenTime = data.openTime
    self.UnlockFlag = data.unlockFlag
    self.BoxSum = data.boxSum
end

function BoxAwardData:GetBoxId()
    return self.BoxId
end

function BoxAwardData:GetBoxLoc()
    return self.BoxLoc
end

function BoxAwardData:GetExpTime()
    return self.ExpTime
end

function BoxAwardData:GetOpenTime()
    return self.OpenTime
end

function BoxAwardData:GetUnlockFlag()
    return self.UnlockFlag
end

function BoxAwardData:GetBoxSum()
    return self.BoxSum
end


---@return WelfareBoxDataManager
function WelfareBoxDataManager:Get()
    if self._instance == nil then
        self._instance = WelfareBoxDataManager()
    end
    return self._instance
end

function WelfareBoxDataManager:initialize()
    self.BoxAwardData = {}
end

function WelfareBoxDataManager:InitBoxAwardData(msg)
    self.BoxAwardData = {}
    for i, v in pairs(msg) do
        local itemData = BoxAwardData()
        itemData:InitBaseData(v)
        table.insert(self.BoxAwardData, itemData)
    end

end

---@return table<number,BoxAwardData>
function WelfareBoxDataManager:GetBoxAwardData()
    return self.BoxAwardData
end

function WelfareBoxDataManager:SetBoxAwardDataByID(msg)
    for i, v in pairs(self.BoxAwardData) do
        if v.BoxLoc == msg.boxLoc then
            local itemData = BoxAwardData()
            itemData:InitBaseData(msg)
            self.BoxAwardData[i] = itemData
        end
    end
end

function WelfareBoxDataManager:SetBoxAwardWareData()
    self.WareList = {}
    local _wareList = ClientDataManager:Get():GetDataTable(ConfigNames.article_config).GetArticleListType2(GoodsType2.Article_Box, 1)

    for i, v in pairs(_wareList) do
        table.insert(self.WareList, { boxId = v.C_ID, boxNum = 0 })
    end

end

function WelfareBoxDataManager:GetBoxAwardWareData()
    --local _KnapData = KnapsackDataManager:Get():GetArticleListByType(GoodsType2.Article_Box)
    self.HaveWareList = {}

    --for i, v in pairs(self.WareList) do
    --    local _data = self:GetHaveBoxNum(v.boxId)
    --    local ifHave = KnapsackDataManager:Get():GetArticleCountByCfgid(v.boxId)
    --    if _data and ifHave > 0 then
    --        self.WareList[i].boxNum = _data:GetCount()
    --        table.insert(self.HaveWareList, self.WareList[i])
    --    end
    --end

    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.BoxAwardHelpID)
    local tittleData = stringSplit(cfg.varval, ':')
    for i, v in pairs(tittleData) do
        table.insert(self.HaveWareList, tonumber(v))
    end

    return self.HaveWareList
end

function WelfareBoxDataManager:GetHaveBoxNum(_ID)
    local _KnapList = KnapsackDataManager:Get():GetArticleListByType(GoodsType2.Article_Box)

    for i, v in pairs(_KnapList) do
        if v:GetID() == _ID then
            return v
        end
    end

    return nil
end

function WelfareBoxDataManager:GetBoxFirstVacancy()
    for i, v in pairs(self.BoxAwardData) do
        if v:GetUnlockFlag() == 1 and v:GetBoxId() == 0 then
            return i
        end
    end
    return -1
end

function WelfareBoxDataManager:GetBoxTypeData()
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.BoxAwardHelpID)
    local tittleData = stringSplitToNumber(cfg.varval, ':')
    return tittleData
end

function WelfareBoxDataManager:GetCostData(differenceValueTime)
    local _cost = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.WelfareBoxAwardCost)
    local _minute = tostring(math.ceil(differenceValueTime / TimeSecond_Minute) * _cost.varval)
    local _minuteText = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.Lab_NewSpeedUp), _minute)
    return _minuteText
end

function WelfareBoxDataManager:SetExaminationMsgData(msg)
    self.ExaminationMsgData = msg
end

function WelfareBoxDataManager:GetExaminationMsgData()
    return self.ExaminationMsgData
end

function WelfareBoxDataManager:GetBoxLocData()
    for i, v in pairs(self.BoxAwardData) do
        if v:GetUnlockFlag() == 1 and v:GetOpenTime() == 0 then
            return v:GetBoxLoc()
        end
    end
    return 0
end
---@param cell ArticleCell
function WelfareBoxDataManager:RefreshBoxAwardRedPointState(cell)
    local ArticleData = cell:GetArticleConfig()
    if ArticleData and cell:GetCount() > 0 and ArticleData.propstype == ArticlePropType.Box then
        local boxRed = RedPointManager:Get():GetValue(RedPointID.S_WelfareBoxAwardState)
        if not boxRed then
            RedPointManager:Get():UpdateValue(RedPointID.S_WelfareBoxAwardState, true)
        end
    end
end

function WelfareBoxDataManager:SetBoxAwardFastestTime()
    local FastestTime = 999999
    self.FastestData = nil
    if self.BoxAwardData then
        for i, v in pairs(self.BoxAwardData) do
            if v:GetBoxId() > 0 then
                local differenceValueTime = v:GetOpenTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) - 1
                if differenceValueTime > 0 and FastestTime > differenceValueTime then
                    FastestTime = differenceValueTime
                    self.FastestData = v
                end
            end
        end
    end

end

function WelfareBoxDataManager:GetBoxAwardFastestTime()
    return self.FastestData
end