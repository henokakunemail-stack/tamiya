---@class RedPointFunction
RedPointFunction = class("RedPointFunction")

function RedPointFunction.RegistData()
    --注册红点数据
    for k, v in pairs(RedPointID) do
        if v < 5000 then
            RedPointManager:Get():RegistRedPoint(RedPointDataMsg(v))
        end
    end

    RedPointManager:Get():RegistRedPoint(RedPointDataAsk(RedPointID.Ask))
    RedPointManager:Get():RegistRedPoint(RedPointDataBag(RedPointID.Bag))
    RedPointManager:Get():RegistRedPoint(RedPointDataChat(RedPointID.Chat))
    RedPointManager:Get():RegistRedPoint(RedPointDataRecruit(RedPointID.Recruit))
    RedPointManager:Get():RegistRedPoint(RedPointDataRecruitDiamond(RedPointID.Recruit_Diamond))
    RedPointManager:Get():RegistRedPoint(RedPointDataRecruitGold(RedPointID.Recruit_Gold))
    RedPointManager:Get():RegistRedPoint(RedPointDataRecruitFriend(RedPointID.Recruit_Friend))
    RedPointManager:Get():RegistRedPoint(RedPointDataTask(RedPointID.S_TaskView))
    RedPointManager:Get():RegistRedPoint(RedPointDataTaskDaily(RedPointID.S_TaskDaily))
    RedPointManager:Get():RegistRedPoint(RedPointDataTaskWeek(RedPointID.Task_Week))
    RedPointManager:Get():RegistRedPoint(RedPointDataTaskWeek(RedPointID.S_ClubTask))
    RedPointManager:Get():RegistRedPoint(RedPointDataTaskAchievement(RedPointID.S_TaskAchievement))
    RedPointManager:Get():RegistRedPoint(RedPointDataGarage(RedPointID.Garage))

    RedPointManager:Get():RegistRedPoint(RedPointDataLoginActivity(RedPointID.LoginActivity_Login))
    RedPointManager:Get():RegistRedPoint(RedPointDataSign(RedPointID.LoginActivity_Sign))
    RedPointManager:Get():RegistRedPoint(RedPointDataNoviceTask(RedPointID.LoginActivity_NoviceTask))

    RedPointManager:Get():RegistRedPoint(RedPointDataFirstActivity(RedPointID.Activity_FirstBuy))
    RedPointManager:Get():RegistRedPoint(RedPointDataPlayerReward(RedPointID.PlayerLevelReward))
    RedPointManager:Get():RegistRedPoint(RedPointDataActivityPay(RedPointID.ActivityPay))

    RedPointManager:Get():RegistRedPoint(RedPointDataEmail(RedPointID.Email))

    --for i, v in pairs(PartGrooveID) do
    --    local key = RedPointHelper:GrooveIDToRedPointKey(v)
    --    RedPointManager:Get():RegistRedPoint(RedPointDataGarage(key))
    --end
    --
    for i = 1, 5 do
        local key = RedPointHelper:CarIDToRedPointKey(i)
        RedPointManager:Get():RegistRedPoint(RedPointDataGarageCar(key))
    end
end