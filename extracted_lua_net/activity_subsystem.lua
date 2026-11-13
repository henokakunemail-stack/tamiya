---@class ActivitySubsystem
ActivitySubsystem = class("ActivitySubsystem")

function ActivitySubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.ACTIVITY_INFO_S2C_RES, self, self.RecMsg_GetActivity)
    NetResponseEventManager:Get():AddListener(MsgID.PERIOD_GIFT_S2C_RES, self, self.RecMsg_GetWeekCardReward)
    --首充
    NetResponseEventManager:Get():AddListener(MsgID.RET_FIRST_CHARGE_S2C_RES, self, self.RecMsg_GetFirstBuyReward)

    NetResponseEventManager:Get():AddListener(MsgID.CREATE_ORDER_S2C_RES, self, self.RecvMsg_Purchase_Quick_Pre)
    --174  发货完成
    NetResponseEventManager:Get():AddListener(MsgID.FINISH_ORDER_S2C_RES, self, self.RecvMsg_Purchase_Quick_FinishCharge)

    NetResponseEventManager:Get():AddListener(MsgID.TOKEN_EXCHANGE_S2C_RES, self, self.RecvMsg_Purchase_Quick_FinishCharge)

    --google充值 检测 发货
    NetResponseEventManager:Get():AddListener(MsgID.CREATE_GOOGLE_ORDER_S2C_RES, self, self.RecvMsg_Purchase_Google_Pre)
    NetResponseEventManager:Get():AddListener(MsgID.CHECK_GOOGLE_ORDER_S2C_RES, self, self.RecvMsg_Purchase_Google_Chick)
    NetResponseEventManager:Get():AddListener(MsgID.FINISH_GOOGLE_ORDER_S2C_RES, self, self.RecvMsg_Purchase_Google_Shipment)

    NetResponseEventManager:Get():AddListener(MsgID.CREAT_EBR_ORDER_C2S_RES, self, self.RecvMsg_Purchase_Ebr_Pre)



    --238, --返回领取成长战令
    NetResponseEventManager:Get():AddListener(MsgID.GROWTH_UP_GIFT_C2S_RES, self, self.ResMsg_GrowthUpGift)
    --238, --返回领取成长战令II
    NetResponseEventManager:Get():AddListener(MsgID.ACT_LEVEL_UP_C2S_RES, self, self.ResMsg_ActLevelUpGift)

    self.ReloadChargeQueue = Queue()
    self.CanReloadCharge = true;
    ---@type table<number,number> @ key是token，value是cporderNum
    self.ChargeOrderTab = {}

    --谷歌补单数据
    self.GoogleReloadChargeList = {}
    self.GoogleCanReloadCharge = true;

    self.ChargeFlag = 1
    self.callbackUrl = "http://43.134.65.85:21004/PayManager/ultrapay"

    self.isBaXiPayCanShipment = false  -- 巴西支付可发货状态
end

---请求活动信息 241    P2=当前第一个活动id的所有giftid
local _IsReset = false
function ActivitySubsystem:SendMsg_GetActivity(giftid, IsReset)
    _IsReset = IsReset
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), giftid })
    NetManager:Get():Send(MsgID.ACTIVITY_INFO_C2S_REQ, msgData)
    --SDKManager:Get():QueryPurchasesAsync()     UnifySDKManager:Get():IPurchase():QueryPurchasesAsync()
end

