---@class Page_RaceSelfChapterSelectCar :Page_SelectCarBase
Page_RaceSelfChapterSelectCar=class("Page_RaceSelfChapterSelectCar",Page_SelectCarBase)
function Page_RaceSelfChapterSelectCar:initialize()

end
---@param page_selectCar Page_SelectCar
function Page_RaceSelfChapterSelectCar:SetData(root,param,page_selectCar)
    ---@type RaceSelfChapterData
    self.chapterData=param[1]
    ---@type dictactivitycopy_config_cell
    self.levelData=param[2]
    if self.levelData.BattleCars==nil then self.levelData.BattleCars=1 end
    local page_more=  CommonHelper:SetGameObjectActive("page_more",root,self.levelData.BattleCars>1 or #self.levelData.BattleInfoList>1)
    local page_one= CommonHelper:SetGameObjectActive("page_one",root,self.levelData.BattleCars<=1 and #self.levelData.BattleInfoList<=1)
    if self.levelData.BattleCars>1 or #self.levelData.BattleInfoList>1 then
        root=page_more
        self:SetMore(root, param, page_selectCar)
    else
        root=page_one
        self:SetOne(root, param, page_selectCar)
    end

    CommonHelper:HButtonSetCallback("BtnFight",root,function(data)
        if self.levelData.BattleCars>1 or #self.levelData.BattleInfoList>1 then
            local MaxCar=self.levelData.BattleCars
            if MaxCar==1 then
                MaxCar=#self.levelData.BattleInfoList
            end
            local flag=true
            for i = 1, MaxCar do
                if self.Cars[i].CarIdx>0 then
                    if CarDataManager:Get():CheckCarCompleteness(self.Cars[i].CarIdx) then
                    else
                        flag=false
                        break
                    end
                else
                    if CarDataManager:Get():GetCarNum()<MaxCar then
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarPleaseOpenCar))
                        return
                    end
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChapterMoreCarNoCar))
                    return
                end
            end
            if flag then
                local caridx=""
                for i = 1, MaxCar do
                    if i>=MaxCar then
                        caridx=caridx..self.Cars[i].CarIdx
                    else
                        caridx=caridx..self.Cars[i].CarIdx..":"
                    end
                end
                RaceSelfChapterDataManager:Get():SetCurLevel(self.levelData)
                RaceSelfChapterSubsystem:Get():SendMsg_SelfChapterBeginRace(self.levelData.C_ID,caridx)
            else

            end
        else
            local data = page_selectCar:GetCurCar()
            if data then
                if CarDataManager:Get():CheckCarCompleteness(data:GetID()) then
                    RaceSelfChapterDataManager:Get():SetCurLevel(self.levelData)
                    RaceSelfChapterSubsystem:Get():SendMsg_SelfChapterBeginRace(self.levelData.C_ID,data:GetID())
                end
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarInParkingLot))
            end
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


