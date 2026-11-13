---@class RaceCarGodView : ViewBase
RaceCarGodView = class("RaceCarGodView", ViewBase)

function RaceCarGodView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceCarGodViewAction")
end
local PlayerIcon = nil
local PlayerIconFrame = nil

local levData = { TemplateStringID.RaceCarGodFiltrateText1,
                  TemplateStringID.RaceCarGodFiltrateText2  }

local _selectLevelType

function RaceCarGodView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(param)
        CommonHelper:ShowHelpView(PageDetailType.RaceCarGod)
    end)

    -------------------
    --CommonHelper:HButtonSetCallback("BtnAll", self.gameObject, function(param)
    --    self:RefreshRaceCarGodData(0)
    --    self:SetCarGodRankView()
    --end)
    --
    --CommonHelper:HButtonSetCallback("BtnFiltrate", self.gameObject, function(param)
    --    self:RefreshRaceCarGodData(1)
    --    self:SetCarGodRankView()
    --end)

    _selectLevelType = 1
    self.SortPanelDropDown = self:GetChildWight("SortPanel", typeof(UIDropDown))
    CommonHelper:SetText("###roottext", self.SortPanelDropDown.gameObject,
            CommonHelper:GetTempStr_Default(levData[1][2]))

    CommonHelper:InitDropDown(self.SortPanelDropDown, #levData, function(uiDropDown, item, index)
        CommonHelper:SetText("Text", item, CommonHelper:GetTempStr_Default(levData[index + 1]))
    end, function(int)
        self:RefreshRaceCarGodData(int+1)
        _selectLevelType =int + 1
        self:SetCarGodRankView()
        CommonHelper:SetText("###roottext", self.SortPanelDropDown.gameObject,
                CommonHelper:GetTempStr_Default(levData[int + 1]))
    end)
    CommonHelper:HButtonSetCallback("BtnSearch",self.gameObject,function (hbtn)
        local value = CommonHelper:GetInputFieldText("Input1/Input75", self.gameObject)
        local infoList = RaceCarGodDataManager:Get():GetPVEGodInfoData()
        local sectionData = RaceCarGodDataManager:Get():GetPVEGodSectionData()
        if not CommonHelper:IsNullOrEmpty(value) and infoList[tonumber(value)] then
            self.RankInfoList ={infoList[tonumber(value)]}
            self.sectionData = {sectionData[tonumber(value)]}
            self:SetCarGodRankView()
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceCarGodSearchFail))
        end
    end)
    ------------------

    self.CarGodSVC = UIUtil.GetTypeChildWightInputPath("CarGodSVC", self.gameObject, typeof(MoreRowScrollView))

    ---@type table<number,ChapterData>
    self.RankInfoList = {}

    PlayerIcon = PlayerDataManager:Get():GetPlayerIcon()
    PlayerIconFrame = PlayerDataManager:Get():GetPlayerIconFrame()
end

function RaceCarGodView:OnOpen()
    _selectLevelType= PlayerPrefsHelper:GetValue_RaceCarGodMoudle()
    CommonHelper:SetText("###roottext", self.SortPanelDropDown.gameObject,
            CommonHelper:GetTempStr_Default(levData[_selectLevelType]))
    self:RefreshRaceCarGodData(_selectLevelType)
    self:SetCarGodRankView()
    self:CheckNewBieGuide()
end

function RaceCarGodView:RefreshRaceCarGodData(_type)
    self.RankInfoList = {}
    self.sectionData = {}
    RaceCarGodDataManager:Get():InitPVEGodSectionData()

    if _type == 2 then
        local infoList = RaceCarGodDataManager:Get():GetPVEGodInfoData()
        local sectionData = RaceCarGodDataManager:Get():GetPVEGodSectionData()
        if #infoList > 0 then
            for i, v in pairs(infoList) do
                if #v.star < 5 then
                    table.insert(self.RankInfoList, infoList[i])
                    table.insert(self.sectionData, sectionData[i])
                end
            end
        else
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CarGodNoFiltrateData))
        end
    else
        self.RankInfoList = RaceCarGodDataManager:Get():GetPVEGodInfoData()
        self.sectionData = RaceCarGodDataManager:Get():GetPVEGodSectionData()
    end

end

function RaceCarGodView:OnOpenAnimEnd()

end

