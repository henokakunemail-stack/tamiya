---@class ShoppingCarViewAction:ViewBaseAction
ShoppingCarViewAction = class("ShoppingCarViewAction",ViewBaseAction)

function ShoppingCarViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ShoppingCarViewAction:OnRegisterEvents()

end
---@return ShoppingCarView
function ShoppingCarViewAction:View()
    return self.view
end

return ShoppingCarViewAction()
