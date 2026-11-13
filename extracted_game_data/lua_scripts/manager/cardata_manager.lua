




---@class CarDataManager
CarDataManager = class("CarDataManager")

function CarDataManager:initialize()
    ---@type table<number, CarData>
    self.CarList = {}

    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end

---@return CarDataManager
function CarDataManager:Get()
    if self._instance == nil then
        self._instance = CarDataManager()
    end
    return self._instance
end

---@param msg SC_NotifyCarChange
function CarDataManager:SetMsgData(msg)
    for i = 1, #msg.cars do
        local data = CarData()
        data:InitData(msg.cars[i])
        self:SetCarData(data)
    end
end

---@param msg SC_UserCar[]
function CarDataManager:InitCars(msg)
    log("初始化车的数据",#msg)
    for i = 1, #msg do
        if msg[i].planseq<=5 then
            local data = CarData()
            data:SetData(msg[i])
            self:SetCarData(data)
        end
    end
    RedPointManager:Get():UpdateValue(RedPointID.Garage)
end
function CarDataManager:AddCar(msg)
    local data = CarData()
    data:SetData(msg)
    self.CarList[data:GetID()]=data
    self.CarList[data:GetID()]:SetCarIdx(data:GetID())
    if self.CarList[data:GetID()+1] then
        self.CarList[data:GetID()+1].LockState=ParkingLotState.UnOpen
    end
    return  self.CarList[data:GetID()]
end

--function CarDataManager:UpdateCarTeam(carid, teamidx, posidx)
--    for i = 1, #self.CarList do
--        if self.CarList[i].carIdx == carid then
--            self.CarList[i]:UpdateTeam(teamidx, posidx)
--            break
--        end
--    end
--end

---@return CarData
function CarDataManager:GetCarDataByCarID(carid)
    local result = nil
    for i = 1, #self.CarList do
        if self.CarList[i]:GetCarIdx() == carid then
            result = self.CarList[i]
            break
        end
    end
    return result
end
---@param carAttrs SC_Attr[]
function  CarDataManager:UpdateCarAttrByCarId(id,carAttrs)
    local data=self:GetCarDataByCarID(id)
    if data then
        data:UpdateAttrs(carAttrs)
    end
end

---@return CarData
function CarDataManager:GetCarDataByIndex(index)

    return self.CarList[index]
end

---@param cardara CarData
function CarDataManager:SetCarData(cardara)
    local isnull = true
    for i = 1, #self.CarList do
        if self.CarList[i]:GetID() == cardara:GetID() then
            isnull = false
            self.CarList[i] = cardara
            self.CarList[i]:SetCarIdx(i)
            break
        end
    end

    if isnull then
        table.insert(self.CarList, cardara)
        cardara:SetCarIdx(#self.CarList)
    end
end


function CarDataManager:GetCarList()
    return self.CarList
end
function CarDataManager:GetCarNum()
    local count=0
    for i = 1, #self.CarList do
        if self.CarList[i].LockState==ParkingLotState.Open then
            count=count+1
        end
    end
    return count
end
--function CarDataManager:GetCarListByType(type)
--    local result = {}
--    for i = 1, #self.CarList do
--        if self.CarList[i].carCfg.carType == type or type == 0 then
--            table.insert(result, self.CarList[i])
--        end
--    end
--    return result
--end


function CarDataManager:CheckCarCompleteness(carid, isshowtips) -- 检测车的完整性，必要配件必须安装
    if isshowtips == nil then isshowtips = true end
    local cardata = self:GetCarDataByCarID(carid)
    if cardata == nil then
        if isshowtips then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoSelectCar))
        end
        return false
    end
    return cardata:CheckCarCompleteness(isshowtips)
end
function  CarDataManager:CheckArticleAdaptationChassis(carId)
    local cardata = self:GetCarDataByCarID(carId)
    if cardata == nil then return false end
    return cardata:CheckArticleAdaptationChassis()
end
function  CarDataManager:CheckArticleIsExp(carId)
    local cardata = self:GetCarDataByCarID(carId)
    if cardata == nil then return false end
    return cardata:CheckArticleIsExp()
end

function CarDataManager:ClearData()
    self.CarList = {}
end


