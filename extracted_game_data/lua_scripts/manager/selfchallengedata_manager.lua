---@class SelfChallengeDataManager
SelfChallengeDataManager = class("SelfChallengeDataManager")

function SelfChallengeDataManager:initialize()

    ---@type table<number,SelfChallengeData>
   self.ticketsList={}

    self.OtherGameList={}
    self.SelfGameList={}

    self:LoadConfig()

    self.ChapterData=nil
    -----------------------
    self.SelectId=nil
    self._SelectType=nil
    self._SelectDays=nil
    self._SelectPassNum=nil
    self._SelectDifficulty=nil
    self._Name=nil
    self._SelectScenes={}
    self._SelectTracks={}
    self._SelectNpcs={}
    self._DropRewards={}
    self._FinishRewards={}

end

function SelfChallengeDataManager:Get()
    if self._instance == nil then
        self._instance = SelfChallengeDataManager()
    end
    return self._instance
end

---@param msg SC_SelfChallengeCreateInfo
function  SelfChallengeDataManager:UpDataSelfChallenge(msg)
   local data=SelfChallengeData()
    data:SetSelfData(msg)
    self.SelectId=nil
    self._SelectType=nil
    self._SelectDays=nil
    self._SelectPassNum=nil
    self._SelectDifficulty=nil
    self._Name=nil
    self._SelectScenes={}
    self._SelectTracks={}
    self._SelectNpcs={}
    self._DropRewards={}
    self._FinishRewards={}
end
function SelfChallengeDataManager:CreateDone()
    SelfChallengeSubsystem:Get():SendGetAllCreateSelfChallenge(2)
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CreateSuccess))
end
function SelfChallengeDataManager:UpdateSelfGameList()
   self:CreateDone()
   self:Clear()
end
function SelfChallengeDataManager:Clear()
    self.SelectId=nil
    self._SelectType=nil
    self._SelectDays=nil
    self._SelectPassNum=nil
    self._SelectDifficulty=nil
    self._Name=nil
    self._SelectScenes={}
    self._SelectTracks={}
    self._SelectNpcs={}
    self._DropRewards={}
    self._FinishRewards={}
end
---@param msg SC_GetAllSelfChallengeInfoRes
function SelfChallengeDataManager:ParseSelfChallenge(msg)
    self.SelfGameList={}
    local data=msg.infos
    for i, v in pairs(data) do
       local data=SelfChallengeData()
       data:SetSelfData(v)
        table.insert(self.SelfGameList,data)
    end
end
---@param msg SC_GetAllSelfChallengeInfoRes
function SelfChallengeDataManager:ParseOtherSelfChallenge(msg)
    self.OtherGameList={}
    local data=msg.infos
    for i, v in pairs(data) do
        local data=SelfChallengeData()
        data:SetMiniData(v)
        table.insert(self.OtherGameList,data)
    end
end
function SelfChallengeDataManager:LoadConfig()

    ---@type
   local data=ClientDataManager:Get():GetDataTable(ConfigNames.selfchallenge_config)

    local tableData=data.GetConfigData()
    for i, v in pairs(tableData) do
         local temp=SelfChallengeData()
         temp:SetData(v)
         table.insert(self.ticketsList,temp)
    end

end

---@param msg SC_SelfChallengeInfo
function SelfChallengeDataManager:SetChapterData(msg)
    local data=ChapterData()
    data:SetDataSelfChallenge(msg)
    data:SetProcess(msg.miniInfo.curLevel)
    data:SetAllBoxState(msg.finishRewardStates)
    self.ChapterData=data
end

---@return ChapterData
function SelfChallengeDataManager:GetChapterData()
    return self.ChapterData
end
function SelfChallengeDataManager:SelectFilter()


    --
    --for i, v in pairs(heroData.GetConfigData()) do
    --
    --    if  self.npcGroup[v.trackTeam]==nil then
    --
    --           self.npcGroup[v.trackTeam]={}
    --
    --    end
    --
    --
    --    table.insert(self.npcGroup[v.trackTeam],v)
    --
    --    self.trackgroup[v.tracktype][v.difficulty]=v.trackTeam
    --
    --end

end

---@return table<number,SelfChallengeData>
function SelfChallengeDataManager:GetTicketsList()

    return self.ticketsList

end

---@return SelfChallengeData
function SelfChallengeDataManager:GetSelfChallengeData(idx)
    if self.ticketsList ~= nil then
        return self.ticketsList[idx]
    end
end

function SelfChallengeDataManager:GetTrackGroup()

end

function SelfChallengeDataManager:CheckSelectDays(lastDays)
   local result = false
    for i, v in pairs(lastDays) do
        if self._SelectDays==v then
            result=true
            break
        end
    end
    return result
end

function SelfChallengeDataManager:CheckSelectPassNum(barrierNums)
    local result = false
    for i, v in pairs(barrierNums) do
        if self._SelectPassNum==v then
            result=true
            break
        end
    end
    return result
end

function SelfChallengeDataManager:CheckSelectType()
    print(CommonHelper:GetTrackTypeById(SelfChallengeDataManager:Get()._SelectType),self._SelectType)
    if self._SelectType==SelfChallengeLVType.Ramp then
        return true
    elseif self._SelectType==SelfChallengeLVType.Speed then
        return true
    elseif self._SelectType==SelfChallengeLVType.Curve then
        return true
    elseif self._SelectType==SelfChallengeLVType.Cross then
        return true
    else
        return false
    end
