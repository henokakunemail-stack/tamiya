


---@class RaceWeekMapView : ViewBase
RaceWeekMapView = class("RaceWeekMapView", ViewBase)

function RaceWeekMapView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceWeekMapViewAction")
end

function RaceWeekMapView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    self.TogState = {}
    for i = 1, 3 do
        self.TogState[i] = CommonHelper:HButtonSetCallback("Tog"..i,self.gameObject,function (hbtn)
            self:OnClickTog(hbtn.intData)
        end, i)
    end

    ---@type RaceWeekData
    self.RaceData = nil
end

function RaceWeekMapView:OnOpen()

end

function RaceWeekMapView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceWeekMap)
end

---@param msgdata RaceWeekData
function RaceWeekMapView:SetData(data)
    if data == nil then
        print("---   RaceWeekMapView:SetData   data = nil")
        return
    end
    self.RaceData = data

    self:AutoSelect()
end

function RaceWeekMapView:AutoSelect()
    self:OnClickTog(1)
end

function RaceWeekMapView:OnClickTog(idx)
    for i = 1, #self.TogState do
        CommonHelper:SetToggleState(self.TogState[i], i == idx, true)
        CommonHelper:SetGameObjectActive("Page"..i, self.gameObject, i == idx)
    end

    if idx == 1 then self:SetState1() end
    if idx == 2 then self:SetState2() end
    if idx == 3 then self:SetState3() end
end


function RaceWeekMapView:SetState1()
    local obj = UIUtil.GetChild("Page1/RaceRuleFightGroupList", self.gameObject)
    local page = Pre_RaceRuleFightGroupList()
    page:SetData(obj, 1, self.RaceData:GetFirstGroup(), UIModuleID.RaceWeekMap)
end

function RaceWeekMapView:SetState2()
    local obj = UIUtil.GetChild("Page2/RaceRuleFightGroupList", self.gameObject)
    local page = Pre_RaceRuleFightGroupList()
    page:SetData(obj, 1, self.RaceData:GetSecondGroup(), UIModuleID.RaceWeekMap)
end

function RaceWeekMapView:SetState3()
    local obj = UIUtil.GetChild("Page3/RaceRuleFightGroup", self.gameObject)
    local page = Pre_RaceRuleFightGroup()
    page:SetData(obj, self.RaceData:GetFightGroupFinals(), UIModuleID.RaceWeekMap, true)
end