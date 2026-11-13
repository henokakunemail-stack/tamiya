

local type = {1,2,3}
local num = {-1,50,100,200}


function RaceSelfCreateView:SetStep2(default)
    self:SetPageGroup(2)

    self.Param_Flag = 0
    self.Param_JoinerMax = 0
    ---@type RaceTrackData
    self.Param_TrackData = nil

    self.Step2_TogType = {}
    for i = 1, 2 do
        self.Step2_TogType[i] = CommonHelper:HButtonSetCallback("TogType"..i,self.Page2,function (hbtn)
            UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_Step2_ClickTogType, hbtn.intData)
        end, i)
    end
    self.Step2_TogNum = {}
    for i = 1, 4 do
        self.Step2_TogNum[i] = CommonHelper:HButtonSetCallback("TogNum"..i,self.Page2,function (hbtn)
            UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_Step2_ClickTogNum, hbtn.intData)
        end, i)
    end

    CommonHelper:HButtonSetCallback("BtnChangeTrack",self.Page2,function (hbtn)
        self:Step2_ClickBtnChange()
    end)

    CommonHelper:HButtonSetCallback("BtnReview",self.Page2,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_Step2_ClickBtnReview)
    end)

    if default then
        self:Step2_ClickTogType(1)
        self:Step2_ClickTogNum(1)
        self:Step2_AutoSelectTrack()
    end


end

function RaceSelfCreateView:Step2_ClickTogType(idx)
    for i = 1, #self.Step2_TogType do
        CommonHelper:SetToggleState(self.Step2_TogType[i], i == idx, true)
    end

    self.Param_Flag = type[idx]
end

function RaceSelfCreateView:Step2_ClickTogNum(idx)
    for i = 1, #self.Step2_TogNum do
        CommonHelper:SetToggleState(self.Step2_TogNum[i], i == idx, true)
    end

    self.Param_JoinerMax = num[idx]
end

function RaceSelfCreateView:Step2_ClickBtnChange()
    --UIManager:Get():OpenPopup("RaceRoomTrackListView",CanvasType.MainCanvas,"RaceRoomTrackListView")
    UIManager:Get():ShowPersistentView("RaceRoomTrackListView",CanvasType.MainCanvas,"RaceRoomTrackListView")
    --UINotify:Get():SendNotification(UINotifyEvent.RaceRoomTrackListView_SetMsgData)
    --UINotify:Get():SendNotification(UINotifyEvent.RaceRoomTrackListView_SetMsgData)
end

---@param data RaceTrackData
function RaceSelfCreateView:Step2_SelectTrack(data)
    self.Param_TrackData = data
    if data then
        CommonHelper:SetText("trackName", self.Page2, data:GetName())
        CommonHelper:SetText("trackLength", self.Page2, data:GetLength())
        CommonHelper:GetComponentSetTrackIconByData("trackIcon", self.Page2, data, UIModuleID.RaceSelfCreate)
    end
end

function RaceSelfCreateView:Step2_ClickBtnReview()
    if self.Param_TrackData then
        CommonHelper:LoadReviewTrack(nil, self.Param_TrackData)
    end
end

---@param cfg racetrack_config_cell
function RaceSelfCreateView:Step2_AutoSelectTrack(cfg)
    if cfg == nil then
        ---@type racetrack_config
        local tab = ClientDataManager:Get():GetDataTable(ConfigNames.racetrack_config)
        local list = tab.GetConfigList()
        cfg = list[1]
    end

    if cfg == nil then
        print("---   RaceSelfCreateView:Step2_SetTrackInfo   cfg == nil")
        return
    end
    local data = CommonHelper:GetRacetrackData(cfg.id)
    self:Step2_SelectTrack(data)
end