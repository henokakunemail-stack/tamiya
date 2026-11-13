---@class PageBattleResult
PageBattleResult = class("PageBattleResult")

function PageBattleResult:initialize(parentPref, moduleID,view)
    self:CacheBaseData(parentPref, moduleID,view)
end

function PageBattleResult:CacheBaseData(parentPref, moduleID,view)
    self.parentPref = parentPref
    self.View=view
    self.pageResultCG = UIUtil.GetTypeChildWightByParent("Page_BattleResult", self.parentPref, typeof(CanvasGroup))
    self.pageRewardCG = UIUtil.GetTypeChildWightByParent("Page_BattleResult_Reward", self.parentPref, typeof(CanvasGroup))
    self.pageStoryRewardCG = UIUtil.GetTypeChildWightByParent("Page_BattleResult_StoryReward", self.parentPref, typeof(CanvasGroup))
    self.pageRaceCG = UIUtil.GetTypeChildWightByParent("Page_BattleResult_Race", self.parentPref, typeof(CanvasGroup))
    self.pageRankCG = UIUtil.GetTypeChildWightByParent("Page_BattleResult_Rank", self.parentPref, typeof(CanvasGroup))
    self.pageTrotCG = UIUtil.GetTypeChildWightByParent("Page_BattleResult_RaceTrot", self.parentPref, typeof(CanvasGroup))
    self.pageClub3v3CG = UIUtil.GetTypeChildWightByParent("Page_BattleResult_RaceClub3v3", self.parentPref, typeof(CanvasGroup))
    self.pageClubGVGCG = UIUtil.GetTypeChildWightByParent("Page_BattleResult_RaceGVG", self.parentPref, typeof(CanvasGroup))
    self.pageJCPCG = UIUtil.GetTypeChildWightByParent("Page_BattleResult_RaceJCP", self.parentPref, typeof(CanvasGroup))
    self.pageXCPCG = UIUtil.GetTypeChildWightByParent("Page_BattleResult_RaceXCP", self.parentPref, typeof(CanvasGroup))
    self.pageCarGodCG = UIUtil.GetTypeChildWightByParent("Page_BattleResult_RaceCarGod", self.parentPref, typeof(CanvasGroup))
    self.battleInfoCG = UIUtil.GetTypeChildWightByParent("BattleInfoCG", self.parentPref, typeof(CanvasGroup))


     self.moduleId = moduleID
    ---@type BattleResultData
    self.battleResultData = nil
    self.selfIndex = -1  --自己在战斗结算中的索引
end

function PageBattleResult:InitViewInfo()
    if self.Page_BattleResultRank==nil then
        self.Page_BattleResultRank=PageBattleResultPlayerRank(self.battleInfoCG)
    end
    self.battleResultData = BattleDataManager:Get():GetBattleResultData()
    if BattleDataManager:Get():GetBattleType()==RaceModel.RaceSuperBattle then
        local allFail=true
        for i = 1, #self.battleResultData.PlayerList do
            if self.battleResultData.PlayerList[i].Error==BattleFailError.None then
                allFail=false
                break
            end
        end

        if allFail then
            table.sort(self.battleResultData.PlayerList,function(a, b)
                return a.Time<b.Time
            end)
            for i = 1, #self.battleResultData.PlayerList do
                self.battleResultData.PlayerList[i].Rank=i
            end
        end

    end

    self.selfIndex=BattleDataManager:Get():GetDefaultPlayerIndex()
    if not (BattleDataManager:Get():GetBattleType()==RaceModel.Battle and PVEChapterDataManager:Get():GetBattleResult() and  PVEChapterDataManager:Get():GetLastFlag() and PVEChapterDataManager:Get().BattleCount>1)
       or not (BattleDataManager:Get():GetBattleType()==RaceModel.NewBieChapter and NewBieChapterDataManager:Get():GetBattleResult() and  NewBieChapterDataManager:Get():GetLastFlag() and NewBieChapterDataManager:Get().BattleCount>1)
    then
        self.Page_BattleResultRank:InitPlayerRank(self.pageResultCG.gameObject,false,self.battleResultData,nil,self.moduleId)
    end
    self:InitRewardInfo()
    self:InitFuncBtn()
end
function PageBattleResult:InitFuncBtn()
    UIUtil.ShowCanvasGroup(self.battleInfoCG, false)


end