end
function Page_RaceSelfChapterSelectCar:SetOne(root,param,page_selectCar)
    local allLevels=self.chapterData.Cops
    CommonHelper:SetText("###rewardprogress",root,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterProgress,self.chapterData.CurLevel,#allLevels))
    CommonHelper:SetText("###fastplayername",root,self.chapterData.FinishPeople)
    CommonHelper:SetText("###fastplayertime",root,"")
    CommonHelper:SetText("###playertime",root,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterSubNum,self.chapterData.subCount))
    ---@type table<string,boolean>
    local showLevelNpc={}
    local  start=1
    local endIndex=4
    if self.chapterData.CurLevel>=5 then
        start=self.chapterData.CurLevel-3
        endIndex=self.chapterData.CurLevel
    end
    for i = start, endIndex do
        ---@type dictactivitycopy_config_cell
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictactivitycopy_config,allLevels[i].copyid)
        local npcs= stringSplitToNumber(cfg.npcid,':')
        table.insert(showLevelNpc,{allLevels[i].copyid,self.chapterData.CurLevel>i,i})
    end
    for i = 1, 4 do
        ---@type dictactivitycopy_config_cell
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictactivitycopy_config,showLevelNpc[i][1])
        local losergroup=UIUtil.GetChild("losergroup"..i,root)
        local text= CommonHelper:SetText("###loser1name",losergroup,CommonHelper:GetTempStr_Default(self.chapterData.cfg.mapname).."-"..showLevelNpc[i][3])
        CommonHelper:GetComponentSetUITexture("PlayerIcon50/icon",losergroup,cfg.levelicon,UIModuleID.SelectTeam)
        CommonHelper:SetGameObjectActive("line",losergroup, false)
        --if not showLevelNpc[i][2] then
        --    local Image=UIUtil.GetTypeChildWightInputPath("line",losergroup,typeof(Image))
        --    local width=UIUtil.GetTextWidth(text)
        --    UIUtil.ImageSetWidth(Image,width)
        --end
        local limititem=UIUtil.GetChild("limititem"..i,root)
        CommonHelper:SetGameObjectActive("lock",limititem, losergroup,not showLevelNpc[i][2])
        CommonHelper:SetGameObjectActive("unlock",limititem, showLevelNpc[i][2])

    end

    CommonHelper:SetText("###tili", root, tostring(self.levelData.paypower))
    local firstdown= CommonHelper:GetRewardByDictDownId(self.levelData.firstdown)
    local copydownids = stringSplitToNumber(self.levelData.copydowns,':')
    local ccpydowns={}
    for i = 1, #copydownids do
        table.insert(ccpydowns,CommonHelper:GetRewardByDictDownId(copydownids[i]))
    end
    ---@type table<number, table<number, RewardData>>
    local datalist = {}
    for i = 1, #firstdown do
        table.insert(datalist, { true, firstdown[i]})
    end
    for i = 1, #ccpydowns do
        for j = 1, #ccpydowns[i] do
            table.insert(datalist,{ false, ccpydowns[i][j]})
        end
    end
    local moreRowScrollView=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H",root,typeof(MoreRowScrollView))
    if datalist then
        local count=#datalist>=4 and #datalist or 4
        CommonHelper:InitMoreRowScrollView(moreRowScrollView,count,1,function(index, itemObj,scroll)
            local temp = datalist[index+1]
            if temp then
                local obj = UIUtil.GetChild("ItemCom_118", itemObj)
                local param = Param_ItemArticleParam()
                param.count = temp[2].num
                CommonHelper:SetItemComGroup(obj, UIModuleID.SelectTeam,temp[2].id,param,function(btnData)
                    CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.SelectTeam)
                end,temp[2].id)
                CommonHelper:SetGameObjectActive("ItemCom_118", itemObj, true)
                CommonHelper:SetGameObjectActive("first", itemObj, temp[1])
                CommonHelper:SetGameObjectActive("odd", itemObj, false)
            else
                CommonHelper:SetGameObjectActive("ItemCom_118", itemObj, false)
                CommonHelper:SetGameObjectActive("first", itemObj, false)
                CommonHelper:SetGameObjectActive("odd", itemObj, false)
            end
        end)
    end
end

