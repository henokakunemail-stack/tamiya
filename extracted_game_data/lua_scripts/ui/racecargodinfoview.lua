local _CurShow=1
local page_more=2
local page_init=1
---@class RaceCarGodInfoView : ViewBase
RaceCarGodInfoView = class("RaceCarGodInfoView", ViewBase)

function RaceCarGodInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceCarGodInfoViewAction")
end

function RaceCarGodInfoView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(param)
        CommonHelper:ShowHelpView(PageDetailType.RaceCarGod)
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(true)
    end)

    self.CarGodInfoSVC = UIUtil.GetTypeChildWightByParent("CarGodInfoSVC", self.gameObject, typeof(MoreRowScrollView))
    self.ShowAwardSVC = UIUtil.GetTypeChildWightByParent("ShowAwardSVC", self.gameObject, typeof(MoreRowScrollView))

    self.BtnFight1=CommonHelper:HButtonSetCallback("BtnFight",self.gameObject,function (hbtn)
        self:OnFightClick()
    end)
    self.BtnFight2=CommonHelper:HButtonSetCallback("BtnFight2",self.gameObject,function (hbtn)
        self:OnFightClick()
    end)
    CommonHelper:HButtonSetCallback("BtnBackMore",self.gameObject,function (hbtn)
        self:SetInitBattleView(page_init)
    end)
    self.BtnSelectCar=CommonHelper:HButtonSetCallback("BtnSelectCar",self.gameObject,function (hbtn)
        self:SetInitBattleView(page_more)
    end)

    CommonHelper:HButtonSetCallback("BtnRefit", self.gameObject, function(data)
        SkipModuleHelper:Get():ToGarage(UIModuleID.RaceGVG)
    end)

    self.Pre_SelectCar = UIUtil.GetChild("Page_SelectCar", self.gameObject)
    self.ObjCarIdx = UIUtil.GetChild("CaridxGroup", self.gameObject)
    self.items = {}
    for i = 1, 4 do
        self.items[i] = UIUtil.GetChild("SelfItem" .. i.."/ItemPart_118", self.gameObject)
    end
    self.PartsItem = { 4, 1, 2, 3 }
end

function RaceCarGodInfoView:OnOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    CommonHelper:IsOpenMini4wdRuleView(UIModuleID.RaceCarGod)


end

