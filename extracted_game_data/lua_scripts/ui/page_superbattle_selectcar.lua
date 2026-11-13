---@class Page_SuperBattle_SelectCar
Page_SuperBattle_SelectCar=class("Page_SuperBattle_SelectCar")

function Page_SuperBattle_SelectCar:initialize()

end
function Page_SuperBattle_SelectCar:SetData(root)
    self.gameObject=root
    self.Data=RaceSuperBattleManager:Get():GetData()
    CommonHelper:HButtonSetCallback("BtnTask",root,function (hbtn)
        if UIManager:Get():IsViewShow("TaskView") == false then
            UIManager:Get():OpenView("TaskView", CanvasType.MainCanvas, "TaskView")
        end
        TaskDataManager:Get():SetOpenModuleType(UIModuleID.RaceSuperBattle)
        UINotify:Get():SendNotification(UINotifyEvent.TaskViewSetData, TaskType.SuperBattle)
    end)
    CommonHelper:HButtonSetCallback("BtnFight", self.gameObject, function(data)
        local carIdx=""
        local isSelectCar=true
        local isCarCanRun=true
        for i = 1, self.Data:GetMatchNum() do
            if isSelectCar and self.Cars[i].CarIdx==0 then
                isSelectCar=false
                break
            end
            if i==self.Data:GetMatchNum() then
                carIdx=string.format("%s%d",carIdx,self.Cars[i].CarIdx)
            else
                carIdx=string.format("%s%d:",carIdx,self.Cars[i].CarIdx)
            end
        end
        if isSelectCar then
            RaceSuperBattleSubsystem:Get():SendMsg_ConfirmCar(carIdx)
        else
            if isSelectCar==false then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleNoCar,self.Data:GetMatchNum()))
            end
        end

    end)
    CommonHelper:HButtonSetCallback("BtnRankList2", self.gameObject, function(data)
        if  RaceSuperBattleManager:Get():IsKnockoutState(self.Data:GetRaceState()) then
            if RaceSuperBattleManager:Get():IsKnockout8State(self.Data:GetMatchRankState()) then
                RaceSuperBattleSubsystem:SendMsg_RaceSuperBattle64Rank(9)
            else
                RaceSuperBattleSubsystem:SendMsg_RaceSuperBattle64Rank(1)
            end
        else
            RaceSuperBattleSubsystem:Get():SendMsg_RaceSuperBattleRank()
        end

    end)



    self.TogTrackGroup={}
    self.TogCarGroup={}
    for i = 1, 5 do
        local  tog=CommonHelper:HButtonSetCallback(string.format("ToggleYellow%d",i),self.gameObject,function (hbtn)
            self:TogTrackClick(i,true)
        end,i)
        self.TogTrackGroup[i]=tog
        CommonHelper:SetHButtonClick(tog,self.Data.TrackIds[i]~=nil,true)
    end
    self.CarGroup={}
    local carIds= self.Data:GetCarIds()
    if carIds==nil or #carIds<1 then carIds={1,2,3} end
    for i = 1, 5 do
        self.CarGroup[i]={}
        if self.Data.Cars[i]~=nil then
            self.CarGroup[i].CarIdx=i
            if self.CarGroup[i].CarIdx==carIds[1]  then
                self.CarGroup[i].State=CarSelectStatus.Normal
            else
                if self.Data:GetMatchNum()<=1 then
                    self.CarGroup[i].State=CarSelectStatus.Normal
                else
                    self.CarGroup[i].State=CarSelectStatus.Use
                end
            end
        else
            self.CarGroup[i].CarIdx=i
            self.CarGroup[i].State=CarSelectStatus.None
        end
    end
    for i = 1, 5 do
        local itemObj=UIUtil.GetChildInputPath(string.format("CaridxGroup/Pos%d",i),self.gameObject)
        self.TogCarGroup[i]=CommonHelper:HButtonSetCallback("BtnPos",itemObj,function (hbtn)
            self:TogCarClick(hbtn.intData,false)
        end,i)
        CommonHelper:SetGameObjectActive("open",itemObj,self.CarGroup[i].State~=CarSelectStatus.None)
        CommonHelper:SetGameObjectActive("lock",itemObj,self.CarGroup[i].State==CarSelectStatus.None)
    end
    self.Cars={}
    for i = 1, 5 do
        self.Cars[i]={}
        if self.Data:GetMatchNum()>=i then
            self.Cars[i].CarIdx=carIds[i]
            if i==1 then
                self.Cars[i].State=CarSelectStatus.Normal
            else
                self.Cars[i].State=CarSelectStatus.Use
            end
        else
            self.Cars[i].CarIdx=i
            self.Cars[i].State=CarSelectStatus.None
        end
    end
    self.ScrollView=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Track",self.gameObject,typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView,5,1,function(index, itemObj,scroll)
        CommonHelper:SetGameObjectActive("bgplayer",itemObj,self.Cars[index+1].State~=CarSelectStatus.None)
        CommonHelper:SetGameObjectActive("bgnull",itemObj,self.Cars[index+1].State==CarSelectStatus.None)
        if self.Cars[index+1].State~=CarSelectStatus.None then
            CommonHelper:SetText("###name",itemObj,CommonHelper:GetParkingSpaceName(index+1))
            if self.Data:GetMatchRacer(index+1) then
                CommonHelper:SetPlayerIconById("PlayerIcon100", itemObj, self.Data:GetMatchRacer(index+1).HeadIcon, self.Data:GetMatchRacer(index+1).IconFrame, nil, UIModuleID.RaceSuperBattleSelectCar)
            else
                CommonHelper:SetPlayerIconById("PlayerIcon100",  itemObj, 0, 0, nil, UIModuleID.RaceSuperBattleSelectCar)
            end

            for i = 1, 5 do
                CommonHelper:SetGameObjectActive(string.format("Toggle%d",i),itemObj,i==index+1)
            end
            local Tog= CommonHelper:HButtonSetCallback(string.format("Toggle%d",index+1),itemObj,function(hbtn)
                if self.SelectCellIdx==hbtn.intData then return end
                if self.Cars[self.SelectCellIdx].CarIdx~=0 then
                    self:SetCarState(self.Cars[self.SelectCellIdx].CarIdx,CarSelectStatus.Use)
                    self.Cars[self.SelectCellIdx].State=CarSelectStatus.Use
                    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
                end
                self:ClickPlayerTrack(hbtn.intData,false)
            end,index+1)
            CommonHelper:SetToggleState(Tog,self.SelectCellIdx==index+1)
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
                        if hbtn.intData==self.SelectCellIdx then
                            self:SetCarState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Select)
                            self.Cars[hbtn.intData].State=CarSelectStatus.Select
                            CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
                        else
                            self:SetCarState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Normal)
                            self.Cars[hbtn.intData].State=CarSelectStatus.Normal
                            self.Cars[hbtn.intData].CarIdx=0
                            CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
                        end
                    end
                else
                    if self.Cars[hbtn.intData].CarIdx~=0 then
                        self:SetCarState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Use)
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
    self:ClickPlayerTrack(1,true)
    self:TogTrackClick(1,false)
    self:TogCarClick(self.Cars[1].CarIdx,true)
