local _ref = 0
---@class RecruitViewAni2 : ViewBase
RecruitViewAni2 = class("RecruitViewAni2")

function RecruitViewAni2:initialize()
    self:CacheRecruitViewAniData()
end

function RecruitViewAni2:CacheRecruitViewAniData()
    self.AniObj = nil

    self.BuildIds = {}
    self.CarCount = 0
    self.FinishMsg = nil

    self.isAdvance = false--是否是高级特效

    self.btnClickTimerId = nil
    self.EndFun=nil
end

---@param msg SC_UserRecruit
function RecruitViewAni2:Begin(CarType,CarCount,isAdvance,endFun)
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
    local childName=self.CarCount==2 and "animation_cj_02" or "animation_cj_01"
    local startCarRootId=self.CarCount==2 and 5 or 0
    self.CjAni= UIUtil.GetChildInputPath(childName,self.AniObj)
    self.CarId={}
    for i = 1, self.CarCount do
        if self.CarCount==2 then
            local parentName = string.format("anim_car_0%d", startCarRootId+i)
            local parent = UIUtil.GetChildInputPath(parentName, self.CjAni)
            CommonHelper:SetGameObjectActive("mesh_shell_gold",parent,CarType==LotteryCarType.Normal)
            CommonHelper:SetGameObjectActive("mesh_shell_dam",parent,CarType~=LotteryCarType.Normal)
        end
        self:LoadCarFinish()
    end
end




function RecruitViewAni2:OnClose()

    RecruitDataManager:Get():ReleaseCar()

    if self.AniObj then
        PrefabCacheMgr:Get():RecyclePrefab(self.AniObj)
    end
    self.AniObj = nil
end


--region 抽奖确认之后的播放加载车辆的动画
function RecruitViewAni2:BeginWaitingTimer()
    self:StopTimer()
    self.timerId = TimerManager:Get():CreateTimer(5, function(class)
        self:StopTimer()
        print("---   error:recruit overtime... ")
    end)
    CommonHelper:PlayScreenEffectWaiting(true)
end


---@param msg SC_UserRecruit
function RecruitViewAni2:GetAniObj(CarCount,isAdvance)
    local aniObj = nil
    aniObj = PrefabCacheMgr:Get():SwapPrefab(RecruitAniName)
    for i = 1, 4 do
        CommonHelper:SetGameObjectActive(string.format("animation_cj_0%d",i),aniObj,false)
    end
    self.isAdvance = isAdvance
    CommonHelper:SetGameObjectActive("sudupianjiang",aniObj,self.isAdvance)
    CommonHelper:SetGameObjectActive("sudupian1",aniObj,not self.isAdvance)
    return aniObj
end

function RecruitViewAni2:LoadCarFinish()

    _ref = _ref + 1
    --
    if _ref == self.CarCount then
        _ref = 0
        self:PlayAni(self.CarCount)
    end
end

function RecruitViewAni2:PlayAni(count)

    UIManager:Get():OpenView("RecruitSkipView", CanvasType.MainCanvas, "RecruitSkipView")

    self:StopTimer()


    self:SetCamera(count)

    --local time = count == 2 and 3.5 or 4.2

    local time = 0
    if count == 2 then
        time = 3.5
    else
        time = 4.2
    end
    local temp = UIUtil.GetChildInputPath("animation_cj_01", self.AniObj)
    temp:SetActive(count == 5)
    temp = UIUtil.GetChildInputPath("animation_cj_02", self.AniObj)
    temp:SetActive(count == 2)
    if self.aniEndTimerId ~= nil then
        TimerManager:Get():StopTimer(self.aniEndTimerId)
        self.aniEndTimerId = nil
    end
    self.aniEndTimerId = TimerManager:Get():CreateTimer(time, function()
        self:PlayAniEnd()
        TimerManager:Get():StopTimer(self.aniEndTimerId)
        self.aniEndTimerId = nil
    end)
    AudioManager:PlayBGM("bgm_battle_01.mp3")
end

function RecruitViewAni2:SetCamera(count)
    local temp = UIUtil.GetChildInputPath("camera_root", self.CjAni)

    HomeSceneHelper:SetCameraRecruitAni(temp)
    if temp==nil then
        print("摄像机点为nui")
    end
    local fxCom = UIUtil.GetGameobjectComponent(temp, typeof(CS.Horizon.Game.ShowLayer.FXFollowCamera))
    if fxCom then
        fxCom:SetCameraRoot(temp)
    end
end

function RecruitViewAni2:PlayAniEnd()

    AudioManager:PauseBGM()
    --CommonHelper:SetGameObjectSctive("animation_cj_01", self.AniObj, false)
    --CommonHelper:SetGameObjectSctive("animation_cj_02", self.AniObj, false)

    CommonHelper:CSGameObjectSetActive(self.AniObj, false)
    self:RecyclePrefabCar()
    if self.AniObj then
        PrefabCacheMgr:Get():RecyclePrefab(self.AniObj)
    end
    self.AniObj = nil

    InviteDataManager:Get():SetIsInRecruit(false)
    CommonHelper:PlayScreenEffectWhite0to0(self.OnPlayEnd, self)

end


function RecruitViewAni2:RecyclePrefabCar()
    for i = 1, #self.CarId do
        local car=  CarBuilderManager:Get():GetCarRoot(self.CarId[i])
        CommonHelper:CSGameObjectSetActive(car,false)
    end
end

function RecruitViewAni2:OnPlayEnd()
    if self.EndFun then
        self.EndFun()
    end
end

function RecruitViewAni2:StopTimer()
    TimerManager:Get():StopTimer(self.timerId)
    self.timerId = -1
    CommonHelper:PlayScreenEffectWaiting(false)
end

function RecruitViewAni2:SkipAni()
    if self.aniEndTimerId ~= nil then
        TimerManager:Get():StopTimer(self.aniEndTimerId)
        self:PlayAniEnd()
        self.aniEndTimerId = nil
    end
end

--endregion




