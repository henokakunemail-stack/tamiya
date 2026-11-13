---@class BattleDataRaceSeniorTrain : BattleData
BattleDataRaceSeniorTrain = class("BattleDataRaceSeniorTrain", BattleData)

function BattleDataRaceSeniorTrain:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceSeniorTrain:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil, type, isreplay)
    local data =nil
    if isreplay then
        data=RoomInitDataHelper:CreateRaceSeniorTrainReplay(msg,msg.idx)
    else
       data=RoomInitDataHelper:CreateRaceSeniorTrain(msg,msg.idx)
    end

    BattleData.SetRoomData(self, data)

end

function BattleDataRaceSeniorTrain:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end