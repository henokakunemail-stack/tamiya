---@class HotfixHelper
HotfixHelper = class("HotfixHelper")

----字符串分割
function HotfixHelper:StringSplit(srcStr, split)
    local res = {}
    local iterator = string.gmatch(srcStr, split)
    for v in iterator do
        local pos = string.find(srcStr, v)
        res[#res + 1] = string.sub(srcStr, 1, pos - 1)
        srcStr = string.sub(srcStr, pos + 1, #srcStr)
    end
    res[#res + 1] = srcStr
    return res
end

function HotfixHelper:StringSplitToNumber(srcStr, split)
    local res = HotfixHelper:StringSplit(srcStr, split)
    for i = 1, #res do
        res[i] = tonumber(res[i])
    end
    return res
end

function HotfixHelper:InstantiateGameObjectByObject(obj)
    if obj == nil then
        print("---   error:InstantiateGameObjectByObject    obj = nil")
        return nil
    end

    local result = CS.Horizon.Util.InstantiateGameObjectByObject(obj)
    return result
end

function HotfixHelper:GetGameobjectComponent(object, ctype)
    return CS.UIUtil.GetGameobjectComponent(object, ctype)
end

----name以/号分割，匹配场景中 和 name 相同的 root 的gameObject
function HotfixHelper:GetRootObjectExactMath(name, justRoot)
    if justRoot == nil then
        justRoot = false
    end
    local result = CS.Horizon.Util.GetRootObjectExactMath(name, justRoot)
    return result
end

function HotfixHelper:SetParentGameObject(parent, child, isreset, isresetui)
    if child == nil or parent == nil then
        return
    end
    if isreset == nil then
        isreset = true
    end
    if isresetui == nil then
        isresetui = false
    end
    HotfixHelper:SetParentTransform(parent.transform, child.transform, isreset, isresetui)
end
function HotfixHelper:SetParentTransform(parent, child, isreset, isresetui)
    if isreset == nil then
        isreset = true
    end
    child:Parent(parent)
    if isreset then
        child:LocalPosition(CS.UnityEngine.Vector3.zero)
        child:LocalScale(CS.UnityEngine.Vector3.one)
        child:LocalRotation(CS.UnityEngine.Quaternion.identity)
    end

    if isresetui then
        local rect = HotfixHelper:GetGameobjectComponent(child.gameObject, typeof(CS.UnityEngine.RectTransform))
        if rect then
            rect.offsetMax = CS.UnityEngine.Vector2.zero
            rect.offsetMin = CS.UnityEngine.Vector2.zero
        end
    end
end

function HotfixHelper:OpenURL(path)
    CS.MonoHelper.OpenURL(path)
end
function HotfixHelper:IsWhite()
    return CS.UnityEngine.PlayerPrefs.GetInt("GameProperties_FE",0)==1
end

function HotfixHelper:IsAndroidPlatform()
    return CS.MonoHelper.IsAndroidPlatform()
end

function HotfixHelper:GetCurPlatform()
    -- 返回类型  int
    -- OSXPlayer return 1;
    -- WindowsPlayer return 2;
    -- Android return 3;
    -- IPhonePlayer return 4;
    return CS.MonoHelper.GetCurPlatform()
end

--{{{路径接口
----返回本地persistentPath/Res/平台名字/version.txt
function HotfixHelper:GetLocalVersionPath()
    return CS.AppPath.PersistentDataPath4Res .. CS.AppPath.GetPlatformName() .. "/version.txt"
end
----返回包体streamingPath/平台名字/version.txt
function HotfixHelper:GetPkgVersionPath()
    return CS.AppPath.StreamingAssetsPath .. "/" .. CS.AppPath.GetPlatformName() .. "/version.txt"
end
----返回persistentPath/Res/平台名字/hotfixmap.txt
function HotfixHelper:GetLocalHotfixMapPath()
    return CS.AppPath.PersistentDataPath4Res .. CS.AppPath.GetPlatformName() .. "/hotfixmap.txt"
end
----返回包体streamingPath/平台名字/hotfixmap.txt
function HotfixHelper:GetPkgHotfixMapPath()
    return CS.AppPath.StreamingAssetsPath .. "/" .. CS.AppPath.GetPlatformName() .. "/hotfixmap.txt"
end
----返回包体streamingPath/平台名字/assetmap.txt
function HotfixHelper:GetPkgAssetMapPath()
    return CS.AppPath.StreamingAssetsPath .. "/" .. CS.AppPath.GetPlatformName() .. "/assetmap.txt"
end
----获取服务器 热更资源对应的URL 的txt，是一个总的,它其中包含了很多个资源的URL，每一个资源对应一个URL：serverUrl/平台名字/hotfixMap.txt
function HotfixHelper:GetServerHotfixMapUrl(resourcerul)
    if resourcerul == nil or resourcerul == "" then
        print("---   error:资源地址错误", resourcerul)
        resourcerul = "https://1"
    end
    if string.find(resourcerul, "http://", 1) == nil and string.find(resourcerul, "https://", 1) == nil then
        print("---   error:资源地址错误", resourcerul)
        resourcerul = "https://1"
    end
    return resourcerul .. "/" .. CS.AppPath.GetPlatformName() .. "/hotfixmap.txt"
end

----获取本地资源地址 persistentPath/Res/平台名字/filePath
function HotfixHelper:GetLocalAssetPath(filepath)
    local formattedPath = string.format("%s%s/%s", CS.AppPath.PersistentDataPath4Res, CS.AppPath.GetPlatformName(), filepath)
    return formattedPath
    --return CS.AppPath.PersistentDataPath4Res .. CS.AppPath.GetPlatformName() .. "/" .. filepath
end

----
function HotfixHelper:GetAssetUrl(filepath, version)
    if version and version ~= "" then
        local path = string.format("%s/%s/%s/%s", VersionManager:Get():GetAssetPathNoVersion(), version, CS.AppPath.GetPlatformName(), filepath)
        return path
        --return VersionManager:Get():GetAssetPathNoVersion() .. "/" .. version .. "/" .. CS.AppPath.GetPlatformName() .. "/" .. filepath
    else
        local path = string.format("%s/%s/%s/%s", VersionManager:Get():GetAssetPath(), CS.AppPath.GetPlatformName(), filepath)
        return path
        --return VersionManager:Get():GetAssetPath() .. "/" .. CS.AppPath.GetPlatformName() .. "/" .. filepath
    end

end
local PhoneNumberIp=nil
function HotfixHelper:GetPhoneNumberIp(func)
    if PhoneNumberIp==nil then
        CS.MonoHelper.GetPhoneNumberIp(function(result)
            PhoneNumberIp=result
            func(PhoneNumberIp)
        end)
    else
        func(PhoneNumberIp)
    end
end

----获取本地persistent/Res/平台名字/assetFlagMap.txt
function HotfixHelper:GetAssetFlagMapPath()
    return CS.AppPath.PersistentDataPath4Res .. CS.AppPath.GetPlatformName() .. "/assetflagmap.txt"
end
--}}}
----获取本地persistent/Res/平台名字/Manifest.txt
function HotfixHelper:GetAssetManifestPath()
    return CS.AppPath.PersistentDataPath4Res .. CS.AppPath.GetPlatformName() .. "/" .. CS.AppPath.GetPlatformName()
end
--}}}
----返回包体streamingPath/Res/平台名字/包体.Manifest
function HotfixHelper:GetPkgManifestPath()
    return CS.AppPath.StreamingAssetsPath .. CS.AppPath.GetPlatformName() .. "/" .. CS.AppPath.GetPlatformName() .. ".manifest"
