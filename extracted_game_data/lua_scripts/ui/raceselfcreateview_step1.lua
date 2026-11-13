

local __type = {2,3,4,5}

function RaceSelfCreateView:SetStep1(default)
    self:SetPageGroup(1)

    self.Param_RuleType = 0

    self.Step1_Tog = {}
    for i = 1, 4 do
        self.Step1_Tog[i] = CommonHelper:HButtonSetCallback("TogSelect"..i,self.Page1,function (hbtn)
            UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_Step1_ClickTog, hbtn.intData)
        end, i)
    end

    if default then
        self:Step1_SelectTog(1)
    end


end

function RaceSelfCreateView:Step1_SelectTog(idx)
    for i = 1, #self.Step1_Tog do
        CommonHelper:SetToggleState(self.Step1_Tog[i], i == idx, true)
    end

    self.Param_RuleType = __type[idx]
end