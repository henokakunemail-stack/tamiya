

---@class RedPointDataGarageCar : RedPointDataBase
RedPointDataGarageCar = class("RedPointDataGarageCar", RedPointDataBase)

function RedPointDataGarageCar:initialize(id)
    RedPointDataBase.initialize(self, id)
end

---@param param
function RedPointDataGarageCar:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = param
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end




---@class RedPointDataGarage : RedPointDataBase
RedPointDataGarage = class("RedPointDataGarage", RedPointDataBase)

function RedPointDataGarage:initialize(id)
    RedPointDataBase.initialize(self, id)
end

---@param param PartGrooveID
function RedPointDataGarage:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    --if param == nil then
    local list = CarDataManager:Get():GetCarList()
    for i = 1, #list do
        local key = RedPointHelper:CarIDToRedPointKey(i)
        local tempvalue = self:CalculateCar(list[i])
        list[i]:SetRedPointState(tempvalue)
        RedPointManager:Get():UpdateValue(key,tempvalue)
    end
    for i = 1, #list do
        value = list[i]:GetRedPointState()
        if value then break end
    end
    --else
    --    local carid = param[1]
    --    local grooveid = param[2]
    --    value = self:CalculateCar(carid, grooveid)
    --end
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end



function RedPointDataGarage:CalculateCar(cardata)
    local result = false
    if cardata == nil or cardata.LockState~=ParkingLotState.Open then
        log("---   error:RedPointDataGarage:UpdateValue()   cardata = nil,carid:",carid)
        return result
    end
    local list = cardata.assembleMgr:GetNodeList()
    for i = 1, #list do
       self:CalculateNode(list[i])
    end
    for i = 1, #list do
        result = list[i]:GetRedFlag()
        if result then
            cardata:SetRedPointState(result)
            break
        end
    end
    return result
end

---@param node CarDetailData
function RedPointDataGarage:CalculateNode(node)
    local result = false
    if node and node:GetGrooveState()==GrooveState.UnLock then
        local bagid = node:GetBagId()
        if bagid > 0 then
            local templist = KnapsackDataManager:Get():GetEquipmentsByGroove(node:GetGrooveId())
            local nodeArticle=KnapsackDataManager:Get():GetArticleByCellID(bagid)
            if nodeArticle == nil then
                log("---   error:RedPointDataGarage:CalculateRedPoint   article = nil,bagid:",bagid)
            else
                 for i = 1, #templist do
                      result=self:CalculateAssemble(nodeArticle,templist[i])
                     if result then
                         break
                     end
                 end
                 if not result then
                    result = self:CalculateLevelUp(nodeArticle)
                    if not result then
                        result = self:CalculateStar(nodeArticle)
                        if not result then
                            result = self:CalculateReform(nodeArticle)
                            if not result then
                                result = self:CalculateStrong(nodeArticle)
                            end
                        end
                    end
                 end
            end
        else
            local templist = KnapsackDataManager:Get():GetEquipmentsByGroove(node:GetGrooveId())
            for i = 1, #templist do
                result=templist[i]:IsNew()
                if result then
                    break
                end
            end
        end
    end
    node:SetRedFlag(result)
    return result
end

---@param article ArticleCell
function RedPointDataGarage:CalculateLevelUp(article)
    local result = false
    return result
end

---@param article ArticleCell
function RedPointDataGarage:CalculateStar(article)
    local result = false
    return result
end

---@param article ArticleCell
function RedPointDataGarage:CalculateReform(article)
    local result = false
    return result
end

---@param article ArticleCell
function RedPointDataGarage:CalculateStrong(article)
    local result = false
    return result
end
---@param article ArticleCell
---@param nodearticle ArticleCell
function RedPointDataGarage:CalculateAssemble(nodearticle,article)
    local result = false
    if nodearticle and article and article:IsNew() then
        result=nodearticle:GetPartQuality()<article:GetPartQuality()
    end
    return result
end

