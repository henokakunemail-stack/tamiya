---@class ClubData
ClubData = class("ClubData")

function ClubData:initialize()
    self.id = 0
    self.name = ""
    self.level = 0
    self.memberCount = 0--查看简略信息用
    self.declaration = ""--宣言
    self.notice = ""--公告
    self.presidentName = ""
    self.memberMax = 0
    self.icon = 1
    self.coin = 0
    self.presidentId = 0
    self.activity = 0
    self.exp = 0
    self.joinType = ClubJoinType.FreeJoin
    self.position = 0------自己在俱乐部中的职位
    self.limitLv = 0
    self.isHadNewApplication = false
    self.applyNum = 0----申请数量

    self.memberIdxList = {}
    ---@type table<number,MemberInfo>
    self.memberDic = {}

    ---@type table<number,ApplyInfo>
    self.applyDic = {}
    self.applyIdIdxList = {}
    ---所有的图标
    self.allBadgeList = {}
end

---@param msg SC_GuildInfo
function ClubData:InitClubShortData(msg)
    self. id = msg. id
    self. name = msg. name
    self. level = msg. level
    self. memberCount = msg. memberCount
    self. memberMax = msg. memberMax
    self. isHadApplyFor = msg. isHadApplyFor --是否已经申请过
    self. icon = msg. icon
    self. dec = msg. dec
    ---@type ClubJoinType
    self. joinType = msg. joinType

    self. limitLv = msg. limitLv
end

---@param msg SC_GuildInfo
function ClubData:InitClubDetailData(msg)
    ---@param type  SC_MemberInfo
    self.id = msg.guildid
    self.name = msg.guildname
    self.level = msg.guildlev
    self.memberCount = msg.members
    self.joinType = msg.guildtype
    self.limitLv = msg.needlev----申请限制等级
    self.declaration = msg.guildpub
    self.notice = msg.guildpub
    self.icon = msg.guildicon
    self.coin = msg.guildmoney
    self.presidentId = msg.leader--会长ID
    self.presidentName = msg.leadername
    ---@type dictguildlevel_config
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictguildlevel_config, self.level)
    self. memberMax = cfg.guildnum
    --self.presidentName = msg.presidentName
    --self.memberMax = msg.memberMax
    --self.presidentId = msg.presidentId--会长ID
    --
    --self.activity = msg.activity
    --self.exp = msg.exp
    --self.position = msg.position------自己在俱乐部中的职位
    --self.applyNum = msg.applyNum----申请数量
    end

--------------------------------################--------------------------------以下是对俱乐部成员的操作
---@param msg SC_UserGuild
function ClubData:InitMemberList(msg)

    self.memberIdxList = {}

    self.memberDic = {}

    for i = 1, #msg.memberlist do
        local memberInfo = MemberInfo(msg.memberlist[i])
        self.memberDic[memberInfo:GetPlayerId()] = memberInfo
        if tonumber(memberInfo:GetPlayerId()) ==  PlayerDataManager:Get():GetPlayerRID() then
            self.position = memberInfo:GetPosition();
        end
        table.insert(self.memberIdxList, memberInfo:GetPlayerId())
    end

    table.sort(self.memberIdxList, function(a, b)
        local tempMemberA = self:GetMemberById(a)
        local tempMemberB = self:GetMemberById(b)

        -- 1. 首先按在线状态排序（在线优先）
        -- 假设 leaveTime = -1 表示在线，其他值表示离线时间戳
        local isOnlineA = tempMemberA:GetLeaveTime() == -1
        local isOnlineB = tempMemberB:GetLeaveTime() == -1

        if isOnlineA ~= isOnlineB then
            return isOnlineA  -- 在线（true）排在离线（false）前面
        else
            -- 2. 在线状态相同的情况下，按职位排序
            if tempMemberA:GetPosition() ~= tempMemberB:GetPosition() then
                return tonumber(tempMemberA:GetPosition()) > tonumber(tempMemberB:GetPosition())
            else
                -- 3. 职位也相同的情况下，按离线时间排序（最近在线的排在前面）
                if tempMemberA:GetLeaveTime() ~= tempMemberB:GetLeaveTime() then
                    return tonumber(tempMemberA:GetLeaveTime()) > tonumber(tempMemberB:GetLeaveTime())
                else
                    -- 4. 离线时间也相同的情况下，按捐赠总额排序
                    return tonumber(tempMemberA:GetDonationSum()) > tonumber(tempMemberB:GetDonationSum())
                end
            end
        end
    end)
end

function ClubData:GetMemberDic()
    return self.memberDic
end

