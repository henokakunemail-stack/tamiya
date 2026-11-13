---@class RaceSuperBattleEnterView : ViewBase
RaceSuperBattleEnterView = class("RaceSuperBattleEnterView", ViewBase)

function RaceSuperBattleEnterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSuperBattleEnterViewAction")
end

function RaceSuperBattleEnterView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)
    self.BtnGarage = CommonHelper:HButtonSetCallback("BtnGarage", self.gameObject, function(data)
        SkipModuleHelper:Get():ToGarage(UIModuleID.RaceSuperBattleEnter)
    end)
    CommonHelper:HButtonSetCallback("BtnHelp",self.gameObject,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceSuperBattle)
    end)

    self.BtnGarage = CommonHelper:HButtonSetCallback("BtnEnter", self.gameObject, function(data)
        local carIdx=""
        local isSelectCar=true
        local isCarCanRun=true
        for i = 1, #self.Cars do
            if isSelectCar and self.Cars[i].CarIdx==0 then
                isSelectCar=false
                break
            end
            if isCarCanRun and self.Cars[i].CarIdx>0 then
                if not CarDataManager:Get():CheckCarCompleteness(self.Cars[i].CarIdx) then
                    isCarCanRun=false
                    break
                end
            end

            if i==#self.Cars then
                carIdx=string.format("%s%d",carIdx,self.Cars[i].CarIdx)
            else
                carIdx=string.format("%s%d:",carIdx,self.Cars[i].CarIdx)
            end
        end
        if isSelectCar and isCarCanRun then
            if RaceSuperBattleManager:Get():IsSelectCarState(RaceSuperBattleManager:Get():GetData():GetRaceState()) then
                RaceSuperBattleSubsystem:Get():SendMsg_SelectCar(carIdx)
            else
                RaceSuperBattleSubsystem:Get():SendMsg_JoinRaceSuperBattle(carIdx)
            end

        else
            if isSelectCar==false then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleNoCar,RaceSuperBattleManager:Get():GetData():GetMatchNum()))
            end
        end

    end)
    self.ScrollView=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Track",self.gameObject,typeof(MoreRowScrollView))
    self.Pre_SelectCar = UIUtil.GetChild("Page_SelectCar", self.gameObject)
    self.Page_SelectCar_Five = UIUtil.GetChild("Page_SelectCar_Five", self.gameObject)
end

function RaceSuperBattleEnterView:OnOpen()
    self:SetData()
    self:SetView()
    self:OnAutoSelect()
    self:SetCarFive(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
    self:SetDefault()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
end
function RaceSuperBattleEnterView:ReOpen()
    if self.Cars[self.SelectIdx].CarIdx>0 then
        self:SetCarMesh(self.Cars[self.SelectIdx].CarIdx)
    else
        for k, v in pairs(self.Cars) do
            if v.CarIdx~=0 then
                self:ClickTrack(k,true)
                self:SetCarMesh(v.CarIdx)
                break
            end
        end
    end
    if self.PreCarFive then
        self.PreCarFive:RefreshIcon()
    end
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
end
function RaceSuperBattleEnterView:SetCarFive(idx)
    if self.PreCarFive==nil then
        self.PreCarFive=Page_SelectCar_Five()
    end
    if RaceSuperBattleManager:Get():IsSelectCarState(RaceSuperBattleManager:Get():GetData():GetRaceState()) then
        local carIds= RaceSuperBattleManager:Get():GetData():GetCarIds()
        if carIds and #carIds>1 then
            idx=carIds[1]
        end
    end
    self.PreCarFive:SetData(self.Page_SelectCar_Five,UIModuleID.RaceSuperBattleEnter, idx, false,function(idx, isautoselect)
        self:SetCarMesh(idx)
        if  self.Cars[self.SelectIdx].CarIdx~=0 then
            self.PreCarFive:SetState(self.Cars[self.SelectIdx].CarIdx,CarSelectStatus.Normal)
        end
        self.Cars[self.SelectIdx].CarIdx=idx
        self.Cars[self.SelectIdx].State=CarSelectStatus.Normal
        CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
    end)
end
function RaceSuperBattleEnterView:SetCarMesh(idx)
    if self.Page_SelectCar == nil then
        self.Page_SelectCar = Page_SelectCar()
    end
    self:SetPageSelectCar(idx)
end
function RaceSuperBattleEnterView:SetData()
    self.Cars={}
    for i = 1, RaceSuperBattleManager:Get():GetData():GetMatchNum() do
        local temp={CarIdx=0,State=CarSelectStatus.None}
        table.insert(self.Cars,temp)
    end
end
function RaceSuperBattleEnterView:SetDefault()
    if RaceSuperBattleManager:Get():IsSelectCarState(RaceSuperBattleManager:Get():GetData():GetRaceState()) then
        local carIds= RaceSuperBattleManager:Get():GetData():GetCarIds()
        if carIds then
            for i = 1, #carIds do
                if self.Cars[i] then
                    self.Cars[i].CarIdx=carIds[i]
                    self.Cars[i].State=CarSelectStatus.Use
                    self.PreCarFive:SetState(carIds[i],CarSelectStatus.Use)
                end
            end
            self.PreCarFive:SetState(carIds[1],CarSelectStatus.Select)
            CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
        end
    end
end

---@param data CarData
function RaceSuperBattleEnterView:SetPageSelectCar(idx)
    if self.Page_SelectCar then
        self.Page_SelectCar:SetData(self.Pre_SelectCar, UIModuleID.RaceSuperBattleEnter, idx, false, SceneChangeID.RefitTable, false)
    end
end

function RaceSuperBattleEnterView:OnOpenAnimEnd()

end

function RaceSuperBattleEnterView:OnClose()
    self:StopTime()
    CommonHelper:ReleasePool(UIModuleID.RaceSuperBattleEnter)
end

function RaceSuperBattleEnterView:OnAutoClose()

end
function RaceSuperBattleEnterView:OnAutoSelect()
    self:ClickTrack(1,true)
end
function RaceSuperBattleEnterView:ClickTrack(idx,isRefresh)
    isRefresh =isRefresh and isRefresh or false
    if self.SelectIdx==idx and isRefresh==false then return end
    self.SelectIdx=idx
    if self.Cars[self.SelectIdx].CarIdx~=0 then
        self.PreCarFive:SetState(self.Cars[self.SelectIdx].CarIdx,CarSelectStatus.Select)
    end
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
end
function RaceSuperBattleEnterView:StartTime()
    self:StopTime()
    self.subTime = RaceSuperBattleManager:Get():GetData():GetStageEndTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    self.TimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
        if self.subTime <= 0 then
            self:StopTime()
            cs_coroutine.start(function()
                coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
                RaceSuperBattleSubsystem:Get():SendMsg_EnterRaceSuperBattle()
            end)
        end
        local day = math.modf(self.subTime / TimeSecond_Day)
        class.day = day
        local hour = math.modf((self.subTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
        local minute = math.modf((self.subTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
        local second = self.subTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)
        self.subTime = self.subTime - 1
        --hour=day*24+hour
        if day >= 1 then
            CommonHelper:SetText("###subtime", self.gameObject,
                    CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleSelectSubTime,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, day, hour, minute)))
        else
            CommonHelper:SetText("###subtime", self.gameObject,
                    CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleSelectSubTime,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, hour, minute, second)))
        end
    end, self)
