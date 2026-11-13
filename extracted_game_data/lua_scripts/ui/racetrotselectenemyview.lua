---@class RaceTrotSelectEnemyView : ViewBase
RaceTrotSelectEnemyView = class("RaceTrotSelectEnemyView", ViewBase)

function RaceTrotSelectEnemyView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTrotSelectEnemyViewAction")
end

function RaceTrotSelectEnemyView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelp",self.gameObject,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceTrot)
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(true,function()
            self:Clear()
        end)
    end)

    CommonHelper:HButtonSetCallback("BtnHistory",self.gameObject,function (hbtn)
        UIManager:Get():ShowPersistentView("RaceTrotHistoryView",CanvasType.FrontCanvas,"RaceTrotHistoryView")
    end)
    self.BtnRefresh= CommonHelper:HButtonSetCallback("BtnRefresh",self.gameObject,function (hbtn)
        local count= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotRefreshEnemyCount,false)
        if count-RaceTrotManager:Get():GetFreshFighter()>0 then
            local boxFunc = function()
                local value= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotRefreshEnemyCost,false)
                ---@type article_config_cell
                local cell= CommonHelper:GetTableDataByID(ConfigNames.article_config,CurrencyType.Diamond)
                value=string.format("%d%s",value,CommonHelper:GetTempStr_Default(cell.name))
                local tips=CommonHelper:GetTempStr_Default(TemplateStringID.RefreshEnemyTips,value)
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.RefreshEnemyTittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
                if ret == MessageBoxHelp.BtnType.OK then
                    RaceTrotSubsystem:Get():SendMsg_RefreshEnemy()
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RefreshEnemyCountNo))
        end

    end)

    self.BtnObservation=CommonHelper:HButtonSetCallback("BtnObservation",self.gameObject,function (hbtn)
        local emmy=  RaceTrotManager:Get():GetGetEnemyDataByIdx(self.SelectIdx)
        local Watched=RaceTrotManager:Get():GetGetEnemyWatchedById(emmy.Id)
        if Watched then
            CommonHelper:ShowCarInfoByCarReviewData(emmy.Car)
        else
            local boxFunc = function()
                local id= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotObservationId,false)
                ---@type article_config_cell
                local cell= CommonHelper:GetTableDataByID(ConfigNames.article_config,id)
                local name=CommonHelper:GetTempStr_Default(cell.name)
                local tips=CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotObservation_Tips,1,name)
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotObservation_Tittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
                if ret == MessageBoxHelp.BtnType.OK then
                    local enemyData=RaceTrotManager:Get():GetCarBuilderByIndex(self.SelectIdx)
                    RaceTrotSubsystem:Get():SendMsg_ObservationEnemy(enemyData.BuilderData.idx-1)
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnLook",self.gameObject,function (hbtn)

    end)
    CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function (hbtn)
        local enemyData=RaceTrotManager:Get():GetCarBuilderByIndex(self.SelectIdx)
        if enemyData then
            RaceTrotSubsystem:Get():SendMsg_SelectEnemy(enemyData.BuilderData.idx-1)
        end
    end)

    self.TogState = {}
    for i = 1, 3 do
        self.TogState[i] = CommonHelper:HButtonSetCallback("TogTrack"..i,self.gameObject,function (hbtn)
            self:OnClickTog(hbtn.intData,true)
        end, i)
    end
end
function RaceTrotSelectEnemyView:StopTime()
    self.TimeCount=0
    if self.Time then
        TimerManager:Get():StopTimer(self.Time)
    end
    self.Time=nil
    CommonHelper:SetHButtonClick(self.BtnRefresh,true)
    CommonHelper:SetText("###text",self.BtnRefresh.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.Refresh))
end
function RaceTrotSelectEnemyView:StartTime()
    CommonHelper:SetHButtonClick(self.BtnRefresh,false)
    self.TimeCount=3
    CommonHelper:SetText("###text",self.BtnRefresh.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotObservation_Refresh,self.TimeCount))
    self.Time=TimerManager:Get():CreateTimerLoop(1,function(class)
        class.TimeCount=class.TimeCount-1
        if class.TimeCount<=0 then
            class:StopTime()
        else
            CommonHelper:SetText("###text",class.BtnRefresh.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotObservation_Refresh,class.TimeCount))
        end
    end,self)
end

function RaceTrotSelectEnemyView:OnOpen()
    self:SetDefaultCarIcon()
    self:SetData()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    self:AutoSelect(1)
end
function RaceTrotSelectEnemyView:ReOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    self:AutoSelect(RaceTrotManager:Get():GetCurEnemyId())
end


function RaceTrotSelectEnemyView:OnOpenAnimEnd()
   self:SetCarIcon()
end
function RaceTrotSelectEnemyView:SetCarIcon()
    if self.CarList then
        CarBuilderTextureManager:Get():BuildMore(self.CarList,function(carList)

        end,function(textureBuilder)
            if textureBuilder.BuilderData.idx==self.SelectIdx then
                self:SetCar(textureBuilder)
            end
            print("textureBuilder.Id",textureBuilder.BuilderData.idx,textureBuilder.BuilderData.CarReviewData.ShellCfg.defaultSticker)
            local rawImage=UIUtil.GetTypeChildWightInputPath("trackicon",self.TogState[textureBuilder.BuilderData.idx].gameObject,typeof(RawImage))
            rawImage.texture=textureBuilder.Texture
            if RaceTrotManager:Get().CarBuilderList==nil then
                RaceTrotManager:Get().CarBuilderList={}
            end
            RaceTrotManager:Get().CarBuilderList[textureBuilder.BuilderData.idx]=textureBuilder
        end)
    end
