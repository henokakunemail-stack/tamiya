---@class Page_ClubRaceSelfChapterSelectCar :Page_SelectCarBase
Page_ClubRaceSelfChapterSelectCar=class("Page_ClubRaceSelfChapterSelectCar",Page_SelectCarBase)
function Page_ClubRaceSelfChapterSelectCar:initialize()

end
---@param page_selectCar Page_SelectCar
function Page_ClubRaceSelfChapterSelectCar:SetData(root,param,page_selectCar)
    ---@type ClubRaceSelfChapterData
    self.chapterData=param[1]
    ---@type dictactivitycopy_config_cell
    self.levelData=param[2]
    CommonHelper:HButtonSetCallback("BtnFight",root,function(data)
        local data = page_selectCar:GetCurCar()
        if data then
            ClubRaceSelfChapterSubsystem:Get():SendMsg_SelfChapterBeginRace(self.chapterData.id,data:GetID())
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
        end
    end)
    CommonHelper:HButtonSetCallback("BtnRefit",root,function(data)
        local data = page_selectCar:GetCurCar()
        if data then
            SkipModuleHelper:Get():ToAssemble(SkipAssembleType.Map, data:GetID(), PartGrooveID.Shell, nil)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
        end
    end)
    local allLevels=stringSplitToNumber(self.chapterData.cfg.levelIds,',')
    CommonHelper:SetText("###rewardprogress",root,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterProgress,self.chapterData.level,#allLevels))
    CommonHelper:SetText("###fastplayername",root,self.chapterData.passNum)
    CommonHelper:SetText("###fastplayertime",root,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterJoinNum,self.chapterData.joinNum))
    CommonHelper:SetText("###playertime",root,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterSubNum,self.chapterData.subCount))
    ---@type table<string,boolean>
    local showLevelNpc={}
    local  start=1
    local endIndex=3
    if self.chapterData.level>=4 then
        start=self.chapterData.level-3
        endIndex=self.chapterData.level-1
    end
    for i = start, endIndex do
        ---@type guildselfchapterlevelinfo_config_cell
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.guildselfchapterlevelinfo_config,allLevels[i])
        local npcs= stringSplitToNumber(cfg.npcs,',')
        table.insert(showLevelNpc,{npcs[1],self.chapterData.level>i})
    end
    for i = 1, 3 do
        local name,icon= CommonHelper:AnalyseNPCNameAndIconById(showLevelNpc[i][1])
        local losergroup=UIUtil.GetChild("losergroup"..i,root)
        local text= CommonHelper:SetText("###loser1name",losergroup,name)
        CommonHelper:GetComponentSetUITexture("PlayerIcon50/icon",losergroup,icon,UIModuleID.SelectTeam)
        CommonHelper:SetGameObjectActive("line",losergroup, showLevelNpc[i][2])
        if not showLevelNpc[i][2] then
            local Image=UIUtil.GetTypeChildWightInputPath("line",losergroup,typeof(Image))
            local width=UIUtil.GetTextWidth(text)
            UIUtil.SetUIWidth(Image,width)
        end
        local limititem=UIUtil.GetChild("limititem"..i,root)
        CommonHelper:SetGameObjectActive("lock",limititem, losergroup,not showLevelNpc[i][2])
        CommonHelper:SetGameObjectActive("unlock",limititem, showLevelNpc[i][2])

    end


    local reward =CommonHelper:GetRewardByDropId(self.levelData.dropReward)
    local moreRowScrollView=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H",root,typeof(MoreRowScrollView))
    if reward then
        CommonHelper:InitMoreRowScrollView(moreRowScrollView,#reward,1,function(index, itemObj,scroll)
            CommonHelper:SetPropGroupByRewardData(itemObj,reward[index+1],UIModuleID.SelectTeam)
        end)
    end

end