---返回活动信息
function ActivitySubsystem:RecMsg_GetActivity(data)
    ---@type SC_ActivityInfo
    local msg = assert(Dll_PB.decode("ActivityInfo", data))
    print(ProtoMsgHelp.block(msg))
    if msg.cporderid ~= "" then
        --打开充值界面触发补单信息
        --if SDKHelper:Get():ChickGoogleSdk() then
        SDKHelper:Get():SendPurchaseLog("ActivitySubsystem" ,"打开活动面板触发","","","")
        SDKHelper:Get():AddPurchase(msg.cporderid)
        --elseif SDKHelper:Get():ChickUltraSdk() then
        --    --print("ultrasdk临时取消补单")
        --    ActivitySubsystem:Get():SendMsg_Purchase_Quick_Shipment("", msg.cporderid)
        --else
        --    ActivitySubsystem:Get():SendMsg_Purchase_Quick_Shipment("", msg.cporderid)
        --end
    end
    if #msg.curActInfo > 0 and msg.curActInfo[1].chargetype == ChargeType.ReturnOldPlayer then
        UINotify:Get():SendNotification(UINotifyEvent.ReturnOldPlayer_SetBox, msg)
    elseif #msg.curActInfo > 0 and msg.curActInfo[1].chargetype == ChargeType.EveryDayGift then
        --给通用活动的每日充值发事件
        if not UIManager:Get():IsPopViewShow("CommonNewActView") then
            UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
        end
        CommonFestivalDataManager:Get():InitEveryDayaData(msg.curActInfo)
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.EveryDayGift })

    else
        if not UIManager:Get():IsViewShow("ActivityView") and _IsReset then
            UIManager:Get():OpenView("ActivityView", CanvasType.MainCanvas, "ActivityView")
            UINotify:Get():SendNotification(UINotifyEvent.ActivityView_SetData)
        end
        UINotify:Get():SendNotification(UINotifyEvent.ActivityView_InitPageInfo, { msg, _IsReset })
        _IsReset=false
    end
end

---请求周月卡领取
function ActivitySubsystem:SendMsg_GetWeekCardReward(value)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), value })
    NetManager:Get():Send(MsgID.PERIOD_GIFT_C2S_REQ, reqBytes)
end

---返回周月卡领取
function ActivitySubsystem:RecMsg_GetWeekCardReward(value)
    ---@type SC_UserPeriodGift
    local msg = assert(Dll_PB.decode("UserPeriodGift", value))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
    UINotify:Get():SendNotification(UINotifyEvent.ActivityView_RefreshChargeState)
    RedPointManager:Get():UpdateValue(RedPointID.S_WeekCardGet, false)
    RedPointManager:Get():UpdateValue(RedPointID.S_MonthCardGet, false)

end

---请求首充奖励 233    P2=领取天数
function ActivitySubsystem:SendMsg_GetFirstBuyReward(dayID)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), dayID })
    NetManager:Get():Send(MsgID.REQ_FIRST_CHARGE_C2S_REQ, msgData)
end

---234, --返回首充奖励
function ActivitySubsystem:RecMsg_GetFirstBuyReward(data)
    ---@type SC_UserFirstGift
    local msg = assert(Dll_PB.decode("UserFirstGift", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
    UserFirstGiftManager:Get():SetUserFirstGiftDataByType(msg)
    UINotify:Get():SendNotification(UINotifyEvent.ActivityFirstBuyView_InitViewInfo,true)
end

function ActivitySubsystem:RecvMsg_GetActivityInfo(data)
    ------买钻石 会给推这个
    -----@type SC_PlayerActivityInfoRes
    --local msg = assert(Dll_PB.decode("PlayerActivityInfoRes", data))
    --print(ProtoMsgHelp.block(msg))
    --
    --if msg.activityId ~= 0 then
    --    --不等于0 说明是礼包
    --    ActivityDataManager:Get():InitActivityItemData(msg.activityId, msg)
    --
    --    ---@type activity_config_cell
    --    local cell = CommonHelper:GetTableDataByID(ConfigNames.activity_config, msg.activityId)
    --
    --    if cell.activityType == ActivityType.FirstBuy then
    --        if ActivityDataManager:Get():GetActivityItemDataByIdx(cell.activityType, 1):GetActivityStatus() ~= ActivityStatus.Get then
    --            UIManager:Get():OpenPopup("ActivityFirstBuyView", CanvasType.MainCanvas, "ActivityFirstBuyView", true)
    --            UINotify:Get():SendNotification(UINotifyEvent.ActivityFirstBuyView_InitViewInfo)
    --        end
    --    else
    --        UINotify:Get():SendNotification(UINotifyEvent.ActivityView_InitPageInfo, msg)
    --    end
    --else
    --    UINotify:Get():SendNotification(UINotifyEvent.ActivityView_InitPageInfo, msg)--这个不是礼包，耍的是钻石的状态
    --end
    --
    --if msg.firstGift == ActivityStatus.FinishNoGet then
    --    ActivityDataManager:Get():SetIsCanFirstPurchase(msg.firstGift == 1)
    --    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_RefreshFirstBuyRedPoint)
    --end
end

--- 237, --请求领取成长战令
function ActivitySubsystem:SendMsg_GrowthGiftUp(LV)
    print("2222222222222222222")
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), LV })
    NetManager:Get():Send(MsgID.GROWTH_UP_GIFT_C2S_REQ, msgData)

