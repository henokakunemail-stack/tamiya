---@class PlayerDataManager
PlayerDataManager = class("PlayerDataManager")

function PlayerDataManager:initialize()
    self.PlayerData = PlayerData()
    self.ReChargeList=nil
    ---@type table<PlayerAttrType,table<number,function>>
    self.AttrChangeEvent = {}
    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end

---@return PlayerDataManager
function PlayerDataManager:Get()
    if self._instance == nil then
        self._instance = PlayerDataManager()
    end
    return self._instance
end

---@param msg SC_UserInfoPacket
function PlayerDataManager:InitPlayData(msg)
    if msg then
        self.PlayerData:InitPlayerData(msg)
    end
end
---@param msg SC_UserHead[]
function PlayerDataManager:SetHeadList(msg)
    self.PlayerData:SetHeadData(msg)
end
function PlayerDataManager:SetTestGiftFlag(value)
    self.PlayerData:SetTestGiftFlag(value)
end

function PlayerDataManager:GetTestGiftFlag()
   return self.PlayerData:GetTestGiftFlag()
end

---@param msg SC_UserHead[]
function PlayerDataManager:AddHeadList(msg)
    if msg then
        self.PlayerData:AddHeadData(msg)
    end
end


---@param msg SC_reloadCharge[]
function PlayerDataManager:InitReChargeList(msg)
    self.ReChargeList=msg
end

function PlayerDataManager:CheckHasIconFrame(id)
     return  self.PlayerData:CheckHasIconFrame(id)
end



function PlayerDataManager:SetPlayerName(playerName)
    self.PlayerData:SetRoleName(playerName)
end
function PlayerDataManager:UpdateBindInfo(msg)
    self.PlayerData:SetBindData(msg)
end
function PlayerDataManager:GetPlayerName()
    return self.PlayerData:GetRoleName()
end
function PlayerDataManager:GetSevenDayTask()
    if self.PlayerData:GetSevenDayTask() then
        return self.PlayerData:GetSevenDayTask()<=8
    end

end
function PlayerDataManager:GetSevenSign()
    if self.PlayerData:GetSevenSign() then
        return self.PlayerData:GetSevenSign()<7
    end
end
function PlayerDataManager:GetSevenSignRedPint()
    if self.PlayerData:GetSevenSign() then
        return self.PlayerData:GetSevenSign()==0
    end
end


function PlayerDataManager:SetPlayerSign(playerSign)
    self.PlayerData:SetSign(playerSign)
end
function PlayerDataManager:GetPlayerSign()
    return self.PlayerData:GetSign()
end

function PlayerDataManager:GetPlayerRID()
    return self.PlayerData:GetRid()
end
function PlayerDataManager:GetPlayerUID()
    return self.PlayerData:GetUid()
end

function PlayerDataManager:GetGuideStep()
    return self.PlayerData:GetGuideStep()
end
function PlayerDataManager:SetGuideStep(guideStep)
    self.PlayerData:SetGuideStep(guideStep)
end


function PlayerDataManager:SetPlayerServerID(serverId)
    self.PlayerData:SetServerId(serverId)
end
function PlayerDataManager:GetPlayerServerID()
    return self.PlayerData:GetServerId()
end

function PlayerDataManager:SetLevelId(id)
    self.PlayerData:SetCurChapterId(id)
end

function PlayerDataManager:GetLevelId()
    return self.PlayerData:GetCurChapterId()
end

--获取购买体力次数
function PlayerDataManager:SetBuyStamina(buyStaminaTimes)
    self.PlayerData:SetBuyStamina(buyStaminaTimes)
end
function PlayerDataManager:GetBuyStamina()
    return self.PlayerData:GetBuyStamina()
end

function PlayerDataManager:GetGuildId()
    return self.PlayerData:GetClubId()
end
function PlayerDataManager:SetGuildId(id)
    self.PlayerData:SetClubId(id)
end
function PlayerDataManager:GetGuildName()
    return self.PlayerData:GetClubName()
end
function PlayerDataManager:SetGuildName(name)
    self.PlayerData:SetClubName(name)
end
function PlayerDataManager:SetUid(id)
    self.PlayerData:SetUid(id)
end

function PlayerDataManager:GetRankScore()
    return self.PlayerData:GetRankScore()
end

function PlayerDataManager:SetRankScore(rankScore)
    self.PlayerData:SetRankScore(rankScore)
end

