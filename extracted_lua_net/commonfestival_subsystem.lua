---@class CommonFestivalSubSystem
CommonFestivalSubSystem = class("CommonFestivalSubSystem")

function CommonFestivalSubSystem:initialize(...)
    --250, --返回签到活动
    NetResponseEventManager:Get():AddListener(MsgID.RET_ACT_SIGN_NFO, self, self.RecMsg_SignInfo)
    --252, --返回签到
    NetResponseEventManager:Get():AddListener(MsgID.RET_ACT_SIGN_NOW, self, self.RecMsg_SignNow)
    --254, --返回活动兑换商城
    NetResponseEventManager:Get():AddListener(MsgID.RET_ACT_SHOP_INFO, self, self.RecMsg_ActShopInfo)
    --256, --返回活动商城
    NetResponseEventManager:Get():AddListener(MsgID.RET_BUY_ACT_SHOP, self, self.RecMsg_BuyActShop)
    --258, --返回活动日礼包
    NetResponseEventManager:Get():AddListener(MsgID.RET_ACT_DAY_GIFT, self, self.RecMsg_ActDayGift)
    --260, --返回最终奖励
    NetResponseEventManager:Get():AddListener(MsgID.RET_ACT_DAY_FINISH, self, self.RecMsg_ActDayFinish)

    ----TWO---------------------------------------------------------------------------------------------------------------------------

    --268, --返回查看暴击充值礼包
    NetResponseEventManager:Get():AddListener(MsgID.RET_ACT_CHARGE_GIFT, self, self.RecMsg_ActChargeGift)
    --270, --返回累计充值
    NetResponseEventManager:Get():AddListener(MsgID.RET_COUNT_CHARGE, self, self.RecMsg_CountCharge)
    --272, --累计充值奖励
    NetResponseEventManager:Get():AddListener(MsgID.RET_COUNT_GIFT, self, self.RecMsg_CountGift)
    --278, --返回定制礼包
    NetResponseEventManager:Get():AddListener(MsgID.RET_DESIGN_GIFT, self, self.RecMsg_DesignGift)
    --288, --返回活动任务
    NetResponseEventManager:Get():AddListener(MsgID.RET_ACT_MISSION, self, self.RecMsg_RetActMission)
    --290,
    NetResponseEventManager:Get():AddListener(MsgID.RET_LOCK_DESIGN, self, self.RecMsg_RetLockDesign)


    --292, --返回幸运签
    NetResponseEventManager:Get():AddListener(MsgID.RET_LUCK_INFO, self, self.RecMsg_RetLuckInfo)
    --294, --返回幸运签
    NetResponseEventManager:Get():AddListener(MsgID.RET_LUCK_AWARD, self, self.RecMsg_RetLuckAward)
    --296, --返回幸运转盘
    NetResponseEventManager:Get():AddListener(MsgID.RET_LUCKY_TABLE, self, self.RecMsg_RetLuckyTable)
    --230, --返回集字奖励列表
    NetResponseEventManager:Get():AddListener(MsgID.RET_ACT_WORD_LIST, self, self.RecMsg_RetActWordList)
    --232, --返回集字奖励
    NetResponseEventManager:Get():AddListener(MsgID.RET_ACT_WORD_GIFT, self, self.RecMsg_RetActWordGift)

    --167  限时活动通行证
    NetResponseEventManager:Get():AddListener(MsgID.ACT_TIME_TOKEN_S2C_RET, self, self.RecMsg_ActTimeToken)
    --169  限时活动通行证奖励
    NetResponseEventManager:Get():AddListener(MsgID.ACT_GIFT_TIME_TOKEN_S2C_RET, self, self.RecMsg_ActGiftTimeToken)
    --176  限时活动通行证奖励
    NetResponseEventManager:Get():AddListener(MsgID.ACT_UP_TIME_TOKEN_LEV_S2C_RET, self, self.RecMsg_ActUpTimeTokenLev)
    --527, --返回回归支援列表
    NetResponseEventManager:Get():AddListener(MsgID.RE_BACK_SUPPORT_S2C_RES, self, self.RecMsg_ReBackSupport)
    --529, --返回请求支援
    NetResponseEventManager:Get():AddListener(MsgID.SUPPORT_PART_S2C_RES, self, self.RecMsg_SupportPart)
    --590  累计充值信息
    NetResponseEventManager:Get():AddListener(MsgID.SUM_CHARGE_S2C_RES, self, self.RecMsg_ActSumCharge)
    --592  返回累计充值信息
    NetResponseEventManager:Get():AddListener(MsgID.SUM_CHARGE_GIFT_S2C_REQ, self, self.RecMsg_ActSumChargeGift)
    --624  返回限时活动礼包
    NetResponseEventManager:Get():AddListener(MsgID.ACT_GIFT_PACKAGE_S2C_RES, self, self.RecMsg_ActGiftPackage)
