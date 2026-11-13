local __instance = nil

---@class MsgErrorManager
MsgErrorManager = class("MsgErrorManager")

---@return MsgErrorManager
function MsgErrorManager:Get()
    if __instance == nil then
        __instance = MsgErrorManager()
    end
    return __instance
end
function MsgErrorManager:initialize()
    self.EvtMap = {}
    self.MsgIDEvtMap = {}
    self.ShowTips=true
end
function MsgErrorManager:Clear()
    self.EvtMap = {}
    self.MsgIDEvtMap = {}
end

function MsgErrorManager:Init()
    self:RegistEvtByMsgId(ErrorCode.LOGIN_REPEAT, MsgErrorManager.Evt_LoginRepeat)
    self:RegistEvtByMsgId(ErrorCode.CHARGE_ORDER_FAILED, MsgErrorManager.Evt_ChargerOderFailed)
    self:RegistEvtByMsgId(ErrorCode.GameServerNoOpen, MsgErrorManager.Evt_GameServerNoOpen)
    self:RegistEvtByMsgId(ErrorCode.LOGIN_BE_OVERDUE, MsgErrorManager.Evt_PlayerBeOverdue)
    self:RegistEvtByMsgId(ErrorCode.PLAYER_BAN_LOGIN, MsgErrorManager.Evt_PlayerBanLogin)
    self:RegistEvtByMsgId(ErrorCode.PLAYER_ILLEGAL_LOGIN, MsgErrorManager.Evt_PlayerIllegalLogin)
    self:RegistEvtByMsgId(ErrorCode.CREATE_NICK_REPETITION, MsgErrorManager.Evt_SendLog)
    self:RegistEvtByMsgId(ErrorCode.PART_REFORM_ERROR, MsgErrorManager.Evt_PartReformError)
    self:RegistEvtByMsgId(ErrorCode.RANK_MATCH_ERROR, MsgErrorManager.Evt_MatchErrorBackToRaceView)
    self:RegistEvtByMsgId(ErrorCode.RANK_MATCH_ERROR_2, MsgErrorManager.Evt_MatchErrorBackToRaceView)
    self:RegistEvtByMsgId(ErrorCode.RANK_MATCH_ERROR_3, MsgErrorManager.Evt_MatchErrorBackToRaceView)
    self:RegistEvtByMsgId(ErrorCode.RANK_TROT_ERROR, MsgErrorManager.Evt_TrotErrorBackToRaceView)
    self:RegistEvtByMsgId(ErrorCode.RANK_BATTLE_ERROR_1, MsgErrorManager.Evt_RankBattleError)
    self:RegistEvtByMsgId(ErrorCode.RANK_BATTLE_ERROR_2, MsgErrorManager.Evt_RankBattleError)
    self:RegistEvtByMsgId(ErrorCode.RANK_GVG_NO_SEASON, MsgErrorManager.Evt_RaceGvgError)
    self:RegistEvtByMsgId(ErrorCode.RANK_BATTLE_ERROR_3, MsgErrorManager.Evt_RankBattleError)
    self:RegistEvtByMsgId(ErrorCode.RANK_BATTLE_ERROR_4, MsgErrorManager.Evt_RankBattleErrorCheat)
    self:RegistEvtByMsgId(ErrorCode.APPLICATION_PLAYER_QUIT, MsgErrorManager.Evt_ApplicationPlayerQuit)
    self:RegistEvtByMsgId(ErrorCode.LOGIN_VERSION_NOT, MsgErrorManager.Evt_LoginVersionNot)
    self:RegistEvtByMsgId(ErrorCode.RANK_TOP_NO_SEASON, MsgErrorManager.Evt_RaceTopNoSeason)
    self:RegistEvtByMsgId(ErrorCode.RANK_TOP_NO_PEOPLE_JOIN, MsgErrorManager.Evt_RaceTopNoSeason)
    self:RegistEvtByMsgId(ErrorCode.SQL_ERROR_BAN_PLAYER, MsgErrorManager.Evt_SqlErrorBanPlayer)
    self:RegistEvtByMsgId(ErrorCode.RECRUIT_NO_ENOUGH, MsgErrorManager.Evt_RecruitNoEnough)
    self:RegistEvtByMsgId(ErrorCode.MSG_IDX_ERROR, MsgErrorManager.Evt_MsgIdxError)
    self:RegistEvtByMsgId(ErrorCode.RECORD_NO_DATA, MsgErrorManager.Evt_RecordNoData)
    self:RegistEvtByMsgId(ErrorCode.REPET_SEND, MsgErrorManager.Evt_REPET_SEND)
    self:RegistEvtByMsgId(ErrorCode.RACE_SUPER_NO_OPEN, MsgErrorManager.Evt_RACESUPER_ERROR)
    self:RegistEvtByMsgId(ErrorCode.ACT_LUCK_TABLE_NO_ENOUGH, MsgErrorManager.Evt_ACT_LUCK_TABLE_NO_ENOUGH)
