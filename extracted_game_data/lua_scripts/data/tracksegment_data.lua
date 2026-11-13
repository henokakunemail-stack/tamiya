---@class TrackSegment_Data
TrackSegment_Data = class("TrackSegment_Data")
function TrackSegment_Data:initialize()
    self.cfgId=-1
    self.needNum=0
    self.curNum=0
    self.isNew=false
    self.isFree=false
    self.type=nil
    self.cfg=nil
    self.costInitNum=0
    --self.
end
function TrackSegment_Data:Copy()
    local data=TrackSegment_Data()
    data.cfgId=self.cfgId
    data.needNum=self.needNum
    data.curNum=self.curNum
    data.isNew=self.isNew
    data.type=self.type
    data.cfg=self.cfg
    return data
end
---@param cfgData tracksegement_config_cell
function TrackSegment_Data:SetCfgData(cfgData)
   self.cfg=cfgData
   self.cfgId=cfgData.C_ID
   self.type=cfgData.type
   self.isFree=self.cfg.freeflag==1
   self.costInitNum=0
end
function TrackSegment_Data:SetServerData(curNum)
   self.curNum=curNum
end
function TrackSegment_Data:GetCurName()
    return self.curNum
end
---@param data SC_Tuple2
function TrackSegment_Data:SetShopData(data)
    self.idx=data.num1
    self.curNum=data.num2
end
function TrackSegment_Data:GetCfgId()
    return self.cfgId
end
function TrackSegment_Data:GetNeedNum()
    return self.needNum
end
function TrackSegment_Data:Update()

end

function TrackSegment_Data:AddNeedNum()
    self.needNum=self.needNum+1
end
function TrackSegment_Data:SetNeedNum(num)
    self.needNum=num
end
----------------------------------------------------------------------------------------------------
---@class TrackSegmentBag
TrackSegmentBag=class("TrackSegmentBag")
function TrackSegmentBag:initialize()
    self.segList={}
end

---@param  param SC_UserProp[]
function TrackSegmentBag:SetData(param)
    self.segList={}
    for i = 1, #param do
        self:UpdateItem(param[i])
    end
end
---@param param SC_UserProp
function TrackSegmentBag:UpdateItem(param)
    if param.propid<SegmentMaxId then
        print("赛道块id",param.propid,param.propnum)
       self.segList[param.propid]=param.propnum
    end
end
---@param param SC_UserProp
function TrackSegmentBag:AddNum(param)
    if param.propid<SegmentMaxId then
        self.segList[param.propid]=param.propnum
    end
end
---@param id number
function TrackSegmentBag:GetItem(id)
    if self.segList[id] ~=nil then
        return self.segList[id]
    end
    return 0
end

function TrackSegmentBag:ClearData()
   self.segList=nil
end

----------------------------------------------------------------------------------------------------

--TrackSegment_Data
---@class CustomTrack_Data
CustomTrack_Data=class("CustomTrack_Data")
function CustomTrack_Data:initialize()
    self.id=0
    self.startOffset=nil
    self.Angle=0
    self.cunRun=false
    self.name=nil
    self.trackSgList=nil
    self.isEdit=false
    self.TrackNumbers=0
    self.CreateTime=0
    self.TestRunTime=0
    self.ErrorType=0
end
---@param data SC_UserTrack
function CustomTrack_Data:SetData(data)
    if data==nil then return end
    self.id=data.seqNo
    self.CreateTime=data.createtime
    self.TestRunTime=data.tradepay
    self.ServerTrackId=data.trackid
    self.cunRun=data.canrun==MiniTrackClosedType.Closed
    self.ErrorType=data.canrun
    if data.myTrackItems then
      self:SetTrackData(data)
    else
        self.isEdit=false
    end
end
---@param data SC_UserTrack
function CustomTrack_Data:SetTrackData(data)
    if data ==nil then return end
    self.Angle=data.angle/1000
    self.name=data.trackname
    self.TrackNumbers=data.tracknum
    self.Score=0
    if data~=nil then
        self.startOffset={
            s1=data.offsetx/1000,
            s2=data.offsety/1000,
            s3=data.offsetz/1000
        }
    end
    if data.myTrackItems then
        self.trackSgList=data.myTrackItems
        for i = 1,#self.trackSgList  do
            ---@type tracksegement_config_cell
            local cfg=CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config,self.trackSgList[i])
            self.Score=self.Score+cfg.difficulty
        end
       -- local id=self.trackSgList[1]
        --if id ~=nil then
        --    local cfg=CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config,id)
        --    if cfg~=nil then
        --        if cfg.numbers==TrackSegmentNumbers.Three then
        --
        --        elseif cfg.numbers==TrackSegmentNumbers.Five then
        --            self.TrackNumbers=TrackSegmentNumbers.Five
        --        end
        --    end
        --end
        if #data.myTrackItems>=1 then
            self.isEdit=true
        else
            self.isEdit=false
        end
    else
        self.isEdit=false
    end
