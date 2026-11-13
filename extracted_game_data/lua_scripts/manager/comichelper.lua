---@class ComicHelper
ComicHelper = class("ComicHelper")

function ComicHelper:initialize()
end

function ComicHelper:TouchStory(levelid, idx, finish, param)

    local leveldata = PVEChapterDataManager:Get():GetLevelDataByLevelId(levelid)
    if leveldata == nil then
        logError("---   error:触发剧情失败，关卡数据空，levelid = ", levelid)
        finish()
        return
    end

    local value = PlayerPrefsHelper:GetValue_Story(levelid)
    if ComicToggle == false or CommonHelper:MathBitUtil_BitTrueInt(value, idx - 1) then
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

end

function ComicHelper:TriggerComicImg(id,finish,param)
    ---@type dictactivitycopy_config_cell
   local activityCopyCfg=  CommonHelper:GetTableDataByID(ConfigNames.dictactivitycopy_config,id)
    if activityCopyCfg == nil then
        logError("---   error:触发漫画失败，关卡数据空，levelid = ", id)
        finish(param)
        return
    end
    --if activityCopyCfg.comicname=="-1" or CommonHelper:IsNullOrEmpty(activityCopyCfg.comicname) or PlayerPrefsHelper:GetValue_Comic(id)  then
    if activityCopyCfg.comicname=="-1" or CommonHelper:IsNullOrEmpty(activityCopyCfg.comicname)  then
        logError("---   error:没有漫画 = ", id)
       finish(param)
        return
    end
   ComicManager:Get():StartPlotImg(activityCopyCfg.comicname,function(param)
       PlayerPrefsHelper:SetValue_Comic(id,1)
       finish(param)
   end,param)
end


