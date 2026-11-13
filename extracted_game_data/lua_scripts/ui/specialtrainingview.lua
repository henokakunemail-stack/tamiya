
---@class SpecialTrainingView : ViewBase
SpecialTrainingView = class("SpecialTrainingView", ViewBase)
local _SelectLevel=0
local challengeMustReward=nil
local challengeScrollView=nil
local _SelectIndex=0
local page_more=2
local page_init=1
local _CurShow=1
function SpecialTrainingView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SpecialTrainingViewAction")
    self.Pre_SelectCar = nil
    self.Pre_CarInfo = nil
    ---@type PreGarageCarIdx
    self.PreCarIdx = nil
end

function SpecialTrainingView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnRankList", self.gameObject, function(data)
        local levelData=SpecialTrainingDataManager:Get():GetSelectCopy()
        ChapterSubsystem:Get():SendMsg_ChapterRankList(levelData.C_ID,RankingListType.SpecialTraining)
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(_CurShow~=page_init)
    end)
    self.LowBtn=CommonHelper:HButtonSetCallback("TogLow",self.gameObject,function (hbtn)
        _SelectLevel=SpecialTrainingLevel.low
        self:UpdateToggleGroup()
    end)
    self.MiddleBtn=CommonHelper:HButtonSetCallback("TogMiddle",self.gameObject,function (hbtn)
        _SelectLevel=SpecialTrainingLevel.middle
        self:UpdateToggleGroup()
    end)
    self.HighBtn=CommonHelper:HButtonSetCallback("TogHight",self.gameObject,function (hbtn)
        _SelectLevel=SpecialTrainingLevel.high
        self:UpdateToggleGroup()
    end)
    self.BtnFight1=CommonHelper:HButtonSetCallback("BtnFight1",self.gameObject,function (hbtn)
        self:OnFightClick()
    end)
    self.BtnFight2=CommonHelper:HButtonSetCallback("BtnFight2",self.gameObject,function (hbtn)
        self:OnFightClick()
    end)
   CommonHelper:HButtonSetCallback("BtnBackMore",self.gameObject,function (hbtn)
       self:SetInitBattleView(page_init)
       self:SetData(true)
    end)
    self.BtnSelectCar=CommonHelper:HButtonSetCallback("BtnSelectCar",self.gameObject,function (hbtn)
        self:SetInitBattleView(page_more)
    end)

    CommonHelper:HButtonSetCallback("BtnReview",self.gameObject,function (hbtn)
       self:OnClickBtnReview()
    end)
    CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        TaskSubsystem:Get():SendMsg_GetTaskList(TaskType.SpecialTraining,UIModuleID.SpecialTraining)
    end)

    CommonHelper:HButtonSetCallback("BtnChangeCar",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():ToGarage(UIModuleID.SpecialTraining)
    end)
    self.BtnSeniorTrain=CommonHelper:HButtonSetCallback("BtnSeniorTrain",self.gameObject,function (hbtn)
       RaceSeniorTrainSubsystem:Get():SendMsg_GetChapterList()
    end)
    self.BtnProb=CommonHelper:HButtonSetCallback("BtnProb",self.gameObject,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.SpecialTrainingProb,nil,HelpStyleType.BlueStyle)
    end)
    CommonHelper:SetHButtonClick(self.BtnProb,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnProb),true)
    challengeScrollView=self:GetChildWight("MoreRowScrollView_1",typeof(MoreRowScrollView))
    challengeMustReward=self:GetChildWight("MoreRowScrollView_2",typeof(MoreRowScrollView))

    self.Pre_SelectCar =UIUtil.GetChild("Page_SelectCar",self.gameObject)
    self.Pre_CarInfo =UIUtil.GetChild("page_carinfo",self.gameObject)
    self.ObjCarIdx =UIUtil.GetChild("CaridxGroup",self.gameObject)