end

--- 238, --返回领取成长战令
function ActivitySubsystem:ResMsg_GrowthUpGift(data)
    ---@type SC_ActGrowupGift
    local msg = assert(Dll_PB.decode("ActGrowupGift", data))
    print(ProtoMsgHelp.block(msg))

    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
    UINotify:Get():SendNotification(UINotifyEvent.ActivityView_RefreshChargeState)
end

--- 235, --请求领取成长战令II P2=0全部>0等级
function ActivitySubsystem:SendMsg_ActLevelUp(LV)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), LV })
    NetManager:Get():Send(MsgID.ACT_LEVEL_UP_C2S_REQ, msgData)

end

--- 236, --返回领取成长战令II
function ActivitySubsystem:ResMsg_ActLevelUpGift(data)
    ---@type SC_ActGrowupGift
    local msg = assert(Dll_PB.decode("ActGrowupGift", data))
    print(ProtoMsgHelp.block(msg))

    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
    UINotify:Get():SendNotification(UINotifyEvent.ActivityView_RefreshChargeState)
end

---@param msg SC_reloadCharge[]
function ActivitySubsystem:ReloadCharge(msg)
    log("ReloadCharge触发补单")
   local msgInfo = ProtoMsgHelp.block(msg)
    --SDKManager:Get():QueryPurchasesAsync()
    GoogleSDKRechargeLog:Get():SendLog()
    if msg then
        SDKHelper:Get():SendPurchaseLog("ReloadCharge" ,"登录游戏触发补单",msgInfo,"","")
        if #msg >= 1 then
            for i = 1, #msg do
                SDKHelper:Get():AddPurchase(msg[i].cporderid,nil, nil, nil, nil, nil, msg[i].markcode, nil)
            end
        end
        PopupManager:Get():FirstPopupOnClose()
    end

end

function ActivitySubsystem:SendMsg_Purchase_Quick_Pre(itemId, itemStr)
    --local reqData = {
    --    productId = productId,
    --}
    --local reqBytes = assert(Dll_PB.encode("OrderCreateReq", reqData))
    ---  读取cdn
    LoginSubSystem:Get():SendMsg_ChargeFlagConfig(function(data)
        local jsonData = Dll_JSON.decode(data)
        print("SendMsg_Purchase_Quick_Pr---json", jsonData)
        self.ChargeFlag = jsonData.ChargeFlag
        print("SendMsg_Purchase_Quick_Pr---json", self.ChargeFlag)
        self.callbackUrl = jsonData.CallBackUrl
        print("SendMsg_Purchase_Quick_Pr---json", self.callbackUrl)
        local data = {}
        local cchn = QuickTaHelper:Get():GetCcHn()
        if SDKHelper:Get():ChickGoogleSdk() then
            data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), itemId, cchn })
            NetManager:Get():Send(MsgID.CREATE_GOOGLE_ORDER_C2S_REQ, data)
        else
            data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), itemId, cchn })
            NetManager:Get():Send(MsgID.CREATE_ORDER_C2S_REQ, data)
        end
    end)
    --SdkAd:Get():SdkAdjust_Prepay(itemId,itemStr)
    --QuickTa:Get():Track_OrderInit("1713", "-1", -1, "-1", -1, itemId, "0", "-1", "-1", "-1", -1, -1, "-1")
end

