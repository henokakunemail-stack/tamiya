



---@class SelfChallengeData
---@field id
---@field tickets
---@field masterId
---@field masterName
---@field name
---@field barrierNums
---@field trackType
---@field lvNum
---@field curLevel
---@field scenes
---@field difficulty
---@field holdReward
---@field flockRewards
---@field dropReward
---@field finishRewards
---@field trackNpcInfo
---@field needSetLv
---@field lastDays
---@field isCompile
---@field joinCounts

SelfChallengeData = class("SelfChallengeData")
function SelfChallengeData:initialize()
    self.id=1
    self.tickets=1
    self.masterId=nil
    self.masterName=nil
    self.name=nil
    self.curNum=nil
    self.barrierNums=nil
    self.scenes=nil
    self.difficulty=1
    self.holdReward=1
    self.flockRewards=nil
    self.joinCounts={}
    self.dropReward=1
    self.finishRewards=1
    self.needSetLv={}
    self.curLevel=-1
    self.isCompile=false


end
---@param data selfchallenge_config_cell
function SelfChallengeData:SetData(data)
    self.id=data.id
    self.articleId=data.holdCost
    self.tickets=data.holdCost
    self.joinCost=data.holdCost
    self.quality=data.quality
    self.lastDays=stringSplitToNumber(data.lastDays,',')
    self.barrierNums=stringSplitToNumber(data.barrierNum,',')
    self.scenes=stringSplitToNumber(data.sceneIds,',')
    self.difficulty=data.difficulty
    self.trackType=data.trackType
    self.holdReward=data.holdReward

    self.dropReward=stringSplitToNumber(data.dropRewards,',')
    self.flockRewards={}
    self.joinCounts={}
    local  temp=stringSplit(data.flockRewards,';')
    for i = 1, #temp do
        local  tempItem=stringSplit(temp[i],',')
        table.insert(self.joinCounts,tonumber(tempItem[1]))
        self.flockRewards[tonumber(tempItem[1])]=tonumber(tempItem[2])
    end
    table.sort(self.joinCounts,function(a, b) return a<b end)
    self.finishRewards={}
    temp=stringSplit(data.finishRewards,';')
    for i = 1, #temp do
        local  tempItem=stringSplit(temp[i],':')
        table.insert(self.needSetLv,tonumber(tempItem[1]))
        self.finishRewards[tonumber(tempItem[1])]=stringSplitToNumber(tempItem[2],',')
    end
    table.sort(self.needSetLv,function(a, b) return a<b end)
    self.trackNpcInfo={}
    temp=stringSplit(data.trackNpcInfo,';')
    for i = 1, #temp do
        local  tempItem=stringSplit(temp[i],':')
        self.trackNpcInfo[tonumber(tempItem[1])]=stringSplitToNumber(tempItem[2],',')
    end



end

-------------------------------------------------
---@param data SC_SelfChallengeInfo
function SelfChallengeData:SetOtherData(data)
    self:SetMiniData(data.miniInfo)
    self.dropReward=data.dropRewards
    self.finishRewards=data.finishRewards
    self.levelInfos=data.levelInfos
    self.finishRewards=data.finishRewardStates



end

---@param data SC_SelfChallengeCreateInfo
function SelfChallengeData:SetSelfData(data)
    self:SetOtherData(data.scInfo)
    self.joinNum=data.joinNum
    self.flockRewards=data.flockRewards


end

---@param data SC_SelfChallengeMiniInfo
function SelfChallengeData:SetMiniData(data)
    self.id=data.id
    self.masterId=data.masterId
    self.name=data.name
    self.masterName=data.masterName
    self.tickets=data.ticketId
    self.trackType=data.trackType
    self.difficulty=data.difficulty
    self.lvNum=data.lvNum
    self.endTime=CommonHelper:SubTime(data.endTime)
    self.subDay= math.modf(self.endTime/1000/60/60/24)
    self.curLevel=data.curLevel
    self.isCompile=true


end
----------------------------------------------------
function SelfChallengeData:GetTracks()



    local track={}
    for i, v in pairs(self.trackNpcInfo) do
        table.insert(track,i)
    end
    return track

end



------------------------------------------------------