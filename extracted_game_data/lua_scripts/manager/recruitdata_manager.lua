---@class RecruitData
RecruitData = class("RecruitData")

function RecruitData:initialize()
    ---@type SC_RecruitInfo
    self.info = nil
    ---@type table<number, dictrecruitlab_config_cell>
    self.probability = nil

    self.recruitTime = 0--免费抽奖倒计时时间
    self.Score=0
    ---@type dictrecruit_config_cell
    self.cfg = nil
    ---@type RecruitData[]
    self.Datas=nil
end


---- --0是不显示 1是显示
function RecruitData:GetVow()
    return self.info.pVow
end
function RecruitData:GetSort()
    if self.cfg then
        return self.cfg.sort
    end
end
---表里配的是秒，转换要用毫秒
function RecruitData:GetStartTime()
    return self.info.beginTime * 1000
end
function RecruitData:GetEndTime()
    return self.info.endTime * 1000
end

function RecruitData:IsOpen()
    local nowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    return self.cfg.endtime == 0 or nowTime < self.cfg.endtime
end

function RecruitData:SetRecruitTime()

    self.recruitTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + self:GetCurFreeTime() + 2
end

function RecruitData:GetRecruitTime()
    return self.recruitTime
end

---@param msg SC_RecruitInfo
function RecruitData:SetRecruitData(msg)
    self.OrgSelect=stringSplitToNumber(msg.CurSelect,':')
    self.info = msg
    local recruitCfg= ClientDataManager:Get():GetDataTable(ConfigNames.recruitgame_config)
    self.cfg = recruitCfg.GetDataBuyServerIdAndRecruitid(PlayerDataManager:Get():GetPlayerServerID(), self:GetId())
    ---@type dictrecruit_config
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.recruitlab_config)
    if cfg then
        self.probability=cfg.GetDataByRecruitId(self.info.recruitId)
    end
    self:SetRecruitTime()

end



---@return  table<number,SC_DropChance>
function RecruitData:GetShowResult()
    local icons = stringSplit(self.cfg.awardIcon, ',')
    return icons
end
function RecruitData:AddRecruitData(data)
    if self.Datas==nil then
        self.Datas={}
    end
    local flag=true
    for k, v in pairs(self.Datas) do
        if v:GetId()==data:GetId() then
            flag=false
            break
        end
    end
    if flag then
        table.insert(self.Datas,data)
    end

end

--大背景
function RecruitData:GetBgIcon()
    return self.cfg.drawBack
end
function RecruitData:GetBgRole()
    return self.cfg.showrole..".png"
end
function RecruitData:GetShowPart()
    return self.cfg.showpart
end
function RecruitData:GetAttType()
    return self.cfg.atttype
end
function RecruitData:GetRecruits()
    return self.Datas
end

function RecruitData:GetBgBanner()
    return string.format("%s.png",self.cfg.bannername)
end

function RecruitData:GetMaxName()
    return self.cfg.maxname
end

--左下角页签
function RecruitData:GetTabIcon()
    return self.cfg.drawIcon
end

--券的图标
function RecruitData:GetTicketIcon()
    return self.cfg.ticketIcon
end
--券的图标
function RecruitData:GetSumVal()
    return self.info.sumval
end

--货币图标
function RecruitData:GetCurrencyIcon()
    return self.cfg.currencyIcon
end
--类型图标
function RecruitData:GetTypeIcon()
    return self.cfg.typeIcon
end

---当日累计抽奖次数
function RecruitData:GetRecruitSum()
    return self.info.dayNum
end
---当日累计抽奖次数
function RecruitData:GetPrizeCount()
    return self.info.curPrizeNum
end
---保底選擇
function RecruitData:GetCurSelect(index)
    if index==RecruitDivinationCell.None then
        return tonumber(self.info.CurSelect)
    else
        return stringSplitToNumber(self.info.CurSelect,':')[index]
    end
end
function RecruitData:SetCurSelect(index)
    self.info.CurSelect=index
