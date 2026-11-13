---@class UltraSDKCallBack
UltraSDKCallBack = class("UltraSDKCallBack")

function UltraSDKCallBack:Get()
    if self._instance == nil then
        self._instance = UltraSDKCallBack()
    end
    return self._instance
end

function UltraSDKCallBack:OnLogin(status,
                                  uid, token, isFristLogin, userName, channelId, channelName)
    if status == "0" then
        PlayerPrefsHelper:SetValue_LoginName(uid)
        UINotify:Get():SendNotification(UINotifyEvent.GameStartView_CloseLoginPanelCG, true)
        UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitServer, nil)
        NetManager:Get():ConnectLoginServer()
        UnifySDKManager:Get():IAccount():DismissMenu()
    end
    if status == "1" then
        print("登录失败")
    end
    if status == "2" then
        print("登录取消")
    end
end

function UltraSDKCallBack:OnLoginOut(status, msg)
    if status == 0 then
        LoginFuncHelper:LoginOut_GameBackToLogin_Combine(false, true, nil, true)
    end
    if status == 1 then
        print("登出失败")
    end
end


function UltraSDKCallBack:OnSwitchAccount(status, uid)
    if status == "0" then
        LoginFuncHelper:LoginOut_GameBackToLogin_Combine(false, true, nil, true)
        PlayerPrefsHelper:SetValue_LoginName(uid)
        UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitServer, nil)
        NetManager:Get():ConnectLoginServer()
        UnifySDKManager:Get():IAccount():DismissMenu()
    end
    if status == "1" then
        print("切换失败")
    end
end



function UltraSDKCallBack:OnFinishInit()
    print("OnFinishInit")
end

function UltraSDKCallBack:OnExit(status,msg)


    if status == "0" then
        print("Exit杀死进程")
        CS.UnityEngine.Application.Quit()
    end
    if status == "1" then
        print("Exit 失败")
    end
    if status == "2" then
        print("Exit取消")
    end
end

-- 被T了
function UltraSDKCallBack:OnLoginInvalid(status,msg)
    --status 1 被踢  2登录失败    msg为原因
    print("OnLoginInvalid" .. status .. "msg" .. msg )
    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(false, true, nil, true)
end

function UltraSDKCallBack:OnPurchaseSuccess(orderId, orderNo, goodsId)
    CommonHelper:PlayScreenEffectWaiting(false)
    print("OnPurchaseSuccess" .. orderId .. "  orderNo" .. orderNo .. " goodsId" .. goodsId)
    --ActivitySubsystem:Get():SendMsg_Purchase_Quick_Shipment(goodsId, orderId)
    SDKHelper:Get():AddPurchase(orderId, orderNo, goodsId)
end

function UltraSDKCallBack:OnPurchaseFail(errorReason)
    CommonHelper:PlayScreenEffectWaiting(false)
end

function UltraSDKCallBack:OnPurchaseCancel(errorReason)
    CommonHelper:PlayScreenEffectWaiting(false)
end

function UltraSDKCallBack:OnFbSharePhoto( status,errorReason)
    print("OnFbSharePhoto:" .. status)

    local recruitData = RecruitDataManager:Get():GetDataById(701)--指定查找的活动id
    if recruitData.info.curShare == 0 then
        RecruitSubsystem:Get():SendMsg_Share(701)
    end
end

function UltraSDKCallBack:OnRewardedAdReceivedRewardEvent(CreativeIdentifier, Amount, lable, Revenue)
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

function UltraSDKCallBack:OnRewardedAdRevenuePaidEvent(CreativeIdentifier, Revenue)
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

function UltraSDKCallBack:OnRewardedDisplayFailedEvent(Code, Message, AdLoadFailureInfo)
    print("OnRewardedDisplayFailedEvent:" .. Code .. "  Message" .. Message .. " AdLoadFailureInfo" .. AdLoadFailureInfo)
    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.WelfareVideoFailure))
end
