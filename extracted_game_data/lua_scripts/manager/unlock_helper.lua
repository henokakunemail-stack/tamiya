---@class UnlockHelper
UnlockHelper = class("UnlockHelper")

function UnlockHelper.RegisterFunc(func)
    UnlockDataManager:Get():RegisterInitEvent(func)
end

function UnlockHelper.IsUnLock(funcId)
   return UnlockDataManager:Get():IsUnLock(funcId)
end