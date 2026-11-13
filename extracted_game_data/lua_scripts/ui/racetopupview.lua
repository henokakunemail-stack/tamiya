---@class RaceTopUpView : ViewBase
RaceTopUpView = class("RaceTopUpView", ViewBase)

function RaceTopUpView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTopUpViewAction")
end

function RaceTopUpView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("RaceTopUpShowView")
    end)


end

function RaceTopUpView:OnOpen()

end


function RaceTopUpView:OnClose()

end

