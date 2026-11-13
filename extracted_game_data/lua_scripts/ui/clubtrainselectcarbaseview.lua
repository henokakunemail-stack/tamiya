---@class ClubTrainSelectCarBaseView : ViewBase
ClubTrainSelectCarBaseView = class("ClubTrainSelectCarBaseView", ViewBase)

function ClubTrainSelectCarBaseView:initialize()
    ViewBase.initialize(self)
end


function ClubTrainSelectCarBaseView:CacheBaseViewData()
    ---@type Page_SelectCar
    self.Page = nil
    self.PagePrefab = nil
    self.PageRoot = UIUtil.GetChild("bgroot",self.gameObject)
end


function ClubTrainSelectCarBaseView:InitBaseViewBtn()

end



function ClubTrainSelectCarBaseView:OnBaseOpen()
   -- self:SetTrackData()

    self:SetPage()
end



function ClubTrainSelectCarBaseView:OnBaseClose()
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





function ClubTrainSelectCarBaseView:SetPage()
    if self.Page then
        self.Page:SetData(self.PagePrefab, UIModuleID.ClubTraining)
    else
        PrefabCacheMgr:Get():SwapPrefabAsync("Page_SelectCar.prefab", nil, nil, self.LoadPageFinish, nil, self)
    end
end

function ClubTrainSelectCarBaseView:LoadPageFinish(param, obj)
    self.PagePrefab = obj
    UIUtil.SetParentGameObject(self.PageRoot, obj, true, true)

    self.Page = Page_SelectCar()
    self.Page:SetData(obj, UIModuleID.ClubTraining)
end