end

--249 请求签到活动信息 P2=actid
function CommonFestivalSubSystem:SendMsg_SignInfo(actid)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actid })
    NetManager:Get():Send(MsgID.REQ_ACT_SIGN_NFO, data)

end

--250 返回签到活动
function CommonFestivalSubSystem:RecMsg_SignInfo(data)
    ---@type SC_ActSign
    local msg = assert(Dll_PB.decode("ActSign", data))
    print(ProtoMsgHelp.block(msg))

    if not UIManager:Get():IsPopViewShow("CommonNewActView") then
        UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
    end
    ---@type act_bussiness_config_cell
    local actConfig = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, msg.actId)
    ActSignInDataManager:Get():SetActSignIsResetFlag(true)
    ActSignInDataManager:Get():SetDataByMsgActSign(msg)

    if actConfig and actConfig.actstyle == CommonFestivalType.SpringSignIn then
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_OpenPage, msg.actId)
    else
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.SignIn })
    end

end

--251 请求签到P2=actid P3=签到天 P4=0正常1补签
function CommonFestivalSubSystem:SendMsg_SignNow(actID, SignInDay, _num)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actID, SignInDay, _num })
    NetManager:Get():Send(MsgID.REQ_ACT_SIGN_NOW, data)
end

--252 返回签到
function CommonFestivalSubSystem:RecMsg_SignNow(data)
    ---@type SC_ActSignNow
    local msg = assert(Dll_PB.decode("ActSignNow", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.mySomeDown[1], true)

    ---@type act_bussiness_config_cell
    local actConfig = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, msg.curActSign.actId)
    ActSignInDataManager:Get():SetActSignIsResetFlag(false)
    ActSignInDataManager:Get():SetDataByMsgActSign(msg.curActSign)

    if actConfig and actConfig.actstyle == CommonFestivalType.SpringSignIn then

        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { msg.curActSign.actId, "Refresh" })
        RedPointManager:Get():UpdateValue(RedPointID.S_SpringSignIn, false)
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshChooseBtn)
    else
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg.curActSign, CommonFestivalType.SignIn })
    end

end

--253 请求活动兑换商城P2=shopid
function CommonFestivalSubSystem:SendMsg_ActShopInfo(shopID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), shopID })
    NetManager:Get():Send(MsgID.REQ_ACT_SHOP_INFO, data)
end

--254 返回活动兑换商城
function CommonFestivalSubSystem:RecMsg_ActShopInfo(data)
    ---@type SC_ActShopInfo
    local msg = assert(Dll_PB.decode("ActShopInfo", data))
    print(ProtoMsgHelp.block(msg))

    if not UIManager:Get():IsPopViewShow("CommonNewActView") then
        UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
    end
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.Exchange })
end

--255 请求兑换商城物品P2=shopid P3=商品idP4=数量
function CommonFestivalSubSystem:SendMsg_BuyActShop(shopID, goodsID, _num)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), shopID, goodsID, _num })
    NetManager:Get():Send(MsgID.REQ_BUY_ACT_SHOP, data)
end

--256 返回活动商城
function CommonFestivalSubSystem:RecMsg_BuyActShop(data)
    ---@type SC_buyActShop
    local msg = assert(Dll_PB.decode("buyActShop", data))
    print(ProtoMsgHelp.block(msg))

    CommonHelper:ShowGetRewardDataBySomeDown(msg.downsome, true)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)
    --UINotify:Get():SendNotification(UINotifyEvent.CommonFestival_RefreshExchangeByID, msg)

    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.Exchange })
end

--257, --请求查看活动日礼包 P2=活动id
function CommonFestivalSubSystem:SendMsg_ActDayGift(actID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actID })
    NetManager:Get():Send(MsgID.REQ_ACT_DAY_GIFT, data)
