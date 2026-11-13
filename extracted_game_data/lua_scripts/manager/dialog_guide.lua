---@class DialogGuide
DialogGuide=class("DialogGuide",GuideBase)

function DialogGuide:initialize()

end

function DialogGuide:OnEnter()
    GuideBase.OnEnter(self)
end

function DialogGuide:OnExecute()
    GuideBase.OnExecute(self)
end

function DialogGuide:OnEnd(type)
    GuideBase.OnEnd(self,type)
end