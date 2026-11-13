---@class RaceClub3V3View : ViewBase
RaceClub3V3View = class("RaceClub3V3View", ViewBase)

function RaceClub3V3View:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceClub3V3ViewAction")
end

function RaceClub3V3View:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)
    self.BtnGarage = CommonHelper:HButtonSetCallback("BtnGarage", self.gameObject, function(data)
        SkipModuleHelper:Get():ToGarage(UIModuleID.RaceClub3V3)
    end)
   CommonHelper:HButtonSetCallback("BtnReward", self.gameObject, function(data)
        UIManager:Get():ShowPersistentView("RaceClub3V3RewardView",CanvasType.MainCanvas,"RaceClub3V3RewardView")
    end)
    CommonHelper:HButtonSetCallback("BtnHelp",self.gameObject,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceClub3V3)
    end)

  self.BtnGarage = CommonHelper:HButtonSetCallback("BtnEnter", self.gameObject, function(data)
      local carIdx=""
      local isSelectCar=false
      local isCarCanRun=true
      for i = 1, #self.trackList do
          if isSelectCar==false and self.trackList[i].caridx>0 then
              isSelectCar=true
          end
          if isCarCanRun and self.trackList[i].caridx>0 then
              if not CarDataManager:Get():CheckCarCompleteness(self.trackList[i].caridx) then
                  isCarCanRun=false
                  break
              end
          end

          if i==#self.trackList then
              carIdx=carIdx..self.trackList[i].caridx
          else
              carIdx=carIdx..self.trackList[i].caridx..":"
          end
      end
      if isSelectCar and isCarCanRun then
          if RaceClub3V3Manager:Get():GetCurCount()<RaceClub3V3Manager:Get():GetMaxCount() then
              RaceClub3v3Subsystem:Get():SendMsg_BeginBattle(carIdx)
          else
              CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceClub3V3NoCount))
          end
      else
          if isSelectCar==false then
              CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceClub3V3NoCar))
          end
      end

    end)
    self.ScrollView=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Track",self.gameObject,typeof(MoreRowScrollView))
    self.Pre_SelectCar = UIUtil.GetChild("Page_SelectCar", self.gameObject)
    self.Page_SelectCar_Five = UIUtil.GetChild("Page_SelectCar_Five", self.gameObject)
end

