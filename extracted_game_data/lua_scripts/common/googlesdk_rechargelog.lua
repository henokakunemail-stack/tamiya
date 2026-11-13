---@class GoogleSDKRechargeLog
GoogleSDKRechargeLog = class("GoogleSDKRechargeLog")

function GoogleSDKRechargeLog:Get()
    if self._instance == nil then
        self._instance = GoogleSDKRechargeLog()
    end
    return self._instance
end

--- 是否为补单数据
--local isMakeUpTheOrder = false;

--- 每一步充值都调用
function GoogleSDKRechargeLog:AddLog(type, logInfo)
    if logInfo ~= nil then
        PlayerPrefsHelper:AddValue_GoogleChargeLog(type, logInfo)
    end
    --if reOrder ~= nil then
    --    isMakeUpTheOrder = reOrder
    --end
end

--- 登录和充值成功时候调用
function GoogleSDKRechargeLog:SendLog()
    local _logInfo = PlayerPrefsHelper:GetValue_GoogleChargeLog()
    if _logInfo ~= "" then
        -- 有数据就发送充值log
        local data = QuickTaData:GetGoogleConsumeRechargeLog(
                PlayerDataManager:Get():GetPlayerRID(),
                _logInfo
        )    --发送充值log
        QuickTa:Get():TrackEvent(TrackEventNames.GoogleRechargeLog, data)
    end
    -- 有没有数据都要清理数据
    PlayerPrefsHelper:ResetValue_GoogleChargeLog()
end

--- 发货成功时候调用  直接删除不上传日志
function GoogleSDKRechargeLog:ResetLog()
    --if isMakeUpTheOrder then
    --    isMakeUpTheOrder = false
    --    SendLog()
    --    return
    --end
    PlayerPrefsHelper:ResetValue_GoogleChargeLog()
end