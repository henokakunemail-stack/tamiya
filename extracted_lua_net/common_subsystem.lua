---@class CommonSubsystem
CommonSubsystem = class("CommonSubsystem")

function CommonSubsystem:initialize(...)
    --NetResponseEventManager:Get():AddListener(MsgID.SYNC_SYS_TIME_S2C_RES, self, self.RecvMsg_CheckServerTime)
    --NetResponseEventManager:Get():AddListener(MsgID.GLOBAL_ENTER_RANK_RACE_NOTIFY, self, self.RecvMsg_JoinRoom)
    --NetResponseEventManager:Get():AddListener(MsgID.ENTER_ROOM_SB2C_RES, self, self.RecvMsg_GetBattleRoomInfo)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_RACE_RECORDS_S2C_RES, self, self.RecvMsg_GetHistoryList)
    --NetResponseEventManager:Get():AddListener(MsgID.PING_SYNC_SYS_TIME_G2C_RES, self, self.RecvMsg_BattlePingServerTime)
    NetResponseEventManager:Get():AddListener(MsgID.GET_RACE_RECORD_S2C_RES, self, self.RecvMsg_RePlayBattle)

    NetResponseEventManager:Get():AddListener(MsgID.BUY_DIRECT_S2C_RES, self, self.RecvMsg_BuyDirect)  --道具直购
    NetResponseEventManager:Get():AddListener(MsgID.RET_CHARGE_S2C_RES, self, self.RecvMsg_ShowCharge)
    NetResponseEventManager:Get():AddListener(MsgID.RET_DIRECT_ALERT_S2C_RES, self, self.RecvMsg_DirectAlert)

    NetResponseEventManager:Get():AddListener(MsgID.TEST_GIFT_S2C_RES, self, self.RecvMsg_TestGift)
    NetResponseEventManager:Get():AddListener(MsgID.RUN_FALSE_S2C_RES, self, self.RecvMsg_RunFalse)

    NetResponseEventManager:Get():AddListener(MsgID.EX_CH_GOLD_S2C_RES, self, self.RecvMsg_ExChGold)  --道具直购

    self.IsLoadRankData=false
end

function CommonSubsystem:SendMsg_CheckServerTime()
    local state = ClientDataManager:Get():GetGameState()
    if state == GameState.Login_GameServer then
        NetManager:Get():Send(OldMsgID.SYNC_SYS_TIME_C2S_REQ, "")
    end
end
function CommonSubsystem:RecvMsg_CheckServerTime(data)
    local msg = assert(Dll_PB.decode("SyncSystemTimeRes", data))
    print(ProtoMsgHelp.block(msg))

    local leftTime = ChatDataManager:Get():GetLeftChatTime()
    local leftBanTime = PlayerDataManager:Get():GetBanTalkLeftTimeNow()

    CommonHelper:SetServerTime(msg.systemTime)

    --NetEaseDataManager:Get():StartAasCount()
    StaminaDataManager:Get():StartIncreaseStamina()
    PlayerDataManager:Get():SetBanTalkLeftTime(leftBanTime)
    ChatDataManager:Get():UpdateTime(leftTime)
    RecruitDataManager:Get():StartAllCountTime()
    --NetEaseDataManager:Get():SetDetectLoginSuccessTime(CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + NetEaseDataManager:Get():GetDetectRandomTime())
end

function CommonSubsystem:RecvMsg_BattlePingServerTime(data)
    local msg = assert(Dll_PB.decode("SyncSystemTimeRes", data))
    --print(ProtoMsgHelp.block(msg))

    mono.SyncServerTime(msg.systemTime)
end

--{{{战斗服_加入房间成功
function CommonSubsystem:RecvMsg_JoinRoom(data)
    ---@type SC_GlobaEnterRaceNotify
    local msg = assert(Dll_PB.decode("GlobaEnterRaceNotify", data))
    print(ProtoMsgHelp.block(msg))

    MatchManager:Get():SetConnectFlag(RaceRankReconnectFlag.Normal)
    MatchManager:Get():InitData(msg.ip, msg.port, msg.type, msg.session)

    NetManager:Get():ConnectSyncBattleServer()
end
--}}}