function RaceClub3V3View:OnOpen()
    self:SetData()
    self:OnAutoSelect()
    self:SetCarFive(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
end
function RaceClub3V3View:ReOpen()
    self:SetCarFive(self.trackList[self.SelectIdx].caridx)
    for i = 1, #self.trackList do
        if i~=self.SelectIdx then
            if self.trackList[i].caridx>0 then
                self.PreCarFive:SetState(self.trackList[i].caridx,CarSelectStatus.Use)
            end
        end
    end
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
end
function RaceClub3V3View:SetCarFive(idx)
    if self.PreCarFive==nil then
        self.PreCarFive=Page_SelectCar_Five()
    end
   self.PreCarFive:SetData(self.Page_SelectCar_Five,UIModuleID.RaceClub3V3, idx, false,function(idx, isautoselect)
       self:SetCarMesh(idx)
       self.trackList[self.SelectIdx].caridx=idx
       CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
   end)
end
function RaceClub3V3View:SetCarMesh(idx)
    if self.Page_SelectCar == nil then
        self.Page_SelectCar = Page_SelectCar()
    end
    self:SetPageSelectCar(idx)
end
---@param data CarData
function RaceClub3V3View:SetPageSelectCar(idx)
    if self.Page_SelectCar then
        self.Page_SelectCar:SetData(self.Pre_SelectCar, UIModuleID.RaceClub3V3, idx, false, SceneChangeID.RefitTable, false)
    end
end

function RaceClub3V3View:OnOpenAnimEnd()

end

function RaceClub3V3View:OnClose()
   self:StopTime()
    CommonHelper:ReleasePool(UIModuleID.RaceClub3V3)
end

function RaceClub3V3View:OnAutoClose()

end
function RaceClub3V3View:OnAutoSelect()
    self:ClickTrack(1,true)
end
function RaceClub3V3View:ClickTrack(idx,isRefresh)
    isRefresh =isRefresh and isRefresh or false
    if self.SelectIdx==idx and isRefresh==false then return end
    self.SelectIdx=idx
    if self.trackList[self.SelectIdx].caridx~=0 then
        self.PreCarFive:SetState(self.trackList[self.SelectIdx].caridx,CarSelectStatus.Select)
    end
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
end
function RaceClub3V3View:SetData()
    self.trackList={}
    local tempTrack= RaceClub3V3Manager:Get():GetTrackList()
    local tempScene= RaceClub3V3Manager:Get():GetSceneList()
    RaceClub3V3Manager:Get():GetSceneList()
    for i = 1, #tempTrack do
        table.insert(self.trackList,{trackid=tempTrack[i],sceneId=tempScene[i],caridx=0})
    end
    self:StopTime()
    self.subTime = RaceClub3V3Manager:Get():GetEndTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    self.TimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
        if self.subTime <= 0 then
            self:StopTime()
        end
        local day = math.modf(self.subTime / TimeSecond_Day)
        class.day = day
        SeasonOrderDataManager:Get():SetDay(day)
        local hour = math.modf((self.subTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
        local minute = math.modf((self.subTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
        local second = self.subTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)
        self.subTime = self.subTime - 1
        --hour=day*24+hour
        if day >= 1 then
            CommonHelper:SetText("###subtime", self.gameObject,
                    CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, day, hour, minute))
        else
            CommonHelper:SetText("###subtime", self.gameObject,
                    CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, hour, minute, second))
        end

        --CommonHelper:SetText("###subtime", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.ReturnClub3V3SubTime,hour, minute, second))
    end, self)
      CommonHelper:SetText("###subcount",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.ReturnClub3V3SubCount,RaceClub3V3Manager:Get():GetCurCount(),RaceClub3V3Manager:Get():GetMaxCount()))
      CommonHelper:InitMoreRowScrollView(self.ScrollView,#self.trackList,1,function(index, itemObj,scroll)
      CommonHelper:GetComponentSetTrackIconByData("trackicon",itemObj,CommonHelper:GetRacetrackData(self.trackList[index+1].trackid),UIModuleID.RaceClub3V3)
      CommonHelper:SetTrackFeatureByParent("trackfeature",itemObj,CommonHelper:GetRacetrackData(self.trackList[index+1].trackid):GetFeature())
          ---@type scene_config_cell
          local sceneCfg=CommonHelper:GetTableDataByID(ConfigNames.scene_config,self.trackList[index+1].sceneId)
          if sceneCfg then
              CommonHelper:GetComponentSetUITexture("chapterpic",itemObj,sceneCfg.icon,UIModuleID.RaceClub3V3)
          end
      CommonHelper:HButtonSetCallback("BtnSelect",itemObj,function(hbtn)
          if self.SelectIdx==hbtn.intData then return end
          if self.trackList[self.SelectIdx].caridx~=0 then
              self.PreCarFive:SetState(self.trackList[self.SelectIdx].caridx,CarSelectStatus.Use)
          end
          self:ClickTrack(hbtn.intData,false)
      end,index+1)
      CommonHelper:HButtonSetCallback("BtnReview",itemObj,function(hbtn)
          local  trackdata=CommonHelper:GetRacetrackData(self.trackList[index+1].trackid)
          CommonHelper:LoadReviewTrack(nil,trackdata)
      end,index+1)
      CommonHelper:HButtonSetCallback("BtnRemove",itemObj,function(hbtn)
          if self.trackList[hbtn.intData].caridx~=0 then
              self.PreCarFive:SetState(self.trackList[hbtn.intData].caridx,CarSelectStatus.Normal)
          end
          self.trackList[hbtn.intData].caridx=0
          CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
      end,index+1)
      CommonHelper:SetGameObjectActive("select",itemObj,self.SelectIdx==index+1)
      if self.trackList[index+1].caridx==0 then
          CommonHelper:SetGameObjectActive("BtnRemove", itemObj, false)
      else
          CommonHelper:SetGameObjectActive("BtnRemove", itemObj, true)
          local carid=TeamCacheManager:Get():GetCarByIndex(self.trackList[index+1].caridx)
          CommonHelper:GetComponentSetUITextureByTexture("caricon",itemObj, CarBuilderManager:Get():GetCarBuilder(carid).CarIcon)
      end
  end)
end

function RaceClub3V3View:StopTime()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId = nil
    end
end


