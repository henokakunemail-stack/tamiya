---@class NetEaseDetect
NetEaseDetect = class("NetEaseDetect")

function NetEaseDetect:Get()
    if self._instance == nil then
        self._instance = NetEaseDetect()
    end
    return self._instance
end




-- <summary>
-- 补丁下载失败
-- </summary>
-- <param name="patch_url">下载地址</param>
-- <param name="download_id">下载任务编号。下载任务编号。目标是用于分析下载过程中,用户杀死游戏取消下载。如需收集补丁下载过程中取消数据,请在补丁下载成功和补丁下载失败时,加上该次下载的download_id编号</param>
-- <param name="http_code">状态吗</param>
-- <param name="error_log">下载失败的异常信息</param>
-- <param name="file_num">已完成下载的文件数量</param>
-- <param name="patch_version">补丁的版本</param>
-- <param name="dl_speed">下载失败时平均下载速度,默认速度为KB/s</param>
-- <param name="file_size">从下载开始到下载失败时，已经完成的下载大小,方便定位异常问题，默认单位KB</param>
-- <param name="time_cost">从下载开始到下载失败的时间长度,方便定位异常时间点，默认单位为毫秒</param>
-- <param name="unzip">文件解压结果。false值为解压失败，true为解压成功</param>
-- <param name="file_md5">文件md5值</param>
-- <param name="file_md5_result">md5值校验结果，true或false，用于检验文件内容是否被劫持</param>
function NetEaseDetect:PatchLoadFail(patch_url, download_id, http_code,
                                     error_log, file_num, patch_version, dl_speed,
                                     file_size, time_cost, unzip, file_md5,
                                     file_md5_result)
    --monoNetEaseDetect:PatchLoadFail(patch_url, download_id, http_code,
    --        error_log, file_num, patch_version, dl_speed,
    --        file_size, time_cost, unzip, file_md5,
    --        file_md5_result)
end


-- <summary>
-- 补丁下载成功
-- </summary>
-- <param name="patch_url">下载地址</param>
-- <param name="download_id">下载任务编号。下载任务编号。目标是用于分析下载过程中,用户杀死游戏取消下载。如需收集补丁下载过程中取消数据,请在补丁下载成功和补丁下载失败时,加上该次下载的download_id编号</param>
-- <param name="http_code">状态吗</param>
-- <param name="error_log">下载失败的异常信息</param>
-- <param name="file_num">已完成下载的文件数量</param>
-- <param name="patch_version">补丁的版本</param>
-- <param name="dl_speed">下载失败时平均下载速度,默认速度为KB/s</param>
-- <param name="file_size">从下载开始到下载失败时，已经完成的下载大小,方便定位异常问题，默认单位KB</param>
-- <param name="time_cost">从下载开始到下载失败的时间长度,方便定位异常时间点，默认单位为毫秒</param>
-- <param name="unzip">文件解压结果。false值为解压失败，true为解压成功</param>
-- <param name="file_md5">文件md5值</param>
-- <param name="file_md5_result">md5值校验结果，true或false，用于检验文件内容是否被劫持</param>
function NetEaseDetect:PatchLoadSuccess(patch_url, download_id, http_code,
                                        error_log, file_num, patch_version, dl_speed,
                                        file_size, time_cost, unzip, file_md5,
                                        file_md5_result)

    --monoNetEaseDetect:PatchLoadSuccess(patch_url, download_id, http_code,
    --        error_log, file_num, patch_version, dl_speed,
    --        file_size, time_cost, unzip, file_md5,
    --        file_md5_result)
end


-- <summary>
-- 登陆成功
-- </summary>
-- <param name="group_id">设置游戏所属群组gid</param>
-- <param name="server_name"></param>
-- <param name="server_ip">产品联接的服务器主机ip或则域名</param>
-- <param name="server_port">产品联接的服务器端口</param>
-- <param name="error_log">为游戏登录失败的异常信息 </param>
-- <param name="user_name">设置用户账号信息</param>
-- <param name="user_id">设置用户ID信息，获取不到情况下，不用上传</param>
-- <param name="account">用户登陆账号，是手机号或则是登陆邮箱账号</param>
function NetEaseDetect:LoginFail(group_id, server_name, server_ip, server_port, error_log,
                                 user_name, user_id)
    --monoNetEaseDetect:LoginFail(tostring(group_id), tostring(server_name), tostring(server_ip), tonumber(server_port), tostring(error_log),
    --        tostring(user_name), tostring(user_id))

