

GoogleSDKData = {}
---@class GoogleChargeData
-----@field public cpOrderId
-----@field public googleOrderNo
-----@field public token
-----@field public innerId
-----@field public itemId
-----@field public chargeReTry
function GoogleSDKData:GoogleChargeData(_cpOrderId, _orderNo, _token, _innerId, _itemId,  _canChargeReTry)
    return {
        cpOrderId = _cpOrderId,
        googleOrderNo = _orderNo,
        token = _token,
        innerId = _innerId,
        itemId = _itemId,
        chargeReTry = _canChargeReTry,
    }
end