function ActivitySubsystem:SendMsg_Purchase_Editor_Pre(itemId, itemStr, type)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), itemId, itemStr })
    print("假充值：" .. itemId, itemStr)
    if type == 1 then
        -- 调用巴西本地支付
        local msg = { itemId = itemId }
        UIManager:Get():ShowPersistentView("ActivityChoosePayView", CanvasType.TopCanvas, "ActivityChoosePayView")
        UINotify:Get():SendNotification(UINotifyEvent.ActivityChoosePayView_InitViewInfo, msg)
        self.isBaXiPayCanShipment = false
    else
        NetManager:Get():Send(MsgID.CREATE_ORDER_FALSE_C2S_REQ, data)
    end
end
function ActivitySubsystem:SendMsg_Token_Exchange(itemId, itemStr, type)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), itemId, itemStr })
    NetManager:Get():Send(MsgID.TOKEN_EXCHANGE_C2S_REQ, data)
end
function ActivitySubsystem:SendMsg_Token_ExchangeCoin(itemId, itemStr, type)
    local cchn = QuickTaHelper:Get():GetCcHn()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), itemId, cchn })
    NetManager:Get():Send(MsgID.TOKEN_COIN_EXCHANGE_C2S_REQ, data)
end


function ActivitySubsystem:RecvMsg_Purchase_Quick_Pre(data)
    ---@type SC_CreateSucc
    local msg = assert(Dll_PB.decode("CreateSucc", data))
    print(ProtoMsgHelp.block(msg))
    self.callbackUrl = msg.url
    ---@type dictcharge_config_cell
    local cell = CommonHelper:GetChargeCfgByAreaAndItemId(msg.itemId)

    if msg.cporderId ~= nil then
        local roleName = PlayerDataManager:Get():GetPlayerName() or ""
        local roleLv = PlayerDataManager:Get():GetPlayerLV() or ""
        local serverName = "NormalServer"
        if PlayerDataManager:Get():GetPlayerServerID() ~= nil then
            if ClientDataManager:Get():GetServerInfoByServerId(PlayerDataManager:Get():GetPlayerServerID()) ~= nil then
                serverName = ClientDataManager:Get():GetServerInfoByServerId(PlayerDataManager:Get():GetPlayerServerID()):GetName()
            end
        end

        if msg.chargeselect == 1 then
            local uid = PlayerDataManager:Get():GetPlayerUID()
            UnifySDKHelper:Purchase_CreateOrder(msg.innerId, msg.itemId, msg.cporderId, msg.cporderId, CommonHelper:GetTempStr_Default(cell.name), tostring(cell.chargenum), cell.currencyType, roleName, tostring(roleLv), serverName, self.callbackUrl)
            --SDKManager:Get():CreateOrder(msg.innerId, msg.itemId, uid, msg.cporderId, CommonHelper:GetTempStr_Default(cell.name), tostring(cell.chargenum), cell.currencyType, roleName, tostring(roleLv), serverName, self.callbackUrl)
        elseif msg.chargeselect == 2 then
            -- 调用巴西本地支付
            UIManager:Get():ShowPersistentView("ActivityChoosePayView", CanvasType.TopCanvas, "ActivityChoosePayView")
            UINotify:Get():SendNotification(UINotifyEvent.ActivityChoosePayView_InitViewInfo, msg)
            self.isBaXiPayCanShipment = false
        end
    end
end

function ActivitySubsystem:RecvMsg_Purchase_Google_Pre(data)
    ---@type SC_CreateSucc
    local msg = assert(Dll_PB.decode("CreateSucc", data))
    print(ProtoMsgHelp.block(msg))

    ---@type dictcharge_config_cell
    local cell = CommonHelper:GetChargeCfgByAreaAndItemId(msg.itemId)

    if msg.cporderId ~= nil then
        local roleName = PlayerDataManager:Get():GetPlayerName() or ""
        local roleLv = PlayerDataManager:Get():GetPlayerLV() or ""
        local serverName = "NormalServer"
        if PlayerDataManager:Get():GetPlayerServerID() ~= nil then
            if ClientDataManager:Get():GetServerInfoByServerId(PlayerDataManager:Get():GetPlayerServerID()) ~= nil then
                serverName = ClientDataManager:Get():GetServerInfoByServerId(PlayerDataManager:Get():GetPlayerServerID()):GetName()
            end
        end

        local jsonCpData = Dll_JSON.encode({ rid = PlayerDataManager:Get():GetPlayerRID(), cporderId = msg.cporderId })
        --SDKManager:Get():CreateOrder(msg.innerId, msg.itemId, "", jsonCpData, CommonHelper:GetTempStr_Default(cell.name), tostring(cell.chargenum), cell.currencyType, roleName, tostring(roleLv), serverName)
        UnifySDKHelper:Purchase_CreateOrder(msg.innerId, msg.itemId, "", jsonCpData, CommonHelper:GetTempStr_Default(cell.name), tostring(cell.chargenum), cell.currencyType, roleName, tostring(roleLv), serverName)
        local data = GoogleSDKData:GoogleChargeData(msg.cporderId, "", "", msg.innerId, msg.itemId, true)
        self.ChargeOrderTab[msg.cporderId] = data
    end