--{{{战斗服_请求房间数据
function CommonSubsystem:SendMsg_GetBattleRoomInfo()
    local reqData = {
        pid = PlayerDataManager:Get():GetPlayerUID(),
        session = MatchManager:Get():GetSession(),
        type = MatchManager:Get():GetType(),
        flag = MatchManager:Get():GetConnectFlag()
    }
    local reqBytes = assert(Dll_PB.encode("EnterRoomReq", reqData))
    NetManager:Get():SendSyncBattleServer(OldMsgID.ENTER_ROOM_C2SB_REQ, reqBytes)

    MatchManager:Get():ClearData()
end
--}}}


--{{{道具直购


function CommonSubsystem:SendMsg_BuyDirect(propid, num, coinid)
    local msg_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), propid, num ,coinid})
    NetManager:Get():Send(MsgID.BUY_DIRECT_C2S_REQ, msg_data)
end

function CommonSubsystem:RecvMsg_BuyDirect(data)
    ---@type SC_buyDirect
    local msg = assert(Dll_PB.decode("buyDirect", data))
    print(ProtoMsgHelp.block(msg))

    UserDirectManager:Get():GetDataByID(msg.buyPropId, msg.coinid).curnum = msg.buynum
    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)

    if msg.buyPropId==CommonHelper:GetDictCalcData( GlobalValueKey.PowerArticleCfgID) then
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.downsome)
        UINotify:Get():SendNotification(UINotifyEvent.StaminaView_UpdateData,true)
    else
        --CommonHelper:ShowGetRewardDataBySomeDown(msg.downsome)
        CommonHelper:ShowGetRewardDataBySomeDown(msg.downsome, false, function()
            if UIManager:Get():IsViewShow("RecruitView") then
                UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitViewInfo)
            end
        end)
    end

    --UINotify:Get():SendNotification(UINotifyEvent.BuyDirectViewRefresh)
end

function CommonSubsystem:SendMsg_ShowCharge()
    --CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default("钻石不足"))
    local msg_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.REQ_CHARGE_C2S_REQ, msg_data)
end

function CommonSubsystem:RecvMsg_ShowCharge(data)
    ---@type SC_DirectCharge
    local msg = assert(Dll_PB.decode("DirectCharge", data))
    print(ProtoMsgHelp.block(msg))

    ChargeTipsDataManager:Get():SetChargeStateData(msg.chargeItems)

    UIManager:Get():OpenPopup("ChargeTipsView", CanvasType.FrontCanvas, "ChargeTipsView", false)
    UINotify:Get():SendNotification(UINotifyEvent.ChargeTipsSetData)

end

function CommonSubsystem:SendMsg_DirectAlert(propID, coinID, ifAlert)
    local msg_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), propID, coinID, ifAlert })
    NetManager:Get():Send(MsgID.REQ_DIRECT_ALERT_C2S_REQ, msg_data)
end

function CommonSubsystem:RecvMsg_DirectAlert(data)
    ---@type SC_UserDirect
    local msg = assert(Dll_PB.decode("UserDirect", data))
    print(ProtoMsgHelp.block(msg))

    UserDirectManager:Get():SetUserDirectDataByID(msg)
    UINotify:Get():SendNotification(UINotifyEvent.RecruitGoViewRefreshAlert, msg)

end

function CommonSubsystem:SendMsg_TestGift()
    local msg_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.TEST_GIFT_C2S_REQ, msg_data)
end

function CommonSubsystem:RecvMsg_TestGift(data)
    ---@type SC_TestCharge
    local msg = assert(Dll_PB.decode("TestCharge", data))
    print(ProtoMsgHelp.block(msg))

    PlayerDataManager:Get():SetTestGiftFlag(msg.testGiftFlag)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.mySomeDown, true)
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_RefreshTestGift)

end

--}}}

--{{{钻石换金币

--179, --请求点金手 P2=次数
function CommonSubsystem:SendMsg_ExChGold(num)
    local msg_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), num })
    NetManager:Get():Send(MsgID.EX_CH_GOLD_C2S_REQ, msg_data)
end

--180, --返回点金结果
function CommonSubsystem:RecvMsg_ExChGold(data)
    ---@type SC_ExchGold
    local msg = assert(Dll_PB.decode("ExchGold", data))
    print(ProtoMsgHelp.block(msg))

    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)
    PlayerDataManager:Get():UpdateExChGold(msg.exchgold)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downsome, true)
    BuyGoldDataManager:Get():UpdateBuyGoldData(msg.dispDown)
    UINotify:Get():SendNotification(UINotifyEvent.UpdateBuyGoldView)

