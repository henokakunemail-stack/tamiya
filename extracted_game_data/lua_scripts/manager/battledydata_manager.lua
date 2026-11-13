---@class CarBuffData
CarBuffData = class("CarBuffData")
function CarBuffData:initialize(id,idx,state,value,addType,duration)
    self.Id=id
    self.Idx=idx
    self.State=state
    self.Value=value
    self.AddType=addType
    self.Duration=duration
end


---@class SkillCardData
SkillCardData = class("SkillData")
function SkillCardData:initialize()
    self.icon = ""
    self.cd = -1
    ---@typ number @这个是短的id
    self.skillTypeId = -1
    self.skillId = -1
    self.itemId = -1
    self.skillIndex = -1
    self.name = ""
    self.des = ""
    self.needEnergyCount = 3
end

function SkillCardData:InitData(skillIdx, skillTypeId)
    self.skillIndex = skillIdx
    self.skillTypeId = skillTypeId
    --todo:根据车的skill id 获取它的技能数据
    self.skillId = skillTypeId * 100 + 1

    ---@type skill_config_cell
    local skillInfo = CommonHelper:GetTableDataByID(ConfigNames.skill_config, self.skillId)
    self.name = ClientDataManager:Get():GetTemplateString(skillInfo.name)
    self.cd = skillInfo.cooldown
    self.icon = skillInfo.icon
    self.des = skillInfo.des

    self.needEnergyCount = 3
    self.itemId = 0--槽位
end

function SkillCardData:GetSkillName()
    return self.name
end

function SkillCardData:GetSkillEnergy()
    return self.needEnergyCount
end

function SkillCardData:GetSkillIcon()
    return self.icon
end

function SkillCardData:GetSkillTypeId()
    return self.skillTypeId
end
function SkillCardData:SetCd(cd)
    self.cd = cd
end
function SkillCardData:GetCd()
    return self.cd
end
---@class CarDyDataSkillData
CarDyDataSkillData=class("CarDyDataSkillData")
---@param data Lua_CarInitData
function CarDyDataSkillData:initialize(data)
    self.carId = data.CarID
    local heroData =nil
    self.carConfigId = data.CarCfgId
    if data.CarshellCfg then
        self.shellId = data.CarshellCfg.id
        self.heroData =CommonHelper:GetTableDataByID(ConfigNames.hero_config, data.CarshellCfg.holder)
    end
    self.buffers = data.Buffs
    self.InitShellBean =0
    self.ShellBean = data.ShellBean
    self.ClickCount =0
    self.BuilderId=0
    if self.heroData then
        self.carHolderIconName =self.heroData.icon
    end
end

--------------------------------------------------------------------------------------CarDyData
---@class CarDyData
CarDyData = class("CarDyData")
function CarDyData:initialize()
    self.rankIndex = 0--排名UI的索引，也就是当前它的UI排名条应该在第几位,这可能和最新的有出入，因为有动画
    self.rank = 0
    self.carId = 0
    self.playerId = 0
    self.teamId = 0
    self.playerName = ""
    self.carConfigId = 0
    self.shellId = 0
    self.carHolderIconName = ""--车手的小图标，比如星马烈
    self.playerHeadIcon = ""--角色图标
    self.playerIconFrame = ""--角色图标
    self.playerBgId=-1
    self.cups= { }
    self.background= 0
    self.teamId = 0
    ---@type table<number,number>
    self.skillIndexIdList = {}
    ---@type table<number,SkillCardData>
    self.skillDataDic = {}

    self.carRankList = {}---当前车的排名列表
    self.carLatestRank = 0---当前车的排名列表--对应的排名
    self.isPlayAni = false---是否正在播放排名动画
    self.buffers = {}
    self.ShellBean=0
    self.CurShellBean=0
    self.CarBuildList={}
    self.Index=-1
    self.playerSampleInfo=PlayerSampleInfoData()
end

