


---@class RaceRankHistoryView : ViewBase
RaceRankHistoryView = class("RaceRankHistoryView", ViewBase)

function RaceRankHistoryView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRankHistoryViewAction")

    ---@type table<number, RaceHistoryData>
    self.msgData = {}
end

function RaceRankHistoryView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RaceRankHistoryView:OnOpen()

end

function RaceRankHistoryView:OnClose()

end

---@param msg SC_GetRecordsRes
function RaceRankHistoryView:SetData(msg)
    self.msgData = {}
    for i = 1, #msg.records do
        local temp = RaceHistoryData()
        temp:SetData(msg.records[i], msg.type)
        table.insert(self.msgData, temp)
    end

    table.sort(self.msgData,function (a,b)
        return a.JoinTime > b.JoinTime
    end)


    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.msgData, 1,function(dataIndex, itemObj, scroll)
       self:UpdateScrollView(dataIndex, itemObj)
    end)
end

function RaceRankHistoryView:UpdateScrollView(dataIndex, itemObj)
    local data = self.msgData[dataIndex + 1]

    ---@type RaceHistoryPlayerData
    local selfrank = data:GetMyPlayerData()

    for i = 1, 5 do
        CommonHelper:SetGameObjectActive("rank"..i,itemObj, selfrank.rank == i and selfrank.error == BattleFailError.None)
    end

    local jointime = CommonHelper:ConvertIntToDataTime(data.JoinTime)
    local temp = "%d-%02d-%02d  %02d:%02d:%02d"
    local str = string.format(temp, jointime.Year, jointime.Month, jointime.Day, jointime.Hour, jointime.Minute, jointime.Second)
    CommonHelper:SetText("jointime", itemObj, str )

    CommonHelper:SetText("scorevalue", itemObj, string.format("%+d", selfrank.PVPScoreDelta) )

    if selfrank.error == BattleFailError.None then
        CommonHelper:GetComponentTransferTime("timevalue", itemObj,  selfrank.time)
    else
        CommonHelper:SetText("timevalue", itemObj, "--:--:--" )
    end



    CommonHelper:SetGameObjectActive("rank6",itemObj, selfrank.error ~= BattleFailError.None)
    CommonHelper:SetText("errortips", itemObj, CommonHelper:GetTempStr_BattleFailErrorTips(selfrank.error))

    CommonHelper:HButtonSetCallback("BtnReplay",itemObj,function (hbtn)
        self:ClickBtnReplay(data)
    end)
end

function RaceRankHistoryView:ClickBtnReplay(data)
    if not RaceRankManager:Get():IsMatching() then
        BattleDataManager:Get():SetRoomData(data, RaceModel.RaceRank, true)
        RaceRankManager:Get():LoadBattleScene(nil, data)
    end


end