end


function Page_SuperBattle_SelectCar:ClickPlayerTrack(idx,isRefresh)
    isRefresh =isRefresh and isRefresh or false
    if self.SelectCellIdx==idx and isRefresh==false then return end
    self.SelectCellIdx=idx
    if self.Cars[self.SelectCellIdx].CarIdx~=0 then
        self:SetCarState(self.Cars[self.SelectCellIdx].CarIdx,CarSelectStatus.Select)
    end
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
end

function Page_SuperBattle_SelectCar:SetCarState(idx,state)
    if self.CarGroup[idx] then
        self.CarGroup[idx].State= state
        self:SetTogStateGroup()
    end
end
function Page_SuperBattle_SelectCar:SetTogCarState(gameObject,k)
    CommonHelper:SetGameObjectActive("normal",gameObject,CarSelectStatus.None == self.CarGroup[k].State or CarSelectStatus.Normal == self.CarGroup[k].State or CarSelectStatus.Use == self.CarGroup[k].State)
    CommonHelper:SetGameObjectActive("select",gameObject,CarSelectStatus.Select == self.CarGroup[k].State)
    CommonHelper:SetGameObjectActive("use",gameObject,CarSelectStatus.Use == self.CarGroup[k].State)
end

function Page_SuperBattle_SelectCar:TogCarClick(idx, refresh)
    if self.CarGroup[idx].State==CarSelectStatus.Normal or self.CarGroup[idx].State==CarSelectStatus.Select then
        if refresh == nil then refresh = false end
        if self.CurCarTog == idx and refresh == false and  self.CarGroup[idx].State==CarSelectStatus.Select then return end
      --  if self.CarGroup[idx].State==CarSelectStatus.Normal then
            self.CarGroup[idx].State=CarSelectStatus.Select
            if not refresh then
              self:SetCarState(self.Cars[self.SelectCellIdx].CarIdx,CarSelectStatus.Normal)
            end
            self.Cars[self.SelectCellIdx].CarIdx=idx
            self.Cars[self.SelectCellIdx].State=CarSelectStatus.Select
            CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)

            for i = 1, #self.CarGroup do
                if idx~=i and self.CarGroup[i].State==CarSelectStatus.Select then
                    self.CarGroup[i].State=CarSelectStatus.Normal
                end
            end
      --  end

        self.CurCarTog = idx
        self:SetCarMesh(self.Data.Cars[self.CurCarTog])
        self:SetTogStateGroup()
    else
        if self.CarGroup[idx].State==CarSelectStatus.None then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CarIdxGroupLock))
        end
        if self.CarGroup[idx].State==CarSelectStatus.Use then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CarIdxGroupUse))
        end
    end
