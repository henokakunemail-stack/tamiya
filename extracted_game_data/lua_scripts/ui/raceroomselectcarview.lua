



---@class RaceRoomSelectCarView:ViewBase
RaceRoomSelectCarView = class("RaceRoomSelectCarView", ViewBase)

function RaceRoomSelectCarView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRoomSelectCarViewAction")
end

function RaceRoomSelectCarView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnSure",self.gameObject,function (hbtn)
        self:OnClickBtnSelect()
    end)

    self.PageRoot = UIUtil.GetChild("pageroot",self.gameObject)

    ---@type Page_SelectCar
    self.Page = nil
    self.PagePrefab = nil
end

function RaceRoomSelectCarView:OnOpen()
    self:SetPage()
    self:SetData()
end

function RaceRoomSelectCarView:OnClose()

end

function RaceRoomSelectCarView:SetData()
    local trackdata = RaceRoomManager:Get():GetTrackData()
    CommonHelper:GetComponentSetTrackIconByData("trackicon", self.gameObject, trackdata, UIModuleID.SelectCar)

    CommonHelper:SetTrackFeatureByParent("trackfeature", self.gameObject, trackdata:GetFeature())
end

function RaceRoomSelectCarView:SetPage()
    if self.Page then
        self.Page:SetData(self.PagePrefab, UIModuleID.SelectCar)
    else
        PrefabCacheMgr:Get():SwapPrefabAsync("Page_SelectCar.prefab", nil, nil, self.LoadPageFinish, nil, self)
    end

end

function RaceRoomSelectCarView:LoadPageFinish(param, obj)
    self.PagePrefab = obj
    UIUtil.SetParentGameObject(self.PageRoot, obj, true, true)

    self.Page = Page_SelectCar()
    self.Page:SetData(obj, UIModuleID.SelectCar,1,false, HomeSceneType.SelectCar)
end


function RaceRoomSelectCarView:OnClickBtnSelect()
    ---@type CarData
    local cardata = self.Page:GetCurCar()
    if cardata  then
        if CarDataManager:Get():CheckCarCompleteness(cardata:GetID()) then
            RaceRoomSubsystem:Get():SendMsg_ChangeCar(cardata:GetID())
        end
    else
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ParkingLotEmpty))
    end


end