function RaceCarGodInfoView:ReOpen()
    if not self.Page_SelectCarFlag then
        self:SetCarOne(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
    else
        self:SetCarFive(self:GetCurTrackCar(),false)
        self:SelectFiveReOpen()
    end
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
end

function RaceCarGodInfoView:SetSeasonData(dataID)
    self.SeasonID = dataID
    ---@type  NewOneCarGodInfoData
    self.SeasonIDData = RaceCarGodDataManager:Get():GetPVEGodSectionDataByID(self.SeasonID)
    self:InitLeftRankData(1)
    self:InitRightAwardData()
    self:SetInitBattleView(page_init)
    self:SetCarGroup()
end

function RaceCarGodInfoView:InitLeftRankData(trackIdx)

    ---------------------------

    RaceCarGodDataManager:Get():InitPVEGodSectionData()


    local leftRankData = RaceCarGodDataManager:Get():GetNewOneGodRankInfo()

    local rankLength = #leftRankData < 3 and 3 or #leftRankData

    CommonHelper:InitMoreRowScrollView(self.CarGodInfoSVC, rankLength, 1, function(index, itemObj, scroll)
        local _data = leftRankData[index + 1]

        CommonHelper:SetGameObjectActive("num1", itemObj, index + 1 == 1)
        CommonHelper:SetGameObjectActive("num2", itemObj, index + 1 == 2)
        CommonHelper:SetGameObjectActive("num3", itemObj, index + 1 == 3)
        CommonHelper:SetGameObjectActive("num4", itemObj, index + 1 >= 4)
        if index + 1 >= 4 then
            CommonHelper:SetText("num4", itemObj, string.format("<size=48>%s</size>", index + 1))
        end

        if _data ~= nil then
            local _IconFrame = _data.IconFrame
            if CommonHelper:IsNullOrEmpty(_IconFrame) then
                _IconFrame = "player_kuangicon_1.png"
            end

            CommonHelper:SetText("###titleidx", itemObj, _data.Name)
            CommonHelper:SetGameObjectActive("###titleidx", itemObj, true)
            CommonHelper:GetComponentTransferTime("###godSpeed", itemObj, _data.Score)
            CommonHelper:SetPlayerIconById("PlayerIcon80", itemObj, _data.Icon, _IconFrame, nil, UIModuleID.RaceOneCarGod)

            CommonHelper:SetGameObjectActive("Btn_PlayBack", itemObj, true)
            CommonHelper:HButtonSetCallback("Btn_PlayBack", itemObj, function(hbtn)
                local CopyID = RaceCarGodDataManager:Get():GetNewOneGodCopyID()
                ChapterSubsystem:SendMsg_GetChapterRank(CopyID, _data.Id, RankingListType.RaceCarGod)
                RankListTestVerifyDataManager:Get():SetRaplayData(_data.Id,{RankingListType.RaceCarGod,CopyID},_data.Score,version,PlayerDataManager:Get():GetPlayerServerID())
            end)
        else
            CommonHelper:SetText("###titleidx", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CarGodShowNoPeople))
            CommonHelper:SetText("###godSpeed", itemObj, "--:--:--")
            CommonHelper:SetPlayerIconById("PlayerIcon80", itemObj, 0, 0, 0, UIModuleID.RaceOneCarGod)
            CommonHelper:SetGameObjectActive("Btn_PlayBack", itemObj, false)
        end

    end)
    for i = 1, 5 do
        local  tog=CommonHelper:HButtonSetCallback("ToggleYellow"..i,self.gameObject,function (hbtn)
            self:InitLeftRankData(hbtn.intData)
        end,i)
        CommonHelper:SetToggleState(tog,trackIdx==i)
        CommonHelper:SetHButtonClick(tog,self.SeasonIDData.BattleInfoList[i]~=nil,true)
    end

    ---------------------------

    local TrackData = CommonHelper:GetRacetrackData(self.SeasonIDData.BattleInfoList[trackIdx].TrackId)
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, self.SeasonIDData.BattleInfoList[trackIdx].SceneId)
    CommonHelper:GetComponentSetTrackIconByData("trackicon", self.gameObject, TrackData, UIModuleID.RaceOneCarGod)
    CommonHelper:GetComponentSetUITexture("chapterpic", self.gameObject, cfg.icon, UIModuleID.RaceOneCarGod)
    CommonHelper:SetTrackFeatureByParent("trackfeature", self.gameObject, TrackData:GetFeature())

    CommonHelper:HButtonSetCallback("BtnReview", self.gameObject, function(hbtn)
        if TrackData:GetIsField() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
        else
            CommonHelper:LoadReviewTrack(nil, TrackData)
        end
    end)


end

function RaceCarGodInfoView:InitRightAwardData()

    ---------------------------
    local RightAwardData = self.SeasonIDData.goods
    ---------------------------

    CommonHelper:InitMoreRowScrollView(self.ShowAwardSVC, #RightAwardData, 1, function(index, itemObj, scroll)
        local _data = RightAwardData[index + 1]

        UIUtil.SetCanvasGroupAlpha("coustom", itemObj, 1, true)

        ------------------


        local TitleFinish =CommonHelper:GetTempStr_Default(TemplateStringID.CarGodOneFinishTitle,CommonHelper:TransferTimeToString(CommonHelper:TransferTime(_data.succVal)))
        CommonHelper:SetText("###awardTitle", itemObj, TitleFinish)

        local myTime = RaceCarGodDataManager:Get():GetPVEGodInfoDataByCopyID(self.SeasonID)
        local groupValue = 0
        if myTime.fasttime ~= 0 and myTime.fasttime <= _data.succVal then
            groupValue = 0.7
        else
            groupValue = 1
        end

        UIUtil.SetCanvasGroupAlpha("coustom", itemObj, groupValue, true)

        ------------------

        self:InitAwardItemSVCData(_data, itemObj)
    end)

end

