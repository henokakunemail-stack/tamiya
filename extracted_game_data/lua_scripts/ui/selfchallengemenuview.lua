---@class SelfChallengeMenuView : ViewBase
SelfChallengeMenuView = class("SelfChallengeMenuView", ViewBase)
function SelfChallengeMenuView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeMenuViewAction")
end

function SelfChallengeMenuView:Awake()
   CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function ()
       UIManager:Get():CloseView()
   end)

    CommonHelper:HButtonSetCallback("BtnJoinChallenge",self.gameObject,function ()
       -- CommonTipsHelper:Get():ShowCenterTips("功能未开启")
        SelfChallengeSubsystem:Get():SendGetAllSelfChallenge(1)
    end)
    CommonHelper:HButtonSetCallback("BtnCreateChallenge",self.gameObject,function ()
        --CommonTipsHelper:Get():ShowCenterTips("功能未开启")
        SelfChallengeSubsystem:Get():SendGetAllCreateSelfChallenge(2)
    end)
end

function SelfChallengeMenuView:OnOpen()

end

function SelfChallengeMenuView:OnClose()

end


