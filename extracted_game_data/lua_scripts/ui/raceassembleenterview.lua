---@class RaceAssembleEnterView : ViewBase
RaceAssembleEnterView = class("RaceAssembleEnterView", ViewBase)

function RaceAssembleEnterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceAssembleEnterViewAction")

end
function RaceAssembleEnterView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(true)
    end)
    CommonHelper:HButtonSetCallback("BtnLook",self.gameObject,function(data)
        if RaceAssembleManager:Get():GetRank3List() and #RaceAssembleManager:Get():GetRank3List()>0 then
            RaceAssembleSubsystem:Get():SendMsg_Record(RaceAssembleManager:Get():GetMatchId(),RaceAssembleManager:Get():GetMatchBeginTime(),RaceAssembleManager:Get():GetRank3List()[1].rid)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMathNoLook))
        end
    end)
    CommonHelper:HButtonSetCallback("BtnRank",self.gameObject,function(data)
        if RaceAssembleManager:Get():GetRank3List() and #RaceAssembleManager:Get():GetRank3List()>0 then
            RaceAssembleSubsystem:Get():SendMsg_RankList(RaceAssembleManager:Get():GetMatchId())
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMathNoRankList))
        end
    end)
    self.BtnFight= CommonHelper:HButtonSetCallback("BtnFight",self.gameObject,function(data)
        if RaceAssembleManager:Get():GetCurBattleCount()>0 and data and RaceAssembleManager:Get():GetRaceEndTime() >CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) then
            if RaceAssembleManager:Get().CarDataManager[1] and RaceAssembleManager:Get().CarDataManager[1]:CheckCarCompleteness(true) then
                RaceAssembleSubsystem:Get():SendMsg_BeginBattle(RaceAssembleManager:Get():GetMatchId(),RaceAssembleManager:Get().CarDataManager[1]:GetID())
            end
        else
            if data==0 then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
            end
            if RaceAssembleManager:Get():GetCurBattleCount()<=0 then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceAssembleNoCount))
            end
            if RaceAssembleManager:Get():GetRaceEndTime()<CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceAssembleOverTime))
            end
        end
    end)
    self.BtnJoin= CommonHelper:HButtonSetCallback("BtnJoin",self.gameObject,function(data)

        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
        ---@type dictbattleaward_config_cell
        local cell=cfg.GetFirstDataByAwardID(RaceAssembleManager:Get():GetAwardId())
        local pay=stringSplitToNumber(cell.jackpottype,":")
        if PlayerDataManager:Get():CheckCurrencyEnough(pay[1],pay[2]) and RaceAssembleManager:Get():GetRaceEndTime()>CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())  then
            RaceAssembleSubsystem:Get():SendMsg_Join()
        else
            if RaceAssembleManager:Get():GetRaceEndTime()<CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())  then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceAssembleOverTime))
            end
        end
    end)
    CommonHelper:HButtonSetCallback("BtnRefit", self.gameObject, function(data)
        if not RaceAssembleManager:Get():GetCanJoin() then
            SkipModuleHelper:Get():ToAssembleGarageView(RaceAssembleManager:Get().CarDataManager[1],RaceAssembleManager:Get().Bag,AssembleGarageOpenType.RaceAssemble)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceAssembleNoJoin))
        end
    end)
    self.MoreRowScrollView_Rank=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Rank",self.gameObject,typeof(MoreRowScrollView))
    self.CarAttrRecommend=UIUtil.GetChild("carAttrRecommend",self.gameObject)
    self.items = {}
    for i = 1, 4 do
        self.items[i] = UIUtil.GetChild("SelfItem" .. i, self.gameObject)
    end
    self.PartsItem = { 4, 1, 2, 3 }
end

function RaceAssembleEnterView:OnOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
end

function RaceAssembleEnterView:ReOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    self:SetData()
end
function RaceAssembleEnterView:SetData()
    CommonHelper:SetHButtonClick(self.BtnJoin,RaceAssembleManager:Get():GetCanJoin(),true)
    CommonHelper:SetHButtonClick(self.BtnFight,not RaceAssembleManager:Get():GetCanJoin(),true)
    self:SetCar()
    self:SetTrackData()
    self:SetRankList()
    self:SetTimer()
    self:SetRewardAndCost()
    --self:SetCarAttrRecommend()
