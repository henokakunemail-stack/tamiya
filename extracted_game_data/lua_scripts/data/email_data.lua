---@class EmailUpdateData
---@field mailState
---@field mailContent


---@class EmailData
EmailData = class("EmailData")

---@param msg SC_MailInfo
function EmailData:initialize(msg)
    self.mailId = msg.mailid
    self.IsUse=msg.mailtype==1
    self.mailTitle = msg.mailtop
    self.mailContent = msg.mailcont
    self.mailState = msg.ifuse
    self.sender = msg.sender
    self.sendTime = msg.sendtime*1000
    self.mailType = msg.mailtype
    self.sendData=CommonHelper:ConvertIntToDataTime(self.sendTime)
    self.subTime=msg.exptime
    -- self.subTime=CommonHelper:ConvertIntToDataTime(msg.exptime)
     self:UpdateTime()
    self.mailItems = msg.userprop
end

function EmailData:UpdateDataState(value)
    local isSendLog = self.mailState~=value

    self.mailState=value

    if isSendLog then
        QuickTaHelper:Get():TrackMailEvent(self)
    end
    --if self.IsUse and self.mailState==EmailState.Read then
    --    self.mailState=EmailState.CanGetItem
    --end
    --QuickTa:Get():Track_Mail(tostring(self.mailId), tostring(self.mailType), Dll_JSON.encode(self.mailItems))
end
function EmailData:UpdateDataIsUse(value)
    self.IsUse=value==1
    if self.IsUse and self.mailState==EmailState.Read then
        self.mailState=EmailState.CanGetItem
    end
    --QuickTa:Get():Track_Mail(tostring(self.mailId), tostring(self.mailType), Dll_JSON.encode(self.mailItems))
end

function EmailData:UpdateTime()
    local lastDateTime=self.subTime-CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    if lastDateTime~=nil then
        local  subTicks=lastDateTime--CommonHelper:SubTimeByDateTime(lastDateTime)
        local subDay= math.modf(subTicks/TimeSecond_Day)
        self.subTime=math.abs(subDay)
        local subHour= math.modf((subTicks-(subDay*TimeSecond_Day))/TimeSecond_Hour)
        self.subHour=math.abs(subHour)
    end
end




