local green = 1
local blue = 2


---@class Page_SelectCar_Five
Page_SelectCar_Five = class("Page_SelectCar_Five")

function Page_SelectCar_Five:initialize()
    self.Root = nil
    self.ModuleID = nil
    self.CurTog = -1
    self.SceneType = SceneChangeID.None
    self.SelectCar = nil
    self.IsPlayAni = false
    self.IsCheckCar = true
    self.ClickFunc = nil
end


function Page_SelectCar_Five:SetData(root, moduleid, autoselectidx, ischeckcar, clickfunc)

    self.ModuleID = moduleid

    if ischeckcar == nil then ischeckcar = true end
    self.IsCheckCar = ischeckcar

    self.ClickFunc = clickfunc

    self:SetUIColor(root, 1)
    self:SetToggle()

    if autoselectidx == nil then autoselectidx = 1 end
    self:AutoSelect(autoselectidx)
end

function Page_SelectCar_Five:AutoSelect(idx)
    self:OnClickTog(idx, true)
    cs_coroutine.start(function()
        coroutine.yield()
        coroutine.yield()
        CommonHelper:CustomView_ScrollToItem(self.ScrollView,idx-1)
    end)
end

function Page_SelectCar_Five:SetUIColor(root)
    self.Root = root
    --local objgreen = CommonHelper:SetGameObjectActive("colorgreen", root, uicolor == green)
    --local objblue = CommonHelper:SetGameObjectActive("colorblue", root, uicolor == blue)
    --if uicolor == green then self.Root = objgreen end
    --if uicolor == blue then self.Root = objblue end
end
function Page_SelectCar_Five:SetToggle()
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
    local data={0,1,2,3,4}
    CommonHelper:CustomView_Init(self.ScrollView, data, function(index, itemObj, scroll)
        CommonHelper:HButtonSetCallback("TogTeam",itemObj,function (hbtn)
            self:OnClickTog(hbtn.intData,false)
        end,index+1)
        if self.CarGroup[index+1]~=CarSelectStatus.None then
            local carid=TeamCacheManager:Get():GetCarByIndex(index+1)
            CommonHelper:GetComponentSetUITextureByTexture("trackicon1",itemObj, CarBuilderManager:Get():GetCarBuilder(carid).CarIcon)
            CommonHelper:GetComponentSetUITextureByTexture("trackicon2",itemObj, CarBuilderManager:Get():GetCarBuilder(carid).CarIcon)
        else
            CommonHelper:GetComponentSetUITexture("trackicon1", itemObj, "uitex_sucai_default_car.png",UIModuleID.SelectCar)
            CommonHelper:GetComponentSetUITexture("trackicon2", itemObj, "uitex_sucai_default_car.png",UIModuleID.SelectCar)
        end
        self:SetTogState(itemObj,index+1)
    end)
end

function Page_SelectCar_Five:SetState(Idx,state,isResetLast)
    self.CarGroup[Idx]= state
    CommonHelper:CustomView_Refresh(self.ScrollView,false)
end
function Page_SelectCar_Five:RefreshIcon()
    CommonHelper:CustomView_Refresh(self.ScrollView,false)
end

function Page_SelectCar_Five:SetTogState(gameObject,k)
    CommonHelper:SetGameObjectActive("bgnormal",gameObject,CarSelectStatus.None == self.CarGroup[k] or CarSelectStatus.Normal == self.CarGroup[k] or CarSelectStatus.Use == self.CarGroup[k]  )
    CommonHelper:SetGameObjectActive("hover",gameObject,CarSelectStatus.Select == self.CarGroup[k])
    CommonHelper:SetGameObjectActive("lock",gameObject,CarSelectStatus.Use == self.CarGroup[k])
end

function Page_SelectCar_Five:OnClickTog(idx, refresh)
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
        CommonHelper:CustomView_Refresh(self.ScrollView,false)
    else
        if self.CarGroup[idx]==CarSelectStatus.None then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CarIdxGroupLock))
        end
        if self.CarGroup[idx]==CarSelectStatus.Use then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CarIdxGroupUse))
        end
    end
end

function Page_SelectCar_Five:CheckCar(idx)
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


function Page_SelectCar_Five:Release()
    CommonHelper:ReleasePool(UIModuleID.SelectCar)
    HomeSceneCarMeshHelper:Get():ClearCache()
    self.ModuleID = nil
    self.CurTog = -1
    self.SelectCar = nil
end