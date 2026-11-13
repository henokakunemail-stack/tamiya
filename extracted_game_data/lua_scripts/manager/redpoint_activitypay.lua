---@class RedPointDataActivityPay : RedPointDataBase
RedPointDataActivityPay = class("RedPointDataActivityPay", RedPointDataBase)

function RedPointDataActivityPay:initialize(id)
    RedPointDataBase.initialize(self, id)
end
---@param param SC_PlayerCardInfoRes
function RedPointDataActivityPay:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false

    for i = 1, #param.playerCardInfo do
        if param.playerCardInfo[i].buyState==1 and param.playerCardInfo[i].curGetState==0 then
            value=true
            break
        end
    end

    --}}}
    RedPointDataBase.UpdateValue(self, value)
end