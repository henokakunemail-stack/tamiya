---@class GoogleSDKCallBack
GoogleSDKCallBack = class("GoogleSDKCallBack")

function GoogleSDKCallBack:Get()
    if self._instance == nil then
        self._instance = GoogleSDKCallBack()
    end
    return self._instance
end

function GoogleSDKCallBack:initialize()

end

function GoogleSDKCallBack:OnLogin(status, uid)
    --QuickSdkDataManager:Get():SetIsLoginSDK(true)
    PlayerPrefsHelper:SetValue_LoginName(uid)
    UINotify:Get():SendNotification(UINotifyEvent.GameStartView_CloseLoginPanelCG, true)
    UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitServer, nil)
    NetManager:Get():ConnectLoginServer()
    QuickTa:Get():TrackEvent(TrackEventNames.FirstLoginSucceed,nil ,TrackEventType.First)
    QuickTa:Get():TrackEvent(TrackEventNames.Login,QuickTaData:GetLogin(
            0,
            false,
            0,
            PlayerDataManager:Get():GetPlayerLV(),
            CSSystemInfo.deviceModel,
            CSSystemInfo.graphicsDeviceName,
            CSSystemInfo.operatingSystem,
            CSSystemInfo.systemMemorySize,
            mono.GetPhoneCPUName(),
            CSSystemInfo.processorCount,
            GameProperties.AverageFPS,
            GameProperties.AverageFightFPS,
            mono.isEmulator(),
            CSSystemInfo.deviceUniqueIdentifier,
            uid,
            ""
    ))
end

function GoogleSDKCallBack:OnLoginOut()
    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(false, true, nil, true)
    local data= QuickTaData:GetLogout(
            PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond),
            PlayerDataManager:Get():GetPlayerStamina(),
            PlayerDataManager:Get():GetPlayerLV(),
            PlayerDataManager:Get():GetCurrency(CurrencyType.Gold),
            0,
            0,
            0
    )
    QuickTa:Get():TrackEvent(TrackEventNames.Logout,data)
    GoogleSDKRechargeLog:Get():SendLog()
end

function GoogleSDKCallBack:OnGoogleConsumeSuccess(purchaseToken)
    CommonHelper:PlayScreenEffectWaiting(false)
    --请求发货
    print("OnGoogleConsumeSuccess---lua" .. purchaseToken)
    --ActivitySubsystem:Get():SendMsg_Purchase_Google_Shipment(purchaseToken)
end

function GoogleSDKCallBack:OnPurchaseSuccess(orderId, orderNo, goodsId, purchaseToken, packageName)
    CommonHelper:PlayScreenEffectWaiting(false)
    local logInfo = "OnGooglePurchaseSuccess:" .. orderId .. "orderNo:" .. orderNo .. "goodsId:" .. goodsId .. "purchaseToken:" .. purchaseToken .. "packageName:" .. packageName
    local JsonData = Dll_JSON.decode(orderId)
    SDKHelper:Get():AddPurchase(JsonData.cporderId, orderNo, goodsId, purchaseToken, packageName,logInfo,"JsonData.markCode",JsonData.rid)
end

function GoogleSDKCallBack:onGoogleRePaySuccess(orderId, orderNo, goodsId, purchaseToken, packageName)
    --补单
    local logInfo = "onGoogleRePaySuccess:" .. orderId .. "orderNo:" .. orderNo .. "goodsId:" .. goodsId .. "purchaseToken:" .. purchaseToken .. "packageName:" .. packageName
    print(logInfo)
    --local tempString = stringSplit(orderId, ',')
    --local _rid = tempString[1]
    --local _orderId = tempString[2]
    --增加服务器新协议新流程，请求验证
    --local listOrder = { goodsId, _orderId, orderNo, purchaseToken }
    --if (self.GoogleReloadChargeList ~= nil) then
    --    for key, value in pairs(self.GoogleReloadChargeList) do
    --        if string.find(value[3], orderNo) then
    --            return
    --        end
    --    end
    --end
    --if (PlayerDataManager:Get():GetPlayerRID() == _rid) then
    --    table.insert(self.GoogleReloadChargeList, listOrder)
    --end
    local JsonData = Dll_JSON.decode(orderId)
    SDKHelper:Get():AddPurchase(JsonData.cporderId, orderNo, goodsId, purchaseToken, packageName,logInfo,"JsonData.markCode",JsonData.rid)
    --SDKManager:Get():ConsumePurchase(purchaseToken)
