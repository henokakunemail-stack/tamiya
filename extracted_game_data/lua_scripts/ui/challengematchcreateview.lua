---@class ChallengeMatchCreateView : ViewBase
ChallengeMatchCreateView = class("ChallengeMatchCreateView", ViewBase)

function ChallengeMatchCreateView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ChallengeMatchCreateViewAction")

    ---@type table<number, RaceTrackData>
    self.TrackList = {}
    self.SceneList = {}
end

local selectTrackID = 1
local selectSceneID = 1
local selectTicketID = 1
local isAdd = 1

function ChallengeMatchCreateView:Awake()

    self.ChooseTrackSVC = self:GetChildWight("ChooseTrackSVC", typeof(MoreRowScrollView))
    self.ChooseSceneSVC = self:GetChildWight("ChooseSceneSVC", typeof(MoreRowScrollView))
    self.ShowAwardSVC = self:GetChildWight("ShowAwardSVC", typeof(MoreRowScrollView))

    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(param)
        CommonHelper:ShowHelpView(PageDetailType.ChallengeMatch)
    end)
end

function ChallengeMatchCreateView:OnOpen()
    isAdd = 1
    selectTicketID = 1

    self:SetMatchCreateData()
    self:SetChooseTrackSVC()
    self:SetShowAwardSVC(selectTicketID)
    self:SetChooseSceneSVC()
    self:RefreshTicketData(selectTicketID)

end

function ChallengeMatchCreateView:ReOpen()
    isAdd = 1
    selectTicketID = 1

    self:SetMatchCreateData()
    self:SetChooseTrackSVC()
    self:SetShowAwardSVC(selectTicketID)
    self:SetChooseSceneSVC()
    self:RefreshTicketData(selectTicketID)
end

function ChallengeMatchCreateView:RefreshTicketData(ticketID)
    selectTicketID = ticketID

    if selectTicketID == 0 then
        selectTicketID = 1
    end

    CommonHelper:SetGameObjectActive("addBg", self.gameObject, selectTicketID == 1)
    CommonHelper:SetGameObjectActive("ItemArticleCom", self.gameObject, selectTicketID ~= 1)

    local articleCount = KnapsackDataManager:Get():GetArticleCountByCfgid(selectTicketID)
    local ItemArticleCom = self:GetChild("ItemArticleCom")

    if selectTicketID > 1 then
        local param = Param_PropParam()
        param.moduleId = UIModuleID.ChallengeMatchCreate
        param.count = tonumber(articleCount)
        param.id = selectTicketID
        param.showcount = true
        param.showname = false
        CommonHelper:SetPropGroup(ItemArticleCom, param)
    end

    CommonHelper:HButtonSetCallback("BtnReward", self.gameObject, function(data)
        UIManager:OpenPopup("ChallengeMatchTicketView", CanvasType.MainCanvas, "ChallengeMatchTicketView", true)
    end)

    CommonHelper:HButtonSetCallback("BtnCreateChallengeMatch", self.gameObject, function(hbtn)
        if articleCount == 0 then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchNoTicket)) --5574 挑战券不足
        elseif selectTrackID == 1 then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchNoTrack)) --5575 您没有可用赛道
        else
            local BtnState = self:GetBtnState()
            if BtnState then
                ChallengeMatchSubsystem:SendMsg_CreateBattle(selectTicketID, selectTrackID, selectSceneID)
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchTrackNoFinish))
            end
        end
    end)

end

function ChallengeMatchCreateView:GetBtnState()
    for i, v in pairs(self.TrackList) do
        if v:GetServerIdx() == selectTrackID then
            if v:GetCanRun() then
                return true
            else
                return false
            end
        end
    end
end

