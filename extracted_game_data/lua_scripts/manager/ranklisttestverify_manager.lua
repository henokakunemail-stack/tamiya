---@class RankListTestVerifyDataManager
RankListTestVerifyDataManager = class("RankListTestVerifyDataManager")
function RankListTestVerifyDataManager:initialize()
   self.IsVerify=false
end
function RankListTestVerifyDataManager:Get()
    if self._instance == nil then
        self._instance = RankListTestVerifyDataManager()
    end
    return self._instance
end
--{{{ 验证排行版
function RankListTestVerifyDataManager:Begin()
    self.IsVerify=true
    self.OpDic={}
    self.OpDic[1]=self.GetServerList
    self.OpDic[2]=self.EnterGameServer
    self.OpDic[3]=self.Done
    self.OpDic[MsgID.GET_SERVER_LIST_S2C_RES]=self.RecServerList
    self.OpDic[MsgID.ENTER_SERVER_PART_S2C_RES]=self.LoginSpeedRankData
    self:ConnectLoginServer()
end
function RankListTestVerifyDataManager:GetIsVerify()
   return  CS.GameProperties:Get().AssetBundleMode==false and  self.IsVerify
end

function RankListTestVerifyDataManager:ConnectLoginServer()
    NetManager:Get():ConnectLoginServer()
end
function RankListTestVerifyDataManager:GetServerList()
    LoginSubSystem:Get():Send_GetServerList("dyy11")
end
---@param msg SC_AuthuserMess
function RankListTestVerifyDataManager:RecServerList(msg)
    self.ServerList=Queue()
    self.Token=msg.authtoken
    self.Uid=msg.uid
    if msg.svrs then
        for i = 1, #msg.svrs do
            local serverData = ServerInfo()
            serverData:InitServerInfo(msg.svrs[i])
            self.ServerList:EnQueueFront(serverData)
        end
    end
    self:Execute()
end
function RankListTestVerifyDataManager:Execute()
    if self.ServerList then
        local value= self.ServerList:DeQueueBack()
        if value then
            self:LoginGameServer(value)
        else
            self.IsVerify=false
        end
    end
end
---@param serverData ServerInfo
function RankListTestVerifyDataManager:LoginGameServer(serverData)
    self.CurServerData=serverData
    NetManager:ConnectGameServer(serverData:GetIp(), serverData:GetPort())
end
---@param serverData ServerInfo
function RankListTestVerifyDataManager:EnterGameServer()
    local serverData=self.CurServerData
    if serverData:GetRid()~=0 then
        local uid = self.Uid
        local pid = serverData:GetRid()
        local token = self.Token

        local data = CommonHelper:GetNetSendData({ pid, uid, token,"nil","2","" })
        NetManager:Get():Send(MsgID.ENTER_SERVER_C2S_REQ, data,true)
    else
        local uid = self.Uid
        local token = self.Token
        local umId = 0
        local chId = 0
        local data = CommonHelper:GetNetSendData({ 0, uid, token, "洋洋"..serverData:GetServerId().."2", 24000038,umId,chId })
        NetManager:Get():Send(MsgID.CREATE_ROLE_C2S_REQ, data)
    end
end
function RankListTestVerifyDataManager:LoginGetPartData(rid)

end

function RankListTestVerifyDataManager:LoginSpeedRankData()
    CommonSubsystem:Get().IsLoadRankData=true
    cs_coroutine.start(function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
        CommonSubsystem:Get().IsLoadRankData=true
        RankingListSubsystem:Get():SendMsg_RankingListInfo(RankingListType.Speed,0)
    end)

end

function RankListTestVerifyDataManager:LoginRlSpeedRankData()
    cs_coroutine.start(function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
        CommonSubsystem:Get().IsLoadRankData=true
        RankingListSubsystem:Get():SendMsg_RankingListInfo(RankingListType.RlSpeed,0)
    end)

end


function RankListTestVerifyDataManager:Done()
    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, function()
        self:Execute()

    end, true)
end
--}}}

--int falseRid = Integer.parseInt(uab.getP2());
--String type = uab.getP3();
--String realspeed = uab.getP4();
--String speed = uab.getP5();
--String realver = uab.getP6();
--String ver = uab.getP7();
--String serverid = uab.getP8();
--{season}Speed:1:101  {season}rlSpeed:1:101
--<Key="REQRUNFLASE" Type="Int" Value="906" ClassName=""  Explain="请求举报"/>
--<Key="RETRUNFLASE" Type="Int" Value="907" ClassName=""  Explain="返回举报"/>
--type  你发上面2个
--一个如龙 pvp 一个普通pvp
--testpveRank:101:copyid
--{top}ASpeed:101
--{top}BSpeed:101
--pveRank:101:copyid
--godpveRank:101:copyid

