





---@class RedPointDataAsk : RedPointDataBase
RedPointDataAsk = class("RedPointDataAsk", RedPointDataBase)

function RedPointDataAsk:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataAsk:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = SurveyDataManager:Get():IsHaveRedPoint()
    --}}}

    RedPointDataBase.UpdateValue(self, value)
end