---@class ShopSubsystem
ShopSubsystem = class("ShopSubsystem")

function ShopSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.GET_SHOP_INFO_S2C_RES, self, self.RecvMsg_ShopInfo)
    NetResponseEventManager:Get():AddListener(MsgID.REFRESH_SHOP_S2C_RES, self, self.RecvMsg_ShopInfo)
    NetResponseEventManager:Get():AddListener(MsgID.BUY_GOOD_S2C_RES, self, self.RecvMsg_Buy)
    --NetResponseEventManager:Get():AddListener(MsgID.GOOGLE_CHECK_S2C_RES, self, self.RecvMsg_Purchase)
    --NetResponseEventManager:Get():AddListener(MsgID.CREATE_ORDER_S2C_RES, self, self.RecvMsg_Purchase_Quick_Pre)
    --NetResponseEventManager:Get():AddListener(MsgID.FINISH_ORDER_S2C_RES, self, self.RecvMsg_Purchase_Quick_Shipment)
end

function ShopSubsystem:SendMsg_ShopInfo(shopid)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),shopid})
    NetManager:Get():Send(MsgID.GET_SHOP_INFO_C2S_REQ, data)
end
function ShopSubsystem:RefreshShop(shopId,isSelf)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),shopId,isSelf})
    NetManager:Get():Send(MsgID.REFRESH_SHOP_C2S_REQ, data)
end
function ShopSubsystem:RecvMsg_ShopInfo(data)
    ---@type SC_ShopInfo
    local msg = assert(Dll_PB.decode("ShopInfo", data))
    print(ProtoMsgHelp.block(msg))
    ShopDataManager:Get().ShopId=msg.shopid
    if(msg.shopid == ShopID.StrengthSprint) then
        StrengthActivityManager:Get():SetStrengthShopData(msg)
        if not UIManager:Get():IsViewShow("StrengthSprintActView")  then
            UIManager:Get():OpenPopup("StrengthSprintActView", CanvasType.MainCanvas, "StrengthSprintActView")
        else
            UINotify:Get():SendNotification(UINotifyEvent.StrengthSprint_OpenActivity)
        end
        return
    end

    if not UIManager:Get():IsViewShow("ShopView")  then
        UIManager:Get():OpenView("ShopView", CanvasType.MainCanvas, "ShopView")
    end
    ShopDataManager:Get():SetData(msg)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)
    UINotify:Get():SendNotification(UINotifyEvent.ShopView_SetData, {msg.shopid,true})
    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)
    if UIManager:Get():IsPersistentViewShow("GoodsInfoView") then
        UIManager:Get():HidePersistentView("GoodsInfoView")
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ShopViewRefreshOnSelect))
    end
    --elseif ShopDataManager:Get().ShopType[msg.shopId].inshop == 2 then
    --    UINotify:Get():SendNotification(UINotifyEvent.TrackSegmentShopViewOpen, msg.shopId)
    --end

end

function ShopSubsystem:SendMsg_Buy(shopid, id, count)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),shopid,id,count})
    NetManager:Get():Send(MsgID.BUY_GOOD_C2S_REQ, data)
end

function ShopSubsystem:RecvMsg_Buy(data)
    ---@type SC_buyShop
    local msg = assert(Dll_PB.decode("buyShop", data))
    print(ProtoMsgHelp.block(msg))
    QuickTaHelper:TrackShopEvent(msg);
    ShopDataManager:Get():UpdateShopGood(msg)
    StrengthActivityManager:Get():UpdateShopGood(msg)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)
    KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.downsome)
    if ShopDataManager:Get().IsAllBuy > 0 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CreateSuccess))
        ShopDataManager:Get().IsAllBuy = ShopDataManager:Get().IsAllBuy - 1
    else
        UINotify:Get():SendNotification(UINotifyEvent.BuyGoodSuccess, msg)
    end
    if msg.shopid == ShopID.ThreeSegment then
        UINotify:Get():SendNotification(UINotifyEvent.TrackSegmentShopViewSetPlayerMoney)
    elseif msg.shopid == ShopID.StrengthSprint then
        UIManager:Get():HidePersistentView("GoodsInfoView")
        UINotify:Get():SendNotification(UINotifyEvent.BuyGoodSuccess, msg)
        UINotify:Get():SendNotification(UINotifyEvent.StrengthSprint_RefreshData)
    else
        UIManager:Get():ClosePopup()
        UINotify:Get():SendNotification(UINotifyEvent.BuyGoodSuccess, msg)
        UINotify:Get():SendNotification(UINotifyEvent.ShopView_SetData, {msg.shopid,false})
    end

end

function ShopSubsystem:SendMsg_Purchase(packageName, productId, token, orderId)
    local reqData = {
        orderId = orderId,
        packageName = packageName,
        productId = productId,
        token = token,
    }
    local reqBytes = assert(Dll_PB.encode("GoogleCheckReq", reqData))
    NetManager:Get():Send(OldMsgID.GOOGLE_CHECK_C2S_REQ, reqBytes)
end

