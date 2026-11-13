---@class NoticeItemData
NoticeItemData = class("NoticeItemData")

---@param msg SC_TvInfo
function NoticeItemData:initialize(msg)
    ---@type table<number,string>
    self.content = msg.content
    self.id = msg.noticeId
    self.partid = msg.partid
    self.count = msg.broadnum
    self.lev = msg.lev
    self.type = msg.type---0小喇叭1大喇叭2玩家触发3系统gm发送
    if msg.type == 0 or msg.type == 1 then
        self.noticeType = NoticeType.PlayerNotice
    else
        self.noticeType = NoticeType.SystemNotice
    end
    self.tvId = msg.tvid
    self.roleName = msg.rolename
    self:AnalysisContent()
end

function NoticeItemData:GetId()
    return self.id
end

function NoticeItemData:GetPartId()
    return self.partid
end

function NoticeItemData:GetContent()
    return self.content
end

function NoticeItemData:AnalysisContent()
    if self.type == NoticeLittleType.PlayerSystem then
        ---@type tracksegement_config_cell
        local type, config = CommonHelper:GetPropTypeById(self:GetPartId())
        if type == PropType.Part then
            self.content = CommonHelper:GetTempStr_Default(CommonHelper:GetDictCalcData(self.tvId, true), self.roleName, CommonHelper:GetTempStr_Default(config.partname))
        elseif type == PropType.Article then
            self.content = CommonHelper:GetTempStr_Default(CommonHelper:GetDictCalcData(self.tvId, true), self.roleName, CommonHelper:GetTempStr_Default(config.name))
        elseif type == PropType.TracKSegment then
            self.content = CommonHelper:GetTempStr_Default(CommonHelper:GetDictCalcData(self.tvId, true), self.roleName, CommonHelper:GetTempStr_Default(config.name))
        end
    else
        self.content = self.content
    end
end

---@class NoticeDataManager
NoticeDataManager = class("NoticeDataManager")
function NoticeDataManager:Get()
    if self._instance == nil then
        self._instance = NoticeDataManager()
    end
    return self._instance
end

function NoticeDataManager:initialize()
    ---@type table<number,table<number,NoticeItemData>>
    self.SystemNotices = {}
    self.SystemNoticeLevUpperLimit = 0
    ---@type table<number,table<number,NoticeItemData>>
    self.PlayerNotices = {}
    self.PlayerNoticeLevUpperLimit = 0
    self.PlayerSmallSpeakTime = 0
    self.PlayerBigSpeakTime = 0
end

---@param msg SC_TvInfo
function NoticeDataManager:AddNoticeMsg(msg)
    local noticeItemData = NoticeItemData(msg)
    if noticeItemData.noticeType == NoticeType.SystemNotice then
        if self.SystemNotices[noticeItemData.lev] == nil then
            self.SystemNotices[noticeItemData.lev] = {}
        end
        for i = 1, noticeItemData.count do
            table.insert(self.SystemNotices[noticeItemData.lev], noticeItemData)
        end
        if noticeItemData.lev > self.SystemNoticeLevUpperLimit then
            self.SystemNoticeLevUpperLimit = noticeItemData.lev
        end
    elseif noticeItemData.noticeType == NoticeType.PlayerNotice then
        if self.PlayerNotices[noticeItemData.lev] == nil then
            self.PlayerNotices[noticeItemData.lev] = {}
        end
        for i = 1, noticeItemData.count do
            table.insert(self.PlayerNotices[noticeItemData.lev], noticeItemData)
        end
        if noticeItemData.lev > self.PlayerNoticeLevUpperLimit then
            self.PlayerNoticeLevUpperLimit = noticeItemData.lev
        end
    end
    if noticeItemData.noticeType == NoticeType.SystemNotice then
        CommonHelper:ShowNoticeMsg(NoticeType.SystemNotice)
        ChatDataManager:Get():PlayRollNotice(noticeItemData)
    elseif noticeItemData.noticeType == NoticeType.PlayerNotice then
        CommonHelper:ShowNoticeMsg(NoticeType.PlayerNotice)
    end
end

function NoticeDataManager:GetNextSystemNotice()
    for i = 0, self.SystemNoticeLevUpperLimit do
        if self.SystemNotices[i] and self.SystemNotices[i][1] then
            local notice = self.SystemNotices[i][1]
            table.remove(self.SystemNotices[i], 1)
            return notice
        end
    end
end

function NoticeDataManager:GetNextPlayerNotice()
    for i = 0, self.PlayerNoticeLevUpperLimit do
        if self.PlayerNotices[i] and self.PlayerNotices[i][1] then
            local notice = self.PlayerNotices[i][1]
            table.remove(self.PlayerNotices[i], 1)
            return notice
        end
    end
end

function NoticeDataManager:UpdateSmallSpeakTime(time)
    self.PlayerSmallSpeakTime = time
end

function NoticeDataManager:IsCanSmallSpeak()
    if self.PlayerSmallSpeakTime == 0 or CommonHelper:ConvertNowTimeDouble() > self.PlayerSmallSpeakTime then
        return true
    end
    return false
end

function NoticeDataManager:UpdateBigSpeakTime(time)
    self.PlayerBigSpeakTime = time
end

function NoticeDataManager:IsCanBigSpeak()
    if self.PlayerBigSpeakTime == 0 or CommonHelper:ConvertNowTimeDouble() < self.PlayerBigSpeakTime then
        return false
    end
    return true
end

function NoticeDataManager:IsCanPopNotice()
    return true
end