end
--}}}

function HotfixHelper:GetManifestUrl(resourcerul)
    return resourcerul .. "/" .. CS.AppPath.GetPlatformName() .. "/" .. CS.AppPath.GetPlatformName()
end

--{{{文件操作
function HotfixHelper:CheckFileExist(path)
    return CS.MonoHelper.CheckFileExist(path)
end

function HotfixHelper:WriteFileString(path, data)
    CS.MonoHelper.WriteFileString(path, data)
end

function HotfixHelper:WriteFileBytes(path, data)
    CS.MonoHelper.WriteFileBytes(path, data)
end

function HotfixHelper:ReadFileString(path, ispkg)
    if ispkg == nil then
        ispkg = false
    end
    return CS.MonoHelper.ReadFileString(path)
end
--}}}

function HotfixHelper:ReadFileContents(filePath)
    local file, err = io.open(filePath, "r") -- 以只读模式打开文件
    if file then
        local content = file:read("*a") -- 读取文件的全部内容
        file:close() -- 关闭文件
        return content -- 返回文件内容
    else
        -- 如果文件打开失败，打印错误信息并返回nil
        print("无法打开文件: ")
        return ""
    end
end
function HotfixHelper:ClearLocalPatch()
    AssetFlagManager:Get():Clear()
    print("覆盖本地资源")
    local path = HotfixHelper:GetAssetFlagMapPath()
    local file, err = io.open(path, "r") -- 以只读模式打开文件
    if file~=nil then
        assert(os.remove(path),"删除不存在文件")
    end
    local path2 = HotfixHelper:GetLocalHotfixMapPath()
    local file, err = io.open(path2, "r") -- 以只读模式打开文件
    if file~=nil then
        assert(os.remove(path2),"删除不存在文件")
    end
    local versionPath=HotfixHelper:GetLocalVersionPath()
    HotfixHelper:WriteFileString(versionPath, VersionManager:Get().TempPkgVersion)
    print("覆盖本地资源完成")
