local LastMainCityScene=-1
local SceneUnloadTime=CS.UnityEngine.WaitForSeconds(10)
---@class SceneHomeManager
SceneHomeManager = class("SceneHomeManager")
function SceneHomeManager:initialize()
    self.PreDict = {}
    self.PreAssetDict = {}
    self.PreUnloadAssetDict = {}
    self.skyboxDict = {}
    self.cubemapDict ={}
end
function SceneHomeManager:Get()
    if self._instance == nil then
        self._instance = SceneHomeManager()
    end
    return self._instance
end
function SceneHomeManager:OnInit()
    if self.Root == nil then
        self.Root = GameObject.Find("SceneHomeRoot")
        if self.Root == nil then
            self.Root = GameObject("SceneHomeRoot")
            GameObject.DontDestroyOnLoad(self.Root)
        end
    else
        return
    end
    self:SetMainCitySceneValue()
    self.MainCityScene=MainCitySceneValue
    self:LoadMainScenePrefab()
    self:LoadScenePrefab()
    self:LoadAwake2D()
end
function SceneHomeManager:SetMainCitySceneValue()
   local nowTime=CommonHelper:GetNowTime()
    if nowTime.Hour>=18 or nowTime.Hour<=6 then
        MainCitySceneValue=SceneChangeID.MainCity_New
        self.MainCityType=SceneHomeLoadType.White
    else
        MainCitySceneValue=SceneChangeID.MainCity_New
        self.MainCityType=SceneHomeLoadType.Night
    end
    if self.PreDict[MainCitySceneValue] == nil or self.PreDict[MainCitySceneValue] == -1 then
        self:SwapPrefabPrefab(MainCitySceneValue)
    end
    if GameProperties.AreaType == AreaType.AreaTypeDNY and GameProperties.isTs then
        MainCitySceneValue=SceneChangeID.MainCity
    end
end
function SceneHomeManager:LoadAwake2D()
    --if self.Awake2D~=nil then
    --    return
    --end
    --local root= GameObject.Find("TopCanvas");
    --self.Awake2D=GameObject("Awake2D1111")
    --UIUtil.SetParentGameObject(root,self.Awake2D,false, false)
    --self.Awake2D:AddComponent(typeof(RawImage))
    --local boxcollider2d= self.Awake2D:AddComponent(typeof(CS.UnityEngine.BoxCollider2D))
    --local rigidbody2D=  self.Awake2D:AddComponent(typeof(CS.UnityEngine.Rigidbody2D))
    --boxcollider2d.size=Vector2(452.08,221.1566)
    --boxcollider2d.offset=Vector2(-3.089478,-18.53894)
    --boxcollider2d.isTrigger=true
    --rigidbody2D.bodyType=1
    --self.Awake2D:AddComponent(typeof(Collision2D))
    --self.Awake2D.transform:LocalPosition(Vector3(-700,-484,0))
end
function SceneHomeManager:IsMainCityLoading()
    return self.PreDict[self.MainCityScene] == -1
end
function SceneHomeManager:AllScreenLoading()
    for k, v in pairs(self.PreDict) do
        if self.PreDict[k]==-1 then
            return true
        end
    end
    return false
end
function SceneHomeManager:IsFistLoginLoading()
    local flag=self.PreDict[self.MainCityScene] == -1
    if not flag then
        for k, v in pairs(self.PreDict) do
          local cfg= CommonHelper:GetTableDataByID(ConfigNames.scenechange_config,k)
            if cfg.loginLoad==1 and self.PreDict[k]==-1 then
                flag= true
                break
            end
        end
    end
    return flag
end


function SceneHomeManager:ScreenCount()
    local count=0
    for k, v in pairs(self.PreDict) do
        if self.PreDict[k]~=-1 then
            count=count+1
        end
    end
    return 1
end



function SceneHomeManager:AddPrefab(type,obj)
    self.PreDict[type] = obj
    if self.PreDict[type] then
        self.PreDict[type]:SetActive(false)
        UIUtil.SetParentGameObject(self.Root, obj)
    else
        logError("这个场景没有",type)
    end
end
function SceneHomeManager:RecycleScenePrefab()
    for k, v in pairs(self.PreDict) do
        if v~=-1 and v~=1 then
            v:SetActive(false)
            UIUtil.SetParentGameObject(self.Root, v)
        end
    end
end

function SceneHomeManager:Clear()
    for k, v in pairs(self.PreDict) do
        PrefabCacheMgr:Get():RecyclePrefab(v)
    end
    self.PreDict = {}
