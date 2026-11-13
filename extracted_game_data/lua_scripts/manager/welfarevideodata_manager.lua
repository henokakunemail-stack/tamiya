---@class WelfareVideoDataManager
WelfareVideoDataManager = class("WelfareVideoDataManager")

---@class DayGiftCountData---------------------------------------
DayGiftCountData = class("DayGiftCountData")
function DayGiftCountData:initialize()
    self.awardIds = {}
    self.awardNums = {}
    self.countNo = 0
    self.giftFlag = 0
end

function DayGiftCountData:InitBaseData(data, countNum, giftFlag)
    self.awardIds = data.propsids
    self.awardNums = data.propsnums
    self.countNo = countNum
    self.giftFlag = giftFlag
end

function DayGiftCountData:GetAwardIds()
    return self.awardIds
end

function DayGiftCountData:GetAwardNums()
    return self.awardNums
end

function DayGiftCountData:GetCountNo()
    return self.countNo
end

function DayGiftCountData:GetGiftFlag()
    return self.giftFlag
end
---------------------------------------------------------------

---@class DayGiftData---------------------------------------
DayGiftData = class("DayGiftData")
function DayGiftData:initialize()
    self.curStatus = 0  --0未1可领2已领
    self.maxWatch = 0   --当日最大观看次数
    self.seq = 0        --序号
    self.watchNum = 0   --当日已观看次数
end

function DayGiftData:InitBaseData(msg)
    self.curStatus = msg.curStatus
    self.maxWatch = msg.maxWatch
    self.seq = msg.seq
    self.watchNum = msg.watchNum
end

function DayGiftData:GetCurStatus()
    return self.curStatus
end

function DayGiftData:GetMaxWatch()
    return self.maxWatch
end

function DayGiftData:GetSeq()
    return self.seq
end

function DayGiftData:GetWatchNum()
    return self.watchNum
end
---------------------------------------------------------------

---@class LuckyTableData---------------------------------------
LuckyTableData = class("DayGiftData")
function LuckyTableData:initialize()
    self.canUseNum = 0   --当前可用次数零散表152
    self.maxWatch = 0 --当日最大观看次数
    self.watchNum = 0 --当日已观看次数
end

function LuckyTableData:InitBaseData(msg)
    self.canUseNum = msg.canUseNum
    self.maxWatch = msg.maxWatch
    self.watchNum = msg.watchNum
end

function LuckyTableData:GetCanUseNum()
    return self.canUseNum
end

function LuckyTableData:GetMaxWatch()
    return self.maxWatch
end

function LuckyTableData:GetWatchNum()
    return self.watchNum
end
---------------------------------------------------------------

---@return WelfareVideoDataManager
function WelfareVideoDataManager:Get()
    if self._instance == nil then
        self._instance = WelfareVideoDataManager()
    end
    return self._instance
end

function WelfareVideoDataManager:initialize()
    self.DayGiftAward = {}
    self.DayGiftState = {}
    self.LuckyTableAward = {}
    self.LuckyTableState = {}
    CrossDayTrigger:Get():RegisterEvent(self, self.CrossDay)
end

-----观影礼赠
function WelfareVideoDataManager:InitDayGiftAwardData()
    self.DayGiftAward = {}
    local DayGiftTab = ClientDataManager:Get():GetDataTable(ConfigNames.dictvideogift_config).GetConfigData()
    for i, v in pairs(DayGiftTab) do
        if type(v.propsids) == "string" then
            local propsIds = stringSplit(v.propsids, ":")
            local propsNums = stringSplit(v.propsnums, ":")
            local randVals = stringSplit(v.randvals, ":")
            v.propsids = propsIds
            v.propsnums = propsNums
            v.randvals = randVals
        end
        table.insert(self.DayGiftAward, v)
    end
end

function WelfareVideoDataManager:GetDayGiftAwardData()

    return self.DayGiftAward
end

function WelfareVideoDataManager:InitDayGiftStateData(msg)
    self.DayGiftState = {}
    for i, v in pairs(msg.dayVideoGifts) do
        local itemData = DayGiftData()
        itemData:InitBaseData(v)
        table.insert(self.DayGiftState, itemData)
    end
end

function WelfareVideoDataManager:RefreshDayGiftStateData(msg)
    for i, v in pairs(self.DayGiftState) do
        if v.seq == msg .seq then
            v.watchNum = msg.watchNum
        end
    end
end

function WelfareVideoDataManager:GetDayGiftStateData()
    return self.DayGiftState
end

function WelfareVideoDataManager:SetVideoDayGiftNumber(_num)
    self.DayGiftVideoNumber = _num
end

function WelfareVideoDataManager:GetVideoDayGiftNumber()
    return self.DayGiftVideoNumber
end

