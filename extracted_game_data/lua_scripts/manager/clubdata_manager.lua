---@class ClubDataManager
ClubDataManager = class("ClubDataManager")

---@return ClubDataManager
function ClubDataManager:Get()
    if self._instance == nil then
        self._instance = ClubDataManager()
    end
    return self._instance
end

function ClubDataManager:initialize()
    ---@type table<number,ClubData>
    self.ClubDataDic = {}
    self.IndexIdList = {}

    self.refreshListTime = 0--刷新俱乐部推荐列表的时间

    ---@type table<number,ClubData>
    self.searchClubIdList = {}

    ---@type table<number,ClubData>
    self.selfApplyList = {}--自己申请的俱乐部

    self.curSelectClubId = -1

    self.curSelectMemId = nil
    self.curSelectApplyMemId = nil

    self.isFirstEnterServer = false

    self.refreshTimeId = -1

    self.clubListType = ClubListType.Recommend

    self.serverHaveClub = false

    CacheClearTrigger:Get():RegisterEvent(self, self.Clear)

end

function ClubDataManager:SetClubListType(clubListType)
    self.clubListType = clubListType
end
---@return ClubListType
function ClubDataManager:GetClubListType()
    return self.clubListType
end

function ClubDataManager:SetFirstEnterServer(isFirstEnterServer)
    self.isFirstEnterServer = isFirstEnterServer
end
function ClubDataManager:GetFirstEnterServer()
    return self.isFirstEnterServer
end

function ClubDataManager:SetRefreshListTime(time)
    self.refreshListTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + time
end
function ClubDataManager:GetRefreshListTime()
    return self.refreshListTime
end

function ClubDataManager:SetCurSelectClubId(clubId)
    self. curSelectClubId = clubId
end
function ClubDataManager:SetServerHaveClub(isHave)
    self. serverHaveClub  = isHave
end
function ClubDataManager:GetServerHaveClub()
    return self. serverHaveClub
end
function ClubDataManager:GetCurSelectClubId()
    return self.curSelectClubId
end

function ClubDataManager:SetCurSelectMemId(memberId)
    self.curSelectMemId = memberId
end

function ClubDataManager:GetCurSelectMemId()
    return self.curSelectMemId
end

function ClubDataManager:SetCurSelectApplyMemId(memberId)
    self.curSelectApplyMemId = memberId
end
function ClubDataManager:GetCurSelectApplyMemId()
    return self.curSelectApplyMemId
end

function ClubDataManager:SetRefreshTimeId(timeId)
    self.refreshTimeId = timeId
end
function ClubDataManager:GetRefreshTimeId()
    return self.refreshTimeId
end

-----------------------------------------以下是对俱乐部的操作------------------------
---@param msg SC_GuildInfo
function ClubDataManager:InitSelfClubData(msg)

    self.IndexIdList = {}

    self.ClubDataDic = {}

    local clubData = ClubData()

    clubData:InitClubDetailData(msg)

    table.insert(self.IndexIdList, msg.guildid)

    self.ClubDataDic[msg.guildid] = clubData
end

------------------------------------------------设置俱乐部列表数据
---@param msg SC_UserGuild
function ClubDataManager:InitRecommendClubData(msg)

    self.ClubDataDic = {}

    self.IndexIdList = {}

    print("俱乐部的列表数量" , #msg.guildlist)

    for i = 1, #msg.guildlist do
        local clubData = ClubData()

        clubData:InitClubDetailData(msg.guildlist[i])

        table.insert(self.IndexIdList, msg.guildlist[i].guildid)

        self.ClubDataDic[msg.guildlist[i].guildid] = clubData
    end

end

---@return ClubData
function ClubDataManager:GetClubDataById(id)
    if self:GetClubListType() == ClubListType.Recommend then
        return self.ClubDataDic[id]
    elseif self:GetClubListType() == ClubListType.Search then
        for i = 1, #self.searchClubIdList do
            local clubData = self:GetClubDataByIdxType(i, ClubListType.Search)
            if clubData:GetId() == id then
                return clubData
            end
        end
    elseif self:GetClubListType() == ClubListType.SelfApply then
        for i = 1, #self.selfApplyList do
            local clubData = self:GetClubDataByIdxType(i, ClubListType.SelfApply)
            if clubData:GetId() == id then
                return clubData
            end
        end
    end
    return nil
end

----------------------------------------------获取当前俱乐部列表的数量
function ClubDataManager:GetClubListCount()
    return #self.IndexIdList
end


--{{{俱乐部申请成员

----------------------------------------------得到当前申请成员的字典
---@param clubData ClubData
function ClubDataManager:GetClubApplyMemberIds(clubData)
    clubData = clubData or self:GetClubDataById(self.curSelectClubId)
    local tempApplyIds = {}
    table.move(clubData.applyIdIdxList, 1, clubData:GetApplyMemCount(), 1, tempApplyIds)
    return tempApplyIds
end


--}}}
----------------------------------------------得到当前申请成员的信息

function ClubDataManager:GetClubApplyInfoById(id)
    self.SetClubListType(ClubListType.SelfApply)
    local clubD = self:GetClubDataById(id)
    ---@return  ApplyInfo
    return clubD.applyDic[id]
end


--}}}

