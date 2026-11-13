---@class RaceAssembleAddManager
RaceAssembleAddManager = class("RaceAssembleAddManager")

function RaceAssembleAddManager:initialize()
    self.Bag=KnapsackData(BagType.TempAdd)
    ---@type CarData[]
    self.CarDataManager={}
    ---@type CarData[]
    self.CarDic={}
end
function RaceAssembleAddManager:Get()
    if self._instance == nil then
        self._instance = RaceAssembleAddManager()
    end
    return self._instance
end

---@param msg SC_UserFairInfo
function RaceAssembleAddManager:Init(msg)
    self:Clear()
    self.Bag:AddPart(msg.fairParts,false)
    for i = 1, #msg.myCars do
        local data = CarData()
        data:SetData(msg.myCars[i],self.Bag)
        self.CarDataManager[i]=data
        self.CarDic[data:GetID()]=data
    end
    self.TrackData=CommonHelper:GetRacetrackData(msg.trackid)
    self.SceneId=msg.scenceid
    self.OpenType=tonumber(msg.uiModuleID)
    self.RaceType=tonumber(msg.raceType)
    self.RaceStyleType=tonumber(msg.racestyle)
end
function RaceAssembleAddManager:GetSceneID()
    return self.SceneId
end
function RaceAssembleAddManager:GetTrackData()
    return self.TrackData
end
function RaceAssembleAddManager:GetOpenType()
    return self.OpenType
end
function RaceAssembleAddManager:GetRaceType()
    return self.RaceType
end
function RaceAssembleAddManager:GetRaceStyleType()
    return self.RaceStyleType
end

---@param msg SC_UserCar
function RaceAssembleAddManager:UpdateCarData(msg)
    if msg then
        local cardata = self.CarDic[msg.planseq]
        if cardata then
            cardata:UpdateData(msg)
            cardata:CheckArticleAdaptationChassis()
        end

    end
end
---@param msg SC_UserCar
function RaceAssembleAddManager:UpdatePartBelong(bagid,carid)
    local data = self.Bag:GetArticleByCellID(bagid)
    if data then
        data:SetUserCarId(carid)
    end
end
---@param msg table<number,number>
function RaceAssembleAddManager:UpdatePartUnload(msg)
    if msg then
        for i = 1, #msg do
            local data = self.Bag:GetArticleByCellID(msg[i])
            if data then
                data:SetUserCarId(0)
            end
        end
    end
end
function RaceAssembleAddManager:DelArticleByPartsId(parts)
    self.Bag:DelArticleByPartsId(parts)
end
function RaceAssembleAddManager:UpdateCarAttrByCarId(id,carAttrs)
    if id then
        local cardata = self.CarDic[id]
        if cardata then
            cardata:UpdateAttrs(carAttrs)
            cardata:CheckArticleAdaptationChassis()
        end
    end
end
function RaceAssembleAddManager:UpdatePartByCarId(id,msg)
    local data = self.Bag:GetArticleByCellID(id)
    if data then
        data:OnInitPart(msg)
    end
end
function RaceAssembleAddManager:ReOpen()
    RaceAssembleAddSubsystem:Get():SendMsg_RaceAssembleInfo(self.TrackData:GetId(),self.SceneId,self.RaceType,self.RaceStyleType,self.OpenType)
end

function RaceAssembleAddManager:Clear()
    self.Bag=KnapsackData(BagType.TempAdd)
    self.CarDataManager={}
    self.CarDic={}
end
