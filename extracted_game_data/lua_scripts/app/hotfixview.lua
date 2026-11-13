---@class HotfixView
HotfixView = class("HotfixView")

function HotfixView:initialize()
    self.gameObject = nil
    self.tipsText = nil
    self.progressText = nil
    self.progressSlider = nil
    self.formatStr = nil
end

function HotfixView:SetData(obj)
    self.gameObject = obj

    self.tipsText = HotfixHelper:GetTypeChildWightByParent("###HotfixTips", self.gameObject, typeof(CS.UnityEngine.UI.Text))
    self.progressText = HotfixHelper:GetTypeChildWightByParent("###PrecessValueText", self.gameObject, typeof(CS.UnityEngine.UI.Text))
    self.Slider = HotfixHelper:GetTypeChildWightByParent("AssetUpdateSlider", self.gameObject, typeof(CS.UnityEngine.UI.Slider))
    self.progressSlider = HotfixHelper:GetTypeChildWightByParent("AssetUpdateSlider", self.gameObject, typeof(CS.Horizon.UI.Control.SliderAni))
    self.downLoadText = HotfixHelper:GetTypeChildWightByParent("downLoadText", self.gameObject, typeof(CS.UnityEngine.UI.Text))
    self.startLoadText = HotfixHelper:GetTypeChildWightByParent("###startLoadText", self.gameObject, typeof(CS.UnityEngine.UI.Text))
    self.ClientVersion = HotfixHelper:GetTypeChildWightByParent("###clientVersion", self.gameObject, typeof(CS.UnityEngine.UI.Text))
    self.SysText = HotfixHelper:GetTypeChildWightByParent("###sysVersion", self.gameObject, typeof(CS.UnityEngine.UI.Text))
    self:SetTips("")

    self:SetParent(obj)
    HotfixHelper:SetSlider(self.Slider, 0)
    HotfixMsgBoxHelper:Get():Init(self.gameObject)

    self:CloseUpdateSlider()
    self:SetBgImgBySdk()
end

function HotfixView:SetStart(func)
    HotfixHelper:SetGameObjectActive("UpdateAsset", self.gameObject, false)
    self:SetStartLoadTextText(HotfixHelper:GetStringById(HotfixString.AppStartLoadLocalConfig))
    HotfixHelper:SetSliderAniByGo(self.progressSlider, 0.2)

end
function HotfixView:SetVersion()
    local localVersion="0" if VersionManager and VersionManager:Get().TempLocalVersion ~=nil and VersionManager:Get().TempLocalVersion~="" then localVersion=VersionManager:Get().TempLocalVersion end
    local pkgverison="0" if VersionManager and VersionManager:Get().TempPkgVersion ~=nil and VersionManager:Get().TempPkgVersion~="" then pkgverison=VersionManager:Get().TempPkgVersion end
    print(localVersion,"Version")
    print(pkgverison,"Version")
    if localVersion~="" and localVersion~=nil and localVersion~="0" then
        localVersion=string.format(HotfixHelper:GetStringById(HotfixString.HotFixClientVersion),localVersion)
        HotfixHelper:SetTextByGo(self.ClientVersion, localVersion)
    end
    if pkgverison~="" and pkgverison~=nil and pkgverison~="0" then
        pkgverison=string.format(HotfixHelper:GetStringById(HotfixString.HotFixSysVersion),pkgverison)
        HotfixHelper:SetTextByGo(self.SysText, pkgverison)
    end
end

function HotfixView:SetBgImgBySdk()
    local isAndroid = HotfixHelper:IsAndroidPlatform()
    HotfixHelper:SetGameObjectActive("bgImg", self.gameObject, CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseQuickSDK or CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseHuaWeiSDK )
    HotfixHelper:SetGameObjectActive("bgImg1", self.gameObject, CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseGoogleSDK or  CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseGoogleSDK4)
    HotfixHelper:SetGameObjectActive("bgImg2", self.gameObject, CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseUltraSdk2  and isAndroid)
    HotfixHelper:SetGameObjectActive("bgImg3", self.gameObject, (CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseUltraSdk2) and not isAndroid)
    HotfixHelper:SetGameObjectActive("bgImg4", self.gameObject, (CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseUltraSdk3 or CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseUltraSdk4 or CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseUltraSdk5) )
    HotfixHelper:SetGameObjectActive("bgImgcn", self.gameObject,(CS.GameProperties:Get().UseSDKType == SDKChannelNames.IsUseQuickSDKChina) or not CS.GameProperties:Get().IsUseSDK)

