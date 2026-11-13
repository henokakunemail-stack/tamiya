---@class ClickGuide
ClickGuide=class("ClickGuide",GuideBase)

function ClickGuide:initialize()

end
function ClickGuide:OnEnter()
    GuideBase.OnEnter(self)
end
function ClickGuide:OnExecute()
    GuideBase.OnExecute(self)
end

function ClickGuide:OnEnd(type)
    GuideBase.OnEnd(self,type)
end
