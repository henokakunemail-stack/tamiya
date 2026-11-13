---@class GMView : ViewBase
GMView = class("GMView", ViewBase)

function GMView:initialize()
    ViewBase.initialize(self)


end

function GMView:Awake()
    CommonHelper:HButtonSetCallback("CloseBtn", self.gameObject, function(hbtn)
         UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("SendBtn", self.gameObject, function(hbtn)
        local reqBytes= CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),CommonHelper:GetInputFieldText("TextGM",self.gameObject)})

    end)
    CommonHelper:HButtonSetCallback("ClearBtn", self.gameObject, function(hbtn)
       self:SetStr("")
    end)
   CommonHelper:HButtonSetCallback("AddItem", self.gameObject, function(hbtn)
       self:SetStr("downprop:id:num")
       CommonHelper:SetText("gmtips",self.gameObject,"downprop:id:num")
    end)

    --reload##
    CommonHelper:HButtonSetCallback("RefreshDataLogin", self.gameObject, function(hbtn)
        self:SetStr("reload##")
        CommonHelper:SetText("gmtips",self.gameObject,"reload##")
    end)

   CommonHelper:HButtonSetCallback("AddGold", self.gameObject, function(hbtn)
       self:SetStr("downprop:12040101:10000")
       CommonHelper:SetText("gmtips",self.gameObject,"downprop:12040101:num")
    end)
   CommonHelper:HButtonSetCallback("AddExp", self.gameObject, function(hbtn)
       self:SetStr("downprop:12040100:10000")
       CommonHelper:SetText("gmtips",self.gameObject,"downprop:12040100:num")
    end)
   CommonHelper:HButtonSetCallback("AddDamil", self.gameObject, function(hbtn)
       self:SetStr("downprop:12040102:10000")
       CommonHelper:SetText("gmtips",self.gameObject,"downprop:12040102:num")
    end)
end

function GMView:OnClose()

end
function GMView:SetStr(str)
    CommonHelper:SetInputFieldText("TextGM",self.gameObject,str)
end
function GMView:OnOpen()

end



