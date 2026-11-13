



---@class TeamData
TeamData = class("TeamData")
function TeamData:initialize(ID, posIdx, teamIdx)
    self.carID = ID -- -1未开启  0没有车
    self.posIdx = posIdx
    self.teamIdx = teamIdx
    ---@type CarData
    self.carData = nil
end




---@class TeamManager
TeamManager = class("TeamManager")
function TeamManager:initialize()
    ---@type table<number, table<number, TeamData>>
    self.teamList = {}
end
function TeamManager:Get()
    if self._instance == nil then
        self._instance = TeamManager()
    end
    return self._instance
end
function TeamManager:InitTeamList(msgdata)
    self.teamList = {}
    for i = 1, #msgdata do
        local data = {}
        data[1] = TeamData(msgdata[i].num1, 1, i)
        data[2] = TeamData(msgdata[i].num2, 2, i)
        data[3] = TeamData(msgdata[i].num3, 3, i)
        data[4] = TeamData(msgdata[i].num4, 4, i)
        data[5] = TeamData(msgdata[i].num5, 5, i)
        self.teamList[i] = data
    end

    self:LinkCarTeam()
end

function TeamManager:GetTeam(teamIdx)
    return self.teamList[teamIdx]
end

function TeamManager:GetTeamData(teamIdx, posIdx)
    return self.teamList[teamIdx][posIdx]
end

---@return TeamData
function TeamManager:GetTeamDataByCar(teamIdx, carid)
    local temp = self.teamList[teamIdx]
    for i = 1, #temp do
        if temp[i].carID == carid then
            return temp[i]
        end
    end
    return nil
end

---@param cardata CarData
function TeamManager:UpdateTeamData(teamIdx, posIdx, cardata)

    self.teamList[teamIdx][posIdx].carData = cardata
    local carid = -1
    if cardata then carid = cardata:GetID()
    end
    self.teamList[teamIdx][posIdx].carID = carid


    --TeamSubsystem:Get():SendMsg_ChangeCar(teamIdx - 1, posIdx - 1, carid)
end

function TeamManager:GetTeamList()
    return self.teamList
end

function TeamManager:LinkCarTeam()
    local carlist = CarDataManager:Get():GetCarList()
    if #carlist == 0 then return end
    for i = 1, #carlist do
        --carlist[i]:UpdateTeam(1, -1)
        --carlist[i]:UpdateTeam(2, -1)
        --carlist[i]:UpdateTeam(3, -1)
        --carlist[i]:UpdateTeam(4, -1)
        --carlist[i]:UpdateTeam(5, -1)
    end

    for i = 1, #self.teamList do
        local team = self.teamList[i]
        for m = 1, #team do
            local cardata = CarDataManager:Get():GetCarDataByCarID(team[m].carID)
            if cardata then
                --cardata:UpdateTeam(team[m].teamIdx, team[m].posIdx)
                team[m].carData = cardata
            end
        end
    end



end


function TeamManager:ClearData()
    self.teamList = {}
end



