---@class ClubTrainSettingView : ViewBase
ClubTrainSettingView = class("ClubTrainSettingView", ViewBase)

function ClubTrainSettingView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ClubTrainSettingViewAction")
end

function ClubTrainSettingView:Awake()
    self:CacheBaseData()
    self:InitSettingViewBtn()
end

function ClubTrainSettingView:OnOpen()
    self:InitSettingViewInfo()
    self:InitScrollView()
end

function ClubTrainSettingView:CacheBaseData()
    self. center = self:GetChild("Center")
    self. bottom = self:GetChild("Bottom")
    self._curSelectTrackIdx = -1
    self._curSelectTrackInfo = -1
    self.MoreRowScrollView_V = self:GetChildWightByParent("MoreRowScrollView_V", self.center, typeof(MoreRowScrollView))
end

function ClubTrainSettingView:InitSettingViewBtn()
    CommonHelper:HButtonSetCallback("BgBtn", self.center, function(param)
        self:OnBgBtnClick()
    end)
    CommonHelper:HButtonSetCallback("SelectBtn", self.bottom, function(param)
        self:OnSelectBtnClick()
    end)
end

function ClubTrainSettingView:OnBgBtnClick()
    UIManager:Get():ClosePopup()
    ClubTrainDataManager:Get():SetCurSelectTrackIdx(self._curSelectTrackIdx)
    ClubTrainDataManager:Get():SetTrackInfoByIndex(self._curSelectTrackIdx, self._curSelectTrackInfo)
end

function ClubTrainSettingView:OnSelectBtnClick()

    UIManager:Get():ClosePopup()
    ClubTrainSubsystem:Get():SendMsg_SetTrackRace()
end

function ClubTrainSettingView:InitSettingViewInfo()
    self._curSelectTrackIdx = ClubTrainDataManager:Get():GetCurSelectTrackIdx()
    self._curSelectTrackInfo = ClubTrainDataManager:Get():GetCurSelectTrackInfo()
end

local _lastSelect=nil
function ClubTrainSettingView:InitScrollView()
    local funcUpdate = function(index, itemObj, scroll)
        local trackDataIndex = index + 1
        local trackData = ClubTrainDataManager:Get():GetTrackInfoByIndex(trackDataIndex)
        local  BtnHorverGo= CommonHelper:SetGameObjectActive("BtnHorver", itemObj, ClubTrainDataManager:Get():GetCurSelectTrackIdx() == trackDataIndex)

        if _lastSelect==nil and  ClubTrainDataManager:Get():GetCurSelectTrackIdx() == trackDataIndex then
            _lastSelect=BtnHorverGo
        end

        local canEditGo = self:GetChildWightByParent("GreenDi", itemObj, typeof(CanvasGroup))
        local canCreateGo = self:GetChildWightByParent("GrayDi", itemObj, typeof(CanvasGroup))
        UIUtil.ShowCanvasGroup(canEditGo, trackData.isEdit)
        UIUtil.ShowCanvasGroup(canCreateGo, not trackData.isEdit)
        if trackData.isEdit then
            self:EditTrack(trackData, canEditGo.gameObject, trackDataIndex)
        else
            self:CreateTrack(trackData, canCreateGo.gameObject, trackDataIndex)
        end
        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(param)
            BtnHorverGo:SetActive(true)
            if _lastSelect and _lastSelect~=BtnHorverGo then
                _lastSelect:SetActive(false)
            end
            _lastSelect=BtnHorverGo
            ClubTrainDataManager:Get():SetCurSelectTrackIdx(trackDataIndex)
            ClubTrainDataManager:Get():SetTrackInfoByIndex(trackDataIndex, trackData)
        end)
    end
    CommonHelper:InitMoreRowScrollView(self.MoreRowScrollView_V, 3, 1, funcUpdate, true)
end


