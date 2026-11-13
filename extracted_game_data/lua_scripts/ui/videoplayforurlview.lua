
local VideoPlayType={
    Popup=1,
    View=2
}
---@class VideoPlayForUrlView:ViewBase
VideoPlayForUrlView = class("VideoPlayForUrlView",ViewBase)


function VideoPlayForUrlView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "VideoPlayForUrlViewAction")
end

function VideoPlayForUrlView:Awake()
    CommonHelper:HButtonSetCallback("BtnSkipPopup",self.gameObject,function(data)
        self.VideoPlayer:Stop()
       UIManager:Get():ClosePopup()
    end)
    self.VideoPlayerPopup=self:GetChildWightByParent("VideoPlayerPopup",self.gameObject,typeof(CS.UnityEngine.Video.VideoPlayer))
    self.AudioSourcePopup=self:GetChildWightByParent("VideoPlayerPopup",self.gameObject,typeof(CS.UnityEngine.AudioSource))
    self.CanvasGroupPopup=self:GetChildWightByParent("VideoPlayerPopup",self.gameObject,typeof(CanvasGroup))
    CommonHelper:HButtonSetCallback("BtnSkipView",self.gameObject,function(data)
        self.VideoPlayer:Stop()
       UIManager:Get():ClosePopup()
    end)
    self.VideoPlayerView=self:GetChildWightByParent("VideoPlayerView",self.gameObject,typeof(CS.UnityEngine.Video.VideoPlayer))
    self.AudioSourceView=self:GetChildWightByParent("VideoPlayerView",self.gameObject,typeof(CS.UnityEngine.AudioSource))
    self.CanvasGroupView=self:GetChildWightByParent("VideoPlayerView",self.gameObject,typeof(CanvasGroup))
end

function VideoPlayForUrlView:OnOpen()

end
function VideoPlayForUrlView:OnClose()
    if self.cor then
        cs_coroutine.stop(self.cor)
        self.cor=nil
    end
    CommonHelper:InitSound()
    if self.CloseFunc then
        self.CloseFunc()
    end
end
function VideoPlayForUrlView:Play(name,videoTime,type,func,isSkip)
    CommonHelper:SetGameObjectActive("VideoImageScale",self.gameObject,true)
    CommonHelper:SetGameObjectActive("popup",self.gameObject,type==VideoPlayType.Popup)
    CommonHelper:SetGameObjectActive("view",self.gameObject,type==VideoPlayType.View)
    CommonHelper:SetGameObjectActive("VideoPlayerPopup",self.gameObject,type==VideoPlayType.Popup)
    CommonHelper:SetGameObjectActive("VideoPlayerView",self.gameObject,type==VideoPlayType.View)
    CommonHelper:SetGameObjectActive("BtnSkipPopup",self.gameObject,type==VideoPlayType.Popup and isSkip)
    CommonHelper:SetGameObjectActive("BtnSkipView",self.gameObject,type==VideoPlayType.View and isSkip)
    self.VideoPlayer=self.VideoPlayerPopup
    self.AudioSource=self.AudioSourcePopup
    self.CanvasGroup=self.CanvasGroupPopup
    if type==VideoPlayType.View then
        self.VideoPlayer=self.VideoPlayerView
        self.AudioSource=self.AudioSourceView
        self.CanvasGroup=self.CanvasGroupView
    end
    UIUtil.ShowCanvasGroup(self.CanvasGroup,true)
    self.VideoPlayer.url = monoVideoMgr:GetVideoPath(name)
    self.VideoPlayer:Play()
    self.CloseFunc=func
    self.Type=type
    CSLuaHelper.SetAudioVolumeByAudioType(AudioType.BGM, 0)
    self.cor=cs_coroutine.start(function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(videoTime))
        if type==VideoPlayType.Popup then
            UIManager:Get():ClosePopup()
        end
        if type==VideoPlayType.View then
            UIManager:Get():ClosePopup()
        end
    end)
end