---@param position ClubMemberPosition
function ClubData:GetMemberCountByPos(position)
    local count = 0
    for id, data in pairs(self:GetMemberDic()) do
        if data:GetPosition() == position then
            count = count + 1
        end
    end
    return count
end

---@return MemberInfo
function ClubData:GetMemberById(memberId)
    return self.memberDic[memberId]
end

---@return MemberInfo
function ClubData:GetMemberByIndex(index)
    return self.memberDic[self.memberIdxList[index]]
end

---@param memberInfo MemberInfo
function ClubData:UpdateMemberById(memberId, memberInfo)
    self.memberDic[memberId] = memberInfo
end

function ClubData:DeleteMemberById(memberPlayerId)
    print("踢除当前的指定id的成员，id是。。。。。。。。。。。。。。" .. memberPlayerId)
    self.memberDic[memberPlayerId] = nil
    for i = #self.memberIdxList, 1, -1 do
        if self.memberIdxList[i] == memberPlayerId then
            table.remove(self.memberIdxList, i)
            break
        end
    end
end

function ClubData:GetMemberCount()
    if #self.memberIdxList <= 0 then
        return self.memberCount
    end
    return #self.memberIdxList
end

function ClubData:SetMemberMaxCount(count)
     self.memberMax = count
end
function ClubData:GetMemberMaxCount()
    return self.memberMax
end

---@param clubJoinType ClubJoinType
function ClubData:SetJoinType(clubJoinType)
    self.joinType = clubJoinType
end

function ClubData:SetClubName(name)
    self.name = name
end

---@return ClubJoinType
function ClubData:GetJoinType()
    return self.joinType
end

function ClubData:GetPresidentId()
    return self.presidentId
end

function ClubData:GetPresidentName()
    return self.presidentName
end

function ClubData:GetCoin()
    return self.coin
end


function ClubData:SetNotice(notice)
    self.notice = notice
end
function ClubData:GetNotice()
    return self.notice
end
function ClubData:SetLimitLv(limitLv)
    self.limitLv = limitLv
end
function ClubData:GetLimitLv()
    return self.limitLv
end

---@param position ClubMemberPosition
function ClubData:SetSelfPosition(position)
    self.position = position
end
---@return ClubMemberPosition
function ClubData:GetSelfPosition()
    return tonumber(self.position)
end

function ClubData:SetDeclaration(declaration)
    self.declaration = declaration
end
function ClubData:GetDeclaration()
    return self.declaration
end

function ClubData:SetLevel(level)
    self.level = level
end
function ClubData:GetLevel()
    return self.level
end

function ClubData:GetName()
    return self.name
end

function ClubData:GetDec()
    return self.dec
end

function ClubData:SetIcon(icon)
    self.icon = icon
end
function ClubData:GetIcon()
    return self.icon
end
function ClubData:SetCoin(coin)
    self.coin = coin
end
function ClubData:GetCoin()
    return self.coin
end

function ClubData:SetExp(exp)
    self.exp = exp
end
function ClubData:GetExp()
    return self.exp
end

function ClubData:SetHasApplyFor(isHadApplyFor)
    self.isHadApplyFor = isHadApplyFor
end
function ClubData:GetHasApplyFor()
    return self.isHadApplyFor
end

function ClubData:SetActivity(activity)
    self.activity = activity
end
function ClubData:GetActivity()
    return self.activity
end

function ClubData:GetId()
    return self.id
end

---@param position ClubMemberPosition
function ClubData:SetMemberPosById(memberId, position)
    self:GetMemberById(memberId):SetPosition(tostring(position))
end
function ClubData:GetMemberPosById(memberId)
    return self:GetMemberById(memberId):GetPosition()
end

---@param msg SC_UserGuild
function ClubData:InitApplyMemberList(msg)

    self.applyIdxIdList = {}

    self.applyDic = {}

    for i = 1, #msg.applylist do
        local applyInfo = ApplyInfo(msg.applylist[i])
        self.applyDic[applyInfo:GetPlayerId()] = applyInfo
        table.insert(self.applyIdxIdList, applyInfo:GetPlayerId())
    end
end

---@return ApplyInfo
function ClubData:GetApplyMemberById(applyId)
    return self.applyDic[applyId]
end

---@return ApplyInfo
function ClubData:GetApplyMemberByIdx(index)
    return self.applyDic[self.applyIdxIdList[index]]
end

---@param applyInfo ApplyInfo
function ClubData:UpdateApplyMemberById(applyId, applyInfo)
    self.applyDic[applyId] = applyInfo
end

