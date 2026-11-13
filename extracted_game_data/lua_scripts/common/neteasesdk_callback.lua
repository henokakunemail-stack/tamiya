---@class NetEaseSDKCallBack
NetEaseSDKCallBack = class("NetEaseSDKCallBack")

function NetEaseSDKCallBack:Get()
    if self._instance == nil then
        self._instance = NetEaseSDKCallBack()
    end
    return self._instance
end

---@param json string @扩展方法返回的json
function NetEaseSDKCallBack:onExtendFuncCall_lua(jsonOrMethodId, isIos)
    local extendFunc = {}

    extendFunc = Dll_JSON.decode(jsonOrMethodId)

    if extendFunc.methodId == ExtendFuncName.aasLeftTime then
        -----@type ExtendFuncAASResult
        --local extendFuncAas = extendFunc
        --
        --self:aasLeftTimeFunc_lua(extendFuncAas.needAAS, extendFuncAas.leftTimeSeconds)


    elseif extendFunc.methodId == ExtendFuncName.showRealnameDialog then
        -----@type ExtendFuncShowDiaResult
        --local extendFuncShowDia = extendFunc
        --if not isIos then
        --    self:showRealnameDialogAd_lua(extendFuncShowDia.result)
        --else
        --    self:showRealnameDialog_lua(extendFuncShowDia.status)
        --end


    elseif extendFunc.methodId == ExtendFuncName.getRealnameStatus then
        -----@type ExtendFuncGetDiaResult
        --local extendFuncGetDia = extendFunc
        --self:getRealnameStatus_lua(extendFuncGetDia.status)

    elseif extendFunc.methodId == ExtendFuncName.queryAASLeftTime then
        ---@type ExtendFuncQueryAASLeftTimeResult
        -- local extendFuncGQueryAASLeftTime = extendFunc

        --     return 返回的结果{"result":{"leftTime":3225, "isRealname":false} }
        --monoAndroidUtility.DebugLog("防沉迷所剩时间----" .. extendFuncGQueryAASLeftTime.result.leftTime)
    elseif extendFunc.methodId == ExtendFuncName.getCutoutInfo or extendFunc.methodId == ExtendFuncName.getHwNotchStatus then
        -----@type NetEaseCutoutInfo
        --local cutOut = extendFunc
        --local logStr = string.format("是否是异形屏------%s   宽：%d--高：%d--左：%d--右：%d--上：%d--下：%d", tostring(cutOut.hasCutout), cutOut.width, cutOut.height, cutOut.left, cutOut.right, cutOut.top, cutOut.bottom)
        --monoAndroidUtility.DebugLog(logStr)


    elseif extendFunc.methodId == ExtendFuncName.getDeviceCAID then
        -----@type NetEaseCaid
        --local caidJson = extendFunc
        --if caidJson.errorCode == 0 then
        --    NetEaseDataManager:Get():SetLogInfoCaid(caidJson.caid)
        --
        --    monoAndroidUtility.DebugLog("更新后的caid" .. NetEaseDataManager:Get():GetLogInfoCaid())
        --else
        --    monoAndroidUtility.DebugLog("获取caid 失败")
        --end


    elseif extendFunc.methodId == ExtendFuncName.didReachAasTimeout then

        --monoAndroidUtility.DebugLog("didReachAasTimeout---未实名" .. "时间到了")
        --SDKManager:Get():ShowAasTimeoutAlert()

    elseif extendFunc.methodId == ExtendFuncName.onAasExitGame then

        --monoAndroidUtility.DebugLog("onAasExitGame---" .. "防沉迷时间到，点击 退出游戏 或 我知道了时")
        --
        --NetEasePoneFunc:Get():AntiAddictionKickOffLog()



        --CommonHelper:ApplicationQuit()
    elseif extendFunc.methodId == ExtendFuncName.callbackLeaveSdk then
        -----@type CallbackLeaveSdkResult
        --local extendFuncCallbackLeaveSdkResult = extendFunc
        --monoAndroidUtility.DebugLog("从 SDK 界面（如登录、支付、用户中心）回到游戏界面时，会通过 extendFuncCall 回调给游戏")
        --
        --if SDKManager:Get():IsHaveLogin() then
        --
        --else
        --    --SDKManager:Get():Login()
        --end

    elseif extendFunc.methodId == ExtendFuncName.NtCloseWebView then
        -----@type NtCloseWebView
        --local NtCloseWebViewResult = extendFunc
        --monoAndroidUtility.DebugLog("关闭问卷调查界面")

        --本地token失效，游戏需要重新调用获取客服token接口，参考[客服SDK游戏服务端文档](http://km.netease.com/wiki/show?page_id=17457),
        --取到接口响应后，调用 <获取客服token，并传递给SDK接口>
    elseif extendFunc.methodId == ExtendFuncName.genToken then
        --monoAndroidUtility.DebugLog("客服token過期了------給服務器發消息")
        --LoginSubSystem:Get():SendMsg_GmGetTokenReq()
        --客服webview界面关闭了
    elseif extendFunc.methodId == ExtendFuncName.onWebClose then
        --monoAndroidUtility.DebugLog("关闭客服界面")
    end
end

function NetEaseSDKCallBack:OnLoginOut_lua(isIos, code)

    --if SDKManager:Get():GetIsAasKickedOff() <= 1 then
    --    if self.timerId ~= nil then
    --        TimerManager:Get():StopTimer(self.timerId)
    --        self.timerId = nil
    --    end
    --    self.timerId = TimerManager:Get():CreateTimer(0.5, function()
    --
    --        if self.timerId ~= nil then
    --            TimerManager:Get():StopTimer(self.timerId)
    --        end
    --
    --        if isIos then
    --            monoAndroidUtility.DebugLog("IOS登出成功---" .. "清理账号相关数据,让游戏回到登陆界面")
    --            LoginFuncHelper:LoginOut_GameBackToLoginSDK(true)
    --        else
    --            monoAndroidUtility.DebugLog("OnLogoutDoneListener   code======" .. code)
    --
    --            monoAndroidUtility.DebugLog(tostring(code == OnLogoutDoneListener.OK))
    --            if code == OnLogoutDoneListener.OK then
    --                monoAndroidUtility.DebugLog("Android登出成功---" .. "清理账号相关数据,让游戏回到登陆界面")
    --                LoginFuncHelper:LoginOut_GameBackToLoginSDK(true)
    --            elseif code == OnLogoutDoneListener.FAILED then
    --                monoAndroidUtility.DebugLog("登出失败")
    --            elseif code == OnLogoutDoneListener.NOLOGIN then
    --                monoAndroidUtility.DebugLog("玩家尚未登录")
    --            elseif code == OnLogoutDoneListener.NEED_RELOGIN then
    --                monoAndroidUtility.DebugLog("由于token过期导致登录失效,需要游戏重新登录，请特别注意这种情况，NEED_RELOGIN代表渠道SDK认为玩家是意外登出，此时需要确保把玩家踢下线，并重新登录")
    --                LoginFuncHelper:LoginOut_GameBackToLoginSDK(true)
    --            else
    --                monoAndroidUtility.DebugLog("登出失败---" .. "result不匹配，检查！！！")
    --            end
    --        end
    --    end)
    --else
    --    LoginFuncHelper:LoginOut_GameBackToLoginSDK(false)
    --end
end

function NetEaseSDKCallBack:OrderCheckDone_lua(orderStatus, charErrCode, charErrReason, jfcode, jfsubcode, currencyType, productPrice)
    print("订单支付状态 orderStatus", orderStatus)

    CommonHelper:PlayScreenEffectWaiting(false)

    if orderStatus == OrderInfoStatus.NT_OS_SDK_INVALID_CURRENCY then
        --对于限制了支付币种的支付且支付的币种不符合要求，才会返回这个status
        --提示支付的币种不符合要求，//提示用户使用指定币种支付
        print("支付成功----------订单支付货币有问题")
    elseif orderStatus == OrderInfoStatus.NT_OS_GS_CHECK_OK then
        print("支付成功----------")

        GlobalAd:Get():GlobalAdjust_Purchase(currencyType, productPrice)

    elseif orderStatus == OrderInfoStatus.NT_OS_GS_CHECK_ERR then
        --提示支付失败
        if not CommonHelper:IsNullOrEmpty(charErrReason) then
            print("支付失败原因----------", charErrReason)
            if charErrReason == OrderErrReason.Nt_Another_order_is_checking then
                print("弹框提示-------已经有一笔订单正在支付，请稍后再试")
            elseif charErrReason == OrderErrReason.Nt_Can_not_make_IAP then
                print("弹框提示-------玩家设置手机取消内购限制")
            elseif charErrReason == OrderErrReason.Nt_Receipt_not_exist then
                print("弹框提示-------收费凭证为空")
            elseif charErrReason == OrderErrReason.Illegal_currency then
                print("弹框提示-------币种不符合设定要求")
            elseif charErrReason == OrderErrReason.Nt_Invalid_product_id then
                print("弹框提示-------玩家当前由于网络问题支付失败，请稍后再试")

            elseif charErrReason == OrderErrReason.Nt_SKPayment_transaction_failed then
                if not CommonHelper:IsNullOrEmpty(charErrCode) then
                    print("支付失败错误码----------", charErrCode)


                end
            elseif charErrReason == OrderErrReason.Nt_Query_product_from_jf_failed then
                print("弹框提示-------玩家当前由于网络问题支付失败，请稍后再试")

            elseif charErrReason == OrderErrReason.Nt_Create_order_id_failed then
                if jfcode == 460 and jfsubcode == 3 then
                    print("弹框提示-------订单超过未成年人限制-未成年人支付")

                elseif jfcode == 460 and jfsubcode == 4 then
                    print("弹框提示-------恶意退款（bridge渠道包特有）")

                elseif jfcode == 430 then
                    print("弹框提示-------停服")
                end
            else

            end
        end
    end
end

function NetEaseSDKCallBack:OrderConsumeDone_lua(code)
    monoAndroidUtility.DebugLog("OrderConsumeDone_lua---------")
end

function NetEaseSDKCallBack:OnExit_lua()
    monoAndroidUtility.DebugLog("OnExit_lua---------游戏退出")

end

function NetEaseSDKCallBack:OnExitFail_lua()
    monoAndroidUtility.DebugLog("OnExitFail_lua---------游戏退出失败")
end

function NetEaseSDKCallBack:OnFinishInit_lua(code)
    if code == OnFinishInitListener.OK or code == OnFinishInitListener.MISSED then
        monoAndroidUtility.DebugLog("初始化成功，可以执行登录操作")
    else
        monoAndroidUtility.DebugLog("初始化失败，不能执行登录操作，需要检查配置信息")
    end
end

---@param jsonText SauthReturn @SauthReturn
function NetEaseSDKCallBack:OnLoginSuccess_lua(jsonText)
    ---@type SauthReturn
    local sauthReturn = Dll_JSON.decode(jsonText)

    local sauthReturnIns = SauthReturn()
    sauthReturnIns:SetData(sauthReturn)
    NetEaseDataManager:Get():SetSauthReturnData(sauthReturnIns)

    if sauthReturn.code == 200 then
        if sauthReturn.subcode == 0 then

            local unisdk_login_json = monoAndroidUtility.DecodeBase64(sauthReturn.unisdk_login_json)

            monoAndroidUtility.DebugLog("unisdk_login_json:  " .. unisdk_login_json)

            monoAndroidUtility.SetStringFromNE(ConstProp.UNISDK_LOGIN_JSON, sauthReturn.unisdk_login_json)

            --SDKManager:Get():SetFirstUDID()

            ---@type Unisdk_login_json
            local unisdkLoginJson = Dll_JSON.decode(unisdk_login_json)
            NetEaseDataManager:Get():UpdateSauthReturnData(unisdkLoginJson)

            local msg = {
                accountid = sauthReturn.uid,
                sessioncode = sauthReturn.sessioncode
            }

            ClientDataManager:Get():SetLoginMsg(msg)

            local userName = unisdkLoginJson.username
            local sdkNum = string.find(userName, '@')
            local sdkUid = string.sub(userName, 1, sdkNum - 1)
            print("c#---------------------OnLoginSuccess_lua-------------sdkUid:---" .. sdkUid)
            PlayerPrefsHelper:SetValue_LoginName(unisdkLoginJson.sdkuid)

            GlobalAd:Get():GlobalAdjust_Login()

            --SDKManager:Get():OpenUserAuth(false)
        elseif sauthReturn.subcode == 9999 then
            CommonHelper:LoginTipPop(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1001), CommonHelper:GetTempStr_Default(TemplateStringID.OK), function()
                LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, nil, true)
            end)
        end
    else
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LoginFail))

        local ipPort = stringSplit(GameProperties.LoginUrl, ':')
        NetEaseDetect:Get():LoginFail(
                "0",
                "登录服",
                ipPort[1],
                tonumber(ipPort[2]),
                tostring(sauthReturn.code) .. tostring(sauthReturn.subcode),
                "-1",
                "-1"
        )
        --NetEasePoneFunc:Get():RoleEnterFailLog()
    end
