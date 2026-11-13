---@class ARManager
ARManager = class("ARManager")


---@return ARManager
function ARManager:Get()
    if self.__instance == nil then
        self.__instance = ARManager()
    end
    return self.__instance
end


function ARManager:initialize()
    self.ARShow = nil
    self.ARPrefab = nil
    self.ARSession = nil
    self.cs_ARPlaceOnPlane = nil
    self.cs_ARCheckPlane = nil
    self.HitPose = nil
end

function ARManager:SetARComponent()
    local ARAsset = AssetsManager.Load("arobj.prefab", typeof(GameObject))
    self.ARShow = CommonHelper:InstantiateGameObjectByObject(ARAsset.asset)

    --self.cs_ARPlaceOnPlane = UIUtil.GetGameobjectComponent(self.ARShow, typeof(CS.ARPlaceOnPlane))
    --if self.cs_ARPlaceOnPlane == nil then
    --    self.cs_ARPlaceOnPlane = UIUtil:AddGameobjectComponent(self.ARShow, typeof(CS.ARPlaceOnPlane))
    --end

    self.cs_ARCheckPlane = UIUtil.GetGameobjectComponent(self.ARShow, typeof(CS.ARCheckPlane))
    if self.cs_ARCheckPlane == nil then
        self.cs_ARCheckPlane = UIUtil:AddGameobjectComponent(self.ARShow, typeof(CS.ARCheckPlane))
    end
end

function ARManager:SetARCarPrefab(carId)
    self.ARPrefab = CarBuilderManager:Get():GetCarRoot(carId)
end

---从CSharp传过来的交点
function ARManager:SetHitPose(_pose, _objRoot, _speed)
    self.HitPose = _pose
    
    self.ARPrefab.transform.localScale = Vector3(0.05,0.05,0.05)
    self.ARPrefab.transform.position = self.HitPose.position
    self.ARPrefab.transform.rotation = self.HitPose.rotation

    --HotfixHelper:SetParentGameObject(_objRoot, self.ARPrefab, true, true)

    --self.ARPrefab.transform:Parent(_objRoot.transform)

end

function ARManager:ResetARMainState()
    --回收ARPrefab
    self.ARPrefab.transform.position = Vector3(10000, 10000, 10000)

    --重置AR检测状态
    self.cs_ARCheckPlane:ResetARState()

end

function ARManager:EndARCar()
    GameObject.Destroy(self.ARShow)
    self.cs_ARCheckPlane:PauseARState()
    self.ARPrefab = nil
    self.ARSession = nil
    self.cs_ARCheckPlane = nil
    self.cs_ARPlaceOnPlane = nil
end


