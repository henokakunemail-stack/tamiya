



local __TogIdxJoin = 1
local __TogIdxCreate = 2


---@class RaceSelfHistoryView : ViewBase
RaceSelfHistoryView = class("RaceSelfHistoryView", ViewBase)

function RaceSelfHistoryView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfHistoryViewAction")
end

function RaceSelfHistoryView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    self.TogJoinList = CommonHelper:HButtonSetCallback("TogJoinList",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfHistoryView_ClickTog, __TogIdxJoin)
    end)
    self.TogCreateList = CommonHelper:HButtonSetCallback("TogCreateList",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfHistoryView_ClickTog, __TogIdxCreate)
    end)


    self.ScrollViewJoin = UIUtil.GetTypeChildWightInputPath("JoinList/MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
    self.ScrollViewCreate = UIUtil.GetTypeChildWightInputPath("CreateList/MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))


end

function RaceSelfHistoryView:OnOpen()
    ---@type table<number, RaceSelfData>
    self.JoinList = {}
    ---@type table<number, RaceSelfData>
    self.CreateList = {}
end

function RaceSelfHistoryView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceSelfHistory)
end

---@param msg SC_SC_GetGameHistoryRes
function RaceSelfHistoryView:SetData(msg)
    ---@type table<number, RaceSelfData>
    self.JoinList = {}
    for i = 1, #msg.joinInfos do
        local data = RaceSelfData()
        data:SetMiniBaseData(msg.joinInfos[i])
        table.insert(self.JoinList, data)
    end

    ---@type table<number, RaceSelfData>
    self.CreateList = {}
    for i = 1, #msg.createInfos do
        local data = RaceSelfData()
        data:SetMiniBaseData(msg.createInfos[i])
        table.insert(self.CreateList, data)
    end


    self:AutoSelect()
end

function RaceSelfHistoryView:AutoSelect()
    self:OnClickTog(__TogIdxJoin)
end

function RaceSelfHistoryView:OnClickTog(idx)
    CommonHelper:SetToggleState(self.TogJoinList, idx == __TogIdxJoin, true)
    CommonHelper:SetToggleState(self.TogCreateList, idx == __TogIdxCreate, true)

    CommonHelper:SetGameObjectActive("JoinList", self.gameObject, idx == __TogIdxJoin)
    CommonHelper:SetGameObjectActive("CreateList", self.gameObject, idx == __TogIdxCreate)
    if idx == __TogIdxJoin then
        self:SetJoinList()
    end
    if idx == __TogIdxCreate then
        self:SetCreateList()
    end
end

----------------------------------------------------参加过得赛事
function RaceSelfHistoryView:SetJoinList()
    CommonHelper:InitMoreRowScrollView(self.ScrollViewJoin, #self.JoinList, 1,function(dataIndex, itemObj, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfHistoryView_UpdateScrollJoin, {dataIndex, itemObj})
    end)

end

function RaceSelfHistoryView:UpdateScrollJoin(dataIndex, itemObj)
    local data = self.JoinList[dataIndex + 1]

    CommonHelper:SetText("racename", itemObj, data.Name)
    CommonHelper:SetText("playername", itemObj, data.Creater)
    CommonHelper:GetComponentSetUITexture("RawIcon",itemObj,data.CreaterIcon, UIModuleID.RaceSelfHistory)

    local endtime = data:GetEndDateTime()
    local str = string.format("%04d-%02d-%02d %02d:%02d",endtime.Year, endtime.Month, endtime.Day, endtime.Hour, endtime.Minute)
    CommonHelper:SetText("time", itemObj, str)

    CommonHelper:HButtonSetCallback("BtnInfo",itemObj,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfHistoryView_ClickItemJoin, hbtn.intData)
    end, dataIndex)
end

function RaceSelfHistoryView:ClickItemJoin(dataIndex)
    local data = self.JoinList[dataIndex + 1]

    RaceSelfManager:Get():TryOpenRaceInfo(data.ID, RaceSelfUIFlag.Joiner)
end
----------------------------------------------------参加过得赛事



----------------------------------------------------创建过得赛事
function RaceSelfHistoryView:SetCreateList()
    CommonHelper:InitMoreRowScrollView(self.ScrollViewCreate, #self.CreateList, 1,function(dataIndex, itemObj, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfHistoryView_UpdateScrollCreate, {dataIndex, itemObj})
    end)

end

function RaceSelfHistoryView:UpdateScrollCreate(dataIndex, itemObj)
    local data = self.CreateList[dataIndex + 1]

    CommonHelper:SetText("racename", itemObj, data.Name)
    CommonHelper:SetText("playername", itemObj, data.Creater)
    CommonHelper:GetComponentSetUITexture("RawIcon",itemObj,data.CreaterIcon, UIModuleID.RaceSelfHistory)
    CommonHelper:SetText("maxcount", itemObj, tostring(data.JoinNum))
    CommonHelper:SetGameObjectActive("statenormal",itemObj,data:GetRaceState() == RaceSelfState.Result)
    CommonHelper:SetGameObjectActive("stateerror",itemObj,data:GetRaceState() == RaceSelfState.Break)

    local endtime = data:GetEndDateTime()
    local str = string.format("%04d-%02d-%02d %02d:%02d",endtime.Year, endtime.Month, endtime.Day, endtime.Hour, endtime.Minute)
    CommonHelper:SetText("time", itemObj, str)

    CommonHelper:HButtonSetCallback("BtnInfo",itemObj,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfHistoryView_ClickItemCreate, hbtn.intData)
    end, dataIndex)
end

function RaceSelfHistoryView:ClickItemCreate(dataIndex)
    local data = self.CreateList[dataIndex + 1]
    RaceSelfManager:Get():TryOpenRaceInfo(data.ID, RaceSelfUIFlag.Creater)
end
----------------------------------------------------创建过得赛事