end
function CustomTrack_Data:GetTrackType()
   return self.TrackNumbers
end
function CustomTrack_Data:GetTrackLength()
   return 0
end
function CustomTrack_Data:GetTrackScore()
   return self.Score
end
function CustomTrack_Data:GetCreateTime()
   return self.CreateTime
end
function CustomTrack_Data:GetTestRunTime()
   return self.TestRunTime
end
---@param data CustomTrack_Data

function CustomTrack_Data:ConvertToMiniTrackData()
    local miniTrackData=nil
    if self==nil then
        return
    end
    if self.isEdit~=nil then
        if self.isEdit==false then
            miniTrackData=CS.Horizon.Game.LogicLayer.MiniTrackData()
            miniTrackData.isCustom=true
            miniTrackData.miniTrackLineType=self.TrackNumbers
        else
            miniTrackData=CS.Horizon.Game.LogicLayer.MiniTrackData()
            miniTrackData.miniTrackLineType=self.TrackNumbers
            miniTrackData.isCustom=true
            for i = 1, #self.trackSgList do
                local temp=CS.Horizon.Game.LogicLayer.MiniSegmentData()
                temp.configId=self.trackSgList[i]
                miniTrackData:AddConfigData(temp)
            end
            miniTrackData.startAngle =self.Angle
            miniTrackData:SetStartOffset(self.startOffset.s1,self.startOffset.s2,self.startOffset.s3)
        end
    else
        miniTrackData=CS.Horizon.Game.LogicLayer.MiniTrackData()
        miniTrackData.miniTrackLineType=self.TrackNumbers
        miniTrackData.isCustom=true
    end
    return miniTrackData
end

function CustomTrack_Data:ConvertRaceTrackData()
    local data=RaceTrackData()
    data.miniTrackType=MiniTrackType.SelfCustomTrack
    data.id=self.idx
    data.canRun=self.canRun
    data.customTrackData=self
    return data
end
function CustomTrack_Data:SetId(id)
    self.id=id
end
function CustomTrack_Data:SetName(name)
    self.name=name
end
function CustomTrack_Data:GetIsCanRun()
    return self.cunRun
end
function CustomTrack_Data:GetErrorType()
    return self.ErrorType
end
function CustomTrack_Data:InitCSharp()
    self.miniTrackData=self:ConvertToMiniTrackData()
    SelfDefineTrack:OnInit(self.miniTrackData)
    SelfDefineTrack:SetBound(CustomTrack_BoundMinX,CustomTrack_BoundMinZ,CustomTrack_BoundMaxX,CustomTrack_BoundMaxZ)
    return self.miniTrackData
end

function CustomTrack_Data:InitCSharpOnPreview()
    self.miniTrackData=self:ConvertToMiniTrackData()
    SelfDefineTrack:OnPreviewInit(self.miniTrackData)
    return self.miniTrackData
end
function CustomTrack_Data:ShowError(errorType)
    CommonHelper:SelfDefineTrackError(errorType)
end

function CustomTrack_Data:ConvertTrackInfo(errorType)
    local data={
        idx=self.ServerTrackId==nil and self.id or self.ServerTrackId,
        canRun=SelfDefineTrack:IsClose(),
        number=self.TrackNumbers,
        trackInfo={
            data={},
            angle= self.miniTrackData.startAngle,
            bias={
                s1=CommonHelper:GetTempStr_Default(TemplateStringID.IntString,self.miniTrackData:GetStartOffsetX()),
                s2=CommonHelper:GetTempStr_Default(TemplateStringID.IntString,self.miniTrackData:GetStartOffsetY()),
                s3=CommonHelper:GetTempStr_Default(TemplateStringID.IntString,self.miniTrackData:GetStartOffsetZ()),
            },
            name=self.name
        }
    }
    SelfDefineTrack:ConvertMiniTrackData()
    if  nil~=self.miniTrackData.configIds then
        for i = 0, self.miniTrackData.configIds.Count-1 do
            table.insert(data.trackInfo.data,self.miniTrackData.configIds[i].configId)
        end
    else
    end
    return data
