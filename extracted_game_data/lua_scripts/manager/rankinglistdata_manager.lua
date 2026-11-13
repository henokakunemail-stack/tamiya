---@class RankingListDataManager
RankingListDataManager = class("RankingListDataManager")
function RankingListDataManager:initialize()
   ---@type RankingListData[]
   self.RankingList={}
end
function RankingListDataManager:Get()
    if self._instance == nil then
        self._instance = RankingListDataManager()
    end
    return self._instance
end
---@param data SC_RetRank
function RankingListDataManager:Init(data)
    self.Data=RankingListData()
    self.Data:SetData(data)
    self.RankType=self.Data.type
    self.CurGroup=data.myrankgroup
    self.CurShowGroup=data.lookgroup
    self.Group=data.rankgroup

    if self.RankType==RankingListType.Speed then
        self:SetCurRankTracks(data.trackids)
        self:SetCurRankTrack(data.curtrackid)
        if not UIManager:Get():IsPopViewShow("RankingListView") then
            UIManager:Get():OpenPopup("RankingListView",CanvasType.FrontCanvas,"RankingListView")
        end
        UINotify:Get():SendNotification(UINotifyEvent.RankListView_SetData,self.RankType)
        if CommonSubsystem:Get().IsLoadRankData then
            local serverName=PlayerDataManager:Get():GetPlayerServerID()
            CS.MonoHelper.CheckRankListFileExist(tostring(serverName).."_挑战")
            self.Rids=Queue()
            for k, v in pairs(self.Data.RankInfoList) do
                self.Rids:EnQueueBack({v.Id,v.Score,RaceRankManager:Get():GetSessionId(),RaceProtectType.Normal,v.Name,v.Rank})
            end
            self.CurValue= self.Rids:DeQueueFront()
            if self.CurValue then
                CommonSubsystem:SendMsg_RePlayBattle( self.CurValue[1],self.CurValue[3],self.CurValue[4])
            else
                if RankListTestVerifyDataManager:Get():GetIsVerify() then
                    RankListTestVerifyDataManager:Get():LoginRlSpeedRankData()
                    return
                end
            end

        end
    end
    if self.RankType==RankingListType.Score then
        if not UIManager:Get():IsPopViewShow("RankingListView") then
            UIManager:Get():OpenPopup("RankingListView",CanvasType.FrontCanvas,"RankingListView")
        end
        UINotify:Get():SendNotification(UINotifyEvent.RankListView_SetData,self.RankType)
    end
    if self.RankType==RankingListType.MainClub then
        if not UIManager:Get():IsViewShow("MainRankingListView") then
            UIManager:Get():OpenView("MainRankingListView",CanvasType.MainCanvas,"MainRankingListView")
        end
        UINotify:Get():SendNotification(UINotifyEvent.MainRankingListView_SetData,self.RankType)
    end
    if self.RankType==RankingListType.RaceClubAll then

    end
    if self.RankType==RankingListType.MainSpeed then
        self:SetCurRankTracks(data.trackids)
        self:SetCurRankTrack(data.curtrackid)
        if not UIManager:Get():IsViewShow("MainRankingListView") then
            UIManager:Get():OpenView("MainRankingListView",CanvasType.MainCanvas,"MainRankingListView")
        end
        self.SeasonId=data.seasonid
        UINotify:Get():SendNotification(UINotifyEvent.MainRankingListView_SetData,self.RankType)
    end
    if self.RankType==RankingListType.MainRlSpeed then
        if not UIManager:Get():IsViewShow("MainRankingListView") then
            UIManager:Get():OpenView("MainRankingListView",CanvasType.MainCanvas,"MainRankingListView")
        end
        self.SeasonId=data.seasonid
        UINotify:Get():SendNotification(UINotifyEvent.MainRankingListView_SetData,self.RankType)
    end
    if self.RankType==RankingListType.RlSpeed then
        if not UIManager:Get():IsPopViewShow("RankingListView") then
            UIManager:Get():OpenPopup("RankingListView",CanvasType.FrontCanvas,"RankingListView")
        end
        UINotify:Get():SendNotification(UINotifyEvent.RankListView_SetData,self.RankType)
        if CommonSubsystem:Get().IsLoadRankData then
            local serverName=PlayerDataManager:Get():GetPlayerServerID()
            CS.MonoHelper.CheckRankListFileExist(tostring(serverName).."_保护")
            self.Rids=Queue()
            for k, v in pairs(self.Data.RankInfoList) do
                self.Rids:EnQueueBack({v.Id,v.Score,RaceRankManager:Get():GetSessionId(),RaceProtectType.Protect,v.Name})
            end
            self.CurValue= self.Rids:DeQueueFront()
            self.CurValue= self.Rids:DeQueueFront()
            if self.CurValue then
                cs_coroutine.start(function()
                    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
                    CommonSubsystem:SendMsg_RePlayBattle( self.CurValue[1],self.CurValue[3],self.CurValue[4])
                end)
            else
                RankListTestVerifyDataManager:Get():Done()
            end
        end
    end
    --if self.RankType==RankingListType.RaceJCP then
    --    if not UIManager:Get():IsViewShow("RankingListView") then
    --        UIManager:Get():OpenPopup("RankingListView",CanvasType.MainCanvas,"RankingListView")
    --    end
    --    self.SeasonId=data.seasonid
    --    UINotify:Get():SendNotification(UINotifyEvent.RankListView_SetData,self.RankType)
    --end

    if self.RankType==RankingListType.RaceJCP then
        if not UIManager:Get():IsViewShow("RaceJcpRankListView") then
            UIManager:Get():OpenPopup("RaceJcpRankListView",CanvasType.MainCanvas,"RaceJcpRankListView")
        end
        self.SeasonId=data.seasonid
        UINotify:Get():SendNotification(UINotifyEvent.RaceJcpRankListView_SetData)
    end
    if self.RankType==RankingListType.RaceXCP then
        if not UIManager:Get():IsViewShow("RaceXCPRankListView") then
            UIManager:Get():OpenPopup("RaceXCPRankListView",CanvasType.MainCanvas,"RaceXCPRankListView")
        end
        self.SeasonId=data.seasonid
        UINotify:Get():SendNotification(UINotifyEvent.RaceXCPRankListView_SetData)
    end
    if self.RankType==RankingListType.RaceTopA then
        ----if not UIManager:Get():IsViewShow("RaceJcpRankListView") then
        ----    UIManager:Get():OpenPopup("RaceJcpRankListView",CanvasType.MainCanvas,"RaceJcpRankListView")
        ----end
        --self.SeasonId=data.seasonid
        --UINotify:Get():SendNotification(UINotifyEvent.RaceJcpRankListView_SetData)
    end
    if self.RankType==RankingListType.RaceTopSuperA then
        ----if not UIManager:Get():IsViewShow("RaceJcpRankListView") then
        ----    UIManager:Get():OpenPopup("RaceJcpRankListView",CanvasType.MainCanvas,"RaceJcpRankListView")
        ----end
        --self.SeasonId=data.seasonid
        --UINotify:Get():SendNotification(UINotifyEvent.RaceJcpRankListView_SetData)
    end
    if self.RankType==RankingListType.RaceTopB then
        --if not UIManager:Get():IsViewShow("RaceJcpRankListView") then
        --    UIManager:Get():OpenPopup("RaceJcpRankListView",CanvasType.MainCanvas,"RaceJcpRankListView")
        --end
        --self.SeasonId=data.seasonid
        --UINotify:Get():SendNotification(UINotifyEvent.RaceJcpRankListView_SetData)
    end
 if self.RankType==RankingListType.RaceTopSuperB then
        --if not UIManager:Get():IsViewShow("RaceJcpRankListView") then
        --    UIManager:Get():OpenPopup("RaceJcpRankListView",CanvasType.MainCanvas,"RaceJcpRankListView")
        --end
        --self.SeasonId=data.seasonid
        --UINotify:Get():SendNotification(UINotifyEvent.RaceJcpRankListView_SetData)
    end
    if self.RankType==RankingListType.RaceGVG then
        --if not UIManager:Get():IsViewShow("RaceJcpRankListView") then
        --    UIManager:Get():OpenPopup("RaceJcpRankListView",CanvasType.MainCanvas,"RaceJcpRankListView")
        --end
        --self.SeasonId=data.seasonid
        --UINotify:Get():SendNotification(UINotifyEvent.RaceJcpRankListView_SetData)
    end
    if self.RankType==RankingListType.RaceGVGSpeed1 then

    end
    if self.RankType==RankingListType.RaceGVGSpeed2 then

    end
    if self.RankType==RankingListType.RaceGVGSpeed3 then

    end
    if self.RankType==RankingListType.RaceGVGPoint then

    end
end
function RankingListDataManager:GetCurRankType()
    return self.RankType
end
---@return RankingListData
function RankingListDataManager:GetRankingListData()
    return self.Data
end

function RankingListDataManager:GetRankCurGroup()
    return self.CurGroup
end
function RankingListDataManager:GetRankCurShowGroup()
    return self.CurShowGroup
end

function RankingListDataManager:GetAllGroup()
    return self.Group
end
---@type string[]
function RankingListDataManager:SetCurRankTracks(trackids)
     self.CurShowTracks={}
    for i = 1, #trackids do
        table.insert(self.CurShowTracks,trackids[i])
    end
end

function RankingListDataManager:GetCurRankTracks()
    return self.CurShowTracks
end

function RankingListDataManager:SetCurRankTrack(value)
     self.CurTrack=value
end

function RankingListDataManager:GetCurRankTrack()
    if self.RankType==RankingListType.Score then
        return -1
    end
    return self.CurTrack
end





















