---@class NewPlayerCarDataManager
NewPlayerCarDataManager = class("NewPlayerCarDataManager")

function NewPlayerCarDataManager:initialize()
    self.Bag=KnapsackData(BagType.TempNewPlayer)
    ---@type CarData[]
    self.CarDataManager={}
    ---@type CarData[]
    self.CarDic={}
end
function NewPlayerCarDataManager:Get()
    if self._instance == nil then
        self._instance = NewPlayerCarDataManager()
    end
    return self._instance
end

---@param msg SC_UserFairInfo
function NewPlayerCarDataManager:Init(parts,cars)
    self:Clear()
    self.Bag:AddPart(parts,false)
    for i = 1, #cars do
        if cars[i].planseq==11 then
            local data = CarData()
            data:SetData(cars[i],self.Bag)
            self.CarDataManager[i]=data
            self.CarDic[data:GetID()]=data
        end
    end
end
---@param msg SC_UserCar
function NewPlayerCarDataManager:UpdateCarData(msg)
    if msg then
        local cardata = self.CarDic[msg.planseq]
        if cardata then
            cardata:UpdateData(msg)
            cardata:CheckArticleAdaptationChassis()
        end
    end
end
---@param msg SC_UserCar
function NewPlayerCarDataManager:UpdatePartBelong(bagid,carid)
    local data = self.Bag:GetArticleByCellID(bagid)
    if data then
        data:SetUserCarId(carid)
    end
end
---@param msg table<number,number>
function NewPlayerCarDataManager:UpdatePartUnload(msg)
    if msg then
        for i = 1, #msg do
            local data = self.Bag:GetArticleByCellID(msg[i])
            if data then
                data:SetUserCarId(0)
            end
        end
    end
end
function NewPlayerCarDataManager:DelArticleByPartsId(parts)
    self.Bag:DelArticleByPartsId(parts)
end
function NewPlayerCarDataManager:UpdateCarAttrByCarId(id,carAttrs)
    if id then
        local cardata = self.CarDic[id]
        if cardata then
            cardata:UpdateAttrs(carAttrs)
            cardata:CheckArticleAdaptationChassis()
        end
    end
end
function NewPlayerCarDataManager:UpdatePartByCarId(id,msg)
    local data = self.Bag:GetArticleByCellID(id)
    if data then
        data:OnInitPart(msg)
    end
end

function NewPlayerCarDataManager:Clear()
    self.Bag=KnapsackData(BagType.TempNewPlayer)
    self.CarDataManager={}
    self.CarDic={}
end
