---@class EncyclopediaView : ViewBase
EncyclopediaView = class("EncyclopediaView", ViewBase)

function EncyclopediaView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "EncyclopediaViewAction")
end
local _OnCloseFunc=nil
function EncyclopediaView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose2",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)

    self._partsBtn = CommonHelper:HButtonSetCallback("PartsBtn", self.gameObject, function(btn)
        self:OnPartsClick(btn)
    end)

    self._attriBtn = CommonHelper:HButtonSetCallback("AttributeBtn", self.gameObject, function(btn)
        self:OnAttriClick(btn)
    end)
    self._ErrorBtn = CommonHelper:HButtonSetCallback("ErrorBtn", self.gameObject, function(btn)
        self:OnErrorBtnClick(btn)
    end)
    self._TrackSegBtn = CommonHelper:HButtonSetCallback("TrackSegBtn", self.gameObject, function(btn)
        self:OnTrackSegBtnClick(btn)
    end)
    self._partsScrollView = self:GetChildWight("PartsScrollView", typeof(MoreRowScrollView))
    self._ErrorScrollView = self:GetChildWight("ErrorScrollView", typeof(MoreRowScrollView))
    self._TrackSegScrollView = self:GetChildWight("TrackSegScrollView", typeof(MoreRowScrollView))
    self._attriScrollView = self:GetChildWight("AttriScrollView", typeof(TitleScrollView))
end

function EncyclopediaView:OnOpen()
end

function EncyclopediaView:OnClose()
    self:CheckExitNewBieGuide()
    CommonHelper:ReleasePool(UIModuleID.Encyclopedia)
end

function EncyclopediaView:OnPartsClick(btn)
    self:SetToggleState(EncyclopediaPage.Parts)
    local encyConfig = ClientDataManager:GetDataTable(ConfigNames.encyclopedia_config)
    local partsIntro = encyConfig.GetPartsIntro()
    CommonHelper:InitMoreRowScrollView(self._partsScrollView, #partsIntro, 1,function(dataIndex, itemObj, scroll)
        local data = partsIntro[dataIndex+1]
        if data then
            -- CommonHelper:SetUITexture()
            CommonHelper:GetComponentSetUITexture("icon", itemObj, data.icon, UIModuleID.Encyclopedia)
            -- CommonHelper:GetComponentSetImage("icon", itemObj, data.icon)
            -- CommonHelper:SetText("PartsIntroText", itemObj, ClientDataManager:Get():GetTemplateString(data.desc))
            CommonHelper:SetText("###des", itemObj, CommonHelper:GetTempStr_Default(data.desc))

        end
    end)
end

function EncyclopediaView:OnAttriClick(btn)
    self:SetToggleState(EncyclopediaPage.Attribute)
    local encyConfig = ClientDataManager:GetDataTable(ConfigNames.encyclopedia_config)
    local attriMain = encyConfig.GetAttriMain()
    local attriSecondary = encyConfig.GetAttriSecondary()
    local titles = {attriMain[1].typeName, #attriMain, attriSecondary[1].typeName, #attriSecondary}
    CommonHelper:InitTitleScrollView(self._attriScrollView, titles, 1,
        function(title, itemObj, dataIndex, scroll)
            if dataIndex == -1 then
                CommonHelper:SetText("###title", itemObj, CommonHelper:GetTempStr_Default(title))
            else
                local name, desc
                if title == attriMain[1].typeName then
                    name = CommonHelper:GetTempStr_Default(attriMain[dataIndex + 1].name)
                    desc = CommonHelper:GetTempStr_Default(attriMain[dataIndex + 1].desc)
                else
                    name = CommonHelper:GetTempStr_Default(attriSecondary[dataIndex + 1].name)
                    desc = CommonHelper:GetTempStr_Default(attriSecondary[dataIndex + 1].desc)
                end
              

                CommonHelper:SetText("###title", itemObj, name)
                CommonHelper:SetText("###name", itemObj, desc)
            end
        end
    )
end

function EncyclopediaView:OnErrorBtnClick(btn)
    self:SetToggleState(EncyclopediaPage.Error)
    local encyConfig = ClientDataManager:GetDataTable(ConfigNames.encyclopedia_config)
    local ErrorInfo = encyConfig.GetErrorMsg()
    CommonHelper:InitMoreRowScrollView(self._ErrorScrollView, #ErrorInfo, 1,function(dataIndex, itemObj, scroll)
        local data = ErrorInfo[dataIndex+1]
        if data then
            CommonHelper:SetText("###title", itemObj, CommonHelper:GetTempStr_Default(ErrorInfo[dataIndex + 1].name))
            CommonHelper:SetText("###name", itemObj,  CommonHelper:GetTempStr_Default(ErrorInfo[dataIndex + 1].desc))

        end
    end)
end
function EncyclopediaView:OnTrackSegBtnClick(btn)
    self:SetToggleState(EncyclopediaPage.TrackSeg)
    local encyConfig = ClientDataManager:GetDataTable(ConfigNames.encyclopedia_config)
    local TrackSegInfo = encyConfig.GetTrackSegMsg()
    CommonHelper:InitMoreRowScrollView(self._TrackSegScrollView, #TrackSegInfo, 1,function(dataIndex, itemObj, scroll)
        local data = TrackSegInfo[dataIndex+1]
        if data then
            CommonHelper:SetText("###title", itemObj, CommonHelper:GetTempStr_Default(data.name))
            CommonHelper:SetText("###name", itemObj,  CommonHelper:GetTempStr_Default(data.desc))
            CommonHelper:GetComponentSetUITexture("icon", itemObj, data.icon, UIModuleID.Encyclopedia)
            CommonHelper:SetGameObjectActive("BtnHelp", itemObj, data.detail~="-1")
            CommonHelper:HButtonSetCallback("BtnHelp",itemObj, function(btn)
                UIManager:Get():ShowPersistentView("EncyclopediaDetailView",CanvasType.FrontCanvas,"EncyclopediaDetailView")
                local str=stringSplit(TrackSegInfo[btn.intData+1].detail,':')
                UINotify:Get():SendNotification(UINotifyEvent.EncyclopediaDetailView_SetData,{TrackSegInfo[btn.intData+1].name,str[1],str[2]})
            end,dataIndex)
        end
    end)
end

function EncyclopediaView:SetToggleState(encyclopediaPage)
    local isParts = encyclopediaPage == EncyclopediaPage.Parts
    local isAttri = encyclopediaPage == EncyclopediaPage.Attribute
    local isError = encyclopediaPage == EncyclopediaPage.Error
    local isTrackSeg = encyclopediaPage == EncyclopediaPage.TrackSeg
    CommonHelper:SetToggleState(self._partsBtn, isParts)
    CommonHelper:SetToggleState(self._attriBtn, isAttri)
    CommonHelper:SetToggleState(self._ErrorBtn, isError)
    CommonHelper:SetToggleState(self._TrackSegBtn, isTrackSeg)
    CommonHelper:SetGameObjectActive("PartsScrollView", self.gameObject, isParts)
    CommonHelper:SetGameObjectActive("AttriScrollView", self.gameObject, isAttri)
    CommonHelper:SetGameObjectActive("ErrorScrollView", self.gameObject, isError)
    CommonHelper:SetGameObjectActive("TrackSegScrollView", self.gameObject, isTrackSeg)
end