end

--}}}

--{{{赛事_获取历史记录
function CommonSubsystem:SendMsg_GetHistoryList(type)
    local reqData = {
        type = type,
    }
    local reqBytes = assert(Dll_PB.encode("GetRecordsReq", reqData))
    NetManager:Get():Send(OldMsgID.GET_RACE_RECORDS_C2S_REQ, reqBytes)
end
function CommonSubsystem:RecvMsg_GetHistoryList(data)
    ---@type SC_GetRecordsRes
    local msg = assert(Dll_PB.decode("GetRecordsRes", data))
    print(ProtoMsgHelp.block(msg))

    if msg.type == SerE_RaceHistoryModuleType.Room then
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomHistoryView_SetData, msg)
    end

    if msg.type == SerE_RaceHistoryModuleType.Rank then
        UINotify:Get():SendNotification(UINotifyEvent.RaceRankHistoryView_SetData, msg)
    end
end
--}}}


--{{{请求战斗回放
---@param type SerE_RecordType
---@param flag ReplayFlag
function CommonSubsystem:SendMsg_RePlayBattle(recordid,seasonid,type)
    local reqBytes=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),recordid,seasonid,type})
    NetManager:Get():Send(MsgID.GET_RACE_RECORD_C2S_REQ, reqBytes)
end
function CommonSubsystem:RecvMsg_RePlayBattle(data)
    ---@type SC_RetPVPRecord
    local msg = assert(Dll_PB.decode("RetPVPRecord", data))
    print(ProtoMsgHelp.block(msg))
    RankListTestVerifyDataManager:Get():SetLookVersion(msg.start.ver)
    cs_coroutine.start(function()
        if UIManager:Get():IsPopViewShow("RankingListView") or UIManager:Get():IsPopViewShow("DebugView") then
            UIManager:Get():ClosePopup()
            coroutine.yield()
        end
        RaceRankManager:Get():SetRaceType(RaceRankRaceType.Record)
        if msg.start.race[1]==nil or CommonHelper:IsNullOrEmpty(msg.start.race[1].op) then
            PlayerPrefsHelper:SetValue_ReplayInputInfos("")
        else
            PlayerPrefsHelper:SetValue_ReplayInputInfos(msg.start.race[1].op)
        end
        RaceRankManager:Get():LoadBattleScene(msg,true)
    end)



    --local temp = RaceHistoryData()
    --temp:SetData(msg.record, msg.flag)
    --if msg.type==SerE_RecordType.Rank then
    --    BattleDataManager:Get():SetRoomData(temp, RaceModel.RaceReplay_Rank)
    --    local scenename = BattleDataManager:Get():GetSceneName()
    --    local trackdata = BattleDataManager:Get():GetTrackData()
    --    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceReplay_Rank)
    --end
    --if msg.type==SerE_RecordType.Default then
    --    BattleDataManager:Get():SetRoomData(temp, RaceModel.RaceReplay_Pve)
    --    local scenename = BattleDataManager:Get():GetSceneName()
    --    local trackdata = BattleDataManager:Get():GetTrackData()
    --    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceReplay_Pve)
    --end

end
--}}}

function CommonHelper:PlayLocalBattle()
    local startbattle_config_cell= CommonHelper:GetTableDataByID(ConfigNames.startbattle_config,GuideBattleId)
    local temp=RaceLocalData()
    temp:SetData(startbattle_config_cell)
    PveLevelTestBattleDataManager:Get():AddLevelData(temp)
    PveLevelTestBattleDataManager:Get():PopLevelData()
end

function CommonHelper:RaceTrackTestRun(trackdata,carIdx)
    local temp=RaceLocalData()
    temp:SetDataTestRun(trackdata,carIdx)
    BattleDataManager:Get():SetRoomData(temp, RaceModel.CustomTestBattle)
    local scenename = temp:GetSceneName()
    local trackdata = temp:GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.CustomTestBattle)
end