end

function NetEaseSDKCallBack:OnRealNameVerifyCallback_lua (status)
    if status == NetEaseRealNameIos.NoRealName then
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "未实名")
    elseif status == NetEaseRealNameIos.RealNameAdult then
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "实名已成年")
    elseif status == NetEaseRealNameIos.RealName then
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "已实名")
    else
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "实名状态未知")
    end

end

function NetEaseSDKCallBack:aasLeftTimeFunc_lua(needAAs, leftTimeSeconds)
    if needAAs == NetEaseAas.NeedAAS and leftTimeSeconds == 0 then

        monoAndroidUtility.DebugLog("aasLeftTime---" .. "则暂停游戏进程，以免耗尽可玩时间时，由于挂机自动打怪的设计而让用户继续获取收益")
    end

    if needAAs == NetEaseAas.NoNeedAAS or leftTimeSeconds > 0 then

        monoAndroidUtility.DebugLog("aasLeftTime---" .. "且游戏进程处于上面设置的暂停状态，则恢复游戏进程")
    end
    --NetEasePoneFunc:Get():UserCertificationLog()
end

function NetEaseSDKCallBack:getRealnameStatus_lua(status)

    --NetEasePoneFunc:Get():UserCertificationLog()
    if status == NetEaseRealName.NoRealName then
        monoAndroidUtility.DebugLog("getRealnameStatus---" .. "未实名")
    elseif status == NetEaseRealName.RealNameNoAge then
        monoAndroidUtility.DebugLog("getRealnameStatus---" .. "已实名未成年")
    elseif status == NetEaseRealName.RealNameAdult then
        monoAndroidUtility.DebugLog("getRealnameStatus---" .. "实名已成年")
    elseif status == NetEaseRealName.RealName then
        monoAndroidUtility.DebugLog("getRealnameStatus---" .. "实名状态未知")
    else
        monoAndroidUtility.DebugLog("getRealnameStatus---" .. "result不匹配，检查！！！")
    end

