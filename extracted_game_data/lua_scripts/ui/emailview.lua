---@class EmailView : ViewBase
EmailView = class("EmailView", ViewBase)
function EmailView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "EmailViewAction")
end
local _SelectEmail=-1
local DefaultEmailCount=5
local _Page=0
function EmailView:Awake()
    self.Center = self:GetChild("Center")
    CommonHelper:HButtonSetCallback("BtnBack", self.Center, function(param)
        UIManager:Get():CloseView()
    end)
    self.DeleteAllBtn = CommonHelper:HButtonSetCallback("DeleteBtn", self.Center, function(data)
        local emailCount = EmailDataManager:Get().EmailCount
        if emailCount>0 then
            EmailSubsystem:Get():SendMsg_DeleteEmail(0)
        else
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.EmailNoEmail))
        end

    end)
    self.GetAllBtn = CommonHelper:HButtonSetCallback("GetAllBtn", self. Center, function(data)
        if EmailDataManager:Get().CanGetEmail>0 then
            EmailSubsystem:Get():SendMsg_GetEmailItem(0)
        else
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.EmailNoEmailCanGet))
        end
    end)
    CommonHelper:HButtonSetCallback("TranslateBtn", self. Center, function(data)
        local data = TranslateData()
        data.targetLand = ClientDataManager:Get():TranslateTargetLand()
        data.textInput = self.CurMailContent
        data.callBack = function(translateContent,sLang)
            CommonHelper:SetNewLineTextMesh("###EmailContentText", self.gameObject, translateContent)
        end
        UnifySDKManager:Get():IDevice():Translate(data)
    end)
    self.pickUpBtn= CommonHelper:HButtonSetCallback("PickUpBtn", self.Center, function(param)
        EmailSubsystem:Get():SendMsg_GetEmailItem(self.curSelectEmailId)
    end)
    self.EmailListScroll = self:GetChildWightByParent("EmailList", self.Center, typeof(MoreRowScrollView))
    self.EmailContent = self:GetChildWightByParent("emailcontent", self.Center, typeof(CanvasGroup))
    self.emailAccessoryScrollList = self:GetChildWightByParent("ScrollHorizontalOneRow", self.Center, typeof(MoreRowScrollView))
end

function EmailView:OnClose()
     CommonHelper:ReleasePool(UIModuleID.Email)
end

function EmailView:OnOpen()
    _SelectEmail=-1
    UIUtil.ShowCanvasGroup(self.EmailContent,false)
    CommonHelper:SetGameObjectActive("contentbg", self.gameObject,false)
    UINotify:Get():SendNotification(UINotifyEvent.EmailListView_InitEmailList)
end

function EmailView:DeleteEmail()
    _Page=0
    _SelectEmail=-1
    UIUtil.ShowCanvasGroup(self.EmailContent,false)
    CommonHelper:SetGameObjectActive("contentbg", self.gameObject,false)
end
function EmailView:RefreshView()
    CommonHelper:MoreRowView_RefreshCurList(self.EmailListScroll,false)
    self:SetViewText()
end

