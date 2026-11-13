


---@class RaceWeekHistoryViewData
RaceWeekHistoryViewData = class("RaceWeekHistoryViewData")
function RaceWeekHistoryViewData:initialize()
    ---@type RaceWeekData
    self.RaceData = nil
    self.Rank = -1
end




---@class RaceWeekHistoryView : ViewBase
RaceWeekHistoryView = class("RaceWeekHistoryView", ViewBase)

function RaceWeekHistoryView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceWeekHistoryViewAction")
end

function RaceWeekHistoryView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("JoinList/MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))

    ---@type table<number, RaceWeekHistoryViewData>
    self.RaceList = {}
end

function RaceWeekHistoryView:OnOpen()

end

function RaceWeekHistoryView:OnClose()

end

---@param msg table<number,SC_Champ_HisInfo>
function RaceWeekHistoryView:SetData(msg)
    self.RaceList = {}
    for i = 1, #msg do
        local temp = msg[i]
        local racedata = RaceWeekData()
        racedata:SetBaseData(temp.uniqueId, true, -1)
        local data = RaceWeekHistoryViewData()
        data.RaceData = racedata
        data.Rank = temp.rank
        table.insert(self.RaceList, data)
    end

    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.RaceList, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScroll(dataIndex, itemObj)
    end)
end



function RaceWeekHistoryView:UpdateScroll(dataIndex, itemObj)
    local data = self.RaceList[dataIndex + 1]
    local racedata = data.RaceData

    CommonHelper:SetText("racename", itemObj, racedata:GetName())
    CommonHelper:SetText("playername", itemObj, "系统")
    CommonHelper:SetText("rank", itemObj, "第"..data.Rank.."名")
    --CommonHelper:GetComponentSetUITexture("RawIcon",itemObj,data.CreaterIcon, UIModuleID.RaceSelfHistory)

    local endtime = racedata:GetEndTime()
    local str = string.format("%04d-%02d-%02d %02d:%02d",endtime.Year, endtime.Month, endtime.Day, endtime.Hour, endtime.Minute)
    CommonHelper:SetText("time", itemObj, str)

    CommonHelper:HButtonSetCallback("BtnInfo",itemObj,function (hbtn)
        RaceWeekManager:Get():TryOpenRaceInfo(racedata:GetServerID())
    end, dataIndex)
end