end

function ActivitySubsystem:SendMsg_Purchase_Quick_Shipment(productId, orderId, failedTime)
    if failedTime == nil then
        failedTime = 0
    end
    print("----------->", debug.traceback())
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), orderId })
    NetManager:Get():Send(MsgID.FINISH_ORDER_C2S_REQ, data)
    ActivityDataManager:Get():SetCurOrderInfo(productId, orderId, failedTime)
    --ShopDataManager:Get():SetData(msg)
    --SdkAd:Get():SdkAdjust_PayServerPre(productId)

    --请求发货


    --QuickTa:Get():Track_OrderInit("1715", "-1", -1, "-1", -1, productId, "0", tostring(orderId), "-1", "-1", -1, -1, "-1")
end

function ActivitySubsystem:SendMsg_Purchase_BaXi_Shipment(productId, orderId, payWay)

    print("----------->", debug.traceback())
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), productId, payWay })
    NetManager:Get():Send(MsgID.CREAT_EBR_ORDER_C2S_REQ, data)
end
local _Queue= Queue()
function ActivitySubsystem:RecvMsg_Purchase_Quick_FinishCharge(data)
    ---@type SC_FinishCharge
    local msg = assert(Dll_PB.decode("FinishCharge", data))
    print(ProtoMsgHelp.block(msg))
    _Queue= Queue()
    for i = 1, #msg.chargeInfo do
        _Queue:EnQueueFront(msg.chargeInfo[i])
    end
    KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume)
    self:DistributionChargeData()
end
function ActivitySubsystem:DistributionChargeData()
    if _Queue:GetSize()>0 then
        local temp=_Queue:DeQueueBack()
        if temp then
            self:RecvMsg_Purchase_Quick_Shipment(temp,function()
                self:DistributionChargeData()
            end)
        end
    end

end
---@param msg SC_ChargeFinish
function ActivitySubsystem:RecvMsg_Purchase_Quick_Shipment(msg,func)
    print("RecvMsg_Purchase_Quick_Shipment----------->", debug.traceback())
    PopUpGiftDataManager:Get():UpdateDataList(msg.buyItems)
    --CommonTipsHelper:Get():ShowCenterTips("充值成功:" )
    --掉落
    self:RefreshChargeData(msg, true, function()
        func()
        SDKHelper:Get():SimpleSendNext()
    end)
    print(ProtoMsgHelp.block(msg))
    ---@type dictcharge_config_cell
    local cell = CommonHelper:GetChargeCfgByAreaAndInnerId(msg.innerid)
    local platform = CS.UnityEngine.Application.platform
    if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk5) and platform == CS.UnityEngine.RuntimePlatform.IPhonePlayer then
        cell = CommonHelper:GetChargeCfgByAreaAndInnerIdIos2(msg.innerid)
    elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk5) and platform == CS.UnityEngine.RuntimePlatform.Android then
        cell = CommonHelper:GetChargeCfgByAreaAndInnerId(msg.innerid)
    else
        if platform == CS.UnityEngine.RuntimePlatform.IPhonePlayer then
            cell = CommonHelper:GetChargeCfgByAreaAndInnerIdIos(msg.innerid)
        else
            cell = CommonHelper:GetChargeCfgByAreaAndInnerId(msg.innerid)
        end
    end
    if cell ~= nil then
        CommonHelper:SendAdJustToken(TrackEventNames.first_pay,AnalysisType.first_pay)
        CommonHelper:SendAdJustToken(TrackEventNames.pay_done,AnalysisType.pay_done)
        local data = RechargeData()
        if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk2)then
            if  platform == CS.UnityEngine.RuntimePlatform.Android then
                data.eventName = cell.adjusttoken5
            else
                data.eventName = cell.adjusttoken4
            end
        end
        if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk3) or SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk4) then
            if  platform == CS.UnityEngine.RuntimePlatform.Android then
                data.eventName = cell.adjusttoken4
            else
                data.eventName = cell.adjusttoken5
            end
        end
        if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk5) then
            if  platform == CS.UnityEngine.RuntimePlatform.Android then
                data.eventName = cell.adjusttoken6
            else
                data.eventName = cell.adjusttoken7
            end
        end
        data.orderID = msg.cporderid
        data.paymentType = tostring(UnifySDKManager:Get():ISDK().IUnifySDK.SDKType)
        data.currencyType = "CNY"   ---目前只有国内quicksdk用的了该属性，所以直接赋值
        data.currencyAmount =  cell.chargenum
        data.customParam = UnifySDKHelper:Analysis_GetCustomData(PlayerDataManager:Get():GetPlayerRID())
        data.itemID = cell.itemid
        UnifySDKEventSystem:Publish(data);
        print("RecvMsg_Purchase_Quick_Shipment13")
    end