function PlayerDataManager:SetPlayerIcon(headIcon)
    self.PlayerData:SetHeadIcon(headIcon)
end
function PlayerDataManager:GetPlayerIcon()
    return self.PlayerData:GetHeadIcon()
end
function PlayerDataManager:SetPlayerIconFrame(headIconFrame)
    self.PlayerData:SetIconFrame(headIconFrame)
end
function PlayerDataManager:GetPlayerIconFrame()
    return self.PlayerData:GetIconFrame()
end

function PlayerDataManager:SetPlayerLV(lv)
    if lv==self.PlayerData:GetLV() then
        return false
    end
    if lv~=0 then
        self.PlayerData:SetLV(lv)
        UINotify:Get():SendNotification(UINotifyEvent.Msg_PlayerLv)
    end
    return true
end

function PlayerDataManager:SetBgId(id)
    self.PlayerData:SetBgId(id)
end

function PlayerDataManager:GetBgId()
    return self.PlayerData:GetBgId()
end

function PlayerDataManager:SetCups(cups)
    self.PlayerData:SetCups(cups)
end

function PlayerDataManager:GetCups()
    return self.PlayerData:GetCups()
end

function PlayerDataManager:SetPlayerStaminaAndStaminaTime(stamina, staminaTime)
    self.PlayerData:SetStamina(stamina)
    self:SetPlayerStaminaTime(staminaTime)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PlayerStamina)
end
function PlayerDataManager:GetPlayerMaxStamina()
    return self.PlayerData:GetMaxStamina()
end
function PlayerDataManager:SetPlayerMaxStamina(maxStamina)
    self.PlayerData:SetMaxStamina(maxStamina)--这个时候不需要再进行刷新体力，因为设置体力的时候用的是最新的
end
function PlayerDataManager:GetPlayerLV()
    if self.PlayerData then
        return self.PlayerData:GetLV()
    else
        return 0
    end

end

function PlayerDataManager:SetPlayerEXP(exp)
    self.PlayerData:SetEXP(exp)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PlayerExp)
end
function PlayerDataManager:GetPlayerEXP()
    return self.PlayerData:GetEXP()
end

function PlayerDataManager:GetPlayerStaminaTime()
    return self.PlayerData:GetStaminaTime()
end
function PlayerDataManager:SetPlayerStaminaTime(staminaTime)
    print("-----------------设置体力恢复时间--------------" .. staminaTime)
    self.PlayerData:SetStaminaTime(staminaTime + 2)
    StaminaDataManager:Get():StartIncreaseStamina()
end

function PlayerDataManager:GetPlayerStamina()
    return self.PlayerData:GetStamina()
end
function PlayerDataManager:SetPlayerStamina(stamina)
    self.PlayerData:SetStamina(stamina)
end
function PlayerDataManager:GetFriendRecNum()
    return self.PlayerData:GetFriendRecNum()
end
function PlayerDataManager:SetFriendRecNum(friendRecNum)
    self.PlayerData:SetFriendRecNum(friendRecNum)
end
function PlayerDataManager:GetFriendGiftNum()
    return self.PlayerData:GetFriendGiftNum()
end
function PlayerDataManager:SetFriendGiftNum(friendGiftNum)
    self.PlayerData:SetFriendGiftNum(friendGiftNum)
end
function PlayerDataManager:GetContinue7Day()
    return self.PlayerData:GetContinue7Day()
end
function PlayerDataManager:SetContinue7Day(continue7Day)
    self.PlayerData:SetContinue7Day(continue7Day)
end
function PlayerDataManager:GetLoginDay()
    return self.PlayerData:GetLoginDay()
end
function PlayerDataManager:SetLoginDay(loginDay)
    self.PlayerData:SetLoginDay(loginDay)
end

function PlayerDataManager:GetPlayerDataDaySign()
    return self.PlayerData.daySign
end
function PlayerDataManager:SetPlayerDataDaySign(value)
    return self.PlayerData:SetSevenSign(value)
end












function PlayerDataManager:GetDailyLoginNum()
    return self.PlayerData.dailyLoginNum
end



--设置购买体力次数




function PlayerDataManager:GetBanTalkLeftTimeDl()
    return self.PlayerData.banTalkLeftTimeDl
end

function PlayerDataManager:SetBanTalkLeftTimeDl()
    local leftTimeSecond = self.PlayerData.banTalkLeftTime
    self.PlayerData.banTalkLeftTimeDl = leftTimeSecond == ChatBanTime.BanForever and ChatBanTime.BanForever or CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + leftTimeSecond