end

function GoogleSDKCallBack:OnRePurchaseOne()
     --ActivitySubsystem:Get():DeLoadChargeQueueFront()
end

function GoogleSDKCallBack:OnPurchaseFail(errorReason)
    CommonHelper:PlayScreenEffectWaiting(false)
end

function GoogleSDKCallBack:OnPurchaseCancel(errorReason)
    CommonHelper:PlayScreenEffectWaiting(false)
end

function GoogleSDKCallBack:OnFbSharePhoto(errorReason, status)
    print("OnFbSharePhoto:" .. status)
end

function GoogleSDKCallBack:onBindInfoChanged(uid)
    print("onBindInfoChanged:" .. uid)
end

function GoogleSDKCallBack:onGetFBToken(token)
    CommonTipsHelper:ShowCenterTips("onGetFBTokenLua:" .. token);
    print("onGetFBTokenLua:" .. token)
end

function GoogleSDKCallBack:onNewFBToken(token)
    print("onNewFBTokenLua:" .. token)
end

function GoogleSDKCallBack:onFBMessageReceived(title, body)
    print("onFBMessageReceivedLua:" .. title .. body)
end

function GoogleSDKCallBack:OnRewardedAdReceivedRewardEvent(CreativeIdentifier, Amount, lable, Revenue)
    print("OnRewardedAdReceivedRewardEvent:" .. CreativeIdentifier .. "  Amount" .. Amount .. " lable" .. lable .. "Revenue" .. Revenue)
    --
    --local _time = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    --local FuncID = WelfareVideoDataManager:Get():GetWelfareFuncID()
    --local passwordID = WelfareVideoDataManager:Get():GetWelfareFuncPassword()
    --CreativeIdentifier = passwordID
    --
    --if FuncID == WelfareFuncType.dayGift then
    --    local videoNum = WelfareVideoDataManager:Get():GetVideoDayGiftNumber()
    --    --print("-- 512, --请求每日观影结束 P2=影片id P3=播放时间 P4=序号", CreativeIdentifier, _time, videoNum)
    --    MonthSignSubsystem:Get():SendMsg_ReqSuccDayVideo(CreativeIdentifier, _time, videoNum)
    --end
    --
    --if FuncID == WelfareFuncType.luckyTable then
    --    --print("--504, --请求观影幸运转盘播放结束发货 P2=影片id P3=播放时间", CreativeIdentifier, _time)
    --    MonthSignSubsystem:Get():SendMsg_ReqFinVideoLuck(CreativeIdentifier, _time)
    --end



    if not NetManager:Get():GetGameServerIsConnect() and SDKHelper:Get():CheckGameState(ClientDataManager:Get():GetGameState()) then
        print("设置GameState---->",ClientDataManager:Get():GetGameState())
        ClientDataManager:Get():SetGameState(GameState.Reconnecting)
    end
    print("GameState",ClientDataManager:Get():GetGameState())
    cs_coroutine.start(function()
        while not NetManager:Get():GetGameServerIsConnect() or not SDKHelper:Get():CheckGameState(ClientDataManager:Get():GetGameState())   do
            print("延时发送",ClientDataManager:Get():GetGameState())
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
        end
        print("发送观影结束",ClientDataManager:Get():GetGameState())

        local _time = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
        local FuncID = WelfareVideoDataManager:Get():GetWelfareFuncID()
        local passwordID = WelfareVideoDataManager:Get():GetWelfareFuncPassword()
        CreativeIdentifier = passwordID

        if FuncID == WelfareFuncType.dayGift then
            local videoNum = WelfareVideoDataManager:Get():GetVideoDayGiftNumber()
            --print("-- 512, --请求每日观影结束 P2=影片id P3=播放时间 P4=序号", CreativeIdentifier, _time, videoNum)
            MonthSignSubsystem:Get():SendMsg_ReqSuccDayVideo(CreativeIdentifier, _time, videoNum)
        end

        if FuncID == WelfareFuncType.luckyTable then
            --print("--504, --请求观影幸运转盘播放结束发货 P2=影片id P3=播放时间", CreativeIdentifier, _time)
            MonthSignSubsystem:Get():SendMsg_ReqFinVideoLuck(CreativeIdentifier, _time)
        end
    end)