end

function ActivitySubsystem:SendMsg_Purchase_Google_Chick(goodsId, orderId, orderNo, purchaseToken)
    print("SendMsg_Purchase_Google_Chick" .. "goodsId" .. goodsId .. "orderId" .. orderId .. "orderNo" .. orderNo .. "purchaseToken" .. purchaseToken)
    --local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), orderId, orderNo, purchaseToken })
    --NetManager:Get():Send(MsgID.CHECK_GOOGLE_ORDER_C2S_REQ, data)
    --self.ChargeOrderTab[purchaseToken] = orderId
    --CommonHelper:PlayScreenEffectWaiting(true)
    --CommonHelper:PlayScreenEffectUIMask(10)


end

function ActivitySubsystem:SendMsg_RePurchase_Google_Chick()
    --if (#self.GoogleReloadChargeList > 0) then
    --    print(self.GoogleReloadChargeList[1][1], self.GoogleReloadChargeList[1][2], self.GoogleReloadChargeList[1][3], self.GoogleReloadChargeList[1][4])
    --    table.remove(self.GoogleReloadChargeList, 1)
    --    return
    --end
end

function ActivitySubsystem:RecvMsg_Purchase_Google_Chick(data)
    print("检测成功------", data)
    ---@type SC_ChargeOrder
    local msg = assert(Dll_PB.decode("ChargeOrder", data))
    print(ProtoMsgHelp.block(msg))

    if msg.orderstatus == 1 then
        SDKManager:Get():ConsumePurchase(msg.token)
        ---@type dictcharge_config_cell
        local cell = CommonHelper:GetChargeCfgByAreaAndInnerId(msg.innerid)
        if cell ~= nil then
            --if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK) then
            --    AdjustSdk:Get():TrackEventRevenue(cell.adjusttoken, cell.chargenum, data.token)
            --end
            --if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK2) then
            --    AdjustSdk:Get():TrackEventRevenue(cell.adjusttoken2, cell.chargenum, data.token)
            --end
            --if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK3) then
            --    AdjustSdk:Get():TrackEventRevenue(cell.adjusttoken3, cell.chargenum, data.token)
            --end
            --if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk2) then
            --    AdjustSdk:Get():TrackEventRevenue(cell.adjusttoken4, cell.chargenum, data.token)
            --end
        end
    end
    local logInfo = "orderstatus=" .. msg.orderstatus .. "token=" .. msg.token
    GoogleSDKRechargeLog:Get():AddLog("2EndPurchaseChickAndBeginConsume", logInfo)
end

