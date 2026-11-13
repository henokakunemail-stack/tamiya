





---@class RedPointDataChat : RedPointDataBase
RedPointDataChat = class("RedPointDataChat", RedPointDataBase)

function RedPointDataChat:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataChat:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    value=ChatDataManager:Get():IsHaveRedPoint()
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end