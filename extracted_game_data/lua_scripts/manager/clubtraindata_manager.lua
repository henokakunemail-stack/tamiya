---@class ClubTrainDataManager
ClubTrainDataManager = class("ClubTrainDataManager")

---@return ClubTrainDataManager
function ClubTrainDataManager:Get()
    if self._instance == nil then
        self._instance = ClubTrainDataManager()
    end
    return self._instance
end

function ClubTrainDataManager:initialize()
    ---@type table<number,RaceTrackData>
    self.TrackList = {}
    self.CurSelectTrackIdx = -1
    self.SelectCarData = nil

    self.indexId={}
end

function ClubTrainDataManager:GetSegmentManager()
    return self.segmentTrackManager
end

function ClubTrainDataManager:SetCurSelectCarData(carData)
    self.SelectCarData = carData
end

---@return CarData
function ClubTrainDataManager:GetCurSelectCarData()
    return self.SelectCarData
end

function ClubTrainDataManager:SetCurSelectTrackIdx(curSelectTrackIdx)
    self.CurSelectTrackIdx = curSelectTrackIdx
end
function ClubTrainDataManager:GetCurSelectTrackIdx()
    return self.CurSelectTrackIdx
end

---@param msg SC_GetSelfTrackRaceInfoRes
function ClubTrainDataManager:InitTrackListInfo(msg)
    self.TrackList = {}
    self.indexId={}
    for i = 1, #msg.trackInfo do
        local trackId=msg.trackInfo[i].idx
        local RaceTrackData = CommonHelper:GetRacetrackData(nil, nil, msg.trackInfo[i])
        RaceTrackData:SetId(trackId)
        --这只RaceTrackData里面的customTrackData 的id 为i-1，需要一个设置RaceTrackData里面的customTrackData 的id方法
        self.TrackList[trackId]=RaceTrackData
        table.insert(self.indexId,trackId)
    end

    for i = 0, 2 do
        if self.TrackList[i]==nil then
            local RaceTrackData =RaceTrackData()
            RaceTrackData:SetSelfDefineData()
            RaceTrackData:SetId(i)
            self.TrackList[i]=RaceTrackData
            table.insert(self.indexId,i)
        end
    end

    table.sort(self.indexId, function(a, b)
        return a < b
    end)
end

---@return CustomTrack_Data
function ClubTrainDataManager:GetTrackInfoByIndex(index)
    --需要一个获取CustomTrack_Data的方法
    local trackId=self.indexId[index]
    if  self.TrackList[trackId] then
        return self.TrackList[trackId]:GetCustomData()
    end

end

---@return CustomTrack_Data
function ClubTrainDataManager:GetCurSelectTrackInfo()
    return self:GetTrackInfoByIndex(self:GetCurSelectTrackIdx())
end

function ClubTrainDataManager:GetTrackInfoCount()
    return #self.indexId
end

---@param trackInfo CustomTrack_Data
function ClubTrainDataManager:SetTrackInfoByIndex(index, trackInfo)
    local trackId=self.indexId[index]
    self.TrackList[trackId] = trackInfo
end

function ClubTrainDataManager:ClearData()
    self.SelectCarData = nil
end



---@param data RaceTrackData
function ClubTrainDataManager:UpdateTrackDataByIndex(index,data)
    local trackId=self.indexId[index]
    self.TrackList[trackId] = data
end







