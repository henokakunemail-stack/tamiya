---@class InitialPlayerView : ViewBase
InitialPlayerView = class("InitialPlayerView", ViewBase)

function InitialPlayerView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "InitialPlayerViewAction")

    print("---   InitialView 初始化完成")
end

function InitialPlayerView:Awake()

end
function InitialPlayerView:OnOpen()
    self:CheckNewBieGuide(nil,nil,function()
        LoginSubSystem:Get():AdvanceCreateUser("",0)
    end)
end


function InitialPlayerView:OnClose()
    self:CheckExitNewBieGuide()
end
function InitialPlayerView:OnAutoClose()

    self:CheckExitNewBieGuide()
end