end
function RaceAssembleEnterView:SetRankList()

    local count=0
    local Rank3List=RaceAssembleManager:Get():GetRank3List()
    if Rank3List then
        count=#Rank3List>=3 and #Rank3List or 3
    else
        count=3
    end

    CommonHelper:InitMoreRowScrollView(self.MoreRowScrollView_Rank,count,1,function(index, itemObj,scroll)
        ---@type SC_rank3
        local temp=  nil
        if Rank3List then
            temp=Rank3List[index+1]
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
    if Rank3List and #Rank3List > 0 then
        local second=CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterDefaultTime)
        if tonumber(Rank3List[1].score)>0 then
            second = self:ParseTime(tonumber(Rank3List[1].score))
        end
        CommonHelper:SetGameObjectActive("fastplayericongroup/default", self.gameObject, false)
        CommonHelper:SetGameObjectActive("fastplayericongroup/icon", self.gameObject, true)
        CommonHelper:SetText("###fastplayername", self.gameObject, Rank3List[1].rolename)
        CommonHelper:SetText("###fastplayertime", self.gameObject, second)
        CommonHelper:SetPlayerIconById("fastplayericongroup", self.gameObject, tonumber(Rank3List[1].headicon),tonumber(Rank3List[1].iconframe),nil,UIModuleID.SelectTeam)
    else
        local second = self:ParseTime(0)
        CommonHelper:SetText("###fastplayername", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterNoPlayerPass))
        CommonHelper:SetText("###fastplayertime", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterDefaultTime))
        CommonHelper:SetGameObjectActive("fastplayericongroup/default", self.gameObject, true)
        CommonHelper:SetGameObjectActive("fastplayericongroup/icon", self.gameObject, false)
    end

end
function RaceAssembleEnterView:SetRewardAndCost()
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
    ---@type dictbattleaward_config_cell
    local cell=cfg.GetFirstDataByAwardID(RaceAssembleManager:Get():GetAwardId())
    local reward=  CommonHelper:SetDataByStrIdAndNum(cell.awardids,cell.awardnums)
    local pay=stringSplitToNumber(cell.jackpottype,":")
    CommonHelper:GetComponentSetImage("joinicon",self.gameObject,CommonHelper:GetCurrencyTypeImage(pay[1]),UIModuleID.SelectTeam)
    CommonHelper:SetText("###joinnum",self.gameObject,pay[2])
    local  challengeTime=CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchJoinTime,RaceAssembleManager:Get():GetCurBattleCount())
    CommonHelper:SetGameObjectActive("join",self.gameObject,RaceAssembleManager:Get():GetCanJoin())
    CommonHelper:SetGameObjectActive("joined",self.gameObject,not RaceAssembleManager:Get():GetCanJoin())
    CommonHelper:SetText("###passvalue",self.gameObject,challengeTime)
    local count=#reward>=4 and #reward or 4
    local MoreRowScrollView_H=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H",self.gameObject,typeof(MoreRowScrollView))
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
end

function RaceAssembleEnterView:StopTimer()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId=nil
    end
end
function RaceAssembleEnterView:SetTimer()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId=nil
    end
    self.RaceSubTime = RaceAssembleManager:Get():GetRaceFinishTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    self.TimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
        if self.RaceSubTime <= 0 then
            UIManager:Get():CloseView()
            TimerManager:Get():StopTimer(self.TimeId)
            self.TimeId=nil
            return
        end
        self:SetRaceTime()

    end, self)
end

function RaceAssembleEnterView:SetRaceTime()
    local day = math.modf(self.RaceSubTime / TimeSecond_Day)
    local hour = math.modf((self.RaceSubTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
    local minute = math.modf((self.RaceSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
    local second = self.RaceSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)
    self.RaceSubTime = self.RaceSubTime - 1

    if day >= 1 then
        CommonHelper:SetText("###opentime", self.gameObject,
                CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopOpenDayTime, day, hour, minute))
    else
        CommonHelper:SetText("###opentime", self.gameObject,
                CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopOpenTime, hour, minute, second))
    end
end
function RaceAssembleEnterView:ParseTime(milliSecond)
    local time=CommonHelper:GetSelfTransferTimeStr(milliSecond)
    local second=string.format("%s'%s'%s",time.minute,time.second,time.milliSecond)
    return second
end
function RaceAssembleEnterView:SetTrackData()
    self.TrackData = RaceAssembleManager:Get():GetTrackData()
    if self.TrackData then
        self.SceneId = RaceAssembleManager:Get():GetSceneID()
        CommonHelper:GetComponentSetTrackIconByData("trackicon", self.gameObject, self.TrackData, UIModuleID.RaceAssemble)
        CommonHelper:SetTrackFeatureByParent("trackfeature", self.gameObject, self.TrackData:GetFeature(), true)
        CommonHelper:SetGameObjectActive("trackfeature",self.gameObject,true)
        CommonHelper:SetGameObjectActive("BtnReview",self.gameObject,true)
        if self.SceneId ~= -1 then
            ---@type scene_config_cell
            local sceneCfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, self.SceneId)
            if sceneCfg then
                CommonHelper:GetComponentSetUITexture("chapterpic", self.gameObject, sceneCfg.icon, UIModuleID.RaceAssemble)
            end
        end
        CommonHelper:HButtonSetCallback("BtnReview", self.gameObject, function(data)
            if self.TrackData:GetIsField() then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
            else
                CommonHelper:LoadReviewTrack(nil, self.TrackData)
            end
        end)
    else
        CommonHelper:GetComponentSetUITexture("trackicon",self.gameObject,"uitex_sucai_default.png",UIModuleID.RaceAssemble)
        CommonHelper:SetGameObjectActive("trackfeature",self.gameObject,false)
        CommonHelper:SetGameObjectActive("BtnReview",self.gameObject,false)

    end

