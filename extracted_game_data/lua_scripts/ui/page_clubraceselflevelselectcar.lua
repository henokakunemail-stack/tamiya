---@class Page_ClubRaceSelfLevelSelectCar :Page_SelectCarBase
Page_ClubRaceSelfLevelSelectCar=class("Page_ClubRaceSelfLevelSelectCar",Page_SelectCarBase)
function Page_ClubRaceSelfLevelSelectCar:initialize()

end
local _SelectReward=nil
---@param page_selectCar Page_SelectCar
function Page_ClubRaceSelfLevelSelectCar:SetData(root,param,page_selectCar)
    ---@type SC_RetBattle
    self.LevelData = param
    self.Root=root
    ClubRaceSelfLevelDataManager:Get():SetLevelData(self.LevelData)
    self.BtnFight= CommonHelper:HButtonSetCallback("BtnFight",root,function(data)
        local data = page_selectCar:GetCurCar()
        if data then
            ClubRaceSelfLevelSubsystem:Get():SendMsg_SelfLevelBeginRace(self.LevelData.id,data:GetID())
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
        end
    end)
    self.BtnJoin= CommonHelper:HButtonSetCallback("BtnJoin",root,function(data)
        local boxfunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Pink,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfLevelMessageText,100),CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfLevelMessageTittle),CommonHelper:GetTempStr_Default(TemplateStringID.OK),CommonHelper:GetTempStr_Default(TemplateStringID.Cancel),true)
            if ret == MessageBoxHelp.BtnType.OK then
                ClubRaceSelfLevelSubsystem:Get():SendMsg_SelfLevelJoin(self.LevelData.id)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end)
    CommonHelper:SetHButtonClick(self.BtnFight,self.LevelData.isJoin,true)
    CommonHelper:SetHButtonClick(self.BtnJoin,not self.LevelData.isJoin,true)
    CommonHelper:HButtonSetCallback("BtnRefit",root,function(data)
        local data = page_selectCar:GetCurCar()
        if data then
            SkipModuleHelper:Get():ToAssemble(SkipAssembleType.Map, data:GetID(), PartGrooveID.Shell, nil)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
        end
    end)
    self.Tog1= CommonHelper:HButtonSetCallback("Tog1",root,function(data)
        _SelectReward=1
        self:UpdateTog()
    end)
    self.Tog2=CommonHelper:HButtonSetCallback("Tog2",root,function(data)
        _SelectReward=2
        self:UpdateTog()
    end)
    self.Tog3=CommonHelper:HButtonSetCallback("Tog3",root,function(data)
        _SelectReward=3
        self:UpdateTog()
    end)
    _SelectReward=1
    self:UpdateTog()

    CommonHelper:SetText("###playerranking",root,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfLevelRank,self.LevelData.Rank))
    if #self.LevelData.PlayRankInfo>0 then
        CommonHelper:SetText("###fastplayername",root,self.LevelData.PlayRankInfo[1].name)
        local second=self:ParseTime(self.LevelData.PlayRankInfo[1].time)
        CommonHelper:SetText("###fastplayertime",root,second)
    end
    local second=self:ParseTime(self.LevelData.Time)
    CommonHelper:SetText("###playertime",root,second)

    for i = 1, 3 do
        local playerInfo=self.LevelData.PlayRankInfo[i]
        local playergroup=UIUtil.GetChild("playergroup"..i,root)
        if playerInfo then
            CommonHelper:SetText("###playername",playergroup,playerInfo.name)
            local second=self:ParseTime(playerInfo.time)
            if playerInfo.pid==PlayerDataManager:Get():GetPlayerRID() then
                CommonHelper:SetText("###fastplayertimeother",playergroup,"")
                CommonHelper:SetText("###fastplayertimeself",playergroup,second)
                CommonHelper:SetGameObjectActive("currank"..i,root,true)
            else
                CommonHelper:SetText("###fastplayertimeother",playergroup,second)
                CommonHelper:SetText("###fastplayertimeself",playergroup,"")
                CommonHelper:SetGameObjectActive("currank"..i,root,false)
            end
        else
            CommonHelper:SetText("###playername",playergroup,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfLevelNoRank))
            CommonHelper:SetText("###fastplayertimeother",playergroup,"")
            CommonHelper:SetText("###fastplayertimeself",playergroup,"")
            CommonHelper:SetGameObjectActive("currank"..i,root,false)
        end
    end


end
function Page_ClubRaceSelfLevelSelectCar:UpdateTog()
    CommonHelper:SetToggleState(self.Tog1,_SelectReward==1)
    CommonHelper:SetToggleState(self.Tog2,_SelectReward==2)
    CommonHelper:SetToggleState(self.Tog3,_SelectReward==3)
    ---@type guildselflevelreward_config_cell
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.selflevelreward_config,self.LevelData.NpcId)
    local reward=nil
    if _SelectReward==1 then
        reward= CommonHelper:GetRewardByDropId(cfg.reward1)
    end
    if _SelectReward==2 then
        reward= CommonHelper:GetRewardByDropId(cfg.reward2)
    end
    if _SelectReward==3 then
        reward= CommonHelper:GetRewardByDropId(cfg.reward3)
    end
    local moreRowScrollView=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H",self.Root,typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(moreRowScrollView,#reward,1,function(index, itemObj,scroll)
        CommonHelper:SetPropGroupByRewardData(itemObj,reward[index+1],UIModuleID.SelectTeam)
    end)

end
function Page_ClubRaceSelfLevelSelectCar:JoinSuccess(result)
    if result==0 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfLevelJoinSuccess))
        self.LevelData.isJoin=true
        CommonHelper:SetHButtonClick(self.BtnFight,self.LevelData.isJoin,true)
        CommonHelper:SetHButtonClick(self.BtnJoin,not self.LevelData.isJoin,true)
    end

end