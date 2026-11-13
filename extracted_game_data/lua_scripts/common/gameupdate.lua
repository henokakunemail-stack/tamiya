
----------所有需要每帧执行的方法，在这里统一管理

function GlobeFunction_GameUpdate()
    GameUpdate:Get():Update()
end



---@class GameUpdate
GameUpdate = class("GameUpdate")

GameUpdate.eventMap = {}

function GameUpdate:EnabelUpdate()
    CS.GameProperties:Get().enableGameUpdate = #self.eventMap > 0
end

function GameUpdate:AddUpdate(eventID, func, class, param)
    local count = #self.eventMap
    for i = 1, count do
        if self.eventMap[i].eventID == eventID then
            print("Error:GameUpdate repeat add, id:",eventID)
            return
        end
    end

    local data = {
        eventID = eventID,
        func = func,
        class = class,
        param = param,
    }
    table.insert(self.eventMap, data)

    self:EnabelUpdate()
end

function GameUpdate:RemoveUpdate(eventID)
    local count = #self.eventMap
    for i = 1, count do
        if self.eventMap[i].eventID == eventID then
            table.remove(self.eventMap, i)
            break
        end
    end

    self:EnabelUpdate()
end



function GameUpdate:Update()
    local count = #self.eventMap
    for i = 1, count do
        local mapdata = self.eventMap[i]
        if mapdata.class == nil then
            mapdata.func(mapdata.param)
        else
            mapdata.func(mapdata.class, mapdata.param)
        end

    end
end

function GameUpdate:ContainKey(key)
    local count = #self.eventMap
    for i = 1, count do
        if self.eventMap[i].eventID == key then
            return true
        end
    end
    return false
end

---@type GameUpdate
local __instance
function GameUpdate:Get()
    if __instance == nil then
        __instance = GameUpdate()
    end
    return __instance
end
