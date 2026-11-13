---@class PlayerInfoSelectCarView : ViewBase
PlayerInfoSelectCarView = class("PlayerInfoSelectCarView", ViewBase)
local __CurCarIdx=-1
function PlayerInfoSelectCarView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PlayerInfoSelectCarViewAction")
    ---@type Page_SelectCar
    self.Page = nil
    self.PagePrefab = nil

end

function PlayerInfoSelectCarView:Awake()
    self.BgBtn = CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(data)
        UIManager:Get():CloseView()
        UINotify:Get():SendNotification(UINotifyEvent.PlayerInfoView_SelectCarBack,__CurCarIdx)
    end)
    CommonHelper:HButtonSetCallback("BtnSelect",self.gameObject,function (hbtn)
        if self.Page then
            local cardata = self.Page:GetCurCar()
            if cardata then
                __CurCarIdx=cardata:GetID()
                UIManager:Get():CloseView()
                UINotify:Get():SendNotification(UINotifyEvent.PlayerInfoView_SelectCarBack,__CurCarIdx)
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ParkingLotEmpty))
            end
        end
    end)

    self.PageRoot = UIUtil.GetChild("bgroot",self.gameObject)
end

function PlayerInfoSelectCarView:OnClose()
    if self.Page then
        self.Page:Release()
        self.Page = nil
    end

    if self.PagePrefab then
        PrefabCacheMgr:Get():RecyclePrefab(self.PagePrefab)
        self.PagePrefab = nil
    end
end
function PlayerInfoSelectCarView:SetPage()
    if self.Page then
        self.Page:SetData(self.PagePrefab, UIModuleID.SelectCar)
    else
        PrefabCacheMgr:Get():SwapPrefabAsync("Page_SelectCar.prefab", nil, nil, self.LoadPageFinish, nil, self)
    end

end

function PlayerInfoSelectCarView:LoadPageFinish(param, obj)
    self.PagePrefab = obj
    UIUtil.SetParentGameObject(self.PageRoot, obj, true, true)

    self.Page = Page_SelectCar()
    self.Page:SetData(obj, UIModuleID.SelectCar)
end


function PlayerInfoSelectCarView:AutoSelect(index)
    __CurCarIdx=index
    self:SetPage()
end



