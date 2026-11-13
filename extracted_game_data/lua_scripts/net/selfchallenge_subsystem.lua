

---@class SelfChallengeSubsystem
SelfChallengeSubsystem = class("SelfChallengeSubsystem")

function SelfChallengeSubsystem:initialize( ... )
    --NetResponseEventManager:Get():AddListener(MsgID.CREATE_SELF_CHALLENGE_S2C_RES , self, self.CreateSelfChallengeRes)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_ALL_SELF_CHALLENGE_S2C_RES , self, self.GetAllSelfChallengeRes)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_ALL_CREATE_SELF_CHALLENGE_S2C_RES , self, self.GetAllCreateSelfChallengeRes)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_SELF_CHALLENGE_INFO_S2C_RES , self, self.GetSelfChallengeInfoRes)
    --NetResponseEventManager:Get():AddListener(MsgID.BEGIN_SELF_CHALLENGE_S2C_RES , self, self.BeginSelfChallengeRes)
    --NetResponseEventManager:Get():AddListener(MsgID.FINISH_SELF_CHALLENGE_S2C_RES , self, self.FinishSelfChallengeRes)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_CREATE_REWARD_S2C_RES , self, self.GetCreateRewardRes)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_CREATE_REWARD_S2C_RES , self, self.GetFlockRewardRes)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_CREATE_REWARD_S2C_RES , self, self.GetFinishRewardRes)
end

function SelfChallengeSubsystem:CreateSelfChallengeRes(data)
    local msg = assert(Dll_PB.decode("SelfChallengeCreateInfo", data))
    print(ProtoMsgHelp.block(msg))
    --CommonHelper:PlayScreenEffectWaiting(false)
    SelfChallengeDataManager:Get():UpdateSelfGameList(msg)

end

function SelfChallengeSubsystem:GetAllSelfChallengeRes(data)
    local msg = assert(Dll_PB.decode("GetAllSelfChallengeInfoRes", data))
    print(ProtoMsgHelp.block(msg))

    SelfChallengeDataManager:Get():ParseOtherSelfChallenge(msg)
    UIManager:Get():OpenView("SelfChallengeOtherGameListView",CanvasType.MainCanvas,"SelfChallengeOtherGameListView")
    UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeOtherGameListSetData)
end

function SelfChallengeSubsystem:GetAllCreateSelfChallengeRes(data)
    local msg = assert(Dll_PB.decode("GetAllSelfChallengeCreateInfoRes", data))
    print(ProtoMsgHelp.block(msg))

    SelfChallengeDataManager:Get():ParseSelfChallenge(msg)
    UIManager:Get():OpenView("SelfChallengeSelfGameListView",CanvasType.MainCanvas,"SelfChallengeSelfGameListView")
    UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelfGameListSetData,-1)
end


function SelfChallengeSubsystem:GetSelfChallengeInfoRes(data)
    local msg = assert(Dll_PB.decode("SelfChallengeInfo", data))
    print(ProtoMsgHelp.block(msg))

    SelfChallengeDataManager:Get():SetChapterData(msg)
    UIManager:Get():OpenView("SelfChallengeChapterListView",CanvasType.MainCanvas,"SelfChallengeChapterListView")
    UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeChapterListView_SetLevelList)

end
function SelfChallengeSubsystem:BeginSelfChallengeRes(data)
    local msg = assert(Dll_PB.decode("CommonRaceInfo", data))
    print(ProtoMsgHelp.block(msg))
    SelfChallengeDataManager:Get():RecBattleData(msg)


end
function SelfChallengeSubsystem:FinishSelfChallengeRes(data)
    local msg = assert(Dll_PB.decode("FinishSCRaceRes", data))
    print(ProtoMsgHelp.block(msg))
    BattleDataManager:Get():SetBattleResultData(msg)
    BattleDataManager:Get():SetStateBattleResult()
end
function SelfChallengeSubsystem:GetCreateRewardRes(data)
    local msg = assert(Dll_PB.decode("GetPassRewardRes", data))
    print(ProtoMsgHelp.block(msg))

end
function SelfChallengeSubsystem:GetFlockRewardRes(data)
    local msg = assert(Dll_PB.decode("GetFlockRewardRes", data))
    print(ProtoMsgHelp.block(msg))