end


-- <summary>
-- 登录成功，
-- </summary>
-- <param name="group_id">设置游戏所属群组gid</param>
-- <param name="server_name"></param>
-- <param name="server_ip">产品联接的服务器主机ip或则域名</param>
-- <param name="server_port">产品联接的服务器端口</param>
-- <param name="time_cost">登录耗时，毫秒 </param>
-- <param name="user_name">设置用户账号信息</param>
-- <param name="user_id">设置用户ID信息，获取不到情况下，不用上传</param>
-- <param name="account">用户登陆账号，是手机号或则是登陆邮箱账号</param>
function NetEaseDetect:LoginSuccess(group_id, server_name, server_ip, server_port,
                                    time_cost, user_name, user_id)
    --monoNetEaseDetect:LoginSuccess(group_id, server_name, server_ip, server_port,
    --        time_cost, user_name, user_id)

end


-- <summary>
-- 定时诊断时间间隔建议
--建议定时网络诊断时间间隔为半个小时 定时收集的开始时间请设置为进入游戏半个小时内的随机触发，这样可分散压力。
--千万不要设置为刚进入游戏的时间点，否则维服后，涌入游戏的用户太多，导致定时收集的用户太过于集中，对系统造成的压力过大，请程序务必知晓
-- </summary>
-- <param name="group_id"></param>
-- <param name="server_name"></param>
-- <param name="server_ip"></param>
-- <param name="server_port"></param>
-- <param name="user_name"></param>
-- <param name="user_id"></param>
-- <param name="account"></param>
function NetEaseDetect:LostData(group_id, server_name, server_ip,
                                server_port, user_name, user_id)
    --monoNetEaseDetect:LostData(group_id, server_name, server_ip,
    --        server_port, user_name, user_id)
end

function NetEaseDetect:LostDataAd()

    print("--------开始抓包------------>")
    local serverInfo = ClientDataManager:Get():GetServerInfoByServerId(PlayerDataManager:Get():GetPlayerServerID())
    self:LostData(
            serverInfo ~= -1 and tostring(serverInfo:GetGroupId()) or "0",
            serverInfo ~= -1 and tostring(serverInfo:GetName()) or "",
            serverInfo ~= -1 and tostring(serverInfo:GetIp()) or "",
            serverInfo ~= -1 and tonumber(serverInfo:GetPort()) or -1,
            PlayerDataManager:Get():GetPlayerName(),
            tostring(PlayerDataManager:Get():GetPlayerUID())
    )
end

function NetEaseDetect:StartLostData()

    local second = 1

    print("-----登录成功之后开始抓包的时间-------->", second)

    --NetEaseDataManager:Get():SetDetectRandomTime(second)

    --NetEaseDataManager:Get():SetDetectLoginSuccessTime(CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + second)

    --if NetEaseDataManager:Get():GetDetectCountDownId() ~= -1 then
    --    TimerManager:Get():StopTimer(NetEaseDataManager:Get():GetDetectCountDownId())
    --end

    --local countDownId = TimerManager:Get():CreateTimerLoop(1, function(class)
    --
    --    -- print("-----当前时间----->", CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()), "----结束时间------->", NetEaseDataManager:Get():GetDetectLoginSuccessTime())
    --
    --    if CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) > NetEaseDataManager:Get():GetDetectLoginSuccessTime() then
    --
    --        if NetEaseDataManager:Get():GetDetectTimeId() ~= -1 then
    --            TimerManager:Get():StopTimer(NetEaseDataManager:Get():GetDetectTimeId())
    --        end
    --
    --        self:LostDataAd()
    --        local timeId = TimerManager:Get():CreateTimerLoop(NetEaseDataManager:Get():GetDetectTimerInterval(), function(class)
    --            self:LostDataAd()
    --        end)
    --        NetEaseDataManager:Get():SetDetectTimeId(timeId)
    --
    --        TimerManager:Get():StopTimer(NetEaseDataManager:Get():GetDetectCountDownId())
    --    end
    --end)
    --
    --NetEaseDataManager:Get():SetDetectCountDownId(countDownId)
end