end

--258, --返回活动日礼包
function CommonFestivalSubSystem:RecMsg_ActDayGift(data)
    ---@type SC_ActDayGift
    local msg = assert(Dll_PB.decode("ActDayGift", data))
    print(ProtoMsgHelp.block(msg))

    --if not UIManager:Get():IsPopViewShow("CommonFestivalView") then
    --    UIManager:Get():OpenPopup("CommonFestivalView", CanvasType.MainCanvas, "CommonFestivalView", true)
    --end
    --UINotify:Get():SendNotification(UINotifyEvent.CommonFestival_RefreshChargeByID, msg)

    if not UIManager:Get():IsPopViewShow("CommonNewActView") then
        UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
    end
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.Charge })
end

--259, --请求活动日礼包最终奖励 P2=活动id
function CommonFestivalSubSystem:SendMsg_ActDayFinish(giftID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), giftID })
    NetManager:Get():Send(MsgID.REQ_ACT_DAY_FINISH, data)
end

--260, --返回最终奖励
function CommonFestivalSubSystem:RecMsg_ActDayFinish(data)
    ---@type SC_ActDayGiftFinish
    local msg = assert(Dll_PB.decode("ActDayGiftFinish", data))
    print(ProtoMsgHelp.block(msg))

    if msg.mySomeDown and #msg.mySomeDown > 0 then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.mySomeDown[1], true)
    end
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshReOpen)
end

----TWO---------------------------------------------------------------------------------------------------------------------------

-- 267, --请求查看暴击充值礼包 P2=活动id
function CommonFestivalSubSystem:SendMsg_ActChargeGift(actID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actID })
    NetManager:Get():Send(MsgID.REQ_ACT_CHARGE_GIFT, data)
end

--268, --返回查看暴击充值礼包
function CommonFestivalSubSystem:RecMsg_ActChargeGift(data)
    ---@type SC_ActChargeGift
    local msg = assert(Dll_PB.decode("ActChargeGift", data))
    print(ProtoMsgHelp.block(msg))

    if not UIManager:Get():IsPopViewShow("CommonNewActView") then
        UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
    end
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.MoreMoney })
end


--269, --请求累计充值P2=活动id
function CommonFestivalSubSystem:SendMsg_CountCharge(actID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actID })
    NetManager:Get():Send(MsgID.REQ_COUNT_CHARGE, data)
end

--= 270, --返回累计充值
function CommonFestivalSubSystem:RecMsg_CountCharge(data)
    ---@type SC_ActivityInfo
    local msg = assert(Dll_PB.decode("ActivityInfo", data))
    print(ProtoMsgHelp.block(msg))

    CommonFestivalDataManager:Get():InitCumulativeCurActCount(msg)
    CommonFestivalDataManager:Get():InitCumulativeCurActInfo(msg)
    CommonFestivalDataManager:InitActive(msg)

    if not UIManager:Get():IsPopViewShow("CommonNewActView") then
        UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
    end
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.Cumulative })
end

--271, --请求累计充值奖励P2=活动idP3=序号0开始
function CommonFestivalSubSystem:SendMsg_CountGift(actID, countNo)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actID, countNo })
    NetManager:Get():Send(MsgID.REQ_COUNT_GIFT, data)
end

--272, --累计充值奖励
function CommonFestivalSubSystem:RecMsg_CountGift(data)
    ---@type SC_ActCountGift
    local msg = assert(Dll_PB.decode("ActCountGift", data))
    print(ProtoMsgHelp.block(msg))

    if msg.downList then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.downList, true)
    end

    CommonFestivalDataManager:Get():RefreshCumulativeFlagInfo(msg)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.Cumulative })
end

--277 请求定制礼包P2=actid
function CommonFestivalSubSystem:SendMsg_DesignGift(actID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actID })
    NetManager:Get():Send(MsgID.REQ_DESIGN_GIFT, data)
end

--278, --返回定制礼包
function CommonFestivalSubSystem:RecMsg_DesignGift(data)
    ---@type SC_ActDesignList
    local msg = assert(Dll_PB.decode("ActDesignList", data))
    print(ProtoMsgHelp.block(msg))

    if not UIManager:Get():IsPopViewShow("CommonNewActView") then
        UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
    end

    CommonFestivalDataManager:Get():InitCustomGiftData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.CustomGift })
