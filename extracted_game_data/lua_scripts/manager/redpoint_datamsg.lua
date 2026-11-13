





---@class RedPointDataMsg : RedPointDataBase
RedPointDataMsg = class("RedPointDataMsg", RedPointDataBase)

function RedPointDataMsg:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataMsg:UpdateValue(param)
    RedPointDataBase.UpdateValue(self, param)
end