end

function MsgErrorManager:RegistEvt(code, evt, param)
    if self.EvtMap[code] ~= nil then
        print("---   error:MsgErrorManager   重复注册", code)
        return
    end

    local tab = {}
    tab[1] = evt
    tab[2] = nil
    tab[3] = param
    self.EvtMap[code] = tab
end
function MsgErrorManager:RegistEvtByMsgId(msgid, evt, param)
    if self.MsgIDEvtMap[msgid] ~= nil then
        print("---   error:MsgErrorManager   重复注册", msgid)
        return
    end

    local tab = {}
    tab[1] = evt
    tab[2] = self
    tab[3] = param
    self.MsgIDEvtMap[msgid] = tab
end

function MsgErrorManager:TouchEvt(code,codeparam)
    print("错误码", code)
    if self.MsgIDEvtMap[code] then
        local tab = self.MsgIDEvtMap[code]
        if tab then
            local evt = tab[1]
            local class = tab[2]
            local param = tab[3]
            if codeparam then
                param=codeparam
            end
            if evt then
                if class then
                    evt(class, param)
                else
                    evt(param)
                end
            end
        end
    end
    local str = CommonHelper:GetTempStr_Default(tostring(code))
    if ErrorCodeNoTip[code] == nil and self.ShowTips then
        if CommonHelper:IsNullOrEmpty(str) then
            CommonTipsHelper:Get():ShowCenterTips(string.format("数据错误=%d", code))
            return false
        else
            CommonTipsHelper:Get():ShowCenterTips(str)
            return true
        end
    end
    self.ShowTips=true
end

function MsgErrorManager:HttpMsgError(errorcode)
    if errorcode == nil then
        logError("---   http协议错误码格式错误   result = nil")
        return false
    end

    if type(errorcode) ~= "number" then
        logError("---   http协议错误码格式错误   不是number类型")
        return false
    end

    if errorcode == 0 then
        return true
    end

    if ErrorCodeNoTip[errorcode] == nil then
        local str = ClientDataManager:Get():GetTemplateString(tostring(errorcode), false)
        if str == "" then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.HttpErrorException, errorcode))
        else
            CommonTipsHelper:Get():ShowCenterTips(str)
        end
    end

    MsgErrorManager:Get():TouchEvt(errorcode)
    return false
end
function MsgErrorManager:HttpError(errorCode)
    local errorTable = {

        ["HTTP_-1"] = CommonHelper:GetTempStr_Default(TemplateStringID.HTTP_1),
        ["HTTP_2"] = CommonHelper:GetTempStr_Default(TemplateStringID.HTTP_2),
        ["HTTP_4"] = CommonHelper:GetTempStr_Default(TemplateStringID.HTTP_4),
        ["HTTP_5"] = CommonHelper:GetTempStr_Default(TemplateStringID.HTTP_5),
        ["HTTP_6"] = CommonHelper:GetTempStr_Default(TemplateStringID.HTTP_6),
        ["HTTP_7"] = CommonHelper:GetTempStr_Default(TemplateStringID.HTTP_7),
        ["HTTP_404"] = CommonHelper:GetTempStr_Default(TemplateStringID.HTTP_404),

    }
    if errorCode == nil then
        logError("---   http协议错误码格式错误   result = nil")
        return false
    end

    if type(errorCode) ~= "number" then
        logError("---   http协议错误码格式错误   不是number类型")
        return false
    end

    if errorCode == 3 then
        return true
    end
    if ErrorCodeNoTip[errorCode] == nil then
        ---@type templetstring_config_cell
        --local cfg = CommonHelper:GetTableDataByID(ConfigNames.templetstring_config, )
        local errorString = errorTable[string.format("HTTP_%s", tostring(errorCode))]
        if errorString then
            CommonTipsHelper:Get():ShowCenterTips(errorString)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.HttpErrorError, errorString))
        end
    end
    -- MsgErrorManager:Get():TouchEvt(errorCode, -1)
    return false
end

function MsgErrorManager:Evt_LoginRepeat()
    logError("---   error:Evt_SyncBattleResultError   顶号")
    PlayerDataManager:Get():SetPlayerSDKLogoutType(SDKLogoutType.DingHao)
   -- NetManager:Get():DisconnectGameServer()
    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, function()
        CommonHelper:LoginTipPop(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1009), CommonHelper:GetTempStr_Default(TemplateStringID.OK), function()
            UnifySDKHelper:Account_Login(false)
        end)
    end, false)