function ActivitySubsystem:SendMsg_Purchase_Google_Shipment(innerId, _orderId, orderNo, token, markCode, passRid)
    --CommonHelper:PlayScreenEffectWaiting(true)
    --CommonHelper:PlayScreenEffectUIMask(10)
    print("----------->", debug.traceback())
    if CommonHelper:IsNullOrEmpty(self.ChargeFlag) then
        self.ChargeFlag = 1
    end
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), _orderId, orderNo and orderNo or "", token and token or "", self.ChargeFlag, innerId and innerId or "1", QuickTaHelper:Get():GetCcHn(), passRid and passRid or "1" })

    local msg = assert(Dll_PB.decode("BaseC2S", data))
    print(ProtoMsgHelp.block(msg))

    NetManager:Get():Send(MsgID.FINISH_GOOGLE_ORDER_C2S_REQ, data)
    GoogleSDKRechargeLog:Get():AddLog("3RequestShipment", _orderId)
    if self.ChargeOrderTab[_orderId] ~= nil then
        self.ChargeOrderTab[_orderId].googleOrderNo = orderNo
        self.ChargeOrderTab[_orderId].token = token
    else
        local data = GoogleSDKData:GoogleChargeData(_orderId, orderNo, token, innerId, "", false)
        self.ChargeOrderTab[_orderId] = data
    end
end

function ActivitySubsystem:RecvMsg_Purchase_Google_Shipment(data)
    print("购买成功------916----", data)
    ---@type SC_ChargeFinish
    local msg = assert(Dll_PB.decode("ChargeFinish", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:PlayScreenEffectWaiting(false)
    PopUpGiftDataManager:Get():UpdateDataList(msg.buyItems)
    --掉落
    ---@type GoogleChargeData
    local data = self.ChargeOrderTab[msg.cporderid]
    if msg.orderstatus >= 2 then
        if SDKHelper:Get().CurValue and not CommonHelper:IsNullOrEmpty(SDKHelper:Get().CurValue.purchaseToken) then
            SDKManager:Get():ConsumePurchase(SDKHelper:Get().CurValue.purchaseToken)
        end
        self:RefreshChargeData(msg, true, function()
            SDKHelper:Get():SimpleSendNext()
        end)
        ---@type dictcharge_config_cell
        local cell = CommonHelper:GetChargeCfgByAreaAndInnerId(msg.innerid)
        if cell ~= nil then
            if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK) then
                AdjustSdk:Get():TrackEventRevenue(cell.adjusttoken, cell.chargenum, data.token)
            end
            if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK2) then
                AdjustSdk:Get():TrackEventRevenue(cell.adjusttoken2, cell.chargenum, data.token)
            end
            if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK3) then
                AdjustSdk:Get():TrackEventRevenue(cell.adjusttoken3, cell.chargenum, data.token)
            end
            --if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK4) then
            --    AdjustSdk:Get():TrackEventRevenue(cell.adjusttoken4, cell.chargenum, data.token)
            --end
            --if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk2) then
            --    AdjustSdk:Get():TrackEventRevenue(cell.adjusttoken4, cell.chargenum, data.token)
            --end
        end

    elseif msg.orderstatus == 0 or msg.orderstatus == 1 then
        SDKHelper:Get():ReSend()
        --if data ~= nil and data.chargeReTry == true then
        --    print("RecvMsg_Purchase_Google_Shipment2222", "data.googleOrderNo", data.googleOrderNo, "data.token", data.token)
        --    self:SendMsg_Purchase_Google_Shipment("", msg.cporderid, data.googleOrderNo, data.token)
        --    self.ChargeOrderTab[msg.cporderid].chargeReTry = false
        --else
        --    self:DeLoadChargeQueueFront()
        --end
    elseif msg.orderstatus <= -1 then
        --self:DeLoadChargeQueueFront()
        SDKHelper:Get():SimpleSendNext()
    end
    GoogleSDKRechargeLog:Get():ResetLog()


end

