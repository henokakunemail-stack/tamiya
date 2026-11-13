
---@class ClubRaceSelfLevelCreateViewAction:ViewBaseAction
ClubRaceSelfLevelCreateViewAction = class("ClubRaceSelfLevelCreateViewAction",ViewBaseAction)

function ClubRaceSelfLevelCreateViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ClubRaceSelfLevelCreateViewAction:OnRegisterEvents()
 end

---@return ClubRaceSelfLevelCreateView
function ClubRaceSelfLevelCreateViewAction:View()
    return self.view
end

return ClubRaceSelfLevelCreateViewAction()