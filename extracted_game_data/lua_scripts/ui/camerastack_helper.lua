



---@class CameraStackHelper
CameraStackHelper = class("CameraStackHelper")
local _CurPort=nil
---@param id SceneChangeID
function CameraStackHelper:SetCamera(id, port)
    _CurPort= port
    ---@type scenechange_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scenechange_config, id)
    if cfg then
        log("---   SetCamera()   id = ", id, "fitenable = ", cfg.fitenable, "port = ", port)
        if cfg.fitenable == 0 and cfg.cameraparammax ~= "-1" and cfg.cameraparammin ~= "-1" then
            CameraStackHelper:SetCameraNoFit(cfg)
        end

        if cfg.fitenable == 1 then
            CameraStackHelper:SetCameraFitUI(cfg, port)
        end
    end
end



--{{{ 切换相机(单basecamera)
---@param cfg scenechange_config_cell
function CameraStackHelper:SetCameraNoFit(cfg)
    if cfg then
        local root = CommonHelper:GetRootObjectExactMath(cfg.cameraroot)
        if root then
            local rootpos = root.transform.position
            local rootrot = root.transform.eulerAngles
            local fov = cfg.NewMaxFov
            local fitfov = cfg.NewMinFov

            local pos = Vector3(rootpos.x + cfg.NewMaxPosX ,rootpos.y + cfg.NewMaxPosY, rootpos.z + cfg.NewMaxPosZ)
            local fitpos = Vector3(rootpos.x + cfg.NewMinPosX ,rootpos.y + cfg.NewMinPosY, rootpos.z + cfg.NewMinPosZ)

            local rot = Vector3(rootrot.x + cfg.NewMaxRotX ,rootrot.y + cfg.NewMaxRotY, rootrot.z + cfg.NewMaxRotZ)
            local fitrot = Vector3(rootrot.x + cfg.NewMinRotX ,rootrot.y + cfg.NewMinRotY, rootrot.z + cfg.NewMinRotZ)

            CSCameraStackManager.Get():SwitchGroup_NoFitCamera(cfg.id, fov, pos, rot, fitfov, fitpos, fitrot)
        end
    end
end
--}}}

--{{{切换相机(单basecamera, ui适配模式)
---@param cfg scenechange_config_cell
function CameraStackHelper:SetCameraFitUI(cfg, port)
    if cfg and port then
        if cfg.fitenable == 1 then
            local root = CommonHelper:GetRootObjectExactMath(cfg.cameraroot)
            if root then
                local rootpos = root.transform.position
                local rootrot = root.transform.eulerAngles
                local fov = cfg.NewFitFov
                local pos = Vector3(rootpos.x, rootpos.y, rootpos.z)
                local rot = Vector3(rootrot.x, rootrot.y, rootrot.z)
                CSCameraStackManager.Get():SwitchGroup_FitUI(cfg.id, fov, pos, rot, port)
            end
        end
    end
end
--}}}

--{{{ UI默认镜头
function CameraStackHelper:SetUIDefaultGroup()
    CSCameraStackManager.Get():SwitchUIDefaultGroup()
end
--}}}
--{{{ 主界面默认相机
function CameraStackHelper:SetMainScene_CameraData()
    CSCameraStackManager.Get():SetMainScene_CameraData()
end
--}}}

--{{{ 赛道预览
function CameraStackHelper:SwitchTrackReview(position,rotation,lengthDistance)
    CSCameraStackManager.Get():SwitchTrackReview(position or Vector3.zero,rotation or Vector3(45,-66,0),lengthDistance or 70)
end
--}}}
--{{{ 赛道预览
function CameraStackHelper:SwitchTrackEditor()
    CSCameraStackManager.Get():SwitchTrackEditor()
end
--}}}
--{{{ 赛道预览
function CameraStackHelper:SwitchMainCity()
    CSCameraStackManager.Get():SwitchMainCity()
end
--}}}
local _GarageCameraManager=nil
local _GarageCameraOpen=false
local _GarageCameraType=-1
---@param cfg scenechange_config_cell
function CameraStackHelper:EnableGarageCamera(id)
    if id==nil then id=_GarageCameraType  end
    if id==nil then id=GarageCameraId.Default  end
    ---@type scenechange_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scenechange_config, id)
    if cfg and _GarageCameraOpen==false then
        _GarageCameraType=id
        local root = CommonHelper:GetRootObjectExactMath(cfg.cameraroot)
        _GarageCameraManager = UIUtil.GetGameobjectComponent(root, typeof(GarageCameraManager))
        if _GarageCameraManager then
            _GarageCameraManager:SetCameraEnable(true,root)
            MonoHelper:TurnOnOutline()
            _GarageCameraManager:SetCamera(GarageCameraId.Default)
        end
        _GarageCameraOpen=true
    end
end

function CameraStackHelper:GarageCameraSwitch(id)
    if _GarageCameraManager then
        _GarageCameraType=id
        _GarageCameraManager:SetCamera(id)
    end
end
function CameraStackHelper:GarageCameraClose()
    if _GarageCameraManager and _GarageCameraOpen==true then
        MonoHelper:TurnOffOutline()
        _GarageCameraManager:SetCameraEnable(false,nil)
        _GarageCameraOpen=false
    end
end

--}}}








--{{{ 赛道预览场景镜头、赛道编辑场景镜头
function CameraStackHelper:SetTrackScene()
    CSCameraStackManager.Get():SwitchRaceRoom_TrackInfo()
end
--}}}