function ActivitySubsystem:RecvMsg_Purchase_Ebr_Pre(data)
    ---@type SC_CreateSucc
    local msg = assert(Dll_PB.decode("CreateSucc", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:PlayScreenEffectWaiting(false)
    if not UIManager:Get():IsPopViewShow("ActivityCashRegisterView") then
        UIManager:Get():OpenPopup("ActivityCashRegisterView", CanvasType.TopCanvas, "ActivityCashRegisterView", true, true)
        --UIManager:Get():ShowPersistentView("ActivityCashRegisterView", CanvasType.TopCanvas, "ActivityCashRegisterView")
        UINotify:Get():SendNotification(UINotifyEvent.ActivityCashRegisterView_OpenByUrl, msg)
    end

end
---@param msg SC_ChargeFinish
function ActivitySubsystem:RefreshChargeData(msg, flag, func)
    if msg.downlist then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true, function()
            --ActivitySubsystem:Get():DeLoadChargeQueueFront()
            func()
            if UIManager:Get():IsViewShow("RecruitView") then
                UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitViewInfo)
            end
        end)
    else
        --self:DeLoadChargeQueueFront()
        func()
    end

    if msg.curActGift ~= nil and msg.curActGift.chargetype == ChargeType.EveryDayGift then
        CommonFestivalDataManager:Get():RefreshEveryDayaData(msg.curActGift)
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.EveryDayGift })
    elseif msg.curActGift ~= nil and msg.curActGift.chargetype == ChargeType.MoreMoney then
        print("MoreMoney   ----   MoreMoney")
    elseif msg.curActGift ~= nil and msg.curActGift.chargetype == ChargeType.LuckRotaryTable then
        print("LuckRotaryTable   ----   LuckRotaryTable")
    elseif msg.myAdList ~= nil  then
        TaskDataManager:Get().AdIsBuy=true
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CreateSuccess))
        UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)
    elseif msg.curActGift ~= nil and msg.curActGift.chargetype == ChargeType.Cumulative then
        CommonFestivalDataManager:Get():RefreshCumulativeCurActInfo(msg)
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.Cumulative })
    elseif msg.curActGift ~= nil and msg.curActGift.chargetype == ChargeType.CustomGift then
        CommonFestivalDataManager:Get():RefreshCustomGiftData(msg)
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.CustomGift })
    elseif msg.curActGift ~= nil and msg.curActGift.chargetype == ChargeType.GiftPackage then
        GiftPackageDataManager:Get():RefreshGiftPackageMsgData(msg)
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { -1, "Refresh" })
    elseif msg.buyActToken ~= 0 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderBuyFinish))
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_BuyFinish)
    elseif msg.buyBacksign ~= 0 then
        ReturnOldPlayerDataManager:Get():SetSignIfCharge(msg.buyBacksign)
        UINotify:Get():SendNotification(UINotifyEvent.ReturnOldPlayer_SetSign)
    elseif msg.buyActTimeToken ~= nil and msg.buyActTimeToken ~= 0 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TimeTokenBuyFinish))
        TimeTokenManager:Get():GetTimeTokenInfoData(msg.buyActTimeToken):SetIfBuy(true)
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { -1, "Refresh" })
    elseif msg.curActGift ~= nil and msg.curActGift.chargetype == ChargeType.StrengthSprintActivity then
        StrengthActivityManager:Get():RefreshStrengthActivityData(msg.curActGift)
    elseif msg.myPassFound ~= nil then
       FoundListManager:Get():UpdateBuyFinish(msg.myPassFound)
    elseif msg.buyItems~=nil and #msg.buyItems>0 then
        print(" popupgift")
    else
        print("ActivityView_RefreshChargeState")
        UINotify:Get():SendNotification(UINotifyEvent.ActivityView_RefreshChargeState)
    end

    --- 1为首充   其它为0
    if #msg.myActFirst > 0 then
    ---首次充值奖励写这里
    UserFirstGiftManager:Get():SetUserFirstGiftData(msg.myActFirst)
    end

    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { -1, "RefreshLotteryTicket" })

end
function ActivitySubsystem:CheckIdActivityType(type)

end
function ActivitySubsystem:DeLoadChargeQueueFront()

end

function ActivitySubsystem:Clear()
    self.ReloadChargeQueue.Clear()
end

local __subsystem = ActivitySubsystem()
function ActivitySubsystem:Get()
    return __subsystem
end
return __subsystem