---@class NetEasePoneFunc
NetEasePoneFunc = class("NetEasePoneFunc")

function NetEasePoneFunc:Get()
    if self._instance == nil then
        self._instance = NetEasePoneFunc()
    end
    return self._instance
end

function NetEasePoneFunc:CreateRoleLog()
    if SDKHelper:Get():ChickNetEaseSdk() then
        --local serverID = tonumber(PlayerDataManager:Get():GetPlayerServerID())
        --local role_id = PlayerDataManager:Get():GetPlayerUID()
        --local role_name = PlayerDataManager:Get():GetPlayerName()
        --monoNetEasePOneFunc:CreateRoleLog(serverID, role_id, role_name)
    end
end

function NetEasePoneFunc:LoadLog(load_time_long)
    if SDKHelper:Get():ChickNetEaseSdk() then
        --monoNetEasePOneFunc:LoadLog(load_time_long)

    end
end


-- <summary>
-- 新手引导日志---日志说明：在有新手引导时记录log；当开始新手指引时记录一条日志（该日志结束时间、引导耗时、角色结束等级都留空），当结束新手时，记录一条结束log，各字段信息完整。
-- </summary>
-- <param name="serverID"></param>
-- <param name="role_id">角色唯一标识，在所有服唯一。</param>
-- <param name="role_name">游戏角色名称，多服可重复，单服唯一</param>
-- <param name="tutorial_id"> 例：“001-1022”。</param>
-- <param name="tutorial_name">例：“第一次主城升级”</param>
-- <param name="begin_time"> 开始新手引导的时间</param>
-- <param name="begin_role_level">开始教程时玩家角色等级</param>
-- <param name="end_role_level">结束教程时玩家角色等级</param>
-- <param name="details">该玩法其他信息。例：该引导总点击次数，玩家实际点击次数 “{total_screens:5, finish_screens:3}”</param>
-- <param name="use_time">使用耗时，秒”</param>
-- <param name="step_type">引导情况（未完成：-1，完成：1，开始 ：0）”</param>
function NetEasePoneFunc:TutorialLog(serverID, role_id, role_name, tutorial_id, tutorial_name,
                                     begin_time, begin_role_level, end_role_level, clickCount, use_time, step_type)
    if SDKHelper:Get():ChickNetEaseSdk() then
        --monoNetEasePOneFunc:TutorialLog(serverID, role_id, role_name, tutorial_id, tutorial_name,
        --        begin_time, begin_role_level, end_role_level, clickCount, use_time, step_type)
    end

    print("-------新手引导日志--------->>>>>", serverID, role_id, role_name, tutorial_id, tutorial_name,
            begin_time, begin_role_level, end_role_level, clickCount, use_time, step_type)
end

function NetEasePoneFunc:AntiAddictionKickOffLog()
    if SDKHelper:Get():ChickNetEaseSdk() then
        --local serverID = tonumber(PlayerDataManager:Get():GetPlayerServerID())
        --local role_id = tostring(PlayerDataManager:Get():GetPlayerUID())
        --local role_name = PlayerDataManager:Get():GetPlayerName()
        --local role_level = PlayerDataManager:Get():GetPlayerLV()
        --
        --monoNetEasePOneFunc:AntiAddictionKickOffLog(serverID, role_id, role_name, role_level)
    end
end

function NetEasePoneFunc:StartFPSPingLog()
    if SDKHelper:Get():ChickNetEaseSdk() then
        --if NetEaseDataManager:Get():GetFpsTimerId() ~= -1 then
        --    TimerManager:Get():StopTimer(NetEaseDataManager:Get():GetFpsTimerId())
        --end
        --local timerId = TimerManager:Get():CreateTimerLoop(NetEaseDataManager:Get():GetFpsTimerInterval(), function(class)
        --    local count = NetEaseDataManager:Get():GetFpsTimerCount()
        --    class:StartPing()
        --    NetEaseDataManager:Get():SetFpsTimerCount(count + 1)
        --    if count % 5 == 0 then
        --        self:FPSLog()
        --    end
        --end, self)
        --NetEaseDataManager:Get():SetFpsTimerId(timerId)
    end
end

function NetEasePoneFunc:StartPing()
    --monoNetEasePOneFunc:StartPing()
end

function NetEasePoneFunc:FPSLog()

end

function NetEasePoneFunc:UserCertificationLog()

end

function NetEasePoneFunc:LoginRoleLog()

end

function NetEasePoneFunc:RoleEnterFailLog()

end

--发言对象的account_id，和玩家私聊时记录；如在公共频道发言，不用记录或者记录空字符串
function NetEasePoneFunc:ChatLog(content, channel, scene, axis, chat_time, y_account_id, y_obj, y_level, y_name)

end



-- <summary>
-- 客户端下载日志,------触发日志场景：设备下载patch过程中，建议patch小于100M时，每下载10M记录一条日志；patch大于100M时，每下载patch总大小的10%时记录一次
-- </summary>
-- <param name="patch_ver">当前要下载的patch的版本号 </param>
-- <param name="download_url">下载资源的url </param>
-- <param name="error_code">更新失败时记录的异常码，用于区分具体的错误类型，具体值由项目自己决定</param>
-- <param name="downloaded_size">	已经下载好的patch文件大小，例如断点续传时可以记录，MB为单位，仅当下载patch时需记录此字段 </param>
-- <param name="file_size">需下载的所有patch文件的总大小，MB为单位，仅当下载patch时需记录此字段 </param>
-- <param name="file_num">需下载的所有patch文件的总数，仅当下载patch时需记录此字段 </param>
function NetEasePoneFunc:DownloadLog(patch_ver, download_url, error_code,
                                     downloaded_size, file_size, file_num)
    --monoNetEasePOneFunc:DownloadLog(patch_ver, download_url, error_code,
    --        downloaded_size, file_size, file_num)
end

-- <summary>
-- 客户端更新日志,------触发日志场景：设备开始更新、更新完成、更新失败时
-- </summary>
-- <param name="update_status">0表示更新开始，1表示更新成功，-1表示更新失败</param>
-- <param name="use_time">单位秒；如果update_status=0，这里记录为0；如果update_status=1，记录更新成功时间-更新开始时间；如果update_status=-1记录更新失败时间-更新开始时间</param>
-- <param name="update_target">当前的更新目标，可填”patchlist”、”patch” </param>
-- <param name="patch_ver">当前要下载的patch的版本号 </param>
-- <param name="download_url">下载资源的url </param>
-- <param name="error_code">更新失败时记录的异常码，用于区分具体的错误类型，具体值由项目自己决定</param>
-- <param name="downloaded_size">	已经下载好的patch文件大小，例如断点续传时可以记录，MB为单位，仅当下载patch时需记录此字段 </param>
-- <param name="file_size">需下载的所有patch文件的总大小，MB为单位，仅当下载patch时需记录此字段 </param>
-- <param name="file_num">需下载的所有patch文件的总数，仅当下载patch时需记录此字段 </param>
function NetEasePoneFunc:UpdateLog(update_status, update_target, patch_ver, download_url,
                                   error_code, downloaded_size, file_size, file_num)

    --monoNetEasePOneFunc:UpdateLog(update_status, update_target, patch_ver, download_url,
    --        error_code, downloaded_size, file_size, file_num)
end

