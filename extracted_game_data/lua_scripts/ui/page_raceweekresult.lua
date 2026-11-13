


---@class Page_RaceWeekResult
Page_RaceWeekResult = class("Page_RaceWeekResult")
function Page_RaceWeekResult:initialize()

end

function Page_RaceWeekResult:ClearData()

end

---@param data RaceWeekData
function Page_RaceWeekResult:SetData(root, data)
    self.Param_Data = data
    self:SetDataBaseInfo(root, data)
    self:SetDataResult(root, data)

    CommonHelper:HButtonSetCallback("BtnMap",root,function (hbtn)
        self:ClickBtnMap()
    end)
end

---@param data RaceWeekData
function Page_RaceWeekResult:SetDataBaseInfo(root, data)
    local obj = UIUtil.GetChild("RaceWeekBaseInfo", root)
    local baseinfo = Pre_RaceWeekBaseInfo()
    baseinfo:SetData(obj, data, UIModuleID.RaceWeekDetail)
end

---@param data RaceWeekData
function Page_RaceWeekResult:SetDataResult(root, data)
    local obj = UIUtil.GetChild("RaceRuleResult", root)
    local baseinfo = Pre_RaceRuleResult()
    baseinfo:SetData(obj, RaceRulePlayerIdentity.Joiner, "赢了", data:GetWiner())
end

function Page_RaceWeekResult:ClickBtnMap()
    UIManager:Get():OpenView("RaceWeekMapView",CanvasType.MainCanvas,"RaceWeekMapView")
    UINotify:Get():SendNotification(UINotifyEvent.RaceWeekMapView_SetData, self.Param_Data)
end