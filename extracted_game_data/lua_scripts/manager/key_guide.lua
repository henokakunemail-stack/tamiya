---@class KeyGuide
KeyGuide=class("KeyGuide",GuideBase)

function KeyGuide:initialize()

end
function KeyGuide:OnEnter()
    GuideBase.OnEnter(self)
end
function KeyGuide:OnExecute()
    GuideBase.OnExecute(self)
end

function KeyGuide:OnEnd(type)
    GuideBase.OnEnd(self,type)
end
