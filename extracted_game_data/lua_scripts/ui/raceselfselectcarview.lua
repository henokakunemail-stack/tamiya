



---@class RaceSelfSelectCarView : ViewBase
RaceSelfSelectCarView = class("RaceSelfSelectCarView", ViewBase)

function RaceSelfSelectCarView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfSelectCarViewAction")

    ---@type Page_SelectCar
    self.Page = nil
    self.PagePrefab = nil
end

function RaceSelfSelectCarView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnSelect",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfSelectCarView_SelectCar)
    end)

    CommonHelper:HButtonSetCallback("BtnReview",self.gameObject,function (hbtn)
        self:OnClose()
        if self.Param_RaceData:GetTrackData() then
            CommonHelper:LoadReviewTrack(nil, self.Param_RaceData:GetTrackData())
        end
    end)



    self.PageRoot = UIUtil.GetChild("bgroot",self.gameObject)


    ---@type RaceSelfData
    self.Param_RaceData = nil
    ---@type RaceSelfSelectCarType
    self.Param_Type = nil
end

function RaceSelfSelectCarView:OnOpen()
    self:SetPage()
end

function RaceSelfSelectCarView:ReOpen()

    self:SetTrackData()

    self:SetPage()
end


function RaceSelfSelectCarView:OnClose()
    if self.Page then
        self.Page:Release()
        self.Page = nil
    end

    if self.PagePrefab then
        PrefabCacheMgr:Get():RecyclePrefab(self.PagePrefab)
        self.PagePrefab = nil
    end
    TrackBuilder:Get():RestoreCamera()
end

function RaceSelfSelectCarView:OnAutoClose()
    TrackBuilder:Get():RestoreCamera()
end


function RaceSelfSelectCarView:SetPage()
    if self.Page then
        self.Page:SetData(self.PagePrefab, UIModuleID.SelectCar)
    else
        PrefabCacheMgr:Get():SwapPrefabAsync("Page_SelectCar.prefab", nil, nil, self.LoadPageFinish, nil, self)
    end

end

function RaceSelfSelectCarView:LoadPageFinish(param, obj)
    self.PagePrefab = obj
    UIUtil.SetParentGameObject(self.PageRoot, obj, true, true)

    self.Page = Page_SelectCar()
    self.Page:SetData(obj, UIModuleID.SelectCar)
end



function RaceSelfSelectCarView:SetData(param)
    self:AnalyseParam(param)
    self:SetTrackData()
end

function RaceSelfSelectCarView:AnalyseParam(param)
    self.Param_RaceData = param[1]
    self.Param_Type = param[2]

end

function RaceSelfSelectCarView:SetTrackData()
    if self.Param_RaceData:GetTrackData() then
        CommonHelper:GetComponentSetTrackIconByData("trackIcon", self.gameObject, self.Param_RaceData:GetTrackData(), UIModuleID.SelectCar)
    end
    CommonHelper:SetText("creatername", self.gameObject, self.Param_RaceData.Creater)
    CommonHelper:SetText("raceid", self.gameObject, "ID:"..self.Param_RaceData.ID)
    CommonHelper:SetText("racerule", self.gameObject, CommonHelper:GetTempStr_RaceSelfRule(self.Param_RaceData.RaceType))
    CommonHelper:SetText("joinerlimit", self.gameObject, CommonHelper:GetTempStr_RaceSelfJoinerLimit(self.Param_RaceData.JoinerMax))
end






function RaceSelfSelectCarView:OnClickBtnSelectCar()
    if self.Param_Type == RaceSelfSelectCarType.Join then
        self:JoinRace()
    end
    if self.Param_Type == RaceSelfSelectCarType.ChangeCar then
        self:ChangeCar()
    end
    if self.Param_Type == RaceSelfSelectCarType.TryRun then
        self:TryRun()
    end
end





function RaceSelfSelectCarView:JoinRace()
    if self.Page then
        local cardata = self.Page:GetCurCar()
        if cardata then
            RaceSelfSubsystem:Get():SendMsg_JoinRace(self.Param_RaceData.ID, cardata:GetID())
            UIManager:Get():CloseView()
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ParkingLotEmpty))
        end
    end

end

function RaceSelfSelectCarView:ChangeCar()
    if self.Page then
        local cardata = self.Page:GetCurCar()
        if cardata then
            RaceSelfSubsystem:Get():SendMsg_ChangeCar(self.Param_RaceData.ID, cardata:GetID())
            UIManager:Get():CloseView()
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ParkingLotEmpty))
        end
    end
end

function RaceSelfSelectCarView:TryRun()
    if self.Page then
        local cardata = self.Page:GetCurCar()
        if cardata then
            RaceSelfSubsystem:Get():SendMsg_TryRun(cardata:GetID())
            UIManager:Get():CloseView()
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ParkingLotEmpty))
        end
    end
end