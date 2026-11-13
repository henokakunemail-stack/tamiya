------@class App
App = class("App")

function App:Instance(...)
    -- body
    if self.instance == nil then
        self.instance = App()
    end

    return self.instance
end

function App:OnInit(...)
    -- body

end
---@param focusTime number
function App.OnApplicationPause(focusTime)

    if HotfixHelper then
        if HotfixManager  then
            if HotfixManager:Get():IsDownloadFinish()==false then
                print("后台打印")
                local count=HotfixManager:Get():SaveDownloadProcess()
                AssetFlagManager:Get():Save()
                HotfixHelper:TrackAppStart("App_HotFix_Pause",nil,count,false,AnalysisType.App_HotFix_Pause)
            else
                HotfixHelper:TrackAppStart("App_Normal_Pause",nil,nil,false,AnalysisType.App_Normal_Pause)
            end
        else
            HotfixHelper:TrackAppStart("App_Normal_Pause",nil,nil,false,AnalysisType.App_Normal_Pause)
        end
    end
end
function App.OnApplicationFocus(flag, focusTime)

    if HotfixHelper then
        if HotfixManager  then
            if HotfixManager:Get():IsDownloadFinish()==false  then
                print("后台打印------》》")
                local count=HotfixManager:Get():SaveDownloadProcess()
                AssetFlagManager:Get():Save()
                HotfixHelper:TrackAppStart("App_HotFix_Pause",nil,count,false,AnalysisType.App_HotFix_Pause)
            else
                HotfixHelper:TrackAppStart("App_Normal_Pause",nil,nil,false,AnalysisType.App_Normal_Pause)
            end
        else
            HotfixHelper:TrackAppStart("App_Normal_Pause",nil,nil,false,AnalysisType.App_Normal_Pause)
        end
    end


    if CommonSubsystem and flag then
      --  CommonSubsystem:Get():SendMsg_CheckServerTime()
    end
    if flag and LoginFuncHelper then
        LoginFuncHelper:CheckLoginedClientNetState()
    end

    if flag then
        HotfixManager:Get():CheckContinueHotfix()
    end
end
function App:OnApplicationQuit()

    if HotfixHelper then
        if HotfixManager then

            if HotfixManager:Get():IsDownloadFinish()==false then
                print("退出打印------》》")
                local count=HotfixManager:Get():SaveDownloadProcess()
                AssetFlagManager:Get():Save()
                HotfixHelper:TrackAppStart("App_HotFix_Quit",nil,count,false,AnalysisType.App_HotFix_Quit)
            else
                HotfixHelper:TrackAppStart("App_Normal_Quit",nil,nil,false,AnalysisType.App_Normal_Quit)
            end
        else
            HotfixHelper:TrackAppStart("App_Normal_Quit",nil,nil,false,AnalysisType.App_Normal_Quit)
        end
    end


    if PlayerPrefsHelper then
        PlayerPrefsHelper:Key_LastLoginPlayerId()
    end
    --if GuideManager and GuideManager:Get().PlayerHasGuide then
    --    local beginTime, beginLv = NetEaseDataManager:Get():GetPoneTutorialParam()
    --    NetEasePoneFunc:Get():TutorialLog(PlayerDataManager:Get():GetPlayerServerID(), tostring(PlayerDataManager:Get():GetPlayerUID()), PlayerDataManager:Get():GetPlayerName()
    --    , tostring(GuideManager:Get().curGroupId), ClientDataManager:Get():GetTemplateString(GuideManager:Get().guideData[GuideManager:Get().curGroupId][1]:GetDesc()), tostring(CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())), beginLv, PlayerDataManager:Get():GetPlayerLV(), GuideManager:Get().ClickCount, CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) - beginTime, -1)
    --end
    if LoginSubSystem then
        LoginSubSystem:Get():SendMsg_ExitGame()
    end
    if MeshCacheMgr then
        MeshCacheMgr:Get():SavePartList()
    end

end
function App.OnApplicationErrorLog(log, logType)
    if DebugLogDataManager ~= nil then
        DebugLogDataManager:Get():InterLog(logType, log)
    end
end
function App.OnGameToolsViewShow()
    UIManager:Get():OpenPopup("DebugView", CanvasType.TopCanvas, "DebugView")
end
function App.OnGameReleaseAllRes()
    LoginFuncHelper:ReleaseAllAssets()
end

function App.LanguageGetTempstring(key)
    local result = "<color=#ff0000>error!</color>"
    if CommonHelper ~= nil then
        result = CommonHelper:GetTempStr_UIStatic(key)
    end
    return result
end

function App.GetUIFxSync(key, func)
    PrefabCacheMgr:Get():SwapPrefabAsync(key, nil,nil,function(param, obj)
        if func then func(obj) end
    end)
end
function App.OnGameToolsShow(flag)
    if UINotify then
        UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_OpenGameTools,flag)
    end
end

function App.RecycleUIFx(obj)
    PrefabCacheMgr:Get():RecyclePrefab(obj)
end