function Page_RaceSelfChapterSelectCar:SetMore(root, param, page_selectCar)
    self.PreCarFive=page_selectCar
    local MaxCar=self.levelData.BattleCars
    if MaxCar==1 then
        MaxCar=#self.levelData.BattleInfoList
    end
    self.Cars={{CarIdx=0,State=CarSelectStatus.None},{CarIdx=0,State=CarSelectStatus.None},{CarIdx=0,State=CarSelectStatus.None},{CarIdx=0,State=CarSelectStatus.None},{CarIdx=0,State=CarSelectStatus.None}}
    self.TogGroup={}
    self.CarTogGroup={}
    self.SelectCarGroup={}
    self.NpcObjGroup={}
    for i = 1, 5 do
        local item=UIUtil.GetChild("NpcGroup"..i,root)
        CommonHelper:SetGameObjectActive("bgplayer",item,MaxCar>=i)
        CommonHelper:SetGameObjectActive("bgnull",item,MaxCar<i)
        if MaxCar>=i then
            self.NpcObjGroup[i]=item
            CommonHelper:SetGameObjectActive("normal_bg",item,self.levelData.copytype==1)
            CommonHelper:SetGameObjectActive("elite_bg",item,self.levelData.copytype==2)
            CommonHelper:SetGameObjectActive("boss_bg",item,self.levelData.copytype==3)
            CommonHelper:GetComponentSetUITexture("npcicon",item,CommonHelper:GetPlayerIconById(PlayerDataManager:Get():GetPlayerIcon()),UIModuleID.SelectTeam)
            self.TogGroup[i]=CommonHelper:HButtonSetCallback("Toggle",item,function(hbtn)
                if self.Cars[self.CurSelectTrack].CarIdx~=0 then
                    self.PreCarFive:SetState(self.Cars[self.CurSelectTrack].CarIdx,CarSelectStatus.Use)
                    self:SetCarState(self.CurSelectTrack,self.Cars[self.CurSelectTrack].CarIdx,CarSelectStatus.Use)
                end
                self:SetTogState(hbtn.intData)
            end,i)
            self.CarTogGroup[i]={}
            for j = 1, 5 do
                self.CarTogGroup[i][j]=CommonHelper:HButtonSetCallback("Pos"..j.."/open/BtnPos",item,function(hbtn)

                end,j)
            end
            self.SelectCarGroup[i]=CommonHelper:HButtonSetCallback("BtnSelect",item,function(hbtn)
                if self.Cars[hbtn.intData].CarIdx~=0 and self.Cars[hbtn.intData].State==CarSelectStatus.Use  then
                    if self.Cars[hbtn.intData].CarIdx~=0 then
                        if hbtn.intData==self.CurSelectTrack then
                            self.PreCarFive:SetState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Select)
                            self:SetCarState(hbtn.intData,self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Select)
                        else
                            self.PreCarFive:SetState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Normal)
                            self:SetCarState(hbtn.intData,0,CarSelectStatus.None)
                        end

                    end
                else
                    if self.Cars[hbtn.intData].CarIdx~=0 then
                        self.PreCarFive:SetState(self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Use)
                        self:SetCarState(hbtn.intData,self.Cars[hbtn.intData].CarIdx,CarSelectStatus.Use)
                    else
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChapterMoreCarNoOneCar))
                    end
                end
            end,i)
        end
    end
    self:SetTogState(1)
end

function Page_RaceSelfChapterSelectCar:SetTogState(idx)
    self.CurSelectTrack=idx
    if self.Cars[self.CurSelectTrack].CarIdx~=0 then
        self.PreCarFive:SetState(self.Cars[self.CurSelectTrack].CarIdx,CarSelectStatus.Select)
    end
    for i = 1, #self.TogGroup do
        CommonHelper:SetToggleState(self.TogGroup[i],idx==i)
    end
end
function Page_RaceSelfChapterSelectCar:GetCurTrackCar()
    if self.Cars and self.Cars[self.CurSelectTrack] then
        return self.Cars[self.CurSelectTrack].CarIdx
    end
end
function Page_RaceSelfChapterSelectCar:SetCurCarState(carIdx,state)
    if self.Cars[self.CurSelectTrack]~=0 then
        self.PreCarFive:SetState(self.Cars[self.CurSelectTrack].CarIdx,CarSelectStatus.Normal)
    end
    self:SetCarState(self.CurSelectTrack,carIdx,state)
end
function Page_RaceSelfChapterSelectCar:ReOpen()
    if self.Cars then
        local carIdx=0
        for i = 1, #self.Cars do
            if i~=self.CurSelectTrack then
                if self.Cars[i].CarIdx>0 then
                    carIdx=self.Cars[i].CarIdx
                    carIdx=i
                    self.PreCarFive:SetState(self.Cars[i].CarIdx,CarSelectStatus.Use)
                end
            end
        end
        self:SetTogState(self.CurSelectTrack)
    end
end
function Page_RaceSelfChapterSelectCar:SetCarState(idx,carIdx,state)
    self.Cars[idx].CarIdx=carIdx
    self.Cars[idx].State=state
    for i = 1, #self.NpcObjGroup do
        CommonHelper:SetGameObjectActive("carid",self.NpcObjGroup[i], self.Cars[i].CarIdx~=0)
        for j = 1, #self.CarTogGroup[i] do
            CommonHelper:SetToggleState(self.CarTogGroup[i][j],self.Cars[i].CarIdx==j and self.Cars[i].State==CarSelectStatus.Use)
            CommonHelper:SetGameObjectActive("Pos"..j,self.NpcObjGroup[i],self.Cars[i].CarIdx==j)
        end
    end
    for i = 1, #self.SelectCarGroup do
        CommonHelper:SetToggleState(self.SelectCarGroup[i],self.Cars[i].CarIdx~=0 and self.Cars[i].State==CarSelectStatus.Use)
    end
end


