---@class ActProclamationView : ViewBase
ActProclamationView = class("ActProclamationView", ViewBase)

function ActProclamationView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ActProclamationViewAction")
end

local _IsPop = false

function ActProclamationView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():HidePersistentView("ActProclamationView")
    end)

    CommonHelper:HButtonSetCallback("BtnCloseMask2", self.gameObject, function(data)
        UIManager:Get():HidePersistentView("ActProclamationView")
    end)

    self.titleBtn1 = CommonHelper:HButtonSetCallback("titleBtn1/ItemBtn", self.gameObject, function(data)
        self.ChooseTitleType = 1
        LoginSubSystem:Get():SendMsg_GetAnnouncement()
    end)

    self.titleBtn2 = CommonHelper:HButtonSetCallback("titleBtn2/ItemBtn", self.gameObject, function(data)
        self.ChooseTitleType = 2
        FunctionSkipManager:Get():SkipToFunction(GameFunction.ActProclamation, { 2, 2 })
    end)

    self.ChooseTitleType = 1
    self.PageView = {}
    self.CurPageId = -1

    self.ChooseBtnSVC = UIUtil.GetTypeChildWightByParent("ChooseBtnSVC", self.gameObject, typeof(MoreRowScrollView))

end

function ActProclamationView:OnOpen()

    self.SelectID = 1

    _IsPop = PlayerPrefsHelper:GetValue_ActProclamationPop()
    if PlayerDataManager:Get():GetPlayerUID() ~= PlayerPrefsHelper:GetValue_LastLoginPlayer() then
        _IsPop = false
    end
end

function ActProclamationView:ReOpen()

    self.SelectID = 1
end

function ActProclamationView:RefreshTitleState(Data)
    self.titleType = Data[1]
    self.gameState = Data[2]
    self.ChooseTitleType = Data[1]
    if self:GetPageView(self.CurPageId) then
        self:GetPageView(self.CurPageId):Close()
    end
    CommonHelper:SetGameObjectActive("titleBtn1", self.gameObject, self.gameState >= 1)
    CommonHelper:SetGameObjectActive("titleBtn2", self.gameObject, self.gameState >= 2)

    CommonHelper:SetGameObjectActive("titleBtn1/coustom/choose", self.gameObject, self.ChooseTitleType == 1)
    CommonHelper:SetGameObjectActive("titleBtn2/coustom/choose", self.gameObject, self.ChooseTitleType == 2)

    CommonHelper:SetGameObjectActive("pagebg", self.gameObject, self.ChooseTitleType == 2)
    CommonHelper:SetGameObjectActive("PageTrans2", self.gameObject, self.ChooseTitleType == 2)
    CommonHelper:SetGameObjectActive("PageTrans", self.gameObject, self.ChooseTitleType == 1)

    if self.ChooseTitleType == 1 then
        self:RefreshTitleSystem()
    end

    if self.ChooseTitleType == 2 then
        self:RefreshTitleRace()
    end

end

function ActProclamationView:RefreshTitleSystem()
    self.ChooseBtnData = {}
    self.ChooseBtnData = AnnouncementDataManager:Get():GetAnnouncementList()
    self.systemData = AnnouncementDataManager:Get():GetAnnouncementList()
    self:RefreshSubsystemData()
    self:RefreshChooseBtnByData()

end

function ActProclamationView:RefreshTitleRace()
    self.ChooseBtnData = {}
    local openTypeList = ActAdvanceNoticeDataManager:Get():GetOpenTypeList()
    self.ChooseBtnData = ActAdvanceNoticeDataManager:Get():GetConfigTabByType(openTypeList[1])
    self:RefreshChooseBtnByData()
    self:ToggleOnClick(self.ChooseBtnData[1].C_ID)

end

