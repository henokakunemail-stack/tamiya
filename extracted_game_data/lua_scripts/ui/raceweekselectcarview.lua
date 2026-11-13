


---@class RaceWeekSelectCarView : ViewBase
RaceWeekSelectCarView = class("RaceWeekSelectCarView", ViewBase)

function RaceWeekSelectCarView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceWeekSelectCarViewAction")

    ---@type Page_SelectCar
    self.Page = nil
    self.PagePrefab = nil
end

function RaceWeekSelectCarView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnSelect",self.gameObject,function (hbtn)
        self:OnClickBtnSelectCar()
    end)

    CommonHelper:HButtonSetCallback("BtnReview",self.gameObject,function (hbtn)
        self:OnClose()
        if self.Param_RaceData:GetTrackData() then
            CommonHelper:LoadReviewTrack(nil, self.Param_RaceData:GetTrackData())
        end
    end)


    self.PageRoot = UIUtil.GetChild("bgroot",self.gameObject)


    ---@type RaceWeekData
    self.Param_RaceData = nil
    ---@type RaceWeekSelectCarType
    self.Param_Type = nil
end

function RaceWeekSelectCarView:OnOpen()
    self:SetPage()
end
function RaceWeekSelectCarView:ReOpen()
    self:SetPage()
end

function RaceWeekSelectCarView:OnClose()

end
function RaceWeekSelectCarView:OnAutoClose()
    TrackBuilder:Get():RestoreCamera()
end

function RaceWeekSelectCarView:SetPage()
    if self.Page then
        self.Page:SetData(self.PagePrefab, UIModuleID.SelectCar)
    else
        PrefabCacheMgr:Get():SwapPrefabAsync("Page_SelectCar.prefab", nil, nil, function(param, obj)
            self.PagePrefab = obj
            UIUtil.SetParentGameObject(self.PageRoot, obj, true, true)

            self.Page = Page_SelectCar()
            self.Page:SetData(obj, UIModuleID.SelectCar)
        end)
    end
end



function RaceWeekSelectCarView:SetData(param)
    self:AnalyseParam(param)
    self:SetDataBaseInfo()
end

function RaceWeekSelectCarView:AnalyseParam(param)
    self.Param_RaceData = param[1]
    self.Param_Type = param[2]
end

---@param data RaceWeekData
function RaceWeekSelectCarView:SetDataBaseInfo()
    local obj = UIUtil.GetChild("RaceWeekBaseInfo", self.gameObject)
    local baseinfo = Pre_RaceWeekBaseInfo()
    baseinfo:SetData(obj, self.Param_RaceData, UIModuleID.SelectCar)
end


function RaceWeekSelectCarView:OnClickBtnSelectCar()
    if self.Page then
        local cardata = self.Page:GetCurCar()
        if cardata then
            if self.Param_Type == RaceWeekSelectCarType.Join then
                RaceWeekSubsystem:Get():SendMsg_Join(self.Param_RaceData:GetServerID(), cardata:GetID())
            end
            if self.Param_Type == RaceWeekSelectCarType.ChangeCar then
                RaceWeekSubsystem:Get():SendMsg_ChangeCar(self.Param_RaceData:GetServerID(), cardata:GetID())
            end
            if self.Param_Type == RaceWeekSelectCarType.TryRun then
                RaceWeekSubsystem:Get():SendMsg_Run(self.Param_RaceData:GetServerID(), cardata:GetID())
            end

            UIManager:Get():CloseView()
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FunctionNoWait))
        end
    end
end