function RaceCarGodView:SetCarGodRankView()
    CommonHelper:InitMoreRowScrollView(self.CarGodSVC, #self.RankInfoList, 4, function(dataIndex, itemObj, scroll)
        self:UpdateChapterView(dataIndex, itemObj)
    end)
    CommonHelper:MoreRowView_EnterAni2(self.CarGodSVC, 0.16)

    --local moveIndex = 1
    --for i, v in pairs(self.RankInfoList) do
    --    --local _numTab = v.Awards
    --    local _numTab = v.star
    --    if #_numTab < 5 then
    --        break
    --    else
    --        moveIndex = i
    --    end
    --
    --
    --end
    --
    --CommonHelper:MoreRowView_ScrollToItem(self.CarGodSVC, moveIndex - 1)

    ---------
    CommonHelper:MoreRowView_ScrollToItem(self.CarGodSVC, PlayerPrefsHelper:GetValue_RaceCarGodIndex(#self.RankInfoList-1))
    ---------

end

function RaceCarGodView:UpdateChapterView(dataIndex, itemObj)
    ---@type NewCarGodInfoData
    local data = self.RankInfoList[dataIndex + 1]

    --if data.RankInfo.Score > -1 then
    --    CommonHelper:GetComponentTransferTime("###godSpeed", itemObj, data.RankInfo.Score)
    --else
    --    CommonHelper:SetText("###godSpeed", itemObj, "--:--:--")
    --end

    --if data.Speed > 0 then
    if data.fasttime > 0 then
        CommonHelper:GetComponentTransferTime("###mySpeed", itemObj, data.fasttime)
    else
        CommonHelper:SetText("###mySpeed", itemObj, "--:--:--")
    end

    --CommonHelper:SetText("###titleidx", itemObj, data.RankInfo.Name)
    --CommonHelper:SetText("###title", itemObj,
    --        string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RaceOneCarGodRankTitle), dataIndex + 1))

    ---------7

    CommonHelper:SetText("###titleidx", itemObj, PlayerDataManager:Get():GetPlayerName())
    CommonHelper:SetText("###title", itemObj,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.CarGodShowTitleNum), data.titleID))

    CommonHelper:SetSlider("SliderBaseColor", itemObj, #data.star / 5)

    CommonHelper:SetText("###FinishNum", itemObj,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.CarGodFinishNum), tostring(#data.star / 5 * 100)) .. "%")

    CommonHelper:SetPlayerIconById("PlayerIcon100", itemObj, PlayerIcon, PlayerIcon, nil, UIModuleID.Top)



    if #data.star > 0 then
        CommonHelper:SetGameObjectActive("statefinish", itemObj, true)
        CommonHelper:GetComponentSetImage("statefinish", itemObj, "racecargodfinish_1_dt", UIModuleID.RaceCarGod)
    else
        CommonHelper:SetGameObjectActive("statefinish", itemObj, false)

    end
    ---------

    --local _IconFrame = data.RankInfo.IconFrame
    --if CommonHelper:IsNullOrEmpty(_IconFrame) then
    --    _IconFrame = "player_kuangicon_1.png"
    --end
    --CommonHelper:SetPlayerIconById("PlayerIcon100", itemObj, data.RankInfo.Icon, _IconFrame, nil, UIModuleID.RaceCarGod)
    local BattleInfoList=self.sectionData[dataIndex + 1].BattleInfoList
    local ScrollPoint = UIUtil.GetTypeChildWightByParent("ScrollPoint",itemObj, typeof(ScrollPoint))
    local BannerScroll = UIUtil.GetTypeChildWightByParent("CarouselScrollView",itemObj, typeof(CarouselScrollView))
    if BattleInfoList then
        CommonHelper:InitCarouselScrollView(BannerScroll,  #BattleInfoList, 0,function(CarousedataIndex, CarousedataIndexitemObj, scroll)
            ScrollPoint:SetPoint(CarousedataIndex)
            local SceneId = BattleInfoList[CarousedataIndex+1].SceneId
            local trackData=  CommonHelper:GetRacetrackData(BattleInfoList[CarousedataIndex+1].TrackId)
            CommonHelper:GetComponentSetTrackIconByData("trackicon", CarousedataIndexitemObj, trackData, UIModuleID.RaceCarGod)
            CommonHelper:SetTrackFeatureByParent("trackfeature",CarousedataIndexitemObj, trackData:GetFeature(), true)
            if SceneId ~= -1 then
                ---@type scene_config_cell
                local sceneCfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, SceneId)
                if sceneCfg then
                    CommonHelper:GetComponentSetUITexture("chapterpic", CarousedataIndexitemObj, sceneCfg.icon, UIModuleID.RaceCarGod)
                end
            end
            CommonHelper:HButtonSetCallback("BtnReview", CarousedataIndexitemObj, function(data)
                local trackData=  CommonHelper:GetRacetrackData(data.intData)
                if trackData:GetIsField() then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
                else
                    CommonHelper:LoadReviewTrack(nil, trackData)
                end
            end,trackData:GetId())
        end)
    end
    local ScrollRect= UIUtil.GetGameobjectComponent(BannerScroll.gameObject,typeof(ScrollRect))
    CommonHelper:ScrollViewEnableDrag(ScrollRect,#BattleInfoList>1,false)


    CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(hbtn)
        PlayerPrefsHelper:SetValue_RaceCarGodMoudle(_selectLevelType)
        PlayerPrefsHelper:SetValue_RaceCarGodIndex(hbtn.intData)
        RaceCarGodDataManager:Get():SetNewOneGodRankCopyID(self.sectionData[hbtn.intData + 1].copyID)
        RaceCarGodDataManager:Get():SetNewOneGodCopyID(self.sectionData[hbtn.intData + 1].copyID)
        RaceCarGodSubsystem:Get():SendMsg_GodInfo(self.sectionData[hbtn.intData + 1].copyID)
    end,dataIndex)

end

function RaceCarGodView:ReOpen()
    _selectLevelType= PlayerPrefsHelper:GetValue_RaceCarGodMoudle()
    CommonHelper:SetText("###roottext", self.SortPanelDropDown.gameObject,
            CommonHelper:GetTempStr_Default(levData[_selectLevelType]))
    self:RefreshRaceCarGodData(_selectLevelType)
    self:SetCarGodRankView()
    CommonHelper:MoreRowView_EnterAni2(self.CarGodSVC, 0.16)
end
function RaceCarGodView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceCarGod)
end