local _CreateToggleState=TrackSegmentNumbers.Three
---@param trackData CustomTrack_Data
function ClubTrainSettingView:EditTrack(trackData, editGo, index)
    if trackData:GetTrackType() == TrackSegmentNumbers.Three then
        CommonHelper:SetText("textLength", editGo, "三轨道")
        _CreateToggleState = TrackSegmentNumbers.Three
    elseif trackData:GetTrackType() == TrackSegmentNumbers.Five then
        _CreateToggleState = TrackSegmentNumbers.Five
    end
    CommonHelper:SetText("textName", editGo, trackData.name)
    CommonHelper:GetComponentSetTrackIcon("TrackPic", editGo, MiniTrackType.SelfCustomTrack, string.format("%d%d", PlayerDataManager:Get():GetPlayerRID(), trackData.id), trackData, UIModuleID.ClubTraining)
    CommonHelper:HButtonSetCallback("EditBtn", editGo, function(data)
        self:OnEditBtnClick(trackData, index)
    end)
    CommonHelper:HButtonSetCallback("DelBtn", editGo, function(data)
        self:OnDelBtnClick(trackData, index)
    end)
end

function ClubTrainSettingView:OnEditBtnClick(trackData, idx)
    ClubTrainDataManager:Get():SetCurSelectTrackIdx(idx)
    ClubTrainDataManager:Get():SetTrackInfoByIndex(idx, trackData)
    CommonHelper:LoadCustomTrack(trackData,MiniTrackSystem.Club)
end

function ClubTrainSettingView:OnDelBtnClick(trackData, idx)
    local data = {
        idx = trackData.id,
        canRun = false,
        trackInfo = nil,
    }
    local raceData=RaceTrackData()
    raceData:SetSelfDefineData(data)
    ClubTrainDataManager:Get():UpdateTrackDataByIndex(idx,raceData)
    --TrackSegmentDataManager:Get():UpdateTrackDataByIndex()
    ClubTrainSubsystem:Get():SendMsg_UpdateSelfTrackData(data)

    if idx==ClubTrainDataManager:Get():GetCurSelectTrackIdx() then
        UINotify:Get():SendNotification(UINotifyEvent.ClubTrainView_InitTrainViewInfo)
        UINotify:Get():SendNotification(UINotifyEvent.ClubTrainView_UpdateRank,{})
    end
    self:InitScrollView()
end

---@param trackData CustomTrack_Data
function ClubTrainSettingView:CreateTrack(trackData, createGo, index)
    local nameInput = self:GetChildWightByParent("nameInput", createGo.gameObject, typeof(InputField))
    nameInput.text = string.format("%s%d", "我的赛道", index)

    local threeTrackTog = CommonHelper:HButtonSetCallback("ThreeTrack", createGo.gameObject, function(data)
        _CreateToggleState = TrackSegmentNumbers.Three
        self:SetTrackToggleState(createGo.gameObject, TrackSegmentNumbers.Three)
    end)
    CommonHelper:HButtonSetCallback("FiveTrack", createGo.gameObject, function(data)
        _CreateToggleState = TrackSegmentNumbers.Five
        self:SetTrackToggleState(createGo.gameObject, TrackSegmentNumbers.Five)
    end)
    CommonHelper:HButtonSetCallback("CreateBtn", createGo.gameObject, function(data)
        self:OnCreateBtnClick(trackData, index, nameInput.text)
    end)
    CommonHelper:SetToggleState(threeTrackTog, true)
end

function ClubTrainSettingView:OnCreateBtnClick(trackData, idx, trackName)
    trackData.TrackNumbers = _CreateToggleState
    trackData.name = trackName
    ClubTrainDataManager:Get():SetCurSelectTrackIdx(idx)
    ClubTrainDataManager:Get():SetTrackInfoByIndex(idx, trackData)
    CommonHelper:LoadCustomTrack(trackData,MiniTrackSystem.Club)
end

function ClubTrainSettingView:SetTrackToggleState(item, type)
    local threeTrackTog = self:GetChildWightByParent("ThreeTrack", item, typeof(HButton))
    local fiveTrackTog = self:GetChildWightByParent("FiveTrack", item, typeof(HButton))
    CommonHelper:SetToggleState(threeTrackTog, type == TrackSegmentNumbers.Three)
    CommonHelper:SetToggleState(fiveTrackTog, type == TrackSegmentNumbers.Five)
end

function ClubTrainSettingView:OnClose()
    _lastSelect=nil
    TrackBuilder:Get():RestoreCamera()
end
function ClubTrainSettingView:OnAutoClose()
    TrackBuilder:Get():RestoreCamera()
end


