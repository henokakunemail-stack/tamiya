---@class TrackItemCDData
TrackItemCDData = class("TrackItemCDData")

function TrackItemCDData:initialize()
    self.techId = -1
    self.startTime = 0 --到期时间，秒
    self.procnum = 0
    self.isFinish = false --是否完成了
end

function TrackItemCDData:InitTimeData(msg, type)
    if type == LabToggleType.SegTech then
        self.techId = msg.techId
        self.startTime = msg.startTime --激活CD
        self.procnum = msg.procnum
        self.trackType = type
        self:SetIsFinish(CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) >= msg.startTime)
    end

    if type == LabToggleType.SegProduct then
        self.techId = msg.trackId
        self.startTime = msg.startTime --激活CD
        self.procnum = msg.procnum
        self.trackType = type
        self:SetIsFinish(CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) >= msg.startTime)
    end
end

function TrackItemCDData:UpdateStartTime()
    self.startTime = self.startTime
end

function TrackItemCDData:GetStartTime()
    return self.startTime
end

function TrackItemCDData:GetId()
    return self.techId
end

function TrackItemCDData:GetIsFinish()
    return self.isFinish
end

function TrackItemCDData:SetIsFinish(isFinish)
    self.isFinish = isFinish
end

---@return LabExpType
function TrackItemCDData:GetLabExpType()
    return self.trackType
end

---@class TrackItemData
TrackItemData = class("TrackItemData")
function TrackItemData:initialize()
    self.curStatus = 0  --0未激活 1激活
    self.ownTracks = {}
    self.startTime = 0   --激活CD
    self.techId = 0
end

function TrackItemData:InitBaseData(msg)
    self.curStatus = msg.curStatus  --0未激活 1激活
    if msg.ownTracks ~= nil then
        self.ownTracks = msg.ownTracks
    end
    self.startTime = msg.startTime --激活CD
    self.techId = msg.techId
end

function TrackItemData:GetCurStatus()
    return self.curStatus
end

function TrackItemData:GetOwnTracks()
    return self.ownTracks
end

function TrackItemData:GetsStartTime()
    return self.startTime
end

function TrackItemData:GetTechId()
    return self.techId
end

---@class TrackDataManager
TrackDataManager = class("TrackDataManager")

function TrackDataManager:Get()
    if self._instance == nil then
        self._instance = TrackDataManager()
    end
    return self._instance
end

function TrackDataManager:initialize()

    self.TrackTagType = LabToggleType.None
    self.TrackTimerIds = {}
    self.TrackTagTypeIdx = {}

    self.TrackData = {}

    self.trackTitleData = {}
    self.trackItemDic = {}

    CacheClearTrigger:Get():RegisterEvent(self, self.Clear)
end

function TrackDataManager:SetTrackItemDatas(msg)
    self.trackItemDic = {}

    for i, v in pairs(msg) do
        table.insert(self.trackTitleData, { v.scienceLev, v.unlockFlag })
        for k, n in pairs(v.ownTechs) do
            local trackItemData = TrackItemData()
            trackItemData:InitBaseData(n)
            self.trackItemDic[trackItemData:GetTechId()] = trackItemData
        end
    end

end

function TrackDataManager:SetTrackItemDataOfTitle(msg)
    for i, v in pairs(self.trackTitleData) do
        if v[1] == msg.scienceLev then
            self.trackTitleData[i] = { msg.scienceLev, msg.unlockFlag }
        end
    end

end

function TrackDataManager:SetTrackItemData(msg)
    self.trackItemDic[msg.techId] = msg
end

function TrackDataManager:SetTrackManufactureItemData(msg)
    for i, v in pairs(self.trackItemDic) do
        for j, k in pairs(v.ownTracks) do
            if k.trackId == msg.trackId then
                self.trackItemDic[i].ownTracks[j] = msg
            end
        end
    end
end

function TrackDataManager:GetTrackItemDataDic()
    return self.trackItemDic
end