---@param teamData Lua_TeamInitData
---@param playerData Lua_PlayerInitData
---@param carLocalData Lua_CarInitData[]
function CarDyData:InitData(teamData, playerData, carLocalData,index)
    self.teamId = teamData.TeamID
    self.Index=index
    self.playerId = playerData.PlayerID
    self.playerHeadIcon = playerData.Icon
    self.playerIconFrame = playerData.IconFrame
    ---@type CarDyDataSkillData[]
    self.CarList={}
    for k, v in pairs(carLocalData) do
        local temp=CarDyDataSkillData(v)
        table.insert(self.CarList,temp)
    end
    self.ShowCarInx=1
    self.playerName = playerData.Name
    self.PlayerSeed=math.random(1000,20000)
    self.trackId = playerData.TrackIdx

    self.playerBgId = playerData.PlayerBgId
    self.cups={}
    for _, v in pairs(playerData.Cups) do
        table.insert(self.cups,v)
    end
    self.playerLevel = playerData.PlayerLevel
    self.playerSampleInfo:SetDataByCarDyData(self)
end

---@param skillTypeIds table<number,number>@技能ID  这个是短ID
function CarDyData:InitSkillData(skillIdx, skillTypeIds)
    logError("InitSkillCardData---------------------初始化技能")

    --for i = 0, skillIdx.Length - 1 do
    --    local skillCardData = SkillCardData()
    --    skillCardData:InitData(skillIdx[i], skillTypeIds[i])
    --    self:SetSkillDataByTypeId(skillCardData)
    --    table.insert(self.skillIndexIdList, skillCardData:GetSkillTypeId())
    --end

    skillTypeIds = {
        1030001,
        1030002,
        1030003,
        1030004
    }

    for i = 1, 4 do
        local skillCardData = SkillCardData()
        skillCardData:InitData(i - 1, skillTypeIds[i])
        self:SetSkillDataByTypeId(skillCardData)
        table.insert(self.skillIndexIdList, skillCardData:GetSkillTypeId())
    end
end

function CarDyData:GetSkillDataCount()
    if self.skillIndexIdList ~= nil then
        return #self.skillIndexIdList
    end
    return -1
end

---@param skillCardData SkillCardData
function CarDyData:SetSkillDataByIndex(index, skillCardData)
    self.skillDataDic[self.skillIndexIdList[index]] = skillCardData
end

---@return SkillCardData
function CarDyData:GetSkillDataByIndex(index)
    return self.skillDataDic[self.skillIndexIdList[index]]
end

---@param skillCardData SkillCardData
---初始化技能
function CarDyData:SetSkillDataByTypeId(skillCardData)
    self.skillDataDic[skillCardData:GetSkillTypeId()] = skillCardData
end

function CarDyData:SetSkillCdByIndex(index, cdTime)
    local skillCardData = self:GetSkillDataByIndex(index)
    if skillCardData == nil then
        logError("设置车的技能数据，车辆数据为空")
        return
    end
    skillCardData:SetCd(cdTime)
    self:SetSkillDataByIndex(index, skillCardData)
end

function CarDyData:GetLatestRank()
    return self.carLatestRank
end

function CarDyData:SetCarRankIndex(rankIndex)
    self.rankIndex = rankIndex
end

function CarDyData:GetCarRankIndex()
    return self.rankIndex
end

function CarDyData:SetCarRankListIdx(rankIndex)
    table.insert(self.carRankList, rankIndex)
end

