


---@class BattleData
BattleData = class("BattleData")

function BattleData:initialize()
    self.BattleType = RaceModel.None

    self.IsReplay = false --是否自己参与的本地战斗回放

    self.IsPlayAgain = false --是否是不切换场景的前提下重新演示战斗

    ---@type Lua_RoomInitData
    self.LuaRoomData = nil

    ---@type BattleResultData
    self.ResultData = nil

    self.CarIDs = {}

    self.isBattleWin=false
    self.SelfBattleCarId=0

end


function BattleData:SetIsBattleWin(isWin)
    self.isBattleWin = isWin
end
function BattleData:GetIsBattleWin()
    return self.isBattleWin
end
function BattleData:SetSelfBattleCarId(id)
    self.SelfBattleCarId = id
end
function BattleData:GetSelfCarId()
    return self.SelfBattleCarId
end

function BattleData:SetData(data, type, isreplay)
    self.BattleType = type
    self.IsReplay = isreplay
    BattleDataManager:Get():SetDefaultBattleSpeed(1)
end

function BattleData:SetPlayAgain(isplay)
    self.IsPlayAgain = isplay
end

function BattleData:SetRoomData(data)
    self.LuaRoomData = data
    self.SelfBattleCarId=data.SelfCarId
    BattleDyDataManager:Get():InitBattleDyCarData()
end

function BattleData:SetResultData(data)
    self.ResultData = data
end


function BattleData:LoadCars(type)
    if self.BattleType ~= type then
        print("---   Error： BattleData:LoadCars  战斗类型不匹配，数据异常")
        return
    end

    if self.LuaRoomData == nil then
        print("---   Error：加载车异常，没有房间数据")
        return
    end

    for teamLoop = 1, #self.LuaRoomData.TeamList do
        local team = self.LuaRoomData.TeamList[teamLoop]
        if team then
            for playerLoop = 1, #team.PlayerList do
                local player = team.PlayerList[playerLoop]
                if player then
                    for carLoop = 1, #player.CarList do
                        local car = player.CarList[carLoop]
                        if car then
                            self:BuildCar(player.PlayerID,-1, car.CarID, car.PartDataList,car.Lightweight,car.Grids,car.Colorid,car.Stickerid)
                        end
                    end
                end
            end
        end
    end
end

function BattleData:BuildCar(playerid,carid, carindex, parts,lightweight, grid, color, sticker)
    local param = CarBuilderParam()
    param.buildType = CarBuilderType.Data
    --param.combineType = CombineType.MeshBaker
    param.newCarId = carid
    param.parts = parts
    param.lightweight = lightweight
    param.grids = grid
    param.colorid = color
    param.stickerid = sticker
    param.finishParam = carindex
    param.finishEvt = function(id, obj, param)
        log("----   BattleData:BuildCar   ",id, obj, param)
    end

    local id = CarBuilderManager:Get():BuildCar(param)
    table.insert(self.CarIDs, id)
    BattleDyDataManager:Get():AddCarBuilderByPlayerId(playerid,id)
end

function BattleData:CSharpAddCarGameobject()
    for i = 1, #self.CarIDs do
        local buildid = self.CarIDs[i]
        local obj = CarBuilderManager:Get():GetCarRoot(buildid)
        local param = CarBuilderManager:Get():GetFinishParam(buildid)
        CS.Horizon.Game.ShowLayer.AssetCacheManager:Get():AddCarGameObject(param, obj)
    end
end

function BattleData:ClearData(racetype)
    if self.BattleType ~= racetype then
        print("---   Error： BattleData:ClearData   战斗类型不匹配，数据异常")
        return
    end

    for i = 1, #self.CarIDs do
        CarBuilderManager:Get():Recycle(self.CarIDs[i])
    end

    self.CarIDs = {}

    self.LuaRoomData = nil

    self.BattleType = RaceModel.None

    self.IsReplay = false

    self.IsPlayAgain = false

    self.ResultData = nil

    self.isBattleWin=false
end


function BattleData:IsLoadCarFinish()
    local result = true
    for i = 1, #self.CarIDs do
        if CarBuilderManager:Get():GetLoadProgress(self.CarIDs[i]) < 1 then
            result = false
            break
        end
    end
    return result
end

function BattleData:GetProgress()
    local progress = 0
    local temp = 1 / #self.CarIDs
    for i = 1, #self.CarIDs do
        progress = progress + CarBuilderManager:Get():GetLoadProgress(self.CarIDs[i]) * temp
    end
    return progress
end

function BattleData:HideCars()
    for i = 1, #self.CarIDs do
        CarBuilderManager:Get():EnableCar(self.CarIDs[i], false)
    end
end

function BattleData:ShowCars()
    for i = 1, #self.CarIDs do
        CarBuilderManager:Get():EnableCar(self.CarIDs[i], true)
    end
end
function BattleData:EnableShellAnim()
    for i = 1, #self.CarIDs do
        CarBuilderManager:Get():GetCarBuilder(self.CarIDs[i]):EnableShellAnim()
    end
end