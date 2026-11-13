---@class RaceSuperBattleListView : ViewBase
RaceSuperBattleListView = class("RaceSuperBattleListView", ViewBase)

function RaceSuperBattleListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSuperBattleListViewAction")
end

function RaceSuperBattleListView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceSuperBattle)
    end)
    CommonHelper:HButtonSetCallback("BtnGuess",self.gameObject,function (hbtn)
        local boxFunc = function()
            local articleName=CommonHelper:GetTempStr_Default(CommonHelper:GetTableDataByID(ConfigNames.article_config,RaceSuperBattleManager:Get():GetData():GetGuessType()).name)
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperGuessOkCancel,RaceSuperBattleManager:Get():GetData():GetGuessNum(),articleName,self.SelectPlayer.Name))
            if ret == MessageBoxHelp.BtnType.OK then
                RaceSuperBattleSubsystem:Get():SendMsg_Guess(RaceSuperBattleManager:Get():GetData():GetMatchRankState(),self.SelectPlayer.Rid)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("LevelMapScrollView",self.gameObject,typeof(LevelMapScrollView))
    self.MoreRowScrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_H",self.gameObject,typeof(MoreRowScrollView))
end

function RaceSuperBattleListView:OnOpen()

end


function RaceSuperBattleListView:OnClose()
    self:StopTimer()
    CommonHelper:ReleasePool(UIModuleID.RaceSuperBattleList)
end
function RaceSuperBattleListView:AutoClose()
    self:StopTimer()
end
local tileX=450
local tileY=195
local ItemPos={{0.2,1.6},{0.2,0.5},{0.2,-0.5},{0.2,-1.58},{1.5,1},{1.5,-1.1},{2.8,0},{3.8,0}}
function RaceSuperBattleListView:GetListData()
    local result = {}
    for i = 1, 8 do
        local temp = LevelMapScrollViewNode()
        temp.id = i
        temp.pos = self:GetVector2(ItemPos[i][1],ItemPos[i][2])
        temp.linePoints= {}
        table.insert(result, temp)
    end
    return result
end
function RaceSuperBattleListView:GetVector2(x,y)
    return Vector2(x*tileX,y*tileY)