function ChallengeMatchCreateView:SetMatchCreateData()
    self.TrackList = {}

    ---@type table<number, RaceTrackData>
    local SelfCustomTrack = CommonHelper:GetTrackListByType(MiniTrackType.SelfCustomTrack)
    for i = 1, #SelfCustomTrack do
        if SelfCustomTrack[i]:GetCanRun() then
            table.insert(self.TrackList, SelfCustomTrack[i])
            isAdd = isAdd + 1
        end
    end

    if #self.TrackList < 6 then
        for i = 1, 6 - #self.TrackList do
            local trackData = RaceTrackData()
            trackData.miniTrackType = MiniTrackType.SelfCustomTrack
            trackData.customTrackData = CustomTrack_Data()
            table.insert(self.TrackList, trackData)
        end
    else

        if #self.TrackList >= 6 and #self.TrackList < 12 then
            local trackData = RaceTrackData()
            trackData.miniTrackType = MiniTrackType.SelfCustomTrack
            trackData.customTrackData = CustomTrack_Data()
            table.insert(self.TrackList, trackData)
        end
    end

    selectTrackID = self.TrackList[1]:GetServerIdx()

    self.SceneList = {}

    ---@type scene_config
    local scene_config = ClientDataManager:Get():GetDataTable(ConfigNames.scene_config)
    local sceneData = scene_config.GetConfigData()
    for k, v in pairs(sceneData) do
        if v.isroomtrack == 1 then
            table.insert(self.SceneList, v)
        end
    end
    selectSceneID = self.SceneList[1].C_ID
end

