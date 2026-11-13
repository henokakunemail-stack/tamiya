



local green = 1
local blue = 2


---@class Page_SelectCar
Page_SelectCar = class("Page_SelectCar")

function Page_SelectCar:initialize()
    self.Root = nil
    self.ModuleID = nil
    self.CurTog = -1
    self.SceneType = SceneChangeID.None
    self.SelectCar = nil
    self.IsPlayAni = false
    self.IsCheckCar = true
    self.ClickFunc = nil
end


function Page_SelectCar:SetData(root, moduleid, autoselectidx, isplayani, scene, ischeckcar, clickfunc)

    self.ModuleID = moduleid

    self.SceneType = scene

    if isplayani == nil then isplayani = false end
    self.IsPlayAni = isplayani

    if ischeckcar == nil then ischeckcar = true end
    self.IsCheckCar = ischeckcar

    self.ClickFunc = clickfunc

    self:SetUIColor(root, 1)

    self:SetBtnArrow()

    if autoselectidx == nil then autoselectidx = 1 end
    self:AutoSelect(autoselectidx)
end

function Page_SelectCar:SetAllData(root, moduleid, isplayani, scene, ischeckcar, clickfunc)

    self.ModuleID = moduleid

    self.SceneType = scene

    if isplayani == nil then isplayani = false end
    self.IsPlayAni = isplayani

    if ischeckcar == nil then ischeckcar = true end
    self.IsCheckCar = ischeckcar

    self.ClickFunc = clickfunc

    self:SetUIColor(root, 1)

    self:SetBtnArrow()

   local carList= CarDataManager:Get():GetCarList()
    for i = 1, #carList do
        self:SetMesh(carList[i]:GetCarIdx(),false)
    end
end

function Page_SelectCar:AutoSelect(idx)
    self:OnClickTog(idx, true)
end

function Page_SelectCar:SetUIColor(root, uicolor)

    self.Root = nil
    local objgreen = CommonHelper:SetGameObjectActive("colorgreen", root, uicolor == green)
    local objblue = CommonHelper:SetGameObjectActive("colorblue", root, uicolor == blue)
    if uicolor == green then self.Root = objgreen end
    if uicolor == blue then self.Root = objblue end

    self:SetToggle()
end








function Page_SelectCar:SetViewRect(root)
    --local fillbg =  UIUtil.GetTypeChildWightInputPath("raceroom/fillbg", root, typeof(RectTransform))
    --local viewrect =  UIUtil.GetTypeChildWightInputPath("raceroom/viewroot", root, typeof(RectTransform))
    --local viewbuttomrect =  UIUtil.GetTypeChildWightInputPath("raceroom/viewbuttom", root, typeof(RectTransform))
    --
    --local rectvalue = viewrect.rect.height
    --local fillvalue = (viewbuttomrect.rect.height - viewrect.rect.height )/ fillbg.rect.height
    --CommonHelper:SetFillBg("raceroom/fillbg",root ,fillvalue ,rectvalue)

end

function Page_SelectCar:SetToggle()
    self.TogGroup = {}
    for i = 1, 5 do
        self.TogGroup[i] = CommonHelper:HButtonSetCallback("TogTeam"..i,self.Root,function (hbtn)
            self:OnClickTog(i)
        end)
    end
end

function Page_SelectCar:OnClickTog(idx, refresh)
    if self:CheckCar(idx) == false then return end


    if refresh == nil then refresh = false end
    if self.CurTog == idx and refresh == false then return end

    for k, v in pairs(self.TogGroup) do
        CommonHelper:SetToggleState(v,k == idx)
    end
    self.CurTog = idx

    self:UpdateBtnArrowActive()

    self:SetEquipmentName(idx)

    self:SetMesh(idx)

    if self.ClickFunc then self.ClickFunc() end
end

function Page_SelectCar:SetBtnArrow()
    --self.BtnLeft = CommonHelper:HButtonSetCallback("BtnPageLeft",self.Root,function (hbtn)
    --    self:OnClickBtnArrow(-1)
    --end)
    --self.BtnRight = CommonHelper:HButtonSetCallback("BtnPageRight",self.Root,function (hbtn)
    --    self:OnClickBtnArrow(1)
    --end)
end

function Page_SelectCar:OnClickBtnArrow(value)
    local idx = self.CurTog
    idx = idx + value
    if idx < 1 then idx = 1 end
    if idx > 5 then idx = 5 end

    self:OnClickTog(idx)
end

function Page_SelectCar:UpdateBtnArrowActive()
    --CommonHelper:SetHButtonClick(self.BtnLeft, self.CurTog > 1, true)
    --CommonHelper:SetHButtonClick(self.BtnRight, self.CurTog < 5, true)
end

function Page_SelectCar:SetEquipmentName(idx)
    local data = CarDataManager:Get():GetCarDataByIndex(idx)
    if data and data:GetShellCfg() then
        local name = ClientDataManager:Get():GetTemplateString(data:GetShellCfg().carNameid)
        CommonHelper:SetText("###carname1", self.Root, name)
        CommonHelper:SetText("###carname2", self.Root, name)
    else
        CommonHelper:SetText("###carname1", self.Root, CommonHelper:GetTempStr_Default(TemplateStringID.EmptyParkingLot))
        CommonHelper:SetText("###carname2", self.Root, CommonHelper:GetTempStr_Default(TemplateStringID.EmptyParkingLot))
    end
end

function Page_SelectCar:SetMesh(idx,isCleatCache)
    local data = CarDataManager:Get():GetCarDataByIndex(idx)
    if data then
        HomeSceneCarMeshHelper:Get():SetDataByCarData(data, self.SceneType,AnimateType.None,isCleatCache)
    else
        HomeSceneCarMeshHelper:Get():ClearCache()
    end


end


function Page_SelectCar:CheckCar(idx)
    if self.IsCheckCar then
        local data = CarDataManager:Get():GetCarDataByIndex(idx)
        if data == nil then
            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SelectCarCheckError))
            return false
        end

        if CarDataManager:Get():CheckCarCompleteness(data:GetID()) == false then
            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SelectCarCheckError))
            return false
        end
    end

    return true
end



function Page_SelectCar:GetCurCar()
    return CarDataManager:Get():GetCarDataByIndex(self.CurTog)
end









function Page_SelectCar:Release()
    CommonHelper:ReleasePool(UIModuleID.SelectCar)
    HomeSceneCarMeshHelper:Get():ClearCache()
    self.ModuleID = nil
    self.CurTog = -1
    self.SelectCar = nil
end