end
function RaceAssembleEnterView:OnAutoClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
    self:StopTimer()
end

function RaceAssembleEnterView:OnClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
    self:StopTimer()
end
--{{{设置车
function RaceAssembleEnterView:SetCar()
    cs_coroutine.start(function()
        coroutine.yield()
        coroutine.yield()
        HomeSceneCarMeshHelper:Get():SetDataByCarData(RaceAssembleManager:Get().CarDataManager[1], SceneChangeID.RefitTable, AnimateType.None)
    end)
    self:SetCarGroup(RaceAssembleManager:Get().CarDataManager[1])
end
---@param cardata CarData
function RaceAssembleEnterView:SetCarGroup(cardata)
    CommonHelper:SetGameObjectActive("nocarinfogroup",self.gameObject,cardata==nil)
    CommonHelper:SetGameObjectActive("carinfo",self.gameObject,cardata~=nil)
    if cardata then
        local partsList = cardata:GetPartDataList()
        for i = 1, 4 do
            ---@type parts_config_cell
            local parts = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partsList[self.PartsItem[i]].PartCfgID)
            CommonHelper:SetGameObjectActive("ItemPart_118",self.items[i],parts~=nil)
            CommonHelper:SetGameObjectActive("grooveopen",self.items[i],parts==nil)
            local grovveId= AssembleHelper:MsgIdxToGrooveID(self.PartsItem[i])
            local cfg= CommonHelper:GetTableDataByID(ConfigNames.grooveid_config,grovveId)
            CommonHelper:GetComponentSetUITexture("defaulticon",self.items[i],cfg.bgicon,UIModuleID.RaceAssemble)
            if parts then
                CommonHelper:SetItemPartGroup(self.items[i], UIModuleID.RaceAssemble, parts.C_ID)
            end
        end
    end

end
--}}}
function RaceAssembleEnterView:SetCarAttrRecommend()
    local partIdx={PartGrooveID.Motor,PartGrooveID.Gears}
    ---@type CarData
    local carData = RaceAssembleManager:Get().CarDataManager[1]
    if carData==nil then return end
    for i = 1, 2 do
        local item=UIUtil.GetChild("Item"..i,self.CarAttrRecommend)
        if carData.assembleMgr:GetNodeByGrooveID(partIdx[i]) and carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId~=0 then
            ---@type parts_config_cell
            local parts=CommonHelper:GetTableDataByID(ConfigNames.parts_config,carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId)
            if parts then
                local articleCell=carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).ArticleCell
                local param = Param_ItemPartParam()
                param.quality = articleCell:GetPartQuality()
                param.star = articleCell:GetStar()
                param.lv = articleCell:GetPartLV()
                param.using = articleCell:GetCarId()
                param.lock = articleCell:GetPartLock()
                param.awaken=articleCell:GetAwaken()
                param.generation=articleCell:GetGeneration()
                param.downType=articleCell:GetPartDownType()
                param.source = articleCell:GetPartSource()
                param.expireTime = articleCell:GetPartExpTime()
                CommonHelper:SetItemPartGroup(item,UIModuleID.SelectTeam,parts.C_ID,ItemPartUIType.Simple,param,function(id)
                    CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.SelectTeam)
                end,parts.C_ID)
            end
        end
        CommonHelper:SetGameObjectActive("ItemPart_118", item,carData.assembleMgr:GetNodeByGrooveID(partIdx[i])~=nil and carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId~=0)
    end
    local data= CarAttrRecommendManager:Get():GetDataByTrackId_MotorId_GearId(self.TrackId,carData.assembleMgr:GetNodeByGrooveID(partIdx[1]).PartId,carData.assembleMgr:GetNodeByGrooveID(partIdx[2]).PartId)
    for i = 1, 3 do
        CommonHelper:SetGameObjectActive("attr"..i,self.CarAttrRecommend,data~=nil)
    end
    CommonHelper:HButtonSetCallback("BtnCarAttrRecommend",self.CarAttrRecommend,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.CarAttrRecommend)
    end)
    if data~=nil then
        local selfStabilize=CommonHelper:FloatRound( carData:GetAttrValueById(CarAttrType.Stabilize).value/1000,100)
        local selfCushion= CommonHelper:FloatRound(carData:GetAttrValueById(CarAttrType.Cushion).value/1000,100)
        local selfDownforce=  CommonHelper:FloatRound(carData:GetAttrValueById(CarAttrType.Downforce).value/1000,100)
        CommonHelper:SetText("attr1/value",self.CarAttrRecommend,selfStabilize>=data.stabilizeMin and data.stabilizeMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.stabilizeMin))
        CommonHelper:SetText("attr2/value",self.CarAttrRecommend,selfCushion>=data.cushionMin and data.cushionMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.cushionMin))
        CommonHelper:SetText("attr3/value",self.CarAttrRecommend,selfDownforce>=data.downforceMin and data.downforceMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.downforceMin))
    end
    CommonHelper:SetGameObjectActive("nocarinfo",self.CarAttrRecommend,data==nil)
end