end

--287, --请求抽取活动任务P2=次数
function CommonFestivalSubSystem:SendMsg_ActMission(NumID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), NumID })
    NetManager:Get():Send(MsgID.REQ_ACT_MISSION, data)
end

--288, --返回活动任务
function CommonFestivalSubSystem:RecMsg_RetActMission(data)
    ---@type SC_ActMission
    local msg = assert(Dll_PB.decode("ActMission", data))
    print(ProtoMsgHelp.block(msg))

    if msg.curConsume then
        KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume, true)
    end

    if not UIManager:Get():IsPopViewShow("CommonNewActView") then
        UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
    end
    CommonFestivalDataManager:Get():RefreshLimitTaskData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.LimitTask })
    UINotify:Get():SendNotification(UINotifyEvent.CommonFestival_RefreshLimitTaskTurn, msg)
end

function CommonFestivalSubSystem:SendMsg_LockDesign(ChargeID, actID, ChargeStr)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), ChargeID, actID, ChargeStr })
    NetManager:Get():Send(MsgID.REQ_LOCK_DESIGN, data)
end

--290, --返回定制礼包锁定
function CommonFestivalSubSystem:RecMsg_RetLockDesign(data)
    ---@type SC_ActDesignList
    local msg = assert(Dll_PB.decode("ActDesignList", data))
    print(ProtoMsgHelp.block(msg))

    CommonFestivalDataManager:Get():RefreshCustomGiftIfBuy(msg)
    --UINotify:Get():SendNotification(UINotifyEvent.CommonFestivalTwo_RefreshCustomGift)

    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.CustomGift })
end

--291, --请求幸运签信息
function CommonFestivalSubSystem:SendMsg_LuckInfo(actId)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actId })
    NetManager:Get():Send(MsgID.REQ_LUCK_INFO, data)

end

--292, --返回幸运签
function CommonFestivalSubSystem:RecMsg_RetLuckInfo(data)
    ---@type SC_ActLuckInfo
    local msg = assert(Dll_PB.decode("ActLuckInfo", data))
    print(ProtoMsgHelp.block(msg))
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_OpenPage, msg.actId)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { msg.actId, "Refresh", msg.luckflag == 0 })
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshChooseBtn)


end

--293, --请求幸运签奖励
function CommonFestivalSubSystem:SendMsg_LuckAward(actId)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actId })
    NetManager:Get():Send(MsgID.REQ_LUCK_AWARD, data)

end

--294, --返回幸运签奖励
function CommonFestivalSubSystem:RecMsg_RetLuckAward(data)
    ---@type SC_ActLuckAward
    local msg = assert(Dll_PB.decode("ActLuckAward", data))
    print(ProtoMsgHelp.block(msg))
    local actLuckInfoEvent = ActLuckInfoEvent()
    local delayAwardShow = function()
        if msg.mySomeDown and #msg.mySomeDown > 0 then
            CommonHelper:ShowGetRewardDataBySomeDown(msg.mySomeDown[1], true)
        end
    end
    actLuckInfoEvent:SetDataByMsg(msg, false, delayAwardShow)
    if actLuckInfoEvent.isUnLuckyDraw == false then
        if RedPointManager:Get():GetValue(RedPointID.S_LuckInfo) == true then
            RedPointManager:Get():UpdateValue(RedPointID.S_LuckInfo, false)
            UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshChooseBtn)
        end
    end
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { msg.actId, "ShowAward", actLuckInfoEvent })

end

--295, --"请求幸运转盘 P2=次数
function CommonFestivalSubSystem:SendMsg_LuckTable(number, actId)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), number, actId })
    NetManager:Get():Send(MsgID.REQ_LUCKY_TABLE, data)

end

--296, --返回幸运转盘
function CommonFestivalSubSystem:RecMsg_RetLuckyTable(data)
    ---@type SC_ActLuckTable
    local msg = assert(Dll_PB.decode("ActLuckTable", data))
    print(ProtoMsgHelp.block(msg))
    if msg.curConsume then
        KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume)
    end
    local delayAwardShow = function()
        if msg.mySomeDown and #msg.mySomeDown > 0 then
            CommonHelper:ShowGetRewardDataBySomeDown(msg.mySomeDown[1], true)
        end
    end
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { msg.actId, "RetLuckyTable", delayAwardShow, msg.hitSeq })

