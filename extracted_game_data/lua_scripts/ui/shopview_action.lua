
---@class ShopViewAction:ViewBaseAction
ShopViewAction = class("ShopViewAction",ViewBaseAction)

function ShopViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ShopViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ShopView_UpdateScrollView, self.UpdateScrollView)
    self:AddNotificationEvent(UINotifyEvent.ShopView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.ShopView_ClickItem, self.ClickItem)
    self:AddNotificationEvent(UINotifyEvent.ShopView_CallBack,self.ShopViewBack)
    self:AddNotificationEvent(UINotifyEvent.ShopViewAutoRefresh,self.RefreshShopView)
end

---@return ShopView
function ShopViewAction:View()
    return self.view
end
function ShopViewAction:ShopViewBack()
     self:View():ShopViewOpen()
end

function ShopViewAction:UpdateScrollView(node)
    if self:View() then
        self:View():UpdateScrollView(node[1], node[2], node[3])
    end
end
function ShopViewAction:RefreshShopView(node)
    if self:View() then
        self:View():StopTiming(node)
    end
end

function ShopViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1],data[2])
    end
end

function ShopViewAction:ClickItem(msg)
    if self:View() then
        self:View():ClickItem(msg)
    end
end



return ShopViewAction()