------------------------------👇👇👇👇👇👇new👇👇👇👇👇-------------------------
function ARManager:AREnter()
    self:SetSelfCarSign(true)

    self.ARAsset = AssetsManager.LoadAsync("arobj.prefab", typeof(GameObject))
    CommonHelper:PlayScreenEffectWhite(2,nil,nil,0.5)
    self.ARAsset:AddComplete(function(asset)
        if asset ~= nil and asset.asset ~= nil then
            self.ARShow = CommonHelper:InstantiateGameObjectByObject(asset.asset)
        end
        self.LuaProxy =GameObject("ARLuaProxyLifeCycle")
        local aRLuaProxyLifeCycle = UIUtil:AddGameobjectComponent(self.LuaProxy,typeof(CS.LuaProxy.ARLuaProxyLifeCycle))
        CSARManager.Get():StartARSession(self.ARShow,self,aRLuaProxyLifeCycle)
        self:ARFunctionBind()
        CSARManager.Get():SetFunctionOpen(CS.ARFunctionIsOpen.OnClickRayCast)
        --CSARManager.Get():StartARSession(self.ARShow,function(state)
        --    self:ARSessionStateChange(state)
        --end,function(pose)
        --    self:ARRayCastHitPose(pose)
        --end)
        CameraStackHelper:ARCameraEnter()
        self.ARPrefab = CarBuilderManager:Get():GetCarRoot(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
        self:LoadARExhibitCar()

        CommonHelper:CSGameObjectSetActive(self.ARPrefab,false)
    end)
    --self:Test()
end

function ARManager:Test()
    ARStateControl:Get():ChangeState(ARState.ARRunning)
end

function ARManager:SetSelfCarSign(selfCarSign)
    self.isSelfCar = selfCarSign
end

function ARManager:ISSelfCar()
    return  self.isSelfCar
end

function ARManager:ChangeCar()
    self.isSelfCar = not self.isSelfCar
    if ARStateControl:Get().curState~=nil then
        ARStateControl:Get():ChangeState(ARState.ARRunning)
        UINotify:Get():SendNotification(UINotifyEvent.ARState_Update)
    end
end

function ARManager:ARFunctionBind()
    CSARManager.Get():Bind(self.ARSessionStateChange,CSARManager.Get().OnSessionStateChangeHandler)
    CSARManager.Get():Bind(self.ARRayCastHitPose,CSARManager.Get().OnClickRayCastHandler)
end

function ARManager:ResetAR()
    CSARManager:Get():SetLastHit()
    CSARManager.Get():ResetAR()
    
end

function ARManager:LoadARExhibitCar()
    self.ARPrefabAsset = AssetsManager.LoadAsync("ARExhibit.prefab", typeof(GameObject))
    self.ARPrefabAsset:AddComplete(function(asset)
        if asset ~= nil and asset.asset ~= nil then
            self.ARExhibit = CommonHelper:InstantiateGameObjectByObject(asset.asset)
            CommonHelper:CSGameObjectSetActive(self.ARExhibit,false)
            local selfCar = CommonHelper:InstantiateGameObjectByObject(asset.asset)
            local center =  UIUtil.GetChild("center",self.ARPrefab)
            local deleteCenter =  UIUtil.GetChild("center",selfCar)
            local copyObj = CommonHelper:InstantiateGameObjectByObject(center)
            UIUtil.SetParentTransform(deleteCenter.transform.parent,copyObj,true)
            deleteCenter.transform.parent=nil
            GameObject.Destroy(deleteCenter)
            copyObj.name = "center"
            selfCar.name = "ARPrefab"
            local carController = UIUtil.GetTypeChildWightByParent("mesh_shell_beakspider_0",selfCar, typeof(CS.ARCarAnimController))
            carController:InitOrigTransInfo()
            CommonHelper:CSGameObjectSetActive(selfCar,false)
            self.ARPrefab = selfCar
        end
    end)
end

---@param ... CS.ARFunctionIsOpen
function ARManager:SetFunctionOpen(...)
    CSARManager.Get():SetFunctionOpen(...)
end

---@param type CS.ARFunctionIsOpen
---@param active 活跃
function ARManager:FunctionOpenUpdate(type,active)
    CSARManager.Get():FunctionOpenUpdate(type,active)
end

---@param state CS.UnityEngine.XR.ARFoundation.ARSessionState
function ARManager:ARSessionStateChange(state)
    if state~=CS.UnityEngine.XR.ARFoundation.ARSessionState.SessionTracking then
        if ARStateControl:Get().curState==nil then
            ARStateControl:Get():ChangeState(ARState.Ready)
            UINotify:Get():SendNotification(UINotifyEvent.ARState_Update)
        end
    else
        ARStateControl:Get():ChangeState(ARState.ARRunning)
        UINotify:Get():SendNotification(UINotifyEvent.ARState_Update)
    end

    if state == CS.UnityEngine.XR.ARFoundation.ARSessionState.Unsupported or state == CS.UnityEngine.XR.ARFoundation.ARSessionState.NeedsInstall then
        local boxfunc = function()
            local title = CommonHelper:GetTempStr_Default(TemplateStringID.ARTipTitle)
            local content=""
            local okName
            if state == CS.UnityEngine.XR.ARFoundation.ARSessionState.Unsupported then
               content= CommonHelper:GetTempStr_Default(TemplateStringID.ARTipTitleUnsupported)
            end
            if state == CS.UnityEngine.XR.ARFoundation.ARSessionState.NeedsInstall  then
                if  HotfixHelper:IsAndroidPlatform() then
                    okName = CommonHelper:GetTempStr_Default(TemplateStringID.ARTipTitleCopyBtn)
                    content = CommonHelper:GetTempStr_Default(TemplateStringID.ARTipTitleUnsupportedToLoad)
                else
                    content= CommonHelper:GetTempStr_Default(TemplateStringID.ARTipTitleNeedsInstall)
                end
            end
            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,content , title, okName, nil, true, false, true)
            if ret == MessageBoxHelp.BtnType.OK then
                if  HotfixHelper:IsAndroidPlatform()  then
                    CommonHelper:WriteClipboart(CommonHelper:GetTempStr_Default(TemplateStringID.ARPluginName))
                end
            end
            UIManager:Get():CloseView()
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end
end

function ARManager:ARRayCastHitPose(pose)
    if pose==nil then
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.AROnClickUnCheckPanel))
    else
        if self:ISSelfCar() then
            ARStateControl:Get():ChangeState(ARState.CarOperating,self.ARPrefab)
        else
            ARStateControl:Get():ChangeState(ARState.CarOperating,self.ARExhibit)
        end
        ARStateControl:Get():ChangeSubState(ARSubState.CarOperating_CarMove,pose)
        UINotify:Get():SendNotification(UINotifyEvent.ARState_Update)
    end

end

--CS.UnityEngine.XR.ARSubsystems.PlaneDetectionMode
function ARManager:SetPlaneDetectionMode(mode)
    CSARManager.Get():SetPlaneDetectionMode(mode)
end

function ARManager:ARExit()
    CameraStackHelper:ARCameraExit()
    GameObject.Destroy(self.ARShow)
    GameObject.Destroy(self.LuaProxy)
    AssetsManager.Unload(self.ARAsset)
    ARStateControl:Get():ClearState()
    GameObject.Destroy(self.ARExhibit)
    AssetsManager.Unload(self.ARPrefabAsset)
    CSARManager.Get():QuitARSession()
end