--{{{  赛道镜头重置
function CameraStackHelper:RestoreTrackScene(disableComponent)
    if disableComponent==nil then disableComponent=true end
    CSCameraStackManager.Get():RestoreTrackCamera(disableComponent)
end
--}}}

--{{{  主场景进入
function CameraStackHelper:MainSceneEnter()
    CSCameraManager.Get().isPause=false
    CSCameraManager.Get():AddCinemaSlot(OperationCameraConfig.MainScene)
    CinemachineCameraHelper:SetCineMachineCameraActive(true)
end
--}}}

--{{{  主场景退出
function CameraStackHelper:MainSceneExit()
    CSCameraManager.Get():ClearAllSlot()
end
--}}}

--{{{  私人家园进入
local CacheClearFlags
function CameraStackHelper:PersonalHomeEnter()
    CSCameraManager.Get().isPause=false
    CSCameraManager.Get():AddCinemaSlot(OperationCameraConfig.PersonalHome)
    CinemachineCameraHelper:PersonalHomeEnter(self:AddFinallyRenderCamera())
end
---}}}

--{{{  私人家园退出
function CameraStackHelper:PersonalHomeExit()
    if CacheClearFlags then
        CSCameraManager.Get():ClearAllSlot()
        CinemachineCameraHelper:PersonalHomeExit()
        self:SetUIDefaultGroup()
        local mainCamera = CSCameraManager.Get()._MainCamera
        mainCamera.nearClipPlane=0.1
        mainCamera.farClipPlane=2000
        mainCamera.clearFlags=CacheClearFlags
        local cameraData = CSCameraExtensions.GetUniversalAdditionalCameraData(mainCamera)
        cameraData.renderPostProcessing=true
        CacheClearFlags=nil
    end

end
--}}}

--{{{  添加顶层渲染相机
function CameraStackHelper:AddFinallyRenderCamera()
    local mainCamera = CSCameraManager.Get()._MainCamera
    CacheClearFlags = mainCamera.clearFlags
    mainCamera.clearFlags = CS.UnityEngine.CameraClearFlags.Skybox;
    local cameraData = CSCameraExtensions.GetUniversalAdditionalCameraData(mainCamera)
    cameraData.renderType = CameraRenderType.Base
    cameraData.renderPostProcessing=false
    local finallyRenderCamera =CSCinemachineCameraManager.Get().finallyRenderCamera
    if GameObjectIsNull(finallyRenderCamera) then
        finallyRenderCamera = GameObject("FinallyRenderCamera"):AddComponent(typeof(Camera))
        finallyRenderCamera.gameObject:AddComponent(typeof(CSCinemachineBrain))
        CS.UIUtil.SetParentAndReset(finallyRenderCamera.transform,mainCamera.transform)
    end
    local finallyRenderCameraData = CSCameraExtensions.GetUniversalAdditionalCameraData(finallyRenderCamera)
    finallyRenderCameraData.renderType = CameraRenderType.Overlay
    finallyRenderCameraData.renderPostProcessing=true
    finallyRenderCamera.cullingMask = 1 <<  CS.UnityEngine.LayerMask.NameToLayer("PriorityRender")
    cameraData.cameraStack:Add(finallyRenderCamera)
    return finallyRenderCamera
end
--}}}

--{{{  ARCamera设置
function CameraStackHelper:ARCameraEnter()
    local arCamera = CSARManager.Get().ARSessionOrigin.camera
    local cameraData = CSCameraExtensions.GetUniversalAdditionalCameraData(arCamera)
    cameraData.renderType = CameraRenderType.Base
    local uiCamera =CSCameraManager.Get()._UICamera
    cameraData.cameraStack:Add(uiCamera)
    CommonHelper:CSGameObjectSetActive( CSCameraManager.Get()._MainCamera.gameObject,false)
end

function CameraStackHelper:ARCameraExit()
    CommonHelper:CSGameObjectSetActive( CSCameraManager.Get()._MainCamera.gameObject,true)
end
function CameraStackHelper:GetCurPort()
   return _CurPort
end


--}}}

























----{{{ 选车镜头
--function CameraStackHelper:SetSelectCar()
--    CSCameraStackManager.Get():SwitchGarageGroup_SelectCar(CommonHelper:GetRootObjectExactMath(SceneHome_CameraGroup_Select))
--end
----}}}


----{{{ 车库镜头
--function CameraStackHelper:SetGarage()
--    CSCameraStackManager.Get():SwitchGarageGroup_Blue(CommonHelper:GetRootObjectExactMath(SceneHome_CameraGroup_Garage_Blue))
--end
----}}}

----{{{ 车库左侧镜头
--function CameraStackHelper:SetGarageLeft()
--    CSCameraStackManager.Get():SwitchGarageGroup_SelectCar(CommonHelper:GetRootObjectExactMath(SceneHome_CameraGroup_GarageLeft))
--end
----}}}

----{{{ 抽奖动画镜头
--function CameraStackHelper:SetRecruitAni(obj) --
--    if obj then -- 动画特效的obj
--        CSCameraStackManager.Get():SwitchRecruitGroup_Ani(UIUtil.GetChild("camera_root", obj))
--    end
--end
----}}}


----{{{ 房间赛镜头
--function CameraStackHelper:SetRaceRoom(obj) --
--    CSCameraStackManager.Get():SwitchGarageGroup_RaceRoom(CommonHelper:GetRootObjectExactMath(SceneHome_CameraGroup_RaceRoom))
--end
----}}}


----{{{ 返回上一个镜头
--function CameraStackHelper:SetLastGroup()
--    CSCameraStackManager.Get():SwitchLastGroup()
--end
----}}}