end

--229, --请求集字奖励
function CommonFestivalSubSystem:SendMsg_ActWordList(actId)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actId })
    NetManager:Get():Send(MsgID.REQ_ACT_WORD_LIST, data)
end

--230, --返回集字奖励列表
function CommonFestivalSubSystem:RecMsg_RetActWordList(data)
    ---@type SC_ActWordList
    local msg = assert(Dll_PB.decode("ActWordList", data))
    print(ProtoMsgHelp.block(msg))
    for i = 1, #msg.myWordExch do
        local collectData = CollectDataManager:Get():GetCollectDataByConfigIndex(msg.myWordExch[i].exchinx, msg.actId)
        if collectData then
            collectData:SetDataByMsg(msg.myWordExch[i])
        end
    end
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_OpenPage, msg.actId)
end

--231, --请求领取集字奖励 P2=奖励id
function CommonFestivalSubSystem:SendMsg_ActWordGift(index, actId)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), index, actId })
    NetManager:Get():Send(MsgID.REQ_ACT_WORD_GIFT, data)
end

--232, --返回集字奖励
function CommonFestivalSubSystem:RecMsg_RetActWordGift(data)
    ---@type SC_ActWordGift
    local msg = assert(Dll_PB.decode("ActWordGift", data))
    print(ProtoMsgHelp.block(msg))
    if msg.curConsume and #msg.curConsume > 0 then
        KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsume)
    end
    if msg.mySomeDown and #msg.mySomeDown > 0 then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.mySomeDown[1], true)
    end
    local collectData = CollectDataManager:Get():GetCollectDataByConfigIndex(msg.exchprop.exchinx, msg.actId)
    collectData:SetDataByMsg(msg.exchprop)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { msg.actId, "Refresh" })
end

--166, --请求限时活动通行证 P2=actId
function CommonFestivalSubSystem:SendMsg_ActTimeToken(actId)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actId })
    NetManager:Get():Send(MsgID.ACT_TIME_TOKEN_C2S_REQ, data)
end

--167, --限时活动通行证
function CommonFestivalSubSystem:RecMsg_ActTimeToken(data)
    ---@type SC_ActTimeToken
    local msg = assert(Dll_PB.decode("ActTimeToken", data))
    print(ProtoMsgHelp.block(msg))
    TimeTokenManager:Get():SetInfoDataByActToken(msg)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_OpenPage, msg.tokenid)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { -1, "Refresh" })
end

--168, --请求领取限时活动通行证奖励P2=actId
function CommonFestivalSubSystem:SendMsg_ActGiftTimeToken(actId)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actId })
    NetManager:Get():Send(MsgID.ACT_GIFT_TIME_TOKEN_C2S_REQ, data)
end

--169, --限时活动通行证奖励
function CommonFestivalSubSystem:RecMsg_ActGiftTimeToken(data)
    ---@type SC_GiftActTimeToken
    local msg = assert(Dll_PB.decode("GiftActTimeToken", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
    TimeTokenManager:Get():SetInfoDataByActToken(msg.alterActToken)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { msg.alterActToken.tokenid, "Refresh" })
end

--175, --请求购买限时活动通行证等级P2=actidP3=增加等级
function CommonFestivalSubSystem:SendMsg_ActUpTimeTokenLev(actId, lev)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actId, lev })
    NetManager:Get():Send(MsgID.ACT_UP_TIME_TOKEN_LEV_C2S_REQ, data)
end

--176, --返回限时通行证
function CommonFestivalSubSystem:RecMsg_ActUpTimeTokenLev(data)
    ---@type SC_BuyActTimeToken
    local msg = assert(Dll_PB.decode("BuyActTimeToken", data))
    print(ProtoMsgHelp.block(msg))
    TimeTokenManager:Get():SetInfoDataByActToken(msg.alterActTimeToken)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CreateSuccess))
    --UINotify:Get():SendNotification(UINotifyEvent.CommonAct_OpenPage, msg.tokenid)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { msg.alterActTimeToken.tokenid, "Refresh" })
end


--526, --请求回归支援列表
function CommonFestivalSubSystem:SendMsg_ReBackSupport()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.RE_BACK_SUPPORT_C2S_REQ, data)
end

