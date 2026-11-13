---@class QuickTa
QuickTa = class("QuickTa")

function QuickTa:Get()
    if self._instance == nil then
        self._instance = QuickTa()
    end
    return self._instance
end

local isFirstTtackEvent = false
function QuickTa:TrackPlatformSetForAdjustToken()
    if  isFirstTtackEvent == false then
        isFirstTtackEvent = true
    end
end
---打点事件通用接口
---@param   eventName         TrackEventNames    事件名
---@param   tableTrackData    table              事件数据   可空   该table及子table需要以key(必须是string)、value(数值、string、bool、DateTime、table)形式存储数据
---@param   type              TrackEventType     事件类型   可空   TrackEventType.Default
---@param   token             string             string   可空    用于adjust
function QuickTa:TrackEvent(eventName, tableTrackData, type, token)
    if HotfixHelper:IsAndroidPlatform() then
        token=nil
    end
    self:TrackPlatformSetForAdjustToken()
    if type == nil then
        type = TrackEventType.Default
    end
    QuickTaHelper:Get():ShuShuTrackEvent(eventName, tableTrackData, type)
    if type == TrackEventType.First then
        if tableTrackData == nil then
            tableTrackData = {}
        end
        tableTrackData.First = "First"
    end
    local flag =true
    for k, v in pairs(NotTrackEventNames) do
        if eventName==v then
            flag=false
        end
    end
    print("TTETTTTTT",flag)
    if flag then
        QuickTaHelper:Get():ChuJianSendLogServer(eventName, tableTrackData)
    end
    if flag then
        if token ~= nil and token ~= "" then
            local data = CustomEventData()
            data.eventName = token      --  这块传 adjustToken
            --UnifySDKManager:Get():IAnalysis():SetCustomEvent(data)
            data.customParam = eventName
            --data.eventCode =
            UnifySDKEventSystem:Publish(data);
        end
    end
end

function QuickTa:SetAppId(appId, url)
    --monoQuickTa:SetAppId(appId, url)
end

---打点属性通用接口
---@param tablePropertyData  table              属性数据  不能为空,该table及子table需要以key(必须是string)、value(数值、string、bool、DateTime、table)形式存储数据
---@param type               TrackPropertyType  属性行为
---@param appid              number             项目 ID(可选)
function QuickTa:TrackProperty(tablePropertyData, type, appid)
    QuickTaHelper:TrackProperty(tablePropertyData, type, appid);
end