end
function SceneHomeManager:GetCurScene()
     return self.CurType
end


function SceneHomeManager:LoadMainScenePrefab()
    -----@type scenechange_config
    --local tab = CommonHelper:GetTableDataByID(ConfigNames.scenechange_config,self.MainCityScene)
    --if tab then
    --    if self.PreDict[self.MainCityScene] == nil or self.PreDict[self.MainCityScene] == -1 then
    --        self.PreDict[self.MainCityScene] = -1
    --        PrefabCacheMgr:Get():SwapPrefabAsync(tab.scenename, nil, nil, function(param, obj)
    --            self:AddPrefab(self.MainCityScene,obj)
    --        end)
    --    end
    --end
end
function SceneHomeManager:SwapPrefabPrefab(id)
     local tab =CommonHelper:GetTableDataByID(ConfigNames.scenechange_config,id)
    if (self.PreAssetDict[id]==nil or self.PreAssetDict[id]==-1) and tab  then
        self.PreAssetDict[id] = AssetsManager.Load(tab.scenename, typeof(GameObject))
        self:AddPrefab(id,CommonHelper:InstantiateGameObjectByObject(self.PreAssetDict[id].asset))
    end
end
function SceneHomeManager:UnLoadPrefabPrefab(id)
    if self.PreDict[id] and self.PreDict[id]~=-1 then
        self.PreDict[id]:SetActive(false)
        self.PreUnloadAssetDict[id]={}
        self.PreUnloadAssetDict[id].flag=true
        self.PreUnloadAssetDict[id].coroutine= cs_coroutine.start(function()
            coroutine.yield(SceneUnloadTime)
            if self.PreUnloadAssetDict[id] and self.PreUnloadAssetDict[id].flag then
                GameObject.Destroy(self.PreDict[id])
                AssetsManager.Unload(self.PreAssetDict[id])
                self.PreDict[id]=-1
                self.PreAssetDict[id]=-1
            end
            self.PreUnloadAssetDict[id]=nil
        end)
    end
end


function SceneHomeManager:LoadScenePrefab()
    self.Count=0
    ---@type scenechange_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.scenechange_config)
    if tab then
        local cfglist = tab.GetConfigData()
        for k, v in pairs(cfglist) do
            local id=v.C_ID
            self.Count=self.Count+1
            if self.PreDict[id] == nil or self.PreDict[id] == -1 then
                if v.scenename=="-1" then
                    self.PreDict[id] = 1
                else
                    self.PreDict[id] = -1
                    if v.loginLoad==SceneHomeLoadType.Advance then
                        self:SwapPrefabPrefab(id)
                    end
                end
            end
        end
    end
end


