---@class PlayerData PlayerData
PlayerData = class("PlayerData")

function PlayerData:initialize()
    self.rid=0 --玩家id
    self.uid = -1
    self.serverId = -1 --服务器id
    self.roleName = "" --玩家名称
    self.headIcon = -1 --头像
    self.iconFrame = -1 --icon边框
    self.curLevel = -1--当前等级
    self.curExp =-1 --当前经验
    self.stamina=-1 --体力
    self.maxStamina=-1 --最大体力
    self.staminaTime=-1 --体力计时
    self.curCheckpoints=-1 --最近关卡id
    self.ClubId=-1 --公会id
    self.sign="" --签名
    self.loginDay=-1--累计登录
    self.continue7Day=-1 --7日连续 0断
    self.buyStamina=-1 --购买体力次数
    self.friendGiftNum=-1 --好友赠送次数
    self.friendRecNum=-1--好友领取次数
    self.headIconList=nil
    self.guideStep = 0
    self.guildName = ""
    self.rankScore = 0
    self.LevelAward=nil
    ---@type PlayerBindData
    self.BindData=nil
    self.ExChGold = 0
    self.TestGiftFlag=0 --测试返利0无 1可领
    self.freePhysicalPower={}
    self.cups= { }
end
---@param data SC_UserInfoPacket
function  PlayerData:InitPlayerData(data)
    self.rid=data.rid
    self.uid = data.uid
    self.serverId = data.serverid
    self.roleName = data.rolename
    self.headIcon = data.headicon
    self.iconFrame = data.iconframe
    self.curLevel = data.curlevel
    self.curExp =data.curexp
    self.stamina=data.stamina
    self.maxStamina = tonumber(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.StaminaBiggestLimit).varval)
    self.staminaTime=data.staminatime
    self.curCheckpoints=data.curcopyid
    self.ClubId=data.guildid
    self.sign=data.sign
    self.loginDay=data.loginday
    self.continue7Day=data.continueday
    self.buyStamina=data.buystamina
    self.friendGiftNum=data.friendgiftnum
    self.friendRecNum=data.friendrecvnum
    if CommonHelper:IsNullOrEmpty(data.tradeNo) then
        self.guideStep=0
    else
        self.guideStep=tonumber(data.tradeNo)
    end

    --self.rankScore=data.
    self.FirstCharge=data.firstcharge
    self.FirstActType=data.firstActType
    self.actFirstCharge=data.actFirstCharge
    self.daygift=data.daygift
    self.daySign=data.daySign
    self.MonthSign=data.montySign
    self.SevenDayTask=data.sevenDayTask
    self.LevelAward=data.levelawards
    self.ExChGold = data.exchgold
    --金币 12040101 钻石 12040102 12040133
    self.freePhysicalPower={}
    for i = 1,# data.powergift do
        table.insert(self.freePhysicalPower,tonumber(data.powergift[i]))
    end
    self:SetBindData(data.curBind)
    self.cups=stringSplitToNumber(data.cups,':')
    self.background = data.background
    QuickTaHelper:Get():SetDefaultDataRoleId(self.rid)
    QuickTaHelper:Get():SetDefaultDataUserId(self.uid)
    QuickTaHelper:Get():SetDefaultDataGlobalUserId(self.uid)
    if ClientDataManager:Get():GetIsNew() then
        UnifySDKHelper:SetLevelUpToken(PlayerDataManager:Get():GetPlayerLV())
    end
    PlayerSampleInfoDataManager:Get():GetSelfSampleInfo():SetDataByPlayerData(self)
end
---@param data SC_UserHead[]
function  PlayerData:SetHeadData(data)
    self.headIconList={}
    for k, v in pairs(data) do
        local temp=HeadIconData()
        temp:SetData(v.headid,v.unlockflag)
        self.headIconList[temp.id]=temp
    end
end
---@param data SC_UserHead[]
function  PlayerData:AddHeadData(data)
    for k, v in pairs(data) do
        local temp=HeadIconData()
        temp:SetData(v.headid,v.unlockflag)
        self.headIconList[temp.id]=temp
    end
end

function PlayerData:CheckHasIconFrame(id)
    if self.headIconList[id] then
        return true
    end
    return false
end
function PlayerData:GetHeadList()
    return self.headIconList
end
function PlayerData:GetSevenDayTask()
    return self.SevenDayTask
end
function PlayerData:GetSevenSign()
    return self.daySign
end
function PlayerData:SetSevenSign(value)
    self.daySign=value
end

function PlayerData:GetUid()
    return self.uid
end
function PlayerData:SetUid(id)
    self.uid=id
    QuickTaHelper:Get():SetDefaultDataGlobalUserId(id)
    QuickTaHelper:Get():SetDefaultDataUserId(id)
end

function PlayerData:GetRid()
    return self.rid
end
function PlayerData:SetRid(id)
    self.rid=id
    QuickTaHelper:Get():SetDefaultDataRoleId(id)
end

function PlayerData:GetServerId()
    return self.serverId
