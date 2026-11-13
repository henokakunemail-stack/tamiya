


---@class RaceSelfMapView : ViewBase
RaceSelfMapView = class("RaceSelfMapView", ViewBase)

function RaceSelfMapView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfMapViewAction")
end

function RaceSelfMapView:Awake()

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    self.TogState = {}
    for i = 1, 5 do
        self.TogState[i] = CommonHelper:HButtonSetCallback("Tog"..i,self.gameObject,function (hbtn)
            UINotify:Get():SendNotification(UINotifyEvent.RaceSelfMapView_ClickTog, hbtn.intData)
        end, i)
    end

    ---@type RaceSelfData
    self.RaceData = nil
end

function RaceSelfMapView:OnOpen()

end

function RaceSelfMapView:OnClose()
    self:ClearCache()

    CommonHelper:ReleasePool(UIModuleID.RaceSelfMap)
end

function RaceSelfMapView:ClearCache()

end

---@param msgdata RaceSelfData
function RaceSelfMapView:SetData(data)
    if data == nil then
        print("---   RaceSelfMapView:SetData   data = nil")
        return
    end
    self.RaceData = data

    self:AutoSelect()
end

function RaceSelfMapView:AutoSelect()
    self:OnClickTog(2)
end

function RaceSelfMapView:OnClickTog(idx)
    for i = 1, #self.TogState do
        CommonHelper:SetToggleState(self.TogState[i], i == idx, true)
        CommonHelper:SetGameObjectActive("Page"..i, self.gameObject, i == idx)
    end


    if idx == 2 then self:SetState2() end
    if idx == 3 then self:SetState3() end
    if idx == 4 then self:SetState4() end
    if idx == 5 then self:SetState5() end

end

function RaceSelfMapView:SetState2()
    self:ClearCache()

    local limit = self.RaceData:GetSiftLimit()
    local mydata = self.RaceData:GetMyPlayerData()
    local playerlist = {}
    for k,v in pairs(self.RaceData:GetPlayerList()) do table.insert(playerlist, v:GetPlayerData()) end

    local obj = UIUtil.GetChildInputPath("Page2/RaceRuleSift", self.gameObject)
    local page = Pre_RaceRuleSift()
    page:SetData(obj, mydata, playerlist, limit, UIModuleID.RaceSelfMap)
end

function RaceSelfMapView:SetState3()
    self:ClearCache()

    local playernum = self.RaceData.RaceType

    local obj = UIUtil.GetChild("Page3/RaceRuleFightGroupList", self.gameObject)
    local page = Pre_RaceRuleFightGroupList()
    page:SetData(obj, playernum, self.RaceData:GetFightGroupKnockout(), UIModuleID.RaceSelfMap)
end

function RaceSelfMapView:SetState4()
    self:ClearCache()

    local playernum = self.RaceData.RaceType

    local obj = UIUtil.GetChild("Page4/RaceRuleFightGroupList", self.gameObject)
    local page = Pre_RaceRuleFightGroupList()
    page:SetData(obj, playernum, self.RaceData:GetFightGroupSemiFinal(), UIModuleID.RaceSelfMap)
end

function RaceSelfMapView:SetState5()
    self:ClearCache()

    local group = self.RaceData:GetFightGroupFinals()

    local obj = UIUtil.GetChild("Page5/RaceRuleFightGroup", self.gameObject)
    local page = Pre_RaceRuleFightGroup()
    page:SetData(obj, group, UIModuleID.RaceSelfMap, true)
end