---@class ClubNoViewAction
ClubNoViewAction = class("ClubNoViewAction", ViewBaseAction)

function ClubNoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return ClubNoView
function ClubNoViewAction:View()
    return self.view
end

function ClubNoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ClubNoView_List_InitClubList, self.InitClubList)
    self:AddNotificationEvent(UINotifyEvent.ClubNoView_List_AfterSearch, self.AfterSearch)
    self:AddNotificationEvent(UINotifyEvent.ClubNoView_List_InitClubInfo, self.InitClubInfo)
    self:AddNotificationEvent(UINotifyEvent.ClubNoView_List_NoClub, self.NoClub)
end

function ClubNoViewAction:InitClubList(clubListType)
    self:View():InitClubList(clubListType[1],clubListType[2])
end

---@param msg SC_GuildInfo
function ClubNoViewAction:AfterSearch(msg)
    self:View():AfterSearch(msg)
end

---@param msg SC_GuildInfo
function ClubNoViewAction:NoClub(msg)
    self:View():NoClub(msg)
end

function ClubNoViewAction:InitClubInfo()
    self:View():InitClubInfo()
end



return ClubNoViewAction()

