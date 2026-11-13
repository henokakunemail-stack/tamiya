


---@class RaceRankJoinView : ViewBase
RaceRankJoinView = class("RaceRankJoinView", ViewBase)

function RaceRankJoinView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRankJoinViewAction")

    self.TimerID = -1
    self.Time = 0
    ---@type SC_RaceInfo[]
    self.MsgData = nil
end

function RaceRankJoinView:Awake()
    self.BtnJoin = CommonHelper:HButtonSetCallback("BtnJoin",self.gameObject,function (hbtn)
        RaceRankSubsystem:Get():SendMsg_JoinRoom()
        CommonHelper:SetHButtonClick(self.BtnJoin, false, true)
        self:SetPlayerState(PlayerDataManager:Get():GetPlayerRID())
        RaceRankManager:Get():SetMatchAgree(true)
    end)

    self.PlayerGroup = {}
    for i = 1, 5 do
        self.PlayerGroup[i] = UIUtil.GetChild("player"..i,self.gameObject)
    end
end

function RaceRankJoinView:OnOpen()
    CommonHelper:SetHButtonClick(self.BtnJoin, true, true)
end

function RaceRankJoinView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceRankJoin)
    self:StopTimer()
    self:StopErrorTimer()
end

function RaceRankJoinView:OnAutoClose()
    self:StopTimer()
    self:StopErrorTimer()
end

---@param info SC_RetPVPMatchSucc
function RaceRankJoinView:SetData(info)
    local races=info.race
    self.MsgData = {}
    for i = 1, #races do
        if races[i].rid == PlayerDataManager:Get():GetPlayerRID() then
            table.insert(self.MsgData, 1, races[i])
        else
            table.insert(self.MsgData, races[i])
        end
    end
    self.Time = info.sureTime
    self:StartTimer()
    self:SetPlayers()
    CommonHelper:SetHButtonClick(self.BtnJoin, false, true)
    --cs_coroutine.start(function()
    --    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
    --    RaceRankSubsystem:Get():SendMsg_JoinRoom()
    --    self:SetPlayerState(PlayerDataManager:Get():GetPlayerRID())
    --    RaceRankManager:Get():SetMatchAgree(true)
    --end)

end

function RaceRankJoinView:SetTime()
    local temp = ClientDataManager:Get():GetTemplateString(TemplateStringID.RaceRankJoinTimeFromat)
    local time=self.Time
    if time<0 then
        time=0
    end
    CommonHelper:SetText("###waitingvalue", self.gameObject,  string.format(temp,math.modf(time)))
end


function RaceRankJoinView:SetPlayers()
    for i = 1, #self.PlayerGroup do
        CommonHelper:SetGameObjectActive("notready", self.PlayerGroup[i],self.MsgData[i]~=nil)
    end
    local icon = CommonHelper:GetPlayerIconById(self.MsgData[1].headicon)
    CommonHelper:GetComponentSetUITexture("icon",self.PlayerGroup[1], icon, UIModuleID.RaceRankJoin)
    for i = 2, #self.MsgData do
        local headicon=self.MsgData[i].headicon
        if self.MsgData[i].headicon==0 then
            headicon=math.random(1,82)
        end
        local icon = CommonHelper:GetPlayerIconById(headicon)
        CommonHelper:GetComponentSetUITexture("Image",self.PlayerGroup[i], icon, UIModuleID.RaceRankJoin)
        CommonHelper:SetGameObjectActive("Image",self.PlayerGroup[i],headicon~=0)
        CommonHelper:SetGameObjectActive("npc",self.PlayerGroup[i],false)
    end
    for i = 1, #self.MsgData do
        local temp = self.MsgData[i]
        local obj = self.PlayerGroup[i]
        if temp.headicon == 0 then
            cs_coroutine.start(function(obj)
                local time=math.random(1,4)
                coroutine.yield(CS.UnityEngine.WaitForSeconds(time))
                local num=math.random(1,3)
                CommonHelper:SetGameObjectActive("notready", obj, num==2)
            end,obj)

        end
    end
end

function RaceRankJoinView:SetPlayerState(pid)
    if pid==PlayerDataManager:Get():GetPlayerRID() then
        self:StopTimer()
    end
    for i = 1, #self.MsgData do
        local temp = self.MsgData[i]
        local obj = self.PlayerGroup[i]
        if temp.rid == pid then
            CommonHelper:SetGameObjectActive("notready", obj, false)
            break
        end
    end
end








function RaceRankJoinView:StartTimer()
    self:StopTimer()
    self.TimerID = TimerManager:Get():CreateTimerLoop(1, function()
        self:TimerGoing()
    end)
end

function RaceRankJoinView:TimerGoing()
    self.Time = self.Time -1
    self:SetTime()
    if self.Time < 0 then
        self:StopTimer()
        self:StartErrorTimer()
    end
end

function RaceRankJoinView:StopTimer()
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = -1
end



function RaceRankJoinView:StartErrorTimer()
    CommonHelper:PlayScreenEffectWaiting(true)
   -- CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ServerDateError))
   -- UIManager:Get():HidePersistentView("RaceRankJoinView")
    --self:StopErrorTimer()
    --self.ErrorTimer = TimerManager:Get():CreateTimerLoop(5, function()
    --    logError("---   RaceRankJoinView    超时，服务器异常")
    --    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ServerDateError))
    --    UIManager:Get():HidePersistentView("RaceRankJoinView")
    --    self:StopErrorTimer()
    --end)
end
function RaceRankJoinView:StopErrorTimer()
    TimerManager:Get():StopTimer(self.ErrorTimer)
end