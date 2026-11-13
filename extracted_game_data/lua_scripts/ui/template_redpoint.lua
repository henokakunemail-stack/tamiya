



---@class Template_RedPoint: ViewBase
Template_RedPoint = class("Template_RedPoint", ViewBase)


function Template_RedPoint:initialize()
    ViewBase.initialize(self)
    self.RedPointValue = false
end


function Template_RedPoint:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject, function (hbtn)
        UIManager:Get():CloseView()
    end)

    self.TogFalse = CommonHelper:HButtonSetCallback("TogFalse",self.gameObject, function (hbtn)
        self.RedPointValue = false
        CommonHelper:SetToggleState(self.TogFalse, true, true)
        CommonHelper:SetToggleState(self.TogTrue, false, true)
    end)

    self.TogTrue = CommonHelper:HButtonSetCallback("TogTrue",self.gameObject, function (hbtn)
        self.RedPointValue = true
        CommonHelper:SetToggleState(self.TogFalse, false, true)
        CommonHelper:SetToggleState(self.TogTrue, true, true)
    end)

    CommonHelper:HButtonSetCallback("Btn1",self.gameObject, function (hbtn)
        log("---   模拟接收服务器红点数据")
        --local id = CommonHelper:GetInputFieldText("RedPointID", self.gameObject)
        --id = tonumber(id)
        --RedPointManager:Get():UpdateValueByMsg(id, self.RedPointValue)
        --log("---   ",id, self.RedPointValue)
    end)

    CommonHelper:HButtonSetCallback("Btn2",self.gameObject, function (hbtn)
        log("---   模拟接收服务器某个模块数据")
        --local id = CommonHelper:GetInputFieldText("RedPointID", self.gameObject)
        --id = tonumber(id)
        --RedPointManager:Get():UpdateValueByModuleMsg(id)
        --log("---   ",id)
    end)

end



function Template_RedPoint:OnOpen()

end