function ChallengeMatchCreateView:SetShowAwardSVC(TicketID)
    if TicketID > 1 then
        ---@type dictbattleaward_config
        local dictbattleaward_config = ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
        ---@type dictbattleaward_config_cell
        local AwardData = dictbattleaward_config.GetDataByAwardID(TicketID)

        local UpdateFunc = function(dataIndex, itemObj, scroll)
            local _itemData = AwardData[dataIndex + 1]

            CommonHelper:SetGameObjectActive("first", itemObj, _itemData.speedfrom == 1)
            CommonHelper:SetGameObjectActive("second", itemObj, _itemData.speedfrom == 2)
            CommonHelper:SetGameObjectActive("third", itemObj, _itemData.speedfrom == 3)
            CommonHelper:SetGameObjectActive("rank10000", itemObj, _itemData.speedfrom >= 4)

            if _itemData.speedfrom >= 4 then
                CommonHelper:SetText("rank10000", itemObj, tostring(_itemData.speedfrom) .. "-" .. tostring(_itemData.speedto))
            end

            local showData = CommonHelper:SetDataByStrIdAndNum(_itemData.awardids, _itemData.awardnums)

            local AwardSVC = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_H", itemObj, typeof(MoreRowScrollView))
            local UpdateItemFunc = function(ItemIndex, itemObjH, scroll)

                CommonHelper:SetGameObjectActive("ItemCom_118", itemObjH, ItemIndex < #showData)
                CommonHelper:SetGameObjectActive("###iconImg", itemObjH, ItemIndex >= #showData)

                if ItemIndex < #showData then
                    local _itemDataH = showData[ItemIndex + 1]
                    local obj = UIUtil.GetChild("ItemCom_118", itemObjH)
                    local param = Param_ItemArticleParam()
                    param.count = _itemDataH.num
                    CommonHelper:SetItemComGroup(obj, UIModuleID.ChallengeMatchCreate, _itemDataH.id, param)
                else
                    local jackpottype = stringSplit(_itemData.jackpottype, ":")
                    local _iconImg = tonumber(jackpottype[1]) == CurrencyType.Gold and "challengmatch_icon_3_dt" or "challengmatch_icon_2_dt"

                    CommonHelper:GetComponentSetImage("###iconImg", itemObjH, _iconImg, UIModuleID.ChallengeMatchCreate)
                    CommonHelper:SetText("###iconImg/###iconNum", itemObjH, "X" .. _itemData.jackpotper .. "%")
                    CommonHelper:SetGameObjectActive("###iconImg", itemObjH, _itemData.jackpotper > 0)
                    CommonHelper:SetGameObjectActive("ItemCom_118", itemObjH, false)
                end
            end
            CommonHelper:InitMoreRowScrollView(AwardSVC, #showData + 1, 1, UpdateItemFunc, true)
        end

        CommonHelper:InitMoreRowScrollView(self.ShowAwardSVC, #AwardData, 1, UpdateFunc, true)
    else

        local UpdateFunc = function(dataIndex, itemObj, scroll)

            CommonHelper:SetGameObjectActive("first", itemObj, dataIndex == 0)
            CommonHelper:SetGameObjectActive("second", itemObj, dataIndex == 1)
            CommonHelper:SetGameObjectActive("third", itemObj, dataIndex == 2)
            CommonHelper:SetGameObjectActive("rank10000", itemObj, false)
            local AwardSVC = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_H", itemObj, typeof(MoreRowScrollView))

            local UpdateItemFunc = function(ItemIndex, itemObjH, scroll)
                CommonHelper:SetGameObjectActive("ItemCom_118", itemObjH, false)
                CommonHelper:SetGameObjectActive("###iconImg", itemObjH, false)
            end

            CommonHelper:InitMoreRowScrollView(AwardSVC, 4, 1, UpdateItemFunc, true)
        end

        CommonHelper:InitMoreRowScrollView(self.ShowAwardSVC, 3, 1, UpdateFunc, true)
    end


end

function ChallengeMatchCreateView:SetChooseSceneSVC()
    CommonHelper:InitMoreRowScrollView(self.ChooseSceneSVC, #self.SceneList, 1, function(index, itemObj, scroll)
        local data = self.SceneList[index + 1]

        CommonHelper:GetComponentSetUITexture("###sceneImg", itemObj, data.icon, UIModuleID.ChallengeMatchCreate)
        CommonHelper:SetText("###sceneText", itemObj, ClientDataManager:GetTemplateString(data.name))

        CommonHelper:SetGameObjectActive("select", itemObj, selectSceneID == data.C_ID)

        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(hbtn)
            self:OnSceneItemBtnVClick(data.C_ID)
        end)

    end)

end

function ChallengeMatchCreateView:SetChooseTrackSVC()
    CommonHelper:InitMoreRowScrollView(self.ChooseTrackSVC, #self.TrackList, 2, function(index, itemObj, scroll)
        local _data = self.TrackList[index + 1]

        CommonHelper:SetGameObjectActive("add", itemObj, _data.customTrackData.isEdit == false)
        CommonHelper:SetGameObjectActive("PartStar", itemObj, _data.customTrackData.isEdit == true)
        CommonHelper:SetGameObjectActive("edit", itemObj, _data.customTrackData.isEdit == true)
        if _data ~= -1 and _data then
            CommonHelper:GetComponentSetTrackIconByData("trackicon", itemObj, _data, UIModuleID.ChallengeMatchCreate)
            CommonHelper:SetStar(_data.customTrackData:GetTrackScore(), 5, itemObj)
        end

        if _data:GetServerIdx() ~= nil then
            CommonHelper:SetGameObjectActive("select", itemObj, selectTrackID == _data:GetServerIdx())
        else
            CommonHelper:SetGameObjectActive("select", itemObj, false)
        end

        CommonHelper:HButtonSetCallback("editBtn", itemObj, function(hbtn)
            self:OnItemBtnVClick(_data:GetServerIdx())
        end)

        CommonHelper:HButtonSetCallback("createBtn", itemObj, function(hbtn)
            if UIManager:Get():IsViewShow("CustomTrackListView") == false then
                UIManager:Get():OpenView("CustomTrackListView", CanvasType.MainCanvas, "CustomTrackListView")
            end
        end)

        if isAdd > index then
            CommonHelper:SetGameObjectActive("lock", itemObj, false)
        else
            CommonHelper:SetGameObjectActive("lock", itemObj, true)
            CommonHelper:SetGameObjectActive("add", itemObj, false)
        end

    end)
end

function ChallengeMatchCreateView:OnSceneItemBtnVClick(dataID)
    selectSceneID = dataID
    UINotify:Get():SendNotification(UINotifyEvent.ChallengeMatchCreate_RefreshChooseScene)
end

function ChallengeMatchCreateView:OnItemBtnVClick(dataID)
    selectTrackID = dataID
    UINotify:Get():SendNotification(UINotifyEvent.ChallengeMatchCreate_RefreshChooseTrack)
end

function ChallengeMatchCreateView:OnClose()
    selectTrackID = 1

    self.TrackList = {}
    self.SceneList = {}
    CommonHelper:ReleasePool(UIModuleID.ChallengeMatch)
end
