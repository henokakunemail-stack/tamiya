---@class RaceTrackDataManager
RaceTrackDataManager =class("RaceTrackDataManager")

function RaceTrackDataManager:Get()
    if self._instance==nil then
        self._instance=RaceTrackDataManager()
        self:LoadAllRaceTrack()
    end
    return self._instance
end
function RaceTrackDataManager:initialize()
    ---@type table<number,RaceTrackData>
    self.SystemRaceTrackList=nil
    ---@type RaceTrackData[]
    self.SystemRaceTrackDic=nil

    ---@type table<number,RaceTrackData>
    self.CustomTrackList=nil
    ---@type table<number,number>
    self.CustomTrackListFive=nil
    ---@type table<number,number>
    self.CustomTrackListThree=nil
    ---@type table<number,RaceTrackData>
    self.RacetrackDataList=nil
end

-------------------------------------系统赛道
function RaceTrackDataManager:LoadAllRaceTrack()
    if self.SystemRaceTrackList==nil or self.SystemRaceTrackDic==nil then
        self.SystemRaceTrackList={}
        self.SystemRaceTrackDic={}
    end
    local racetrack_config= ClientDataManager:Get():GetDataTable(ConfigNames.racetrack_config).GetConfigData()
    for i, v in pairs(racetrack_config) do
        local data=RaceTrackData()
        data:SetData(v.C_ID,nil)
        table.insert(self.SystemRaceTrackList,data)
        self.SystemRaceTrackDic[v.C_ID]=data
    end
end

function RaceTrackDataManager:GetSystemRaceDataById(id)
    local  id,orgId,FillType=CommonHelper:ParseTrackId(id)
    local data=self.SystemRaceTrackDic[id]
    if data then
        data.FillType=FillType
        data.TrackOrgId=orgId
    end
    return data
end