-----观影转盘
function WelfareVideoDataManager:InitLuckyTableAwardData()
    local videolucky = ClientDataManager:Get():GetDataTable(ConfigNames.dictvideolucky_config).GetConfigData()
    self.LuckyTableAwardData = videolucky
end

function WelfareVideoDataManager:GetLuckyTableAwardData()
    return self.LuckyTableAwardData
end

function WelfareVideoDataManager:InitLuckyTableStateData(msg)
    self.LuckyTableState = {}
    local itemData = LuckyTableData()
    itemData:InitBaseData(msg)
    table.insert(self.LuckyTableState, itemData)
end

function WelfareVideoDataManager:GetLuckyTableStateData()
    return self.LuckyTableState
end

function WelfareVideoDataManager:GetLuckytableTicketNum()
    return self.LuckyTableState
end

----------------

function WelfareVideoDataManager:InitVideoMD5Str(_time, CreativeIdentifier, _num)
    local str = ""
    local VideoStr = ""
    local _rid = PlayerDataManager:Get():GetPlayerRID()

    if _num ~= nil then
        VideoStr = "playtime=" .. _time .. "rid=" .. _rid .. "movieId=" .. CreativeIdentifier .. "seq=" .. _num .. VideoMD5.MD5
    else
        VideoStr = "playtime=" .. _time .. "rid=" .. _rid .. "movieId=" .. CreativeIdentifier .. VideoMD5.MD5
    end
    str = CS.AndroidUtility.Md5Encode(VideoStr)

    return str
end

function WelfareVideoDataManager:SetWelfareFuncID(_ID)
    self.WelfareFuncID = _ID
end

function WelfareVideoDataManager:GetWelfareFuncID()
    return self.WelfareFuncID
end

function WelfareVideoDataManager:SetWelfareFuncPassword()
    local _time = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    local _rid = PlayerDataManager:Get():GetPlayerRID()
    self.WelfareFuncPassword = _time .. _rid
end

function WelfareVideoDataManager:GetWelfareFuncPassword()
    return self.WelfareFuncPassword
end

function WelfareVideoDataManager:GetAllBtnData()
    local welfareSwift = {}
    local _welfare = ClientDataManager:Get():GetDataTable(ConfigNames.welfareswift_config).GetConfigData()
    for i, v in pairs(_welfare) do
        local flag = true
        if v.C_ID == WelfareFuncType.dayGift then
            flag =HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.VideoGift)
        end
        if v.C_ID == WelfareFuncType.luckyTable then
            flag = HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.VideoLuckTurntable)
        end
        if v.C_ID == WelfareFuncType.boxAwards then
            flag = HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BoxAward)
        end
        if v.actswift > 0 and flag then
            table.insert(welfareSwift, v)
        end
    end

    return welfareSwift
end

function WelfareVideoDataManager:CreateTimerID(videoType)
    self.TimerID = TimerManager:Get():CreateTimer(2, function()
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.WelfareVideoNoResource))
        if videoType == WelfareFuncType.dayGift then
            MonthSignSubsystem:Get():SendMsg_ReqDayVideo()
            WelfareVideoDataManager:Get():SetWelfareFuncID(WelfareFuncType.dayGift)
        end
    end)
end

function WelfareVideoDataManager:ClearTimerID()
    if self.TimerID ~= -1 then
        TimerManager:Get():StopTimer(self.TimerID)
        self.TimerID = -1
    end
end

function WelfareVideoDataManager:InitVideoDayGiftCumulative()
    self.VideoDayGiftCumulative = {}
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictvideocount_config).GetConfigData()
    for i, v in pairs(cfg) do
        local itemData = DayGiftCountData()
        itemData:InitBaseData(v, i, 0)
        table.insert(self.VideoDayGiftCumulative, itemData)
    end
end

function WelfareVideoDataManager:SetVideoDayGiftCumulative(msg)
    for i, v in pairs(self.VideoDayGiftCumulative) do
        v.giftFlag = msg.countGift[i]
    end

    if msg.countNum ~= nil then
        self.VideoDayGiftCumulativeCountNum = msg.countNum
    end
end

function WelfareVideoDataManager:GetVideoDayGiftCumulative()
    return self.VideoDayGiftCumulative
end

function WelfareVideoDataManager:GetVideoDayGiftCumulativeCountNum()
    return self.VideoDayGiftCumulativeCountNum
end

function WelfareVideoDataManager:RefreshWelfareViewState()
    if not UIManager:Get():IsViewShow("WelfareView") then
        UIManager:Get():OpenView("WelfareView", CanvasType.MainCanvas, "WelfareView")
    else
        UINotify:Get():SendNotification(UINotifyEvent.WelfareReOpen)
    end

end

function WelfareVideoDataManager:CrossDay()
    if UIManager:Get():IsViewShow("WelfareView") then
        UINotify:Get():SendNotification(UINotifyEvent.WelfareReOpen)
    end
end