--527, --返回回归支援列表
function CommonFestivalSubSystem:RecMsg_ReBackSupport(data)
    ---@type SC_SupportList
    local msg = assert(Dll_PB.decode("SupportList", data))
    print(ProtoMsgHelp.block(msg))

    if not UIManager:Get():IsPopViewShow("CommonNewActView") then
        UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
    end

    ReturnOldPlayerDataManager:Get():InitReBackSupportData(msg)
    --UINotify:Get():SendNotification(UINotifyEvent.ReturnOldPlayer_SetSupport)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_OpenPage, msg.actId)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { msg.actId, "RefreshSupportData" })

end

--528, --请求支援 P2=槽位loc P3=配件id
function CommonFestivalSubSystem:SendMsg_SupportPart(loc, ID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), loc, ID })
    NetManager:Get():Send(MsgID.SUPPORT_PART_C2S_REQ, data)
end

--529, --返回请求支援
function CommonFestivalSubSystem:RecMsg_SupportPart(data)
    ---@type SC_SupportPart
    local msg = assert(Dll_PB.decode("SupportPart", data))
    print(ProtoMsgHelp.block(msg))

    KnapsackDataManager:Get():AddPart({ msg.downPart })
    ReturnOldPlayerDataManager:Get():RefreshReBackSupportData(msg.curSupports)

    --UINotify:Get():SendNotification(UINotifyEvent.ReturnOldPlayer_SetSupport)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { msg.actId, "RefreshSupportData" })

end

--589, --请求累计充值信息 P2=活动id
function CommonFestivalSubSystem:SendMsg_ActSumCharge(actId)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actId })
    NetManager:Get():Send(MsgID.SUM_CHARGE_C2S_REQ, data)
end

--590, --累计充值信息
function CommonFestivalSubSystem:RecMsg_ActSumCharge(data)
    ---@type SC_ActSumCharge
    local msg = assert(Dll_PB.decode("ActSumCharge", data))
    print(ProtoMsgHelp.block(msg))
    RechargeRewardManager:Get():SetRechargeIsResetFlag(true)
    RechargeRewardManager:Get():SetInfoDataByActSumCharge(msg)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_OpenPage, msg.actId)
end

--591, --请求累计充值奖励 P2=活动id P3=0领取宝箱1累计奖P4=奖励序号
function CommonFestivalSubSystem:SendMsg_ActSumChargeGift(actId, receiveType, index)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actId, receiveType, index })
    NetManager:Get():Send(MsgID.SUM_CHARGE_GIFT_C2S_REQ, data)
end

--592, --返回累计充值信息
function CommonFestivalSubSystem:RecMsg_ActSumChargeGift(data)
    ---@type SC_ActSumCharge
    local msg = assert(Dll_PB.decode("ActSumCharge", data))
    print(ProtoMsgHelp.block(msg))
    RechargeRewardManager:Get():SetRechargeIsResetFlag(false)
    RechargeRewardManager:Get():SetInfoDataByActSumCharge(msg)
    if msg.mySomeDown and #msg.mySomeDown > 0 then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.mySomeDown[1], true)
    end
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { -1, "Refresh" })
end


--623, --請求限时活动礼包 P2=actid
function CommonFestivalSubSystem:SendMsg_ActGiftPackage(actID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actID })
    NetManager:Get():Send(MsgID.ACT_GIFT_PACKAGE_C2S_REQ, data)
end

--624, --返回限时活动礼包
function CommonFestivalSubSystem:RecMsg_ActGiftPackage(data)
    ---@type SC_ActGiftPackage
    local msg = assert(Dll_PB.decode("ActGiftPackage", data))
    print(ProtoMsgHelp.block(msg))
    GiftPackageDataManager:Get():SetGiftPackageIsResetFlag(true)
    GiftPackageDataManager:Get():SetGiftPackageMsgData(msg)

    if not UIManager:Get():IsPopViewShow("CommonNewActView") then
        UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
    end

    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_OpenPage, msg.actId)
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction, { msg.actId, "Refresh" })
    UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshChooseBtn)
end

function CommonFestivalSubSystem:Clear()

end

local __subsystem = CommonFestivalSubSystem()

function CommonFestivalSubSystem:Get()
    return __subsystem
end

return __subsystem