---@param battleType RaceModel
function PageBattleResult:InitCanvasGroup(battleType)
    UIUtil.ShowCanvasGroup(self.pageResultCG, not (BattleDataManager:Get():GetBattleType()==RaceModel.Battle and PVEChapterDataManager:Get():GetBattleResult() and  PVEChapterDataManager:Get():GetLastFlag() and PVEChapterDataManager:Get().BattleCount>1)
    and not (BattleDataManager:Get():GetBattleType()==RaceModel.NewBieChapter and NewBieChapterDataManager:Get():GetBattleResult() and  NewBieChapterDataManager:Get():GetLastFlag() and NewBieChapterDataManager:Get().BattleCount>1)
    )
    CommonHelper:CSGameObjectSetActive(self.pageResultCG.gameObject, not (BattleDataManager:Get():GetBattleType()==RaceModel.Battle and PVEChapterDataManager:Get():GetBattleResult() and  PVEChapterDataManager:Get():GetLastFlag() and PVEChapterDataManager:Get().BattleCount>1)
    and not (BattleDataManager:Get():GetBattleType()==RaceModel.NewBieChapter and NewBieChapterDataManager:Get():GetBattleResult() and  NewBieChapterDataManager:Get():GetLastFlag() and NewBieChapterDataManager:Get().BattleCount>1)
    )
    UIUtil.ShowCanvasGroup(self.pageRewardCG, battleType ~= RaceModel.RaceRank and battleType ~= RaceModel.RaceRoom and battleType ~= RaceModel.Battle and battleType ~= RaceModel.NewBieChapter
            and battleType~=RaceModel.RaceSelfChapter and battleType ~= RaceModel.RaceTrot and battleType ~= RaceModel.RaceClub3v3 and battleType ~= RaceModel.RaceJcp and battleType ~= RaceModel.RaceXcp and battleType ~= RaceModel.RaceGVG and battleType ~= RaceModel.RaceSeniorTrain and battleType ~= RaceModel.RaceCarGod )
    CommonHelper:CSGameObjectSetActive(self.pageRewardCG.gameObject, battleType ~= RaceModel.RaceRank and battleType ~= RaceModel.RaceRoom and battleType ~= RaceModel.Battle and battleType ~= RaceModel.NewBieChapter
            and battleType~=RaceModel.RaceSelfChapter and battleType ~= RaceModel.RaceTrot and battleType ~= RaceModel.RaceClub3v3 and battleType ~= RaceModel.RaceJcp and battleType ~= RaceModel.RaceXcp and battleType ~= RaceModel.RaceGVG and battleType ~= RaceModel.RaceSeniorTrain and battleType ~= RaceModel.RaceCarGod )
    UIUtil.ShowCanvasGroup(self.pageRankCG, battleType == RaceModel.RaceRank)
    CommonHelper:CSGameObjectSetActive(self.pageRankCG.gameObject, battleType == RaceModel.RaceRank)
    UIUtil.ShowCanvasGroup(self.pageTrotCG, battleType == RaceModel.RaceTrot)
    CommonHelper:CSGameObjectSetActive(self.pageTrotCG.gameObject, battleType == RaceModel.RaceTrot)
    UIUtil.ShowCanvasGroup(self.pageClub3v3CG, battleType == RaceModel.RaceClub3v3)
    CommonHelper:CSGameObjectSetActive(self.pageClub3v3CG.gameObject, battleType == RaceModel.RaceClub3v3)
    UIUtil.ShowCanvasGroup(self.pageClubGVGCG, battleType == RaceModel.RaceGVG)
    CommonHelper:CSGameObjectSetActive(self.pageClubGVGCG.gameObject, battleType == RaceModel.RaceGVG)
    UIUtil.ShowCanvasGroup(self.pageRaceCG, battleType == RaceModel.RaceRoom)
    CommonHelper:CSGameObjectSetActive(self.pageRaceCG.gameObject, battleType == RaceModel.RaceRoom)
    UIUtil.ShowCanvasGroup(self.pageJCPCG, battleType == RaceModel.RaceJcp)
    CommonHelper:CSGameObjectSetActive(self.pageJCPCG.gameObject, battleType == RaceModel.RaceJcp)
    UIUtil.ShowCanvasGroup(self.pageXCPCG, battleType == RaceModel.RaceXcp)
    CommonHelper:CSGameObjectSetActive(self.pageXCPCG.gameObject, battleType == RaceModel.RaceXcp)
    UIUtil.ShowCanvasGroup(self.pageCarGodCG, battleType == RaceModel.RaceCarGod)
    CommonHelper:CSGameObjectSetActive(self.pageCarGodCG.gameObject, battleType == RaceModel.RaceCarGod)
    UIUtil.ShowCanvasGroup(self.pageStoryRewardCG, battleType == RaceModel.Battle or battleType==RaceModel.NewBieChapter or battleType==RaceModel.RaceSelfChapter or battleType==RaceModel.RaceSeniorTrain)
    CommonHelper:CSGameObjectSetActive(self.pageStoryRewardCG.gameObject, battleType == RaceModel.Battle or battleType==RaceModel.NewBieChapter or battleType==RaceModel.RaceSelfChapter or battleType==RaceModel.RaceSeniorTrain)
