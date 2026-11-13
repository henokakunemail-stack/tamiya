local _ref = 0
---@class RecruitViewAni1 : ViewBase
RecruitViewAni1 = class("RecruitViewAni1")

function RecruitViewAni1:initialize()
    self:CacheRecruitViewAniData()
end

function RecruitViewAni1:CacheRecruitViewAniData()
    self.AniObj = nil

    self.BuildIds = {}
    self.CarCount = 0
    self.FinishMsg = nil

    self.isAdvance = false--是否是高级特效

    self.btnClickTimerId = nil
    self.EndFun=nil
end
---@param msg SC_UserRecruit
function RecruitViewAni1:Begin(CarType,CarCount,isAdvance,endFun)
    self:BeginWaitingTimer()
    self.EndFun=endFun
    if self.AniObj then
        PrefabCacheMgr:Get():RecyclePrefab(self.AniObj)
    end
    self.AniObj = self:GetAniObj(CarCount,isAdvance)
    local cars=nil
    local carFive=RecruitDataManager:Get().carFive
    local carTwo=RecruitDataManager:Get().carTwo
    local carTwoDam=RecruitDataManager:Get().carTwoDam
    if CarCount==LotteryType.Ten then
        cars=carFive
    else
        if CarType==LotteryCarType.Normal then
            cars=carTwo
        else
            cars=carTwoDam
        end

    end
    self.CarCount =#cars
    self:LoadCarFinish()
end




function RecruitViewAni1:OnClose()

    RecruitDataManager:Get():ReleaseCar()

    if self.AniObj then
        PrefabCacheMgr:Get():RecyclePrefab(self.AniObj)
    end
    self.AniObj = nil
end


--region 抽奖确认之后的播放加载车辆的动画
function RecruitViewAni1:BeginWaitingTimer()
    self:StopTimer()
    self.timerId = TimerManager:Get():CreateTimer(5, function(class)
        self:StopTimer()
        print("---   error:recruit overtime... ")
    end)
    CommonHelper:PlayScreenEffectWaiting(true)
end


---@param msg SC_UserRecruit
function RecruitViewAni1:GetAniObj(CarCount,isAdvance)
    local aniObj = nil
    if CarCount==LotteryType.One then
        aniObj = PrefabCacheMgr:Get():SwapPrefab(isAdvance == true and RecruitAniName_NewOneAdvance or RecruitAniName_NewOneAdvance)
    else
        aniObj = PrefabCacheMgr:Get():SwapPrefab(isAdvance == true and RecruitAniName_NewTenAdvance or RecruitAniName_NewTenAdvance)
    end
    self.isAdvance = isAdvance
    return aniObj
end

function RecruitViewAni1:LoadCarFinish()
    self:PlayAni(self.CarCount)
end

function RecruitViewAni1:PlayAni(count)

    UIManager:Get():OpenView("RecruitSkipView", CanvasType.MainCanvas, "RecruitSkipView")

    self:StopTimer()

    self:SetCamera(count)
    local time = 21
    --if count == 2 then
    --    time = self.isAdvance == true and 15.03 or 13.25
    --else
    --    time = self.isAdvance == true and 14.3 or 13.2
    --end

    if self.aniEndTimerId ~= nil then
        TimerManager:Get():StopTimer(self.aniEndTimerId)
        self.aniEndTimerId = nil
    end
    self.aniEndTimerId = TimerManager:Get():CreateTimer(time, function()
        self:PlayAniEnd()
        TimerManager:Get():StopTimer(self.aniEndTimerId)
        self.aniEndTimerId = nil
    end)
    AudioManager:PlayBGM("bgm_luckdraw_01.mp3")
end

function RecruitViewAni1:SetCamera(count)
    if count==2 then
        local temp = UIUtil.GetChild("Camera", self.AniObj)
        HomeSceneHelper:SetCameraRecruitAni(temp)
        local fxCom = UIUtil.GetGameobjectComponent(self.AniObj, typeof(CS.Horizon.Game.ShowLayer.FXFollowCamera))
        if fxCom then
            fxCom:SetCameraRoot(UIUtil.GetChild("Camera", self.AniObj))
        end
    else
        HomeSceneHelper:SetCameraRecruitAni()
        self._CinemachineBlendDefinitionStyle= CinemachineCameraHelper:GetCineMachineCameraDefaultBland()
        self._CinemachineBlendDefinitionStyleTime= CinemachineCameraHelper:GetCineMachineCameraDefaultBlandTime()
        CinemachineCameraHelper:SwitchCineMachineCameraDefaultBland(CinemachineBlendDefinitionStyle.Cut,0)
        CinemachineCameraHelper:SetCineMachineCameraActive(true)
    end
end

function RecruitViewAni1:PlayAniEnd()


    AudioManager:PauseBGM()
    CommonHelper:CSGameObjectSetActive(self.AniObj, false)

    if self.AniObj then
        PrefabCacheMgr:Get():RecyclePrefab(self.AniObj)
    end
    self.AniObj = nil
    InviteDataManager:Get():SetIsInRecruit(false)
    if self._CinemachineBlendDefinitionStyle then
        CinemachineCameraHelper:SetCineMachineCameraActive(false)
        CinemachineCameraHelper:SwitchCineMachineCameraDefaultBland(self._CinemachineBlendDefinitionStyle,self._CinemachineBlendDefinitionStyleTime)
        self._CinemachineBlendDefinitionStyle=nil
    end
    CommonHelper:PlayScreenEffectWhite0to0(self.OnPlayEnd, self)

end

function RecruitViewAni1:OnPlayEnd()
    if self.EndFun then
        self.EndFun()
    end
end

function RecruitViewAni1:StopTimer()
    TimerManager:Get():StopTimer(self.timerId)
    self.timerId = -1
    CommonHelper:PlayScreenEffectWaiting(false)
end

function RecruitViewAni1:SkipAni()
    if self.aniEndTimerId ~= nil then
        TimerManager:Get():StopTimer(self.aniEndTimerId)
        self:PlayAniEnd()
        self.aniEndTimerId = nil
    end
end

--endregion