function ShopSubsystem:RecvMsg_Purchase(data)
    ---@type SC_GoogleCheckRes
    local msg = assert(Dll_PB.decode("GoogleCheckRes", data))
    print(ProtoMsgHelp.block(msg))

    print("购买成不成功------", msg.gpState)
    if #msg.items > 0 then
        CommonHelper:ShowGetReward(msg.items, true)
    end

    --SDKManager:Get():Global_ConfirmPurchase(msg.purchaseToken)
end

--function ShopSubsystem:SendMsg_Purchase_Quick_Pre(itemId)
--    --local reqData = {
--    --    productId = productId,
--    --}
--    --local reqBytes = assert(Dll_PB.encode("OrderCreateReq", reqData))
--    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),itemId })
--    NetManager:Get():Send(MsgID.CREATE_ORDER_C2S_REQ, data)
--    SdkAd:Get():SdkAdjust_Prepay(itemId)
--    --QuickTa:Get():Track_OrderInit("1713", "-1", -1, "-1", -1, itemId, "0", "-1", "-1", "-1", -1, -1, "-1")
--end
--
--function ShopSubsystem:SendMsg_Purchase_Editor_Pre(itemId)
--    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),itemId })
--    print("假充值：" .. itemId)
--    NetManager:Get():Send(MsgID.CREATE_ORDER_FALSE_C2S_REQ, data)
--end
--function ShopSubsystem:RecvMsg_Purchase_Quick_Pre(data)
--    ---@type SC_CreateSucc
--    local msg = assert(Dll_PB.decode("CreateSucc", data))
--    print(ProtoMsgHelp.block(msg))
--
--    ---@type dictcharge_config_cell
--    local cell = CommonHelper:GetTableDataByID(ConfigNames.dictcharge_config, msg.itemId)
--
--    if msg.cporderId ~= nil then
--        local roleName = PlayerDataManager:Get():GetPlayerName() or ""
--        local roleLv = PlayerDataManager:Get():GetPlayerLV() or ""
--        local serverName = "NormalServer"
--        if PlayerDataManager:Get():GetPlayerServerID() ~= nil then
--            if ClientDataManager:Get():GetServerInfoByServerId(PlayerDataManager:Get():GetPlayerServerID()) ~= nil then
--                serverName = ClientDataManager:Get():GetServerInfoByServerId(PlayerDataManager:Get():GetPlayerServerID()):GetName()
--            end
--        end
--        -- ShopSubsystem:SendMsg_Purchase_Quick_ShipmentWeek(msg.productId, msg.cpOrderNo,cell.cardId)
--        -- ShopSubsystem:Get():SendMsg_Purchase_Quick_Shipment(msg.productId, msg.cpOrderNo)
--        --local setJfExtInfo =PlayerDataManager:Get():GetPlayerServerID()
--        SDKManager:Get():CreateOrder(msg.innerId, "", msg.cporderId, cell.name, tostring(cell.chargenum), cell.currencyType, roleName, tostring(roleLv), serverName)
--        SdkAd:Get():SdkAdjust_PayServerBack(msg.cporderId)
--
--        --QuickTa:Get():Track_OrderInit("1714", "USD", -1, "-1", -1, msg.innerId, "0", tostring(msg.cporderId), "-1", "-1", -1, cell.price, "-1")
--    end
--end
--
--function ShopSubsystem:SendMsg_Purchase_Quick_Shipment(productId, orderId)
--    --请求发货
--    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),orderId })
--    NetManager:Get():Send(MsgID.FINISH_ORDER_C2S_REQ, data)
--    ShopDataManager:Get():SetData(msg)
--    SdkAd:Get():SdkAdjust_PayServerPre(productId)
--
--    --QuickTa:Get():Track_OrderInit("1715", "-1", -1, "-1", -1, productId, "0", tostring(orderId), "-1", "-1", -1, -1, "-1")
--end
--
--function ShopSubsystem:RecvMsg_Purchase_Quick_Shipment(data)
--    print("购买成不成功------", data)
--    ---@type SC_ChargeFinish
--    local msg = assert(Dll_PB.decode("ChargeFinish", data))
--    print(ProtoMsgHelp.block(msg))
--
--    --CommonTipsHelper:Get():ShowCenterTips("充值成功:" )
--
--    --掉落
--    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
--    ----各类礼包
--    if msg.curActGift and msg.curActGift > 0 then
--        --doSomething about curActGift
--    end
--    ----周月卡
--    if msg.curActPeriod and #msg.curActPeriod > 0 then
--        --doSomething about curActPeriod
--    end
--    --- 1为首充   其它为0
--    if msg.firstflag == 1 then
--        ---首次充值奖励写这里
--        UserFirstGiftManager:Get():SetUserFirstGiftData(msg.myActFirst)
--    end
--    UINotify:Get():SendNotification(UINotifyEvent.ActivityView_RefreshChargeState)
--    SdkAd:Get():SdkAdjust_PayServerBack()
--
--    --QuickTa:Get():Track_OrderInit("1716", "-1", -1, "-1", -1, "-1", "0", "-1", "-1", "-1", -1, -1, "-1")
--end

local __subsystem = ShopSubsystem()
function ShopSubsystem:Get()
    return __subsystem
end
return __subsystem