end

function CustomTrack_Data:ConvertToCustomTrack_Data()
        self.cunRun=SelfDefineTrack:IsClose()==0 and true or false
        self.startOffset={
            s1=CommonHelper:GetTempStr_Default(TemplateStringID.IntString,self.miniTrackData:GetStartOffsetX()),
            s2=CommonHelper:GetTempStr_Default(TemplateStringID.IntString,self.miniTrackData:GetStartOffsetY()),
            s3=CommonHelper:GetTempStr_Default(TemplateStringID.IntString,self.miniTrackData:GetStartOffsetZ()),
            }
        self.Angle=self.miniTrackData.startAngle
        SelfDefineTrack:ConvertMiniTrackData()
    self.trackSgList={}
    if  nil~=self.miniTrackData.configIds then
        for i = 0, self.miniTrackData.configIds.Count-1 do
            table.insert(self.trackSgList,self.miniTrackData.configIds[i].configId)
        end
    else
    end
    return data
end
----------------------------------------------------------------------------------------------
---@class RaceTrackData
RaceTrackData=class("RaceTrackData")

function RaceTrackData:initialize()
    self.id=-1
    self.name=""
    self.icon=""
    self.type=""
    self.miniTrackType=0
    self.numbers=0
    self.round=""
    self.configName=""
    self.resName=""
    self.scope=""
    self.start_camera=""
    self.end_camera=""
    self.length=""
    self.isfield=false
    self.customTrackData=nil
    self.isRaceRoom=-1
    self.FillType=""
    self.TrackOrgId=""
    self.cameraDefaultPosition=nil
    self.cameraDefaultRotation=nil
    self.cameraDefaultLength=70
end
---@param trackid number
---@param param SC_UserTrack
---@param trackindex number
---@param trackInfo SC_UserTrack
function RaceTrackData:SetData(trackid,trackInfo,param,trackindex)
    if param~=nil or trackInfo ~=nil then
        self:SetSelfDefineData(param,trackInfo)
    elseif  trackid~=nil and trackid>-1 then
        self:SetSystemRaceData(trackid)
    elseif trackindex~=nil and trackindex >-1 then
        return RaceTrackDataManager:Get():GetSystemRaceDataById(trackindex)
    end
end
---@param id
function RaceTrackData:SetSystemRaceData(id)
    local  id,orgId,FillType=CommonHelper:ParseTrackId(id)
    ---@type dicttracktrack_config_cell
    local param=CommonHelper:GetTableDataByID(ConfigNames.racetrack_config,id)
    if param==nil then
        return
    end
    self.TrackOrgId=orgId
    self.FillType=FillType
    self.id=param.C_ID
    self.name=ClientDataManager:Get():GetTemplateString(param.name)
    self.icon=param.icon
    self.type=ClientDataManager:Get():GetTemplateString(param.type)
    if param.resname=="-1" then
        self.miniTrackType=MiniTrackType.LocalCustomTrack
    else
        self.miniTrackType=MiniTrackType.System
    end
    self.numbers=tonumber(param.numbers)
    self.round=param.round
    self.configName=param.configName
    self.resName=param.resname
    self.scope=param.scope
    self.start_camera=param.start_camera
    self.end_camera=param.end_camera
    self.length=param.length
    if param.cameraDefaultPosition~="0" then
        local pos= stringSplitToNumber(param.cameraDefaultPosition,",")
        self.cameraDefaultPosition=Vector3(pos[1],pos[2],pos[3])
    end
    if param.cameraDefaultRotation~="0" then
        local pos= stringSplitToNumber(param.cameraDefaultRotation,",")
        self.cameraDefaultRotation=Vector3(pos[1],pos[2],pos[3])
    end
    if param.cameraDefaultLength~=0 then
        self.cameraDefaultLength=param.cameraDefaultLength
    end
    self.isfield=param.isfield==1
    self.feature=stringSplitToNumber(param.logo,',')
    if param.roomscope==1 then
       self.isRaceRoom=TrackListModule.RaceRoom
    end

end

