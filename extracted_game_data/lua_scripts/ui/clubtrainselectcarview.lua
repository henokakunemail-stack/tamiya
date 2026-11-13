---@class ClubTrainSelectCarView : ClubTrainSelectCarBaseView
ClubTrainSelectCarView = class("ClubTrainSelectCarView",  ClubTrainSelectCarBaseView)

function ClubTrainSelectCarView:initialize()
    ClubTrainSelectCarBaseView.initialize(self)
    ViewBase.RegisteAction(self, "ClubTrainSelectCarViewAction")
end

function ClubTrainSelectCarView:Awake()
    self:CacheSelectCarData()
    self:InitRaceViewBtn()
end

function ClubTrainSelectCarView:OnOpen()
    self:OnBaseOpen()
end

function ClubTrainSelectCarView:SetTrackData()
    local data = SpecialTrainingDataManager:Get():GetSelectCopy()

    ---@type racetrack_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.racetrack_config, data.racetrack)

    CommonHelper:SetText("trackName", self.gameObject, ClientDataManager:Get():GetTemplateString(cfg.name))
    CommonHelper:SetText("trackLength", self.gameObject, cfg.length .. "米")
    CommonHelper:GetComponentSetTrackIcon("trackIcon", self.gameObject, MiniTrackType.System, cfg.icon, nil, UIModuleID.SpecialTraining)
end

function ClubTrainSelectCarView:CacheSelectCarData()
    self:CacheBaseViewData()
    self. center = self:GetChild("Center")
    self. bottom = self:GetChild("Bottom")

end

function ClubTrainSelectCarView:InitRaceViewBtn()
    self:InitBaseViewBtn()

    CommonHelper:HButtonSetCallback("EnsureBtn", self.bottom, function(hbtn)
        self:OnEnsureBtnClick()
    end)
    CommonHelper:HButtonSetCallback("BtnBack", self.bottom, function(param)
        UIManager:Get():CloseView()
    end)
end

function ClubTrainSelectCarView:OnEnsureBtnClick()
    if self.Page then
        local cardata = self.Page:GetCurCar()
        if cardata then
            ClubTrainDataManager:Get():SetCurSelectCarData(cardata)
            ClubTrainSubsystem:Get():SendMsg_StartTrainRace(cardata:GetID())
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
        end
    end
end

function ClubTrainSelectCarView:OnClose()
    self:OnBaseClose()
end





