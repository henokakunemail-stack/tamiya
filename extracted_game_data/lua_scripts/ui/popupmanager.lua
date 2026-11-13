---@class PopupManager
PopupManager = class("PopupManager")
function PopupManager:initialize()
    ---@type Queue
    self.FirstLoginQueue = Queue()
    self.RallyIngQueue = Queue()
    self.isCheckRallyPopup=false
    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end

---@return PopupManager
function PopupManager:Get()
    if self._instance == nil then
        self._instance = PopupManager()
    end
    return self._instance
end

function PopupManager:AddAllFirstInitPopupView()
   -- CommonHelper:PlayScreenEffectNull(true)
    self:AddFirstPopupView(self.AddVideoPlayer)
    self:AddFirstPopupView(self.AddReChargeInfoPopup)
    --self:AddFirstPopupView(self.AddAnnouncementPopup)

    self:AddFirstPopupView(self.AddReturnOldPlayerPopup)

    --self:AddFirstPopupView(self.AddAdvanceNoticeViewPopup)
    self:AddFirstPopupView(self.ActProclamationViewPopup)

    self:AddFirstPopupView(self.AddPopGiftViewPopup)

   --     self:AddFirstPopupView(self.AddSignInfoPopup)
   --     self:AddFirstPopupView(self.AddActivityInfoPopup)

end

function PopupManager:AddReturnOldPlayerPopup()
    if ReturnOldPlayerDataManager:Get():GetReturnEmailDayNum() > 0 then
        if not UIManager:Get():IsPopViewShow("ReturnOldPlayerEmailView") then
            UIManager:Get():ShowPersistentView("ReturnOldPlayerEmailView",CanvasType.FrontCanvas,"ReturnOldPlayerEmailView",false)
        end
    else
        self:FirstPopupOnClose()
    end
end

function PopupManager:AddAdvanceNoticeViewPopup()
    if ActAdvanceNoticeDataManager:Get():GetAdvanceNoticeCount() > 0 then
        --FunctionSkipManager:Get():SkipToFunction(GameFunction.ActAdvanceNotice)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.ActProclamation, { 2, 2 })
    else
        self:FirstPopupOnClose()
    end
end

function PopupManager:ActProclamationViewPopup()
    if ActAdvanceNoticeDataManager:Get():GetAdvanceNoticeCount() > 0 then
        if UIManager:Get():IsViewShow(CommonHelper:GetMainMenuViewName()) then
            FunctionSkipManager:Get():SkipToFunction(GameFunction.ActProclamation, { 2, 2 })
        else
            LoginSubSystem:Get():SendMsg_GetAnnouncement()
        end
        self:FirstPopupOnClose()
    end
end

function PopupManager:AddPopGiftViewPopup()
    if not PopUpGiftDataManager:Get():DelayPopUpShow() then
        self:FirstPopupOnClose()
    end
end

function PopupManager:AddReChargeInfoPopup()
    --ActivitySubsystem:Get():ReloadCharge(PlayerDataManager:Get().ReChargeList)
end

function PopupManager:AddAnnouncementPopup()
    LoginSubSystem:Get():SendMsg_GetAnnouncement()
end

function PopupManager:AddVideoPlayer()
    LoginSubSystem:Get():SendMsg_GetMainPlayVideo(function(data)
        if CommonHelper:IsNullOrEmpty(data) then
            PopupManager:Get():FirstPopupOnClose()
        else
            local videoName=data
            local flag= PlayerPrefsHelper:GetValue_PlayerVideo(videoName)
            if flag then
                CommonHelper:PlayerVideo(videoName,function()
                    PlayerPrefsHelper:SetValue_PlayerVideo(videoName,1)
                    PopupManager:Get():FirstPopupOnClose()
                end,nil,nil,true)
            else
                PopupManager:Get():FirstPopupOnClose()
            end
        end
    end)

end



function PopupManager:AddSignInfoPopup()
    FunctionSkipManager:Get():SkipToFunction(GameFunction.LoginTask)
end

function PopupManager:AddActivityInfoPopup()
    ActivitySubsystem:Get():SendMsg_GetWeekCardInfo(7)
end
function PopupManager:AddFirstPopupView(func)
   self.FirstLoginQueue:EnQueueBack(func)
end

function PopupManager:PopupFirstInitPopup()
    if self.FirstLoginQueue and  self.FirstLoginQueue:GetSize()>0 then
        local func= self.FirstLoginQueue:DeQueueFront()
        if func then
            func(self)
        else
            -- CommonHelper:PlayScreenEffectNull(false)
        end
    end
end

function PopupManager:FirstPopupOnClose()
    self:PopupFirstInitPopup()
end

function PopupManager:Clear()
    self.FirstLoginQueue:Clear()
end


function PopupManager:SetIsCheckRallyPopup(flag)
    self.isCheckRallyPopup=flag
end

function PopupManager:GetIsCheckRallyPopup()
    return self.isCheckRallyPopup
end

function PopupManager:AddRallyPopup(func)
    if not CommonHelper:CheckPlayerIsNewGuide() then
        self.RallyIngQueue:EnQueueFront(func)
    end
end

function PopupManager:PopRallyPopupView()
    if self.isCheckRallyPopup and self.RallyIngQueue:GetSize()>0 then
        local func= self.RallyIngQueue:DeQueueFront()
        if func then
            func()
        else
            -- CommonHelper:PlayScreenEffectNull(false)
        end
    end
    self:SetIsCheckRallyPopup(false)
end

function PopupManager:ClearData()
    self.FirstLoginQueue:Clear()
    self.RallyIngQueue:Clear()
end