end
function RecruitData:GetIsOrgSelect()
    local flag=true
    for i = 1, self:GetRecruitViewType() do
        if self.OrgSelect[i]==nil or self.OrgSelect[i]<=0 then
            flag=false
            break
        end
    end
    return flag
end
function RecruitData:GetIsSelectIsSure()
    local flag=true
    for i = 1, self:GetRecruitViewType() do
        if self:GetCurSelect(i)~=self.OrgSelect[i] then
            flag=false
            break
        end
    end
    return flag
end

function RecruitData:GetCurOrgSelect(index)
    return self.OrgSelect[index]
end

---保底時間
function RecruitData:GetSelectTime()
    return self.info.selectnum>=0
end
---保底時間
function RecruitData:GetTaskType()
    return self.cfg.taskids~="0" or self.cfg.awardnums~="0"
end
function RecruitData:GetTaskShellTask()
    return self.cfg.taskids~="0"
end
function RecruitData:GetTaskCountTask()
    return self.cfg.awardnums~="0"
end
function RecruitData:GetRecruitViewType()
    return self.cfg.selectpoint
end

---保底池子
function RecruitData:GetAwardIds()
    return self.info.awardids
end

---当前免费计时，0免费 -1不免费 >0计时中
function RecruitData:GetCurFreeTime()
    return self.info.freeTime
end
function RecruitData:SetCurFreeTime(curFreeTime)
    self.info.freeTime = curFreeTime
end

function RecruitData:GetFreeTime()
    return self.cfg.freecd
end

---抽奖次数上限
function RecruitData:GetRecruitTimeLimit()
    return self.cfg.daysum
end

--免费次数为0，代表没有免费抽奖
function RecruitData:GetFreeNum()
    return self.info.freeNum
end
--当前可以免费抽奖的次数,curFreeNum 为当前已经免费抽奖的次数，用总次数-已经免费抽取的次数，得出所剩次数
function RecruitData:GetCurFreeNum()
    return  self.info.freeNum
end
function RecruitData:SetCurFreeNum(curFreeNum)
    self.info.curFreeNum = self:GetFreeNum() - curFreeNum
end

function RecruitData:GetSelfTicket()
    return self.info.pTicket
end
function RecruitData:SetSelfTicket(ticket)
    self.info.pTicket = ticket
end

function RecruitData:GetMoneyType()
    return self.cfg.moneytype
end

---0代表不用抽奖券，不为0代表可以使用抽奖券
function RecruitData:GetTicketId()
    return self.cfg.ticketid
end

---单次抽奖消耗
function RecruitData:GetOneConsume()
    return self.cfg.oneexpend
end

---单次抽奖消耗
function RecruitData:GetTenConsume()
    return self.cfg.tenexpend
end

function RecruitData:GetId(SubType)
    if self.Datas and SubType then
        self.Datas[SubType]:GetId()
    end
    return self.info.recruitId
end

function RecruitData:GetGroupId()
    return self.GroupId
end

function RecruitData:SetGroupId(id)
    self.GroupId=id
end

function RecruitData:GetDesc()
    return self.cfg.dictawarddes
end

function RecruitData:GetDescTitle()
    return self.cfg.dictawardname
end

---@class RecruitDataManager
RecruitDataManager = class("RecruitDataManager")

function RecruitDataManager:initialize()
    ---@type table<number, RecruitData>
    self.DataMapDic = {}
    ---@type table<number,number>
    self.IndexIdList = {}
    self.curSelectRecruitId = -1
    self.timerDic = {}--抽奖计时器表
    self.redPointDic = {}--红点数据，一个抽奖一个红点，空表--没有红点  不为空--有红点

    self.recruitCount = -1 --这是几连抽，0--免费 1--单抽 10--十连抽
    self.recruitType = RecruitType.None--在主界面 还是再抽一次

    self.newRecruitId = 401--新手奖池，只显示一次
    --CacheClearTrigger:Get():RegisterEvent(self, self.ClearRecruitData)

    ---@type number[]
    self.carFive={ 23000006,23000010,24000031,24000030,24000022}
    ---@type number[]
    self.carTwo={23000008,23000000}
    ---@type number[]
    self.carTwoDam={24000024,24000018}
    ---@type number
    self.CarDic={}
    CrossDayTrigger:Get():RegisterEvent(self,self.CrossDay)
