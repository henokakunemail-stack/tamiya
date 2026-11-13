---@class InitialView : ViewBase
InitialView = class("InitialView", ViewBase)
local _InitialViewSelectCar=nil
function InitialView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "InitialViewAction")

    print("---   InitialView 初始化完成")
end

function InitialView:Awake()
    print("---   InitialView awake")

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("InitialView")
    end)

    CommonHelper:HButtonSetCallback("BtnSure",self.gameObject,function (hbtn)
        local inputStr =  CommonHelper:GetInputFieldText("InputName",self.gameObject)
        if CommonHelper:IsNullOrEmpty(inputStr)  then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PlayerNameCannotBeNull))
        else
            if  CommonHelper:IsNullOrEmpty(StringTrim(inputStr)) then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PlayerNameCannotBeNull))
            else
                CommonHelper:RegexName(inputStr, function()
                    QuickTa:Get():TrackEvent(TrackEventNames.click_choose_role_btn, nil,TrackEventType.First,AnalysisType.click_choose_role_btn)
                    UINotify:Get():SendNotification(UINotifyEvent.InitialView_Sure)
                end)
            end
        end
        --if GameProperties.NewBieGuide==true  then
        --    NewBieGuideDataManager:Get():OnInit(PlayerDataManager:Get():GetGuideStep())
        --end
    end)

    self.BtnCar1= CommonHelper:HButtonSetCallback("BtnCar1",self.gameObject,function (hbtn)
        self:PlayerCarCVByIdx(1,true)
        UINotify:Get():SendNotification(UINotifyEvent.InitialView_SelectCar, 1)

    end)
    self.BtnCar2= CommonHelper:HButtonSetCallback("BtnCar2",self.gameObject,function (hbtn)
        self:PlayerCarCVByIdx(2,true)
        UINotify:Get():SendNotification(UINotifyEvent.InitialView_SelectCar, 2)

    end)
    self.BtnCar3=CommonHelper:HButtonSetCallback("BtnCar3",self.gameObject,function (hbtn)
        self:PlayerCarCVByIdx(3,true)
        UINotify:Get():SendNotification(UINotifyEvent.InitialView_SelectCar, 3)
    end)
      self.BtnCar4=CommonHelper:HButtonSetCallback("BtnCar4",self.gameObject,function (hbtn)
        self:PlayerCarCVByIdx(4,true)
        UINotify:Get():SendNotification(UINotifyEvent.InitialView_SelectCar, 4)
    end)
    CommonHelper:SetBtnDelayClick(self.BtnCar1, 0, true)
    CommonHelper:SetBtnDelayClick(self.BtnCar2, 0, true)
    CommonHelper:SetBtnDelayClick(self.BtnCar3, 0, true)
    CommonHelper:SetBtnDelayClick(self.BtnCar4, 0, true)
    CommonHelper:HButtonSetCallback("BtnRandom",self.gameObject,function (hbtn)
        local name= CommonHelper:GetRandomName()
        CommonHelper:SetInputFieldText("InputName",self.gameObject,name)
    end)


    self.selectIdx = 0

    self.groupObj = {}
    for i = 1, 4 do
        local obj = UIUtil.GetChild("group"..i, self.gameObject)
        table.insert(self.groupObj, obj)
    end
    self.GuideDesc=self:GetChild("guidehead")
    self.TweenPlayer =self:GetChildWight("TweenPlayer",typeof(FXUITweenMoreGroup))

end
function InitialView:SetData()
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictcar_config)
    ---@type dictcar_config_cell[]
    local _Data=cfg.GetConfigData()
    _InitialViewSelectCar={}
    for k, v in pairs(_Data) do
        if v.cartype==1 then
            table.insert(_InitialViewSelectCar,v)
        end
    end
    table.sort(_InitialViewSelectCar,function(a, b)
        return a.sort<b.sort
    end)
end
function InitialView:OnOpen()
    self:SetData()
    self:CheckNewBieGuide(nil,nil,function()
        print("结束选车引导")
        CommonHelper:CloseGuideScreenEffectUIMask()
        --self:PlayerCarCVByIdx(3)
        --UIUtil:GameobjectLocalPositionY(self.GuideDesc, -400)
        --CommonHelper:TMG_PlayAllTween(self.TweenPlayer)
    end)
    self:AutoSelect()
    QuickTa:Get():TrackEvent(TrackEventNames.choose_race, nil,TrackEventType.First,AnalysisType.choose_race)
    QuickTa:Get():TrackEvent(TrackEventNames.OpenCreateNicknamePanel)
