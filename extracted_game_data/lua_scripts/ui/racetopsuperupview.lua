---@class RaceTopSuperUpView : ViewBase
RaceTopSuperUpView = class("RaceTopSuperUpView", ViewBase)

function RaceTopSuperUpView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTopSuperUpViewAction")
end

function RaceTopSuperUpView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("RaceTopSuperUpShowView")
    end)


end

function RaceTopSuperUpView:OnOpen()

end


function RaceTopSuperUpView:OnClose()

end

