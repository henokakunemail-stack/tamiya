---@class RaceTrotSelectCarView : ViewBase
RaceTrotSelectCarView = class("RaceTrotSelectCarView", ViewBase)

function RaceTrotSelectCarView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTrotSelectCarViewAction")
end

function RaceTrotSelectCarView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceTrot)
    end)
    CommonHelper:HButtonSetCallback("BtnHome", self.gameObject, function(hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(true,function()
            self:Clear()
        end)
    end)

    CommonHelper:HButtonSetCallback("BtnRefit", self.gameObject, function(data)
        SkipModuleHelper:Get():ToGarage(UIModuleID.RaceTrotSelectCar)
    end)
    CommonHelper:HButtonSetCallback("BtnEnter", self.gameObject, function(hbtn)

        if ForbiddenDataManager:Get():IsCanMatch(self.Page_SelectCar:GetCurCar():GetID()) then
            if RaceTrotManager:Get():GetMaxCount() - RaceTrotManager:Get():GetJoinCount() > 0 then
                if CarDataManager:Get():CheckCarCompleteness(self.Page_SelectCar:GetCurCar():GetID()) then
                    RaceTrotSubsystem:Get():SendMsg_BeginBattle(self.Page_SelectCar:GetCurCar():GetID(), 0)
                end
            else
                local maxCount= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotMaxEnterCount,false)
                if (maxCount-RaceTrotManager:Get():GetMaxCount()) -(RaceTrotManager:Get():GetJoinCount()-RaceTrotManager:Get():GetMaxCount())<=0 then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotEnterNotCount))
                    return
                end
                local id = CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotEnterCost, false)
                if PlayerDataManager:Get():CheckCurrencyEnough(id, 1) then
                    local boxFunc = function()
                        ---@type article_config_cell
                        local cell = CommonHelper:GetTableDataByID(ConfigNames.article_config, id)
                        local name = CommonHelper:GetTempStr_Default(cell.name)
                        local tips = CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotEnter_Tips, 1, name)
                        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotEnter_Tittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
                        if ret == MessageBoxHelp.BtnType.OK then
                            if CarDataManager:Get():CheckCarCompleteness(self.Page_SelectCar:GetCurCar():GetID()) then
                                cs_coroutine.start(function()
                                    coroutine.yield()
                                    coroutine.yield()
                                    RaceTrotSubsystem:Get():SendMsg_BeginBattle(self.Page_SelectCar:GetCurCar():GetID(), 1)
                                end)
                            end
                        end
                    end
                    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
                end
            end
        end

    end)

    self.TogState = {}
    for i = 1, 3 do
        self.TogState[i] = CommonHelper:HButtonSetCallback("Tog" .. i, self.gameObject, function(hbtn)
            self:OnClickTog(hbtn.intData)
        end, i)
    end
    self.PageRoot = UIUtil.GetChild("pageroot", self.gameObject)
    self.Pre_SelectCar = UIUtil.GetChild("Page_SelectCar", self.gameObject)
    self.ObjCarIdx = UIUtil.GetChild("CaridxGroup", self.gameObject)
end

function RaceTrotSelectCarView:OnOpen()
    ForbiddenDataManager:Get():SetData()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRaceTrotVs(port)
    self:SetSelfCar()
    self:SetEnemyCar()
    self:SetView()
end
function RaceTrotSelectCarView:ReOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRaceTrotVs(port)
    self:SetSelfCar()
    self:SetEnemyCar()
    self:SetView()
end

function RaceTrotSelectCarView:OnOpenAnimEnd()
    self:AutoSelect()
end
function RaceTrotSelectCarView:OnClose()
   self:Clear()
end
function RaceTrotSelectCarView:Clear()
    ForbiddenDataManager:Get():Clear()
    RaceTrotManager:Get():RecycleFighter()
    self.Page_SelectCar:Release()
    CommonHelper:ReleasePool(UIModuleID.RaceTrotSelectCar)
end

function RaceTrotSelectCarView:OnAutoClose()
    RaceTrotManager:Get():RecycleFighter()
    self.Page_SelectCar:Release()
end

function RaceTrotSelectCarView:SetData()

end

function RaceTrotSelectCarView:AutoSelect()
    self:OnClickTog(1)
end

function RaceTrotSelectCarView:OnClickTog(idx)
    for i = 1, #self.TogState do
        CommonHelper:SetToggleState(self.TogState[i], i == idx, true)
    end
end
function RaceTrotSelectCarView:SetView()
    if RaceTrotManager:Get():GetMaxCount() - RaceTrotManager:Get():GetJoinCount() > 0 then
        CommonHelper:SetGameObjectActive("entercost", self.gameObject, false)
        CommonHelper:SetText("###subCount", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotSubCount, RaceTrotManager:Get():GetJoinCount(), RaceTrotManager:Get():GetMaxCount()))
    else
        CommonHelper:SetText("###subCount", self.gameObject, "")
        CommonHelper:SetGameObjectActive("entercost", self.gameObject, true)
        local id = CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotEnterCost, false)
        local maxCount = CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotMaxEnterCount, false)
        CommonHelper:SetText("entercost/###value", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotBattleCost, RaceTrotManager:Get():GetJoinCount() - RaceTrotManager:Get():GetMaxCount(), maxCount - RaceTrotManager:Get():GetMaxCount()))

    end

end

function RaceTrotSelectCarView:SetSelfCar()
    if self.PreCarIdx == nil then
        self.PreCarIdx = PreGarageCarIdx()
        self:SetPreGarageCar()
    else
        self:SetPreGarageCar()
    end
end
function RaceTrotSelectCarView:SetCarMesh(data)
    if self.Page_SelectCar == nil then
        self.Page_SelectCar = Page_SelectCar()
        self:SetPageSelectCar(data)
    else
        self:SetPageSelectCar(data)
    end
end
---@param data CarData
function RaceTrotSelectCarView:SetPageSelectCar(data)
    if self.Page_SelectCar then
        self.Page_SelectCar:SetData(self.Pre_SelectCar, UIModuleID.RaceTrotSelectCar, data:GetCarIdx(), false, SceneChangeID.RaceTrot_Vs, false)
    end
end

function RaceTrotSelectCarView:SetPreGarageCar()
    self.PreCarIdx:SetData(self.ObjCarIdx, UIModuleID.RaceTrotSelectCar, PlayerPrefsHelper:GetValue_MainMenuViewCarIndex(), true, false, function(data, isautoselect)
        self:SetCarMesh(data)
        PlayerPrefsHelper:SetValue_MainMenuViewCarIndex(data:GetCarIdx())
    end)
end

function RaceTrotSelectCarView:SetEnemyCar()
    local data = RaceTrotManager:Get():GetSelectEnemy().Car
    self:SetEnemyCarMash(data)
end
function RaceTrotSelectCarView:SetEnemyCarMash(carData)
    if carData then
        local param = CarBuilderParam()
        param.buildType = CarBuilderType.Data
        param.parts = carData:GetPartList()
        param.lightweight = carData:GetLightweight()
        param.grids = carData:GetGrids()
        param.colorid = carData:GetColorId()
        param.stickerid = carData:GetStickerid()
        param.combineType = CombineType.None
        param.parent = HomeSceneHelper:GetEnemyCarRoot_RaceTrot_Vs()
        param.finishParam = param
        local carId = CarBuilderManager:Get():BuildCar(param)
        RaceTrotManager:Get():SetEnemyCarId(carId)
    end
end


