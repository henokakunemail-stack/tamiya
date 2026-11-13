---@class GuideGarageGuide
GuideGarageGuide=class("GuideGarageGuide",GuideBase)

function GuideGarageGuide:initialize()

end

function GuideGarageGuide:OnEnter()
    GuideBase.OnEnter(self)
end

function GuideGarageGuide:OnExecute()
    GuideBase.OnExecute(self)
end

function GuideGarageGuide:OnEnd(type)
    GuideBase.OnEnd(self,type)
end