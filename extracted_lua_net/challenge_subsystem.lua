

---@class ChallengeSubsystem
ChallengeSubsystem = class("ChallengeSubsystem")

function ChallengeSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.GET_TEST_TRAIN_S2C_RES,self,self.GetChallengeInfoRes)
    NetResponseEventManager:Get():AddListener(MsgID.BEGIN_TEST_TRAIN_S2C_RES,self,self.BeginChallengeRes)
    NetResponseEventManager:Get():AddListener(MsgID.FINISH_TEST_TRAIN_S2C_RES,self,self.FinishChallengeRes)
end
local _OpenCallback=nil
function ChallengeSubsystem:GetChallengeInfoRes(data)
    ---@type SC_UserChapter[]
    local msg = assert(Dll_PB.decode("UserChapter", data))
    print(ProtoMsgHelp.block(msg))
    SpecialTrainingDataManager:Get():Init(msg)
    UIManager:Get():OpenView("SpecialTrainingView",CanvasType.MainCanvas,"SpecialTrainingView")
    if _OpenCallback then
        _OpenCallback()
        _OpenCallback=nil
    end
end
function ChallengeSubsystem:BeginChallengeRes(data)
    ---@type SC_BeginPve
    local msg = assert(Dll_PB.decode("BeginPve", data))
    print(ProtoMsgHelp.block(msg))
    SpecialTrainingDataManager:Get():RecBattleData(msg)
end
function ChallengeSubsystem:FinishChallengeRes(data)
    ---@type SC_FinishPve
    local msg = assert(Dll_PB.decode("FinishPve", data))
    print(ProtoMsgHelp.block(msg))
    --------------------------------------
    local isUP=false
    if msg.level~=0 then
        PlayerDataManager:Get():SetPlayerEXP(msg.exp)
        isUP=  PlayerDataManager:Get():SetPlayerLV(msg.level)
    end
    if msg.addLev>1 and isUP then
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.levelupdown)
        CommonHelper:CheckPlayerLevelUp(msg.addLev)
    end
    if msg.curdown  then
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.curdown)
    end
    local battleResultData = BattleDataManager:Get():GetBattleResultData()
    battleResultData:SetOtherResultData(msg,msg.curdown)

    BattleDataManager:Get():SetStateBattleResult()
    SpecialTrainingDataManager:Get():UpdateCurChallenge(msg.id,msg.lastNum,msg.maxNum)
    PlayerDataManager:Get():SetPlayerStaminaAndStaminaTime(msg.stamina, msg.staminaTime)

end

function ChallengeSubsystem:SendGetChallengeInfo(func)
    _OpenCallback=func
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.GET_TEST_TRAIN_C2S_REQ,data)
end
function ChallengeSubsystem:SendBeginChallenge(levelid, idx)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),levelid, idx})
    NetManager:Get():Send(MsgID.BEGIN_TEST_TRAIN_C2S_RES,data)
end
function ChallengeSubsystem:SendFinishChallenge(rank, time, error,times,starttime,recordValue)
    local data=  SpecialTrainingDataManager:Get():GetSelectCopy()
    local car=  SpecialTrainingDataManager:Get():GetCurSelectCarData()
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),data.C_ID,car ,time,rank,error,times,starttime,recordValue})
    NetManager:Get():Send(MsgID.FINISH_TEST_TRAIN_C2S_RES,data)
end
local __subsystem=ChallengeSubsystem()
function ChallengeSubsystem:Get() return __subsystem end
return __subsystem
