local _ref = 0
---@class RecruitViewAni : ViewBase
RecruitViewAni = class("RecruitViewAni")

function RecruitViewAni:initialize()
    self:CacheRecruitViewAniData()
end

function RecruitViewAni:CacheRecruitViewAniData()
    self.AniObj = nil

    self.BuildIds = {}
    self.CarCount = 0
    self.FinishMsg = nil

    self.isAdvance = false--是否是高级特效

    self.btnClickTimerId = nil
    self.EndFun=nil
end

---@param msg SC_UserRecruit
function RecruitViewAni:Begin(CarType,CarCount,isAdvance,endFun)
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

    for i = 1, self.CarCount do
        if RecruitDataManager:Get().CarDic[cars[i]] then
            local parentName = self.CarCount == 2 and string.format("car%d_socket/car_rotate", i) or string.format("path%d/car_rotate", i)
            local parent = UIUtil.GetChild(parentName, self.AniObj)
            local car=  CarBuilderManager:Get():GetCarRoot(RecruitDataManager:Get().CarDic[cars[i]])
            CommonHelper:CSGameObjectSetActive(car,true)
            UIUtil.SetParentGameObject(parent,car,true)
            self:LoadCarFinish()
        else
            local param = CarBuilderParam()
            param.tableID = cars[i]
            param.buildType = CarBuilderType.Table
            param.combineType = CombineType.OnceVertexBaker
            param.lightweight = {true,true,true,true,true}
            param.grids = {0,0,0,0,0}
            param.colorid = 0
            param.stickerid = 0

            local parentName = self.CarCount == 2 and string.format("car%d_socket/car_rotate", i) or string.format("path%d/car_rotate", i)
            param.parent = UIUtil.GetChild(parentName, self.AniObj)

            param.finishEvt = function(obj)
                self:LoadCarFinish()
            end
            local buildId = CarBuilderManager:Get():BuildCar(param)
            RecruitDataManager:Get().CarDic[cars[i]]= buildId
        end
    end
end




function RecruitViewAni:OnClose()

    RecruitDataManager:Get():ReleaseCar()

    if self.AniObj then
        PrefabCacheMgr:Get():RecyclePrefab(self.AniObj)
    end
    self.AniObj = nil
end


--region 抽奖确认之后的播放加载车辆的动画
function RecruitViewAni:BeginWaitingTimer()
    self:StopTimer()
    self.timerId = TimerManager:Get():CreateTimer(5, function(class)
        self:StopTimer()
        print("---   error:recruit overtime... ")
    end)
    CommonHelper:PlayScreenEffectWaiting(true)
end


---@param msg SC_UserRecruit
function RecruitViewAni:GetAniObj(CarCount,isAdvance)
    local aniObj = nil
    if CarCount==LotteryType.One then
        aniObj = PrefabCacheMgr:Get():SwapPrefab(isAdvance == true and RecruitAniName_TwoAdvance or RecruitAniName_TwoNormal)
    else
        aniObj = PrefabCacheMgr:Get():SwapPrefab(isAdvance == true and RecruitAniName_TenAdvance or RecruitAniName_TenNormal)
    end
    self.isAdvance = isAdvance
    return aniObj
end

function RecruitViewAni:LoadCarFinish()

    _ref = _ref + 1
    --
    if _ref == self.CarCount then
        _ref = 0
        self:PlayAni(self.CarCount)
    end
end

function RecruitViewAni:PlayAni(count)

    UIManager:Get():OpenView("RecruitSkipView", CanvasType.MainCanvas, "RecruitSkipView")

    self:StopTimer()


    self:SetCamera(count)

    --local time = count == 2 and 3.5 or 4.2

    local time = 0
    if count == 2 then
        time = self.isAdvance == true and 15.03 or 13.25
    else
        time = self.isAdvance == true and 14.3 or 13.2
    end

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

function RecruitViewAni:SetCamera(count)
    local temp = UIUtil.GetChild("cam_shake", self.AniObj)

    HomeSceneHelper:SetCameraRecruitAni(temp)

    local fxCom = UIUtil.GetGameobjectComponent(self.AniObj, typeof(CS.Horizon.Game.ShowLayer.FXFollowCamera))
    if fxCom then
        fxCom:SetCameraRoot(UIUtil.GetChild("cam_shake", self.AniObj))
    end
end

function RecruitViewAni:PlayAniEnd()

    AudioManager:PauseBGM()
    --CommonHelper:SetGameObjectSctive("animation_cj_01", self.AniObj, false)
    --CommonHelper:SetGameObjectSctive("animation_cj_02", self.AniObj, false)

    CommonHelper:CSGameObjectSetActive(self.AniObj, false)

    if self.AniObj then
        PrefabCacheMgr:Get():RecyclePrefab(self.AniObj)
    end
    self.AniObj = nil

    InviteDataManager:Get():SetIsInRecruit(false)
    CommonHelper:PlayScreenEffectWhite0to0(self.OnPlayEnd, self)

end

function RecruitViewAni:OnPlayEnd()
    if self.EndFun then
        self.EndFun()
    end
end

function RecruitViewAni:StopTimer()
    TimerManager:Get():StopTimer(self.timerId)
    self.timerId = -1
    CommonHelper:PlayScreenEffectWaiting(false)
end

function RecruitViewAni:SkipAni()
    if self.aniEndTimerId ~= nil then
        TimerManager:Get():StopTimer(self.aniEndTimerId)
        self:PlayAniEnd()
        self.aniEndTimerId = nil
    end
end

--endregion