end

function RecruitDataManager:Get()
    if self._instance == nil then
        self._instance = RecruitDataManager()
    end
    return self._instance
end

function RecruitDataManager:GetNewRecruitId()
    return self.newRecruitId
end
function RecruitDataManager:RecycleCar()
    for k, v in pairs(self.CarDic) do
        CarBuilderManager:Get():Recycle(v)
    end
    self.CarDic = {}
end
function RecruitDataManager:ReleaseCar()
    for k, v in pairs(self.CarDic) do
        local  car=CarBuilderManager:Get():GetCarRoot(v)
        CommonHelper:CSGameObjectSetActive(car,false)
        UIUtil.SetParentTransform(PrefabCacheMgr:Get().Root,car)
    end

end

function RecruitDataManager:SetRecruitType(recruitType)
    self.recruitType = recruitType
end

---@return RecruitType
function RecruitDataManager:GetRecruitType()
    return self.recruitType
end

function RecruitDataManager:SetCurSelectRecruitId(curSelectRecruitId)
    self.curSelectRecruitId = curSelectRecruitId
end
function RecruitDataManager:GetCurSelectRecruitId()
    --if self:GetDataById(self.curSelectRecruitId) and self:GetDataById(self.curSelectRecruitId).Datas then
    --    local _CurSubType=PlayerPrefsHelper:GetValue_RecruitSubType()
    --    self.SubId=self.curSelectRecruitId
    --    if self:GetDataById(self.curSelectRecruitId).Datas[_CurSubType] then
    --        self.SubId=self:GetDataById(self.curSelectRecruitId).Datas[_CurSubType]:GetId()
    --    end
    --    return self.curSelectRecruitId
    --end
    return self.curSelectRecruitId
end

function RecruitDataManager:SetRecruitCount(recruitCount)
    self.recruitCount = recruitCount
end
function RecruitDataManager:GetRecruitCount()
    return self.recruitCount
end
local GroupMainIndex=1
---@param infos table<number,SC_RecruitInfo>
function RecruitDataManager:InitRecruitData(infos,flag)
    self.DataMapDic = {}
    self.IndexIdList = {}
    for i = 1, #infos do
        local recruitData = RecruitData()
        recruitData:SetRecruitData(infos[i])
        if recruitData.cfg then
            self.DataMapDic[infos[i].recruitId] = recruitData
        end
    end
    local GroupId={}
    for k, v in pairs(self.DataMapDic) do
        if v:GetAttType()=="0" then
            table.insert(self.IndexIdList,k)
        else
            table.insert(GroupId,k)
        end
    end
    table.sort(GroupId)
    for i = 1, #GroupId do
        self.DataMapDic[GroupId[i]]:SetGroupId(GroupId[GroupMainIndex])
        self.DataMapDic[GroupId[GroupMainIndex]]:AddRecruitData(self.DataMapDic[GroupId[i]])
    end
    table.insert(self.IndexIdList,GroupId[GroupMainIndex])
    table.sort(self.IndexIdList, function(a, b)
        local recruitData_A = self:GetDataById(a)
        local recruitData_B = self:GetDataById(b)
        return recruitData_A:GetSort() < recruitData_B:GetSort()
    end)
    if  flag then
        self:SetCurSelectRecruitId(self.IndexIdList[1])
        if #self.IndexIdList >=3  then
            self:SetCurSelectRecruitId(self.IndexIdList[3])
        end
    else
        if self.DataMapDic[self:GetCurSelectRecruitId()]==nil then
            self:SetCurSelectRecruitId(self.IndexIdList[1])
            if #self.IndexIdList >=3  then
                self:SetCurSelectRecruitId(self.IndexIdList[3])
            end
        end
    end

    for recruitId, recruitData in pairs(self.DataMapDic) do
        self:StartCountTime(recruitData)
        if recruitData:GetTicketId() ~= 0 and recruitData:GetCurFreeTime() == 0 and recruitData:GetCurFreeNum() > 0 then
            self:UpdateRedDic(recruitData:GetId(), recruitData:GetId())
        end
    end
