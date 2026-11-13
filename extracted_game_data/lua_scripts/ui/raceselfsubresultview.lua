---@class RaceSelfSubResultUIData
RaceSelfSubResultUIData = class("RaceSelfSubResultUIData", ViewBase)
function RaceSelfSubResultUIData:initialize()
    self.ID = 0
    self.Rank = 0
    self.Name = ""
    self.Time = ""
    self.ClubName = ""
    ---@type table<number, SC_PartInfo>
    self.MsgCarData = nil
    self.CarName = ""
    self.TrackIdx = 0
    self.Error = 0
    self.QualifyRank = 1
end

function RaceSelfSubResultUIData:SetData(id, rank, name, time, clubname, trackidx, shellid, msgcardata, error, qualifyRank)
    self.ID = id
    self.Rank = rank
    self.Name = name
    self.Time = time
    self.ClubName = clubname
    self.TrackIdx = trackidx
    ---@type table<number, SC_PartInfo>
    self.MsgCarData = msgcardata
    self.Error = error
    self.QualifyRank = qualifyRank

    if shellid > 0 then
        ---@type parts_config_cell
        local partcfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, shellid)
        ---@type dictpartbase_config_cell
        local partBaseCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, partcfg.baseid)
        ---@type carshell_config_cell
        local shellcfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartcell_config, partBaseCfg.NewShellId)
        self.CarName = ClientDataManager:Get():GetTemplateString(shellcfg.carNameid)
    end
end

---@class RaceSelfSubResultView : ViewBase
RaceSelfSubResultView = class("RaceSelfSubResultView", ViewBase)

function RaceSelfSubResultView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfSubResultViewAction")
end

function RaceSelfSubResultView:Awake()

    --self.BtnReplay = CommonHelper:HButtonSetCallback("BtnReplay", self.gameObject, function(hbtn)
    --
    --end)

    self.BtnBack = CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        self:OnBackBtnClick()
    end)

    ---@type table<number, PVPRankResultUIData>
    self.ResultList = {}
end

function RaceSelfSubResultView:OnOpen()
     self:InitPvPCompareView()

    -- self:SetData()

    self:SetBtn()

   --  self:SetRankList()
end

function RaceSelfSubResultView:OnBackBtnClick()

    if BattleDataManager:Get():IsReplay() then
        UIManager:Get():OpenView("RaceSelfHistoryView", CanvasType.MainCanvas, "RaceSelfHistoryView")
        RaceSelfSubsystem:Get():SendMsg_History()
    else
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToRaceSelf)
    end
    BattleDataManager:Get():SetStateBattleExit()
end

----------------------------------详情界面
local _btnIndex = 0
function RaceSelfSubResultView:InitPvPDetailView()
    self.PvPDetailCanvasGroup = self:GetChildWightByParent("PVPDetailView", self.gameObject, typeof(CanvasGroup))
    self.BtnCompare = CommonHelper:HButtonSetCallback("BtnCompare", self.PvPDetailCanvasGroup.gameObject, function()
        local data = self.ResultList[_btnIndex]
        UIUtil.ShowCanvasGroup(self.PvPCompareCanvasGroup, true)
        self:SetPvPCompareViewData()
        CSLuaHelper.BattleCompareResult(data.ID)
    end)
    self.BtnCarInfo = CommonHelper:HButtonSetCallback("BtnCarInfo", self.PvPDetailCanvasGroup.gameObject, function()
        self:OnClickBtn_CarInfo(_btnIndex)
    end)
    CommonHelper:HButtonSetCallback("BgBtn", self.PvPDetailCanvasGroup.gameObject, function()
        UIUtil.ShowCanvasGroup(self.PvPDetailCanvasGroup, false)
    end)
    UIUtil.ShowCanvasGroup(self.PvPDetailCanvasGroup, false)
end