end

function HotfixView:SetGetLocalVersion(func)
    self:SetStartLoadTextText(HotfixHelper:GetStringById(HotfixString.AppStartLoadGetVersionData))
end
function HotfixView:SetLoadGameData(func)
    self:SetStartLoadTextText(HotfixHelper:GetStringById(HotfixString.AppStartLoadGameData))
end
function HotfixView:SetLoadCheckVersionData(func)
    self:SetStartLoadTextText(HotfixHelper:GetStringById(HotfixString.AppStartLoadCheckVersionData))
end

----把热更放到start  canvas 下
function HotfixView:SetParent(obj)
    if obj then
        local parent = HotfixHelper:GetRootObjectExactMath("StartCanvas/Root", false)
        HotfixHelper:SetParentGameObject(parent, obj, true, true)
    end
end

function HotfixView:SetUI()
    self:SetStartLoadTextText("")
    HotfixHelper:SetGameObjectActive("UpdateAsset", self.gameObject, true)
    -- HotfixHelper:SetSliderAniByFinishCallback(self.progressSlider,function()
    print("版本完成")
    self:CloseUpdateSlider()
    self:AskNewPkg()
    self:AskNewVersion()
    --   end)
    -- HotfixHelper:SetSliderAniByGo(self.progressSlider, 1)
end
function HotfixView:SetHotFixEnd()
    HotfixHelper:SetGameObjectActive("UpdateAsset", self.gameObject, false)
    self:SetStartLoadTextText(HotfixHelper:GetStringById(HotfixString.HotFixEndAppStart))
    HotfixHelper:SetSliderAniByGo(self.progressSlider, 0.2)
end
function HotfixView:SetEnd(func)
    self:SetDownLoadText(HotfixHelper:GetStringById(HotfixString.AppLoadAsset))
    func()
end

function HotfixView:SetTips(tips)
    if self.tipsText ~= nil then
        HotfixHelper:SetTextByGo(self.tipsText, tips)
    end
end
function HotfixView:SetProgressText(progress)
    HotfixHelper:SetTextByGo(self.progressText, progress)
end

function HotfixView:SetDownLoadText(text)
    HotfixHelper:SetTextByGo(self.downLoadText, text)
end

function HotfixView:SetStartLoadTextText(text)
    HotfixHelper:SetTextByGo(self.startLoadText, text)
end


--{{{更新进度
function HotfixView:OpenUpdateSlider()
    local obj = HotfixHelper:SetGameObjectActive("UpdateAsset", self.gameObject, true)
    self:SetDownLoadText(HotfixHelper:GetStringById(HotfixString.AppStartCheckVersion))
    HotfixHelper:SetSlider(self.Slider, 0)
    self.progressSlider = HotfixHelper:SetSliderAniByFinishCallback(self.progressSlider, function()

    end)
    HotfixHelper:SetGameObjectActive("downLoadText", self.gameObject, false)

    self:SetTips(HotfixHelper:GetStringById(HotfixString.MsgCalculatingTip))
end

function HotfixView:CloseUpdateSlider()
    HotfixHelper:SetGameObjectActive("UpdateAsset", self.gameObject, false)
end

function HotfixView:UpdateProgress(value, max)

    if self.formatStr == nil then
        self.formatStr = max >= 0.1 and "%0.2fMB/%0.2fMB" or "%dKB/%dKB"
    end
    if max < 0.1 then
        max = math.floor(max * 1024)
        value = math.floor(value * 1024)
    end

    local str = string.format(self.formatStr, value, max)
    self:SetProgressText(str)
    local per = value / max
    HotfixHelper:SetSliderAniByGo(self.progressSlider, per)
end
--}}}

function HotfixView:CheckVersionFail(func)
    HotfixMsgBoxHelper:Get():OpenMsgBox(HotfixHelper:GetStringById(HotfixString.CheckVersionFail), function()
        if func then
            func()
        end
    end, function()
        HotfixHelper:ApplicationQuit()
    end)