end
function RaceSuperBattleEnterView:SetView()
    self:StartTime()
    self.CarTogGroup={}
    self.SelectCarGroup={}
    CommonHelper:InitMoreRowScrollView(self.ScrollView,5,1,function(index, itemObj,scroll)
        CommonHelper:SetGameObjectActive("bgplayer",itemObj,self.Cars[index+1]~=nil)
        CommonHelper:SetGameObjectActive("bgnull",itemObj,self.Cars[index+1]==nil)
        if self.Cars[index+1] then
            CommonHelper:SetGameObjectActive("itemselect",itemObj,self.SelectIdx==index+1)
            CommonHelper:SetText("###name",itemObj,CommonHelper:GetParkingSpaceName(index+1))
           CommonHelper:HButtonSetCallback("BtnItem",itemObj,function(hbtn)
               if self.SelectIdx==hbtn.intData then return end
               if self.Cars[self.SelectIdx].CarIdx~=0 then
                   self.PreCarFive:SetState(self.Cars[self.SelectIdx].CarIdx,CarSelectStatus.Use)
                   self.Cars[self.SelectIdx].State=CarSelectStatus.Use
                   CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
               end
               self:ClickTrack(hbtn.intData,false)
            end,index+1)
            CommonHelper:SetGameObjectActive("carid",itemObj,self.Cars[index+1].State~=CarSelectStatus.None)
            for j = 1, 5 do
               local item=CommonHelper:SetGameObjectActive(string.format("Pos%d",j),itemObj,self.Cars[index+1].CarIdx==j)
                if self.Cars[index+1].CarIdx==j then
                    CommonHelper:SetGameObjectActive("normal",item,self.Cars[index+1].State==CarSelectStatus.Normal or self.Cars[index+1].State==CarSelectStatus.Select)
                    CommonHelper:SetGameObjectActive("select",item,self.Cars[index+1].State==CarSelectStatus.Use  )
                end
            end
           local BtnSelect= CommonHelper:HButtonSetCallback("BtnSelect",itemObj,function(hbtn)
                if self.Cars[hbtn.intData].CarIdx~=0 and self.Cars[hbtn.intData].State==CarSelectStatus.Use  then
                    if self.Cars[hbtn.intData].CarIdx~=0 then
                        if hbtn.intData==self.SelectIdx then
                            self.PreCarFive:SetState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Select)
                            self.Cars[hbtn.intData].State=CarSelectStatus.Select
                            CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
                        else
                            self.PreCarFive:SetState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Normal)
                            self.Cars[hbtn.intData].State=CarSelectStatus.None
                            self.Cars[hbtn.intData].CarIdx=0
                            CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
                        end
                    end
                else
                    if self.Cars[hbtn.intData].CarIdx~=0 then
                        self.PreCarFive:SetState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Use)
                        self.Cars[hbtn.intData].State=CarSelectStatus.Use
                        CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
                    else
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChapterMoreCarNoOneCar))
                    end
                end
            end,index+1)
          CommonHelper:SetToggleState(BtnSelect,self.Cars[index+1].State==CarSelectStatus.Use)
        end
    end)
end

function RaceSuperBattleEnterView:StopTime()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId = nil
    end
end


