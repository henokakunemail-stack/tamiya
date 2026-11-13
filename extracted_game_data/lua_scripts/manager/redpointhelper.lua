


---@class RedPointHelper
RedPointHelper = class("RedPointHelper")

function RedPointHelper.GetValue(id)
    local result = RedPointManager:Get():GetValue(id)
    --log("---   RedPointHelper.GetValue",id,result)
    if result == nil then
        logError("---   error:redpointvalue = nil", id)
        result = false
    end
    return result
end

function RedPointHelper.RegistRealtimeFunc(id, objid, redjob)
    --log("---   RedPointHelper.RegistRealtimeFunc",id, obj)
    local f = function(value, param)
        if param then param:SetActive(value) end
    end
    RedPointManager:Get():RegistRealtimeFunc(id, objid, f, redjob) --实时刷新红点gameobjec
end

function RedPointHelper.UnRegistRealtimeFunc(id, objid)
    --log("---   RedPointHelper.UnRegistRealtimeFunc",id)
    RedPointManager:Get():RegistRealtimeFunc(id, objid, nil, nil)
end





--{{{数据构建模板，客户端槽位id转红点系统key值
function RedPointHelper:GrooveIDToRedPointKey(grooveid)
    return 100000 + grooveid
end
--}}}

--{{{数据构建模板，客户端车位id转红点系统key值
function RedPointHelper:CarIDToRedPointKey(carid)
    return 200000 + carid
end
--}}}


--{{{刷新车库系统中车位上所有配件槽位红点
function RedPointHelper.RefreshGrooveMapRedPoint(carid)
    for i, v in pairs(PartGrooveID) do
        local key = RedPointHelper:GrooveIDToRedPointKey(v)
        RedPointManager:Get():UpdateValue(key, {carid, v})
    end
end
--}}}

--{{{刷新车库系统中车位红点
function RedPointHelper.RefreshCarPosRedPoint()
    local list = CarDataManager:Get():GetCarList()
    for i = 1, #list do
        local key = RedPointHelper:CarIDToRedPointKey(list[i]:GetID())
        RedPointManager:Get():UpdateValue(key, {list[i]:GetID()})
    end
end
--}}}