end

function HotfixHelper:WriteFileContent(filePath, data)
    local file = io.open(filePath, "w") -- 以写入模式打开文件
    if file then
        file:write(data) -- 写入数据到文件
        file:close() -- 关闭文件
        print("Data saved to file: " .. filePath)
    else
        print("Failed to open file for writing.")
    end
end

--{{{ui接口
function HotfixHelper:GetChild(controlName, parent, isDirectChild)
    if controlName == nil or parent == nil then
        print("---   error:HotfixHelper.GetChild   controlName = ", controlName, "   parent = ", parent)
        return
    end
    return CS.UIUtil.GetChild(controlName, parent, isDirectChild or false)
end
function HotfixHelper:GetTypeChildWightByParent(controlName, parent, ctype, isDirectChild)
    return CS.UIUtil.GetTypeChildWightByParent(controlName, parent, ctype, isDirectChild or false)
end
function HotfixHelper:SetGameObjectActive(objname, parent, active)
    local obj = HotfixHelper:GetChild(objname, parent)
    if obj then
        obj:SetActive(active)
    end
    return obj
end

function HotfixHelper:SetGameObjectActiveByGo(object, isActive)
    if object then
        object:SetActive(isActive)
    end
end

function HotfixHelper:SetText(objName, parent, string)
    local text = HotfixHelper:GetTypeChildWightByParent(objName, parent, typeof(CS.UnityEngine.UI.Text))
    if text then
        local isandroid = HotfixHelper:IsAndroidPlatform()
        if not isandroid then
            CS.Horizon.Game.Language.LanguageSwitchManager.Get():SetTextFont(text,false)
        end
        text.text = string
    end
    return text
end

function HotfixHelper:SetTextByGo(text, string)
    if text then
        local isandroid = HotfixHelper:IsAndroidPlatform()
        if not isandroid then
            CS.Horizon.Game.Language.LanguageSwitchManager.Get():SetTextFont(text,false)
        end
        text.text = string
    end
    return text
end
function HotfixHelper:GetStringById(id)
    CS.Horizon.Game.Language.LanguageSwitchManager.Get():OnInit(GameProperties.languageType)
    local type = CS.Horizon.Game.Language.LanguageSwitchManager.Get():GetCurLanguage()
    if type == 1 then
        return HotfixStringCN[id]
    end
    if type == 2 then
        return HotfixStringTW[id]
    end
    if type == 3 then
        return HotfixStringEN[id]
    end
    if type == 4 then
        return HotfixStringTai[id]
    end
    if type == 5 then
        return HotfixStringIND[id]
    end
    if type == 6 then
        return HotfixStringBR[id]
    end
    if type == 7 then
        return HotfixStringKR[id]
    end
    return HotfixStringCN[id]
end

function HotfixHelper:HButtonSetCallback(objName, parent, func, paramInt, paramStr, paramLong)
    local btn = HotfixHelper:GetTypeChildWightByParent(objName, parent, typeof(CS.HButton))
    if btn then
        btn.intData = paramInt
        btn.longData = paramLong
        btn.stringData = paramStr
        btn.onClickAction = func
    end
    HotFixLuaEvent:Get():AddBtn(btn)
    return btn
end
function HotfixHelper:SetSlider(slider, value)
    if slider then
        slider.value = value
    end
    return slider
end

function HotfixHelper:SetSliderAniByGo(slider, value)
    if slider then
        slider:Play(value)
    end
    return slider
end
function HotfixHelper:SetSliderAniByFinishCallback(slider, func)
    if slider then
        slider:SetFinshCallback(func)
    end
    HotFixLuaEvent:Get():AddSlider(slider)
    return slider
end
function HotfixHelper:SetSliderAni(objName, parent, value, finish)
    local slider = HotfixHelper:GetTypeChildWightByParent(objName, parent, typeof(CS.Horizon.UI.Control.SliderAni))
    if slider then
        slider:Play(value, finish)
    else
        if finish then
            finish()
        end
    end
    HotFixLuaEvent:Get():AddSlider(slider)
    return slider
end
function HotfixHelper:SendHttpGetRequest(url, fun, errorfun)
    local HttpHelper2 = HttpHelperLua()
    HttpHelper2.successCallback_Lua = fun
    HttpHelper2.errorCallback_Lua = errorfun
    HttpHelper2:SendHttp(url)
    HotFixLuaEvent:Get():AddHttpCallBack(HttpHelper2)
    return HttpHelper2
end


function HotfixHelper:SendHttpGetRequestSaveAtCSharp(url,filename, fun, errorfun)

    local HttpHelper2 = HttpHelperLua()
    HttpHelper2.successSimpleCallback_Lua = fun
    HttpHelper2.errorCallback_Lua = errorfun
    HttpHelper2.isSaveInCSharp = true
    HttpHelper2.fileName = HotfixHelper:GetLocalAssetPath(filename)
    HttpHelper2:SendHttp(url)
    HotFixLuaEvent:Get():AddHttpCallBack(HttpHelper2)
    return HttpHelper2
end

function HotfixHelper:HttpAbort(httphelper)
    if httphelper and httphelper.request then
        httphelper.request:Abort()
    end
end

function HotfixHelper:HttpQuit()
    HttpHelperLua.HttpQuit()
end

function HotfixHelper:SendHttpPostRequest(url, jsonData, recvfun, errorfun)
    local HttpHelper2 =HttpHelperLua()
    if HttpHelper2 then
        HttpHelper2.successCallback = recvfun
        HttpHelper2.errorCallback = errorfun
        HttpHelper2:SendHttpPost_Json(url, jsonData)
        HotFixLuaEvent:Get():AddHttpCallBack(HttpHelper2)
    end
end
--}}}

