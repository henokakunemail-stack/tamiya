---@class KnapsackSubsystem
KnapsackSubsystem = class("ArticleSubsystem")

function KnapsackSubsystem:initialize(...)
    --NetResponseEventManager:Get():AddListener(MsgID.ARTICLE_CHANGE_S2C_NOTIFY, self, self.RecvMsg_Acticle)
    NetResponseEventManager:Get():AddListener(MsgID.GET_REWARD_S2C_RES, self, self.RecvMsg_UseArticle)
    NetResponseEventManager:Get():AddListener(MsgID.USE_COMPOSE_DRAW_S2C_RES, self, self.RecvMsg_ComposeDraw)
    NetResponseEventManager:Get():AddListener(MsgID.GET_ARTICLE_LEVEL_LIST_S2C_RES, self, self.RecvMsg_ArticleLevelList)
    NetResponseEventManager:Get():AddListener(MsgID.ADD_ARTICLE_LOCK_S2C_RES, self, self.RecvMsg_PartLock)
    --NetResponseEventManager:Get():AddListener(MsgID.ARTICLE_CONFIG_ID_S2C_RES, self, self.RecvMsg_UseArticleByCfgID)
    NetResponseEventManager:Get():AddListener(MsgID.OPTIONAL_BOX_S2C_RES, self, self.RecvMsg_OpenOptionalBox)


    NetResponseEventManager:Get():AddListener(MsgID.OPEN_RAND_BOX_S2C_RES, self, self.RecvMsg_OpenRandomBox)
    NetResponseEventManager:Get():AddListener(MsgID.SELL_GOODS_S2C_RES, self, self.RecvMsg_SellGoods)
end

function KnapsackSubsystem:RecvMsg_Acticle(data)
    print("---   得到背包数据")
    ---@type  SC_NotifyArticleChange
    local msg = assert(Dll_PB.decode("NotifyArticleChange", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():SetMsgData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.BagViewRefresh)
    -- UINotify:Get():SendNotification(UINotifyEvent.KnapsackView_RefreshData)
end

function KnapsackSubsystem:SendMsg_UseArticle(cellid, count)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),cellid,count})
    NetManager:Get():Send(MsgID.GET_REWARD_C2S_REQ, reqBytes)
end
function KnapsackSubsystem:SendMsg_UseCompose_Draw(cellid, count)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),cellid})
    NetManager:Get():Send(MsgID.USE_COMPOSE_DRAW_C2S_REQ, reqBytes)
end
function KnapsackSubsystem:RecvMsg_UseArticle(data)
    log("---   使用物品成功")
    ---@type SC_OpenPackage
    local msg = assert(Dll_PB.decode("OpenPackage", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:UserGetReward(msg)
    UINotify:Get():SendNotification(UINotifyEvent.BagViewRefresh,false)
end
function KnapsackSubsystem:RecvMsg_ComposeDraw(data)
    log("---   使用合成图成功")
    ---@type SC_OpenPackage
    local msg = assert(Dll_PB.decode("CreateLabTarg", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsume(msg.drugCousume)
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.UsePropSuccess))
    UINotify:Get():SendNotification(UINotifyEvent.BagViewRefresh,false)
    UINotify:Get():SendNotification(UINotifyEvent.CostUseViewRefresh)
end

function KnapsackSubsystem:SendMsg_PartLock(cellid, value)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),cellid,value})
    NetManager:Get():Send(MsgID.ADD_ARTICLE_LOCK_C2S_REQ, reqBytes)

end
function KnapsackSubsystem:RecvMsg_PartLock(data)
    ---@type SC_UserPart
    local msg = assert(Dll_PB.decode("UserPart", data))
    print(ProtoMsgHelp.block(msg))

    local article = KnapsackDataManager:Get():GetArticleByCellID(msg.partinx)
    if article then article:UpdatePartLock(msg.lockstatus) end
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartLock)
end


