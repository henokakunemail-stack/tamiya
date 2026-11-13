

require ("common/baselua")

require ("require_list")
require ("require_list_2")
require ("hotfix/hotfixhelper")
require ("uitemplate/template_require_list")

function Start_BeforeLogin()

if not CS.GameProperties:Get().IsFE then
    print(".......启动lua模板")
end
    --mono.SqlInit()

    CS.GameProperties:Get().languageType = CS.Language_Type.ZH_CN
    CS.GameProperties:Get().Language = "zh_cn_lang"
    LanguageSwitchManager.Get():ChangeLanguage(CS.Language_Type.ZH_CN)
    ClientDataManager:Get():InitLoginConfig()
    ClientDataManager:Get():InitConfig()
    NetManager:Get():OnInit()
    PlotManager:Get():OnInit()
    ComicManager:Get():OnInit()
    CarAssembleRule:Get():Init()
    UIManager:Get():OpenView("TemplateMainView", CanvasType.MainCanvas, "TemplateMainView")

    local StartCanvas=HotfixHelper:GetRootObjectExactMath("StartCanvas", false)
    if StartCanvas then
	StartCanvas=HotfixHelper:GetRootObjectExactMath("StartCanvas", false)
        if StartCanvas then
            StartCanvas:SetActive(false)
        end
    end
    CSCameraManager.Get():OnInit(false)
    CarTextIconSizeWidth=2436*4
    CarTextIconSizeHigh=1125*4
    CameraStackHelper:SetUIDefaultGroup()
    RtHelper:Init()
    RtHelper:ClosePostProcessing()
end



function RemoveRequiredByName( preName )
if not CS.GameProperties:Get().IsFE then
    logError("preName = "..preName)
end
    for key, _ in pairs(package.preload) do
        if string.find(tostring(key), preName) == 1 then
            package.preload[key] = nil
if not CS.GameProperties:Get().IsFE then
            logError("preload key = "..key)
end
        end
    end
    for key, _ in pairs(package.loaded) do
        if string.find(tostring(key), preName) == 1 then
            package.loaded[key] = nil
        end
    end

    require(preName)
end