----检查网络状态  0无网络 1WiFi 2移动网
function HotfixHelper:CheckAppNetType()
    --   -1:error   0:无网络     1:wifi    2:移动网
    return CS.MonoHelper.CheckAppNetType()
end

function HotfixHelper:ApplicationQuit()
    print("杀死进程")
    CS.UnityEngine.Application.Quit()
end
--region 发送日志服
function HotfixHelper:SendHttpPost_LogServer(jsonData, eventId, recvfun, errorfun,ismustsend)
    if ismustsend==nil then ismustsend=false end
    if not CS.GameProperties:Get().AssetBundleMode then
        return
    end
    if not CS.GameProperties:Get().LogSwitch and not ismustsend then return end
    local defaultUrl = "http://43.154.33.164:21009/InterfaceManager/ClientLog"

    if CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseGoogleSDK or CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseGoogleSDK2 or CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseGoogleSDK3 or CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseGoogleSDK4 then
        defaultUrl = "http://43.134.68.123:21009/InterfaceManager/ClientLog"
    elseif CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseUltraSdk then
        defaultUrl = "http://43.134.51.224:21009/InterfaceManager/ClientLog"
    elseif CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseUltraSdk2 then
        defaultUrl = "http://43.134.51.224:21009/InterfaceManager/ClientLog"
    elseif CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseUltraSdk3 then
        defaultUrl = "http://43.134.86.187:21009/InterfaceManager/ClientLog"
    elseif CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseUltraSdk4 then
        defaultUrl = "http://43.134.86.187:21009/InterfaceManager/ClientLog"
    elseif CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseUltraSdk5 then
        defaultUrl = "http://43.134.86.187:21009/InterfaceManager/ClientLog"
    elseif CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseQuickSDKChina then
        defaultUrl = "http://43.140.225.124:21009/InterfaceManager/ClientLog"
    end
    if CS.GameProperties:Get().ClientLogUrl ~=nil and CS.GameProperties:Get().ClientLogUrl ~="" then
        defaultUrl=CS.GameProperties:Get().ClientLogUrl
    end
    local key = "13e2ee68b3fe4ce88e7907c71482008b"
    local newData = CS.MonoHelper.AesEncryptor_Base64(jsonData, key)
    local signData = CS.AndroidUtility.Md5Encode(newData .. "." .. key)
    local jsonDataUp = Dll_JSON.encode(
            {
                data = newData,
                sign = signData,
                eventId = eventId
            })
    HotfixHelper:SendHttpPostRequest(defaultUrl, jsonDataUp, recvfun, errorfun)