----返回当前最新的排名，如果返回0 则说明当前没有排名变化
function CarDyData:GetLatestRankIdx()
    if #self.carRankList > 0 and not self.isPlayAni then
        local curRankIdx = self.carRankList[#self.carRankList]
        --if #self.carRankList>1 then
        --    print("----在动画播放期间又有排名条的变化-----")
        --end
        self.carLatestRank = self.rank
        self.carRankList = {}
        return curRankIdx
    else
        return 0
    end
end

function CarDyData:SetIsPlayAni(isPlayAni)
    self.isPlayAni = isPlayAni
end
function CarDyData:GetIsPlayAni()
    return self.isPlayAni
end

function CarDyData:SetCarRank(rank)
    self.rank = rank
end
function CarDyData:GetCarRank()
    return self.rank
end
function CarDyData:SwitchShowIdx(id)
    for i = 1, #self.CarList do
        if self.CarList[i].carId==id then
            self.ShowCarInx=i
            break
        end
    end
end
function CarDyData:AddCarBuilder(carBuilder)
    table.insert(self.CarBuildList,carBuilder)
end
function CarDyData:GetCarId()
    return self.CarList[self.ShowCarInx].carId
end
function CarDyData:GetShellId()
    return self.CarList[self.ShowCarInx].shellId
end
function CarDyData:GetHolderIconName()
    return self.CarList[self.ShowCarInx].carHolderIconName
end
function CarDyData:GetBuffers()
    return self.CarList[self.ShowCarInx].buffers
end
function CarDyData:SetCurShellBean(value)
    if self.CarList[self.ShowCarInx].InitShellBean==0 then
        self.CarList[self.ShowCarInx].InitShellBean=value*self.PlayerSeed
    end
    self.CurShellBean = value
end
function CarDyData:SetMaxShellBean(value)
    self.CarList[self.ShowCarInx].ShellBean = value
end
function CarDyData:SetClickCount(value)
    self.CarList[self.ShowCarInx].ClickCount = ((self.CarList[self.ShowCarInx].ClickCount)/self.PlayerSeed+value)*self.PlayerSeed
end
function CarDyData:CheckClickCount()
   return self.CarList[self.ShowCarInx].ClickCount<self.CarList[self.ShowCarInx].InitShellBean
end

function CarDyData:GetCurShellBean()
    return self.CurShellBean
end
function CarDyData:GetMaxShellBean()
    return self.CarList[self.ShowCarInx].ShellBean
end

function CarDyData:GetPlayerID()
    return self.playerId
end

function CarDyData:GetPlayerName()
    return self.playerName
end

function CarDyData:GetPlayerIcon()
    return self.playerHeadIcon
end
function CarDyData:GetIconFrame()
    if CommonHelper:IsNullOrEmpty(self.playerIconFrame) then
        return "player_kuangicon_1.png"
    end
    return self.playerIconFrame
end

function CarDyData:GetSampleInfo()
    return self.playerSampleInfo
end

function CarDyData:GetCarTrackId()
    return self.trackId
end
function CarDyData:GetCarBuildId()
    return self.CarBuildList[1]
end


----------------------------------------------------------------------------------------BattleDynamicDataManager
---@class BattleDyDataManager
BattleDyDataManager = class("BattleDyDataManager")
function BattleDyDataManager:initialize()
    print("-------------------初始化战斗动态数据-------------------")
    ---@type table<number,CarDyData>
    self.carsDataDic = {}
    ---@type table<number,number>
    self.carsIndexIdList = {}
    ---@type CarDyData
    self.selfCarData = nil

    self.chatItemFlag = {}--talk 的每一个item，当前是否有动画的标记.0--代表没有 1--代表有
    self.explainList = {}--解说
    self.isSelfFinished = false--自己是否完成比赛
    ---@type BattleExplainState
    self.explainState = BattleExplainState.Closed--解说是否打开了
end

function BattleDyDataManager:SetIsSelfFinished(isSelfFinished)
    self.isSelfFinished = isSelfFinished
end
function BattleDyDataManager:GetIsSelfFinished()
    return self.isSelfFinished
end

function BattleDyDataManager:OnInit()
    self.carsDataDic = {}
    self.carsIndexIdList = {}
end

function BattleDyDataManager:InitChatItemFlag()
    self.chatItemFlag = {}
    for i = 1, #self.carsIndexIdList do
        table.insert(self.chatItemFlag, 0)
    end
end

function BattleDyDataManager:GetEmptyItemIdx()
    for i = 1, #self.chatItemFlag do
        if self.chatItemFlag[i] == 0 then
            return i
        end
    end
    return nil
end

function BattleDyDataManager:SetChatItemFlag(itemIdx, flag)
    if self.chatItemFlag[itemIdx] then
        self.chatItemFlag[itemIdx] = flag
    end
end

--- 暂时只取第一辆车,---初始化车辆数据
function BattleDyDataManager:InitBattleDyCarData()
    print("---------------------------------初始化战斗时车的动态数据-------------------------------")
    print("---------------------------------battletype-------------------------------", BattleDataManager:Get():GetBattleType())

    self:OnInit()
    ---@type Lua_RoomInitData
    local battleData = BattleDataManager:Get():GetRoomData()
    if battleData == nil or #battleData.TeamList <= 0 then
        return
    end

    for i = 1, #battleData.TeamList do
        for j = 1, #battleData.TeamList[i].PlayerList do

            ---@type Lua_PlayerInitData
            local playerData = battleData.TeamList[i].PlayerList[j]

            ---@type Lua_CarInitData
            local carLocalData = playerData.CarList

            local carDyData = CarDyData()

            carDyData:InitData(battleData.TeamList[i], playerData, carLocalData,i)

            self:SetCarDataById(carDyData)
            table.insert(self.carsIndexIdList, carDyData:GetCarId())

            table.sort(self.carsIndexIdList, function(a, b)
                return self:GetCarDataById(a):GetCarTrackId() < self:GetCarDataById(b):GetCarTrackId()
            end)

            self:InitSelfCarData(carDyData,battleData.DefaultSelectPlayerID)
        end
    end

    self:InitChatItemFlag()
    --if BattleDataManager:Get():GetTrackType() == TrackType.Free then
    self:InitCarSkillData()
    -- end
end

--- 假战斗初始化战斗时车的动态数据
function BattleDyDataManager:InitLocalBattleDyCarData()
    print("---------------------------------初始化战斗时车的动态数据-------------------------------")
    print("---------------------------------battletype-------------------------------", BattleDataManager:Get():GetBattleType())

    self:OnInit()
    ---@type Lua_RoomInitData
    local battleData = BattleDataManager:Get():GetRoomData()
    if battleData == nil or #battleData.TeamList <= 0 then
        return
    end

    local temp = nil
    for i = 1, #battleData.TeamList do
        for j = 1, #battleData.TeamList[i].PlayerList do

            ---@type Lua_PlayerInitData
            local playerData = battleData.TeamList[i].PlayerList[j]

            ---@type Lua_CarInitData
            local carLocalData = playerData.CarList

            local carDyData = CarDyData()

            carDyData:InitData(battleData.TeamList[i], playerData, carLocalData)
            if temp == nil then
                temp = carDyData
            end
            self:SetCarDataById(carDyData)
            table.insert(self.carsIndexIdList, carDyData:GetCarId())

            table.sort(self.carsIndexIdList, function(a, b)
                return self:GetCarDataById(a):GetCarTrackId() < self:GetCarDataById(b):GetCarTrackId()
            end)
        end
    end
    self:InitLocalSelfCarData(temp)
    self:InitChatItemFlag()
    --if BattleDataManager:Get():GetTrackType() == TrackType.Free then
    self:InitCarSkillData()
    -- end
end

function BattleDyDataManager:GetCarCount()
    return #self.carsIndexIdList
end
function BattleDyDataManager:AddCarBuilderByPlayerId(playerId,carBuilderid)
    for k, v in pairs(self.carsDataDic) do
        if v.playerId==playerId then
            v:AddCarBuilder(carBuilderid)
        end
    end
end

---@return CarDyData
function BattleDyDataManager:GetCarDataByIndex(index)
    if self.carsIndexIdList[index] then
        return self:GetCarDataById(self.carsIndexIdList[index])
    end
    return -1
end

---@param carDyData CarDyData
function BattleDyDataManager:SetCarDataById(carDyData)
    self.carsDataDic[carDyData:GetCarId()] = carDyData
end



---@return CarDyData
function BattleDyDataManager:GetCarDataById(carId)
    local carData = self.carsDataDic[carId]
    if carData ~= nil then
        return carData
    end
    logError("GetCarDataById------没有找到该ID的车，carId 是" .. carId)
    return -1
end
function BattleDyDataManager:ResetPlayAni()
    for k, v in pairs(self.carsDataDic) do
        v:SetIsPlayAni(false)
        v:SetCarRankIndex(0)
    end
end

---@param carDyData CarDyData
function BattleDyDataManager:InitSelfCarData(carDyData,DefaultSelectPlayerID)
    if DefaultSelectPlayerID == carDyData.playerId then
        self.selfCarData = carDyData
    end
    --if carDyData.playerId == PlayerDataManager:Get():GetPlayerID() then
    --    self.selfCarData = carDyData
    --    return
    --end
    --if carDyData.playerId == then
    --
    --end
end
function BattleDyDataManager:SwitchSelfCarDataByCarId(idx)
    self.selfCarData:SwitchShowIdx(idx)
end



---@param carDyData CarDyData
function BattleDyDataManager:InitLocalSelfCarData(carDyData)
    self.selfCarData = carDyData
end

---@return CarDyData
function BattleDyDataManager:GetSelfCarData()
    return self.selfCarData
end

function BattleDyDataManager:InitCarSkillData(indexes, skillTypeIds)
    print("InitSkillCardData---------------------初始化技能")
    --self.selfCarData:InitSkillData(indexes, skillTypeIds)
    self:SetCarDataById(self.selfCarData)
end

function BattleDyDataManager:SetCarRankById(carId, rank, rankIndex)
    local carData = self:GetCarDataById(carId)
    if carData ~= -1 then
        carData:SetCarRank(rank)
        carData:SetCarRankListIdx(rankIndex)
        self:SetCarDataById(carData)
    end
end

function BattleDyDataManager:GetCarRankById(carId)
    local carData = self:GetCarDataById(carId)
    if carData ~= -1 then
        return carData:GetCarRank()
    end
end

---@return CarDyData
function BattleDyDataManager:GetCarDataByRank(rank)
    for carId, carDyData in pairs(self.carsDataDic) do
        if carDyData:GetCarRank() == rank then
            return carDyData
        end
    end
    return -1
end

function BattleDyDataManager:Get()
    if self._instance == nil then
        self._instance = BattleDyDataManager()
    end
    return self._instance
end

function BattleDyDataManager:AddExplain(explain)
    table.insert(self.explainList, explain)
end
function BattleDyDataManager:RemoveLastMsg()
    table.remove(self.explainList, 1)
end

function BattleDyDataManager:GetLastExplain()
    if self:GetExplainState() == BattleExplainState.Closed and #self.explainList == 1 then
        self:SetExplainState(BattleExplainState.CanOpen)
    end
    if #self.explainList > 0 then
        return self.explainList[#self.explainList]
    end
    self.explainList = {}
end
---@param explainState BattleExplainState
function BattleDyDataManager:SetExplainState(explainState)
    self.explainState = explainState
end
---@return BattleExplainState
function BattleDyDataManager:GetExplainState()
    return self.explainState
end

----清理战斗车辆数据
function BattleDyDataManager:ClearBattleDyData()
    self.carsDataDic = {}
    self.carsIndexIdList = {}
    ---@type CarDyData
    self.currentCarData = nil
    self.explainList = {}
    self.explainState = BattleExplainState.Closed
    self.isSelfFinished = false
    self.chatItemFlag = {}
    CommonHelper:ReleasePool(UIModuleID.Battle)
    CommonHelper:ReleasePool(UIModuleID.BattleResult)
end

----重新进当前关卡或者进行下一关
function BattleDyDataManager:OpenCurrentOrNextLevel(isNextLevel)
    local curLevelId = BattleDataManager:Get():GetLevelId()
    local levelData = PVEChapterDataManager:Get():GetLevelDataByLevelId(curLevelId)
    local levelId = isNextLevel and levelData.nextlevel or curLevelId
    if levelId == "-1" then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.BattleLevelNotOpen))
        return
    end
    --local idx = TeamManager:Get():TestGetCurStoryCarIDx()
    --BattleSubsystem:Get():SendMsg_BattleBegin(levelId, idx)
    BattleDataManager:Get():SetStateBattleExit()
end

function BattleDyDataManager:UpdateBattleRankByTrackType(rankData)
    local trackType = BattleDataManager:Get():GetTrackType()
    if trackType == TrackType.Free then
        UINotify:Get():SendNotification(UINotifyEvent.BattleNewOutdoorView_UpdateBattleRank, rankData)
    else
        UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_UpdateBattleRank, rankData)
    end
end

function BattleDyDataManager:OnFinishedBattleByTrackType(finishedData)
    local trackType = BattleDataManager:Get():GetTrackType()
    if trackType == TrackType.Free then
        UINotify:Get():SendNotification(UINotifyEvent.BattleNewOutdoorView_OnFinishedBattle, finishedData)
    else
        UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_OnFinishedBattle, finishedData)
    end
end

function BattleDyDataManager:SetProtectBtnState(state)
    self.ProtectBtnState=state
end
function BattleDyDataManager:GetProtectBtnState()
   return self.ProtectBtnState
end