function RankListTestVerifyDataManager:SetRaplayData(lookid,typetable,rankSpeed,version,serverId)
    self.LookId=lookid
    self.Type=self:GetRecordType(typetable,serverId)
    self.RankSpeed=rankSpeed
    self.LookVersion=version
    self.LookServerId=serverId
    self.Recording=true
    self.ResultTime=0
    self.BattleError=BattleFailError.None
    self.BattleResult=""
end
function RankListTestVerifyDataManager:SetLookVersion(version)
    self.LookVersion=version
end

function RankListTestVerifyDataManager:GetRecordType(typetable,serverId)
    local result=""
    if typetable[1]==RankingListType.Speed then
        result="{season}Speed:"..typetable[2]..":".. serverId
    end
    if typetable[1]==RankingListType.RlSpeed then
        result="{season}rlSpeed:"..typetable[2]..":".. serverId
    end
    if typetable[1]==RankingListType.SpecialTraining then
        result="testpveRank:".. serverId..":"..typetable[2]
    end
    if typetable[1]==RankingListType.RaceTopA then
        result="{top}ASpeed:".. serverId
    end
    if typetable[1]==RankingListType.RaceTopSuperA then
        result="{top}2ASpeed:".. serverId
    end
    if typetable[1]==RankingListType.RaceTopB then
        result="{top}BSpeed:".. serverId
    end
 if typetable[1]==RankingListType.RaceTopSuperB then
        result="{top}2BSpeed:".. serverId
    end
    if typetable[1]==RankingListType.PveChapter then
        result="pveRank:".. serverId..":"..typetable[2]
    end
    if typetable[1]==RankingListType.RaceCarGod then
        result="godpveRank:".. serverId..":"..typetable[2]
    end
    if typetable[1]==RankingListType.RaceJCP then
        result="{jcup}Speed:"..typetable[2]
    end
    if typetable[1]==RankingListType.RaceXCP then
        result="{xup}Speed:"..typetable[2]
    end
    return result
end
--int falseRid = Integer.parseInt(uab.getP2());
--String type = uab.getP3();
--String realspeed = uab.getP4();
--String speed = uab.getP5();
--String realver = uab.getP6();
--String ver = uab.getP7();
--String serverid = uab.getP8();
function RankListTestVerifyDataManager:OnRecordDone(result)
    if self.Recording and result then
        local battleResult=nil

        for i = 0, result.Length - 1 do
            if result[i].pid == self.LookId then
                battleResult = result[i]
                self.BattleResult= self.BattleResult..string.format("%d---%d---%d---%d---%.2f---%.2f---%.2f :",result[i].pid,result[i].rank,result[i].time,result[i].error,result[i].averageSpeed,result[i].maxSpeed,result[i].minSpeed)
                break
            end
        end
        if battleResult then
            self.ResultTime=self.ResultTime+battleResult.time
            self.BattleError=battleResult.error
        else
            self.Recording=false
        end

    end
end
function RankListTestVerifyDataManager:CloseRecord(battleType)
    if (battleType==RaceModel.RaceClub3v3 and RaceClub3V3Manager:Get().Queue and RaceClub3V3Manager:Get().Queue:GetSize()>0) or
            (battleType==RaceModel.Battle  and PVEChapterDataManager:Get().Queue and PVEChapterDataManager:Get().Queue:GetSize()>0) or
            (battleType==RaceModel.RaceReplay_Pve  and PVEChapterDataManager:Get().Queue and PVEChapterDataManager:Get().Queue:GetSize()>0) or
            (battleType==RaceModel.RaceSeniorTrain  and RaceSeniorTrainManager:Get().Queue and RaceSeniorTrainManager:Get().Queue:GetSize()>0) or
            (battleType==RaceModel.RaceJcp  and RaceJcpManager:Get().Queue and RaceJcpManager:Get().Queue:GetSize()>0) or
            (battleType==RaceModel.RaceXcp  and RaceXCupManager:Get().Queue and RaceXCupManager:Get().Queue:GetSize()>0) or
            (battleType==RaceModel.RaceCarGod  and RaceCarGodDataManager:Get().Queue:GetSize()>0) then
       return
    end
    if self.Recording then
        if self.BattleError~=BattleFailError.None or self.ResultTime~=self.RankSpeed then
            CommonSubsystem:SendMsg_RunFalse(self.LookId,self.Type,self.ResultTime,self.RankSpeed,self.LookVersion,CommonHelper:GetClientVersion(),PlayerDataManager:Get():GetPlayerServerID(),self.BattleResult,999)
        end
        self.Recording=false
    end
end
function RankListTestVerifyDataManager:Report()
   CommonSubsystem:SendMsg_RunFalse(self.LookId,self.Type,self.ResultTime,self.RankSpeed,self.LookVersion,CommonHelper:GetClientVersion(),PlayerDataManager:Get():GetPlayerServerID(),self.BattleResult,999)
end