end


---@param infos table<number,SC_RecruitInfo>
function RecruitDataManager:UpdateRecruitData(infos)
    for i = 1, #infos do
        if infos[i].recruitId == self.newRecruitId then
            self:RemoveRecruitById(self.newRecruitId)
            if #self.IndexIdList > 0 then
                self:SetCurSelectRecruitId(self.IndexIdList[1])
            end
        else
            local recruitData = self:GetDataById(infos[i].recruitId)
            if recruitData then
                recruitData:SetRecruitData(infos[i])
                local ticketId = recruitData:GetTicketId()
                if ticketId ~= 0 then
                    for j = 1, #self.IndexIdList do
                        local UpdateRecruitData = self:GetDataById(self.IndexIdList[j])
                        if UpdateRecruitData:GetTicketId() == ticketId then
                            UpdateRecruitData:SetSelfTicket(infos[i].pTicket)
                        end
                    end
                end
            else
                self.IndexIdList={}
                local recruitData = RecruitData()
                recruitData:SetRecruitData(infos[i])
                if recruitData.cfg then
                    self.DataMapDic[infos[i].recruitId] = recruitData
                end
                local GroupId={}
                for k, v in pairs(self.DataMapDic) do
                    if v:GetAttType()=="0" then
                        table.insert(self.IndexIdList,k)
                    else
                        table.insert(GroupId,k)
                    end
                end
                table.sort(GroupId)
                for i = 1, #GroupId do
                    self.DataMapDic[GroupId[i]]:SetGroupId(GroupId[GroupMainIndex])
                    self.DataMapDic[GroupId[GroupMainIndex]]:AddRecruitData(self.DataMapDic[GroupId[i]])
                end
                table.insert(self.IndexIdList,GroupId[GroupMainIndex])
                table.sort(self.IndexIdList, function(a, b)
                    local recruitData_A = self:GetDataById(a)
                    local recruitData_B = self:GetDataById(b)
                    return recruitData_A:GetSort() < recruitData_B:GetSort()
                end)
                for recruitId, recruitData in pairs(self.DataMapDic) do
                    self:StartCountTime(recruitData)
                    if recruitData:GetTicketId() ~= 0 and recruitData:GetCurFreeTime() == 0 and recruitData:GetCurFreeNum() > 0 then
                        self:UpdateRedDic(recruitData:GetId(), recruitData:GetId())
                    end
                end
            end
        end
    end
end

---@return RecruitData
function RecruitDataManager:GetDataById(id)
    if self.DataMapDic[id] ~= nil then
        return self.DataMapDic[id]
    else
        logError("GetData--在抽奖数据里面没有找到该id  id是" .. tostring(id))
        return nil
    end
end
---@param recruitData RecruitData
function RecruitDataManager:SetDataById(recruitData)
    self.DataMapDic[recruitData:GetId()] = recruitData
end

---@return RecruitData
function RecruitDataManager:GetDataByIndex(index)
    if self.IndexIdList[index] ~= nil then
        return self.DataMapDic[self.IndexIdList[index]]
    else
        logError("GetDataByIndex--当前索引表里面没有该索引")
    end
end

function RecruitDataManager:RemoveRecruitById(recruitId)
    self.DataMapDic[recruitId] = nil
    for i = #self.IndexIdList, 1, -1 do
        if self.IndexIdList[i] == recruitId then
            table.remove(self.IndexIdList, i)
            break
        end
    end
end

function RecruitDataManager:GetRecruitTypeCount()
    return #self.IndexIdList
end

function RecruitDataManager:ClearRecruitData()
    self.IndexIdList = {}
    self.DataMapDic = {}
    self.timerDic = {}
    self.curSelectRecruitId = -1
    self.recruitType = RecruitType.None
end

---更新计时器，防止时间不一致
function RecruitDataManager:AddRecruitTimer(recruitId, timerID)
    self.timerDic[recruitId] = timerID
end

