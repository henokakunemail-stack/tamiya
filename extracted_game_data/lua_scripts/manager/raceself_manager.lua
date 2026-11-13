

local __instance
---@class RaceSelfManager
RaceSelfManager = class("RaceSelfManager")
function RaceSelfManager:initialize()
    ---@type RaceSelfData
    self.JoinData = nil
    ---@type RaceSelfData
    self.CreateData = nil
end
---@return RaceSelfManager
function RaceSelfManager:Get()
    if __instance == nil then
        __instance = RaceSelfManager()
    end
    return __instance
end

---@return RaceSelfData
function RaceSelfManager:GetJoinData() return self.JoinData end
---@return RaceSelfData
function RaceSelfManager:GetCreateData() return self.CreateData end

function RaceSelfManager:GetJoinRaceID()
    if self.JoinData then return self.JoinData.ID end
    return -1
end
function RaceSelfManager:GetCreateRaceID()
    if self.CreateData then return self.CreateData.ID end
    return -1
end





---@param msg SC_SC_MiniGameInfo
function RaceSelfManager:SetJoinMiniData(msg)
    if msg == nil then
        self.JoinData = nil
    else
        self.JoinData = RaceSelfData()
        self.JoinData:SetMiniBaseData(msg)
    end
end

---@param msg SC_SC_GameInfo
function RaceSelfManager:SetJoinBaseData(msg)
    if msg == nil then
        self.JoinData = nil
    else
        self.JoinData = RaceSelfData()
        self.JoinData:SetData(msg)
    end
end




function RaceSelfManager:SetCreateData(msg)
    if msg == nil then
        self.CreateData = nil
    else
        self.CreateData = RaceSelfData()
        self.CreateData:SetMiniBaseData(msg)
    end
end
---@param msg SC_SC_GameInfo
function RaceSelfManager:SetCreateBaseData(msg)
    if msg == nil then
        self.CreateData = nil
    else
        self.CreateData = RaceSelfData()
        self.CreateData:SetData(msg)
    end
end
















function RaceSelfManager:TryOpenRaceInfo(id, flag)
    RaceSelfSubsystem:Get():SendMsg_GetRaceStateInfo(id, flag)
end
---@param msg SC_SC_GetGameStageInfoRes
function RaceSelfManager:OpenRaceStateUI(msg)

    local racedata = RaceSelfData()
    racedata:SetData(msg.gameInfo)
    racedata:AnalyseMsg(msg)


    local state = racedata:GetMyState()
    if not racedata:GetIsJoin() then
        state = racedata:GetRaceState()
    end

    if state == RaceSelfState.Join then
        UIManager:Get():OpenView("RaceSelfJoinView",CanvasType.MainCanvas,"RaceSelfJoinView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfJoinView_SetData, racedata)
    end

    if state == RaceSelfState.Select then
        UIManager:Get():OpenView("RaceRuleSiftView",CanvasType.MainCanvas,"RaceRuleSiftView")
        local param = RaceRuleSiftViewParam()
        param.Type = RaceRuleModule.Self
        param.RaceSelfData = racedata
        param.Title = racedata.Name
        param.MyData = racedata:GetMyPlayerData()
        local playerlist = {}
        for k,v in pairs(racedata:GetPlayerList()) do table.insert(playerlist, v:GetPlayerData()) end
        param.PlayerList = playerlist
        if racedata:GetIsJoin() then param.PlayerIdentity = RaceRulePlayerIdentity.Joiner end
        UINotify:Get():SendNotification(UINotifyEvent.RaceRuleSiftView_SetData, param)
    end

    if state == RaceSelfState.Knockout then
        if racedata:GetIsJoin() then
            UIManager:Get():OpenView("RaceRuleFightGroupView",CanvasType.MainCanvas,"RaceRuleFightGroupView")
            local param = RaceRuleFightGroupViewParam()
            param.Type = RaceRuleModule.Self
            param.PlayerIdentity = RaceRulePlayerIdentity.Joiner
            param.Title = racedata.Name
            local player = racedata:GetMyPlayerData()
            param.FightGroup = player:GetKnockoutGroup()
            param.RaceSelfData = racedata
            UINotify:Get():SendNotification(UINotifyEvent.RaceRuleFightGroupView_SetData, param)
        else
            UIManager:Get():OpenView("RaceRuleFightGroupListView",CanvasType.MainCanvas,"RaceRuleFightGroupListView")
            local param = RaceRuleFightGroupListViewParam()
            param.Type = RaceRuleModule.Self
            param.Title = racedata.Name
            param.GroupList = racedata:GetFightGroupKnockout()
            param.RaceSelfData = racedata
            UINotify:Get():SendNotification(UINotifyEvent.RaceRuleFightGroupListView_SetData, param)
        end
    end

    if state == RaceSelfState.SemiFinal then
        if racedata:GetIsJoin() then
            UIManager:Get():OpenView("RaceRuleFightGroupView",CanvasType.MainCanvas,"RaceRuleFightGroupView")
            local param = RaceRuleFightGroupViewParam()
            param.Type = RaceRuleModule.Self
            param.PlayerIdentity = RaceRulePlayerIdentity.Joiner
            param.Title = racedata.Name
            local player = racedata:GetMyPlayerData()
            param.FightGroup = player:GetSemiFinalGroup()
            param.RaceSelfData = racedata
            UINotify:Get():SendNotification(UINotifyEvent.RaceRuleFightGroupView_SetData, param)
        else
            UIManager:Get():OpenView("RaceRuleFightGroupListView",CanvasType.MainCanvas,"RaceRuleFightGroupListView")
            local param = RaceRuleFightGroupListViewParam()
            param.Type = RaceRuleModule.Self
            param.Title = racedata.Name
            param.GroupList = racedata:GetFightGroupSemiFinal()
            param.RaceSelfData = racedata
            UINotify:Get():SendNotification(UINotifyEvent.RaceRuleFightGroupListView_SetData, param)
        end
    end

    if state == RaceSelfState.Finals then
        UIManager:Get():OpenView("RaceRuleFightGroupView",CanvasType.MainCanvas,"RaceRuleFightGroupView")
        local param = RaceRuleFightGroupViewParam()
        param.Type = RaceRuleModule.Self
        if racedata:GetIsJoin() then param.PlayerIdentity = RaceRulePlayerIdentity.Joiner end
        param.Title = racedata.Name
        param.IsShowCup = true
        param.FightGroup = racedata:GetFightGroupFinals()
        param.RaceSelfData = racedata
        UINotify:Get():SendNotification(UINotifyEvent.RaceRuleFightGroupView_SetData, param)

    end

    if state == RaceSelfState.Result then
        UIManager:Get():OpenView("RaceRuleResultView",CanvasType.MainCanvas,"RaceRuleResultView")
        local param = RaceRuleResultViewParam()
        param.Type = RaceRuleModule.Self
        param.RaceSelfData = racedata
        param.Title = racedata.Name
        param.Winer = racedata:GetWiner()
        param.ScoreTips = racedata:GetResultScoreTips()
        if racedata:GetIsJoin() then param.PlayerIdentity = RaceRulePlayerIdentity.Joiner end
        UINotify:Get():SendNotification(UINotifyEvent.RaceRuleResultView_SetData, param)
    end

    if state == RaceSelfState.Break then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.RaceSelfRaceError))
    end


end

