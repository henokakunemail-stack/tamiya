---@class ClubRaceSelfLevelData
ClubRaceSelfLevelData=class("ClubRaceSelfLevelData")
function ClubRaceSelfLevelData:initialize()
    ---@type guildselfchapterticket_config_cell
    self.cfg=nil
    self.endTime=nil
    self.isJoin=false
end

---@param msg SC_GUILD_SC_Level_GameInfo
function ClubRaceSelfLevelData:SetMiniData(msg,isJoin)
    self.id = msg.id
    self.NpcId = msg.configId
    self.endTime = msg.endTime
    self.masterName = msg.masterName
    self.masterIcon = msg.masterIcon
    self.sceneId = msg.sceneId
    self.name="自建赛事"
    self.isJoin=isJoin
end

---@param msg SC_GUILD_SC_CreateLevelRes
function ClubRaceSelfLevelData:SetDetailData(msg,isJoin)
    self:SetMiniData(msg.gameInfo,isJoin)
    self.Rank=2
    self.Time=1000
    self.num=msg.num
    self.joinNum=msg.joinNum
    self.trackId=msg.trackId
    self.trackInfo=msg.trackInfo
    self.name="自建赛事"
    ---@type table<number,ShowBasePlayerInfo>
    self.PlayRankInfo={}
    if msg.rank3List then
        for i = 1, #msg.rank3List do
            local temp=ShowBasePlayerInfo()
            temp:SetData(msg.rank3List[i])
            table.insert(self.PlayRankInfo,temp)
        end
    end

end
