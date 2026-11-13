


---@class Page_RaceWeekFightGroup
Page_RaceWeekFightGroup = class("Page_RaceWeekFightGroup")
function Page_RaceWeekFightGroup:initialize()

end

function Page_RaceWeekFightGroup:ClearData()

end

---@param data RaceWeekData
---@param groupdata RaceDataFightGroup
function Page_RaceWeekFightGroup:SetData(root, data, groupdata, isshowcup)
    self.Param_Data = data
    self:SetDataBaseInfo(root, data)
    self:SetFightGroup(root, groupdata, isshowcup)

    CommonHelper:HButtonSetCallback("BtnChangeCar",root,function (hbtn)
        self:ClickBtnChangeCar()
    end)

    CommonHelper:HButtonSetCallback("BtnTry",root,function (hbtn)
        self:ClickBtnTry()
    end)

    CommonHelper:HButtonSetCallback("BtnBuyCount",root,function (hbtn)
        self:ClickBtnBuy()
    end)

    CommonHelper:HButtonSetCallback("BtnMap",root,function (hbtn)
        self:ClickBtnMap()
    end)
end

---@param data RaceWeekData
function Page_RaceWeekFightGroup:SetDataBaseInfo(root, data)
    local obj = UIUtil.GetChild("RaceWeekBaseInfo", root)
    local baseinfo = Pre_RaceWeekBaseInfo()
    baseinfo:SetData(obj, data, UIModuleID.RaceWeekDetail)
end

---@param groupdata RaceDataFightGroup
function Page_RaceWeekFightGroup:SetFightGroup(root, groupdata, isshowcup)
    local obj = UIUtil.GetChild("RaceRuleFightGroup",root)
    local baseinfo = Pre_RaceRuleFightGroup()
    baseinfo:SetData(obj, groupdata, UIModuleID.RaceWeekDetail, isshowcup)
end

function Page_RaceWeekFightGroup:ClickBtnChangeCar()
    UIManager:Get():OpenView("RaceWeekSelectCarView",CanvasType.MainCanvas,"RaceWeekSelectCarView")
    local param = {self.Param_Data, RaceWeekSelectCarType.ChangeCar}
    UINotify:Get():SendNotification(UINotifyEvent.RaceWeekSelectCarView_SetData, param)
end

function Page_RaceWeekFightGroup:ClickBtnTry()
    UIManager:Get():OpenView("RaceWeekSelectCarView",CanvasType.MainCanvas,"RaceWeekSelectCarView")
    local param = {self.Param_Data, RaceWeekSelectCarType.TryRun}
    UINotify:Get():SendNotification(UINotifyEvent.RaceWeekSelectCarView_SetData, param)
end

function Page_RaceWeekFightGroup:ClickBtnBuy()

end

function Page_RaceWeekFightGroup:ClickBtnMap()
    UIManager:Get():OpenView("RaceWeekMapView",CanvasType.MainCanvas,"RaceWeekMapView")
    UINotify:Get():SendNotification(UINotifyEvent.RaceWeekMapView_SetData, self.Param_Data)
end