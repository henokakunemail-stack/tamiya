


---@class RaceSelfLevelCreateViewAction:ViewBaseAction
RaceSelfLevelCreateViewAction = class("RaceSelfLevelCreateViewAction",ViewBaseAction)

function RaceSelfLevelCreateViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfLevelCreateViewAction:OnRegisterEvents()

end

---@return RaceSelfLevelCreateView
function RaceSelfLevelCreateViewAction:View()
    return self.view
end


return RaceSelfLevelCreateViewAction()