end
function SpecialTrainingView:OnClickBtnReview()
    local rankData=SpecialTrainingDataManager:Get():GetSelectCopy()
    if rankData ~=nil then
        local data=CommonHelper:GetRacetrackData(rankData.BattleInfoList[1].TrackId)
        CommonHelper:LoadReviewTrack(nil,data)
    end
end
function SpecialTrainingView:OnFightClick()
    local  data=SpecialTrainingDataManager:Get():GetSelectCopy()
    local showtime=data.openflag
    local showTimeList=stringSplitToNumber(showtime,':')
    local timeFlag=false
    for i = 1, #showTimeList do
        timeFlag=CommonHelper:CheckDataIsDayOfWeek(showTimeList[i])
        if timeFlag then
            break
        end
    end
    local lv=data.needlevel
    local lvFlag=PlayerDataManager:Get():GetPlayerLV()>=lv
    local countFlag=SpecialTrainingDataManager:Get():GetSelectCopyMsg().todynum<SpecialTrainingDataManager:Get():GetSelectCopy().maxenter
    if  lvFlag and timeFlag and countFlag then
        if SpecialTrainingDataManager:Get():GetCurPowerByLv(_SelectLevel)> PlayerDataManager:Get():GetPlayerStamina() then
            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.PowerNotEnough))
            return
        end
        local rankData=SpecialTrainingDataManager:Get():GetSelectCopy()
        if self.Page_SelectCarFlag then
            local flag=true
            for i = 1,rankData.BattleCars do
                if self.Cars[i].CarIdx>0 then
                    if CarDataManager:Get():CheckCarCompleteness(self.Cars[i].CarIdx) then
                    else
                        flag=false
                        break
                    end
                else
                    if CarDataManager:Get():GetCarNum()<rankData.BattleCars then
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarPleaseOpenCar))
                        return
                    end
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChapterMoreCarNoCar))
                    return
                end
            end
            if flag then
                local caridx=""
                for i = 1, rankData.BattleCars do
                    if i>=rankData.BattleCars then
                        caridx=caridx..self.Cars[i].CarIdx
                    else
                        caridx=caridx..self.Cars[i].CarIdx..":"
                    end
                end
                SpecialTrainingDataManager:Get():SetCurSelectCarData(caridx)
                PlayerPrefsHelper:SetValue_SpecialTrainLevel(_SelectLevel)
                PlayerPrefsHelper:SetValue_SpecialTrainType(_SelectIndex)
                ChallengeSubsystem:Get():SendBeginChallenge(rankData.C_ID,caridx)
            else

            end
        else
            local data = self.Page_SelectCar:GetCurCar()
            if data then
                SpecialTrainingDataManager:Get():SetCurSelectCarData(data:GetID())
                PlayerPrefsHelper:SetValue_SpecialTrainLevel(_SelectLevel)
                PlayerPrefsHelper:SetValue_SpecialTrainType(_SelectIndex)
                if CarDataManager:Get():CheckCarCompleteness(data:GetID()) then
                    ChallengeSubsystem:Get():SendBeginChallenge(rankData.C_ID,data:GetID())
                end
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
            end
        end
    else
        if lvFlag==false then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelNo))
            return
        end
        if timeFlag==false then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingNoTime))
        end
        if countFlag==false then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SpecialChallengeNoCount))
        end
    end
end

function SpecialTrainingView:UpdateToggleGroup()
    CommonHelper:SetToggleState(self.LowBtn,_SelectLevel==SpecialTrainingLevel.low)
    CommonHelper:SetToggleState(self.MiddleBtn,_SelectLevel==SpecialTrainingLevel.middle)
    CommonHelper:SetToggleState(self.HighBtn,_SelectLevel==SpecialTrainingLevel.high)
    UINotify:Get():SendNotification(UINotifyEvent.SpecialTrainingViewUpdateReward)
    self:SetTrackData()
    if self.Page_SelectCarFlag then
        self:SetCarFive(self:GetCurTrackCar(),true)
    end
