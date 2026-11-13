---@class Page_RaceSelfLevelSelectCar :Page_SelectCarBase
Page_RaceSelfLevelSelectCar=class("Page_RaceSelfLevelSelectCar",Page_SelectCarBase)
function Page_RaceSelfLevelSelectCar:initialize()

end
local _SelectReward=nil
---@param page_selectCar SC_BattleInfo
function Page_RaceSelfLevelSelectCar:SetData(root,param,page_selectCar)
    ---@type SC_RetBattle
    self.LevelData = param
    ---@type SC_BattleInfo
    self.BattleInfo=param.battles[1]
    self.Root=root
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
    ---@type dictbattleaward_config_cell
    local cell=cfg.GetFirstDataByAwardID(tonumber(self.BattleInfo.awardid))
    self.BtnFight= CommonHelper:HButtonSetCallback("BtnFight",root,function(data)
        local data = page_selectCar:GetCurCar()
        if self.CurNum>0 and data and tonumber(self.BattleInfo.resulttime) >CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) then
            if CarDataManager:Get():CheckCarCompleteness(data:GetID()) then
                ChallengeMatchSubsystem:Get():SendMsg_BeginBattle(self.BattleInfo.createrid,data:GetID())
            end
        else
            if data==0 then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
            end
            if self.CurNum<=0 then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMathNoCount))
            end
            if tonumber(self.BattleInfo.resulttime)<CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchOverTime))
            end

        end
    end)
    self.BtnJoin= CommonHelper:HButtonSetCallback("BtnJoin",root,function(data)
        local pay=stringSplitToNumber(cell.jackpottype,":")
        if PlayerDataManager:Get():CheckCurrencyEnough(pay[1],pay[2]) and tonumber(self.BattleInfo.resulttime)>CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())  then
            ChallengeMatchSubsystem:Get():SendMsg_JoinBattle(self.BattleInfo.createrid,self.BattleInfo.awardid)
        else
            if tonumber(self.BattleInfo.resulttime)<CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())  then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchOverTime))
            end
        end
    end)
    self.isJoin=false
    local challengeTime=CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchNoJoin)
    if self.LevelData.records and #self.LevelData.records>0 then
        for i = 1, #self.LevelData.records do
            if self.BattleInfo.createrid == self.LevelData.records[i].battleid then
                self.isJoin=true
                self.CurNum=self.LevelData.records[i].curnum
                 challengeTime=CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchJoinTime,self.LevelData.records[i].curnum)
                break
            end
        end
    end
    CommonHelper:SetHButtonClick(self.BtnFight,self.isJoin,true)
    CommonHelper:SetHButtonClick(self.BtnJoin,not self.isJoin,true)
    CommonHelper:SetText("###passvalue",self.Root,challengeTime)
    CommonHelper:SetGameObjectActive("join",root,not self.isJoin)
    local pay=stringSplitToNumber(cell.jackpottype,":")
    CommonHelper:GetComponentSetImage("joinicon",root,CommonHelper:GetCurrencyTypeImage(pay[1]),UIModuleID.SelectTeam)
    CommonHelper:SetText("###joinnum",root,pay[2])
    CommonHelper:HButtonSetCallback("BtnRefit",root,function(data)
        local data = page_selectCar:GetCurCar()
        if data then
            SkipModuleHelper:Get():ToAssemble(SkipAssembleType.Map, data:GetID(), PartGrooveID.Shell, nil)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
        end
    end)
    CommonHelper:HButtonSetCallback("BtnLook",root,function(data)
        if self.BattleInfo.firstracer and #self.BattleInfo.firstracer >0 then
            ChallengeMatchSubsystem:Get():SendMsg_BattleHistory(self.BattleInfo.createrid,self.BattleInfo.createtime,self.BattleInfo.firstracer[1].rid)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMathNoLook))
        end
    end)
    CommonHelper:HButtonSetCallback("BtnRank",root,function(data)
        if self.BattleInfo.rank3list and #self.BattleInfo.rank3list>0 then
            ChallengeMatchSubsystem:Get():SendMsg_BattleRank(self.BattleInfo.createrid)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMathNoRankList))
        end
    end)
    if #self.BattleInfo.rank3list > 0 then
        local second=CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterDefaultTime)
        if tonumber(self.BattleInfo.rank3list[1].score)>0 then
            second = self:ParseTime(tonumber(self.BattleInfo.rank3list[1].score))
        end
        CommonHelper:SetGameObjectActive("fastplayericongroup/default", root, false)
        CommonHelper:SetGameObjectActive("fastplayericongroup/icon", root, true)
        CommonHelper:SetText("###fastplayername", root, self.BattleInfo.rank3list[1].rolename)
        CommonHelper:SetText("###fastplayertime", root, second)
        CommonHelper:SetPlayerIconById("fastplayericongroup", root, tonumber(self.BattleInfo.rank3list[1].headicon),tonumber(self.BattleInfo.rank3list[1].iconframe),nil,UIModuleID.SelectTeam)
    else
        local second = self:ParseTime(0)
        CommonHelper:SetText("###fastplayername", root, CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterNoPlayerPass))
        CommonHelper:SetText("###fastplayertime", root, CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterDefaultTime))
        CommonHelper:SetGameObjectActive("fastplayericongroup/default", root, true)
        CommonHelper:SetGameObjectActive("fastplayericongroup/icon", root, false)
    end


    local MoreRowScrollView_H=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H",self.Root,typeof(MoreRowScrollView))

    local reward=  CommonHelper:SetDataByStrIdAndNum(cell.awardids,cell.awardnums)
    local count=#reward>=4 and #reward or 4
    CommonHelper:InitMoreRowScrollView(MoreRowScrollView_H,count,1,function(index, itemObj,scroll)
        local temp = reward[index + 1]
        if temp then
            local reward = temp
            local obj = UIUtil.GetChild("ItemCom_118", itemObj)
            local param = Param_ItemArticleParam()
            param.count = reward.num
            CommonHelper:SetItemComGroup(obj, UIModuleID.SelectTeam,reward.id,param,function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.SelectTeam)
            end,reward.id)
            CommonHelper:SetGameObjectActive("ItemCom_118", itemObj, true)
            CommonHelper:SetGameObjectActive("first", itemObj, false)
            CommonHelper:SetGameObjectActive("odd", itemObj, false)
        else
            CommonHelper:SetGameObjectActive("ItemCom_118", itemObj, false)
            CommonHelper:SetGameObjectActive("first", itemObj, false)
            CommonHelper:SetGameObjectActive("odd", itemObj, false)
        end

    end)

    local MoreRowScrollView_Rank=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Rank",self.Root,typeof(MoreRowScrollView))
    local count=0
    if self.BattleInfo.rank3list then
        count=#self.BattleInfo.rank3list>=3 and #self.BattleInfo.rank3list or 3
    else
        count=3
    end

    CommonHelper:InitMoreRowScrollView(MoreRowScrollView_Rank,count,1,function(index, itemObj,scroll)
        ---@type SC_rank3
       local temp=  nil
        if self.BattleInfo.rank3list then
            temp=self.BattleInfo.rank3list[index+1]
        end
        if temp then
            CommonHelper:SetText("###rank",itemObj,CommonHelper:GetRankByNum(index+1))
            CommonHelper:SetText("###loser1name",itemObj,temp.rolename)
            local second=CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterDefaultTime)
            if tonumber(temp.score)>0 then
                second = self:ParseTime(tonumber(temp.score))
            end
            CommonHelper:SetText("###losertime",itemObj,second)

            CommonHelper:SetPlayerIconById("playericongroup", itemObj, tonumber(temp.headicon),tonumber(temp.iconframe),nil,UIModuleID.SelectTeam)
            CommonHelper:SetGameObjectActive("losergroup1",itemObj,true)
        else
            CommonHelper:SetGameObjectActive("losergroup1",itemObj,false)
        end
        CommonHelper:SetGameObjectActive("playericongroup/default", itemObj, false)
    end)
end
---@param msg SC_RetJoinBattle
function Page_RaceSelfLevelSelectCar:JoinSuccess(msg)
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfLevelJoinSuccess))
        self.isJoin=true
        self.CurNum=msg.records[1].curnum
        CommonHelper:SetHButtonClick(self.BtnFight,self.isJoin,true)
        CommonHelper:SetHButtonClick(self.BtnJoin,not self.isJoin,true)
end