---@param param  SC_UserTrack
function RaceTrackData:SetSelfDefineData(param,trackInfo)

    self.customTrackData=CustomTrack_Data()
    if param~=nil then
        if param.seqNo~=nil then
            self.id=param.seqNo
        end
        if param.canrun~=nil then
            self.canRun=param.canrun
        end
        self.customTrackData:SetData(param)
        self.miniTrackType=MiniTrackType.SelfCustomTrack
    else
        self.customTrackData:SetTrackData(trackInfo)
        self.miniTrackType=MiniTrackType.OtherCustomTrack
    end
end
function RaceTrackData:GetCanRun()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then return true
    elseif self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then return self.customTrackData:GetIsCanRun() end
    return false
end
function RaceTrackData:GetErrorType()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then return true
    elseif self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then return self.customTrackData:GetErrorType() end
    return false
end
function RaceTrackData:GetIsEdit()
    if self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then return self.customTrackData.isEdit end
    return true
end
function RaceTrackData:GetName()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then return self.name
    elseif self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then return self.customTrackData.name end
    return ""
end
function RaceTrackData:GetLength()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then return string.format("%0.2f",self.length)
    elseif self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then return self.customTrackData:GetTrackLength() end
    return ""
end
function RaceTrackData:GetScore()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then return 0
    elseif self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then return self.customTrackData:GetTrackScore() end
    return ""
end
function RaceTrackData:GetCreateTime()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then return 0
    elseif self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then return self.customTrackData:GetCreateTime() end
    return ""
end
function RaceTrackData:GetTestRunTime()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then return 0
    elseif self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then return self.customTrackData:GetTestRunTime() end
    return ""
end
function RaceTrackData:GetRaceNumber()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then return self.round
    elseif self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then return self.customTrackData:GetTrackType() end
end
function RaceTrackData:GetRaceType()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then return self.type
    elseif self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then return self.type end
end
function RaceTrackData:GetMiniTrackType()
    return self.miniTrackType
end

function RaceTrackData:GetId()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then
        return self.id
    end
    if self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then
        return self.id
    end
end
function RaceTrackData:GetOrgId()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then
        return self.TrackOrgId
    end
    if self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then
        return self.id
    end
end
function RaceTrackData:GetFillType()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then
        return self.FillType
    end
    if self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then
        return ""
    end
end

function RaceTrackData:GetIdx()
    if self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then
        return self.id
    end
    return -1
end
function RaceTrackData:GetServerIdx()
    if self.miniTrackType==MiniTrackType.SelfCustomTrack or self.miniTrackType==MiniTrackType.OtherCustomTrack then
        return self.customTrackData.ServerTrackId
    end
    return -1
end
function RaceTrackData:ConvertToMiniTrackData()
    if self.customTrackData~=nil then
        return self.customTrackData:ConvertToMiniTrackData()
    end
end

function RaceTrackData:GetConfigName()
    return self.configName
end

function RaceTrackData:GetCustomData()
    return self.customTrackData
end
function RaceTrackData:SetRaceTrackNumber(number)
    if self.customTrackData~=nil then
        self.customTrackData.TrackNumbers=number
    end
end
function RaceTrackData:SetName(name)
    if self.customTrackData~=nil then
        self.customTrackData.name=name
    end
end
function RaceTrackData:SetId(id)
    self.id=id
    if self.customTrackData~=nil then
        self.customTrackData:SetId(id)
    end
end
function RaceTrackData:GetIsField()
   return  self.isfield
end
function RaceTrackData:GetFeature()
    if self.miniTrackType==MiniTrackType.System or self.miniTrackType==MiniTrackType.LocalCustomTrack then
        return self.feature
    end
    return "-1"
end

function RaceTrackData:GetRaceNumName()
    if self:GetRaceNumber()==TrackSegmentNumbers.Three then
        return  CommonHelper:GetTempStr_Default(TemplateStringID.TrackThree)
    end
    if self:GetRaceNumber()==TrackSegmentNumbers.Five then
        return CommonHelper:GetTempStr_Default(TemplateStringID.TrackFive)
    end
end

function RaceTrackData:GetIsRaceRoom()
    return self.isRaceRoom
end

function RaceTrackData:CheckFeature(trackFeature)
    local result=false
    for i = 1, #trackFeature do
        if  self:CheckFeatureSingleFeature(trackFeature[i]) then
            result=true
            break
        end
    end
    return result
end

function RaceTrackData:CheckFeatureSingleFeature(num)
    for i = 1, #self.feature do
        if num==self.feature[i] then
            return true
        end
    end
    return false
end
--------------------------------------------------------------------------

