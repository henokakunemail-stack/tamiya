
---@class LimitChapterViewAction:ViewBaseAction
LimitChapterViewAction = class("LimitChapterViewAction",ViewBaseAction)

function LimitChapterViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return LimitChapterView
function LimitChapterViewAction:View()
    return self.view
end
function  LimitChapterViewAction:OnRegisterEvents()

end
function LimitChapterViewAction:SetData(data)
    if self:View() then

    end
end
function LimitChapterViewAction:RefreshCurView()
    if self:View() then

    end
end
return LimitChapterViewAction()