function RecruitDataManager:RemoveRecruitTimer(recruitId)
    if self.timerDic[recruitId] then
        TimerManager:Get():StopTimer(self.timerDic[recruitId])
        self.timerDic[recruitId] = nil
    end
end

function RecruitDataManager:GetRecruitTimerById(recruitId)
    return self.timerDic[recruitId]
end

---@param recruitData RecruitData
function RecruitDataManager:StartCountTime(recruitData)
    if recruitData:GetTicketId() == 0 or recruitData:GetCurFreeTime() <= 0 then
        return
    end

    self:RemoveRecruitTimer(recruitData:GetId())

    local timerId = TimerManager:Get():CreateTimerLoop(1, function()
        if CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) >= recruitData:GetRecruitTime() then
            self:RemoveRecruitTimer(recruitData:GetId())
            recruitData:SetCurFreeTime(0)
            recruitData:SetCurFreeNum(recruitData:GetCurFreeTime() - 1)

            self:UpdateRedDic(recruitData:GetId(), recruitData:GetId())

            UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitViewInfo)
        end
    end)

    self:AddRecruitTimer(recruitData:GetId(), timerId)
end

function RecruitDataManager:StartAllCountTime()
    for recruitId, timerId in pairs(self.timerDic) do
        if self:GetDataById(recruitId) then
            self:GetDataById(recruitId):SetRecruitTime()
            self:StartCountTime(self:GetDataById(recruitId))
        else
            self:RemoveRecruitTimer(recruitId)
            logError("有计时器，但是没有抽奖数据，ID是" .. recruitId)
        end
    end
end


--{{{红点
function RecruitDataManager:GetRedById(recruitId)
    return self.redPointDic[recruitId]
end
function RecruitDataManager:GetRedByIdIsTask(recruitId)
    return tostring(self.redPointDic[recruitId])=="Task"
end
function RecruitDataManager:GetRedByIdIsCount(recruitId)
    if recruitId>100000 then
        return tostring(self.redPointDic[recruitId])=="Count"
    else
        return tostring(self.redPointDic[recruitId+100000])=="Count"
    end

end

function RecruitDataManager:RecRedPointId(id,value)
    local recruitCfg= ClientDataManager:Get():GetDataTable(ConfigNames.recruitgame_config)
    if id>=100000 then
        local orgid=id-100000
        local cfg = recruitCfg.GetDataBuyServerIdAndRecruitid(PlayerDataManager:Get():GetPlayerServerID(), orgid)
        if cfg then
            if value=="Check" then
                self:UpdateRedDic(id, "Count")
            else
                self:UpdateRedDic(id, value)
            end
        end
    else
        local cfg = recruitCfg.GetDataBuyServerIdAndRecruitid(PlayerDataManager:Get():GetPlayerServerID(), id)
        if cfg then
            if value=="Check" then
                self:UpdateRedDic(id, "Task")
            else
                self:UpdateRedDic(id, value)
            end
        end
    end
end
function RecruitDataManager:UpdateRedDic(recruitId, value)
    self.redPointDic[recruitId] = value
    RedPointManager:Get():UpdateValue(RedPointID.S_Recruit_Task,self:GetRedByIdIsTask(recruitId))
    RedPointManager:Get():UpdateValue(RedPointID.S_Recruit_Count,self:GetRedByIdIsCount(recruitId))
    --这个比较特殊，服务器通知，客户端计算消失
    RedPointManager:Get():UpdateValue(RedPointID.S_Recruit, self:IsHaveRedPoint())

    UINotify:Get():SendNotification(UINotifyEvent.RecruitView_UpdateRecruitList)
end

function RecruitDataManager:GetRedPointCount()
    local redCount = 0
    for key, value in pairs(self.redPointDic) do
        redCount = redCount + 1
    end
    return redCount
end

function RecruitDataManager:IsHaveRedPoint()
    return self:GetRedPointCount() > 0
end
function RecruitDataManager:CrossDay()
    if UIManager:Get():IsViewShow("RecruitView") then
        RecruitSubsystem:Get():SendMsg_RecruitInfo(1)
    end
end
--}}}