end

function PlayerDataManager:GetBanTalkLeftTimeNow()
    if self.PlayerData.banTalkLeftTimeDl == ChatBanTime.BanForever then
        return ChatBanTime.BanForever
    else
        return self.PlayerData.banTalkLeftTimeDl - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    end
end
function PlayerDataManager:SetBanTalkLeftTime(leftTimeSecond)
    self.PlayerData.banTalkLeftTime = leftTimeSecond
    self:SetBanTalkLeftTimeDl()
end



---@param list table<number,SC_Tuple2>
function PlayerDataManager:SetCurrencyList(list)
    self.PlayerData:SetCurrencyList(list)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PlayerCurrency)
end

function PlayerDataManager:SetCurrency(key, value)
    --self.PlayerData:SetCurrency(key, value)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PlayerCurrency)
end

function PlayerDataManager:GetCurrency(key)
    --从背包里面根据id 获取
    return KnapsackDataManager:Get():GetArticleCountByCfgid(key)
end
function PlayerDataManager:CheckCurrencyEnough(key,number,IsShow)
    local result=false
    if IsShow==nil then IsShow=true end
    if number==nil then number=1 end
    if KnapsackDataManager:Get():GetArticleCountByCfgid(key)>=number then
        result=true
    end
    if not result and IsShow then
        CommonHelper:ShowCurrencyNoEnough(key)
    end
    return result
end


function PlayerDataManager:GetPlayerLoginDay()
    return self.PlayerData.loginDay
end
---@return PlayerData
function PlayerDataManager:GetPlayerData()
    if self.PlayerData == nil then
        logError("GetPlayerData---当前玩家数据为空")
    end
    return self.PlayerData
end

function PlayerDataManager:GetPlayerCreateTime()
    return self.PlayerData.createTime
end

function PlayerDataManager:GetPlayerLastLoginTime()
    return self.PlayerData.lastLogin
end

function PlayerDataManager:GetChatServerInfo()
    return self.PlayerData.chatIp, self.PlayerData.chatPort
end

---@param msg table<number,SC_Tuple2>
function PlayerDataManager:SetPlayerAttrData(msg)

end

function PlayerDataManager:GetPlayerRankNum()
    return self.PlayerData.rankNum
end
function PlayerDataManager:GetPlayerWinNum()
    return self.PlayerData.winNum
end
function PlayerDataManager:GetPlayerRankScoreMax()
    return self.PlayerData.rankScoreMax
end




---@param kickType KickedType
function PlayerDataManager:SetPlayerKickType(kickType)
    self.PlayerData.kickType = kickType
end
---@return KickedType
function PlayerDataManager:GetPlayerKickType()
    return self.PlayerData.kickType
end


---@param sdkLogoutType SDKLogoutType
function PlayerDataManager:SetPlayerSDKLogoutType(sdkLogoutType)
    self.PlayerData.sdkLogoutType = sdkLogoutType
end
---@return SDKLogoutType
function PlayerDataManager:GetPlayerSDKLogoutType()
    return self.PlayerData.sdkLogoutType
end

---@return SDKLogoutType
function PlayerDataManager:CheckReturnState()
    return self:GetPlayerLV()>=5 and self:GetPlayerLV()<=35
end
function PlayerDataManager:UpdateLevelAward(level)
    table.insert(self.PlayerData.LevelAward,level)
end
function PlayerDataManager:GetLevelAward()
    return self.PlayerData.LevelAward
end

-----------
function PlayerDataManager:GetExChGold()
    return self.PlayerData.ExChGold
end
function PlayerDataManager:GetBindData()
    return self.PlayerData.BindData
end

function PlayerDataManager:UpdateExChGold(data)
    self.PlayerData.ExChGold = data
end
-----------


function PlayerDataManager:SetGuildIpPort(guildIp, guildPort)
    self.PlayerData.guildIp = guildIp
    self.PlayerData.guildPort = guildPort
end
function PlayerDataManager:GetGuildIpPort()
    return self.PlayerData.guildIp, self.PlayerData.guildPort
end

---@param msg SC_RankInfo
function PlayerDataManager:UpdateRankData(msg)
    self.PlayerData.rankScoreMax = msg.rankScoreMax
    self.PlayerData.rankNum = msg.rankNum
    self.PlayerData.winNum = msg.winNum
    self.PlayerData.rankScore = msg.rankScore