function SceneHomeManager:ChangeScene(type)
    if self.PreDict then
        ---@type scenechange_config_cell
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.scenechange_config,type)
        if cfg then
            local temp = CommonHelper:GetRootObjectExactMath(cfg.sceneroot)
            ---@type scenechange_config
            local tab = ClientDataManager:Get():GetDataTable(ConfigNames.scenechange_config)
            if tab then
                ---@type scenechange_config_cell[]
                local cfglist = tab.GetConfigData()
                for k, v in pairs(cfglist) do
                    local id=v.C_ID
                    if  type == id then
                        if v.scenename~="-1" then
                            if self.PreDict[id]==nil  or self.PreDict[id] == -1 then
                                self:SwapPrefabPrefab(id)
                            else
                                if self.PreUnloadAssetDict[id] then
                                    self.PreUnloadAssetDict[id].flag=false
                                    cs_coroutine.stop(self.PreUnloadAssetDict[id])
                                end
                            end
                            self.CurType=type
                            self.PreDict[id]:SetActive(true)
                            UIUtil.SetParentGameObject(temp, self.PreDict[id])
                            UIUtil.SetParentGameObject(self.Root, self.PreDict[id],false)
                        else
                            self.PreDict[id]=1
                        end
                    else
                        if v.loginLoad==SceneHomeLoadType.Advance or id==MainCitySceneValue then
                            if self.PreDict[id]~=nil  and self.PreDict[id] ~= -1 and self.PreDict[id] ~= 1 then
                                if self.PreDict[id] and not CommonHelper:GameObjectIsNull(self.PreDict[id]) then
                                    self.PreDict[id]:SetActive(false)
                                    UIUtil.SetParentGameObject(self.Root, self.PreDict[id])
                                end
                            end
                        else
                            if self.PreDict[id]~=nil  and self.PreDict[id] ~= -1 and self.PreDict[id]~=1 then
                                self:UnLoadPrefabPrefab(id)
                            end
                        end
                    end
                end
            end
            local sceneMat=cfg.skybox
            if sceneMat~="-1" then
                if  self.skyboxDict[sceneMat]==nil then
                    local Asset=AssetsManager.Load(string.format("%s.mat",sceneMat), typeof(Material))
                    self.skyboxDict[sceneMat]=CommonHelper:InstantiateMaterialByObject(Asset.asset)
                end
                CSRenderSettings.skybox= self.skyboxDict[sceneMat]
            else
                if  self.skyboxDict[sceneMat]==nil then
                    local Asset=AssetsManager.Load(string.format("scn_home_bundle_skybox_02.mat"), typeof(Material))
                    self.skyboxDict[sceneMat]=CommonHelper:InstantiateMaterialByObject(Asset.asset)
                end
                CSRenderSettings.skybox= self.skyboxDict[sceneMat]
            end
            local  configcubemap =cfg.cubemap
            if configcubemap ~="-1" then
                if configcubemap ~="none" and self.cubemapDict[configcubemap]==nil  then
                    local Asset=AssetsManager.Load(string.format("%s.exr",configcubemap), typeof(CSCubemap))
                    self.cubemapDict[configcubemap] = CommonHelper:InstantiateCubemapByObject(Asset.asset)
                end
                if self.cubemapDict[configcubemap]==nil  then
                    CSRenderSettings.defaultReflectionMode = CS.UnityEngine.Rendering.DefaultReflectionMode.Skybox
                    log("  DefaultReflectionMode.Skybox  ",configcubemap)
                else
                    CSRenderSettings.defaultReflectionMode = CS.UnityEngine.Rendering.DefaultReflectionMode.Custom
                    log("  DefaultReflectionMode.Custom  ",self.cubemapDict[configcubemap].name)
                end
               -- CSRenderSettings.customReflection =self.cubemapDict[configcubemap]
            end
            local  configcolor =cfg.environmenthdrcolor
            if configcolor~= "-1" then
                local hdrColor= stringSplitToNumber(configcolor,',')
                log("  ambientLight -------------  config   ",configcolor)
                if #hdrColor>3 then
                    --local m,_ = math.modf(hdrColor[4])
                    local indensity = 2 ^  hdrColor[4]  --math.pow(2,hdrColor[3])) 5.3lua  用 ^ 替代了 math.pow
                    local color = Color(hdrColor[1]/255,hdrColor[2]/255,hdrColor[3]/255,1)
                    local ambientLight = Color(color.r *indensity, color.g*indensity, color.b*indensity)
                    CSRenderSettings.ambientLight =ambientLight
                    CSRenderSettings.ambientMode = CS.UnityEngine.Rendering.AmbientMode.Flat
                    log("  ambientLight ------------- ",ambientLight)
                end
            end

            local  configgradient =cfg.environmentgradient
            if configgradient~= "-1" then
                CSRenderSettings.ambientMode = CS.UnityEngine.Rendering.AmbientMode.Trilight  -- Skybox：Skybox --Trilight：Gradient --Flat：Color --Custom：自定义的cubemap
                if configgradient ~= "default" then
                    local hdrColor= stringSplitToNumber(configgradient,',')
                    if #hdrColor>11 then
                        local indensity1 = 2 ^  hdrColor[4]
                        local indensity2 = 2 ^  hdrColor[8]
                        local indensity3= 2 ^  hdrColor[12]
                        CSRenderSettings.ambientSkyColor = Color(hdrColor[1]/255 *indensity1, hdrColor[2]/255*indensity1, hdrColor[3]/255*indensity1)
                        CSRenderSettings.ambientEquatorColor = Color(hdrColor[5]/255 *indensity2, hdrColor[6]/255*indensity2, hdrColor[7]/255*indensity2)
                        CSRenderSettings.ambientGroundColor = Color(hdrColor[9]/255 *indensity3, hdrColor[10]/255*indensity3, hdrColor[11]/255*indensity3)
                    end
                end
            end
            CS.UnityEngine.DynamicGI.UpdateEnvironment();
        end
    end
end


function SceneHomeManager:GetScenePrefab(type,loadflag)
    if self.PreDict then
        if loadflag then
            self:SwapPrefabPrefab(type)
        end
        return self.PreDict[type]
    end
    return nil
end