end

function GoogleSDKCallBack:OnRewardedAdRevenuePaidEvent(CreativeIdentifier, Revenue)
    print("OnRewardedAdRevenuePaidEvent:" .. CreativeIdentifier .. "  Revenue" .. Revenue)

    local _time = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    local FuncID = WelfareVideoDataManager:Get():GetWelfareFuncID()

    WelfareVideoDataManager:Get():SetWelfareFuncPassword()
    local passwordID = WelfareVideoDataManager:Get():GetWelfareFuncPassword()
    CreativeIdentifier = passwordID

    if FuncID == WelfareFuncType.dayGift then
        local videoNum = WelfareVideoDataManager:Get():GetVideoDayGiftNumber()
        local MD5Str = WelfareVideoDataManager:Get():InitVideoMD5Str(_time, CreativeIdentifier, videoNum)
        --print("--510, --开始每日观影 P2=影片id P3=播放时间 P4=序号 P5=md5(playtime=xxxrid=xxx+movieId=xxx+seq=xx+tokenstr)",
        --        CreativeIdentifier, _time, videoNum, MD5Str)
        MonthSignSubsystem:Get():SendMsg_ReqDayVideoPlay(CreativeIdentifier, _time, videoNum, MD5Str)
    end

    if FuncID == WelfareFuncType.luckyTable then
        local MD5Str = WelfareVideoDataManager:Get():InitVideoMD5Str(_time, CreativeIdentifier)
        --print("--502, --请求观影幸运转盘播放开始 P2=影片id P3=播放时间 P4=md5(playtime=xxxrid=xxx+movieId=xxx+tokenstr)",
        --        CreativeIdentifier, _time, MD5Str)
        MonthSignSubsystem:Get():SendMsg_ReqPlayVideoLuck(CreativeIdentifier, _time, MD5Str)
    end

    WelfareVideoDataManager:Get():ClearTimerID()
end

function GoogleSDKCallBack:OnRewardedDisplayFailedEvent(Code, Message, AdLoadFailureInfo)
    print("OnRewardedDisplayFailedEvent:" .. Code .. "  Message" .. Message .. " AdLoadFailureInfo" .. AdLoadFailureInfo)
    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.WelfareVideoFailure))
end
--
--function GoogleSDKCallBack:OnRewardedDisplaySuccessEvent(CreativeIdentifier, Revenue)
--    print("OnRewardedDisplaySuccessEvent:" .. CreativeIdentifier .. "  Revenue" .. Revenue)
--
--    local _time = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
--    local FuncID = WelfareVideoDataManager:Get():GetWelfareFuncID()
--
--    WelfareVideoDataManager:Get():SetWelfareFuncPassword()
--    local passwordID = WelfareVideoDataManager:Get():GetWelfareFuncPassword()
--    CreativeIdentifier = passwordID
--
--    if FuncID == WelfareFuncType.dayGift then
--        local videoNum = WelfareVideoDataManager:Get():GetVideoDayGiftNumber()
--        local MD5Str = WelfareVideoDataManager:Get():InitVideoMD5Str(_time, CreativeIdentifier, videoNum)
--
--        print("--510, --开始每日观影 P2=影片id P3=播放时间 P4=序号 P5=md5(playtime=xxxrid=xxx+movieId=xxx+seq=xx+tokenstr)",
--                CreativeIdentifier, _time, videoNum, MD5Str)
--        MonthSignSubsystem:Get():SendMsg_ReqDayVideoPlay(CreativeIdentifier, _time, videoNum, MD5Str)
--    end
--
--    if FuncID == WelfareFuncType.luckyTable then
--        local MD5Str = WelfareVideoDataManager:Get():InitVideoMD5Str(_time, CreativeIdentifier)
--
--        print("--502, --请求观影幸运转盘播放开始 P2=影片id P3=播放时间 P4=md5(playtime=xxxrid=xxx+movieId=xxx+tokenstr)",
--                CreativeIdentifier, _time, MD5Str)
--        MonthSignSubsystem:Get():SendMsg_ReqPlayVideoLuck(CreativeIdentifier, _time, MD5Str)
--    end
--end