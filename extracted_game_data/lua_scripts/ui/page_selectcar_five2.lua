local green = 1
local blue = 2


---@class Page_SelectCar_Five2
Page_SelectCar_Five2 = class("Page_SelectCar_Five2")

function Page_SelectCar_Five2:initialize()
    self.Root = nil
    self.ModuleID = nil
    self.CurTog = -1
    self.SceneType = SceneChangeID.None
    self.SelectCar = nil
    self.IsPlayAni = false
    self.IsCheckCar = true
    self.ClickFunc = nil
end


function Page_SelectCar_Five2:SetData(root, moduleid, autoselectidx, ischeckcar, clickfunc)

    self.ModuleID = moduleid

    if ischeckcar == nil then ischeckcar = true end
    self.IsCheckCar = ischeckcar

    self.ClickFunc = clickfunc

    self:SetUIColor(root, 1)
    self:SetToggle()

    if autoselectidx == nil then autoselectidx = 1 end
    self:AutoSelect(autoselectidx)
end

function Page_SelectCar_Five2:AutoSelect(idx)
    self:OnClickTog(idx, true)
end

function Page_SelectCar_Five2:SetUIColor(root)
    self.Root = root
    --local objgreen = CommonHelper:SetGameObjectActive("colorgreen", root, uicolor == green)
    --local objblue = CommonHelper:SetGameObjectActive("colorblue", root, uicolor == blue)
    --if uicolor == green then self.Root = objgreen end
    --if uicolor == blue then self.Root = objblue end
end
function Page_SelectCar_Five2:SetToggle()
    self.TogGroup = {}
    self.CarGroup={}
    for i = 1, 5 do
        if TeamCacheManager:Get():GetCarByIndex(i) then
            self.CarGroup[i]=CarSelectStatus.Normal
        else
            self.CarGroup[i]=CarSelectStatus.None
        end
    end
    self.ScrollView=UIUtil.GetTypeChildWightInputPath("CustomScrollViewTtoM",self.Root,typeof(CustomScrollView))
    for i = 1, 5 do
        local itemObj=UIUtil.GetChildInputPath("Pos"..i,self.Root)
        self.TogGroup[i]=CommonHelper:HButtonSetCallback("BtnPos",itemObj,function (hbtn)
        self:OnClickTog(hbtn.intData,false)
        end,i)
        CommonHelper:SetGameObjectActive("open",itemObj,self.CarGroup[i]~=CarSelectStatus.None)
        CommonHelper:SetGameObjectActive("lock",itemObj,self.CarGroup[i]==CarSelectStatus.None)
        self:SetTogState(itemObj,i)
    end
end
function Page_SelectCar_Five2:SetTogStateGroup()
    for i = 1, #self.TogGroup do
        self:SetTogState(self.TogGroup[i].gameObject,i)
    end
end
function Page_SelectCar_Five2:SetState(Idx,state,isResetLast)
    self.CarGroup[Idx]= state
    self:SetTogStateGroup()
end
function Page_SelectCar_Five2:GetState(Idx)
    return self.CarGroup[Idx]
end

function Page_SelectCar_Five2:SetTogState(gameObject,k)
    CommonHelper:SetGameObjectActive("normal",gameObject,CarSelectStatus.None == self.CarGroup[k] or CarSelectStatus.Normal == self.CarGroup[k] or CarSelectStatus.Use == self.CarGroup[k]  )
    CommonHelper:SetGameObjectActive("select",gameObject,CarSelectStatus.Select == self.CarGroup[k])
    CommonHelper:SetGameObjectActive("use",gameObject,CarSelectStatus.Use == self.CarGroup[k])
end

function Page_SelectCar_Five2:OnClickTog(idx, refresh)
    if self.CarGroup[idx]==CarSelectStatus.Normal or self.CarGroup[idx]==CarSelectStatus.Select then
        if self:CheckCar(idx) == false then return end
        if refresh == nil then refresh = false end
        if self.CurTog == idx and refresh == false and  self.CarGroup[idx]==CarSelectStatus.Select then return end
        if self.CarGroup[idx]==CarSelectStatus.Normal then
            self.CarGroup[idx]=CarSelectStatus.Select
            for i = 1, #self.CarGroup do
                if idx~=i and self.CarGroup[i]==CarSelectStatus.Select then
                    self.CarGroup[i]=CarSelectStatus.Normal
                end
            end
        end
        self.CurTog = idx
        if self.ClickFunc then self.ClickFunc(idx) end
        CommonHelper:GetComponentSetUITexture("carname", self.Root, CarDataManager:Get():GetCarDataByCarID(idx):GetShellCfg().carNameIcon, self.ModuleID)
        self:SetTogStateGroup()
    else
        if self.CarGroup[idx]==CarSelectStatus.None then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CarIdxGroupLock))
        end
        if self.CarGroup[idx]==CarSelectStatus.Use then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CarIdxGroupUse))
        end
    end
end

function Page_SelectCar_Five2:CheckCar(idx)
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


function Page_SelectCar_Five2:Release()
    CommonHelper:ReleasePool(UIModuleID.SelectCar)
    HomeSceneCarMeshHelper:Get():ClearCache()
    self.ModuleID = nil
    self.CurTog = -1
    self.SelectCar = nil
end