end
function SelfChallengeDataManager:CheckSelectDifficulty()
    return self._SelectDifficulty~=nil and self._SelectDifficulty>=1 and self._SelectDifficulty<=4
end

function SelfChallengeDataManager:CheckSelectScene(lvs)
    local result = true
    for i, v in pairs(lvs) do
        if self._SelectScenes[v]==nil then
            result =false
            break
        end
    end
    return result
end

function SelfChallengeDataManager:CheckSelectTrack(lvs)
    local result = true
    for i, v in pairs(lvs) do
        if self._SelectTracks[v]==nil then
            result =false
            break
        end
    end
    return result
end

function SelfChallengeDataManager:CheckSelectNpcs(lvs)
    local result = true
    for i, v in pairs(lvs) do
        if self._SelectTracks[v]~=nil then
            local trackid=self._SelectTracks[v]
            local trackData=CommonHelper:GetRacetrackData(trackid)
            if trackData.numbers==3 then
                if self._SelectNpcs[v][1]==nil or self._SelectNpcs[v][2]==nil then
                    result=false
                    break
                end
            elseif trackData.numbers==5 then
                if self._SelectNpcs[v][1]==nil or self._SelectNpcs[v][2]==nil or self._SelectNpcs[v][3]==nil or self._SelectNpcs[v][4]==nil then
                    result=false
                    break
                end
                break
            end
        else
            result=false
            break
        end
    end
    return result
end

function SelfChallengeDataManager:CheckSelectDropReward()
    local result =false
    if self._DropRewards[1]~=nil or self._DropRewards[2]~=nil or self._DropRewards[3]~=nil then
        result =true
    end
    return result
end

function SelfChallengeDataManager:CheckSelectFinishReward(lvs)
    local result = true
    for i, v in pairs(lvs) do
        local temp=self._FinishRewards[v]
        print(temp[1],temp[2],temp[3])
    end
    for i, v in pairs(lvs) do
        local temp=self._FinishRewards[v]
        if temp~=nil then
            if temp[1]==nil or temp[2]==nil or temp[3]==nil then
                result=false
                break
            end
        else
            result=false
            break
        end
    end
    return result
end

function SelfChallengeDataManager:CheckChallengeName()
    if self._Name==nil or self._Name=="" then
        return false
    end
    return true
end

function SelfChallengeDataManager:CommitParam()
    local data=self:GetSelfChallengeData(self.SelectId)
    local levelInfos={}
    for k, v in pairs(data.needSetLv) do
        local levelInfo={
            trackId=self._SelectTracks[v],
            sceneId=self._SelectScenes[v],
            npcIds=self._SelectNpcs[v],
        }
        table.insert(levelInfos,levelInfo)
    end
    local finishRewards={}
    for k, v in pairs(data.needSetLv) do
        local finishReward={
           num1=self._FinishRewards[v][1],
           num2=self._FinishRewards[v][2],
           num3=self._FinishRewards[v][3],
        }
        table.insert(finishRewards,finishReward)
    end
    print(self._SelectPassNum,"self._SelectPassNum")
     local data={
         ticketId=data.articleId,
         name=self._Name,
         lastDay=self._SelectDays,
         trackType=self._SelectType,
         difficulty=self._SelectDifficulty,
         lvNum=self._SelectPassNum,
         dropRewards=self._DropRewards,
         finishRewards=finishRewards,
         levelInfos=levelInfos
     }
     SelfChallengeSubsystem:Get():SendCreateSelfChallenge(data)
    -- CommonHelper:PlayScreenEffectWaiting(true)
end

---@param data SC_CommonRaceInfo
function SelfChallengeDataManager:RecBattleData(data)

    BattleDataManager:Get():SetRoomData(data, RaceModel.SelfChallenge)
    --SceneManager:Get():UnloadScene(MainCityRes)
    --local trackData=RaceTrackData()
    --trackData:SetData(data.trackId)
    --local scenename = BattleDataManager:Get():GetSceneName()
    --SceneManager:Get():LoadingSelfChallengeScene(scenename, trackData)

    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.SelfChallenge)
end

---@return SelfChallengeData
function SelfChallengeDataManager:GetSelfChallengeDataByTicket(tickets)
    for i, v in pairs(self.ticketsList) do
        if tickets==v.tickets then
               return v
        end
    end
    return nil
end
function SelfChallengeDataManager:CheckNpcIsSelected(curLv,id)
    if self._SelectNpcs[curLv]~=nil then
       -- LuaLogHelper.LogTable("dasdasd",self._SelectNpcs[track])

        for i, v in pairs(self._SelectNpcs[curLv]) do
           -- print(id,"adsdssssssss",curLv,v,v==id)
            if v==id then
                return true
            end
        end
    end
    return false
end
---@return table<number,SelfChallengeData>
function SelfChallengeDataManager:GetSelfGameData() return self.SelfGameList end
---@return table<number,SelfChallengeData>
function SelfChallengeDataManager:GetOtherGameData() return self.OtherGameList end

function SelfChallengeDataManager:SetCurSelectCarData(CarData)
    self.CurSelectCarData=CarData
end
function SelfChallengeDataManager:GetCurSelectCarData()
    return  self.CurSelectCarData
end