end
function RaceSuperBattleListView:Refresh()
    CommonHelper:LevelMapView_Refresh(self.ScrollView,false)
    CommonHelper:SetGameObjectActive("BtnGuess",self.gameObject,RaceSuperBattleManager:Get():GetData():GetGuessType()~=0
            and RaceSuperBattleManager:Get():GetMyGuessByState(RaceSuperBattleManager:Get():GetData():GetMatchRankState())==0
            and self.self.MatchData[#self.MatchData] and RaceSuperBattleManager:Get():GetData():GetMatchRankState()==self.MatchData[#self.MatchData].MatchRank)
end
function RaceSuperBattleListView:SetData()
    ---@type RaceSuperBattleMatchInfo[]
    self.MatchData=RaceSuperBattleManager:Get():GetRecord()
    self:SetTimer()
    CommonHelper:SetGameObjectActive("BtnGuess",self.gameObject,RaceSuperBattleManager:Get():GetData():GetGuessType()~=0
            and RaceSuperBattleManager:Get():GetMyGuessByState(RaceSuperBattleManager:Get():GetData():GetMatchRankState())==0
            and self.MatchData[#self.MatchData] and  RaceSuperBattleManager:Get():GetData():GetMatchRankState()==self.MatchData[#self.MatchData].MatchRank)
    local  data=self:GetListData()
    CommonHelper:LevelMapView_Init(self.ScrollView, data,false, function(dataIndex, itemObj, scroll)
       local winner=CommonHelper:SetGameObjectActive("winner",itemObj,dataIndex==#data)
       local bgother=CommonHelper:SetGameObjectActive("bgother",itemObj,dataIndex~=#data)
       local bgself=CommonHelper:SetGameObjectActive("bgself",itemObj,dataIndex~=#data)
        CommonHelper:SetGameObjectActive("bgplayer",bgother,self.MatchData[dataIndex]~=nil)
        CommonHelper:SetGameObjectActive("bgplayer",bgself,self.MatchData[dataIndex]~=nil)
        CommonHelper:SetGameObjectActive("lose",bgother,self.MatchData[dataIndex]~=nil)
        CommonHelper:SetGameObjectActive("lose",bgself,self.MatchData[dataIndex]~=nil)
        CommonHelper:SetGameObjectActive("bgnull",bgother,self.MatchData[dataIndex]==nil)
        CommonHelper:SetGameObjectActive("bgnull",bgself,self.MatchData[dataIndex]==nil)
       local lineRacer=  CommonHelper:SetGameObjectActive("linerace",itemObj,dataIndex<RaceSuperBattleGroup.Group3)
       local line4=  CommonHelper:SetGameObjectActive("line4",itemObj,dataIndex<=RaceSuperBattleGroup.Group1)
       local line2=  CommonHelper:SetGameObjectActive("line2",itemObj,dataIndex>RaceSuperBattleGroup.Group1 and dataIndex<=RaceSuperBattleGroup.Group2 )
       local line1=  CommonHelper:SetGameObjectActive("line1",itemObj,dataIndex>RaceSuperBattleGroup.Group2 and dataIndex<=RaceSuperBattleGroup.Group3)
       CommonHelper:SetGameObjectActive("linerace/race1/off",itemObj,self.MatchData[dataIndex]==nil or self.MatchData[dataIndex]:GetWinnerInfo()==nil )
       CommonHelper:SetGameObjectActive("linerace/race1/open",itemObj,self.MatchData[dataIndex]~=nil and  self.MatchData[dataIndex]:GetWinnerInfo()~=nil )
       CommonHelper:SetGameObjectActive("linerace/race2/off",itemObj,self.MatchData[dataIndex]==nil or self.MatchData[dataIndex]:GetWinnerInfo()==nil )
       CommonHelper:SetGameObjectActive("linerace/race2/open",itemObj,self.MatchData[dataIndex]~=nil and  self.MatchData[dataIndex]:GetWinnerInfo()~=nil )
        CommonHelper:SetGameObjectActive("BtnLook",itemObj,self.MatchData[dataIndex]~=nil and self.MatchData[dataIndex]:GetWinnerInfo()~=nil and dataIndex~=#data)
        if dataIndex<=RaceSuperBattleGroup.Group1 then
            CommonHelper:SetGameObjectActive("top",line4,dataIndex%2==1 )
            CommonHelper:SetGameObjectActive("bottom",line4,dataIndex%2==0)
            CommonHelper:SetGameObjectActive("lian/off",line4,self.MatchData[dataIndex]==nil or self.MatchData[dataIndex]:GetWinnerInfo()==nil )
            CommonHelper:SetGameObjectActive("lian/open",line4,self.MatchData[dataIndex]~=nil and  self.MatchData[dataIndex]:GetWinnerInfo()~=nil )
            CommonHelper:SetGameObjectActive("top/off",line4,self.MatchData[dataIndex]==nil or self.MatchData[dataIndex]:GetWinnerInfo()==nil)
            CommonHelper:SetGameObjectActive("top/open",line4,self.MatchData[dataIndex]~=nil and  self.MatchData[dataIndex]:GetWinnerInfo()~=nil )
            CommonHelper:SetGameObjectActive("bottom/off",line4,self.MatchData[dataIndex]==nil or self.MatchData[dataIndex]:GetWinnerInfo()==nil)
            CommonHelper:SetGameObjectActive("bottom/open",line4,self.MatchData[dataIndex]~=nil and  self.MatchData[dataIndex]:GetWinnerInfo()~=nil )
        elseif dataIndex>RaceSuperBattleGroup.Group1 and dataIndex<=RaceSuperBattleGroup.Group2 then
            CommonHelper:SetGameObjectActive("top",line2,dataIndex%2==1 )
            CommonHelper:SetGameObjectActive("bottom",line2,dataIndex%2==0 )
            CommonHelper:SetGameObjectActive("lian/off",line2,self.MatchData[dataIndex]==nil or self.MatchData[dataIndex]:GetWinnerInfo()==nil)
            CommonHelper:SetGameObjectActive("lian/open",line2,self.MatchData[dataIndex]~=nil and  self.MatchData[dataIndex]:GetWinnerInfo()~=nil )
            CommonHelper:SetGameObjectActive("top/off",line2,self.MatchData[dataIndex]==nil or self.MatchData[dataIndex]:GetWinnerInfo()==nil)
            CommonHelper:SetGameObjectActive("top/open",line2,self.MatchData[dataIndex]~=nil and  self.MatchData[dataIndex]:GetWinnerInfo()~=nil )
            CommonHelper:SetGameObjectActive("bottom/off",line2,self.MatchData[dataIndex]==nil or self.MatchData[dataIndex]:GetWinnerInfo()==nil)
            CommonHelper:SetGameObjectActive("bottom/open",line2,self.MatchData[dataIndex]~=nil and  self.MatchData[dataIndex]:GetWinnerInfo()~=nil )
        elseif dataIndex>RaceSuperBattleGroup.Group2 and dataIndex<=RaceSuperBattleGroup.Group3 then
            CommonHelper:SetGameObjectActive("off",line1,self.MatchData[dataIndex]==nil or self.MatchData[dataIndex]:GetWinnerInfo()==nil)
            CommonHelper:SetGameObjectActive("open",line1,self.MatchData[dataIndex]~=nil and  self.MatchData[dataIndex]:GetWinnerInfo()~=nil )
        end

        if dataIndex==#data then
            CommonHelper:SetGameObjectActive("PlayerIcon148",winner,self.MatchData[dataIndex-1] and self.MatchData[dataIndex-1]:GetWinnerInfo()~=nil)
            if self.MatchData[dataIndex-1] and self.MatchData[dataIndex-1]:GetWinnerInfo() then
                CommonHelper:SetPlayerIconById("PlayerIcon148", winner, self.MatchData[dataIndex-1]:GetWinnerInfo().HeadIcon, self.MatchData[dataIndex-1]:GetWinnerInfo().IconFrame, nil, UIModuleID.RaceSuperBattleList)
            end
        else
            if self.MatchData[dataIndex]~=nil then
                CommonHelper:SetText("###name", bgother, self.MatchData[dataIndex].Racer1.Name)
                CommonHelper:SetText("###clubname",  bgother, self.MatchData[dataIndex].Racer1.GuideName)
                CommonHelper:SetPlayerIconById("PlayerIcon60", bgother, self.MatchData[dataIndex].Racer1.HeadIcon, self.MatchData[dataIndex].Racer1.IconFrame, nil, UIModuleID.RaceSuperBattleList)
                CommonHelper:SetText("###name", bgself, self.MatchData[dataIndex].Racer2.Name)
                CommonHelper:SetText("###clubname",  bgself, self.MatchData[dataIndex].Racer2.GuideName)
                --头像
                CommonHelper:SetPlayerIconById("PlayerIcon60", bgself, self.MatchData[dataIndex].Racer2.HeadIcon, self.MatchData[dataIndex].Racer2.IconFrame, nil, UIModuleID.RaceSuperBattleList)
                CommonHelper:SetGameObjectActive("select",bgother, self.SelectPlayer and self.SelectPlayer.Rid==self.MatchData[dataIndex].Racer1.Rid and  self.MatchData[dataIndex]:GetWinnerInfo()==nil )
                CommonHelper:SetGameObjectActive("select",bgself,self.SelectPlayer and self.SelectPlayer.Rid==self.MatchData[dataIndex].Racer2.Rid and  self.MatchData[dataIndex]:GetWinnerInfo()==nil )
                CommonHelper:SetGameObjectActive("guess",bgother,RaceSuperBattleManager:Get():GetMyGuessByState(self.MatchData[dataIndex].MatchRank)==self.MatchData[dataIndex].Racer1.Rid)
                CommonHelper:SetGameObjectActive("guess",bgself,RaceSuperBattleManager:Get():GetMyGuessByState(self.MatchData[dataIndex].MatchRank)==self.MatchData[dataIndex].Racer2.Rid)
                CommonHelper:HButtonSetCallback("BtnLook",itemObj,function(hbtn)
                    if self.MatchData[hbtn.intData] then
                        RaceSuperBattleSubsystem:Get():SendMsg_RaceRecord(self.MatchData[hbtn.intData].MatchRank,self.MatchData[hbtn.intData].MatchId,1)
                    end
                end,dataIndex)
                if self.MatchData[dataIndex]:GetWinnerInfo() then
                    CommonHelper:SetGameObjectActive("race1/open",lineRacer,self.MatchData[dataIndex].Winner==self.MatchData[dataIndex].Racer1.Rid)
                    CommonHelper:SetGameObjectActive("race1/off",lineRacer,self.MatchData[dataIndex].Winner~=self.MatchData[dataIndex].Racer1.Rid)
                    CommonHelper:SetGameObjectActive("race2/open",lineRacer,self.MatchData[dataIndex].Winner==self.MatchData[dataIndex].Racer2.Rid )
                    CommonHelper:SetGameObjectActive("race2/off",lineRacer,self.MatchData[dataIndex].Winner~=self.MatchData[dataIndex].Racer2.Rid )
                    CommonHelper:SetGameObjectActive("lose",bgother,self.MatchData[dataIndex].Winner~=self.MatchData[dataIndex].Racer1.Rid )
                    CommonHelper:SetGameObjectActive("lose",bgself,self.MatchData[dataIndex].Winner~=self.MatchData[dataIndex].Racer2.Rid )
                    --CommonHelper:SetGameObjectActive("top/open",line4,self.MatchData[dataIndex]:GetWinnerInfo()~=nil)
                    --CommonHelper:SetGameObjectActive("top/off",line4,self.MatchData[dataIndex]:GetWinnerInfo()==nil)
                    --CommonHelper:SetGameObjectActive("bottom/open",line4,self.MatchData[dataIndex]:GetWinnerInfo()~=nil)
                    --CommonHelper:SetGameObjectActive("bottom/off",line4,self.MatchData[dataIndex]:GetWinnerInfo()==nil)
                    --CommonHelper:SetGameObjectActive("top/open",line2,self.MatchData[dataIndex]:GetWinnerInfo()~=nil)
                    --CommonHelper:SetGameObjectActive("top/off",line2,self.MatchData[dataIndex]:GetWinnerInfo()==nil)
                    --CommonHelper:SetGameObjectActive("bottom/open",line2,self.MatchData[dataIndex]:GetWinnerInfo()~=nil)
                    --CommonHelper:SetGameObjectActive("bottom/off",line2,self.MatchData[dataIndex]:GetWinnerInfo()==nil)
                    --CommonHelper:SetGameObjectActive("lian/open",line4,true)
                    --CommonHelper:SetGameObjectActive("lian/open",line2,true)
                    --CommonHelper:SetGameObjectActive("open",line1,true )
                else
                    CommonHelper:SetGameObjectActive("lose",bgother,false )
                    CommonHelper:SetGameObjectActive("lose",bgself,false )
                end
                CommonHelper:HButtonSetCallback("ItemBtn1",itemObj,function(hbtn)
                    if self.MatchData[hbtn.intData] and self.MatchData[hbtn.intData]:GetWinnerInfo()==nil then
                        self.SelectPlayer=self.MatchData[hbtn.intData].Racer1
                        CommonHelper:LevelMapView_Refresh(self.ScrollView,false)
                    end
                end,dataIndex)
                CommonHelper:HButtonSetCallback("ItemBtn2",itemObj,function(hbtn)
                    if self.MatchData[hbtn.intData] and self.MatchData[hbtn.intData]:GetWinnerInfo()==nil then
                      self.SelectPlayer=self.MatchData[hbtn.intData].Racer2
                        CommonHelper:LevelMapView_Refresh(self.ScrollView,false)
                    end
                end,dataIndex)
            end
        end

    end)
    self.LookGroup= RaceSuperBattleManager:Get():GetLookGroup()
    CommonHelper:InitMoreRowScrollView(self.MoreRowScrollView,9,1,function(index, itemObj,scroll)
          local Tog= CommonHelper:HButtonSetCallback("Toggle",itemObj,function(hbtn)
              if hbtn.intData+1==self.LookGroup then
                  return
              end
              RaceSuperBattleSubsystem:SendMsg_RaceSuperBattle64Rank(hbtn.intData+1)
          end,index)
          CommonHelper:SetToggleState(Tog,self.LookGroup==index+1)
          CommonHelper:SetGameObjectActive("self",itemObj,index+1==RaceSuperBattleManager:Get():GetMyGroup())
          CommonHelper:SetText("normal/###name", itemObj, CommonHelper:GetSuperBattleGroupName(index+1))
          CommonHelper:SetText("hover/###name", itemObj, CommonHelper:GetSuperBattleGroupName(index+1))
    end)
end
--{{{  设置时间
function RaceSuperBattleListView:StopTimer()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
end
function RaceSuperBattleListView:SetTimer()
    self:StopTimer()
    local RaceData=RaceSuperBattleManager:Get():GetData()
    self.RaceSubTime = RaceData:GetRaceEndTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    self.StateSubTime = RaceData:GetStageEndTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    if self.StateSubTime<=0 then return end
    self:SetRaceTime()
    self:SetStateTime()
    self.TimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
        if self.RaceSubTime <= 0 then
            self:StopTimer()
        end
        self:SetRaceTime()
        self:SetStateTime()

    end, self)
end

function RaceSuperBattleListView:SetRaceTime()
    local day = math.modf(self.RaceSubTime / TimeSecond_Day)
    local hour = math.modf((self.RaceSubTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
    local minute = math.modf((self.RaceSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
    local second = self.RaceSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)
    self.RaceSubTime = self.RaceSubTime - 1

    --if day >= 1 then
    --    CommonHelper:SetText("###opentime", self.gameObject,
    --            CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopOpenDayTime, day, hour, minute))
    --else
    --    CommonHelper:SetText("###opentime", self.gameObject,
    --            CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopOpenTime, hour, minute, second))
    --end
end
function RaceSuperBattleListView:SetStateTime()
    local day = math.modf(self.StateSubTime / TimeSecond_Day)
    local hour = math.modf((self.StateSubTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
    local minute = math.modf((self.StateSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
    local second = self.StateSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)
    self.StateSubTime = self.StateSubTime - 1
    if self.StateSubTime<=0 then
        cs_coroutine.start(function()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
            RaceSuperBattleSubsystem:Get():SendMsg_EnterRaceSuperBattle(true)
        end)
    end
    --local time=""
    --if day >= 1 then
    --    time=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGTimeDay, day, hour, minute)
    --else
    --    time=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGTimeHour, hour, minute, second)
    --end
    --local objName=""
    --if RaceSuperBattleManager:Get():IsTrackReviewState(self.Data:GetRaceState()) and not self.Data:GetIsFail() and not self.Data:OffSeason() and not self.Data:IsUpKnockout()  and RaceSuperBattleManager:Get():GetIsSign() then
    --    objName="###subtime"
    --else
    --    objName="###racestatetime"
    --end
    --if RaceSuperBattleManager:Get():IsTrackReviewState(self.Data:GetRaceState()) and not self.Data:GetIsFail() and not self.Data:OffSeason() and not self.Data:IsUpKnockout() then
    --    if day >= 1 then
    --        CommonHelper:SetText(objName, self.gameObject,
    --                CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleSelectSubTime,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, day, hour, minute)))
    --    else
    --        CommonHelper:SetText(objName, self.gameObject,
    --                CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleSelectSubTime,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, hour, minute, second)))
    --    end
    --else
    --    if day >= 1 then
    --        CommonHelper:SetText(objName, self.gameObject,
    --                CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleStateSubTime,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, day, hour, minute)))
    --    else
    --        CommonHelper:SetText(objName, self.gameObject,
    --                CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleStateSubTime,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, hour, minute, second)))
    --    end
    --end
end
--}}}