end

function NetEaseSDKCallBack:showRealnameDialogAd_lua(status)
    if status == NetEaseRealName.NoRealName then
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "未实名")
    elseif status == NetEaseRealName.RealNameNoAge then
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "已实名未成年")
    elseif status == NetEaseRealName.RealNameAdult then
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "实名已成年")
    elseif status == NetEaseRealName.RealName then
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "实名状态未知")
    else
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "result不匹配，检查！！！")
    end
end

function NetEaseSDKCallBack:showRealnameDialog_lua(status)
    if status == NetEaseRealNameIos.NoRealName then
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "未实名")
    elseif status == NetEaseRealNameIos.RealNameAdult then
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "实名已成年")
    elseif status == NetEaseRealNameIos.RealName then
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "已实名")
    else
        monoAndroidUtility.DebugLog("showRealnameDialog---" .. "实名状态未知")
    end
end

function NetEaseSDKCallBack:queryAasLeftTimeFunc_lua(resultJson)


end

function NetEaseSDKCallBack:onProtocolFinish_lua(code)
    if code == OnProtocolFinishListener.ACCEPT then
        monoAndroidUtility.DebugLog("onProtocolFinish---" .. "同意协议")
        LoginSubSystem:Get():RecvMsg_LoginSDK()
    elseif code == OnProtocolFinishListener.REJECT then
        monoAndroidUtility.DebugLog("onProtocolFinish---" .. "拒绝协议")
    elseif code == OnProtocolFinishListener.NOT_NEED_SHOW then
        monoAndroidUtility.DebugLog("onProtocolFinish---" .. "不用显示")
        LoginSubSystem:Get():RecvMsg_LoginSDK()
    else
        monoAndroidUtility.DebugLog("onProtocolFinish---" .. "正在阅读")
    end

