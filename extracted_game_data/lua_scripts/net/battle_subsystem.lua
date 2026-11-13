---@class BattleSubsystem
BattleSubsystem = class("BattleSubsystem")

function BattleSubsystem:initialize(...)

    --NetResponseEventManager:Get():AddListener(MsgID.PLAYER_LEVELUP_S2C_NOTIFY, self, self.RecvMsg_PlayerLevelUp)
end
----玩家等级升级
function BattleSubsystem:RecvMsg_PlayerLevelUp(data)
    ---@type SC_NotifyLevelChange
    local msg = assert(Dll_PB.decode("NotifyLevelChange", data))
    print(ProtoMsgHelp.block(msg))

    PlayerLevelUpDataManager:Get():SetIsUpgrade(true)
    PlayerLevelUpDataManager:Get():SetOldData(PlayerDataManager:Get():GetPlayerLV(), PlayerDataManager:Get():GetPlayerEXP(), PlayerDataManager:Get():GetPlayerStamina())

    PlayerDataManager:Get():SetPlayerLV(msg.level)
    PlayerDataManager:Get():SetPlayerEXP(msg.exp)
    PlayerDataManager:Get():SetPlayerStaminaAndStaminaTime(msg.stamina, msg.staminaTime) --设置体力和体力时间

    if msg.level == 2 then
        UnlockDataManager:Get():AddUnlockId(GameFunction.Survey)
    end

    UnlockDataManager:Get():UpdateLockData()
    UnlockDataManager:Get():UpdateLockUIData()
end

local __subsystem = BattleSubsystem()
function BattleSubsystem:Get()
    return __subsystem
end
return __subsystem