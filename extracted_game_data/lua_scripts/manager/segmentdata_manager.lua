---@class SegmentDataManager
SegmentDataManager =class("SegmentDataManager")

function SegmentDataManager:Get()
    if self._instance==nil then
        self._instance=SegmentDataManager()
    end
    return self._instance
end
function SegmentDataManager:initialize()
    ---@type table<number,TrackSegment_Data>
    self.curShowList=nil
    self._tracKSgesBag=nil
    CacheClearTrigger:Get():RegisterEvent(self, self.Clear)
end

function SegmentDataManager:Init(TrackNumbers)
    self.TrackNumbers=TrackNumbers
    self:LoadAllTrackCell(TrackNumbers)
end
---@param data SC_UserProp[]
function SegmentDataManager:RecServerData(data)
    self._tracKSgesBag=TrackSegmentBag()
    self._tracKSgesBag:SetData(data)
end
---@param data SC_UserProp
function SegmentDataManager:UpdateTrackSegmentNum(data)
    self._tracKSgesBag:AddNum(data)
end
function SegmentDataManager:GetNumById(id)
   return self._tracKSgesBag:GetItem(id)
end
-- 解析本地所有赛道块数据
function SegmentDataManager:LoadAllTrackCell(TrackNumbers)
    ---@type table<number<number,TrackSegment_Data>>
    self.AllTrackSgDic={}
    self.TrackTypeList={}
    self.CostTrackList={}
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.tracksegement_config)
    ---@type table<number,tracksegement_config_cell>
    local  cfgData=cfg.GetConfigData()
    for k,v in pairs(cfgData) do
        local temp=v
        if temp then
            if self.AllTrackSgDic[temp.difficulty]==nil then
                self.AllTrackSgDic[temp.difficulty]={}
                table.insert(self.TrackTypeList,temp.difficulty)
            end
            if temp.numbers==TrackNumbers and temp.editflag==1 then
                local trackCellData=TrackSegment_Data()
                trackCellData:SetCfgData(temp)
                self.AllTrackSgDic[temp.difficulty][temp.C_ID]=trackCellData
            end
            if temp.freeflag==0 then
                local trackCellData=TrackSegment_Data()
                trackCellData:SetCfgData(temp)
                self.CostTrackList[trackCellData.cfgId]=trackCellData
            end
        else
            print(v.segmentid,"为空")
        end

    end
    table.sort(self.TrackTypeList)
end
function SegmentDataManager:GetTrackTypeList()
    return self.TrackTypeList
end


function SegmentDataManager:UpdateTrackSegmentItemData(miniTrackData,isInit)
    SelfDefineTrack:ConvertMiniTrackData()
    if self.AllTrackSgDic then
        for k,v in pairs(self.AllTrackSgDic)do
            for j,i in pairs(v)  do
                i.needNum=0
            end
        end
        local count=miniTrackData.configIds.Count
        for i = 0, miniTrackData.configIds.Count-1 do
            local  id= miniTrackData.configIds[i].configId
            local  temp=CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config,id)
            if self.AllTrackSgDic[temp.difficulty]  then
                if  self.AllTrackSgDic[temp.difficulty][id] ~=nil then
                    self.AllTrackSgDic[temp.difficulty][id].needNum=   self.AllTrackSgDic[temp.difficulty][id] .needNum+1
                end
            end
        end
        if isInit then
            for k, v in pairs(self.AllTrackSgDic) do
                for m, n in pairs(v) do
                    if self.CostTrackList[m] then
                        self.CostTrackList[m].costInitNum=n.needNum
                    end
                end
            end
        end
        return count
    end
end
function SegmentDataManager:GetCostInitNumById(id)
    if self.CostTrackList and self.CostTrackList[id] then
        return self.CostTrackList[id].costInitNum
    end
    return 0
end


function SegmentDataManager:SetShowDataByType(type)
    if self.AllTrackSgDic and self.AllTrackSgDic[type]~=nil then
        self.curShowList=self.AllTrackSgDic[type]
    else
        self.AllTrackSgDic[type]={}
        self.curShowList=self.AllTrackSgDic[type]
    end
end
function SegmentDataManager:GetSegmentBag()
    return self._tracKSgesBag
end
function SegmentDataManager:GetTrackSegmentDataById(cfgId)
    for k, v in pairs(self.curShowList) do
        if v.cfgId==cfgId then
            return v
        end
    end
    return nil
end

local _ShowError=false
function SegmentDataManager:OnError(errorType)
    if _ShowError then
        CommonHelper:SelfDefineTrackError(errorType)
    end
end

function SegmentDataManager:ClearData()


    if self.AllTrackSgDic~=nil then
        for k,v in ipairs(self.AllTrackSgDic) do
            for i,j in ipairs(v) do
                j=nil
            end
            v=nil
        end
    end
    self.AllTrackSgDic= {}
end
function SegmentDataManager:Clear()
    self._tracKSgesBag:ClearData()
    self:ClearData()
end