end


function InitialView:OnClose()
    if not CommonHelper:IsNullOrEmpty(self.cvName) then CommonHelper:Audio_StopAudioByName(self.cvName) end
    self.selectIdx=nil
    self:CheckExitNewBieGuide()
end
function InitialView:OnAutoClose()
    if not CommonHelper:IsNullOrEmpty(self.cvName) then CommonHelper:Audio_StopAudioByName(self.cvName) end
    self.selectIdx=nil
    self:CheckExitNewBieGuide()
end

function InitialView:AutoSelect()
    self:OnClickBtnCar(1)
end

function InitialView:OnClickBtnCar(idx)
    self.selectIdx = idx
    --for i = 1, 4 do
    --    self.groupObj[i]:SetActive(idx == i)
    --end
    self:UpDataSelect(idx)
    self:SetTittle(idx)
end
function InitialView:PlayerCarCVByIdx(idx,check)
    if check and self.selectIdx==idx  then return end
    if not CommonHelper:IsNullOrEmpty(self.cvName) then CommonHelper:Audio_StopAudioByName(self.cvName) end
    if  idx==1 then
        --黑色战神

        self.cvName="chose1_init.wav"
    end
    if  idx==2 then
        --音速战神

        self.cvName="chose3_init.wav"
    end
    if  idx==3 then
        --旋风冲锋

        self.cvName="chose2_init.wav"
    end
    --self:PlayerCarPersonByIdx(idx,check)
    -- CommonHelper:Audio_PlayAudio(self.cvName, AudioType.VOICE, false, 1, 0)
end
function InitialView:SetTittle(idx,check)
    if check and self.selectIdx==idx  then return end
    local tittle=nil
    if  idx==1 then
        --黑色战神

        tittle=TemplateStringID.InitViewTittle1
    end
    if  idx==2 then
        --音速战神

        tittle=TemplateStringID.InitViewTittle2
    end
    if  idx==3 then
        --旋风冲锋

        tittle=TemplateStringID.InitViewTittle3
    end
    if  idx==4 then
        --旋风冲锋

        tittle=TemplateStringID.InitViewTittle4
    end
    CommonHelper:SetText("###tittle", self.gameObject, CommonHelper:GetTempStr_Default(tittle))
end



function InitialView:PlayerCarPersonByIdx(idx,check)
    if check and self.selectIdx==idx  then return end
    if  idx==1 then
        --黑色战神
        self.Tips=CommonHelper:GetTempStr_Default(TemplateStringID.InitCar_1)
    end
    if  idx==2 then
        --音速战神
        self.Tips=CommonHelper:GetTempStr_Default(TemplateStringID.InitCar_2)
    end
    if  idx==3 then
        --旋风冲锋
        self.Tips=CommonHelper:GetTempStr_Default(TemplateStringID.InitCar_3)
    end
    CommonHelper:SetDoText("tipsborder/###tips",self.gameObject,self.Tips,1)
end
function InitialView:UpDataSelect(idx)
    CommonHelper:SetGameObjectActive("hover",self.BtnCar1.gameObject,idx==1)
    CommonHelper:SetGameObjectActive("hover",self.BtnCar2.gameObject,idx==2)
    CommonHelper:SetGameObjectActive("hover",self.BtnCar3.gameObject,idx==3)
    CommonHelper:SetGameObjectActive("hover",self.BtnCar4.gameObject,idx==4)
    CommonHelper:SetGameObjectActive("normal",self.BtnCar1.gameObject,idx~=1)
    CommonHelper:SetGameObjectActive("normal",self.BtnCar2.gameObject,idx~=2)
    CommonHelper:SetGameObjectActive("normal",self.BtnCar3.gameObject,idx~=3)
    CommonHelper:SetGameObjectActive("normal",self.BtnCar4.gameObject,idx~=4)
end

function InitialView:OnClickBtnSure()
    local value=CommonHelper:GetInputFieldText("InputName",self.gameObject)
    if getStringLength(value)>16 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangeNameNotLength))
        return
    end
    LoginSubSystem:Get():CreateUser(value,_InitialViewSelectCar[self.selectIdx].C_ID)
end



function InitialView:SelectSucceed()
    -- UIManager:Get():CloseView()
    SkipModuleHelper:Get():ToMainMenuView(true)
end