function CommonHelper:PlayLevelBattleMore(id,defaultNpc)
    PveLevelTestBattleDataManager:Get():Clear()
    CS.MonoHelper.CheckLevelFileExist()
    ---@type pvelevel_config
    local pvelevel_config= ClientDataManager:Get():GetDataTable(ConfigNames.pvelevel_config)
    local tempList={}
    for k,v in pairs(pvelevel_config.GetConfigData())  do
        if v.copytype~=LevelType.Story and v.C_ID>=id then
            for i, m in ipairs(v.BattleInfoList) do
                local temp=RaceLocalData()
                temp:SetDataByLevelData(v.C_ID.."_"..i,m,defaultNpc)
                table.insert(tempList,temp)
            end
        end
    end
    if #tempList<=0 then
        CommonTipsHelper:Get():ShowCenterTips("一搏同学输入错了"..id)
        return
    end

    table.sort(tempList,function(a, b)
        return a.LevelId>b.LevelId
    end)
    for i = 1, #tempList do
        PveLevelTestBattleDataManager:Get():AddLevelData(tempList[i])
    end
   PveLevelTestBattleDataManager:Get():PopLevelData()
end

function CommonHelper:PlayLevelBattleOne(id,index,defaultNpc)
    PveLevelTestBattleDataManager:Get():Clear()
    CS.MonoHelper.CheckLevelFileExist()
    ---@type pvelevel_config
    local pvelevel_config= ClientDataManager:Get():GetDataTable(ConfigNames.pvelevel_config)
    local tempList={}
    for k,v in pairs(pvelevel_config.GetConfigData())  do
        if v.copytype~=LevelType.Story and v.C_ID==id then
            for i, m in ipairs(v.BattleInfoList) do
                local temp=RaceLocalData()
                temp:SetDataByLevelData(v.C_ID.."_"..i,m,index,defaultNpc)
                table.insert(tempList,temp)
            end
        end
    end
    if #tempList<=0 then
        CommonTipsHelper:Get():ShowCenterTips("一搏同学输入错了"..id)
        return
    end

    table.sort(tempList,function(a, b)
        return a.LevelId>b.LevelId
    end)
    for i = 1, #tempList do
        PveLevelTestBattleDataManager:Get():AddLevelData(tempList[i])
    end
   PveLevelTestBattleDataManager:Get():PopLevelData()
end
function CommonHelper:PlayRaceSeniorTrainBattleMore(id,defaultNpc)
    PveLevelTestBattleDataManager:Get():Clear()
    CS.MonoHelper.CheckLevelFileExist()
    ---@type pvelevel_config
    local pvelevel_config= ClientDataManager:Get():GetDataTable(ConfigNames.dicthidecopy_config)
    local tempList={}
    for k,v in pairs(pvelevel_config.GetConfigData())  do
        if v.copytype~=LevelType.Story and v.C_ID>=id then
            for i, m in ipairs(v.BattleInfoList) do
                local temp=RaceLocalData()
                temp:SetDataByLevelData(v.C_ID.."_"..i,m,defaultNpc)
                table.insert(tempList,temp)
            end
        end
    end
    if #tempList<=0 then
        CommonTipsHelper:Get():ShowCenterTips("一搏同学输入错了"..id)
        return
    end

    table.sort(tempList,function(a, b)
        return a.LevelId>b.LevelId
    end)
    for i = 1, #tempList do
        PveLevelTestBattleDataManager:Get():AddLevelData(tempList[i])
    end
   PveLevelTestBattleDataManager:Get():PopLevelData()
end

function CommonHelper:PlayRaceSeniorTrainBattleOne(id,defaultNpc)
    PveLevelTestBattleDataManager:Get():Clear()
    CS.MonoHelper.CheckLevelFileExist()
    ---@type pvelevel_config
    local pvelevel_config= ClientDataManager:Get():GetDataTable(ConfigNames.dicthidecopy_config)
    local tempList={}
    for k,v in pairs(pvelevel_config.GetConfigData())  do
        if v.copytype~=LevelType.Story and v.C_ID==id then
            for i, m in ipairs(v.BattleInfoList) do
                local temp=RaceLocalData()
                temp:SetDataByLevelData(v.C_ID.."_"..i,m,defaultNpc)
                table.insert(tempList,temp)
            end
        end
    end
    if #tempList<=0 then
        CommonTipsHelper:Get():ShowCenterTips("一搏同学输入错了"..id)
        return
    end

    table.sort(tempList,function(a, b)
        return a.LevelId>b.LevelId
    end)
    for i = 1, #tempList do
        PveLevelTestBattleDataManager:Get():AddLevelData(tempList[i])
    end
   PveLevelTestBattleDataManager:Get():PopLevelData()
