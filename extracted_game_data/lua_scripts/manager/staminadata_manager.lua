---@class StaminaDataManager
StaminaDataManager = class("StaminaDataManager")

function StaminaDataManager:Get()
    if self._instance == nil then
        self._instance = StaminaDataManager()
    end
    return self._instance
end
function StaminaDataManager:initialize()
    self.TimerID = -1
    ---@type dictcalc_config_cell
    local globalvalue_config = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.StaminaRecoverInterval)
    self.staminaTime = tonumber(globalvalue_config.varval)
    print("体力恢复时间---", self.staminaTime)
end

---开始增加体力
function StaminaDataManager:StartIncreaseStamina()
    local stamina = PlayerDataManager:Get():GetPlayerStamina()
    local maxStamina = tonumber(PlayerDataManager:Get():GetPlayerMaxStamina())
    local staminaTime = PlayerDataManager:Get():GetPlayerStaminaTime()

    local StaminaRecoverInterval = tonumber(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.StaminaRecoverInterval).varval) --常量表的体力时间间隔
    --print("staminaTime",StaminaRecoverInterval)
    local logvalue = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    --log("staminaTime:", (staminaTime), "CommonHelper:GetNowTime():", logvalue, "staminaTime-CommonHelper:GetNowTime():", (staminaTime - logvalue))
    --log("staminaTime:", (stamina), "CommonHelper:GetNowTime():", maxStamina)

    if stamina < maxStamina then
        self:StopTimer()
        self.TimerID = TimerManager:Get():CreateTimerLoop(1, function()
            if CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) >= staminaTime + StaminaRecoverInterval then
                self:StopTimer()
                ---请求回复体力
                if stamina < maxStamina then
                    StaminaSubsystem:Get():SendMsg_ReBackStamina()
                end
            end
        end)

    else
        print("体力已达最大")
    end
end

function StaminaDataManager:StopTimer()
    if self.TimerID ~= -1 then
        TimerManager:Get():StopTimer(self.TimerID)
        self.TimerID = -1
    end
end


