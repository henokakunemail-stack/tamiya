---@class StoryHelper
StoryHelper = class("StoryHelper")

function StoryHelper:initialize()
end

function StoryHelper:TouchStory(levelid, idx, finish, param)

    local leveldata = PVEChapterDataManager:Get():GetLevelDataByLevelId(levelid)
    if leveldata == nil then
        logError("---   error:触发剧情失败，关卡数据空，levelid = ", levelid)
        finish()
        return
    end

    local value = PlayerPrefsHelper:GetValue_Story(levelid)
    if StoryToggle == false or CommonHelper:MathBitUtil_BitTrueInt(value, idx - 1) then
        finish()
        return
    end

    local storyid = leveldata.StoryGroup[idx]
    if storyid == nil then
        logError("---   error:触发剧情失败，关卡数据空，storyid = nil")
        finish()
        return
    end

    if storyid <= 0 then
        finish()
        return
    end

    PlotManager:Get():StartPlot(storyid, function(param)
        local value = PlayerPrefsHelper:GetValue_Story(levelid)
        value = CommonHelper:MathBitUtil_BitInt_Or(value, idx - 1)
        PlayerPrefsHelper:SetValue_Story(levelid, value)
        finish(param)
    end, param)

end

function StoryHelper:TouchStory_SelectTeam(levelid, finish)
    StoryHelper:TouchStory(levelid, 1, function()
        if finish then
            finish()
        end
    end)
end

function StoryHelper.TouchStory_Win(levelid, result)
    local battleType = BattleDataManager:Get():GetBattleType()
    BattleDataManager:Get():AnalyzeResult(result.results)
    local isWin = BattleDataManager:Get():GetIsBattleWin()

    if battleType == RaceModel.Battle and isWin == true then
        StoryHelper:TouchStory(levelid, 3, function()
            print("---    BattleHelper.TouchStory_Win", result.results.Length)
            local loop = result.results.Length - 1
            for i = 0, loop do
                log("---   BattleHelper.TouchStory_Win", result.results[i].pid, result.results[i].rank, result.results[i].time, result.results[i].error, result.results[i].trackidx)
            end
            BattleDataManager:Get():SetStateBattleFinish(result.results)
        end)
    else
        BattleDataManager:Get():SetStateBattleFinish(result.results)
    end
end

function StoryHelper.TouchStory_Ready(levelid, result)
    StoryHelper:TouchStory(levelid, 2, function()
        --print("---    BattleHelper.TouchStory_Win", result.results.Length)
        --local loop = result.results.Length - 1
        --for i = 0, loop do
        --    log("---   BattleHelper.TouchStory_Win", result.results[i].pid, result.results[i].rank, result.results[i].time, result.results[i].error, result.results[i].trackidx)
        --end
        --BattleDataManager:Get():SetStateBattleFinish(result.results)
    end)
end
