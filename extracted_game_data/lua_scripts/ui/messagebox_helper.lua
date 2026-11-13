

---@class BoxParam
BoxParam = class("BoxParam")
function BoxParam:initialize()
    self.color = ""
    self.text = ""
    self.title = ""
    self.btntype = ""
    self.OkName = ""
    self.CancelName = ""
    self.isclose = ""
    self.ismask = ""
    self.istoggle = ""
    self.ViewType = MessageBoxHelp.ViewType.Tips
    ---@type RewardData[]
    self.param = nil
    self.canvasType = CanvasType.TopCanvas
end


---@class MessageBoxHelp
MessageBoxHelp = class("MessageBox")

---@class MessageBox_BtnType
MessageBoxHelp.BtnType = {
    OK = 1,
    Cancel = 2,
}
---@class MessageBox_ViewType
MessageBoxHelp.ViewType = {
    Tips = 1,
    Article = 2,
}



local __instance = MessageBoxHelp()
---@return MessageBoxHelp
function MessageBoxHelp:Get()
    return __instance
end

local __co
-------------------------------启动box协同队列
function MessageBoxHelp:StartCoroutineBox(func)
    print("启动")
    __co = coroutine.create(func)
    coroutine.resume(__co)
end
--------------------------------



--------------------------------接收box按钮事件（不是外部访问接口，不要自行调用）
function MessageBoxHelp:OnClickBtn(btntype,toggle)
    print("---   toggle = ",toggle)
    UIManager:Get():ClosePopup()
    toggle = toggle or false
    coroutine.resume(__co, btntype, toggle)
end
--------------------------------
--------------------------------接收box按钮事件（不是外部访问接口，不要自行调用）
function MessageBoxHelp:BreakMessageBox()
    print("---   toggle = ",toggle)
    UIManager:Get():ClosePopup()
    coroutine.resume(__co, MessageBoxHelp.BtnType.Cancel, false)
end
--------------------------------



--------------------------------显示box，自定义box样式
function MessageBoxHelp:SetLyoutParam(colortype, text, title,btntype, OkName, CancelName, isclose, ismask,istoggle,viewType,param,canvasType)
    local table = BoxParam()
    table.color = colortype
    table.text = text
    table.title = title or CommonHelper:GetTempStr_Default(TemplateStringID.Hit)
    table.btntype = btntype
    table.OkName = OkName or CommonHelper:GetTempStr_Default(TemplateStringID.OK)
    table.CancelName = CancelName or CommonHelper:GetTempStr_Default(TemplateStringID.Cancel)
    table.isclose = isclose or false
    table.ismask = ismask or true
    table.istoggle = istoggle or false
    table.ViewType = viewType or MessageBoxHelp.ViewType.Tips
    table.param = param
    table.canvasType=canvasType or CanvasType.TopCanvas
    return table
end
function MessageBoxHelp:OpenBox(param)
    UIManager:Get():OpenPopup("MessageBoxView", param.canvasType or  CanvasType.TopCanvas, "MessageBoxView", true)
    UINotify:Get():SendNotification(UINotifyEvent.MessageBoxView_SetLayout, param)
end

function MessageBoxHelp:OpenBox_OKCancel(colortype, text, title, OkName, CancelName, isclose, isMask,istoggle,viewType,param,canvasType)
    print("打开MessageBoxHelp界面",debug.traceback())
    local param = self:SetLyoutParam(colortype, text, title, MessageBoxView.BtnLayout.OkCancel, OkName, CancelName, isclose, isMask,istoggle,viewType,param,canvasType)
    self:OpenBox(param)
    print(coroutine.status(__co))
    local ret,tag = coroutine.yield()
    return ret,tag
end

function MessageBoxHelp:OpenBox_OK(colortype, text, title, OkName, CancelName, isclose, isMask,istoggle,viewType,param,canvasType)
    local param = self:SetLyoutParam(colortype, text, title, MessageBoxView.BtnLayout.Ok, OkName, CancelName, isclose, isMask,istoggle,viewType,param,canvasType)
    self:OpenBox(param)

    local ret,tag = coroutine.yield()
    return ret,tag
end
--------------------------------