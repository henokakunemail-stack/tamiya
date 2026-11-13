

---@class RaceBulider
RaceBulider = class("RaceBulider")

function RaceBulider:intialize()
    
end
local __RaceBulider

---@return RaceBulider
function RaceBulider:Get()
    return __RaceBulider
end

function RaceBulider:Builder()

    local assetCacheManager = CS.Horizon.Game.ShowLayer.AssetCacheManager:Get()
    -- 1. 加载赛车资源
    local carBatchManager = BatchLoadManager()

    local fxNames = __RaceBulider:GetFxNames()
    for i, fxName in ipairs(fxNames) do
        local asset = AssetsManager.LoadAsync(fxName, typeof(GameObject))
        assetCacheManager:AddFxAsset(fxName, asset)
        carBatchManager:AddAssets(asset)
    end

    while not carBatchManager:IsDone() do
        UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, 0.8 + carBatchManager:GetProgress() * 0.2)
        --logError(carBatchManager:GetProgress()..","..tostring(carBatchManager:IsDone()))
        coroutine.yield()
    end
    carBatchManager = nil

    coroutine.yield()
    logError("RaceBulider")
    --- 加载到初始化的位置

    BattleDataManager:Get():CSharpAddCarGameobject()

end


function RaceBulider:TestBattleBuilder()

    local assetCacheManager = CS.Horizon.Game.ShowLayer.AssetCacheManager:Get()
    -- 1. 加载赛车资源
    local carBatchManager = BatchLoadManager()

    BattleDataManager:Get():SetRoomData(DemoDataManager:Get():GetLocalBattleData(), RaceModel.Local)

    BattleDataManager:Get():LoadCars(RaceModel.Local)

    local fxNames = __RaceBulider:GetFxNames()
    for i, fxName in ipairs(fxNames) do
        local asset = AssetsManager.LoadAsync(fxName, typeof(GameObject))
        assetCacheManager:AddFxAsset(fxName, asset)
        carBatchManager:AddAssets(asset)
    end

    while not carBatchManager:IsDone() do
        UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, 0.3 + carBatchManager:GetProgress() * 0.7)
        --logError(carBatchManager:GetProgress()..","..tostring(carBatchManager:IsDone()))
        coroutine.yield()
    end
    carBatchManager = nil

    coroutine.yield()
    logError("RaceBulider")
    --- 加载到初始化的位置

end


function RaceBulider:GetFxNames()
    local fxNames = {}

--     table.insert(fxNames, "fx_jiasu.prefab")
--     table.insert(fxNames, "fx_weiqi_huoxing.prefab")
--     table.insert(fxNames, "fx_weiqi_smoke.prefab")

    table.insert(fxNames, "camerashake1.prefab")
--     table.insert(fxNames, "fx_car_drift_01.prefab")
--
--     table.insert(fxNames, "cv_sports_start.prefab")
--     table.insert(fxNames, "fx_camera_start_01.prefab")
--     table.insert(fxNames, "fx_camera_start_02.prefab")
--     table.insert(fxNames, "fx_camera_start_03.prefab")
--     table.insert(fxNames, "prefab_map_opening.prefab")
--     table.insert(fxNames, "fx_camera_start_04.prefab")
--     table.insert(fxNames, "fx_camera_start_05.prefab")
--     table.insert(fxNames, "fx_camera_start_06.prefab")
--     table.insert(fxNames, "fx_camera_start_07.prefab")
--     table.insert(fxNames, "fx_camera_start_08.prefab")
--     table.insert(fxNames, "fx_camera_start_09.prefab")
--     table.insert(fxNames, "fx_camera_start_10.prefab")
--     table.insert(fxNames, "fx_camera_start_11.prefab")
--     table.insert(fxNames, "fx_camera_start_12.prefab")
--     table.insert(fxNames, "fx_camera_start_13.prefab")
--     table.insert(fxNames, "fx_finishline.prefab")
--     table.insert(fxNames, "fx_mach_haitun.prefab")
--     table.insert(fxNames, "fx_mach_shayu.prefab")
    return fxNames
end


function RaceBulider:Clear()
    mono.OnRaceExit()
    CSCameraManager.Get():Pause()
end


__RaceBulider = RaceBulider()


