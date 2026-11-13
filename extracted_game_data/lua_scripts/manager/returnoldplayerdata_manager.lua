---@class ReturnOldPlayerDataManager
ReturnOldPlayerDataManager = class("ReturnOldPlayerDataManager")

---@class SupportData
SupportData = class("SupportData")
function SupportData:initialize()
    self.loc = 0 --槽位
    self.unlockTime = 0 --解锁时间 0已解锁>0解锁时间戳
    self.supportPart = -1 --支援配件
    self.freshTime = 0  --槽位刷新时间
end

---@param msg SC_RebackSupport
function SupportData:InitBaseData(msg)
    self.loc = msg.loc
    self.unlockTime = msg.unlockTime
    self.supportPart = msg.supportPart ~= nil and msg.supportPart or -1
    self.freshTime = msg.freshTime
end

function SupportData:GetLoc()
    return self.loc
end

function SupportData:GetunlockTime()
    return self.unlockTime
end

function SupportData:GetSupportPart()
    return self.supportPart
end

function SupportData:GetFreshTime()
    return self.freshTime
end

function ReturnOldPlayerDataManager:initialize()
    self.ActivityDataTab = {}
    self.ReturnState = nil
    self.curTasks = {}
    self.rebackactiveGifts = {}
    self.rebackTaskval = nil
    self.rebackactiveGifts = {}
    self.ReturnAwardData = {}
end

function ReturnOldPlayerDataManager:Get()
    if self._instance == nil then
        self._instance = ReturnOldPlayerDataManager()
    end
    return self._instance
end

function ReturnOldPlayerDataManager:InitReturnState(msg)
    self.ReturnState = msg
end

function ReturnOldPlayerDataManager:GetReturnState()
    if self.ReturnState > 0 then
        return true
    else
        return false
    end
end

function ReturnOldPlayerDataManager:GetReturnTime()
    return self.ReturnState
end

function ReturnOldPlayerDataManager:SetSignData(msg)
    self.curTasks = msg.curTasks

    self.rebackactiveGifts = msg.rebackactiveGifts

    self.rebackTaskval = msg.rebackTaskval

end

function ReturnOldPlayerDataManager:SetSignGift(msg)
    self.signGift = msg.signGift
end

function ReturnOldPlayerDataManager:GetSignGift()
    return self.signGift
end

function ReturnOldPlayerDataManager:SetSignIfCharge(msg)
    self.SignCharge = msg
end

function ReturnOldPlayerDataManager:GetSignIfCharge()
    return self.SignCharge
end

function ReturnOldPlayerDataManager:SetCurTasksData(msg)
    for i, v in pairs(self.curTasks) do
        if v.missionid == msg.missionId[1] then
            v.curstatus = 3
        end
    end

    self.rebackTaskval = msg.rebacktaskval

    for i, v in pairs(self.rebackactiveGifts) do
        if msg.rebacktaskval >= v.activeval and v.ifgift == 0 then
            v.ifgift = 1
        end
    end

end

function ReturnOldPlayerDataManager:SetReBackActiveGifts(msg)
    for i, v in pairs(self.rebackactiveGifts) do
        if v.activeval == msg.activeval then
            v.activetype = msg.activetype
            v.activeval = msg.activeval
            v.ifgift = msg.ifgift
        end
    end

end

function ReturnOldPlayerDataManager:SetTaskMaxGifts()
    local giftData = {}

    ---@type dictactive_config
    local active_config = ClientDataManager:Get():GetDataTable(ConfigNames.active_config)
    giftData = active_config.GetConfigDataByType(TaskType.ReturnOldPlayer)

    local returnMaxNumber = nil
    for i, j in pairs(giftData) do
        --给最大数值 returnMaxNumber 变量赋值
        if returnMaxNumber == nil then
            returnMaxNumber = j
        end
        --取得最大的数值
        if (j.activeval > returnMaxNumber.activeval) then
            returnMaxNumber = j
        end
    end

    return returnMaxNumber
end

function ReturnOldPlayerDataManager:GetCurTasks()
    return self.curTasks
end

function ReturnOldPlayerDataManager:GetReBackActiveGifts()
    return self.rebackactiveGifts
end

function ReturnOldPlayerDataManager:GetReBackTaskValGifts()
    return self.rebackTaskval
end

function ReturnOldPlayerDataManager:InitReturnEmailData(msg)
    self.firstlogin = msg.userinfo.firstlogin
    self.offlinedays = msg.userinfo.offlinedays
end
function ReturnOldPlayerDataManager:SetCarShellNum(num)
    self.carShellNum = num
end

function ReturnOldPlayerDataManager:GetReturnEmailDayNum()
    if self.offlinedays == nil then
        self.offlinedays = 0
    end
    return self.offlinedays
end

function ReturnOldPlayerDataManager:GetReturnEmailFirstLogin()
    return self.firstlogin
end

function ReturnOldPlayerDataManager:GetReturnEmailCarShellNum()
    return self.carShellNum
end

function ReturnOldPlayerDataManager:GetReturnTaskActivevalData(_type)
    local _data = {}
    local active_config = ClientDataManager:Get():GetDataTable(ConfigNames.active_config)

    for i, v in pairs(active_config) do
        if v.activetype == _type then
            table.insert(_data, v)
        end
    end

    return _data
end

function ReturnOldPlayerDataManager:InitActive(msg)
    self.dailyActiveState = {}
    for i = 1, #msg do
        if msg[i].activetype == TaskType.ReturnOldPlayer then
            local temp = ActiveData()
            temp:SetData(msg[i])
            table.insert(self.dailyActiveState, temp)
        end
    end
end

function ReturnOldPlayerDataManager:UpdateActive(activeId)
    for i = 1, #self.dailyActiveState do
        if activeId == self.dailyActiveState[i].activeNum then
            self.dailyActiveState[i].state = 2
        end
    end

    UINotify:Get():SendNotification(UINotifyEvent.ReturnOldPlayer_SetTask)
end

function ReturnOldPlayerDataManager:InitReBackSupportData(msg)
    self.ReBackSupportData = {}

    for i, v in pairs(msg.curSupports) do
        local _baseData = SupportData()
        _baseData:InitBaseData(v)
        table.insert(self.ReBackSupportData, _baseData)
    end

    self.ReBackSupportEndTime = msg.endTime
end

function ReturnOldPlayerDataManager:InitSelectSupportData()
    self.selectSupportPart = ClientDataManager:Get():GetDataTable(ConfigNames.dictsupportpart_config).GetConfigData()
end

function ReturnOldPlayerDataManager:GetReBackSupportData()
    return self.ReBackSupportData
end

function ReturnOldPlayerDataManager:GetReBackSupportSelectData()
    return self.selectSupportPart
end

function ReturnOldPlayerDataManager:GetSupportChooseDataState(chooseID)
    for i, v in pairs(self.ReBackSupportData) do
        if v:GetSupportPart() ~= -1 and v:GetSupportPart().partid == chooseID then
            return false
        end
    end
    return true
end

function ReturnOldPlayerDataManager:RefreshReBackSupportData(msg)
    for i, v in pairs(self.ReBackSupportData) do
        if v.loc == msg.loc then
            local _msgData = SupportData()
            _msgData:InitBaseData(msg)
            self.ReBackSupportData[i] = _msgData
        end
    end

end

function ReturnOldPlayerDataManager:Clear()

    self.ActivityDataTab = {}

end