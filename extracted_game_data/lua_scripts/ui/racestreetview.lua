---@class RaceStreetView : ViewBase
RaceStreetView = class("RaceStreetView", ViewBase)

function RaceStreetView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceStreetViewAction")
end

function RaceStreetView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnShow",self.gameObject,function (hbtn)
        CommonTipsHelper:Get():ShowCenterTips("热更测试面板")
    end)

end

function RaceStreetView:OnOpen()

end


function RaceStreetView:OnClose()

end