end
---@type SpecialTrainingData[]
local _SpecialTrainings=nil
function SpecialTrainingView:Init()
     _SpecialTrainings={}
    for i, v in pairs(SpecialTrainingDataManager:Get():GetSpecialTrainings()) do
        table.insert(_SpecialTrainings,v)
    end
    if _SpecialTrainings[_SelectIndex+1]==nil then
        _SelectIndex=0
    end
    CommonHelper:InitMoreRowScrollView(challengeScrollView,#_SpecialTrainings,1,function (index, itemObj,scroll)
        ---@type SpecialTrainingData
        local temp =_SpecialTrainings[index+1]
        CommonHelper:SetText("hover/###challengename",itemObj,CommonHelper:GetTempStr_Default(temp.cfg.mapname))
        CommonHelper:SetText("normal/###challengename",itemObj,CommonHelper:GetTempStr_Default(temp.cfg.mapname))
         local Tog= CommonHelper:HButtonSetCallback("Tog1",itemObj,function (data)
             if _CurShow==page_more then
                 local boxfunc = function()
                     local text = ClientDataManager:Get():GetTemplateString(TemplateStringID.SpecialTrainingChangeTips)
                     local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, text, ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
                     if ret == MessageBoxHelp.BtnType.OK then
                         _SelectIndex=data.intData
                         UINotify:Get():SendNotification(UINotifyEvent.SpecialTrainingViewUpdate)
                         self:SetInitBattleView(page_init)
                     end
                 end
                 MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
             else
                 _SelectIndex=data.intData
                 UINotify:Get():SendNotification(UINotifyEvent.SpecialTrainingViewUpdate)
             end
         end,index)
        CommonHelper:SetToggleState(Tog,_SelectIndex==index)
    end)
    self:SetInitBattleView(page_init)
    self:SetData(true)
end

function SpecialTrainingView:SetInitBattleView(type)
    _CurShow=type
    CommonHelper:SetGameObjectActive("page_more",self.gameObject,type==page_more)
    CommonHelper:SetGameObjectActive("page_challenge2",self.gameObject,type==page_init)
end


function SpecialTrainingView:UpdateScrollView()
    CommonHelper:MoreRowView_RefreshCurList(challengeScrollView,false)
    self:SetData(true)
end