function ClubData:DeleteApplyMember(memberId,addMemberDic)
    print("同意或拒绝当前的指定id的成员，id是。。。。。。。。。。。。。。" .. memberId)
    if addMemberDic then
        --复制到成员列表中
        ---@param aaa SC_MemberInfo
        local msg  ={}
        msg.rid = self.applyDic[memberId].playerId
        msg.position = self.applyDic[memberId].position
        msg.curactivity = self.applyDic[memberId].curactivity
        msg.donationsum = self.applyDic[memberId].donationsum
        msg.exchsum = self.applyDic[memberId].exchsum
        msg.jointime = self.applyDic[memberId].jointime
        msg.rolename = self.applyDic[memberId].playerName
        msg.curlevel = self.applyDic[memberId].level
        msg.logintime = self.applyDic[memberId].leaveTime
        msg.headicon = self.applyDic[memberId].headIcon
        local memberInfo = MemberInfo(msg)
        self.memberDic[memberId] = memberInfo
        table.insert(self.memberIdxList, memberId)
    end
    --申请列表中移除
    self.applyDic[memberId] = nil
    for i = #self.applyIdxIdList, 1, -1 do
        if self.applyIdxIdList[i] == memberId then
            table.remove(self.applyIdxIdList, i)
            break
        end
    end
end

function ClubData:DeleteMulApplyMemByIds(memberIds)
    for i = 1, #memberIds do
        self:DeleteSingleApplyMemById(memberIds[i])
    end
end

function ClubData:GetApplyMemCount()
    return #self.applyIdxIdList
end

---@class MemberInfo
MemberInfo = class("MemberInfo")

---@param msg SC_MemberInfo
function MemberInfo:initialize(msg)
    self.position = msg.position
    self.curactivity = msg.curactivity
    self. playerId = msg.rid

    self. headIcon = tonumber(msg.headicon)
    self. IconFrame = tonumber(msg.iconframe)

    self. level = msg.curlevel
    self. playerName = msg.rolename
    self. leaveTime = tonumber(msg.logintime)
    self. jointime = tonumber(msg.jointime)
    self. donationsum = msg.donationsum == nil and 0 or msg.donationsum
    self. weekpoint = msg.weekpoint == nil and 0 or msg.weekpoint
    self. exchsum = msg.exchsum

    self.score = msg.score
end
function MemberInfo:GetName()
    return self.playerName
end

function MemberInfo:GetDonationSum()
    return self.donationsum
end

function MemberInfo:GetWeekPoint()
    return self.weekpoint
end

function MemberInfo:SetPosition(position)
    self.position = position
end
---@return ClubMemberPosition
function MemberInfo:GetPosition()
    return tonumber(self.position)
end
function MemberInfo:GetLevel()
    return self. level
end
function MemberInfo:GetLeaveTime()
    return tonumber(self. leaveTime) <= 0 and -1 or tonumber(self. leaveTime) * 1000
end
function MemberInfo:GetPlayerId()
    return self. playerId
end
function MemberInfo:GetHeadIcon()
    return self. headIcon
end
function MemberInfo:GetIconFrame()
    return self. IconFrame
end
function MemberInfo:GetRankScore()
    --return self. score
    return 0
end

---@class ApplyInfo
ApplyInfo = class("ApplyInfo")

---@param msg SC_MemberInfo
function ApplyInfo:initialize(msg)
    self.position = msg.position
    self.curactivity = msg.curactivity
    self.playerId = msg.rid

    self.headIcon = tonumber(msg.headicon)
    self.IconFrame = tonumber(msg.iconframe)

    self.level = tonumber(msg.curlevel)
    self.playerName = msg.rolename
    self.leaveTime = tonumber(msg.logintime)
    self.jointime = tonumber(msg.jointime)
    self.donationsum = msg.donationsum
    self. weekpoint = msg.weekpoint
    self.exchsum = msg.exchsum

    self.score = msg.score
end

function ApplyInfo:GetName()
    return self.playerName
end
function ApplyInfo:GetHeadIcon()
    return self.headIcon
end
function ApplyInfo:GetLeaveTime()
    return tonumber(self.leaveTime) <= 0 and -1 or tonumber(self.leaveTime) * 1000
end
function ApplyInfo:GetPlayerId()
    return self.playerId
end
function ApplyInfo:GetIconFrame()
    return self.IconFrame
end

function ApplyInfo:GetPosition()
    return tonumber(self.position)
end

function ApplyInfo:GetLevel()
    return tonumber(self.level)
end

function ApplyInfo:GetRankScore()
    --return self. score
    return 0
end

function ApplyInfo:GetDonationSum()
    return self.donationsum
end

function ApplyInfo:GetWeekPoint()
    return self.weekpoint
end