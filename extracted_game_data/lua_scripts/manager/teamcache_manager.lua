

--整车缓存管理器，carbuildermanager之上的缓存
--1.缓存车位上的所有车（可以根据策略减少缓存数量）
--2.缓存的车，进入车库后合批解开，进战斗后使用贴图合批，在主城里顶点合批





local __instance
---@class TeamCacheManager
TeamCacheManager = class("TeamCacheManager")
function TeamCacheManager:initialize()
    if self.Root == nil then
        self.Root = GameObject.Find("TeamCacheRoot")
        if self.Root == nil then
            self.Root = GameObject("TeamCacheRoot")
            GameObject.DontDestroyOnLoad(self.Root)
        end
    end
    self.IsInit=false
    self.BuilderList = {}
end
---@return TeamCacheManager
function TeamCacheManager:Get()
    if __instance == nil then __instance = TeamCacheManager() end
    return __instance
end

function TeamCacheManager:InitData()
    if not self.IsInit then
        self.IsInit=true
        local list = CarDataManager:Get():GetCarList()
        for i = 1, #list do
            if list[i].LockState==ParkingLotState.Open then
                self:LoadCar(i, list[i]:GetID())
            end
        end
    end

end

function TeamCacheManager:LoadCar(idx, carid, func)
    local param = CarBuilderParam()
    param.buildType = CarBuilderType.Assemble
    param.newCarId = carid
    param.parent = self.Root
    param.BuilderTexture=true
    param.finishEvt = function(id, obj, param)
        log("----   TeamCacheManager:LoadCar()   ",id, obj, param)
        CarBuilderManager:Get():EnableCar(id, false)
        if func then
            CarBuilderManager:Get():EnableCar(id, true)
            func(id)
        end
    end
    self.BuilderList[idx] = CarBuilderManager:Get():BuildCar(param)
end

function TeamCacheManager:GetLoadProcess()
    local progress = 0
    for i = 1, #self.BuilderList do
        progress = progress + CarBuilderManager:Get():GetLoadProgress(self.BuilderList[i])
    end
    progress = progress / #self.BuilderList
    return progress
end
function TeamCacheManager:GetMainCarLoadProcess()
    local carIdx= PlayerPrefsHelper:GetValue_MainMenuViewCarIndex()
    if self.BuilderList[carIdx] then
        print(carIdx,"TeamCacheManager----------",CarBuilderManager:Get():GetLoadProgress(self.BuilderList[carIdx]))
        return CarBuilderManager:Get():GetLoadProgress(self.BuilderList[carIdx])
    end
    return 1
end

function TeamCacheManager:ClearData()
    for i = 1, #self.BuilderList do
        CarBuilderManager:Get():Recycle(self.BuilderList[i])
    end
    self.BuilderList = {}
    self.IsInit=false
end

function TeamCacheManager:GetCarByIndex(idx, func)
    local buildid = self.BuilderList[idx]
    if buildid  then
        if func then func(buildid) end
    end
    return buildid
end

function TeamCacheManager:GetCarByCarId(carid, func)
    local buildid = -1
    local idx = -1
    local list = CarDataManager:Get():GetCarList()
    for i = 1, #list do
        if list[i].LockState==ParkingLotState.Open and list[i]:GetID() == carid then
            buildid = self.BuilderList[i]
            idx = i
            break
        end
    end

    if buildid == nil or CarBuilderManager:Get():GetCarBuilder(buildid)==nil then
        self:LoadCar(idx, carid, func)
        return
    end


    if buildid > -1 then
        CarBuilderManager:Get():EnableCar(buildid, true)
        if func then func(buildid) end
    end
end

function TeamCacheManager:Recycle(builderid, isassemble)
    --if CarBuilderManager:Get():GetFlagCombine(builderid) then
    --    CarBuilderManager:Get():ReverseCombine(builderid)
    --end
    CarBuilderManager:Get():QucikReBuild(builderid, nil)
    CarBuilderManager:Get():SetParent(builderid, self.Root)
    CarBuilderManager:Get():EnableCar(builderid, false)
end