function RaceSelfSubResultView:UpdatePvPDetailView()
    UIUtil.ShowCanvasGroup(self.PvPDetailCanvasGroup, true)
    if _btnIndex > 0 then
        local data = self.ResultList[_btnIndex]
        if data.ID == PlayerDataManager:Get():GetPlayerUID() then
            CommonHelper:SetHButtonClick(self.BtnCompare, false, true)
        else
            CommonHelper:SetHButtonClick(self.BtnCompare, true, true)
        end
    end
end

function RaceSelfSubResultView:SetPvPDetailViewData(btnIndex)
    _btnIndex = btnIndex
end

local _selfBtnIndex = 0
----------------------------------车辆对比界面
function RaceSelfSubResultView:InitPvPCompareView()
    self.PvPCompareCanvasGroup = self:GetChildWightByParent("PVPCompareView", self.gameObject, typeof(CanvasGroup))
    self.SceneRawImage = self:GetChildWightByParent("SceneRawImage", self.PvPCompareCanvasGroup.gameObject, typeof(RawImage))
    self.Record_1 = self:GetChildByParent("Record_1", self.PvPCompareCanvasGroup.gameObject)
    self.Record_2 = self:GetChildByParent("Record_2", self.PvPCompareCanvasGroup.gameObject)
    self.TrackImages_1 = self:InitPvPCompareTrackImage(self.Record_1)
    self.TrackImages_2 = self:InitPvPCompareTrackImage(self.Record_2)
    CommonHelper:HButtonSetCallback("BtnBack", self.PvPCompareCanvasGroup.gameObject, function()
        UIUtil.ShowCanvasGroup(self.PvPCompareCanvasGroup, false)
        CSLuaHelper.OnBattleCompareResultExit()
        CSLuaHelper.ReleaseBattleCompareRenderTexture()
    end)
    UIUtil.ShowCanvasGroup(self.PvPCompareCanvasGroup, false)
end
function RaceSelfSubResultView:SetPvPCompareViewData()
    local rawTexture = CSLuaHelper.GetBattleCompareRenderTexture()
    self.SceneRawImage.texture = rawTexture

    local Record_1_data = self.ResultList[_selfBtnIndex]
    CommonHelper:GetComponentTransferTime("RecordTimeText", self.Record_1, Record_1_data.Time)
    self:SetPvPCompareTrackImage(self.TrackImages_1, Record_1_data.TrackIdx)

    local Record_2_data = self.ResultList[_btnIndex]
    CommonHelper:GetComponentTransferTime("RecordTimeText", self.Record_2,Record_2_data.Time)
    CommonHelper:SetText("CompareNameText", self.Record_2, Record_2_data.Name)
    self:SetPvPCompareTrackImage(self.TrackImages_2, Record_2_data.TrackIdx)
end

function RaceSelfSubResultView:InitPvPCompareTrackImage(parent)
    local TrackImages = {}
    for i = 1, 5 do
        local image = self:GetChildByParent(tostring(i), parent)
        table.insert(TrackImages, image)
    end
    return TrackImages
end
function RaceSelfSubResultView:SetPvPCompareTrackImage(trackImages, trackIndex)
    for i = 1, 5 do
        if i == trackIndex then
            trackImages[i].gameObject:SetActive(true)
        else
            trackImages[i].gameObject:SetActive(false)
        end
    end
end

function RaceSelfSubResultView:OnClose()

end

function RaceSelfSubResultView:SetRankResultUIData(playerDataList)
    local resultList = {}
    local loop = #playerDataList
    for i = 1, loop do
        -----@type SC_RcPlayer
        --local temp = playerDataList[i]
        --local data = RaceSelfSubResultUIData()
        --local shellId = 0
        --if temp.partInfos[4] ~= nil then
        --    shellId = temp.partInfos[4].cId
        --else
        --end
        --if temp.pid == PlayerDataManager:Get():GetPlayerID() then
        --    _selfBtnIndex = i
        --end
        --data:SetData(temp.pid, temp.rank, temp.name, temp.time, "", temp.trackId, shellId, temp.partInfos, temp.error, temp.num1)
        --table.insert(resultList, data)
    end
    return resultList
end

