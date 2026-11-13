---@class BreakGuide
BreakGuide=class("BreakGuide",GuideBase)

function BreakGuide:initialize()

end
function BreakGuide:OnEnter()
    GuideBase.OnEnter(self)
end
function BreakGuide:OnExecute()
    GuideBase.OnExecute(self)
end

function BreakGuide:OnEnd(type)
    GuideBase.OnEnd(self,type)
end
