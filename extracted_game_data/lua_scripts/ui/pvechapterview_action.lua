
---@class PveChapterViewAction:ViewBaseAction
PveChapterViewAction = class("PveChapterViewAction",ViewBaseAction)

function PveChapterViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function PveChapterViewAction:OnRegisterEvents()

end



---@return PveChapterView
function PveChapterViewAction:View()
    return self.view
end


return PveChapterViewAction()