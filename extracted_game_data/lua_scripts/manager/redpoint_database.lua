


---@class RedPointDataBase
RedPointDataBase = class("RedPointDataBase")

function RedPointDataBase:initialize(id)
    self.ID = id

    self.Value = false
    self.FuncRealtime = {} --注册事件，当红点值有变更执行刷新方法（红点状态根据值刷新）
    self.FuncRealtimeParam = {}
end

function RedPointDataBase:InitData()--可选重写

end

function RedPointDataBase:UpdateValue(param)--必须重写
    self.Value = param
    for k, v in pairs(self.FuncRealtime) do
        local redobj = self.FuncRealtimeParam[k]
        if v then v(self.Value, redobj) end
    end
end

function RedPointDataBase:SetRealTimeFunc(objid, func, redjob)
    self.FuncRealtime[objid] = func
    self.FuncRealtimeParam[objid] = redjob
end

function RedPointDataBase:GetValue() return self.Value end
function RedPointDataBase:GetID() return self.ID end