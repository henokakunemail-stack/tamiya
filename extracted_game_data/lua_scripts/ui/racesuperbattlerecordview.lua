---@class RaceSuperBattleRecordView : ViewBase
RaceSuperBattleRecordView = class("RaceSuperBattleRecordView", ViewBase)

function RaceSuperBattleRecordView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSuperBattleRecordViewAction")
end

function RaceSuperBattleRecordView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("RaceSuperBattleRecordView")
    end)
    self.TogRank1= CommonHelper:HButtonSetCallback("TogRank1",self.gameObject,function (hbtn)
        self:TogClick(RaceSuperBattleRaceState.KnockoutStage-1)
    end)
    self.TogRank2=CommonHelper:HButtonSetCallback("TogRank2",self.gameObject,function (hbtn)
        self:TogClick(RaceSuperBattleRaceState.KnockoutStage)
    end)
    self.TogRank3=CommonHelper:HButtonSetCallback("TogRank3",self.gameObject,function (hbtn)
        self:TogClick(RaceSuperBattleRaceState.KnockoutStage+1)
    end)
    self.TittleScrollView = UIUtil.GetTypeChildWightByParent("TitleScrollView", self.gameObject, typeof(MoreRowScrollViewTittle))
    self.DropDownScrollView = UIUtil.GetTypeChildWightInputPath("DropDownScrollView", self.gameObject, typeof(UIDropDownScrollList))
end
local _CurSelectDays={}
local _DefaultDay=0
function RaceSuperBattleRecordView:TogClick(type)
   self:SetDropDownScrollView(type,true)
    if _DefaultDay==0 then
        RaceSuperBattleSubsystem:Get():SendMsg_RaceResult(self.LookId,_CurSelectDays[1].Stage)
    else
        if RaceSuperBattleManager:Get():IsReachResult(RaceSuperBattleManager:Get():GetData():GetRaceState()) then
            RaceSuperBattleSubsystem:Get():SendMsg_RaceResult(self.LookId,RaceSuperBattleManager:Get():GetData():GetMatchRankState())
        else
            local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictkillerstage_config)
            RaceSuperBattleSubsystem:Get():SendMsg_RaceResult(self.LookId,cfg.Get_RankingStage(RaceSuperBattleManager:Get():GetData():GetMatchAddDay()-1))
        end
    end
end
function RaceSuperBattleRecordView:SetTogState(type)
   CommonHelper:SetToggleState(self.TogRank1,type<RaceSuperBattleRaceState.KnockoutStage)
   CommonHelper:SetToggleState(self.TogRank2,type==RaceSuperBattleRaceState.KnockoutStage)
   CommonHelper:SetToggleState(self.TogRank3,type>RaceSuperBattleRaceState.KnockoutStage)
    CommonHelper:SetHButtonClick(self.TogRank2,RaceSuperBattleManager:Get():GetData():GetMatchRankState()>=RaceSuperBattleRaceState.KnockoutStage,true)
end

function RaceSuperBattleRecordView:SetDropDownScrollView(type,check)
    _CurSelectDays={}
    _DefaultDay=0
    local CurDay=0
    if RaceSuperBattleManager:Get():IsReachResult(RaceSuperBattleManager:Get():GetData():GetRaceState()) then
        CurDay=RaceSuperBattleManager:Get():GetData():GetMatchAddDay()
    else
        CurDay=RaceSuperBattleManager:Get():GetData():GetMatchAddDay()-1
    end
    self.KillerStageCfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictkillerstage_config)
    for k, v in pairs(self.KillerStageCfg.Get_RacSuperBattleStage()) do
        if type<RaceSuperBattleRaceState.KnockoutStage and v<RaceSuperBattleRaceState.KnockoutStage then
            table.insert(_CurSelectDays, {Day=k,Stage=v} )
        end
        if type==RaceSuperBattleRaceState.KnockoutStage and v==RaceSuperBattleRaceState.KnockoutStage then
            table.insert(_CurSelectDays, {Day=k,Stage=v} )
        end
        if type>RaceSuperBattleRaceState.KnockoutStage and v>RaceSuperBattleRaceState.KnockoutStage then
            table.insert(_CurSelectDays, {Day=k,Stage=v} )
        end
    end
    if check then
        for i = 1, #_CurSelectDays do
            if CurDay==_CurSelectDays[i].Day then
                _DefaultDay=i-1
                break
            end
        end
    else
        for i = 1, #_CurSelectDays do
            if self.LookRecordType==_CurSelectDays[i].Stage then
                _DefaultDay=i-1
                break
            end
        end
    end
    CommonHelper:SetGameObjectActive("DropDownScrollView",self.gameObject,#_CurSelectDays>1)
    if #_CurSelectDays>1 then
        if _DefaultDay<0 then
            _DefaultDay=0
        end
        CommonHelper:SetText("###currentgroup",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleRankingGroup,_CurSelectDays[_DefaultDay+1].Day))
        CommonHelper:InitDropDownScrollList(self.DropDownScrollView,#_CurSelectDays,function(uidrop,item,index)
            CommonHelper:SetText("###Text",item,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleRankingGroup,_CurSelectDays[index+1].Day))
        end,function(index)
            CommonHelper:SetText("###currentgroup",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleRankingGroup,_CurSelectDays[index+1].Day))
            RaceSuperBattleSubsystem:Get():SendMsg_RaceResult(self.LookId,_CurSelectDays[index+1].Stage)
        end)
    end
end
function RaceSuperBattleRecordView:OnOpen()

end

