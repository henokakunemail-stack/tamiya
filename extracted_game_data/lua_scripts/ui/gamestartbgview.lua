---@class Page_GameStartBgView : ViewBase
Page_GameStartBgView = class("GameStartBgView")

function Page_GameStartBgView:SetData(parent)
    local name="GameStartBGCNView"
    local isAndroid = HotfixHelper:IsAndroidPlatform()
    print(SDKChannelNames.IsUseUltraSdk2,isAndroid,"----222")
    if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseHuaWeiSDK) or SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseQuickSDK) or SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK) then
        name="GameStartBG1View"
    elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK) then
        name="GameStartBG2View"
    elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk3) then
        name="GameStartBG6View"
    elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk4) then
        name="GameStartBG6View"
    elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk5) then
        name="GameStartBG6View"
    elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk2) and  isAndroid then
       name="GameStartBG3View"
    elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK3) then
        name="GameStartBG4View"
    elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk2) and not isAndroid then
        name="GameStartBG5View"
    else
        name="GameStartBGCNView"
    end
    self.BgAsset = AssetsManager.Load(name..".prefab", typeof(GameObject))
    self.gameObject = CommonHelper:InstantiateGameObjectByObject(self.BgAsset.asset)
    UIUtil.SetParentTransform(parent,self.gameObject,true,true)
    if name=="GameStartBG4View" then
        self.VideoPlayer=UIUtil.GetTypeChildWightByParent("VideoPlayer",self.gameObject,typeof(CS.UnityEngine.Video.VideoPlayer))
        self.AudioSource=UIUtil.GetTypeChildWightByParent("VideoPlayer",self.gameObject,typeof(CS.UnityEngine.AudioSource))
        self:Play()
    end
    if name=="GameStartBGCNView" then
        self.FXUITweenMoreGroup =UIUtil.GetTypeChildWightByParent("Center",self.gameObject, typeof(FXUITweenMoreGroup))
        CommonHelper:TMG_PlayAllTween(self.FXUITweenMoreGroup)
    end
end

function Page_GameStartBgView:Play()
    local url=monoVideoMgr:GetVideoPath("video_part_10020124.mp4")
    CommonHelper:SetGameObjectActive("VideoImageScale",self.gameObject,true)
    CommonHelper:SetGameObjectActive("VideoPlayer",self.gameObject,true)
    self.VideoPlayer.url = url
    self.VideoPlayer:Play()
    self.VideoPlayer:SetTargetAudioSource(0, self.AudioSource);
end
function Page_GameStartBgView:Stop()
    if self.VideoPlayer then
        self.VideoPlayer:Stop()
    end
end

function Page_GameStartBgView:Unload()
    self:Stop()
    GameObject.Destroy(self.BgPrefab)
    AssetsManager.Unload(self.BgAsset)
    self.BgPrefab=nil
    self.BgAsset=nil
end

