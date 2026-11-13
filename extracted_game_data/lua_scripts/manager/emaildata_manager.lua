---@class EmailDataManager
EmailDataManager = class("EmailDataManager")
function EmailDataManager:Get()
    if self._instance == nil then
        self._instance = EmailDataManager()
    end
    return self._instance
end
function EmailDataManager:initialize()
    ---@type EmailData[]
    self.EmailDic=nil
    CacheClearTrigger:Get():RegisterEvent(self, self.Clear)
end
---@param msg SC_MailInfo[]
function EmailDataManager:InitEmailListData(msg)
    if ClientDataManager:Get():GetGameState()~=GameState.CrossDay then
        self.EmailDic = nil
    end
    if self.EmailDic==nil then
        self.EmailDic = {}
    end
    self.EmailCount=0
    self.NoReadCount=0
    self.CanGetEmail=0
    for i = 1, #msg do
        local temp=EmailData(msg[i])
        if temp.IsUse and (temp.mailState==EmailState.New or  temp.mailState==EmailState.CanGetItem)  then
            self.CanGetEmail=self.CanGetEmail+1
        end
        if temp.mailState==EmailState.New then
            self.NoReadCount=self.NoReadCount+1
        end
        table.insert(self.EmailDic,temp)
    end
    self.EmailCount=#self.EmailDic
    self:SortEmailData()
    RedPointManager:Get():UpdateValue(RedPointID.Email)
end
function EmailDataManager:AddEmailListData(msg)
    for i = 1, #msg do
        local temp=EmailData(msg[i])
        if temp.mailState==EmailState.New then
            self.NoReadCount=self.NoReadCount+1
        end
        if temp.IsUse then
            self.CanGetEmail=self.CanGetEmail+1
        end
        table.insert(self.EmailDic,temp)
    end
    self.EmailCount=#self.EmailDic
    self:SortEmailData()
    RedPointManager:Get():UpdateValue(RedPointID.Email)
end
function EmailDataManager:GetIsNew()
    return self.NoReadCount>0 or self.CanGetEmail>0
end
---@param mailids number[]
function EmailDataManager:DeleteEmail(mailids)
    for i = 1, #mailids do
         self:DeleteOneEmail(mailids[i])
    end
end
function EmailDataManager:DeleteOneEmail(id)
    local pos=-1
    for i = 1, #self.EmailDic do
        if id==self.EmailDic[i].mailId then
            pos=i
            break
        end
    end
    if pos>-1 then
        self.EmailCount=self.EmailCount-1
        table.remove(self.EmailDic,pos)
    end
end



function EmailDataManager:SortEmailData()
    table.sort(self.EmailDic, function(a, b)
        if a.mailState ~= b.mailState then
            return a.mailState < b.mailState
        else
            return a.sendTime > b.sendTime
        end
    end)
end
---@param type EmailType
function EmailDataManager:GetEmailList()
    return self.EmailDic
end
---@return EmailData
function EmailDataManager:GetEmailDataByIndex(index)
    return self.EmailDic[index]
end
function EmailDataManager:SetCurSelectEmailId(curSelectEmailId)
    self.curSelectEmailId = curSelectEmailId
end
function EmailDataManager:UpdateOneEmailState(id, state)
    if self:GetEmailDataById(id).mailState==EmailState.New then
        if self.NoReadCount>0 then
            self.NoReadCount=self.NoReadCount-1
        end
    end
    if  self:GetEmailDataById(id) then
        self:GetEmailDataById(id):UpdateDataState(state)
    end
    self:SortEmailData()
end
function EmailDataManager:UpdateDataIsUse(ids)
    for i = 1, #ids do
        if  self:GetEmailDataById(ids[i]) then
            if self:GetEmailDataById(ids[i]).mailState==EmailState.New  then
                self.NoReadCount=self.NoReadCount-1
            end
            self:GetEmailDataById(ids[i]):UpdateDataState(EmailState.Read)
            self.CanGetEmail=self.CanGetEmail-1
        end
    end
    self:SortEmailData()
end

---@return EmailData
function EmailDataManager:GetEmailDataById(id)
    for k, v in pairs(self.EmailDic) do
        if v.mailId==id then
                return v
        end
    end
    return nil
end
function EmailDataManager:DeleteMultiEmail(idTable)
    if #idTable <= 0 then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.EmailNoEmailCanDelete))
    else
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.EmailHasDelete))
    end
end
local _AllRewardMailIds={}
function EmailDataManager:UpdateAllEmail(msg)
    _AllRewardMailIds={}
    for k,v in pairs(self.EmailDic)do
        if #v >0 then
            for i = 1, #v do
                local emailData=v[i]
                if emailData then
                    if emailData.mailState~=EmailState.Read and #emailData.mailItems>0 then
                        table.insert(_AllRewardMailIds,emailData.mailId)
                        emailData:UpdateData(msg)
                    end
                end
            end
        end
    end
    self:SortEmailData()
end
function EmailDataManager:Clear()
    self.EmailDic = nil
end

function EmailDataManager:GetAllReward()
    if #_AllRewardMailIds>0 then
        UINotify:Get():SendNotification(UINotifyEvent.EmailGetReward,_AllRewardMailIds)
    end
end