end
HotFixEvent={
    AppStart="AppStart",--启动
    HttpError ="HotFixHttpError",--热更错误
}
AnalysisType2 =
{
    App_Init = "1kyxpl",
    end_race = "25bd1w",
    EnterPlayerData = "mrsrjg",
    first_pay="x6yqki",
    pay_done="mps6bv",
    PlayAd="bwkagl",
    PlayAdEnd="1xgo8m"
}
AnalysisTypeIOS2 = {
    App_Init = "1kyxpl",
    end_race = "25bd1w",
    EnterPlayerData = "mrsrjg",
    first_pay="x6yqki",
    pay_done="mps6bv",
    PlayAd="bwkagl",
    PlayAdEnd="1xgo8m"
}
AnalysisTypeIOS = {
    App_Init = "sl32y1",
    end_race = "nenvg0",
    EnterPlayerData = "mo7j8g",
    first_pay="iwuncd",
    pay_done="sg42xw",
    PlayAd="bwkagl",
    PlayAdEnd="1xgo8m"
}
AnalysisType =
{
    App_Init = "sl32y1",
    end_race = "nenvg0",
    EnterPlayerData = "mo7j8g",
    first_pay="iwuncd",
    pay_done="sg42xw",
    NetError="aws3pp",
    PlayAd="bwkagl",
    PlayAdEnd="1xgo8m"
}
local _uuid=nil
function HotfixHelper:GetChuJianData(eventname, data)
    _uuid= CS.UnityEngine.PlayerPrefs.GetString("Game4wd_Raceer_uuid","")
    if _uuid=="" then _uuid=math.random(0,1000000)..tostring(CS.System.DateTime.Now.Ticks)..math.random(0,100) CS.UnityEngine.PlayerPrefs.SetString("Game4wd_Raceer_uuid",_uuid) end
    local dataNew = {}
    dataNew.event_name = eventname
    dataNew.account_id = _uuid
    dataNew.device_id = CS.SDKManager:Get():Quick_GetDeviceId()
    dataNew.time = HotfixHelper:GetNowTimeForMta()
    dataNew.type = "track"


    if data==nil then data={} end
    data.created_time = HotfixHelper:GetNowTimeForMta()
    data.account = _uuid
    data.device = CS.SDKManager:Get():Quick_GetDeviceId()
    data.deviceModel = CS.UnityEngine.SystemInfo.deviceModel
    data.deviceName = CS.UnityEngine.SystemInfo.deviceName
    data.systemMemorySize = tostring(CS.UnityEngine.SystemInfo.systemMemorySize)
    data.operatingSystem = CS.UnityEngine.SystemInfo.operatingSystem

    for k, v in pairs(data) do
        if data and data[k]~=nil then

            data[k]=tostring(data[k])
        end
    end
    local jsonData = Dll_JSON.encode(data)

    dataNew.properties = jsonData
    for k, v in pairs(dataNew) do
        if dataNew and dataNew[k]~=nil then
            if k == "event_name" then
                dataNew["#event_name"]=tostring(dataNew[k])
            else
                dataNew[k]=tostring(dataNew[k])
            end
        end
    end
    local jsonDataNew = Dll_JSON.encode(dataNew)
    --local replaced_string = string.gsub(jsonDataNew, "\\\"", "\"")
    return jsonDataNew
end
function HotfixHelper:TrackEvent(eventname,data,ismustsend)
    local jsonData = self:GetChuJianData(eventname, data)
    self:SendHttpPost_LogServer(jsonData, 0, nil, nil, ismustsend)
    if data.adjustToken ~= nil and  data.adjustToken ~= "" then
        self:SetCustomEvent(data.adjustToken)
    end
end
function HotfixHelper:TrackAppStart(state,size,finishcount,ismustsend,token)
    local appStartTime=CS.MonoHelper.GetAppStartTime()
    local curTime=CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow())
    local localVersion="0" if VersionManager and VersionManager:Get().TempLocalVersion ~=nil and VersionManager:Get().TempLocalVersion~="" then localVersion=VersionManager:Get().TempLocalVersion end
    local pkgverison="0" if VersionManager and VersionManager:Get().TempPkgVersion ~=nil and VersionManager:Get().TempPkgVersion~="" then pkgverison=VersionManager:Get().TempPkgVersion end
    local serverversion="0" if VersionManager and VersionManager:Get().TempServerVersion ~=nil and VersionManager:Get().TempServerVersion~="" then serverversion=VersionManager:Get().TempServerVersion end
    local data={
        State=state,
        AppStartTime=appStartTime,
        curTime=curTime,
        AwakeTime=curTime-appStartTime,
        Size=size and size or 0,
        FinishCount=finishcount and finishcount or 0,
        LocalVersion=localVersion,
        PkgVersion=pkgverison,
        SerVersion=serverversion,
        adjustToken = token,
    }
    HotfixHelper:TrackEvent(HotFixEvent.AppStart,data,ismustsend,token)