---------------------------------自定义赛道列表
---@param trackList table<number,SC_UserTrack>
function RaceTrackDataManager:RecServerData(trackList)
    if self.CustomTrackList==nil then
        self.CustomTrackList={}
        self.CustomTrackListFive={}
        self.CustomTrackListThree={}
    end
    self.trackList=trackList
    for i = 1, 12 do
        local temp=self:GetTrackInfoByIdx(i)
        local trackData=RaceTrackData()
        if temp then
            trackData:SetData(nil,nil,temp)
        else
            trackData.miniTrackType=MiniTrackType.SelfCustomTrack
            trackData.customTrackData=CustomTrack_Data()
            trackData:SetId(i)
        end
        if self:CustomTrackDataListContains(trackData.id) then
            self.CustomTrackList[i]=trackData
        else
            table.insert(self.CustomTrackList,trackData)
            if (#self.CustomTrackListThree<6 and not trackData:GetIsEdit())or trackData:GetRaceNumber()==TrackSegmentNumbers.Three then
                table.insert(self.CustomTrackListThree,i)
            else
                table.insert(self.CustomTrackListFive,i)
            end
        end
    end
end
function  RaceTrackDataManager:GetTrackInfoByIdx(idx)
    local result=nil
    for i = 1, #self.trackList do
        if idx==self.trackList[i].seqNo then
            result=self.trackList[i]
            break
        end
    end
    return result
end
function RaceTrackDataManager:CustomTrackDataListContains(id)
    for i = 1, #self.CustomTrackList do
            if self.CustomTrackList[i]:GetIdx()==id then
            return true
        end
    end
    return false
end

---@return  RaceTrackData
function RaceTrackDataManager:GetRaceDataByIndex(index)
    if self.CustomTrackList[index]~=nil then
        local raceTrackData=self.CustomTrackList[index]
        return raceTrackData
    end
end
---@param data RaceTrackData
function RaceTrackDataManager:UpdateTrackDataByIndex(index,data)
    self.CustomTrackList[index]=data
end
---@param data RaceTrackData
function RaceTrackDataManager:GetCustomTrackListByType(type)
    if type==TrackSegmentNumbers.Three then
       return self.CustomTrackListThree
    end
    if type==TrackSegmentNumbers.Five then
       return self.CustomTrackListFive
    end
    return nil
end
---@return RaceTrackData
function RaceTrackDataManager:GetTrackListById(id)
    if self.CustomTrackList ~=nil then
         for i = 1, #self.CustomTrackList do
            if self.CustomTrackList[i].id==id then
                return self.CustomTrackList[i]
            end
         end
    end
    return nil
end
---@return RaceTrackData
function RaceTrackDataManager:DelTrackDataByServerId(id)
    if self.CustomTrackList ~=nil then
         for i = 1, #self.CustomTrackList do
            if self.CustomTrackList[i]:GetServerIdx()==id then
                local data=RaceTrackData()
                data.miniTrackType=MiniTrackType.SelfCustomTrack
                data.customTrackData=CustomTrack_Data()
                data:SetId(i)
                self.CustomTrackList[i]=data
            end
         end
    end
    return nil
end

---@param param  RaceTrackData
function RaceTrackDataManager:SetTrackListById(param)
    if self.CustomTrackList ~=nil then
         for i = 1, #self.CustomTrackList do
            if self.CustomTrackList[i].id==param:GetId() then
                self.CustomTrackList[i]=param
            end
         end
    end
    return nil
end
--{{{----------------------------------自定义赛道提示
local _ShowError=false
function RaceTrackDataManager:OnError(errorType)
    if _ShowError then
        CommonHelper:SelfDefineTrackError(errorType)
    end
end
--}}}
function RaceTrackDataManager:Init(TrackNumbers)
    _ShowError=true
    self.TrackNumbers=TrackNumbers
    self:LoadAllTrackCell(TrackNumbers)
end

---@param trackData RaceTrackData
function RaceTrackDataManager:InitCSharp(trackData)
    self.curTrackData=trackData:GetCustomData()
    self.miniTrackData=self.curTrackData:InitCshrp()
    CSLuaHelper:Get():CustomTrackRegister(self,self.OnError)
    return self.curTrackData
end

function RaceTrackDataManager:GetTrackList() return self.trackDataList end

function RaceTrackDataManager:GetCustomRacetrackDataList()
    local result={}
    for i = 1, #self.CustomTrackList do
       -- if --self.CustomTrackList[i]:GetCanRun() then
            table.insert(result,self.CustomTrackList[i])
        --end
    end
    return result
end

function RaceTrackDataManager:GetSystemRacetrackDataList(trackListModule)
    if trackListModule==TrackListModule.None then
        return self.SystemRaceTrackList
    else
        local result={}
        for i = 1, #self.SystemRaceTrackList do
            if trackListModule==self.SystemRaceTrackList[i].isRaceRoom then
                table.insert(result,self.SystemRaceTrackList[i])
            end
        end
        return result
    end
end
---@return table<number,RaceTrackData>
function RaceTrackDataManager:GetSystemRaceTrackDataByTrackNum(trackNum,trackListModule) local result={}
    for i = 1, #self.SystemRaceTrackList do
        if trackListModule==TrackListModule.None  then
            if self.SystemRaceTrackList[i]:GetRaceNumber()==trackNum then
                table.insert(result,self.SystemRaceTrackList[i])
            end
        else
            if self.SystemRaceTrackList[i]:GetRaceNumber()==trackNum and trackListModule==self.SystemRaceTrackList[i].isRaceRoom then
                table.insert(result,self.SystemRaceTrackList[i])
            end
        end

    end
    return result
end

function RaceTrackDataManager:GetSystemRaceTrackDataByTrackFeature(trackNum,trackListModule,trackfeature)
    local trackList=self:GetSystemRaceTrackDataByTrackNum(trackNum,trackListModule)
    local result={}
    for i = 1, #trackList do
        if trackList[i]:CheckFeature(trackfeature) then
            table.insert(result,trackList[i])
        end
    end
    return result
end
function RaceTrackDataManager:GetCustomRaceTrackDataByTrackNum(trackNum) local result={}
    for i = 1, #self.CustomTrackList do
        if self.CustomTrackList[i]:GetRaceNumber()==trackNum and self.CustomTrackList[i]:GetCanRun() then
            table.insert(result,self.CustomTrackList[i])
        end
    end
    return result
end


function RaceTrackDataManager:ClearData()
    _ShowError=false
    self.miniTrackData=nil
    self.trackDataList=nil
    self.curTrackData=nil
    if self.AllTrackSgDic~=nil then
        for k,v in ipairs(self.AllTrackSgDic) do
            for i,j in ipairs(v) do
                j=nil
            end
            v=nil
        end
    end
    self.AllTrackSgDic=nil
end



