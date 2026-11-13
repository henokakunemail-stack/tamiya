---@class FeedBackViewAction : ViewBase
FeedBackViewAction = class("FeedBackViewAction", ViewBaseAction)

function FeedBackViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function FeedBackViewAction:OnRegisterEvents()

end


---@return FeedBackView
function FeedBackViewAction:View()
    return self.view
end

return FeedBackViewAction()
