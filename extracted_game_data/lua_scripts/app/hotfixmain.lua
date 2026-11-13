

require ("hotfix_require")
function HotFixStart(hotfixend)
    if CS.GameProperties:Get().AssetBundleMode and CS.GameProperties:Get().HotfixEnable and (not hotfixend) then
    local hotFixFun=function()
    AssetFlagManager:Get():Read()
    VersionManager:Get():OnInit(true)
    HotfixHelper:TrackAppStart("App_Init",nil,nil,true,AnalysisType.App_Init)
    --HotfixHelper:SetToken(AnalysisType.checkweb)
    end
    if CS.GameProperties:Get().IsAAB and CS.UnifySDK.EnvironmentVariableSettings.Instance.IsNewPAD then
    GooglePlayAssetDelivery(hotFixFun)
    else
    hotFixFun()
    end
    else
    VersionManager:Get():OnlyReadPkgVersion()
    HotFixEnd(false)
    end
    end

    function GooglePlayAssetDelivery(hotFixFun)
    GooglePADManager:Get():OnInit(hotFixFun)
    end

    ----热更结束，正常开始游戏
    function HotFixEnd(isHotfix)

if not CS.GameProperties:Get().IsFE then
    print("HotFixEnd", CS.UnityEngine.Time.realtimeSinceStartup, isHotfix)
end
    try( function()
    VersionManager:Get():SetHotFixDone(not isHotfix)
    if isHotfix then
    HotFixLuaEvent:Get():Clear()
    CS.MonoHelper.ReleaseAllAssets()
    HotfixHelper:TrackAppStart("App_Hotfix_End_Init",nil,nil,false,AnalysisType.App_Hotfix_End_Init)
    else
    require("main")
    MainStart()
    HotfixHelper:TrackAppStart("App_NoHotFix_Init",nil,nil,false,AnalysisType.App_NoHotFix_Init)
    end
    end).catch(function(error)
    HotfixHelper:TrackAppStart("App_NoHotFix_Exception"..error,nil,nil,false,AnalysisType.App_NoHotFix_Exception)
    require("main")
    MainStart()
    end)

    end
