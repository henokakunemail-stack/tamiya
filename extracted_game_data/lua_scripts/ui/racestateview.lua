---@class RaceStateView : ViewBase
RaceStateView = class("RaceStateView", ViewBase)

function RaceStateView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceStateViewAction")
end

function RaceStateView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RaceStateView:OnOpen()

end

function RaceStateView:OnClose()
   CommonHelper:ReleasePool(self.UIModuleID)
end

function RaceStateView:SetData(type)
    local data={}
    self.UIModuleID=type
    if type==UIModuleID.RaceGVG then
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictgvgpointseason_config,RaceGVGManager:Get():GetSeasonId())
        local StartTime=CommonHelper:ConvertIntToDataTime(cfg.start1*1000)
        local endTime=CommonHelper:ConvertIntToDataTime(cfg.end1*1000)
        table.insert(data,{tittle=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGvgStateTime,StartTime.Month, StartTime.Day, StartTime.Hour,StartTime.Second,endTime.Month, endTime.Day, endTime.Hour,endTime.Second),desc=CommonHelper:GetTempStr_Default(cfg.racegvgapplicationdes)})
        StartTime=CommonHelper:ConvertIntToDataTime(cfg.start2*1000)
        endTime=CommonHelper:ConvertIntToDataTime(cfg.end2*1000)
        table.insert(data,{tittle=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGvgStateTime,StartTime.Month, StartTime.Day, StartTime.Hour,StartTime.Second,endTime.Month, endTime.Day, endTime.Hour,endTime.Second),desc=CommonHelper:GetTempStr_Default(cfg.racegvgfirstdes)})
        StartTime=CommonHelper:ConvertIntToDataTime(cfg.start3*1000)
        endTime=CommonHelper:ConvertIntToDataTime(cfg.end3*1000)
        table.insert(data,{tittle=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGvgStateTime,StartTime.Month, StartTime.Day, StartTime.Hour,StartTime.Second,endTime.Month, endTime.Day, endTime.Hour,endTime.Second),desc=CommonHelper:GetTempStr_Default(cfg.racegvgseconddes)})
        StartTime=CommonHelper:ConvertIntToDataTime(cfg.start4*1000)
        endTime=CommonHelper:ConvertIntToDataTime(cfg.end4*1000)
        table.insert(data,{tittle=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGvgStateTime,StartTime.Month, StartTime.Day, StartTime.Hour,StartTime.Second,endTime.Month, endTime.Day, endTime.Hour,endTime.Second),desc=CommonHelper:GetTempStr_Default(cfg.racegvgthirddes)})
        StartTime=CommonHelper:ConvertIntToDataTime(cfg.over1*1000)
        endTime=CommonHelper:ConvertIntToDataTime(cfg.over2*1000)
        table.insert(data,{tittle=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGvgStateTime,StartTime.Month, StartTime.Day, StartTime.Hour,StartTime.Second,endTime.Month, endTime.Day, endTime.Hour,endTime.Second),desc=CommonHelper:GetTempStr_Default(cfg.racegvgsettlementdes)})
    end
    if type==UIModuleID.RaceSuperBattle then
        local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictkillerstage_config)
        local raceStartTime=CommonHelper:ConvertIntToDataTime(RaceSuperBattleManager:Get():GetData() :GetRaceBeginTime()*1000)
        for k,v in pairs(cfg.GetConfigData()) do
            local temp={}
            local startTime=raceStartTime:AddDays(v.addstage)
            local endTime=raceStartTime:AddDays(v.addstage1)
            temp.tittle=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleStateTime,startTime.Year, startTime.Month, startTime.Day,v.btime,endTime.Year, endTime.Month, endTime.Day,v.etime)
            temp.desc=CommonHelper:GetTempStr_Default(v.desc)
            table.insert(data,temp)
        end

    end


  CommonHelper:InitMoreRowScrollView(self.ScrollView,#data,1,function(dataIndex, rowitem, scroll)
      CommonHelper:SetText("###date",rowitem,data[dataIndex+1].tittle)
      CommonHelper:SetText("###content",rowitem,data[dataIndex+1].desc)
      CommonHelper:SetGameObjectActive("wenli",rowitem,dataIndex%2==1)

  end)
end

function RaceStateView:GetTime(time)
   local DataTime= CommonHelper:ConvertIntToDataTime(time*1000)
    return CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGTimeFormat,DataTime.Year,DataTime.Month,DataTime.Day,DataTime.Hour,DataTime.Minute)
end