---@class RaceSelfLevelData
RaceSelfLevelData=class("RaceSelfLevelData")
function RaceSelfLevelData:initialize()
    ---@type selfchapterticket_config_cell
    self.cfg=nil
    self.endTime=nil
    self.isJoin=false
    self.NpcIcon=nil
end

---@param msg SC_SC_Level_MiniGameInfo
function RaceSelfLevelData:SetMiniData(msg,isJoin)
    self.id = msg.id
    self.NpcId = msg.configId
    self.endTime = msg.endTime
    self.masterName = msg.masterName
    self.masterIcon = msg.masterIcon
    self.heroId=msg.heroid
    self.name=msg.name
    if self.heroId~=0 then
        ---@type hero_config_cell
        local hero_config= CommonHelper:GetTableDataByID(ConfigNames.hero_config,self.heroId)
        self.NpcIcon=hero_config.icon
        self.masterName=CommonHelper:GetTempStr_Default(hero_config.name)
        self.name=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfLevelDefaultName,self.masterName)
    end
    self.sceneId = msg.sceneId
    self.isJoin=isJoin
end

---@param msg SC_SC_Level_GameInfo
function RaceSelfLevelData:SetDetailData(msg,isJoin)
    self:SetMiniData(msg.gameInfo,isJoin)
    self.Rank=2
    self.Time=1000
    self.num=msg.num
    self.joinNum=msg.joinNum
    self.trackId=msg.trackId
    self.trackInfo=msg.trackInfo
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