function SpecialTrainingView:SetDefault()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    self:SetCarGroup()
end
function SpecialTrainingView:SetCarGroup()
    self.Page_SelectCarFlag=SpecialTrainingDataManager:Get():GetSelectCopy().BattleCars>1
    self:SetSelectCarType()
    self:SetCarOne(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
    self:SetCarFive(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex(),true)
end

function SpecialTrainingView:SetSelectCarType()
    CommonHelper:SetGameObjectActive("Page_SelectCar",self.gameObject,not self.Page_SelectCarFlag)
    self.Page_SelectCar_Five=CommonHelper:SetGameObjectActive("Page_SelectCar_Five2",self.gameObject,self.Page_SelectCarFlag)
    CommonHelper:SetHButtonClick(self.BtnFight1,not self.Page_SelectCarFlag,true)
    CommonHelper:SetHButtonClick(self.BtnSelectCar,self.Page_SelectCarFlag,true)
end

function SpecialTrainingView:SetCarOne(caridx)
    if  not self.Page_SelectCarFlag then
        if self.PreCarIdx==nil then
            self.PreCarIdx=PreGarageCarIdx()
            self:SetPreGarageCar(caridx)
        else
            self:SetPreGarageCar(caridx)
        end
    end
end
function SpecialTrainingView:SetPreGarageCar(idx)
    self.PreCarIdx:SetData(self.ObjCarIdx, UIModuleID.SpecialTraining, idx,true,false ,function(data, isautoselect)
        self:SetCarMesh(data:GetCarIdx())
        PlayerPrefsHelper:SetValue_MainMenuViewCarIndex(data:GetCarIdx())
    end)
end

function SpecialTrainingView:SetPageSelectCar(carIdx)
    if self.Page_SelectCar == nil then
        self.Page_SelectCar = Page_SelectCar()
    end
    if self.Page_SelectCar then
        self.Page_SelectCar:SetData(self.Pre_SelectCar, UIModuleID.SpecialTraining,carIdx,false, SceneChangeID.RefitTable, false)
    end
end


function SpecialTrainingView:SetCarFive(idx,isreset)
    if self.Page_SelectCarFlag then
        if self.PreCarFive == nil then
            self.PreCarFive = Page_SelectCar_Five2()
        end
        if isreset then
            self:SetMore(self.gameObject)
        end
        self.PreCarFive:SetData(self.Page_SelectCar_Five,UIModuleID.SpecialTraining, idx, false,function(idx, isautoselect)
            self:SetCarMesh(idx)
            self:SetCurCarState(idx,self.PreCarFive:GetState(idx))
        end)
    end
end

function SpecialTrainingView:SetCarMesh(idx)
    cs_coroutine.start(function()
        self:SetPageSelectCar(idx)
    end)
end






function SpecialTrainingView:SetData(flag)
    SpecialTrainingDataManager:Get():SetCurChallenge(_SpecialTrainings[_SelectIndex+1].id)
    local  data=SpecialTrainingDataManager:Get():GetCurChallengeTeam()

    local weeks=stringSplit(data.cfg.time,':')
    local dispaskdate=CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingOpenDay)
    for i = 1, #weeks do
        dispaskdate=dispaskdate..ClientDataManager:Get():GetTemplateString(weeks[i]).." "
    end
    CommonHelper:SetText("###opendata",self.gameObject,dispaskdate)
    CommonHelper:SetText("selectcar_bg_left_1/###challengenametittle",self.gameObject,ClientDataManager:Get():GetTemplateString(data.cfg.mapname))
    CommonHelper:SetText("###challengedesc",self.gameObject,ClientDataManager:Get():GetTemplateString(data.cfg.desc))

    local lowLv,middleLv,highLv=SpecialTrainingDataManager:Get():GetCurChallengeTeamAllUnLockLevel()
    local playerLv= PlayerDataManager:Get():GetPlayerLV()
    CommonHelper:SetText("TogLow/###nomaltext",self.gameObject,playerLv>=lowLv and CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelNormal,lowLv) or CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelHigh,lowLv))
    CommonHelper:SetText("TogMiddle/###nomaltext",self.gameObject,playerLv>=middleLv and CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelNormal,middleLv) or CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelHigh,middleLv))
    CommonHelper:SetText("TogHight/###nomaltext",self.gameObject,playerLv>=highLv and CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelNormal,highLv) or CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelHigh,highLv))
    CommonHelper:SetText("TogLow/hover/###text",self.gameObject,playerLv>=lowLv and CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelNormal,lowLv) or CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelHigh,lowLv))
    CommonHelper:SetText("TogMiddle/hover/###text",self.gameObject,playerLv>=middleLv and CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelNormal,middleLv) or CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelHigh,middleLv))
    CommonHelper:SetText("TogHight/hover/###text",self.gameObject,playerLv>=highLv and CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelNormal,highLv) or CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingLevelHigh,highLv))

    _SelectLevel=PlayerPrefsHelper:GetValue_SpecialTrainLevel()
    self:UpdateToggleGroup()
    self:SetTrackData()
    if flag then
        self:SetCarGroup()
    end
end