end

function RaceTrotSelectEnemyView:SetDefaultCarIcon()
    for k, v in pairs(self.TogState) do
        CommonHelper:GetComponentSetUITexture("trackicon",self.TogState[k].gameObject,"uitex_sucai_default_car.png",UIModuleID.RaceTrotSelectEnemy)
    end
    for i = 1, 3 do
        if RaceTrotManager:Get():GetGetEnemyDataByIdx(i).AddPoint>0 then
            CommonHelper:SetText("###value"..i,self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotAddScore,RaceTrotManager:Get():GetGetEnemyDataByIdx(i).AddPoint))
        else
            CommonHelper:SetText("###value"..i,self.gameObject,"")
        end

    end
end

function RaceTrotSelectEnemyView:OnClose()
    self:Clear()
end
function RaceTrotSelectEnemyView:Clear()
    RaceTrotManager:Get():ClearCarList()
    self:StopTime()
    CommonHelper:ReleasePool(UIModuleID.RaceTrotSelectEnemy)
end
function RaceTrotSelectEnemyView:OnAutoClose()
    self:StopTime()
end
function RaceTrotSelectEnemyView:SetCar(data)
    if data then
        if self.CurCar then
            CommonHelper:CSGameObjectSetActive(self.CurCar,false)
        end
        local car=CarBuilderManager:Get():GetCarRoot(data.CarId)
        UIUtil.SetParentTransform(HomeSceneHelper:GetCarRoot_RefitTable(),car,true)
        HomeSceneCarMeshHelper:Get():SetMeshCtrl(true,car,SceneChangeID.RefitTable)
        CommonHelper:CSGameObjectSetActive(car,true)
        self.CurCar=car
    end
end
---@param msgdata RaceWeekData
function RaceTrotSelectEnemyView:SetData(isRefresh)
    self.CarList=RaceTrotManager:Get():GetCarList()
    self:SetView()
    if isRefresh then
        self:SetDefaultCarIcon()
        RaceTrotManager:Get():ClearCarList()
        self:AutoSelect(self.SelectIdx)
        self:SetCarIcon()
    end
end
function RaceTrotSelectEnemyView:RefreshWatch()
    CommonHelper:SetToggleState(self.BtnObservation,false)
end
function RaceTrotSelectEnemyView:SetView()
    local value= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotRefreshEnemyCount,false)
    if value-RaceTrotManager:Get():GetFreshFighter()<=0 then
        CommonHelper:SetText("###text",self.BtnRefresh.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RefreshEnemyTittle))
    else
        CommonHelper:SetText("###text",self.BtnRefresh.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RefreshEnemyCount,value-RaceTrotManager:Get():GetFreshFighter()))
    end
    CommonHelper:SetTrotGroupByData("Page_RaceTrotInfo", self.gameObject, RaceTrotManager:Get().RaceTrot)
    CommonHelper:SetGameObjectActive("rankicon_s_4", self.gameObject, RaceTrotManager:Get().RaceTrot.UpMatch==-1)
end


function RaceTrotSelectEnemyView:AutoSelect(idx)
    self:OnClickTog(idx)
    local emmy= RaceTrotManager:Get():GetGetEnemyDataByIdx(idx)
    local Watched=RaceTrotManager:Get():GetGetEnemyWatchedById(emmy.Id)
    if RaceTrotManager:Get().RaceTrot.UpMatch==-1 then
        CommonHelper:SetText("###CurAddPoint",self.gameObject,emmy.AddPoint)
    else
        CommonHelper:SetText("###CurAddPoint",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotUpMatch))
    end

    CommonHelper:SetToggleState(self.BtnObservation,not Watched)
    local id= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotObservationId,false)
    CommonHelper:SetText("###value",self.BtnObservation.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotObservationCost,KnapsackDataManager:Get():GetArticleCountByCfgid(id)))
end

function RaceTrotSelectEnemyView:OnClickTog(idx,isCheck)
    if isCheck and idx==self.SelectIdx then return  end
    self.SelectIdx=idx
    for i = 1, #self.TogState do
        CommonHelper:SetToggleState(self.TogState[i], i == idx, true)
    end
    self:ChangeEnemy(idx)

end

function RaceTrotSelectEnemyView:ChangeEnemy(idx)
    ---@type CarBuilderTexture
    local data= RaceTrotManager:Get():GetCarBuilderByIndex(idx)
    self:SetCar(data)
    if data then
        local emmy= RaceTrotManager:Get():GetGetEnemyDataByIdx(data.BuilderData.idx)
        local Watched=RaceTrotManager:Get():GetGetEnemyWatchedById(emmy.Id)
        if RaceTrotManager:Get().RaceTrot.UpMatch==-1 then
            CommonHelper:SetText("###CurAddPoint",self.gameObject,emmy.AddPoint)
        else
            CommonHelper:SetText("###CurAddPoint",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotUpMatch))
        end
        CommonHelper:SetToggleState(self.BtnObservation,not Watched)
        local id= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotObservationId,false)
        CommonHelper:SetText("###value",self.BtnObservation.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotObservationCost,KnapsackDataManager:Get():GetArticleCountByCfgid(id)))
    end
end