------------------------------------------------------------#######################---------公用方法--------#################-------
---------------------------------------------获得职位相应的名称
function ClubDataManager:GetPositionName(position)
    ----去读表
    if (position == ClubMemberPosition.President) then
        --return "會長"
        return CommonHelper:GetTempStr_Default(TemplateStringID.ClubPresident)
    elseif (position == ClubMemberPosition.Manager) then
        --return "管理員"
        return CommonHelper:GetTempStr_Default(TemplateStringID.ClubManager)
    elseif (position == ClubMemberPosition.Officer) then
        return "官員"
    elseif (position == ClubMemberPosition.Elite) then
        return "精英會員"
    elseif (position == ClubMemberPosition.RankAndFile) then
        --return "成員"
        return CommonHelper:GetTempStr_Default(TemplateStringID.ClubRankAndFile)
    else
        --return "成員"
        return CommonHelper:GetTempStr_Default(TemplateStringID.ClubRankAndFile)
    end
end

---@param msg SC_GuildInfo
function ClubDataManager:InitSearchClubListData(msg)
    self.searchClubIdList = {}

    local clubData = ClubData()

    clubData:InitClubDetailData(msg)

    table.insert(self.searchClubIdList, clubData)

    ClubDataManager:Get():SetCurSelectClubId(clubData:GetId())
end

function ClubDataManager:GetSearchClubCount()
    return #self.searchClubIdList
end


--{{{自己申请的俱乐部
---@param msg table<number,SC_MemberInfo>
function ClubDataManager:InitSelfApplyListData(msg)
    self.selfApplyList = {}

    for i = 1, #msg do
        local clubData = ClubData()
        clubData:InitClubShortData(msg[i])
        table.insert(self.selfApplyList, clubData)
    end
end
function ClubDataManager:GetSelfApplyDataByIdx(index)
    return self.selfApplyList[index]
end

function ClubDataManager:GetSelfApplyClubCount()
    return #self.selfApplyList
end
--}}}


--{{{公用方法

----false,就是没有俱乐部，true，就是有俱乐部
function ClubDataManager:IsHadClub()
    return PlayerDataManager:Get():GetGuildId() ~= 0
end

---@param clubListType ClubListType
function ClubDataManager:GetMemberCountByType(clubListType)
    if clubListType == ClubListType.Search then
        return self:GetSearchClubCount()
    elseif clubListType == ClubListType.Recommend then
        return self:GetClubListCount()
    elseif clubListType == ClubListType.SelfApply then
        return self:GetClubListCount()
    end
end

---@param clubListType ClubListType
---@return ClubData
function ClubDataManager:GetClubDataByIdxType(index, clubListType)
    if clubListType == ClubListType.Recommend then
        return self.ClubDataDic[self.IndexIdList[index]]
    elseif clubListType == ClubListType.Search then
        return self.searchClubIdList[index]
    elseif clubListType == ClubListType.SelfApply then
        return self.selfApplyList[index]
    end
end

---@return ClubData
function ClubDataManager:GetCurSelectClubData()
    return self:GetClubDataById(self.curSelectClubId)
end

---@return dictguildlevel_config
function ClubDataManager:GetGuildConfigByLevel(level)
    ---@type dictguildlevel_config
    local dictguild = ClientDataManager:Get():GetDataTable(ConfigNames.dictguildlevel_config)

    return dictguild.GetById(level)
end

---@return dictguildlevel_config
function ClubDataManager:GetGuildLevelByExp(exp)
    local curExp = exp or self:GetCurSelectClubData():GetCoin()
    local LevelOld = self:GetCurSelectClubData():GetLevel()
    local LevelNew = 1
    ---@type dictguildlevel_config
    local  cfgData=ClientDataManager:Get():GetDataTable(ConfigNames.dictguildlevel_config).GetConfigData()
    for k,v in pairs(cfgData) do
        if curExp < v.guildexpe then
            LevelNew = v.C_ID
            break
        end
    end
    --俱乐部等级提升（客户度自己判断）
    if LevelNew > LevelOld then
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictguildlevel_config, LevelNew)
        self:GetCurSelectClubData():SetMemberMaxCount(cfg.guildnum)
    end
    return LevelNew
end

function ClubDataManager:Clear()
    self.ClubDataDic = {}
    self.IndexIdList = {}
    self.refreshListTime = 0
    self.searchClubIdList = {}
    self.selfApplyList = {}
    self.curSelectClubId = -1
    self.curSelectMemId = nil
    self.curSelectApplyMemId = nil

    self.refreshTimeId = -1

    self.isFirstEnterServer = false

    self.clubListType = ClubListType.None
end
--}}}







