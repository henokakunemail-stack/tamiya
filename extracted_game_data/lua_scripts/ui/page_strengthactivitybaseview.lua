---@class Page_StrengthActivityBaseView
Page_StrengthActivityBaseView = class("Page_StrengthActivityBaseView")

function Page_StrengthActivityBaseView:initialize(gameObject, type,view)
    self.gameObject = gameObject
    self.type = type
    ---@type StrengthSprintActView
    self.view=view
    ---@type StrengthActivityData
    self.ActivityData=nil
    self.Active = false
end

function Page_StrengthActivityBaseView:Open(data)
    self.Active = true
    self.ActivityData=data
    CommonHelper:CSGameObjectSetActive(self.gameObject, true)
    self:OnOpen()
end

function Page_StrengthActivityBaseView:Close()
    CommonHelper:CSGameObjectSetActive(self.gameObject, false)
    if self.Active then
        self:OnClose()
        self.Active = false
    end
end

function Page_StrengthActivityBaseView:Refresh()
    self:OnRefresh()
end
function Page_StrengthActivityBaseView:SetActivityTime()
    self.view:SetActivityTime(self.type)
end
