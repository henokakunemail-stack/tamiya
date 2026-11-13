





---@class RedPointDataBag : RedPointDataBase
RedPointDataBag = class("RedPointDataBag", RedPointDataBase)

function RedPointDataBag:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataBag:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    value=KnapsackDataManager:Get():GetIsNew()
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end