

---@class ArticleBoxParam
ArticleBoxParam = class("ArticleBoxParam")
function BoxParam:initialize()
    self.color = ""
    self.TopText=""
    self.BottomText = ""
    self.componentType=""
    self.componentData=""
    self.title = ""
    self.btntype = ""
    self.OkName = ""
    self.CancelName = ""
    self.isclose = ""
    self.ismask = ""
    self.istoggle = ""
    self.isShowTop=""
    self.isShowBottom=""

end



---@class ArticleMessageBoxHelp
ArticleMessageBoxHelp = class("ArticleMessageBoxHelp")


local __instance = ArticleMessageBoxHelp()
function ArticleMessageBoxHelp:Get()
    return __instance
end

local __co
-------------------------------启动box协同队列
function ArticleMessageBoxHelp:StartCoroutineBox(func)
    print("启动")
    __co = coroutine.create(func)
    coroutine.resume(__co)
end
--------------------------------



--------------------------------接收box按钮事件（不是外部访问接口，不要自行调用）
function ArticleMessageBoxHelp:OnClickBtn(btntype,toggle)
    print("---   toggle = ",toggle)
    UIManager:Get():ClosePopup()
    toggle = toggle or false
    coroutine.resume(__co, btntype, toggle)
end
--------------------------------



--------------------------------显示box，自定义box样式
function ArticleMessageBoxHelp:SetLyoutParam(colortype, topDesc,bottomDesc,componentType,componentData, title,btntype, OkName, CancelName,isShowTop,isShowBottom ,isclose, ismask,istoggle)
    local table = ArticleBoxParam()
    table.color = colortype
    table.topText = topDesc
    table.componentType=componentType
    table.componentData=componentData
    table.bottomText=bottomDesc
    table.title = title or "提示"
    table.btntype = btntype
    table.OkName = OkName or "确认"
    table.CancelName = CancelName or "取消"
    table.isclose = isclose or false
    table.ismask = ismask or true
    table.istoggle = istoggle or false
    table.isShowTop=isShowTop or false
    table.isShowBottom=isShowBottom or false
    return table
end
function ArticleMessageBoxHelp:OpenBox(param)
    UIManager:Get():OpenPopup("ArticleMessageBoxView", CanvasType.FrontCanvas, "ArticleMessageBoxView", true)
    UINotify:Get():SendNotification(UINotifyEvent.ArticleMessageBoxView_SetLayout, param)
end

function ArticleMessageBoxHelp:OpenBox_OKCancel(colortype, topDesc,bottomDesc,componentType,componentData,title,OkName, CancelName,isShowTop,isShowBottom,isclose, isMask,istoggle)
    local param = self:SetLyoutParam(colortype, topDesc,bottomDesc,componentType,componentData, title, ArticleMessageBoxView.BtnLayout.OkCancel, OkName, CancelName,isShowTop,isShowBottom ,isclose, isMask,istoggle)
    self:OpenBox(param)
    print(coroutine.status(__co))
    local ret,tag = coroutine.yield()
    return ret,tag
end

function ArticleMessageBoxHelp:OpenBox_OK(colortype, topDesc,bottomDesc,componentType,componentData,title, OkName, CancelName,isShowTop,isShowBottom, isclose, isMask,istoggle)
    local param = self:SetLyoutParam(colortype, topDesc,bottomDesc,componentType,componentData,title, ArticleMessageBoxView.BtnLayout.Ok, OkName, CancelName,isShowTop,isShowBottom, isclose, isMask,istoggle)
    self:OpenBox(param)

    local ret,tag = coroutine.yield()
    return ret,tag
end
--------------------------------