function RaceSelfSubResultView:SetData()
    self.ResultList = {}

    ---@type BattleResultData
    local data = BattleDataManager:Get():GetBattleResultData()
    if BattleDataManager:Get():IsReplay() then
        self.ResultList = self:SetRankResultUIData(data.RaceSelfMsgData.PlayerList)
    else
        self.ResultList = self:SetRankResultUIData(data.RaceSelfMsgData.record.rcPlayers)
    end

    table.sort(self.ResultList, function(a, b)
        return a.Rank < b.Rank
    end)
end

function RaceSelfSubResultView:SetBtn()
    --CommonHelper:SetHButtonClick(self.BtnReplay,not  BattleDataManager:Get():IsReplay(), true)
end

function RaceSelfSubResultView:SetRankList()
    local isSelfFlyOut = self.ResultList[_selfBtnIndex].Error ~= BattleFailError.None
    for i = 1, 5 do
        local obj = UIUtil.GetChild("rank" .. i, self.gameObject)
        local data = self.ResultList[i]
        if data then
            obj:SetActive(true)
            CommonHelper:SetText("playername", obj, data.Name)
            CommonHelper:SetText("clubname", obj, data.ClubName)
            local BtnCompare = self:GetChildWightByParent("BtnCompare", obj, typeof(HButton))

            if isSelfFlyOut then
                CommonHelper:SetHButtonClick(BtnCompare, false, true)
            else
                CommonHelper:SetHButtonClick(BtnCompare, data.CarName ~= "", true)
                CommonHelper:SetHButtonClick(BtnCompare, data.ID ~= PlayerDataManager:Get():GetPlayerRID(), true)
            end
            if data.Error == BattleFailError.None then
                CommonHelper:GetComponentTransferTime("time", obj, data.Time)
            else
                CommonHelper:SetText("time", obj, CommonHelper:GetTempStr_BattleFailErrorTips(data.Error))
                CommonHelper:SetHButtonClick(BtnCompare, false, true)
            end
            CommonHelper:SetText("carname", obj, data.CarName)

            CommonHelper:GetComponentSetImage("trackidx", obj, CommonHelper:GetCarTrackIdxIcon(data.TrackIdx))
            ---@type qualifyingrank_config_cell
            local qualifyRankData = self:GetQualifyRankByIntegral(data.QualifyRank)
            CommonHelper:GetComponentSetImage("rankIcon", obj, qualifyRankData.icon)--设置段位
            CommonHelper:SetText("rankValue", obj, qualifyRankData.name)

            UIUtil.GetChild("select", obj):SetActive(data.ID == PlayerDataManager:Get():GetPlayerID())
            local BtnCarInfo = self:GetChildWightByParent("BtnCarInfo", obj, typeof(HButton))
            CommonHelper:SetHButtonClick(BtnCarInfo, data.CarName ~= "", true)

            CommonHelper:HButtonSetCallback("BtnCarInfo", obj, function(hbtn)
                self:OnClickBtn_CarInfo(hbtn.intData)
            end, i)
            CommonHelper:HButtonSetCallback("BtnCompare", obj, function(hbtn)
                self:SetPvPDetailViewData(hbtn.intData)
                local data = self.ResultList[hbtn.intData]
                UIUtil.ShowCanvasGroup(self.PvPCompareCanvasGroup, true)
                self:SetPvPCompareViewData()
                CSLuaHelper.BattleCompareResult(data.ID)
            end, i)

        else
            obj:SetActive(false)
        end
    end
end

function RaceSelfSubResultView:OnClickBtn_CarInfo(idx)
    local data = self.ResultList[idx]
    if data and data.MsgCarData then
        CommonHelper:ShowCarInfoByMsg(data.MsgCarData)
    end
end

function RaceSelfSubResultView:GetQualifyRankByIntegral(integral)
    --根据积分获得该段位数据
    ---@type qualifyingrank_config_cell
    local qualifyRankData = CommonHelper:GetRankCfgByScore(integral)
    return qualifyRankData
end


