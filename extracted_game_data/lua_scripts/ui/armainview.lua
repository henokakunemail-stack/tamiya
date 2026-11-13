---@class ARMainView : ViewBase
ARMainView = class("ARMainView", ViewBase)

function ARMainView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ARMainViewAction")
    print("---   ARCarMainView 初始化完成")
end



function ARMainView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(data)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(data)
        CommonHelper:ShowHelpView(PageDetailType.CustomTrack)
    end)

    CommonHelper:SetGameObjectActive("BtnHelp", self.gameObject, false)
    self.CarOperatingTypeView = UIUtil.GetTypeChildWightByParent("CarOperatingTypeView",self.gameObject,typeof(MoreRowScrollView))
    self.BtnReset = CommonHelper:HButtonSetCallback("BtnReset", self.gameObject, function(data)
        --ARManager:Get():ResetARMainState()
        ARManager:Get():ResetAR()
        ARStateControl:Get():ChangeState(ARState.ARRunning)
        UINotify:Get():SendNotification(UINotifyEvent.ARState_Update)
    end)

    self.BtnChangeCarSign = CommonHelper:HButtonSetCallback("BtnChangeCarSign", self.gameObject, function(data)
        ARManager:Get():ChangeCar()
    end)

    CommonHelper:CSGameObjectSetActive(self.BtnChangeCarSign.gameObject,false)
    CommonHelper:CSGameObjectSetActive(self.BtnReset.gameObject,false)
    self.Ready = self:GetChild("Ready")
    self:ARState_Update()
    --CommonHelper:SetGameObjectActive("BtnReset", self.gameObject, false)
    self.stringTemp={}
    table.insert(self.stringTemp,CommonHelper:GetTempStr_Default(TemplateStringID.ARFunctionCarMove))
    table.insert(self.stringTemp,CommonHelper:GetTempStr_Default(TemplateStringID.ARFunctionCarRotate))
    table.insert(self.stringTemp,CommonHelper:GetTempStr_Default(TemplateStringID.ARFunctionPlayAni))
    table.insert(self.stringTemp,CommonHelper:GetTempStr_Default(TemplateStringID.ARFunctionPlayAniStop))
    table.insert(self.stringTemp,CommonHelper:GetTempStr_Default(TemplateStringID.ARFunctionCarCollision))

end

function ARMainView:OnOpen()
    log(" ARMainView:OnOpen ")
    self:ARState_Update()
end

function ARMainView:ReOpen()
    log(" ARMainView:ReOpen ")
    self:ARState_Update()
end

---@param state ARState
---@param subState ARSubState
function ARMainView:ARState_Update()
    local state = ARStateControl:Get().curState
    local subState = ARStateControl:Get().subState
    if ARManager:Get():ISSelfCar() then
        CommonHelper:SetText("###text",self.BtnChangeCarSign.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.ARUseExhibitCar))
    else
        CommonHelper:SetText("###text",self.BtnChangeCarSign.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.ARUseSelfCar))
    end

    CommonHelper:CSGameObjectSetActive(self.Ready,state == ARState.Ready)
    CommonHelper:CSGameObjectSetActive(self.BtnReset.gameObject,state == ARState.CarOperating)
    CommonHelper:CSGameObjectSetActive(self.CarOperatingTypeView.gameObject,state == ARState.CarOperating)
    if state == ARState.CarOperating then
        local count = 5
        --if ARManager:Get():ISSelfCar() then
        --    count=2
        --end
        self.subState = subState
        CommonHelper:InitMoreRowScrollView(self.CarOperatingTypeView,count,5,function (index, item,scroll)
            CommonHelper:SetText("tweenhover/###text", item ,self.stringTemp[index+1])
            CommonHelper:SetText("tweennormal/###text", item ,self.stringTemp[index+1])
            local tempSubState = 301+index
            local Tog=CommonHelper:HButtonSetCallback("Toggle",item,function (data)
                if  self.subState ~= data.intData then
                    ARStateControl:Get():ChangeSubState(data.intData)
                    self:ARState_Update()
                end
            end,tempSubState)
            CommonHelper:SetToggleState(Tog,self.subState == tempSubState)
        end,nil,nil,false)
    end
end
function ARMainView:OnClose()
    --ARManager:Get():EndARCar()
    ARManager:Get():ARExit()
end