end




--{{{是否有新版本
function HotfixView:AskNewPkg()
    local result = VersionManager:Get():GetVersionCheckResult()
    --if result == SerE_VersionCheckResult.Package then
    --    HotfixMsgBoxHelper:Get():OpenMsgBox(HotfixString.MsgUpdateVersionTip, function()
    --        HotfixHelper:ApplicationQuit()
    --        --HotfixHelper:OpenURL(VersionManager:Get():GetPackageUrl())
    --    end, function()
    --        HotfixHelper:ApplicationQuit()
    --    end)
    --end

    if result == SerE_VersionCheckResult.Package then
        HotfixMsgBoxHelper:Get():OpenMsgBox(HotfixHelper:GetStringById(HotfixString.MsgUpdateVersionTip), function()
            local CPSChannelID = CS.UnifySDK.UnifySDKManager.Instance.IUnifySDK_Account:GetCPSChannelID()
            local ChannelID = CS.UnifySDK.UnifySDKManager.Instance.IUnifySDK:GetChannelID()
            if (ChannelID == "134" and CPSChannelID == "tap") or ChannelID == "27512" then
                CS.UnifySDK.UnifySDKManager.Instance.IUnifySDK_Account:callFunction(206)
            else
                HotfixHelper:OpenURL(VersionManager:Get().PackageUrl)
                HotfixHelper:ApplicationQuit()
            end

        end, nil, nil, nil, MsgBoxType.Ensure)
    end
end
--}}}

--{{{是否有新版本
function HotfixView:AskNewVersion()
    local result = VersionManager:Get():GetVersionCheckResult()
    if result == SerE_VersionCheckResult.Assets then
        HotfixHelper:SetTextByGo(self.tipsText, HotfixHelper:GetStringById(HotfixString.MsgLoadingTip))
        HotfixManager:Get():Init(function()
            HotfixHelper:SetTextByGo(self.tipsText, "")
            local isGreat100, assetSize = HotfixManager:Get():GetAssetSize()
            print("=--------assetSZIE", assetSize)
            VersionManager:Get():SetTipText( HotfixHelper:GetStringById(HotfixString.MsgLoadingTip_HotfixMapBeginDown))
            self:AskNet(isGreat100)
        end, function()
            self:CheckVersionFail(function()
                self:AskNewVersion()
            end)
        end)
    end
end
--}}}


--{{{开始下载patch时检测网络
function HotfixView:AskNet(isGreat100)
    if HotfixHelper:CheckAppNetType() == 0 then
        HotfixMsgBoxHelper:Get():OpenMsgBox(HotfixHelper:GetStringById(HotfixString.NoNet), function()
            self:AskNet()
        end, function()
            HotfixHelper:ApplicationQuit()
        end, HotfixHelper:GetStringById(HotfixString.MsgRetry))
    end
    if HotfixHelper:CheckAppNetType() == 1 then
        self:StartDownload()
    end
    if HotfixHelper:CheckAppNetType() == 2 then
        if isGreat100 then
            HotfixMsgBoxHelper:Get():OpenMsgBox(HotfixHelper:GetStringById(HotfixString.MsgDataNetTip), function()
                self:StartDownload()
            end, function()
                HotfixHelper:ApplicationQuit()
            end)
        else
            self:StartDownload()
        end
    end
end
--}}}


--{{{开始下载patch
function HotfixView:StartDownload()

    print("StartDownload1", CS.UnityEngine.Time.realtimeSinceStartup, isHotfix)
    cs_coroutine.start(function()
        coroutine.yield()
        HotfixManager:Get():DownloadStart()
        coroutine.yield()
        coroutine.yield()
        self:OpenUpdateSlider()
        self:SetDownLoadText(HotfixHelper:GetStringById(HotfixString.CheckAssetArea))
        self:SetTips("")
        HotfixHelper:SetGameObjectActive("downLoadText", self.gameObject, true)
        print("StartDownload2", CS.UnityEngine.Time.realtimeSinceStartup, isHotfix)
    end)


end
--}}}



function HotfixView:CloseView()

end