function RaceSuperBattleRecordView:SetData()
    self.ScrollData={}

    ---@type RaceSuperBattleMatchInfo[]
    self.Record=RaceSuperBattleManager:Get():GetRecord()
    self.LookId=RaceSuperBattleManager:Get():GetLookId()
    self.LookRecordType=RaceSuperBattleManager:Get():GetLookRecordType()
    if self.LookRecordType<RaceSuperBattleRaceState.KnockoutStage then
        self:SetTogState(RaceSuperBattleRaceState.KnockoutStage-1)
        self:SetDropDownScrollView(RaceSuperBattleRaceState.KnockoutStage-1,false)
    elseif self.LookRecordType==RaceSuperBattleRaceState.KnockoutStage then
        self:SetTogState(RaceSuperBattleRaceState.KnockoutStage)
        self:SetDropDownScrollView(RaceSuperBattleRaceState.KnockoutStage,false)
    elseif self.LookRecordType>RaceSuperBattleRaceState.KnockoutStage then
        self:SetTogState(RaceSuperBattleRaceState.KnockoutStage+1)
        self:SetDropDownScrollView(RaceSuperBattleRaceState.KnockoutStage+1,false)
    end
    for i = 1, #self.Record do
        local temp = MoreRowScrollViewTittleGroup()
        temp.tittle = i
        temp.totle = #self.Record[i].Racer1.Times
        temp.groupIndex = i
        temp.isFold=false
        table.insert(self.ScrollData, temp)
    end
    CommonHelper:MoreRowTitle_Init(self.TittleScrollView, self.ScrollData, 1,function(title, tittleIdx, itemObj, type ,dataIndex, scroll)
        if type==TittleItemType.Title then
            if self.Record[tittleIdx] then
                local Left=self:GetChildByParent("left",itemObj)
                local right=self:GetChildByParent("right",itemObj)

                ---@type RaceSuperBattleRacerInfo
                local selfData=nil
                ---@type RaceSuperBattleRacerInfo
                local otherData=nil
                if self.Record[tittleIdx].Racer1.Rid==self.LookId then
                    selfData=self.Record[tittleIdx].Racer1
                    otherData=self.Record[tittleIdx].Racer2
                else
                    otherData=self.Record[tittleIdx].Racer1
                    selfData=self.Record[tittleIdx].Racer2
                end
                CommonHelper:SetGameObjectActive("Fold",itemObj,selfData.Rid~=0 and otherData.Rid~=0)
                CommonHelper:SetText("###playerName", Left, selfData.Name)
                CommonHelper:SetText("###guildename",  Left, selfData.GuideName)
                --头像
                CommonHelper:SetPlayerIconById("PlayerIcon", Left, selfData.HeadIcon, selfData.IconFrame, nil, UIModuleID.RaceSuperBattleRecord)
                CommonHelper:SetGameObjectActive("win",Left,self.Record[tittleIdx].Winner==selfData.Rid)
                CommonHelper:SetGameObjectActive("lose",Left,self.Record[tittleIdx].Winner~=selfData.Rid and self.Record[tittleIdx].Winner~=0)
                if selfData.Rid==0 then
                    CommonHelper:SetText("###playerName", Left, CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleNameNull))
                    CommonHelper:SetText("###guildename",  Left, "")
                end

                CommonHelper:SetText("###playerName", right, otherData.Name)
                CommonHelper:SetText("###guildename",  right, otherData.GuideName)
                --头像
                CommonHelper:SetPlayerIconById("PlayerIcon", right, otherData.HeadIcon, otherData.IconFrame, nil, UIModuleID.RaceSuperBattleRecord)
                CommonHelper:SetGameObjectActive("win",right,self.Record[tittleIdx].Winner==otherData.Rid)
                CommonHelper:SetGameObjectActive("lose",right,self.Record[tittleIdx].Winner~=otherData.Rid and self.Record[tittleIdx].Winner~=0)
                if otherData.Rid==0 then
                    CommonHelper:SetText("###playerName", right, CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleNameNull))
                    CommonHelper:SetText("###guildename",  right, "")
                end

            end
        end
        if type == TittleItemType.Item then
            ---@type RaceSuperBattleRacerInfo
            local selfData=nil
            if self.Record[tittleIdx].Racer1.Rid==self.LookId then
                selfData=self.Record[tittleIdx].Racer1
            else
                selfData=self.Record[tittleIdx].Racer2
            end
            CommonHelper:SetText("###battlename", itemObj, CommonHelper:GetBattleTittleNameByName(dataIndex+1))
            local str=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleAudition)
            if type==RaceSuperBattleRaceState.KnockoutStage then
                str=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleKnockout)
            end
            CommonHelper:SetText("###state", itemObj, str)
            if selfData.Times[dataIndex+1]>-1 then
                CommonHelper:GetComponentTransferTime("###time",itemObj,selfData.Times[dataIndex+1])
            elseif selfData.Times[dataIndex+1]<=-1 then
                local result=CommonHelper:TransferTime(math.abs(selfData.Times[dataIndex+1]), 0.001)
                CommonHelper:SetText("###time", itemObj,"-".. CommonHelper:TransferTimeToString(result))
            else
                CommonHelper:SetText("###time",itemObj,"--:--:--")
            end
            CommonHelper:SetGameObjectActive("win",itemObj,selfData.Results[dataIndex+1])
            CommonHelper:SetGameObjectActive("lose",itemObj,not selfData.Results[dataIndex+1])

            CommonHelper:HButtonSetCallback("BtnRecord",itemObj,function (hbtn)
                RaceSuperBattleSubsystem:Get():SendMsg_RaceRecord(self.Record[hbtn.intData].MatchRank,self.Record[hbtn.intData].MatchId,tonumber(hbtn.stringData)+1)
            end,tittleIdx,tostring(dataIndex))
        end
    end)
end


function RaceSuperBattleRecordView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceSuperBattleRecord)
end