end
function PlayerData:SetServerId(id)
    self.serverId=id
end

function PlayerData:GetRoleName()
    return self.roleName
end
function PlayerData:SetRoleName(roleName)
    self.roleName=roleName
    PlayerSampleInfoDataManager:Get():GetSelfSampleInfo():SetRoleName(roleName)
end

function PlayerData:GetHeadIcon()
    if self.headIcon == 0 then
        self.headIcon = 16
    end
    return self.headIcon
end
function PlayerData:SetHeadIcon(headIcon)
    self.headIcon=headIcon
    PlayerSampleInfoDataManager:Get():GetSelfSampleInfo():SetHeadIcon(headIcon)
end

function PlayerData:GetIconFrame()
    return self.iconFrame
end
function PlayerData:SetIconFrame(iconFrame)
    self.iconFrame=iconFrame
    PlayerSampleInfoDataManager:Get():GetSelfSampleInfo():SetIconFrame(iconFrame)
end

function PlayerData:SetBgId(id)
    self.background=id
    PlayerSampleInfoDataManager:Get():GetSelfSampleInfo():SetBgId(id)
end

function PlayerData:GetBgId()
    return self.background
end

function PlayerData:SetCups(cups)
    self.cups[1]=cups[1]
    self.cups[2]=cups[2]
    self.cups[3]=cups[3]
    PlayerSampleInfoDataManager:Get():GetSelfSampleInfo():SetCup(cups)
end

function PlayerData:GetCups()
    return self.cups
end

function PlayerData:GetLV()
    return self.curLevel
end
function PlayerData:SetLV(lv)
    self.curLevel=lv
    PlayerSampleInfoDataManager:Get():GetSelfSampleInfo():SetLevel(lv)
end

function PlayerData:GetEXP()
    return self.curExp
end
function PlayerData:SetEXP(exp)
    self.curExp=exp
end

function PlayerData:GetStamina()
    return self.stamina
end
function PlayerData:SetStamina(stamina)
    self.stamina=stamina
end

function PlayerData:GetStaminaTime()
    return self.staminaTime
end
function PlayerData:SetStaminaTime(staminaTime)
    self.staminaTime=staminaTime
end

function PlayerData:GetCurChapterId()
    return self.curCheckpoints
end
function PlayerData:SetCurChapterId(levelId)
     self.curCheckpoints=levelId
end

function PlayerData:GetClubId()
    return self.ClubId
end
function PlayerData:SetClubId(club)
    self.ClubId=club
end

function PlayerData:GetClubName()
    return self.ClubName
end
function PlayerData:SetClubName(name)
    self.ClubName=name
end

function PlayerData:GetSign()
    return self.sign
end
function PlayerData:SetSign(sign)
    self.sign=sign
end

function PlayerData:GetLoginDay()
    return self.loginDay
end
function PlayerData:SetLoginDay(loginDay)
    self.loginDay=loginDay
end

function PlayerData:GetContinue7Day()
    return self.continue7Day
end
function PlayerData:SetContinue7Day(continue7Day)
     self.continue7Day=continue7Day
end
function PlayerData:SetBuyStamina(buyStamina)
    self.buyStamina=buyStamina
end
function PlayerData:GetBuyStamina()
    return self.buyStamina
end
function PlayerData:SetTestGiftFlag(value)
    self.TestGiftFlag=value
end
function PlayerData:GetTestGiftFlag()
    return self.TestGiftFlag==1
end

function PlayerData:GetFriendGiftNum()
    return self.friendGiftNum
end
function PlayerData:SetFriendGiftNum(friendGiftNum)
    self.friendGiftNum=friendGiftNum
end

function PlayerData:GetFriendRecNum()
    return self.friendRecNum
end
function PlayerData:SetFriendRecNum(friendRecNum)
    self.friendRecNum=friendRecNum
end

function PlayerData:GetGuideStep()
    return self.guideStep
end
function PlayerData:SetGuideStep(guideStep)
    self.guideStep=guideStep
end

function PlayerData:GetRankScore()
    return self.rankScore
end
function PlayerData:SetRankScore(rankScore)
    self.rankScore=rankScore
end
function PlayerData:SetMaxStamina(value)
    self.maxStamina=value
end
---@param msg SC_UserRidInfo
function PlayerData:SetBindData(msg)
    if msg then
        self.BindData=PlayerBindData(msg)
    end

end

function PlayerData:GetMaxStamina()
   local cfg= CommonHelper:GetTableDataByID(ConfigNames.levelup_config, self.curLevel)
    if cfg then
        self.maxStamina=cfg.maxpower
    end
   return self.maxStamina
end

---@class PlayerBindData
PlayerBindData = class("PlayerBindData")
---@param msg SC_UserRidInfo
function PlayerBindData:initialize(msg)
    self.wdRid=msg.wdRid
    self.roleName=msg.roleName
    self.headIcon=msg.headIcon
    self.iconFrame=msg.iconFrame
    self.serverId=msg.serverId
end