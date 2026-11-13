
---@class AnnouncementView : ViewBase
AnnouncementView = class("AnnouncementView", ViewBase)
function AnnouncementView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "AnnouncementViewAction")
end
local _IsPop = false
function AnnouncementView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():HidePersistentView("AnnouncementView")
    end)
    CommonHelper:HButtonSetCallback("BtnCloseMask2", self.gameObject, function(data)
        UIManager:Get():HidePersistentView("AnnouncementView")
    end)

    self.TogSelect = CommonHelper:HButtonSetCallback("TogSelect", self.gameObject, function(data)
        if _IsPop then
            _IsPop = false
        else
            _IsPop = true
        end
        CommonHelper:SetToggleState(self.TogSelect, _IsPop)
    end)
    self.textArea = self:GetChildWightByParent("TextArea", self.gameObject, typeof(Text))
   -- self.LinkText = self:GetChildWightByParent("###contetnt", self.gameObject, typeof(CS.LinkText))
    --self.LinkText.uiCamera=CSCameraManager.Get()._UICamera
    self.ScrollView = self:GetChildWight("MoreRowScrollView_V", typeof(MoreRowScrollView))
end

function AnnouncementView:OnOpen()

    _IsPop = PlayerPrefsHelper:GetValue_AnnouncementPop()
    if PlayerDataManager:Get():GetPlayerUID() ~= PlayerPrefsHelper:GetValue_LastLoginPlayer() then
        _IsPop = false
    end
    CommonHelper:SetToggleState(self.TogSelect, _IsPop)
end

local _SelectIndex = -1
---@type table<number,AnnouncementData>
local _Data = nil
function AnnouncementView:SetContent()
    _SelectIndex = 0
    CommonHelper:SetText("###Tittle", self.gameObject, "")
    CommonHelper:SetText("###contentsendertext", self.gameObject, "")
    local xtext = CommonHelper:SetXTextText("###contetnt", self.gameObject,"" )
    _Data = AnnouncementDataManager:Get():GetAnnouncementList()
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #_Data, 1, function(index, itemObj, scroll)
        -- local tempParent=UIUtil.GetChild("point"..math.fmod(index,4),itemObj)
        CommonHelper:SetText("hover/###text", itemObj, _Data[index + 1].tag)
        CommonHelper:SetText("normal/###text", itemObj, _Data[index + 1].tag)
        local Tog = CommonHelper:HButtonSetCallback("ToggleAnnounce", itemObj, function(data)
            _SelectIndex = data.intData
            self:SetData()
            CommonHelper:MoreRowView_RefreshCurList(scroll, false)
        end, index)
        -- CommonHelper:SetText("text",itemObj,_Data[index+1].id)
        --UIUtil.SetParentGameObject(tempParent,Tog,true,true)
        CommonHelper:SetToggleState(Tog, _SelectIndex == index)
    end)
    self:SetData()
end
function AnnouncementView:SetData()
    if _Data then
        local temp = _Data[_SelectIndex + 1]
        if temp then
            CommonHelper:SetText("###Tittle", self.gameObject, temp.title)
            CommonHelper:SetText("###contentsendertext", self.gameObject, temp.sender)
            local xtext= CommonHelper:SetTextMesh("###contetnt", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.AnnouncementContent,temp.content))
            CommonHelper:SetTextMeshLinkClick("###contetnt", self.gameObject)
        end
    end
end
function AnnouncementView:OnClose()
    local value = 0
    if _IsPop then
        value = 1
    end
    PlayerPrefsHelper:SetValue_AnnouncementPop(value)

    PopupManager:Get():FirstPopupOnClose()
end

function AnnouncementView:OnBackKey()
    UIManager:Get():HidePersistentView("AnnouncementView")
end



