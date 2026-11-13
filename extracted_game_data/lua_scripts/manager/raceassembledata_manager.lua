---@class RaceAssembleManager
RaceAssembleManager = class("RaceAssembleManager")

function RaceAssembleManager:initialize()
    self.Bag=KnapsackData(BagType.TempAssemble)
    ---@type CarData[]
    self.CarDataManager={}
    ---@type CarData[]
    self.CarDic={}
    self.MatchId=-1
    self.PlanSeq=-1
    self.MatchFinishTime=-1
    self.MatchEndTime={}
end
function RaceAssembleManager:Get()
    if self._instance == nil then
        self._instance = RaceAssembleManager()
    end
    return self._instance
end

---@param msg SC_UserFairInfo
function RaceAssembleManager:Init(msg)
    self:Clear()
    self.Bag:AddPart(msg.fairParts,false)
    for i = 1, #msg.myCars do
        local data = CarData()
        data:SetData(msg.myCars[i],self.Bag)
        self.CarDataManager[i]=data
        self.CarDic[data:GetID()]=data
    end
    self.MatchId=msg.matchId
    self.MatchEndTime=msg.matchendTime
    self.MatchBeginTime=msg.matchbeginTime
    self.MatchFinishTime=msg.matchFinishTime
    self.ConsumeList=CommonHelper:SetDataByConsumeList(msg.consumelist)
    self.JoinType=msg.needjoin
    self.TrackData=CommonHelper:GetRacetrackData(msg.trackid)
    self.SceneId=msg.scenceid
    self.Rank3List=msg.rank3list
    self.AwardId=msg.awardid
    self.CurBattleCount=msg.curnum
end


function RaceAssembleManager:GetSceneID()
    return self.SceneId
end
function RaceAssembleManager:GetTrackData()
    return self.TrackData
end
function RaceAssembleManager:GetCanJoin()
    return self.JoinType==1
end
function RaceAssembleManager:GetCurBattleCount()
    return self.CurBattleCount
end

function RaceAssembleManager:GetMatchId()
    return self.MatchId
end
function RaceAssembleManager:GetFirstRacer()
    return self.FirstRacer
end
function RaceAssembleManager:GetRank3List()
    return self.Rank3List
end
function RaceAssembleManager:GetRaceEndTime()
    return self.MatchEndTime
end
function RaceAssembleManager:GetRaceFinishTime()
    return self.MatchFinishTime
end

function RaceAssembleManager:GetMatchBeginTime()
    return self.MatchBeginTime
end
function RaceAssembleManager:GetAwardId()
    return self.AwardId
end

---@param msg SC_UserCar
function RaceAssembleManager:UpdateCarData(msg)
    if msg then
        local cardata = self.CarDic[msg.planseq]
        if cardata then
            cardata:UpdateData(msg)
            cardata:CheckArticleAdaptationChassis()
        end
    end
end
---@param msg SC_UserCar
function RaceAssembleManager:UpdatePartBelong(bagid,carid)
    local data = self.Bag:GetArticleByCellID(bagid)
    if data then
        data:SetUserCarId(carid)
    end
end
---@param msg table<number,number>
function RaceAssembleManager:UpdatePartUnload(msg)
    if msg then
        for i = 1, #msg do
            local data = self.Bag:GetArticleByCellID(msg[i])
            if data then
                data:SetUserCarId(0)
            end
        end
    end
end
function RaceAssembleManager:DelArticleByPartsId(parts)
    self.Bag:DelArticleByPartsId(parts)
end
function RaceAssembleManager:UpdateCarAttrByCarId(id,carAttrs)
    if id then
        local cardata = self.CarDic[id]
        if cardata then
            cardata:UpdateAttrs(carAttrs)
            cardata:CheckArticleAdaptationChassis()
        end
    end
end
function RaceAssembleManager:UpdatePartByCarId(id,msg)
    local data = self.Bag:GetArticleByCellID(id)
    if data then
        data:OnInitPart(msg)
    end
end

function RaceAssembleManager:Clear()
    self.Bag=KnapsackData(BagType.TempAssemble)
    self.CarDataManager={}
    self.CarDic={}
    self.MatchId=-1
    self.PlanSeq=-1
    self.MatchFinishTime=-1
    self.MatchEndTime={}
end