function RaceCarGodInfoView:InitAwardItemSVCData(ItemDatas, ParentItemObj)
    local AwardItemSVC = UIUtil.GetTypeChildWightByParent("AwardItemSVC", ParentItemObj, typeof(MoreRowScrollView))

    ------------------
    local _itemData = ItemDatas.ids
    ------------------

    local dataLength = #_itemData < 4 and 4 or #_itemData
    CommonHelper:InitMoreRowScrollView(AwardItemSVC, dataLength, 1, function(index, itemObj, scroll)
        CommonHelper:SetGameObjectActive("ItemCom_118", itemObj, index < #_itemData)

        local data = _itemData[index + 1]
        if data ~= nil then
            local rewardObj = UIUtil.GetChild("ItemCom_118", itemObj)
            local param = Param_ItemArticleParam()
            param.count = ItemDatas.nums[index + 1]
            CommonHelper:SetItemComGroup(rewardObj, UIModuleID.RaceOneCarGod, data, param)
            ------------------

        end
    end)
end

function RaceCarGodInfoView:OnFightClick()
    if self.Page_SelectCarFlag then
        local flag=true
        for i = 1,#self.SeasonIDData.BattleInfoList do
            if self.Cars[i].CarIdx>0 then
                if CarDataManager:Get():CheckCarCompleteness(self.Cars[i].CarIdx) then
                else
                    flag=false
                    break
                end
            else
                if CarDataManager:Get():GetCarNum()<#self.SeasonIDData.BattleInfoList then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarPleaseOpenCar))
                    return
                end
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChapterMoreCarNoCar))
                return
            end
        end
        if flag then
            local caridx=""
            for i = 1, #self.SeasonIDData.BattleInfoList do
                if i>=3 then
                    caridx=caridx..self.Cars[i].CarIdx
                else
                    caridx=caridx..self.Cars[i].CarIdx..":"
                end
            end
            CommonHelper:CheckMini4wdRule(UIModuleID.RaceCarGod,function()
                RaceCarGodSubsystem:Get():SendMsg_GodStart(self.SeasonID, caridx)
            end)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
        end
    else
        local data = self.Page_SelectCar:GetCurCar()
        if data then
            if CarDataManager:Get():CheckCarCompleteness(self.Page_SelectCar:GetCurCar():GetID()) then
                CommonHelper:CheckMini4wdRule(UIModuleID.RaceCarGod,function()
                    RaceCarGodSubsystem:Get():SendMsg_GodStart(self.SeasonID, self.Page_SelectCar:GetCurCar():GetID())
                end)
            end
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
        end
    end
end










function RaceCarGodInfoView:SetInitBattleView(type)
    _CurShow=type
    CommonHelper:SetGameObjectActive("page_more",self.gameObject,type==page_more)
    CommonHelper:SetGameObjectActive("RightAward",self.gameObject,type==page_init)
end
function RaceCarGodInfoView:SetCarGroup()
    self.Page_SelectCarFlag=#self.SeasonIDData.LevelData.BattleInfoList>1
    self:SetSelectCarType()
    self:SetCarOne(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
    self:SetCarFive(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex(),true)
end
function RaceCarGodInfoView:SetSelectCarType()
    CommonHelper:SetGameObjectActive("Page_SelectCar",self.gameObject,not self.Page_SelectCarFlag)
    self.Page_SelectCar_Five=CommonHelper:SetGameObjectActive("Page_SelectCar_Five2",self.gameObject,self.Page_SelectCarFlag)
    CommonHelper:SetHButtonClick(self.BtnFight1,not self.Page_SelectCarFlag,true)
    CommonHelper:SetHButtonClick(self.BtnSelectCar,self.Page_SelectCarFlag,true)
end

function RaceCarGodInfoView:SetCarOne(caridx)
    if  not self.Page_SelectCarFlag then
        if self.PreCarIdx==nil then
            self.PreCarIdx=PreGarageCarIdx()
            self:SetPreGarageCar(caridx)
        else
            self:SetPreGarageCar(caridx)
        end
    end
end
function RaceCarGodInfoView:SetCarFive(idx,isreset)
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

function RaceCarGodInfoView:SetPreGarageCar(caridx)
    self.PreCarIdx:SetData(self.ObjCarIdx, UIModuleID.RaceOneCarGod, caridx, true, false, function(data, isautoselect)
        self:SetCarMesh(data:GetCarIdx())
        PlayerPrefsHelper:SetValue_MainMenuViewCarIndex(data:GetCarIdx())
    end)
end
function RaceCarGodInfoView:SetCarMesh(idx)
    cs_coroutine.start(function()
        self:SetPageSelectCar(idx)
    end)

end
function RaceCarGodInfoView:SetPageSelectCar(carIdx)
    if self.Page_SelectCar == nil then
        self.Page_SelectCar = Page_SelectCar()
    end
    if self.Page_SelectCar then
        self.Page_SelectCar:SetData(self.Pre_SelectCar, UIModuleID.RaceOneCarGod,carIdx,false, SceneChangeID.RefitTable, false)
    end
end


function RaceCarGodInfoView:OnClose()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
    if self.Page_SelectCar then
        self.Page_SelectCar:Release()
    end
    if self.Page_SelectCar then
        self.Page_SelectCar:Release()
    end
    CommonHelper:ReleasePool(UIModuleID.RaceOneCarGod)
end







