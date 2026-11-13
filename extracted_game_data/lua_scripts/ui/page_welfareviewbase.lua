---@field GetPageName fun(param:self):string @必须重写 该返回值为了查找该View节点
---@field GetUIModuleID fun(param:self):string @可选重写
---@field RequestOpen fun(param:self):void @可选重写
---@field OnOpen fun(param:self):string @可选重写
---@field ReOpen fun(param:self):string @可选重写
---@field OnClose fun(param:self):string @可选重写
---@field gameObject  CS.UnityEngine.GameObject
---@field parentPref CS.UnityEngine.GameObject 父节点
---@class Page_WelfareViewBase
Page_WelfareViewBase = class("Page_WelfareViewBase")

function Page_WelfareViewBase.CreatePageActView(actId, parentPref)
    local pageWelfareView = nil

    if actId == WelfareFuncType.monthSign then
        pageWelfareView = Page_MonthSignInView()
    elseif actId == WelfareFuncType.physical then
        pageWelfareView = Page_PhysicalPowerView()
    elseif actId == WelfareFuncType.dayGift then
        pageWelfareView = Page_VideoDayGiftView()
    elseif actId == WelfareFuncType.luckyTable then
        pageWelfareView = Page_VideoLuckyTableView()
    elseif actId == WelfareFuncType.boxAwards then
        pageWelfareView = Page_BoxAwardsView()
    elseif actId == WelfareFuncType.examination then
        pageWelfareView = Page_ExaminationView()
    end

    if pageWelfareView then
        Page_WelfareViewBase.initialize(pageWelfareView, actId, parentPref)
        pageWelfareView:OnAwake()
    end
    return pageWelfareView

end

function Page_WelfareViewBase:initialize(actId, parentPref)
    if self and actId and parentPref then
        self.parentPref = parentPref
        self.canvasGroup = UIUtil.GetTypeChildWightByParent(self:GetPageName(), self.parentPref, typeof(CanvasGroup))
        self.gameObject = self.canvasGroup.gameObject
        self:SetCanvasGroup(false)
        self.IsOpen = false
    end
end

function Page_WelfareViewBase:Open()
    self:SetCanvasGroup(true)
    self.IsOpen = true
    self:OnOpen()
end

function Page_WelfareViewBase:ReOpen()
    self:SetCanvasGroup(true)
    self.IsOpen = true
    self:ReOpen()
end

function Page_WelfareViewBase:Close()
    self.IsOpen = false
    self:SetCanvasGroup(false)
    self:OnClose()
end

function Page_WelfareViewBase:SetCanvasGroup(active)
    UIUtil.ShowCanvasGroup(self.canvasGroup, active)
end

--{{{ 子类必须重写
function Page_WelfareViewBase:GetPageName()
    return "预制体分页名字"
end
--}}}

function Page_WelfareViewBase:RunAction(data)
    local value = self.class.__instanceDict[data[1]]
    if value and type(value) == "function" and self.IsOpen then
        table.remove(data, 1)
        value(self, data)
    end
end

--{{{ 子类可重写
function Page_WelfareViewBase:GetUIModuleID()
    return UIModuleID.Welfare
end

function Page_WelfareViewBase:RequestOpen()
    self:Open()
end

function Page_WelfareViewBase:OnAwake()
end

function Page_WelfareViewBase:OnOpen()
end

function Page_WelfareViewBase:ReOpen()
end

function Page_WelfareViewBase:OnClose()
end

function Page_WelfareViewBase:GetRedPointActive()
    return false
end

--}}}

return Page_WelfareViewBase()