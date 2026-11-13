---@class RedPointDataEmail : RedPointDataBase
RedPointDataEmail = class("RedPointDataEmail", RedPointDataBase)

function RedPointDataEmail:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataEmail:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    value=EmailDataManager:Get():GetIsNew()
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end