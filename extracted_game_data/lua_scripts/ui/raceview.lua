---@class RaceView:ViewBase
RaceView = class("RaceView", ViewBase)

function RaceView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceViewAction")
end

function RaceView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(false)
    end)
   CommonHelper:HButtonSetCallback("BtnRaceRoom", self.gameObject, function(param)
       FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceRoom)
    end)
    CommonHelper:HButtonSetCallback("BtnRaceRank", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.PVPRank)
    end)
    CommonHelper:HButtonSetCallback("BtnRaceSelfChapter", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.SelfChapter)
    end)
    CommonHelper:HButtonSetCallback("BtnRaceSelfLevel", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.SelfRace)
    end)

    CommonHelper:HButtonSetCallback("BtnTrackEdit", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.SelfTrack)
    end)
    self.BtnRaceTrot=CommonHelper:HButtonSetCallback("BtnRaceTrot", self.gameObject, function(hbtn)
        cs_coroutine.start(function()
            if CommonHelper:CheckPlayerIsNewGuide() then
                coroutine.yield()
                coroutine.yield()
            end
            FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceTrot)
        end)

    end)

    CommonHelper:HButtonSetCallback("BtnRaceCarGod", self.gameObject, function(param)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceCarGod)
    end)
    CommonHelper:HButtonSetCallback("BtnRaceServer", self.gameObject, function(param)
        --FunctionSkipManager:Get():SkipToFunction(GameFunction.ActAdvanceNotice)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.ActProclamation, { 2, 2 })

    end)
    --CommonHelper:HButtonSetCallback("BtnRaceClubActive", self.gameObject, function(hbtn)
    --    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FunctionNoWait))
    --    --if ClubDataManager:Get():IsHadClub() then
    --    --    if not RaceRankManager:Get():IsMatching() then
    --    --        ClubRaceSelfChapterSubsystem:Get():SendMsg_GetAllSelfChapter(0)
    --    --    end
    --    --else
    --    --    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default("未加入俱乐部"))
    --    --end
    --end)
    --CommonHelper:HButtonSetCallback("BtnRaceClubLevel", self.gameObject, function(hbtn)
    --    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FunctionNoWait))
    --    --if ClubDataManager:Get():IsHadClub() then
    --    --    if not RaceRankManager:Get():IsMatching()  then
    --    --        ClubRaceSelfLevelSubsystem:Get():SendMsg_SelfLevelGetList(0)
    --    --    end
    --    --else
    --    --    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default("未加入俱乐部"))
    --    --end
    --
    --end)
end
function RaceView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end
function RaceView:OnOpen()
    local flag1,data1 = RaceActManager:Get():GetRaceInfo(RaceActId.RaceTrot,false,true)
    if data1 then
        CommonHelper:SetText("tweenracetrot/Bg/###pvptime", self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceActTimeFormat,data1.BeginTime.Year,data1.BeginTime.Month,data1.BeginTime.Day,data1.BeginTime.Hour,data1.BeginTime.Second,data1.EndTime.Year,data1.EndTime.Month,data1.EndTime.Day,data1.EndTime.Hour,data1.EndTime.Second))
        CommonHelper:SetText("Bg/###pvptime", self.gameObject,"")
    else
        CommonHelper:SetText("tweenracetrot/Bg/###pvptime", self.gameObject,"")
    end

    local score = RaceRankManager:Get():GetScore()
    ---@type qualifyingrank_config_cell
    local curcfg, minscore, maxscore = CommonHelper:GetRankCfgByScore(score)
    local process = (score - minscore) / (maxscore - minscore)
    if score > maxscore then
        CommonHelper:SetSlider("scoreslider", self.gameObject, 1)
        CommonHelper:SetText("###scoreprocess", self.gameObject, score)
    else
        CommonHelper:SetSlider("scoreslider", self.gameObject, process)
        CommonHelper:SetText("###scoreprocess", self.gameObject, (score - minscore) .. "/" .. (maxscore - minscore))
    end

    CommonHelper:SetRankIconGroup("rankicon_s_3", self.gameObject, curcfg)
    CommonHelper:SetRankIconGroup("rankicon_s_4", self.gameObject, curcfg)

    CommonHelper:SetText("###challengeNumText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum, RaceRankManager:Get():GetCurRaceRankTime(), RaceRankManager:Get():GetMaxRaceRankTime()))
end

