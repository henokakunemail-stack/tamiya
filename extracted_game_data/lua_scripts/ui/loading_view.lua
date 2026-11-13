

---@class LoadingView : ViewBase
LoadingView = class("LoadingView", ViewBase)

--local _TweenSlider=nil
-- View必加
function LoadingView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "LoadingViewAction")

    self.currProgress = 0
    self.targetProgress = 0
    self.isAutoClose = true
    self.LoadFinishEvt = nil
    self.LoadFinishEvtParam = nil
end

function LoadingView:Awake()

    self.Slider = self:GetChildWight("Slider", typeof(Slider))

    self.LoadingImageList={
        "loadingpic_bg_1.png","loadingpic_bg_2.png","loadingpic_bg_4.png","loadingpic_bg_5.png"
    }
    self.Tip={}
    local data= ClientDataManager:Get():GetDataTable(ConfigNames.loadingtips_config).GetConfigData()
    for k, v in pairs(data) do
        table.insert(self.Tip,v.templestrid)
    end
    self.BtnChange=CommonHelper:HButtonSetCallback("BtnHit",self.gameObject,function(data)
        CommonHelper:SetBtnDelayClick(self.BtnChange, 1, false)
        self:SetTipText()
    end)
end

function LoadingView:SetTipText()
   local text= self.Tip[math.random( 1,#self.Tip)]
    CommonHelper:SetText("###hittext",self.gameObject,CommonHelper:GetTempStr_Default(text))
end



function LoadingView:OnOpen()
    log("LoadingView:OnOpen()")
    local iconName = self.LoadingImageList[math.random(1,#self.LoadingImageList)]
    self:SetTipText()
    print("loadingview------->>"..iconName)
    CommonHelper:GetComponentSetUITexture("bg",self.gameObject, iconName, UIModuleID.Loading)
    CommonHelper:SetText("###PrecessValueText", self.gameObject, string.format("00.00"))
    self.currProgress = 0
    self.targetProgress = 0
    self.Slider.value = 0
    self:UpdateProgress(0)
    GameUpdate.Get():AddUpdate(GameUpdateID.LoadingView, function()
        self:SliderAni()
    end)
end

function LoadingView:OnClose()
    log("---   ^^^   test  GameUpdate.Get():RemoveUpdate(GameUpdateID.LoadingView)" )
    GameUpdate.Get():RemoveUpdate(GameUpdateID.LoadingView)
    CommonHelper:ReleasePool(UIModuleID.Loading)
end



function LoadingView:SliderAni()
    if self.currProgress >= 1 then
        if self.isAutoClose then
            CommonHelper:CloseLoading()
            self:LoadingProgressFinish()
        else
            self:LoadingProgressFinish()
        end
    end


    local a = self.currProgress
    local b = self.targetProgress
    local value = CommonHelper:MathLerpFloat(a, b, CSTime.deltaTime * LoadingSpeed)
    --log("---   ^^^   test  SliderAni" ,a,b,value)
    self.currProgress = value
    CommonHelper:SetText("###PrecessValueText", self.gameObject, string.format("%0.2f",value * 100))
    CommonHelper:SetSliderValue(self.Slider, value)
end


function LoadingView:SetAutoClose( isclose )
    self.isAutoClose = isclose
end

function LoadingView:SetFinishEvt( evt, param )
    self.LoadFinishEvt = evt
    self.LoadFinishEvtParam = param
end


function LoadingView:LoadingProgressFinish()
    log("---   LoadingView   loadfinish!")
    if self.LoadFinishEvt then
        self.LoadFinishEvt(self.LoadFinishEvtParam)
    end
    self.LoadFinishEvt = nil
    self.LoadFinishEvtParam = nil
end

function LoadingView:UpdateProgress( progress )
    --log("---   ^^^   test  loading progress: value = " , progress, "   tar = " , self.targetProgress)
    if progress > self.targetProgress then
        self.targetProgress = progress
    end

end

function LoadingView:UpdateLoadingFinish()
    log("---   LoadingView:UpdateLoadingFinish()    1.2")
    self:UpdateProgress(1.2)
end


function LoadingView:TweenSlider()

end