function TrackDataManager:GetTrackTitleDatas()
    return self.trackTitleData
end

function TrackDataManager:GetTrackItemDataDicByID(techID)
    return self.trackItemDic[techID]
end

function TrackDataManager:GetTrackManufactureItemDataByID(trackId)
    for i, v in pairs(self.trackItemDic) do
        for j, k in pairs(v.ownTracks) do
            if k.trackId == trackId then
                return false
            end
        end
    end
    return true
end

function TrackDataManager:GetTrackTitleData(lvID)
    for i, v in pairs(self.trackTitleData) do
        if v[1] == lvID then
            return v
        end
    end

end

---@param labExpType LabExpType
function TrackDataManager:SetTrackTagType(labExpType)
    self.TrackTagType = labExpType
end

---@return  LabExpType
function TrackDataManager:GetTrackTagType()
    return self.TrackTagType
end

function TrackDataManager:AddTrackItemCDData(msg, type)
    local itemCDData = TrackItemCDData()
    itemCDData:InitTimeData(msg, type)

    if self.TrackTagTypeIdx[itemCDData:GetLabExpType()] == nil then
        self.TrackTagTypeIdx[itemCDData:GetLabExpType()] = {}
    end

    table.insert(self.TrackTagTypeIdx[itemCDData:GetLabExpType()], itemCDData)
end

---@param msg SC_UserTech
---@param msg SC_procTrack
function TrackDataManager:RemoveTrackItemCDData(msg, type)
    if self.TrackTagTypeIdx[type] ~= nil then

        if type == LabToggleType.SegTech then
            for i = 1, #self.TrackTagTypeIdx[type] do
                if msg.techId == self.TrackTagTypeIdx[type][i]:GetId() then
                    table.remove(self.TrackTagTypeIdx[type], i)
                    break
                end
            end
        end

        if type == LabToggleType.SegProduct then
            for i = 1, #self.TrackTagTypeIdx[type] do
                if msg.trackId == self.TrackTagTypeIdx[type][i]:GetId() then
                    table.remove(self.TrackTagTypeIdx[type], i)
                    break
                end
            end
        end

    end
end

---@param msg SC_UserScience
---@param msg SC_UserTech
function TrackDataManager:InitTrackCdDatas(msg)
    self.TrackTagTypeIdx = {}

    for i, v in pairs(msg) do
        for j, k in pairs(v.ownTechs) do
            if k.startTime > 0 then
                self:AddTrackItemCDData(k, LabToggleType.SegTech)
            end
            for m, n in pairs(k.ownTracks) do
                if n.startTime > 0 then
                    self:AddTrackItemCDData(n, LabToggleType.SegProduct)
                end
            end
        end
    end

end

---@param msg SC_UserTech
---@param msg SC_procTrack
function TrackDataManager:InitTrackCdData(msg, type)
    if type == LabToggleType.SegTech then
        self:AddTrackItemCDData(msg, LabToggleType.SegTech)
    end

    if type == LabToggleType.SegProduct then
        self:AddTrackItemCDData(msg, LabToggleType.SegProduct)
    end
end
---@param msg SC_UserTech
---@param msg SC_procTrack
function TrackDataManager:RemoveTrackCdData(msg, type)
    if type == LabToggleType.SegTech then
        self:RemoveTrackItemCDData(msg, LabToggleType.SegTech)
    end

    if type == LabToggleType.SegProduct then
        self:RemoveTrackItemCDData(msg, LabToggleType.SegProduct)
    end
end

---@param type LabExpType
---@return table<number,TrackItemCDData>
function TrackDataManager:GetTrackCdDataByType(type)
    if self.TrackTagTypeIdx[type] then
        return self.TrackTagTypeIdx[type]
    end
    return {}
end

function TrackDataManager:Clear()
    self.TrackTagType = LabToggleType.None
    self.TrackTimerIds = {}
    self.TrackTagTypeIdx = {}
    self.TrackData = {}
    self.trackTitleData = {}
    self.trackItemDic = {}

end


