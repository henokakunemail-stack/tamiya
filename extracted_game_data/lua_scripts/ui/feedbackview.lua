---@class FeedBackView : ViewBase
FeedBackView = class("FeedBackView", ViewBase)

function FeedBackView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "FeedBackViewAction")
end

function FeedBackView:Awake()
    -- 设置关闭按钮回调
    CommonHelper:HButtonSetCallback("BtnClose2", self.gameObject, function(hbtn)
        UIManager:Get():ClosePopup()
    end)
    
    -- 设置取消按钮回调
    CommonHelper:HButtonSetCallback("btn_cancel", self.gameObject, function(hbtn)
        UIManager:Get():ClosePopup()
    end)
    
    -- 设置返回按钮回调
    CommonHelper:HButtonSetCallback("btn_back", self.gameObject, function(hbtn)
        UIManager:Get():ClosePopup()
    end)
    
    -- 设置提交按钮回调
    CommonHelper:HButtonSetCallback("btn_submit", self.gameObject, function(hbtn)
        self:OnSubmit()
    end)
    
    -- 获取输入框组件
    self.inputContent = self:GetChildWight("InputField_content", typeof(TMP_InputField))
    self.inputEmail = self:GetChildWight( "InputField_email", typeof(TMP_InputField))
    
    -- 获取滚动列表组件
    self.scrollView = self:GetChildWight( "DropDownScrollView", typeof(UIDropDownScrollList))
end

function FeedBackView:OnOpen()
    self:SetData()
end

function FeedBackView:OnClose()
end

function FeedBackView:OnSubmit()
    -- 检查内容输入
    if string.IsNullOrEmpty(self.inputContent.text) then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PleaseInputContent))
        return
    end
    
    -- 检查邮箱输入
    if string.IsNullOrEmpty(self.inputEmail.text) then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PleaseInputEmail))
        return
    end
    
    -- 验证邮箱格式
    if not string.IsNullOrEmpty(self.inputEmail.text) and not self:IsValidEmail(self.inputEmail.text) then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PleaseInputValidEmail))
        return
    end
    
    -- 构造内容
    local content = self.inputContent.text
    if self.index > 0 then
        content = DataMgr.Get():GetString(self.cfgData[self.index].viewdesc) .. ":" .. content
    end
    
    -- 发送反馈消息
    FeedbackSubsystem.Get():SendMsg_Send(content, self.inputEmail.text)
end

function FeedBackView:IsValidEmail(email)
    if string.IsNullOrWhiteSpace(email) then
        return false
    end
    
    -- 简单的邮箱格式验证
    return string.match(email, "^[^@%s]+@[^@%s]+%.[^@%s]+$") ~= nil
end

function FeedBackView:SetData()
    -- 显示输入框界面，隐藏完成界面
    CommonHelper:SetGameObjectActive("box", true, self.gameObject)
    CommonHelper:SetGameObjectActive("done", false, self.gameObject)
    
    -- 清空输入框
    self.inputContent.text = ""
    self.inputEmail.text = ""
    
    -- 设置默认文本
    CommonHelper:SetTextMesh("###curvalue", self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.PleaseSelectType))
    
    -- 初始化索引和状态
    self.index = -1
    self.ShowActive = false
    
    -- 获取配置数据
    self.cfgData = DataMgr.Get().dictfeedbackData.cfgData:ValuesToList()
    
    -- 设置滚动列表数据
    self.scrollView:SetData(#self.cfgData, function(view, item, index)
        self.ShowActive = not self.ShowActive
        CommonHelper:SetTextTextMeshPro("###desc", DataMgr.Get():GetString(self.cfgData[index].viewdesc), item)
        CommonHelper:SetGameObjectActive("hoverScrollView", self.ShowActive, self.scrollView.gameObject)
    end, function(index)
        self.index = index
        CommonHelper:SetTextTextMeshPro("###curvalue", DataMgr.Get():GetString(self.cfgData[self.index].viewdesc), self.gameObject)
    end, self.index)
end

function FeedBackView:RefreshView()
    -- 隐藏输入框界面，显示完成界面
    CommonHelper:SetGameObjectActive("box", false, self.gameObject)
    CommonHelper:SetGameObjectActive("done", true, self.gameObject)
end