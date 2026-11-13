---@class NetDelayManager
NetDelayManager = class("NetDelayManager")

function NetDelayManager:initialize(  )

end

function NetDelayManager:Get()
    if self._instance == nil then
        self._instance = NetDelayManager()
    end
    return self._instance
end

function NetDelayManager:Register()
    print("...."..#DelayMsgID)
    self:Clear()
    for i, v in pairs(DelayMsgID) do
        local ReqId=v.ReqId
        local ResId=v.ResId
        local isShowMask=v.isShowMask or true
        local AutoCloseTime=v.AutoCloseTime or -1
        local AutoCloseFunc=v.AutoCloseFunc
        monoNetDelayMgr:OnRegister(ReqId,ResId,isShowMask,AutoCloseTime,AutoCloseFunc)
    end
    for i, v in pairs(NoMsgIdxMsgID) do
        local ReqId=v.ReqId
        local isShowMask=v.showMask
        local AutoCloseTime=v.AutoCloseTime or -1
        local AutoCloseFunc=v.AutoCloseFunc
        monoNetDelayMgr:OnRegisterNoMsg(ReqId,isShowMask,AutoCloseTime,AutoCloseFunc)
    end
end

function NetDelayManager:OnErrorRemoveDelayInfo(cmd)
    monoNetDelayMgr:RemoveNetDelayInfo(cmd)
end
function NetDelayManager:Clear()
    monoNetDelayMgr:Clear()
end
function NetDelayManager:OnReConnect()
    --monoNetDelayMgr:OnReConnect()
end
