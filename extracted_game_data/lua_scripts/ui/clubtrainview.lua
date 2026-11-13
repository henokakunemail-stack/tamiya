---@class ClubTrainView : ViewBase
ClubTrainView = class("ClubTrainView", ViewBase)

local _selfPosition = ClubMemberPosition.RankAndFile
function ClubTrainView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ClubTrainViewAction")
end

function ClubTrainView:Awake()
    self:CacheTrainData()
    self:InitTrainViewBtn()
end
function ClubTrainView:CacheTrainData()
    self. bottom = self:GetChild("Bottom")
    self. center = self:GetChild("Center")

    self.RankInfoScroll = self:GetChildWightByParent("RankInfo", self.center, typeof(MoreRowScrollView))
    self.RankInfo = self:GetChildByParent("RankInfo", self.center)
    self.TrainText = self:GetChildByParent("TrainText", self.center)
    self.RankItemGos = nil
end

function ClubTrainView:InitTrainViewBtn()
    CommonHelper:HButtonSetCallback("BtnBack", self.bottom, function(param)
        UIManager:Get():CloseView()
    end)
    self.BtnReview = CommonHelper:HButtonSetCallback("BtnReview", self.center, function(param)
        self:OnBtnReviewClick()
    end)
    self.BtnEditor = CommonHelper:HButtonSetCallback("BtnEditor", self.center, function(param)
        self:OnBtnEditorClick()
    end)
    self.BtnSelect = CommonHelper:HButtonSetCallback("BtnSelect", self.center, function(param)
        self:OnBtnSelectClick()
    end)
    CommonHelper:HButtonSetCallback("BtnTrain", self.bottom, function(param)
        self:OnBtnTrainClick()
    end)
end

function ClubTrainView:OnOpen()
    --UINotify:Get():SendNotification(UINotifyEvent.ClubTrainView_InitTrainViewInfo)
end

function ClubTrainView:OnBtnReviewClick()
    local trackInfo = ClubTrainDataManager:Get():GetCurSelectTrackInfo()
    if trackInfo ~= nil and trackInfo.trackSgList ~= nil and #trackInfo.trackSgList ~= 0 then
        local data = trackInfo:ConvertRaceTrackData()
        CommonHelper:LoadReviewTrack(nil, data)
    end
end

function ClubTrainView:OnBtnEditorClick()
    self:OnBtnSelectClick()
end

function ClubTrainView:OnBtnSelectClick()
    if _selfPosition >= ClubMemberPosition.Manager then
        ClubTrainSubsystem:Get():SendMsg_GetTrackListInfo()
    else
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubAuthorityLimit))
    end
end

function ClubTrainView:OnBtnTrainClick()
    local trackData = ClubTrainDataManager:Get():GetCurSelectTrackInfo()
    if trackData ~= nil and trackData.trackSgList ~= nil and #trackData.trackSgList ~= 0 then
        if trackData.cunRun then
            UIManager:Get():OpenView("ClubTrainSelectCarView", CanvasType.MainCanvas, "ClubTrainSelectCarView")
        else
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubTrainCannotRun))
        end
    else
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubTrainNoSelectTrack))
    end
end

function ClubTrainView:InitTrainViewInfo()
    local clubData = ClubDataManager:Get():GetClubDataById(ClubDataManager:Get():GetClubDataById())
    local playerId = PlayerDataManager:Get():GetPlayerRID()
    _selfPosition = clubData:GetSelfPosition()
    local trackInfo = ClubTrainDataManager:Get():GetCurSelectTrackInfo()
    if trackInfo == nil or trackInfo.trackSgList == nil or #trackInfo.trackSgList == 0 then
        self:InitTrackInfo("", "", "")
    else
        CommonHelper:GetComponentSetTrackIcon("RaceIconImage", self.center, MiniTrackType.SelfCustomTrack, string.format("%d%d", playerId, trackInfo.id), trackInfo, UIModuleID.ClubTraining)
        local trackType = trackInfo:GetTrackType() == TrackSegmentNumbers.Three and "三轨道" or "五轨道"
        self:InitTrackInfo(trackInfo.name, trackInfo:GetTrackLength(), trackType)
    end

    CommonHelper:SetGameObjectActive("RaceIconRawImage", self.center, trackInfo ~= nil and trackInfo.trackSgList ~= nil and #trackInfo.trackSgList ~= 0)
    CommonHelper:SetGameObjectActive("TrainText", self.center, trackInfo == nil or trackInfo.trackSgList == nil or #trackInfo.trackSgList == 0)
    CommonHelper:SetHButtonClick(self.BtnSelect, trackInfo == nil or trackInfo.trackSgList == nil or #trackInfo.trackSgList == 0, true)
    CommonHelper:SetHButtonClick(self.BtnReview, trackInfo ~= nil and trackInfo.trackSgList ~= nil and #trackInfo.trackSgList ~= 0, true)
    CommonHelper:SetHButtonClick(self.BtnEditor, _selfPosition >= ClubMemberPosition.Manager, true)
end

---@param ranks SC_RaceRankInfo
function ClubTrainView:UpdateRank(ranks)
    local rankCount = #ranks
    CommonHelper:SetGameObjectActive("RankInfo", self.center, rankCount > 0)
    if rankCount < 0 then
        return
    end

    self:SortRankByTime(ranks)
    local funcUpdate = function(dataIndex, itemObj, scroll)
        ---@type SC_RaceRankInfo
        local rankData = ranks[dataIndex + 1]
        local rank = dataIndex + 1
        CommonHelper:SetGameObjectActive("BgRawImage", itemObj, rank <= 3)
        CommonHelper:SetGameObjectActive("RankOneBgImage", itemObj, rank == 1)
        local RankBgImageGo = CommonHelper:SetGameObjectActive("RankBgImage", itemObj, rank <= 3)
        local RankBgImage = RankBgImageGo.gameObject:GetComponent(typeof(Image))
        self:SetRankBgColor(RankBgImage, rank)
        local RankImage = self:GetChildWightByParent("RankImage", itemObj, typeof(Image))
        CommonHelper:SetImage(RankImage, string.format("%s%d%s", "common_icon_rank_", rank, "_dt"), UIModuleID.ClubTraining)
        CommonHelper:SetText("PlayerNameText", itemObj, rankData.name)
        CommonHelper:GetComponentTransferTime("ScoreText", itemObj, rankData.time)
    end
    CommonHelper:InitMoreRowScrollView(self.RankInfoScroll, rankCount, 1, funcUpdate, true)
end

---@param ranks SC_RaceRankInfo
function ClubTrainView:SortRankByTime(ranks)
    ---@param a SC_RaceRankInfo
    local sortFunc = function(a, b)
        return a.time < b.time
    end
    table.sort(ranks, sortFunc)
end

function ClubTrainView:InitTrackInfo(trackName, trackLength, trackType)
    CommonHelper:SetText("trackName", self.center, trackName)
    CommonHelper:SetText("trackLength", self.center, trackLength)
    CommonHelper:SetText("trackType", self.center, trackType)
end

function ClubTrainView:SetRankBgColor(image, rank)
    if rank == 1 then
        CommonHelper:SetImageColorRGBA(image, "FFC919C8")
    elseif rank == 2 then
        CommonHelper:SetImageColorRGBA(image, "A2CEFAC8")
    elseif rank == 3 then
        CommonHelper:SetImageColorRGBA(image, "F38CA0C8")
    else
        CommonHelper:SetImageColorRGBA(image, "FFFFFF00")
    end
end

function ClubTrainView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.ClubTraining)
end