function ActProclamationView:RefreshChooseBtnByData()
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local btnData = self.ChooseBtnData[dataIndex + 1]

        CommonHelper:SetGameObjectActive("choose", itemObj, self.SelectID == dataIndex + 1)
        CommonHelper:SetGameObjectActive("common", itemObj, self.SelectID ~= dataIndex + 1)

        if self.ChooseTitleType == 1 then
            CommonHelper:SetText("choose/###Text", itemObj, btnData.title)
            CommonHelper:SetText("common/###Text", itemObj, btnData.title)
        end

        if self.ChooseTitleType == 2 then
            CommonHelper:SetText("choose/###Text", itemObj, CommonHelper:GetTempStr_Default(btnData.actname))
            CommonHelper:SetText("common/###Text", itemObj, CommonHelper:GetTempStr_Default(btnData.actname))
        end

        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(btn)
            self.SelectID = dataIndex + 1
            self:RefreshChooseBtnByData()
            if self.titleType == ProclamationType.System then
                self:RefreshSubsystemData()
            end

            if self.titleType == ProclamationType.Race then
                self:ToggleOnClick(btnData.C_ID)
            end
        end)

    end

    CommonHelper:InitMoreRowScrollView(self.ChooseBtnSVC, #self.ChooseBtnData, 1, UpdateFunc, true)
end

function ActProclamationView:ToggleOnClick(configId)
    if self.titleType == ProclamationType.Race then
        if configId == self.CurPageId and self:GetPageView(configId) then
            self:GetPageView(configId):RequestOpen()
        elseif configId ~= self.CurPageId and self:GetPageView(configId) then
            local lastActId = self.CurPageId
            self.CurPageId = configId
            self:GetPageView(configId):RequestOpen()
            if self:GetPageView(lastActId) then
                self:GetPageView(lastActId):Close()
            end
        elseif configId ~= self.CurPageId and configId == -1 then
            if self:GetPageView(self.CurPageId) then
                self:GetPageView(self.CurPageId):Close()
            end
            self.CurPageId = configId
        end
    end

end

function ActProclamationView:OpenActPage(configId)
    if configId ~= -1 then
        if self.CurPageId == configId and self:GetPageView(configId) then
            self:GetPageView(configId):Open()
        end
    end
end

function ActProclamationView:PageRunAction(data)
    local configId = data[1]
    configId = configId == -1 and self.CurPageId or configId
    if configId and self:GetPageView(configId) then
        table.remove(data, 1)
        self:GetPageView(configId):RunAction(data)
    end
end

function ActProclamationView:GetPageView(configId)
    if configId == -1 then
        return nil
    end
    return self.PageView[configId] and self.PageView[configId] or self:CreatePageView(configId)
end

function ActProclamationView:CreatePageView(configId)
    self.PageView[configId] = Page_ActAdvanceNoticeViewBase.CreatePageActView(configId, self.gameObject)
    return self.PageView[configId]
end

function ActProclamationView:RefreshSubsystemData()
    if self.systemData then
        local temp = self.systemData[self.SelectID]
        if temp then
            CommonHelper:HButtonSetCallback("TranslateBtn", self. Center, function(data)
                local data = TranslateData()
                data.targetLand = ClientDataManager:Get():TranslateTargetLand()
                data.textInput = temp.content
                data.callBack = function(translateContent,sLang)
                    CommonHelper:SetNewLineTextMesh("###contetnt", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.AnnouncementContent, translateContent))
                end
                UnifySDKManager:Get():IDevice():Translate(data)
            end)
            CommonHelper:SetText("###Tittle", self.gameObject, temp.title)
            CommonHelper:SetText("###contentsendertext", self.gameObject, temp.sender)
            CommonHelper:SetNewLineTextMesh("###contetnt", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.AnnouncementContent, temp.content))
            CommonHelper:SetTextMeshLinkClick("###contetnt", self.gameObject)
        end
    end
end

function ActProclamationView:OnClose()
    local value = 0
    if _IsPop then
        value = 1
    end

    PlayerPrefsHelper:SetValue_ActProclamationPop(value)
    PopupManager:Get():FirstPopupOnClose()
    if self:GetPageView(self.CurPageId) then
        self:GetPageView(self.CurPageId):Close()
    end
    QuickTa:Get():TrackEvent(TrackEventNames.events_close, nil,TrackEventType.First,AnalysisType.events_close)
end

function AnnouncementView:OnBackKey()
    UIManager:Get():HidePersistentView("ActProclamationView")
end
