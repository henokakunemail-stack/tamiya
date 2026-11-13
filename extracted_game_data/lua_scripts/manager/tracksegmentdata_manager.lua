---@class TrackSegmentDataManager
TrackSegmentDataManager =class("TrackSegmentDataManager")
---@type SC_Tuple2
local _traceSges=nil
function TrackSegmentDataManager:Get()
    if self._instance==nil then
        self._instance=TrackSegmentDataManager()
    end
    return self._instance
end
function TrackSegmentDataManager:initialize()
    ---@type table<number,TrackSegment_Data>
    self.curShowList=nil
    ---@type table<number,RaceTrackData>
    self.RacetrackDataList=nil
end
local _ShowError=false
function TrackSegmentDataManager:Init(TrackNumbers)
  _ShowError=true
  self.TrackNumbers=TrackNumbers
  self:LoadAllTrackCell(TrackNumbers)
end
function TrackSegmentDataManager:RecServerData(data)
    _traceSges=data.traceSegs
    self:ParseTrackData(data.trackInfo)
    self:ParseToRaceTrackData(data.trackInfo)
end

function TrackSegmentDataManager:ParseToRaceTrackData(trackInfo)
    if self.RacetrackDataList==nil then
        self.RacetrackDataList={}
    end
    for i = 1, #trackInfo do
        local trackData=RaceTrackData()
        trackData:SetData(nil,nil,trackInfo[i])
        if self:RaceTrackDataListContains(trackData.id) then
            self.RacetrackDataList[i]=trackData
        else
            table.insert(self.RacetrackDataList,trackData)
        end
    end
end

function TrackSegmentDataManager:RaceTrackDataListContains(id)
    for i = 1, #self.RacetrackDataList do
        if self.RacetrackDataList[i]:GetId()==id then
            return true
        end
    end
    return false
end

-- 解析本地所有赛道块数据
function TrackSegmentDataManager:LoadAllTrackCell(TrackNumbers)
        ---@type table<number<number,TrackSegment_Data>>
        self.AllTrackSgDic={}
        local  cfgData=ClientDataManager:Get():GetDataTable(ConfigNames.tracksegement_config).GetConfigData()
        for k,v in pairs(cfgData) do
            if self.AllTrackSgDic[v.type]==nil then
                self.AllTrackSgDic[v.type]={}
            end
            if v.numbers==TrackNumbers then
                local trackCellData=TrackSegment_Data()
                trackCellData:SetCfgData(v)
                self.AllTrackSgDic[v.type][v.id]=trackCellData
            end
        end
        for i = 1, #_traceSges do
            local cellId=_traceSges.num1
            local cellNum=_traceSges.num2
            local cellData=CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config,cellId)
            self.AllTrackSgDic[cellData.type][cellId]:SetServerData(cellNum)
        end
end
function TrackSegmentDataManager:ParseTrackData(trackInfoList)
    if self.trackDataList==nil then
        self.trackDataList={}
    end
    for i = 1, #trackInfoList do
        local trackData=CustomTrack_Data()
        trackData:SetData(trackInfoList[i])
        if self:TrackDataListContains(trackData.id) then
            self.trackDataList[i]=trackData
        else
            table.insert(self.trackDataList,trackData)
        end
    end
end
function TrackSegmentDataManager:TrackDataListContains(id)
    for i = 1, #self.trackDataList do
        if self.trackDataList[i].id==id then
            return true
        end
    end
    return false
end
---@param trackData CustomTrack_Data
function TrackSegmentDataManager:InitCSharp(trackData)
        self.curTrackData=trackData
        self.miniTrackData=self.curTrackData:InitCSharp()
       -- print(debug.traceback())
       -- SelfDefineTrack:OnInit(self.miniTrackData)
        CSLuaHelper:Get():CustomTrackRegister(self,self.OnError)
        if self.curTrackData.trackSgList~=nil then
            for i = 1, #self.curTrackData.trackSgList do
               local id=self.curTrackData.trackSgList[i]
                local cellData=CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config,id)
                self.AllTrackSgDic[cellData.type][id].needNum=self.AllTrackSgDic[cellData.type][id].needNum+1
            end
        end
        return self.curTrackData
end
function TrackSegmentDataManager:OnError(errorType)
    if _ShowError then
        if errorType==CustomTrackHandleType.Out then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackOutArea))
        elseif errorType==CustomTrackHandleType.OverLap then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackOverlap))
        elseif errorType==CustomTrackHandleType.OverFloor then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackOverFloor))
        elseif errorType==CustomTrackHandleType.OverHeight then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackOverHeight))
        elseif errorType==CustomTrackHandleType.TrackClosed then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackClosed))
        elseif errorType==CustomTrackHandleType.TrackNoChanger then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNoChanger))
        end
    end
end

function TrackSegmentDataManager:UpdateTrackSegmentItemData()
    SelfDefineTrack:ConvertMiniTrackData()
    for k,v in pairs(self.curShowList)do
        v.needNum=0
    end
    for i = 0, self.miniTrackData.configIds.Count-1 do
        local  id=self.miniTrackData.configIds[i].configId
        if self.curShowList[id]~=nil then
            self.curShowList[id].needNum=  self.curShowList[id].needNum+1
        end
    end
end
---@return  CustomTrack_Data
function TrackSegmentDataManager:GetTrackDataByIndex(index)
    if self.trackDataList[index]~=nil then
        self.curTrackData=self.trackDataList[index]
        return self.curTrackData
    end
end
---@return  RaceTrackData
function TrackSegmentDataManager:GetRaceDataByIndex(index)
    if self.RacetrackDataList[index]~=nil then
        local raceTrackData=self.RacetrackDataList[index]
        return raceTrackData
    end
end
---@param data CustomTrack_Data
function TrackSegmentDataManager:UpdateTrackDataByIndex(index,data)
    self.trackDataList[index]=data
end





function TrackSegmentDataManager:SetShowDataByType(type)
    if self.AllTrackSgDic[type]~=nil then
        self.curShowList=self.AllTrackSgDic[type]
    end
end
function TrackSegmentDataManager:ClearData()
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
function TrackSegmentDataManager:GetTrackListCanRun()

end
---@return CustomTrack_Data
function TrackSegmentDataManager:GetTrackListById(id)
    for i = 1, #self.trackDataList do
        if self.trackDataList[i].id==id then
            return self.trackDataList[i]
        end
    end
    return nil
end

function TrackSegmentDataManager:GetTrackList() return self.trackDataList end
function TrackSegmentDataManager:GetRacetrackDataList() return self.RacetrackDataList end

--function TrackSegmentDataManage


