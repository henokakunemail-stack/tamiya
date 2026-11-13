


---@class CarBuildMaskView : ViewBase
CarBuildMaskView = class("CarBuildMaskView", ViewBase)

function CarBuildMaskView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "CarBuildMaskViewAction")
end

function CarBuildMaskView:Awake()

end

function CarBuildMaskView:OnOpen()

end

function CarBuildMaskView:OnClose()

end