end
function MsgErrorManager:Evt_GameServerNoOpen()
    if SDKHelper:Get():ChickSdk() then
        NetManager:Get():DisconnectLoginServer()
    end

    if CommonHelper:IsNullOrEmpty(GameProperties.maintainUrl) then
        CommonTipsHelper:Get():ShowPushTips(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1001))
        return
    end
    NetManager:Get():SendHttpGet_GetAnnouncement(GameProperties.maintainUrl, function(data)
        local boxfunc = function()
            local text = data
            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text, ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
            if ret == MessageBoxHelp.BtnType.OK then
                if SDKHelper:Get():ChickSdk() then
                    UINotify:Get():SendNotification(UINotifyEvent.GameStartView_ReOpenServerInfo)
                else

                end
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end)
end

function MsgErrorManager:Evt_PlayerBeOverdue()
    logError("----   Session过期 返回登录")
    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, function()
        local boxfunc = function()
            local text =  CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1010)
            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,text,  CommonHelper:GetTempStr_Default(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
            if ret == MessageBoxHelp.BtnType.OK then

            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end, true)
end
function MsgErrorManager:Evt_PlayerBanLogin()
    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, function()
        local boxfunc = function()
            local text = CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1011)
            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text,CommonHelper:GetTempStr_Default(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
            if ret == MessageBoxHelp.BtnType.OK then

            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end, true)
end
function MsgErrorManager:Evt_SqlErrorBanPlayer()
    logError("----》》》》》》》》》》  用户被封号了")
    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, function()
        local boxfunc = function()
            local text = CommonHelper:GetTempStr_Default(TemplateStringID.BanPlayerSQLError)
            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text,CommonHelper:GetTempStr_Default(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
            if ret == MessageBoxHelp.BtnType.OK then
                UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitCG, false)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end, true)
end


function MsgErrorManager:Evt_NoRankSession()
    logError("----》》》》》》》》》》  排位赛没有赛季")

end
function MsgErrorManager:Evt_RecruitNoEnough()

    UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitBtn, true)
end
function MsgErrorManager:Evt_MsgIdxError()

   CommonHelper:PlayScreenEffectNull(false)
end
function MsgErrorManager:Evt_RecordNoData()
    RankListTestVerifyDataManager:Get().Recording=false
    if CommonSubsystem:Get().IsLoadRankData then
        local LastType=RaceRankManager:Get():GetLastType()
        local result="回放数据删除"
        if RaceRankManager:Get().RecordData==nil then
            RaceRankManager:Get().RecordData={}
        end
        local serverName=PlayerDataManager:Get():GetPlayerServerID()
        if RankingListDataManager:Get().CurValue[4]==RaceProtectType.Normal then
            serverName=serverName.."_挑战"
        else
            serverName=serverName.."_保护"
        end
        CS.MonoHelper.AppendToRankListFileExist(serverName,result.."\n")
        CS.MonoHelper.AppendToRankListFileExist(serverName,RankingListDataManager:Get().CurValue[1].."_"..RankingListDataManager:Get().CurValue[2].."_"..RankingListDataManager:Get().CurValue[5].."\n")
        CS.MonoHelper.AppendToRankListFileExist(serverName,"-------------------------------------------\n")
        table.insert(RaceRankManager:Get().RecordData,result)
        if RankingListDataManager:Get().Rids:GetSize()>0 then
            RankingListDataManager:Get().CurValue=RankingListDataManager:Get().Rids:DeQueueFront()
            cs_coroutine.start(function()
                coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
                LastType=RankingListDataManager:Get().CurValue[4]
                CommonSubsystem:SendMsg_RePlayBattle(RankingListDataManager:Get().CurValue[1],RankingListDataManager:Get().CurValue[3],RankingListDataManager:Get().CurValue[4])
            end)
        else
            if LastType==RaceProtectType.Normal then
                if RankListTestVerifyDataManager:Get():GetIsVerify() then
                    RankListTestVerifyDataManager:Get():LoginRlSpeedRankData()
                end
            end
            if LastType==RaceProtectType.Protect then
                if RankListTestVerifyDataManager:Get():GetIsVerify() then
                    RankListTestVerifyDataManager:Get():Done()
                end
            end

        end
    end
end
function MsgErrorManager:Evt_REPET_SEND()

    if RankListTestVerifyDataManager:Get():GetIsVerify() then
        RaceRankManager:Get():ReSend()
    end
end
function MsgErrorManager:Evt_RACESUPER_ERROR()
    if UIManager:Get():IsViewShow("RaceSuperBattleListView") or UIManager:Get():IsViewShow("RaceSuperBattleView") then
       SkipModuleHelper:Get():ToMainMenuView(false)
    end
