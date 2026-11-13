---@class SDKManager
SDKManager = class("SDKManager")

---@return SDKManager
function SDKManager:Get()
    if self._instance == nil then
        self._instance = SDKManager()
    end
    return self._instance
end
function SDKManager:initialize()
end

--function SDKManager:ShowPrivace()
--    --monoSDKManager:ShowPrivace()
--    UnifySDKManager:Get():IAccount():ShowPrivacy()
--end

--function SDKManager:Login(isAutoLogin)
--    if NetManager:Get():GetNetReachability() == NetworkReachability.NotReachable and isAutoLogin then
--        CommonHelper:LoginTipPop(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1007), CommonHelper:GetTempStr_Default(TemplateStringID.Retry), function()
--            UnifySDKManager:Get():IAccount():Login(false)
--        end)
--    else
--        print("之前的登录类型----", PlayerPrefsHelper:GetValue_GlobalLoginType())
--        UIManager:Get():OpenView("GameStartView", CanvasType.FrontCanvas, "GameStartView", false, true)
--        UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitCG, false)
--        print("测试一下热更新----")
--    end
--end

--function SDKManager:QuickLogin(isShowMenu)
--    --monoSDKManager:Login(isShowMenu)
--    UnifySDKManager:Get():IAccount():Login(isShowMenu)
--end

--function SDKManager:QuickLogout()
--    print("QuickLogout----" )
--    --monoSDKManager:Logout()
--    UnifySDKManager:Get():IAccount():Logout()
--end
--function SDKManager:QuickAccountDeletion()
--    --monoSDKManager:QuickAccountDeletion()
--    UnifySDKManager:Get():IAccount():AccountDeletion()
--end

--function SDKManager:Quick_IsUserGuest()
--    --return monoSDKManager:Quick_IsUserGuest()
--    return UnifySDKManager:Get():IAccount():IsUserGuest()
--end

--function SDKManager:QuickShowMenu()
--    --monoSDKManager:QuickShowMenu()
--    UnifySDKManager:Get():IAccount():ShowMenu()
--end
--function SDKManager:QuickDismissMenu()
--    --monoSDKManager:QuickDismissMenu()
--    UnifySDKManager:Get():IAccount():DismissMenu()
--end

--function SDKManager:getChannelId()
--    --return monoSDKManager:getChannelId()
--    return UnifySDKManager:Get():ISDK():GetChannelID()
--end

--function SDKManager:GetCPSChannelID()
--    return UnifySDKManager:Get():IAccount():GetCPSChannelID()
--    --return monoSDKManager:GetCPSChannelID()
--end

--function SDKManager:ReviewWordsV2(level, channel, content)
--    monoAndroidUtility.DebugLog("ReviewWordsV2-----level:  " .. level .. "  channel:  " .. channel .. "  content:  " .. content)
--    --return monoSDKManager:ReviewWordsV2(level, channel, content)
--    return content
--end

--function SDKManager:CreateOrder(productId,itemId, setJfExtInfo, orderId, orderDec, amount, currency, roleName, roleLv, serverName,callbackUrl)
--    print("CreateOrder-----productId:", productId, "   orderId:", orderId, "callbackUrl:", callbackUrl)
--    if ClientDataManager:Get():GetGameState() == GameState.Login_GameServer then
--        CommonHelper:PlayScreenEffectWaiting(true)
--        UnifySDKHelper:SubmitRoleInfo(4)
--        SDKManager:Get():Quick_Purchase(orderId, orderDec, productId,itemId, amount, currency, roleName, roleLv, serverName, setJfExtInfo,callbackUrl)
--    end
--end
--
--function SDKManager:Quick_Purchase(orderId, orderDec, productId,itemId, amount, currency, roleName, roleLv, serverName, serverIdParam,callbackUrl)
--    --monoSDKManager:Quick_Purchase(orderId, orderDec, productId, itemId, amount, currency, roleName, roleLv, serverName, serverIdParam, callbackUrl)
--    local data = PurchaseOrderInfoData
--    data.goodsID = itemId
--    data.cpOrderID =orderId
--    data.quantifier = "个"
--    data.extrasParams = serverIdParam
--    data.count = 1
--    data.price = tonumber(amount)
--    data.amount = tonumber(amount)
--    data.callbackUrl = callbackUrl
--    data.goodsName = orderDec
--    data.goodsDesc = orderDec
--
--    data.productId = productId
--
--    data.currency = currency
--    data.roleName = roleName
--    data.roleLv = roleLv
--    data.serverName = serverName
--    UnifySDKManager:Get():IPurchase():Purchase(data)
--end




--function SDKManager:SDKIsHaveLogin(loginType)
--    loginType = loginType or ""
--    if SDKHelper:Get():ChickQuickSdk() then
--        return QuickSdkDataManager:Get():GetIsLoginSDK()
--    end
--end

--function SDKManager:Quick_BindUser(qGConstant)
--    monoSDKManager:Quick_BindUser(qGConstant)
--end
--function SDKManager:Quick_GetUserBindInfo()
--    return monoSDKManager:Quick_GetUserBindInfo()
--end

--function SDKManager:Quick_EnterUserCenter()
--    monoSDKManager:Quick_EnterUserCenter()
--end

--function SDKManager:Quick_GetDeviceId()
--    return monoSDKManager:Quick_GetDeviceId()
--end

--function SDKManager:Quick_GetCountryInfo()
--    return monoSDKManager:Quick_GetCountryInfo()
--end

--function SDKManager:ConsumePurchase(PurchaseToken)  ---Google
--    return monoSDKManager:ConsumePurchase(PurchaseToken)
--end
--
--function SDKManager:QueryPurchasesAsync()  ---Google
--    return monoSDKManager:QueryPurchasesAsync()
--end

--function SDKManager:Translate(targetLand, textInput, callBack)
--    monoSDKManager:Translate(targetLand, textInput, callBack)
--end

-----@class SubmitRoleInfo :上传角色信息接口
-----@field   SubmitType        @ （1 进入游戏   2 创建角色 3角色升级   其他  充值前统计等）
-----@field   channelUserId     @ 渠道用户ID(玩家登录账号)
-----@field   gameUserId        @ 游戏生成的账号ID
-----@field   serverId          @ 区服ID
-----@field   serverName        @ 区服名称  serverNa
-----@field   roleId            @ 角色ID  roleId
-----@field   roleName          @ 角色名  roleName
-----@field   roleAvatar        @ 角色头像地址  roleAv
-----@field   level             @ 角色等级  level
-----@field   vipLevel          @ 角色VIP等级  ipLev
-----@field   gold1             @ 一级货币[充值获得]  go
-----@field   gold2             @ 二级货币[游戏内产出]  g
-----@field   sumPay            @ 累计充值总额  sumPay
--function SDKManager:SubmitRoleInfo(SubmitType, channelUserId, gameUserId, serverId, serverName, roleId, roleName, roleAvatar, level, vipLevel, gold1, gold2, sumPay)
--    --monoSDKManager:SubmitRoleInfo(SubmitType, channelUserId, gameUserId, serverId, serverName, roleId,
--    --        roleName, roleAvatar, level, vipLevel, gold1, gold2, sumPay)
--end

--function SDKManager:QuitGame()
--    UnifySDKManager:Get():IAccount():QuitGame()
--    --monoSDKManager:QuitGame()
--end
--
--function SDKManager:CanQuitGame()
--    return  UnifySDKManager:Get():IAccount():CanQuitGame()
--    --local canQGame =  monoSDKManager:CanQuitGame()
--    --print("CanQuitGame",canQGame)
--    --return canQGame
--end