end

function PageBattleResult:InitRewardInfo()
    ---@type BattleResultPlayerData
    local playerDataList = self.battleResultData:GetPlayerList()
    playerDataList = playerDataList[self.selfIndex]

    local battleType = BattleDataManager:Get():GetBattleType()

    local isFail = playerDataList:GetRank() ~= 1 or playerDataList:GetError() ~= BattleFailError.None or playerDataList:GetTime() == 0

    self:InitCanvasGroup(battleType)

    self:InitBattleResult(battleType, isFail, playerDataList)
end

---@param playerData BattleResultPlayerData
---@param battleType RaceModel
function PageBattleResult:InitBattleResult(battleType, isFail, playerData)
    if battleType == RaceModel.Battle or battleType==RaceModel.NewBieChapter or battleType==RaceModel.RaceSelfChapter or battleType==RaceModel.RaceSeniorTrain then
        self:StoryReward_InitResultInfo(isFail,playerData,self.Page_BattleResultRank)
    elseif battleType == RaceModel.RaceRoom then
        self:Race_InitResultInfo()
    elseif battleType == RaceModel.RaceJcp then
        self:JCP_InitResultInfo(playerData)
    elseif battleType == RaceModel.RaceXcp then
        self:XCP_InitResultInfo(playerData)
    elseif battleType == RaceModel.RaceRank then
        self:Rank_InitResultInfo(playerData)
    elseif battleType == RaceModel.RaceTrot then
        self:Trot_InitResultInfo(playerData)
   elseif battleType == RaceModel.RaceClub3v3 then
        self:Club3V3_InitResultInfo(playerData)
    elseif battleType == RaceModel.RaceGVG then
        self:RaceGVG_InitResultInfo(playerData)
    elseif battleType == RaceModel.RaceCarGod then
        self:CarGod_InitResultInfo(isFail,playerData,self.Page_BattleResultRank)
    else
        self:Reward_InitResultInfo(isFail)
    end
end


function PageBattleResult:InitBaseData(parentPref, msg, isWin)
    print("奖励信息----------")

    local playerLv = PlayerDataManager:Get():GetPlayerLV()

    ---@type dictlevelup_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.levelup_config, playerLv)

    local nextCfg = CommonHelper:GetTableDataByID(ConfigNames.levelup_config, playerLv + 1)

    local totalExp = nextCfg == nil and 99999 or cfg.needexp

    local curExp = PlayerDataManager:Get():GetPlayerEXP()

    local expStr = nil

    if nextCfg == nil then
        expStr = CommonHelper:GetTempStr_Default(TemplateStringID.FullLevel)
    else
        expStr = totalExp - curExp
    end

    CommonHelper:SetText("###NextExpCountText", parentPref, expStr)


    --local gold = self:GetAwardGold(result.currency)

    CommonHelper:SetText("###ExpCountText", parentPref, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "+", (isWin and msg ~= nil and msg.addExp~=nil) and tostring(msg.addExp) or 0))
    --CommonHelper:SetText("GoldCountText", self.pageStoryRewardCG.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "x", tostring(gold)))
    local strLv = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "Lv:", tostring(playerLv))
    CommonHelper:SetText("###LevelCountText", parentPref, strLv)
    CommonHelper:SetSlider("SliderGradientYellow", parentPref,0)
    CommonHelper:SetSliderAni("SliderGradientYellow", parentPref, curExp / totalExp)
end
function PageBattleResult:CheckFirstError()
    local PlayerData=BattleDataManager:Get():GetDefaultPlayerBattleResultData()
    if PlayerData and PlayerData:GetError() and PlayerData:GetError()>BattleFailError.None then
        if not PlayerPrefsHelper:GetValue_PlayerBattleError() then
            print("第一次失败")
            --PlayerPrefsHelper:SetValue_PlayerBattleError(1)
            --GuideManager:Get():Init(GuideState.GuideStateFirstError,true)
            --GuideManager:Get():Execute(self.View.gameObject.name,GuideTriggerType.BattleError)
        end
    end
end






