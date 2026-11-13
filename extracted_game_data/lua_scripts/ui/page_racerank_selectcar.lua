function RaceRankView:SetMore(root)
    local MaxCar=3
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
            CommonHelper:SetGameObjectActive("normal_bg",item,true)
            CommonHelper:SetGameObjectActive("elite_bg",item,false)
            CommonHelper:SetGameObjectActive("boss_bg",item,false)
            --local name,icon = CommonHelper:AnalyseNPCNameAndIconById(BattleInfo[1].NpcIds[1])
            CommonHelper:GetComponentSetUITexture("npcicon",item,CommonHelper:GetPlayerIconById(PlayerDataManager:Get():GetPlayerIcon()),UIModuleID.SpecialTraining)
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

function RaceRankView:SetTogState(idx)
    self.CurSelectTrack=idx
    if self.Cars[self.CurSelectTrack].CarIdx~=0 then
        self.PreCarFive:SetState(self.Cars[self.CurSelectTrack].CarIdx,CarSelectStatus.Select)
    end
    for i = 1, #self.TogGroup do
        CommonHelper:SetToggleState(self.TogGroup[i],idx==i)
    end
end
function RaceRankView:GetCurTrackCar()
    return self.Cars[self.CurSelectTrack].CarIdx
end
function RaceRankView:SetCurCarState(carIdx,state)
    if self.Cars[self.CurSelectTrack]~=0 then
        self.PreCarFive:SetState(self.Cars[self.CurSelectTrack].CarIdx,CarSelectStatus.Normal)
    end
    self:SetCarState(self.CurSelectTrack,carIdx,state)
end
function RaceRankView:SelectFiveReOpen()
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
function RaceRankView:SetCarState(idx,carIdx,state)
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