end







function PlayerDataManager:CheckPlayerLevelUpGuide()
    local unlockTable = UnlockDataManager:Get():GetUnlockByLevelID(PlayerDataManager:Get():GetPlayerLV())--这是解锁的表

    local nextLv, nextUnlockTable = UnlockDataManager:Get():GetNextUnlockByLevelID(PlayerDataManager:Get():GetPlayerLV())--这是将要解锁的

    local funcId = {}
    if unlockTable ~= nil then
        for funcIdKey, funcIdKeyValue in pairs(unlockTable) do
            table.insert(funcId, funcIdKeyValue)
        end
    end

    local nextUnlockIdx = {}
    if nextUnlockTable ~= nil then
        for funcIdKey, funcIdKeyValue in pairs(nextUnlockTable) do
            table.insert(nextUnlockIdx, funcIdKeyValue)
        end
    end
    local funcName = ""
    local guideId=-1
    if #funcId > 0 then
        for i = 1, #funcId do
            ---@type functionlist_config_cell
            local cfg = nil
            if ClientDataManager:Get().IsConfig2 then
                cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist2_config, funcId[i])
            else
                cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist_config, funcId[i])
            end
            local format = i ~= #funcId and "%s," or "%s"
            funcName = string.format("%s%s", funcName, string.format(format, CommonHelper:GetTempStr_Default(cfg.name)))
            if cfg.newbieguideId~=-1 and guideId==-1 then
                guideId=cfg.newbieguideId
            end
        end
    end

    local nextFuncName = ""
    if #nextUnlockIdx > 0 then
        for i = 1, #nextUnlockIdx do
            ---@type functionlist_config_cell
            local cfg = nil
            if ClientDataManager:Get().IsConfig2 then
                cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist2_config, nextUnlockIdx[i])
            else
                cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist_config, nextUnlockIdx[i])
            end

            local format = i ~= #nextUnlockIdx and "%s," or "%s"

            nextFuncName = string.format("%s%s", nextFuncName, string.format(format, CommonHelper:GetTempStr_Default(cfg.name)))
        end
    end
    if nextLv then
        return  guideId,funcId,nextUnlockIdx,funcName,nextFuncName,string.format(CommonHelper:GetTempStr_Default(TemplateStringID.LevelUp), nextLv)
    end
    return  guideId,funcId,nextUnlockIdx,funcName,nextFuncName
end


function PlayerDataManager:ClearData()
    self.PlayerData=PlayerData()
end
























function PlayerDataManager:OnInitBaseData(msg)
    self.PlayerData:OnInitBaseData(msg)
end
function PlayerDataManager:OnInitPartData(msg)
    self.PlayerData:OnInitPartData(msg)
    StaminaDataManager:Get():StartIncreaseStamina()
end

function PlayerDataManager:IsAlreadyRemovedFreePhysicalPower(index)
    return self.PlayerData.freePhysicalPower[index]==1
end

function PlayerDataManager:SetFreePhysicalPower(index,value)
    self.PlayerData.freePhysicalPower[index]=value
end

---返回补签次数
function PlayerDataManager:GetRetroactiveMonthSign()
    return self.PlayerData.MonthSign
end

---设置补签次数
function PlayerDataManager:SetRetroactiveMonthSign(value)
     self.PlayerData.MonthSign = value
end
function PlayerDataManager:CheckPlayerBindData(callback)
    if not HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.GameBind) then
        callback()
        return
    end
    if self:GetBindData()~=nil and self:GetBindData().wdRid~=0  then
        callback()
    else
        local boxFunc = function()
            local tips=CommonHelper:GetTempStr_Default(TemplateStringID.CheckPlayerIsBindDataIsNull)
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotEnter_Tittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
            if ret == MessageBoxHelp.BtnType.OK then
                PlayerInfoSubsystem:Get():SendMsg_GetBindInfo()
            else
                callback()
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end
end

---@param kickedType KickedType
function PlayerDataManager:KickedByType(kickedType)
    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, function()
        local content = CommonHelper:GetKickTipsByKickType(kickedType)

        CommonHelper:LoginTipPop(content, CommonHelper:GetTempStr_Default(TemplateStringID.OK), function()
            if kickedType == KickedType.UpdateExit then
                CommonHelper:ApplicationQuit()
            --else
            --    SDKManager:Get():Login()
            end
        end)
    end, false)
end