end

function CommonHelper:PlayActivityLevelBattleMore(id,defaultNpc)
    PveLevelTestBattleDataManager:Get():Clear()
    CS.MonoHelper.CheckLevelFileExist()
    ---@type pvelevel_config
    local pvelevel_config= ClientDataManager:Get():GetDataTable(ConfigNames.dictactivitycopy_config)
    local tempList={}
    for k,v in pairs(pvelevel_config.GetConfigData())  do
        if v.copytype~=LevelType.Story and v.C_ID>=id then
            for i, m in ipairs(v.BattleInfoList) do
                local temp=RaceLocalData()
                temp:SetDataByLevelData(v.C_ID.."_"..i,m,defaultNpc)
                table.insert(tempList,temp)
            end
        end
    end
    if #tempList<=0 then
        CommonTipsHelper:Get():ShowCenterTips("一搏同学输入错了"..id)
        return
    end
    table.sort(tempList,function(a, b)
        return a.LevelId>b.LevelId
    end)
    for i = 1, #tempList do
        PveLevelTestBattleDataManager:Get():AddLevelData(tempList[i])
    end
   PveLevelTestBattleDataManager:Get():PopLevelData()
end

function CommonHelper:PlayActivityLevelBattleOne(id,defaultNpc)
    PveLevelTestBattleDataManager:Get():Clear()
    CS.MonoHelper.CheckLevelFileExist()
    ---@type pvelevel_config
    local pvelevel_config= ClientDataManager:Get():GetDataTable(ConfigNames.dictactivitycopy_config)
    local tempList={}
    for k,v in pairs(pvelevel_config.GetConfigData())  do
        if v.copytype~=LevelType.Story and v.C_ID==id then
            for i, m in ipairs(v.BattleInfoList) do
                local temp=RaceLocalData()
                temp:SetDataByLevelData(v.C_ID.."_"..i,m,defaultNpc)
                table.insert(tempList,temp)
            end
        end
    end
    if #tempList<=0 then
        CommonTipsHelper:Get():ShowCenterTips("一搏同学输入错了"..id)
        return
    end

    table.sort(tempList,function(a, b)
        return a.LevelId>b.LevelId
    end)
    for i = 1, #tempList do
        PveLevelTestBattleDataManager:Get():AddLevelData(tempList[i])
    end
   PveLevelTestBattleDataManager:Get():PopLevelData()
end
function CommonHelper:PlayLevelBattleOneByRaceLocalData(data)
    PveLevelTestBattleDataManager:Get():Clear()
    CS.MonoHelper.CheckLevelFileExist()
    PveLevelTestBattleDataManager:Get():AddLevelData(data)
    PveLevelTestBattleDataManager:Get():PopLevelData()
end







function CommonHelper:SetSpeedChange()
    CarSpeedChange:Clear()
    local startbattle_config_cell= CommonHelper:GetTableDataByID(ConfigNames.startbattle_config,GuideBattleId)
    local npcs =stringSplitToNumber(startbattle_config_cell.npcs,',')
    for i = 1, #npcs do
        ---@type npc_config_cell
        local npc_config_cell= CommonHelper:GetTableDataByID(ConfigNames.dictnpc_config,npcs[i])
        if npc_config_cell then
            CarSpeedChange:SetData(npc_config_cell.attr1,npc_config_cell.attr2)
        end
    end
end

function CommonSubsystem:SendMsg_RunFalse(lookid,type,resultTime,rankSpeed,lookVersion,version,serverId,BattleResult,addType)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() ,lookid,type,resultTime,rankSpeed,lookVersion,version,serverId,BattleResult,addType})
    NetManager:Get():Send(MsgID.RUN_FALSE_C2S_REQ, data)
end

function CommonSubsystem:RecvMsg_RunFalse(data)


end

local __subsystem = CommonSubsystem()
function CommonSubsystem:Get()
    return __subsystem
end
return __subsystem