function EmailView:SetView()
    local data=EmailDataManager:Get():GetEmailList()
    local count=  #data
    CommonHelper:InitMoreRowScrollView(self.EmailListScroll,count,1,function(index, itemObj,scroll)
        ---@type EmailData
        local emailData = EmailDataManager:Get():GetEmailDataByIndex(index + 1)
        CommonHelper:SetGameObjectActive("email_state_null",itemObj,emailData==nil)
        CommonHelper:SetGameObjectActive("eamil_state_content",itemObj,emailData~=nil and self.IsLoadBtn~=index+1)
        CommonHelper:SetGameObjectActive("loadbtn",itemObj,self.IsLoadBtn==index+1)
        if emailData then
            local mailTitle = emailData.mailTitle
            CommonHelper:SetText("###TitleText", itemObj, mailTitle)
            CommonHelper:SetText("###EmailSendNameText", itemObj, emailData.sender)
            CommonHelper:SetText("###DateText", itemObj, CommonHelper:FormatDataString(emailData.sendData,ClientDataManager:Get():GetTemplateString(TemplateStringID.EmailDataFormat)))
            if emailData.subTime>0 then
                CommonHelper:SetText("###EmailSentSubTimeText", itemObj,  CommonHelper:GetTempStr_Default(TemplateStringID.EmailDataSubFormat,emailData.subTime))
            else
                CommonHelper:SetText("###EmailSentSubTimeText", itemObj,  CommonHelper:GetTempStr_Default(TemplateStringID.EmailDataSubHourFormat,emailData.subHour))
            end

            CommonHelper:HButtonSetCallback("BtnItem",itemObj,function(param)
                local temp= EmailDataManager:Get():GetEmailDataByIndex(param.intData + 1)
                _SelectEmail=temp.mailId
                EmailDataManager:Get():SetCurSelectEmailId(temp.mailId)
                EmailSubsystem:Get():SendMsg_ReadEmail(temp.mailId)
            end,index)
            CommonHelper:SetGameObjectActive("selectBg",itemObj,_SelectEmail==emailData.mailId)
            local state2=  CommonHelper:SetGameObjectActive("email_state_2",itemObj,emailData.mailState==EmailState.New)
            local state1= CommonHelper:SetGameObjectActive("email_state_1",itemObj,emailData.mailState~=EmailState.New)
            CommonHelper:SetGameObjectActive("email_state_null",itemObj,emailData.mailState~=EmailState.New)
            CommonHelper:SetGameObjectActive("rewardflag",state2,#emailData.mailItems>0 and (emailData.mailState==EmailState.New or emailData.mailState==EmailState.CanGetItem))
            CommonHelper:SetGameObjectActive("rewardflag",state1,#emailData.mailItems>0 and (emailData.mailState==EmailState.New or emailData.mailState==EmailState.CanGetItem))
        end
    end,false,nil,_Page==0)--true)
    self:SetViewText()
end

function EmailView:SetViewText()
    CommonHelper:SetHButtonClick(self.DeleteAllBtn, EmailDataManager:Get().EmailCount >0, true)
    CommonHelper:SetHButtonClick(self.GetAllBtn, EmailDataManager:Get().EmailCount >0, true)
    CommonHelper:SetText("###allemailNum",self.gameObject,EmailDataManager:Get().EmailCount)
    CommonHelper:SetText("###noreadnum",self.gameObject,EmailDataManager:Get().NoReadCount)
    CommonHelper:SetGameObjectActive("emailcontentnull", self.gameObject,EmailDataManager:Get().EmailCount <=0 )
    UIUtil.ShowCanvasGroup(self.EmailContent,EmailDataManager:Get().EmailCount >0 and _SelectEmail~=-1)
end






function EmailView:SetContent(id)
    UIUtil.ShowCanvasGroup(self.EmailContent,true)
    local data = EmailDataManager:Get():GetEmailDataById(id)
    if data then
        self.curSelectEmailId=id
        CommonHelper:SetText("###themetext", self.gameObject,  data.mailTitle)
        self.CurMailContent=data.mailContent
       CommonHelper:SetNewLineTextMesh("###EmailContentText", self.gameObject, data.mailContent)
        CommonHelper:SetTextMeshLinkClick("###EmailContentText", self.gameObject)
        CommonHelper:SetText("sender1/###contentsendertext", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.EmailDataContentSenderFormat,data.sender))
        CommonHelper:SetText("sender2/###contentsendertext", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.EmailDataContentSenderFormat,data.sender))
        if data.subTime>0 then
            CommonHelper:SetText("###getrewardsubtime", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.EmailDataSubFormat,data.subTime))
        else
            CommonHelper:SetText("###getrewardsubtime", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.EmailDataSubHourFormat,data.subHour))
        end
        self:InitEmailItemList(data)
        CommonHelper:SetHButtonClick(self.pickUpBtn, #data.mailItems > 0, true)
        CommonHelper:SetGameObjectActive("###getrewardsubtime",self.gameObject,#data.mailItems > 0)
        CommonHelper:SetGameObjectActive("sender1/###contentsendertext", self.gameObject,#data.mailItems > 0)
        CommonHelper:SetGameObjectActive(" enclosure",self.gameObject,#data.mailItems > 0)
        CommonHelper:SetGameObjectActive("sender2/###contentsendertext", self.gameObject,#data.mailItems <= 0 )
        if data.mailState == EmailState.Read or data.mailState==EmailState.Invalid then
            CommonHelper:SetHButtonClick(self.pickUpBtn, false, true)
            CommonHelper:SetGameObjectActive("###getrewardsubtime",self.gameObject,false)
        end
    else
        UIUtil.ShowCanvasGroup(self.EmailContent,false)
    end

end

---@param mailData EmailData
function EmailView:InitEmailItemList(mailData)
    if #mailData.mailItems <= 0 then
        return
    end
    local tempMailItems=self:AnalysisEmailItemData(mailData.mailItems)
    if mailData.mailType==2 then
        local funcUpdateItem = function(dataIndex, itemObj, scroll)
            local emailItemData = tempMailItems[dataIndex + 1]
            for i = 1, 6 do
                CommonHelper:SetGameObjectActive("itemquality"..i, itemObj, 5 == i)
            end
            ---@type dictcharge_config_cell
            local charge_config= CommonHelper:GetChargeCfgByAreaAndItemId(emailItemData.id)
            local rewImage =CommonHelper:GetComponentSetUITexture("icon", itemObj,charge_config.icon,UIModuleID.Email)
            CommonHelper:SetText("###count",itemObj,charge_config.pricename)
        end
        CommonHelper:InitMoreRowScrollView(self.emailAccessoryScrollList, #tempMailItems,1, funcUpdateItem, nil, true)
    else
        local funcUpdateItem = function(dataIndex, itemObj, scroll)
            local emailItemData = tempMailItems[dataIndex + 1]
            local param = Param_PropParam()
            param.moduleId=UIModuleID.Email
            param.id = emailItemData.id
            param.count = emailItemData.count
            param.showcount=true
            CommonHelper:SetPropGroup(itemObj, param)
            CommonHelper:HButtonSetCallback("BtnReward",itemObj,function(data)
                CommonHelper:ShowPartInfoByCfgId(data.intData,UIModuleID.Email)
            end,param.id)
        end
        CommonHelper:InitMoreRowScrollView(self.emailAccessoryScrollList, #tempMailItems,1, funcUpdateItem, nil, true)
    end

end

---@param mailItems SC_UserProp[]
---@return  table<number,number>@num1 id , num2 数量
function EmailView:AnalysisEmailItemData(mailItems)
    local tempMailItems = {}
    for i = 1, #mailItems do
        local isPart = CommonHelper:GetTableDataByID(ConfigNames.parts_config, mailItems[i].propid)
        local emailItemData = {}
        if isPart then
            for j = 1, mailItems[i].propnum do
                emailItemData.id = mailItems[i].propid
                emailItemData.count = 1
                table.insert(tempMailItems, emailItemData)
            end
        else
            emailItemData.id = mailItems[i].propid
            emailItemData.count = mailItems[i].propnum
            table.insert(tempMailItems, emailItemData)
        end
    end
    return tempMailItems
end

function EmailView:GetReward(ids)
    local rewardTable={}
    for i = 1, #ids do
        local emailData=EmailDataManager:Get():GetEmailDataById(ids[i])
        for i = 1, #emailData.mailItems do
            table.insert(rewardTable,emailData.mailItems[i])
        end
    end
    if #rewardTable>0 then
        CommonHelper:ShowGetReward(rewardTable,true)
    end
end