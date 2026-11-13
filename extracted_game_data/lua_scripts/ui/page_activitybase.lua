---@class Page_ActivityBase
Page_ActivityBase = class("Page_ActivityBase")

function Page_ActivityBase:initialize()
    self.parent = nil
    self.activityType = nil
end

function Page_ActivityBase:InitViewInfo(parent, activityType, msg,isreset)
    self.parent = parent
    self.activityType = activityType
end

function Page_ActivityBase:OnBaseClose()

end
function Page_ActivityBase:OnChangeBase()

end
---@param chargeCfg dictcharge_config_cell
function Page_ActivityBase:SetBtnIsRmbOrToken(Btn,chargeCfg)
    CommonHelper:SetBtnIsRmbOrToken(Btn,chargeCfg)

end

