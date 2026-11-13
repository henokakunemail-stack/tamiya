---@class LimitChapterView : ViewBase
LimitChapterView = class("LimitChapterView", ViewBase)

function LimitChapterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "LimitChapterViewAction")
end

function LimitChapterView:Awake()

end

function LimitChapterView:OnOpen()
end

function LimitChapterView:OnClose()

end