function KnapsackSubsystem:SendMsg_UseArticleByCfgID(cfgid, count)
    local reqData = {
        cellId = cfgid,
        num = count,
    }
    local reqBytes = assert(Dll_PB.encode("UseArticleReq", reqData))
    NetManager:Get():Send(MsgID.GET_USE_DRUG_PWR_C2S_REQ, reqBytes)
end
function KnapsackSubsystem:SendMsg_GetArticleLevelList(id)

    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.GET_ARTICLE_LEVEL_LIST_C2S_REQ, reqBytes)
end
function KnapsackSubsystem:RecvMsg_ArticleLevelList(data)
    local msg = assert(Dll_PB.decode("GetWay", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():OpenPopup("QuickGetArticleView",CanvasType.FrontCanvas,"QuickGetArticleView")
    UINotify:Get():SendNotification(UINotifyEvent.QuickGetArticleView_SetData,msg)
end



function KnapsackSubsystem:RecvMsg_UseArticleByCfgID(data)
    log("---   UseArticleByCfgID 使用物品成功")
    ---@type SC_UseArticleRes
    local msg = assert(Dll_PB.decode("UseArticleRes", data))
    print(ProtoMsgHelp.block(msg))

    --{{{使用车库钥匙
    local caridxArticle = CommonHelper:GetCarIdxArticleCfg()
    if caridxArticle and caridxArticle.id == msg.configId then
        UINotify:Get():SendNotification(UINotifyEvent.Msg_CarIdxOpen)
    end
    --}}}


    --{{{使用体力药剂
    local powerArticle = CommonHelper:GetPowerArticleCfg()
    if powerArticle and powerArticle.id == msg.configId then
        UINotify:Get():SendNotification(UINotifyEvent.StaminaView_UpdateData,false)
    end
    --}}}


    if #msg.items > 0 then
        CommonHelper:ShowGetReward(msg.items)
    end

end

---请求打开自选宝箱P2=宝箱idP3=选中序号0-x
function KnapsackSubsystem:SendMsg_OpenOptionalBox(boxId,index,num)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),boxId,index,num})
    NetManager:Get():Send(MsgID.OPTIONAL_BOX_C2S_REQ, reqBytes)
end

---返回自选宝箱
function KnapsackSubsystem:RecvMsg_OpenOptionalBox(data)
    log("---  打开自选宝箱")
    ---@type SC_OpenOptionalBox
    local msg = assert(Dll_PB.decode("OpenOptionalBox", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:UserGetReward(msg)
    UINotify:Get():SendNotification(UINotifyEvent.BagViewRefresh,false)
end

---请求打开随机宝箱 P2=宝箱id
function KnapsackSubsystem:SendMsg_OpenRandomBox(boxId,num)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),boxId,num})
    NetManager:Get():Send(MsgID.OPEN_RAND_BOX_C2S_REQ, reqBytes)
end

---返回请求打开随机宝箱
function KnapsackSubsystem:RecvMsg_OpenRandomBox(data)
    ---@type SC_OpenRandBox
    local msg = assert(Dll_PB.decode("OpenOptionalBox", data))
    print(ProtoMsgHelp.block(msg))

    CommonHelper:UserGetReward(msg)
    UINotify:Get():SendNotification(UINotifyEvent.BagViewRefresh,false)
end
---请求道具出售
function KnapsackSubsystem:SendMsg_SellGoods(boxId,num)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),boxId,num})
    NetManager:Get():Send(MsgID.SELL_GOODS_C2S_REQ, reqBytes)
end

---返回请求道具出售
function KnapsackSubsystem:RecvMsg_SellGoods(data)
    ---@type SC_sellGoods
    local msg = assert(Dll_PB.decode("sellGoods", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsume(msg.pay)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downsome)
    UINotify:Get():SendNotification(UINotifyEvent.BagViewRefresh,false)
end


local __subsystem = KnapsackSubsystem()
function KnapsackSubsystem:Get()
    return __subsystem
end
return __subsystem