end
AnalysisCustomEventData = CS.UnifySDK.Event.Analysis.CustomEventData

function HotfixHelper:SetCustomEvent(Token)
    --if CS.UnityEngine.Application.platform == CS.UnityEngine.RuntimePlatform.Android then
    local eventData = AnalysisCustomEventData()
    eventData.eventName = Token
    --CS.UnifySDK.UnifySDKManager.Instance.IUnifySDK_Analysis:SetCustomEvent(eventData)
    CS.UnifySDK.Event.UnifySDKEventSystem.Instance:Publish(eventData)
    --end
end

function HotfixHelper:TrackHotFixHttpError(filename,error,version,assetpath,finishMb,fileMb,max,loadTime)
    local data={
        FileName=filename,
        Error=error,
        Version=version,
        AssetPath=assetpath,
        FinishMb=finishMb,
        FileMb=fileMb,
        Max=max,
        LoadTime=loadTime,
        adjustToken=AnalysisType.HotFixHttpError
    }
    HotfixHelper:TrackEvent(HotFixEvent.HttpError,data)
end
function HotfixHelper:GetNowTimeForMta()
    return CS.MonoHelper.GetNowTimeForMta()
end
--endregion
HotFixLuaEvent = class("HotFixLuaEvent")
function HotFixLuaEvent:initialize()

end
function HotFixLuaEvent:Get()
    if self._instance == nil then
        self._instance = HotFixLuaEvent()
    end
    return self._instance
end

function HotFixLuaEvent:AddBtn(bth)
    if self.BtnList == nil then
        self.BtnList = {}
    end
    table.insert(self.BtnList, bth)
end
function HotFixLuaEvent:AddSlider(slider)
    if self.SliderList == nil then
        self.SliderList = {}
    end
    table.insert(self.SliderList, slider)
end
function HotFixLuaEvent:AddHttpCallBack(fun)
    if self.HttpFunList == nil then
        self.HttpFunList = {}
    end
    table.insert(self.HttpFunList, fun)
end

function HotFixLuaEvent:Clear()
    if self.BtnList then
        for i = 1, #self.BtnList do
            self.BtnList[i].onClickAction = nil
        end
        self.BtnList = nil
    end
    if self.SliderList then
        for k, v in pairs(self.SliderList) do
            v:Clear()
            v.action = nil
        end
        self.SliderList = nil
    end
    if self.HttpFunList then
        for k, v in pairs(self.HttpFunList) do
            v.successCallback = nil
            v.errorCallback = nil
        end
        self.HttpFunList = nil
    end
end
---@class SDKData :SDK渠道名字
SDKChannelNames = {
    ---   @field  int@IsUseGATSDK
    IsUseGATSDK = 9999,
    ---   @field  int@IsUseQuickSDK
    IsUseQuickSDK =1,
    ---   @field  int@IsUseHuaWeiSDK
    IsUseHuaWeiSDK =2,
    ---   @field  int@IsUseHuaWeiSDKSelf
    IsUseHuaWeiSDKSelf = 3,
    ---   @field  int@IsUseGoogleSDK
    IsUseGoogleSDK = 4,
    ---   @field  int@IsUseQuickSDKSEA
    IsUseQuickSDKSEA = 5,
    ---   @field  int@IsUseGoogleSDK2
    IsUseGoogleSDK2 = 6,
    ---   @field  int@IsUseGoogleSDK3
    IsUseGoogleSDK3 = 7,
    ---   @field  int@IsUseGoogleSDK4
    IsUseGoogleSDK4 = 8,
    ---   @field  int@IsUseUltraSdk
    IsUseUltraSdk = 9,
    ---   @field  int@IsUseUltraSdk2
    IsUseUltraSdk2 = 10,
    ---   @field  int@IsUseQuickSDKChina
    IsUseQuickSDKChina = 11,
    ---   @field  int@IsUseUseUltraSdkkr
    IsUseUltraSdk3 = 12,
  ---   @field  int@IsUseUseUltraSdkkr
    IsUseUltraSdk4 = 13,
    ---   @field  int@IsUseUseUltraSdkkr
    IsUseUltraSdk5 = 14

}