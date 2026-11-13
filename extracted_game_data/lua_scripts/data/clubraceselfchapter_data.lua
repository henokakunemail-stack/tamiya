---@class  ClubRaceSelfChapterData
ClubRaceSelfChapterData=class("ClubRaceSelfChapterData")
function ClubRaceSelfChapterData:initialize()
    ---@type guildselfchapterticket_config_cell
    self.cfg=nil
    self.endTime=nil
end

---@param msg SC_GUILD_SC_Chapter_GameInfo
function ClubRaceSelfChapterData:SetMiniData(msg,isJoin)
    self.id=msg.id
    self.ticketId=msg.ticketId
    ---@type guildselfchapterticket_config
    local data= ClientDataManager:Get():GetDataTable(ConfigNames.guildselfchapterticket_config).GetConfigData()
    self.cfg=nil
    for k, v in pairs(data) do
        if self.ticketId==v.holdCost then
            self.cfg=v
        end
    end
    self.endTime=msg.endTime
    self.subTime=CommonHelper:SubTime(self.endTime)
    self.subDay=math.modf(self.subTime/1000/60/60/24)
    self.subHour=math.modf(math.fmod(self.subTime,60*60*24)/60/60)
    self.masterName=msg.masterName
    self.masterIcon=msg.masterIcon
    self.level=msg.level
    if isJoin~=nil then
        self.isJoin=isJoin
    end
end

---@param msg SC_GUILD_SC_CreateChapterRes
function ClubRaceSelfChapterData:SetDetailData(msg)
    self:SetMiniData(msg.gameInfo.gameInfo)
    self.subCount=msg.gameInfo.num		--剩余挑战次数
    self.joinNum = msg.gameInfo.joinNum --一共多少人参加
    self.passNum = msg.gameInfo.passNum --通关人数
end