end
function Page_SuperBattle_SelectCar:SetTogStateGroup()
    for i = 1, #self.TogCarGroup do
        self:SetTogCarState(self.TogCarGroup[i].gameObject,i)
    end
end

function Page_SuperBattle_SelectCar:Release()
    CommonHelper:ReleasePool(UIModuleID.RaceSuperBattleSelectCar)
    HomeSceneCarMeshHelper:Get():ClearCache()
    self.CurCarTog = -1
end


function Page_SuperBattle_SelectCar:SetCarMesh(carData)
    HomeSceneCarMeshHelper:Get():SetDataByCarReviewData(carData,SceneChangeID.RefitTable,nil)
    CommonHelper:GetComponentSetUITexture("carname", self.gameObject, carData.ShellCfg.carNameIcon,UIModuleID.RaceSuperBattleSelectCar)

end
function Page_SuperBattle_SelectCar:ReOpen()

end






function Page_SuperBattle_SelectCar:TogTrackClick(idx,check)
    if check and idx==self.SelectTrackIdx then return end
    self.SelectTrackIdx=idx
    for i = 1, 5 do
        CommonHelper:SetToggleState(self.TogTrackGroup[i],idx==i)
    end
    self:SetTrackIcon()
end

function Page_SuperBattle_SelectCar:SetTrackIcon()
    local trackData=CommonHelper:GetRacetrackData(self.Data.TrackIds[self.SelectTrackIdx])
    CommonHelper:SetTrackFeatureByParent("trackfeature",self.gameObject,trackData:GetFeature(),true)
    CommonHelper:GetComponentSetTrackIconByData("trackicon",self.gameObject,trackData,UIModuleID.RaceSuperBattleSelectCar)
    CommonHelper:HButtonSetCallback("BtnReview",self.gameObject,function(hbtn)
        CommonHelper:LoadReviewTrack(nil,trackData)
    end)
    ---@type scene_config_cell
    local sceneCfg=CommonHelper:GetTableDataByID(ConfigNames.scene_config,self.Data.Scenes[self.SelectTrackIdx])
    if sceneCfg then
        CommonHelper:GetComponentSetUITexture("chapterpic",self.gameObject,sceneCfg.icon,UIModuleID.RaceSuperBattleSelectCar)
    end
    self:SetPlayerIcon(self.SelectTrackIdx)
end

function Page_SuperBattle_SelectCar:SetPlayerIcon(idx)
    if self.Data:GetMatchRacer(idx) then
        CommonHelper:SetText("###playername", self.gameObject, self.Data:GetMatchRacer(idx).Name)
        CommonHelper:SetText("###clubername",  self.gameObject, "")
        --头像
        CommonHelper:SetPlayerIconById("PlayerIcon", self.gameObject, self.Data:GetMatchRacer(idx).HeadIcon, self.Data:GetMatchRacer(idx).IconFrame, nil, UIModuleID.RaceSuperBattleSelectCar)
    else
        CommonHelper:SetText("###playername",  self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RacerNull))
        CommonHelper:SetText("###clubername",  self.gameObject, "")
        --头像
        CommonHelper:SetPlayerIconById("PlayerIcon",  self.gameObject, 0, 0, nil, UIModuleID.RaceSuperBattleSelectCar)
    end
end