end
function MsgErrorManager:Evt_ACT_LUCK_TABLE_NO_ENOUGH()
    CommonHelper:CloseGuideScreenEffectUIMask()
end

function MsgErrorManager:Evt_PlayerIllegalLogin()

    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, function()
        local boxfunc = function()
            local text =  CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1015)
            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text, CommonHelper:GetTempStr_Default(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
            if ret == MessageBoxHelp.BtnType.OK then

            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end, true)
end

function MsgErrorManager:Evt_ChargerOderFailed()
    logError("---   error:Evt_ChargerOderFailed   发货失败请重试")
    SDKHelper:Get():ReSend()
end


function MsgErrorManager:Evt_SendLog()
    QuickTa:Get():TrackEvent(TrackEventNames.CreateNicknameFailure)
end
function MsgErrorManager:Evt_PartReformError(param)
    ---@type grooveid_config_cell
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.grooveid_config,param)
    if cfg then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(cfg.noticeerror))
    else
        local str = CommonHelper:GetTempStr_Default(tostring(ErrorCode.PART_REFORM_ERROR))
        CommonTipsHelper:Get():ShowCenterTips(str)
    end
end


function MsgErrorManager:Evt_MatchErrorBackToRaceView()
    if BattleDataManager:Get():IsFighting() then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceView,false,true)
        BattleDataManager:Get():SetStateBattleExit()
    else
        SkipModuleHelper:Get():Loading_BattleErrorToRaceView(false)
    end
end

function MsgErrorManager:Evt_TrotErrorBackToRaceView()
    if BattleDataManager:Get():IsFighting()  then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceView,false,true)
        BattleDataManager:Get():SetStateBattleExit()
    else
        SkipModuleHelper:Get():Loading_BattleErrorToRaceView(false)
    end
end


function MsgErrorManager:Evt_RankBattleError()
    if CommonHelper:CheckPlayerIsNewGuide() then
        GuideManager:Get():SwitchCurEnd()
    end
    if BattleDataManager:Get():IsFighting() then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToPVPRank)
        BattleDataManager:Get():SetStateBattleExit()
    else
        if not UIManager:Get():IsViewShow("RaceView") then
            UIManager:Get():OpenView("RaceView", CanvasType.MainCanvas, "RaceView")
        end
    end
end
function MsgErrorManager:Evt_RankBattleErrorCheat()
    if BattleDataManager:Get():IsFighting() then
        local boxfunc = function()
            local text =  CommonHelper:GetTempStr_Default(TemplateStringID.RankBattleErrorCheat)
            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text, CommonHelper:GetTempStr_Default(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
            if ret == MessageBoxHelp.BtnType.OK then
                SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToPVPRank)
                BattleDataManager:Get():SetStateBattleExit()
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    else
        if not UIManager:Get():IsViewShow("RaceView") then
            UIManager:Get():OpenView("RaceView", CanvasType.MainCanvas, "RaceView")
        end
    end
end

function MsgErrorManager:Evt_ApplicationPlayerQuit()
    local boxfunc = function()
        local text =  CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1013)
        local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text, CommonHelper:GetTempStr_Default(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
        if ret == MessageBoxHelp.BtnType.OK then
            CommonHelper:ApplicationQuit()
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxfunc)

end

function MsgErrorManager:Evt_LoginVersionNot()
    local boxfunc = function()
        local text =  CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1013)
        local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text, CommonHelper:GetTempStr_Default(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
        if ret == MessageBoxHelp.BtnType.OK then

        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxfunc)

end


function MsgErrorManager:Evt_RaceTopNoSeason()
    if UIManager:Get():IsViewShow("RaceTopView") then
        UIManager:Get():CloseView()
    end
    if UIManager:Get():IsPopViewShow("RaceTopRankingListView") then
        UIManager:Get():ClosePopup()
    end
    if UIManager:Get():IsPopViewShow("RaceTopGroupView") then
        UIManager:Get():ClosePopup()
    end
    if UIManager:Get():IsPopViewShow("RankingListRewardView") then
        UIManager:Get():ClosePopup()
    end
end


function MsgErrorManager:Evt_RaceGvgError()
    if UIManager:Get():IsViewShow("RaceGVGView") then
        UIManager:Get():CloseView()
    end
    if UIManager:Get():IsPopViewShow("RaceStateView") then
        UIManager:Get():ClosePopup()
    end
    if UIManager:Get():IsPopViewShow("RaceGVGRankListView") then
        UIManager:Get():ClosePopup()
    end
    if UIManager:Get():IsPopViewShow("RaceGVGResultView") then
        UIManager:Get():ClosePopup()
    end
end


