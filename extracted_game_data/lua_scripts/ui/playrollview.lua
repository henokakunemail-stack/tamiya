---@class PlayRollView : ViewBase
PlayRollView = class("PlayRollView", ViewBase)

function PlayRollView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PlayRollViewAction")
end

function PlayRollView:Awake()
    self.timer_system = -1
    self.timer_player = -1
    self.timeOutCount_system = 20
    self.timeOutCount_player = 15
    self.isPlayingRoll_System = false--是否正在播放跑马灯
    self.isPlayingRoll_Player = false
    self.tweenRollLampMoreGroup_System = self:GetChildWightByParent("tweenRollLamp_System", self.gameObject, typeof(FXUITweenMoreGroup))
    self.tweenRollLampMoreGroup_Player = self:GetChildWightByParent("tweenRollLamp_Player", self.gameObject, typeof(FXUITweenMoreGroup))
    self.tweenRollGo = self:GetChild("tweenPosRight")
    self.system = self:GetChild("tweenPosRight_System")
    self.player = self:GetChild("tweenPosRight_Player")
    CommonHelper:CSGameObjectSetActive(self.system,false)
    CommonHelper:CSGameObjectSetActive(self.player,false)
    CommonHelper:TMG_SetAllTweenCallBack(self.tweenRollLampMoreGroup_System, function()
        self.isPlayingRoll_System = false
        self.timer_system = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + self.timeOutCount_system
        self:UpdateRollText_System()
    end)
    CommonHelper:TMG_SetAllTweenCallBack(self.tweenRollLampMoreGroup_Player, function()
        self.isPlayingRoll_Player= false
        self.timer_player = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + self.timeOutCount_player
        self:UpdateRollText_Player()
    end)
end

function PlayRollView:OnOpen()

    self.timeOutCoroutine = cs_coroutine.start(function()
        while true do
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
            if self.timer_system>0 and  CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())>self.timer_system then
                self.timer_system = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + self.timeOutCount_system
                self.isPlayingRoll_System = false
                CommonHelper:CSGameObjectSetActive(self.system,false)
                log("    超时处理  isPlayingRoll_System  ")
            end
            if self.timer_player>0 and CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) >self.timer_player then
                self.timer_player = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + self.timeOutCount_player
                self.isPlayingRoll_Player = false
                CommonHelper:CSGameObjectSetActive(self.player,false)
                log("     超时处理  isPlayingRoll_Player ")
            end
        end
    end
    )
    self.isPlayingRoll_System = false--是否正在播放跑马灯
    self.isPlayingRoll_Player = false
    CommonHelper:CSGameObjectSetActive(self.system,false)
    CommonHelper:CSGameObjectSetActive(self.player,false)
end

function PlayRollView:OnClose()
    if self.timeOutCoroutine~=nil then
        cs_coroutine.stop( self.timeOutCoroutine)
    end
    self.timeOutCoroutine=nil
    self.isPlayingRoll_System = false--是否正在播放跑马灯
    self.isPlayingRoll_Player = false
    self.timer_system=-1
    self.timer_player=-1
    CommonHelper:CSGameObjectSetActive(self.system,false)
    CommonHelper:CSGameObjectSetActive(self.player,false)
end

function PlayRollView:UpdateRollText_System()
    if not self.isPlayingRoll_System then
        local noticeItemData = NoticeDataManager:Get():GetNextSystemNotice()
        if noticeItemData ~= nil then
            CommonHelper:CSGameObjectSetActive(self.system, true)
            CommonHelper:SetGameObjectActive("###rollLampText_2",self.gameObject,noticeItemData.type == NoticeLittleType.PlayerSystem)
            CommonHelper:SetGameObjectActive("###rollLampText_3",self.gameObject,noticeItemData.type == NoticeLittleType.GMSystem)
            if noticeItemData.type==NoticeLittleType.PlayerSystem then
                CommonHelper:SetText("###rollLampText_2", self.gameObject,noticeItemData:GetContent())
            elseif noticeItemData.type==NoticeLittleType.GMSystem then
                CommonHelper:SetText("###rollLampText_3", self.gameObject,noticeItemData:GetContent())
            end
            self.isPlayingRoll_System = true
            self.timer_system = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + self.timeOutCount_system
            CommonHelper:TMG_PlayAllTween(self.tweenRollLampMoreGroup_System)
        else
            self.timer_system =-1
            CommonHelper:CSGameObjectSetActive(self.system, false)
        end
    end
end

function PlayRollView:UpdateRollText_Player()
    if not self.isPlayingRoll_Player then
        local noticeItemData = NoticeDataManager:Get():GetNextPlayerNotice()
        if noticeItemData ~= nil then
            CommonHelper:CSGameObjectSetActive(self.player, true)
            CommonHelper:SetGameObjectActive("###rollLampText_0",self.gameObject,noticeItemData.type == NoticeLittleType.SmallSpeak)
            CommonHelper:SetGameObjectActive("###rollLampText_1",self.gameObject,noticeItemData.type == NoticeLittleType.BigSpeak)
            if noticeItemData.type==NoticeLittleType.SmallSpeak then
                CommonHelper:SetText("###rollLampText_0", self.gameObject, noticeItemData:GetContent())
            elseif noticeItemData.type==NoticeLittleType.BigSpeak then
                CommonHelper:SetText("###rollLampText_1", self.gameObject, noticeItemData:GetContent())
            end
            self.isPlayingRoll_Player= true
            self.timer_player = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + self.timeOutCount_player
            CommonHelper:TMG_PlayAllTween(self.tweenRollLampMoreGroup_Player)
        else
            self.timer_player =-1
            CommonHelper:CSGameObjectSetActive(self.player, false)
        end
    end
end