---初始化
function QuickTa:OnInit()

    QuickTaHelper:Get():SetLog(false)
    log("  ChuJianSDKDataHelper:OnInit   ")
    local platform = CS.UnityEngine.Application.platform
    if platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseQuickSDK) then
        QuickTaHelper:Get():SetDefaultDataChannelId(1002)
        QuickTaHelper:Get():SetDefaultDataChannelName("安卓包")
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseQuickSDKSEA) then
        QuickTaHelper:Get():SetDefaultDataChannelId(1007)
        QuickTaHelper:Get():SetDefaultDataChannelName("东南亚quick安卓包")
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseHuaWeiSDK) then
        QuickTaHelper:Get():SetDefaultDataChannelId(1003)
        QuickTaHelper:Get():SetDefaultDataChannelName("华为安卓包")
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseHuaWeiSDKSelf) then
        QuickTaHelper:Get():SetDefaultDataChannelId(1004)
        QuickTaHelper:Get():SetDefaultDataChannelName("华为安卓包")
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK) then
        --QuickTaHelper:Get():SetDefaultDataChannelId("1001" .. AdjustSdk:Get():getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelId("1001" .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName("1001")
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK2) then
        --QuickTaHelper:Get():SetDefaultDataChannelId("1002" .. AdjustSdk:Get():getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelId("1002" .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName("1002")
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK3) then
        --QuickTaHelper:Get():SetDefaultDataChannelId("1003" .. AdjustSdk:Get():getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelId("1003" .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName("1003")
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK4) then
        --QuickTaHelper:Get():SetDefaultDataChannelId("1004" .. AdjustSdk:Get():getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelId("1004" .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName("1004")
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk2) then
        -- 安卓平台（东南亚新包用）
        QuickTaHelper:Get():SetDefaultDataChannelId("2001" .. UnifySDKManager:Get():ISDK():GetChannelID() .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName(2001)
    elseif platform == CS.UnityEngine.RuntimePlatform.IPhonePlayer and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk2) then
        -- 苹果平台（东南亚新包用）
        QuickTaHelper:Get():SetDefaultDataChannelId("1007" .. UnifySDKManager:Get():ISDK():GetChannelID() .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName(1007)
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk3) then
        -- 安卓平台（韩国包用）
        QuickTaHelper:Get():SetDefaultDataChannelId("3001" .. UnifySDKManager:Get():ISDK():GetChannelID() .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName(3001)
    elseif platform == CS.UnityEngine.RuntimePlatform.IPhonePlayer and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk3) then
        -- 苹果平台（韩国包用）
        QuickTaHelper:Get():SetDefaultDataChannelId("3002" .. UnifySDKManager:Get():ISDK():GetChannelID() .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName(3002)
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk4) then
        -- 安卓平台（韩国包用）
        QuickTaHelper:Get():SetDefaultDataChannelId("3003" .. UnifySDKManager:Get():ISDK():GetChannelID() .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName(3003)
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk5) then
        -- 安卓平台（韩国包用）
        QuickTaHelper:Get():SetDefaultDataChannelId("3004" .. UnifySDKManager:Get():ISDK():GetChannelID() .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName(3004)
    elseif platform == CS.UnityEngine.RuntimePlatform.IPhonePlayer and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk5) then
        -- 安卓平台（韩国包用）
        QuickTaHelper:Get():SetDefaultDataChannelId("3005" .. UnifySDKManager:Get():ISDK():GetChannelID() .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName(3005)
    elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk) then
        -- 旧的东南亚（IOS包）
        QuickTaHelper:Get():SetDefaultDataChannelId("1007" .. UnifySDKManager:Get():ISDK():GetChannelID() .. UnifySDKHelper:getAttribution())
        QuickTaHelper:Get():SetDefaultDataChannelName(1007)
    elseif platform == CS.UnityEngine.RuntimePlatform.Android and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseQuickSDKChina) then
        print("CPSChannelID:" .. UnifySDKManager:Get():IAccount():GetCPSChannelID())
        local CPSChannelID = UnifySDKManager:Get():IAccount():GetCPSChannelID()
        local ChannelID = UnifySDKManager:Get():ISDK():GetChannelID()
        local markCode = "1010"
        if ChannelID == "134" then
            if CPSChannelID == "toutiao" or CPSChannelID == "tap" or CPSChannelID == "hykb" then
                markCode = "1008"
            else
                markCode = "1010"
            end
        end
        if ChannelID == "27512" then
            --quickgame-tap
            markCode = "1012"
        end
        if ChannelID == "27518" then
            --quickgame-haoyoukuaibao
            markCode = "1013"
        end
        print("markCode:" .. markCode)
        QuickTaHelper:Get():SetDefaultDataChannelId(markCode .. UnifySDKManager:Get():ISDK():GetChannelID() .. CPSChannelID)
        QuickTaHelper:Get():SetDefaultDataChannelName(markCode)
    elseif platform == CS.UnityEngine.RuntimePlatform.IPhonePlayer and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseQuickSDKChina) then

        --local Config = UnifySDKManager:Get():ISDK():GetConfig().ChannelId
        --print("QuickTAConfig:" .. Config)
        --if Config =="self"  then
        QuickTaHelper:Get():SetDefaultDataChannelId(1011)
        QuickTaHelper:Get():SetDefaultDataChannelName(1011)
        --else
        --    QuickTaHelper:Get():SetDefaultDataChannelId(1009)
        --    QuickTaHelper:Get():SetDefaultDataChannelName(1009)
        --end
    elseif platform == CS.UnityEngine.RuntimePlatform.IPhonePlayer and SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK) then
        QuickTaHelper:Get():SetDefaultDataChannelId(1006)
        QuickTaHelper:Get():SetDefaultDataChannelName("东南亚谷歌IOS包")
    elseif platform == CS.UnityEngine.RuntimePlatform.IPhonePlayer then
        QuickTaHelper:Get():SetDefaultDataChannelId(1001)
        QuickTaHelper:Get():SetDefaultDataChannelName("IOS包")
    elseif platform == CS.UnityEngine.RuntimePlatform.WindowsEditor then
        QuickTaHelper:Get():SetDefaultDataChannelId(2)
        QuickTaHelper:Get():SetDefaultDataChannelName("WindowsEditor")
    elseif platform == CS.UnityEngine.RuntimePlatform.OSXEditor then
        QuickTaHelper:Get():SetDefaultDataChannelId(1)
        QuickTaHelper:Get():SetDefaultDataChannelName("OSXEditor")
    elseif platform == CS.UnityEngine.RuntimePlatform.WindowsPlayer then
        QuickTaHelper:Get():SetDefaultDataChannelId(102)
        QuickTaHelper:Get():SetDefaultDataChannelName("WindowsPlayer")
    elseif platform == CS.UnityEngine.RuntimePlatform.OSXPlayer then
        QuickTaHelper:Get():SetDefaultDataChannelId(101)
        QuickTaHelper:Get():SetDefaultDataChannelName("OSXPlayer")
    else
        QuickTaHelper:Get():SetDefaultDataChannelId(0)
        QuickTaHelper:Get():SetDefaultDataChannelName("Other")
    end
    --QuickTaHelper:Get():SetDefaultDataUmid(CS.QuickTA:Get():GetDeviceId())
    if self.isInit == nil then
        QuickTa:Get():TrackEvent(TrackEventNames.Activate)
    end
    self.isInit = true
end

function QuickTa:GetPresetProperties()
    return nil
    --return monoQuickTa:GetPresetProperties()
end

---↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--old--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓---
---@class QuickTaKay
QuickTaKay = {
    IsFirstLogin = "IsFirstLogin",

}

function QuickTa:SetKey(key, value)
    value = value or 1
    PlayerPrefs.SetInt(key, value)
    PlayerPrefs.Save()
end

function QuickTa:IsHaveKey(key)
    return PlayerPrefs.GetInt(key, 0) == 1
end

function QuickTa:GetDeviceId()
    return monoQuickTa:GetDeviceId()
end


--string roleName, string role_id, string serverName
function QuickTa:Track_Register(roleName, role_id, serverName)
    monoQuickTa:Track_Register(roleName, role_id, serverName)
end

function QuickTa:Track_Login(login_days, first_login, clearance_times, level, roleId)
    if self:IsHaveKey(QuickTaKay.IsFirstLogin) then
        monoQuickTa:Track_Login(login_days, false, clearance_times, level, roleId)
    else
        monoQuickTa:Track_Login(login_days, true, clearance_times, level, roleId)
        self:SetKey(QuickTaKay.IsFirstLogin)
    end
end

function QuickTa:Track_Logout(clearance_times, diamond_sum, strength_consume, strength_surplus,
                              activity, level, gold_sum, payment_total, draw_total, online_time, parking_lot1,
                              parking_lot2, parking_lot3, parking_lot4, parking_lot5, parking_lot_sum,
                              qualifying_rank, match_rank, daw_total_1, daw_total_10)
    monoQuickTa:Track_Logout(clearance_times, diamond_sum, strength_consume, strength_surplus,
            activity, level, gold_sum, payment_total, draw_total, online_time, parking_lot1,
            parking_lot2, parking_lot3, parking_lot4, parking_lot5, parking_lot_sum,
            qualifying_rank, match_rank, daw_total_1, daw_total_10)
end

function QuickTa:Track_LvUp(clearance_times, diamond_sum, strength_consume, strength_surplus,
                            activity, level, gold_sum, payment_total, draw_total, parking_lot_sum,
                            qualifying_rank, match_rank, daw_total_1, daw_total_10)
    monoQuickTa:Track_LvUp(clearance_times, diamond_sum, strength_consume, strength_surplus,
            activity, level, gold_sum, payment_total, draw_total, parking_lot_sum,
            qualifying_rank, match_rank, daw_total_1, daw_total_10)
end



--任务开始		任务接取后上报（没有放弃或失败结果记录需求的任务可以选择不上报任务开始）
--         task_id	任务ID	文本	活动参与类数据也可以上报至任务表
--			task_type	任务类型	文本
--			task_subtype	二级类型	文本
--			level	角色等级	数值
--			strength_consume	本日当前消耗体力数量	数值
--			strength_surplus	本日当前剩余体力数量	数值
function QuickTa:Track_TaskStart(point_sort, point_id, point_name, point_describe, level)
    monoQuickTa:Track_TaskStart(point_sort, point_id, point_name, point_describe, level)
end

--完成任务		完成任务时上报
--task_id	任务ID	文本
--task_type	任务类型	文本
--task_subtype	二级类型	文本
--level	角色等级	数值  目前没记录
--strength_consume	本日当前消耗体力数量	数值
--strength_surplus	本日当前剩余体力数量	数值
function QuickTa:Track_TaskComplete(task_id, task_type, task_subtype, strength_surplus, strength_consume)
    monoQuickTa:Track_TaskComplete(task_id, task_type, task_subtype, strength_surplus, strength_consume)
end

--research_type	科技类型	文本	1、合成，2、分解，3、升级
--research_objectives	科技目标物品	对象组/列表
--research_objectives_rank	科技目标物品品质	文本
--material_science	科技材料	对象组/列表
--success_rate	成功率	数值
--scheduled_time	预定耗时	数值	单位秒
function QuickTa:Track_ResearchStart(research_type, research_objectives, research_objectives_rank, material_science, success_rate, scheduled_time)
    monoQuickTa:Track_ResearchStart(research_type, research_objectives, research_objectives_rank, material_science, success_rate, scheduled_time)
end

--string research_type, int reformer_level, int get_exp, string research_objectives,
--string research_objectives_rank, string material_science, int success_rate, int scheduled_time,
--int time_consuming, string accelerate
function QuickTa:Track_ResearchEnd(research_type, reformer_level, get_exp, research_objectives, research_objectives_rank, material_science, success_rate, scheduled_time, time_consuming, accelerate)
    monoQuickTa:Track_ResearchEnd(research_type, reformer_level, get_exp, research_objectives, research_objectives_rank, material_science, success_rate, scheduled_time, time_consuming, accelerate)
end
--string is_first, string array, string pve_type, string match_id, string pve_id
function QuickTa:Track_PveStart(is_first, array, pve_type, match_id, pve_id)
    monoQuickTa:Track_PveStart(is_first, array, pve_type, match_id, pve_id)
end

--比赛结束后上报
--is_first	是否首次成功本类型比赛	文本 1表示首次 2表示非首次
--starting_efficiency	起步效率	文本
--array	玩家阵容	对象组
--pve_type	比赛类型	文本
--match_id	比赛唯一id	文本	多人比赛才需要
--pic_duration	本次比赛耗时	数值	秒单位
--Result	比赛结果	文本	1正常战败，2胜利，3、翻车，4、故障
--score_list	多人比赛成绩榜	对象组
--pve_id	关卡id/赛道id	文本
function QuickTa:Track_PveEnd(is_first, starting_efficiency, array, match_id, pic_duration, Result, score_list, pve_type)
    monoQuickTa:Track_PveEnd(is_first, starting_efficiency, array, match_id, pic_duration, Result, score_list, pve_type)
end

--friend_type	好友行为类型	文本	1、加好友，2、删除好友，3、拉黑名单，4、解除黑名单，5、聊天
--friend_target	好友行为目标	文本	用户id
--friend_number	当前好友人数	数值
--friend_number_online	当前好友在线人数	数值
function QuickTa:Track_FiendSystem(friend_type, friend_target, friend_number, friend_number_online)
    monoQuickTa:Track_FiendSystem(friend_type, friend_target, friend_number, friend_number_online)
end

--union_type	工会行为类型	文本	1、创建，2、加入，3、退出
--union_id	当前工会id	文本
--union_name	当前工会名称	文本
--union_number	当前工会人数	数值
function QuickTa:Track_Union(union_type, union_id, union_name, union_number)
    monoQuickTa:Track_Union(union_type, union_id, union_name, union_number)
end

--string mail_id, string mail_type, string wallpapper_message
function QuickTa:Track_Mail(mail_id, mail_type, wallpapper_message)
    monoQuickTa:Track_Mail(mail_id, mail_type, wallpapper_message)
end

--string dev_type, string dev_level, string item_id, string supporter_id,
--string site_id, string rarity
function QuickTa:Track_Devprogressstatus(dev_type, dev_level, item_id, supporter_id, site_id, rarity)
    monoQuickTa:Track_Devprogressstatus(dev_type, dev_level, item_id, supporter_id, site_id, rarity)
end

--string shop_type, string type_name, string currency, string item_id, string item_name,
--int number, int balance, int itemcount, string discount, string discount_name, int remain
function QuickTa:Track_ShopTrade(shop_type, type_name, currency, item_id, item_name, number, balance, itemcount, discount, discount_name, remain)
    monoQuickTa:Track_ShopTrade(shop_type, type_name, currency, item_id, item_name, number, balance, itemcount, discount, discount_name, remain)
end

--currency_type	币种（字符）	文本
--diamond_amount	钻石获取量	数值	上报实际获取量，包括优惠折扣的增加量
--is_first_pay	是否首次付费	数值	1为首次付费，2为非首次付费
--pay_amount	付费金额	数值
--pay_id	购买商品id	文本
--pay_type	兑换方式	文本	0表示纯领卡，1表示月卡
--game_order	游戏生成的订单号	文本
--sn	订单号	文本
--plat_order	渠道支付订单号	文本
--orderamount	SDK返回的平台统一币种对应金额	数值
--payprice	商品定价	数值	为商品初始定价，不计算优惠折扣等因素
--reattackd_info	礼包内容	文本

function QuickTa:Track_OrderInit(order_init, currency_type, diamond_amount, is_first_pay,
                                 pay_amount, pay_id, pay_type, game_order, sn, plat_order, orderamount,
                                 payprice, reattackd_info)
    monoQuickTa:Track_OrderInit(order_init, currency_type, diamond_amount, tonumber(is_first_pay),
            pay_amount, pay_id, pay_type, game_order, sn, plat_order, orderamount,
            tonumber(payprice), reattackd_info)
end


