end

---@param logInfo string
function NetEaseSDKCallBack:pOnelog_lua(logInfo)
    ---@type LogInfo
    local logInfoJson = Dll_JSON.decode(logInfo)

    NetEaseDataManager:Get():SetLogInfoData(logInfoJson)
end

---------------------survey---------------------------
function NetEaseSDKCallBack:onSurveyCallBackDel_lua(action, data)
    if action == NetEaseSurvey.finish then
        monoAndroidUtility.DebugLog("onSurveyCallBackDel_lua---" .. "完成问卷回调")
        SurveySubsystem:Get():SendMsg_GetReward(SurveyDataManager:Get():GetCurSelectId())
    end
    if action == NetEaseSurvey.close then
        monoAndroidUtility.DebugLog("onProtocolFinish---" .. "关闭窗口")
    end
end

---------------------survey---------------------------

function NetEaseSDKCallBack:onGmBridgeGenToken_lua()
    monoAndroidUtility.DebugLog("onGmBridgeGenToken_lua---" .. "关闭客服界面")
end

---------------------orbit---------------------------
function NetEaseSDKCallBack:onOrbitProgress_lua(jsonStr)

    monoAndroidUtility.DebugLog("onOrbitProgress_lua---" .. jsonStr)

end
function NetEaseSDKCallBack:onOrbitFinished_lua(jsonStr, isIos, successed, compelete)
    monoAndroidUtility.DebugLog("onOrbitFinished_lua---" .. jsonStr)
    ---@type NetEaseOrbitFinished
    local jsonTab = Dll_JSON.decode(jsonStr)
    -- 以下fileName的判断是sdk需要的额外操作，固定的回调
    --配置文件下载节点---标识

    if isIos == true then
        if jsonTab.fileName == "__DOWNLOAD_CONFIG__" then
            if compelete == true and jsonTab.code ~= 0 then

                -- 下载已经结束，下载环境存在问题，大部分是网络问题，可以再次重试或者弹窗提示
                --[self doSomeNotifyOrRetry];
                return
            else
                -- 业务无需处理config的提示，可忽略这个回调，直接return
                return
            end
            -- Dns解析节点---标识
        elseif jsonTab.fileName == "__DOWNLOAD_DNS_RESOLVED__" then
            if compelete == true and jsonTab.code ~= 0 then
                --下载已经结束，DNS解析失败，大部分是网络问题，可以再次重试或者弹窗提示
                --[self doSomeNotifyOrRetry];
                return
            else
                -- 业务无需处理DNS解析的提示，可忽略这个回调，直接return
                return
            end

            --失去网络节点
        elseif jsonTab.fileName == "__DOWNLOAD_NETWORK_LOST__" then
            if compelete == true and jsonTab.code ~= 0 then
                -- 下载已经结束，网络链接已经丢失，可以再次重试或者弹窗提示
                --[self doSomeNotifyOrRetry];
                return

            end
            --清除Downloadid节点
        elseif jsonTab.fileName == "__DOWNLOAD_CLEAN_CACHE__" then

            if compelete == true and jsonTab.code == 0 then
                -- 缓存downloadid已经清除成功，接下来基本不用做什么操作
                --[self doSomeNotify];
                return
            end
        end
        --[[
        * 以下属于正常文件下载的统计操作
        * 其中，code的取值有：
        * 0 成功
        * 1 网络错误
        * 2 size校验失败
        * 3 md5校验失败
        * 4 存储不足
        * 6 配置不正常
        * 12 下载取消
        ]]--
        if jsonTab.code == 0 then
            -- 单个文件的下载结果。下载成功，可以做些统计相关的操作
            --[self doSomeSuccess];
        elseif jsonTab.code == 12 then
            -- 如果code是取消的话，compelete基本是YES，同时SDK没有后续的回调了，在此根据需要做相关的操作。处理完成后，可直接return。
            -- 这里的回调是调用downloadcancel之后才会进入。
            if compelete == true then
                --self doSomeIfNeed];
                return
            else
                -- 单个文件的下载结果。文件下载失败，可以做些统计方面的操作
                --[self doSomefail];
            end
        end

        if jsonTab.compelete == true then
            --全部文件下载结束，SDK没有后续的回调了，请根据每个文件的下载结果统计，看是否需要发起部分失败文件的下载重试
            --[self doSomeNotifyOrRetryIfNeed];
        end
    else
        -----------android---------------

    end
end

function NetEaseSDKCallBack:OnLoginServerSuccess_lua(data)
    LoginSubSystem:Get():RecvMsg_Login(data)
end

function NetEaseSDKCallBack:AntiAddictionKickOffLog()
    --NetEasePoneFunc:Get():AntiAddictionKickOffLog()
end

function NetEaseSDKCallBack:SendMsg_GmGetTokenReq()
    monoAndroidUtility.DebugLog("客服token過期了------給服務器發消息")
    LoginSubSystem:Get():SendMsg_GmGetTokenReq()
end

function NetEaseSDKCallBack:LoginOut_GameBackToLoginSDK()
    monoAndroidUtility.DebugLog("LoginOut_BindGuest------绑定账号之后，登出之前的账号")
    LoginFuncHelper:LoginOut_BindGuest()
end

function NetEaseSDKCallBack:Test(data)
    monoAndroidUtility.DebugLog("用来测试，不传第一个参数的function call---" .. data)
end