function SpecialTrainingView:SpecialTrainingSetReward()
    SpecialTrainingDataManager:Get():SetSelectCopy(_SelectLevel)
    local firstdown,ccpydowns=SpecialTrainingDataManager:Get():GetCurRewardByLv(_SelectLevel)
    ---@type table<number, table<number, RewardData>>
    local datalist = {}
    for i = 1, #firstdown do
        table.insert(datalist, { false, firstdown[i]})
    end
    for j = 1, #ccpydowns[1] do
        table.insert(datalist,{ false, ccpydowns[1][j]})
    end
    for i = 2, #ccpydowns-1 do
        for j = 1, #ccpydowns[i] do
            table.insert(datalist,{ true, ccpydowns[i][j]})
        end
    end
    local count=#datalist
    CommonHelper:InitMoreRowScrollView(challengeMustReward,count,4,function (index, itemObj,scroll)
        local temp = datalist[index + 1]
        if temp then
            local isfirst = temp[1]
            local reward = temp[2]
            local obj = UIUtil.GetChild("ItemArticleSelectTeam", itemObj)
            local param = Param_ItemArticleParam()
            param.count = reward.num
            CommonHelper:SetItemComGroup(obj, UIModuleID.SpecialTraining,reward.id,param,function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.SpecialTraining)
            end,reward.id)
            CommonHelper:SetGameObjectActive("ItemArticleSelectTeam", itemObj, true)
            CommonHelper:SetGameObjectActive("first", itemObj, false)
            CommonHelper:SetGameObjectActive("odds", itemObj, isfirst)
        else
            CommonHelper:SetGameObjectActive("ItemArticleSelectTeam", itemObj, false)
            CommonHelper:SetGameObjectActive("first", itemObj, false)
            CommonHelper:SetGameObjectActive("odds", itemObj, false)
        end

    end)
    CommonHelper:SetText("###tili1", self.gameObject, SpecialTrainingDataManager:Get():GetCurPowerByLv(_SelectLevel))
end
function SpecialTrainingView:SetTrackData()
    self.BattleInfoList=SpecialTrainingDataManager:Get():GetSelectCopy().BattleInfoList
    ---@type PVELevelBattleData
    local data=nil
    if #self.BattleInfoList>1 then
        data=self.BattleInfoList[self.Page_SelectCar:GetCurCar():GetID()]
    else
        data=self.BattleInfoList[1]
    end

    local raceTrackData=CommonHelper:GetRacetrackData(data.TrackId)
    CommonHelper:SetText("###trackname", self.gameObject, CommonHelper:GetTempStr_Default(SpecialTrainingDataManager:Get():GetSelectCopy().name))
    CommonHelper:GetComponentSetTrackIconByData("trackicon",self.gameObject,raceTrackData,UIModuleID.SpecialTraining)
    local scene=data.SceneId
    if scene~=-1 then
        ---@type scene_config_cell
        local sceneCfg=CommonHelper:GetTableDataByID(ConfigNames.scene_config,scene)
        if sceneCfg then
            CommonHelper:GetComponentSetUITexture("sceneicon",self.gameObject,sceneCfg.icon,UIModuleID.SpecialTraining)
        end
    end
    CommonHelper:SetText("###GetedCount",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.SpecialTrainingRewardCount2,SpecialTrainingDataManager:Get():GetSelectCopyMsg().todynum,SpecialTrainingDataManager:Get():GetSelectCopy().maxenter))
    CommonHelper:SetTrackFeatureByParent("trackfeature",self.gameObject,raceTrackData:GetFeature())
end

function SpecialTrainingView:OnOpen()
    self:ViewFixScreen()
    _SelectIndex=  PlayerPrefsHelper:GetValue_SpecialTrainType()
    _SelectLevel=PlayerPrefsHelper:GetValue_SpecialTrainLevel()
    self:Init()
    self:SetDefault()
    RedPointManager:Get():UpdateValue(RedPointID.S_TaskSpecialTraining,true)
    CommonHelper:SetHButtonClick(self.BtnSeniorTrain,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.HideCopy),true)
end















function SpecialTrainingView:ReOpen()
    if not self.Page_SelectCarFlag then
        self:SetCarOne(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
    else
        self:SetCarFive(self:GetCurTrackCar(),false)
        self:SelectFiveReOpen()
    end
    self:SetData(false)
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
end

function SpecialTrainingView:OnClose()
    if self.Page_SelectCar then
        self.Page_SelectCar:Release()
    end
    if self.Page_SelectCar then
        self.Page_SelectCar:Release()
    end
    CommonHelper:ReleasePool(UIModuleID.SpecialTraining)
end
function SpecialTrainingView:OnAutoClose()
    CommonHelper:ReleasePool(UIModuleID.SpecialTraining)
end
function SpecialTrainingView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end