end
function SelfChallengeSubsystem:GetFinishRewardRes(data)
    local msg = assert(Dll_PB.decode("GetFinishRewardRes", data))
    print(ProtoMsgHelp.block(msg))

end



function SelfChallengeSubsystem:SendCreateSelfChallenge(data)
    --local reqData = {
    --      ticketId = data.ticketId,
    --      name = data.name,
    --      lastTime = data.lastTime,		--持续时间	7天 14天
    --      trackType = data.trackType,			--轨道类型  1.速度2.弯道3.坡道4.越野
    --      difficulty = data.difficulty,			 --1.简单2.普通3.困难4.极难
    --      lvNum = data.lvNum,				--一共多少关
    --      finishRewards = data.finishRewards,		--通关奖励
    --      levelInfos = data.levelInfos
    --}
    local reqBytes = assert(Dll_PB.encode("CreateSelfChallengeReq", data))
    NetManager:Get():Send(OldMsgID.CREATE_SELF_CHALLENGE_C2S_REQ, reqBytes)
end

function SelfChallengeSubsystem:SendGetAllSelfChallenge(idx)
    local reqData = {
       idx=idx
    }
    local reqBytes = assert(Dll_PB.encode("GetAllSelfChallengeInfoReq", reqData))
    NetManager:Get():Send(OldMsgID.GET_ALL_SELF_CHALLENGE_C2S_REQ, reqBytes)
end

function SelfChallengeSubsystem:SendGetAllCreateSelfChallenge(id)
    local reqData = {
       idx=id
    }
    local reqBytes = assert(Dll_PB.encode("GetAllSelfChallengeInfoReq", reqData))
    NetManager:Get():Send(OldMsgID.GET_ALL_CREATE_SELF_CHALLENGE_C2S_REQ, reqBytes)

end

function SelfChallengeSubsystem:SendGetSelfChallengeInfo(id)
    local reqData = {
       num=id
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1_64", reqData))
    NetManager:Get():Send(OldMsgID.GET_SELF_CHALLENGE_INFO_C2S_REQ, reqBytes)

end
function SelfChallengeSubsystem:SendBeginSelfChallenge(id,levelid,carIdx)
    local reqData = {
        gameId=id,
        levelNum=levelid,
        carIdx=carIdx
    }
    local reqBytes = assert(Dll_PB.encode("BeginSCRaceReq", reqData))
    NetManager:Get():Send(OldMsgID.BEGIN_SELF_CHALLENGE_C2S_REQ, reqBytes)

end

function SelfChallengeSubsystem:SendFinishSelfChallenge(gameId,level,result)
    local reqData = {
      gameId=gameId,
      levelNum=level,
      raceResult=result
    }
    print(ProtoMsgHelp.block(reqData))
    local reqBytes = assert(Dll_PB.encode("FinishSCRaceReq", reqData))
    NetManager:Get():Send(OldMsgID.FINISH_SELF_CHALLENGE_C2S_REQ, reqBytes)

end

function SelfChallengeSubsystem:SendGetCreateReward(idx)
    local reqData = {
        idx=idx
    }
    local reqBytes = assert(Dll_PB.encode("GetCreateRewardReq", reqData))
    NetManager:Get():Send(OldMsgID.GET_CREATE_REWARD_C2S_REQ, reqBytes)

end
function SelfChallengeSubsystem:GetFlockRewardReq(gameId,idx)
    local reqData = {
        gameId=gameId,
        idx=idx
    }
    local reqBytes = assert(Dll_PB.encode("GetFlockRewardReq", reqData))
    NetManager:Get():Send(OldMsgID.GET_CREATE_REWARD_C2S_REQ, reqBytes)

end
function SelfChallengeSubsystem:GetFinishRewardReq(gameId,idx)
    local reqData = {
        gameId=gameId,
        idx=idx
    }
    local reqBytes = assert(Dll_PB.encode("GetFinishRewardReq", reqData))
    NetManager:Get():Send(OldMsgID.GET_CREATE_REWARD_C2S_REQ, reqBytes)

end


local __subsystem=SelfChallengeSubsystem()
function SelfChallengeSubsystem:Get() return __subsystem end
return __subsystem
