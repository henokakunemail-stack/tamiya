---@class PVEChapterBoxData
PVEChapterBoxData = class("PVEChapterBoxData")
function PVEChapterBoxData:initialize(node)
    self.star = node[1]
    ---@type table<number, RewardData>
    self.rewards = CommonHelper:GetRewardByDictDownId(node[2])
    self.state = LevelBoxState.CanNotReceive
end
---@class PVEChapterRankData
PVEChapterRankData = class("PVEChapterRankData")
---@param node SC_FastCopyInfo
function PVEChapterRankData:initialize(node)
    self.pid = node.rid
    self.name = node.name
    self.icon = node.icon
    self.playerLevel = node.curleves[1]
    self.IconFrame=node.iconframe
    self.bgId=node.titleback
    self.cups=stringSplitToNumber(node.titlecup,":")
    self.times={}
    if node.times and #node.times>0 then
        self.times =node.times
    else
       table.insert(self.times,node.time)
    end
    self.StarTimes=node.powerstarts
    self.chapterId=node.chapterid
    self.levelId=node.copyid
    self.recordAtt = node.attr
    self.recordPart = node.partrec
    self.Seeds={}
    if node.seeds and #node.seeds>0 then
        self.Seeds =node.seeds
    else
        table.insert(self.Seeds,node.seed)
    end
    self.Stops=node.stops
    self.CarList={}
    if CommonHelper:IsNullOrEmpty(self.recordPart) or CommonHelper:IsNullOrEmpty(self.recordAtt) then
        if node.attrs and #node.attrs > 0 and node.partrecs and #node.partrecs>0 then
            for i = 1, #node.attrs do
               local  temp=CarReviewData()
                temp:SetDataByJson(node.attrs[i],node.partrecs[i],self.pid)
                table.insert(self.CarList,temp)
            end
        end
    else
        local  temp=CarReviewData()
        temp:SetDataByJson(self.recordAtt,self.recordPart,self.pid)
        table.insert(self.CarList,temp)
    end

end



---@class PVEChapterData
PVEChapterData = class("PVEChapterData")

function PVEChapterData:initialize()
    self.id = 0
    self.chapterId=0
    ---@type table<number,PVELevelData>
    self.levels={}
    self.name=""
    self.idx=""
    self.chapterDesc=""
    self.chapterIcon=""
    self.isLock=true
    self.process=0
    self.BoxState={}
    ---@type table<number,PVEChapterBoxData>
    self.BoxData={}
    self.BoxSlider = 0
    self.PropId=0
    self.ChapterTabType=""
end

---@param param table<number,mapnode_config_cell>
function PVEChapterData:SetData(chapterId,param,type)
    self.id = chapterId
    self.chapterId=chapterId
    self.chapterType=type
    for k,v in pairs(param) do
        local level=PVELevelData()
        level:SetData(v,self.chapterType)
        table.insert(self.levels,level)
    end
    table.sort(self.levels,function(a, b)
        return a.id<b.id
    end)
    local cfg=nil
    local reward=nil
    if self.chapterType==PveType.Chapter then
        ---@type dcitchapter_config_cell
         cfg= CommonHelper:GetTableDataByID(ConfigNames.dictchapter_config,self.id)
         reward= CommonHelper:GetTableDataByID(ConfigNames.dictsectionaward_config,self.id)
    end
    if self.chapterType==PveType.NewBie then
        ---@type dcitchapter_config_cell
         cfg= CommonHelper:GetTableDataByID(ConfigNames.dictchapter_config,self.id)
         reward= CommonHelper:GetTableDataByID(ConfigNames.dictsectionaward_config,self.id)
    end
    if self.chapterType==PveType.RaceSeniorTrain then
        ---@type dicthidechapter_config_cell
         cfg= CommonHelper:GetTableDataByID(ConfigNames.dicthidechapter_config,self.id)
         reward= CommonHelper:GetTableDataByID(ConfigNames.dictsectionaward_config,self.id)
         self.PartList=stringSplitToNumber(cfg.recommendicon,":")
         self.ChapterTabType=cfg.tebname
         self.ChapterHide=cfg.hide
    end

    self.name=CommonHelper:GetTempStr_Default(cfg.mapname)
    self.idx=CommonHelper:GetTempStr_Default(cfg.mapidx)

    if reward then
        self.starNums=stringSplitToNumber(reward.starsum,':')
        local rewards=stringSplit(reward.dropid,':')
        for i = 1, #self.starNums do
            self.BoxData[i]=PVEChapterBoxData({self.starNums[i], rewards[i]})
        end
    end

    self.MaxStar=cfg.sumstar
    self.BoxSlider = {}
    if self.starNums then
        for i = 1, #self.starNums do
            local num=math.modf((self.starNums[i]/self.MaxStar)*100)
            table.insert(self.BoxSlider,num*0.01)
        end
    end
    self.chapterIcon=cfg.mapicon
    self.PropId=cfg.prop
    self.lock=true
    self.process=0
    self.star=0
    self.PassRate=0
end
function PVEChapterData:SetLock(lock)
    self.lock = lock
end

function PVEChapterData:SetProcess(value)
    self.process = value
end

---@param value number[]
function PVEChapterData:SetAllBoxState(value)

    local count=#self.BoxData
    for i = 1,count  do
        if self.process>=self.BoxData[i].star then
            self.BoxData[i].state =LevelBoxState.CanReceive
        end
        local flag=false
        for j = 1, #value do
            if self.BoxData[i].star==value[j] then
                flag=true
                break
            end
        end
        if flag then
            self.BoxData[i].state=LevelBoxState.ReceiveCompleted
        else
            self.BoxData[i].state=self.BoxData[i].state
        end
    end
end
local tileX=400
local tileY=280
function PVEChapterData:CreateTestLevelMapData()
    local result = {}
    for i = 1, #self.levels do
        local temp = LevelMapScrollViewNode()
        temp.id = self.levels[i].id
        temp.pos = self:GetVector2(self.levels[i].mapPositionsX,self.levels[i].mapPositionsY)
        local  linePoints ={}
        for j = 1, #self.levels[i].inputLevel do
            local tempLinePos={}
            local inputLevel=self:GetLevelDataById(self.levels[i].inputLevel[j])
            if inputLevel then
                table.insert(tempLinePos,self:GetVector2(inputLevel.mapPositionsX,inputLevel.mapPositionsY))
                if self.levels[i].temppos then
                    local inputLeveltemps = self.levels[i].temppos[inputLevel.id]
                    if inputLeveltemps then
                        for k = 1, #inputLeveltemps do
                            table.insert(tempLinePos,self:GetVector2(inputLeveltemps[k][1],inputLeveltemps[k][2]))
                        end
                    end
                end
                table.insert(linePoints,tempLinePos)
            end
        end
        temp.linePoints=linePoints
        table.insert(result, temp)
    end
    return result
end
function PVEChapterData:GetVector2(x,y)
    return Vector2(x*tileX,y*tileY)
end
---@return PVELevelData
function PVEChapterData:GetLevelDataById(id)
    for i = 1, #self.levels do
        if id==self.levels[i].id then
            return self.levels[i]
        end
    end
    return nil
end

---@class PVELevelData
PVELevelData=class("PVELevelData")
function PVELevelData:initialize()
    self.id = 0
    self.chapterId=0
    self.name=""
    self.mapPositions={}
    self.inputLevel={}
    self.outLevel={}
    self.isLock=true
    self.star="000"
    self.OpenStar=0
    self.OpenPass=0
    self.starNum=0
    self.count=0
    self.starParam={}
    self.star2Param=""
    self.star3Param=""
    self.OpenOther=""
    self.temppos=""
    ---@type dictcopy_config_cell
    self.levelCfg=nil
    self.personRecord=0
    self.StoryGroup = {}
    ---@type table<number,PVEChapterRankData>
    self.PveRankData=nil
    self.winSum=0
    self.MaxStar=0
end



---@param data mapnode_config_cell
function  PVELevelData:SetData(data,chapterType)
    self.id = data.C_ID
    self.chapterId=data.chapterid
    self.chapterType=chapterType
    if GameProperties.isEnableFreeModel then
        self.levelCfg=CommonHelper:GetTableDataByID(ConfigNames.pvelevelfield_config,self.id)
    else
        if self.chapterType==PveType.Chapter then
            ---@type dictcopy_config_cell
            self.levelCfg=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,self.id)
        end
        if self.chapterType==PveType.NewBie then
            ---@type dictcopy_config_cell
            self.levelCfg=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,self.id)
        end
        if self.chapterType==PveType.RaceSeniorTrain then
            ---@type dicthidecopy_config_cell
            self.levelCfg=CommonHelper:GetTableDataByID(ConfigNames.dicthidecopy_config,self.id)
        end

    end

    self.name=CommonHelper:GetTempStr_Default(self.levelCfg.name)
    ---@type dictasset_config_cell
    local starPara=CommonHelper:GetTableDataByID(ConfigNames.dictasset_config,self.id)

    if starPara then
         self:GetPassStarParam(starPara.cond1,starPara.succval1,1)
         self:GetPassStarParam(starPara.cond2,starPara.succval2,2)
         self:GetPassStarParam(starPara.cond3,starPara.succval3,3)
    end
    if self:GetBattleInfo() and self.starParam[1] then
        self.MaxStar=#self:GetBattleInfo()*#self.starParam[1]
    end
    --self.MaxStar=3
    self.StoryGroup=stringSplitToNumber(self.levelCfg.storygroup,':')
    local pos=stringSplitToNumber(data.pos,',')
    self.mapPositionsX=pos[1]
    self.mapPositionsY=pos[2]
    self.inputLevel=stringSplitToNumber(data.input,',')
    self.outLevel=stringSplitToNumber(data.output,',')
    self.isLock=true
    self.OpenStar=data.openstar
    self.OpenPass=data.openpass
    self.OpenOther=data.openother
    self.temppos=nil
    self:ParseTempPos(data.temppos)
end

--0 跑完比赛
--1 时间
--2 用配件
--3不能使用配件
--4 获得第1名
--5 不是最后一名
--6 获得前x名
function PVELevelData:GetPassStarParam(cond,succval,index)
    local conds= stringSplitToNumber(cond,':')
    local succval= stringSplitToNumber(succval,':')
    for i = 1, #conds do
        if self.starParam[i]==nil then
            self.starParam[i]={}
        end
        self.starParam[i][index]=CommonHelper:GetLevelPassDesc(conds[i],succval[i])
    end
end

function   PVELevelData:ParseTempPos(str)
    if str~="-1" then
        self.temppos={}
        local tempPoss=stringSplit(str,'|')
        for i = 1, #tempPoss do
            local levels=stringSplit(tempPoss[i],':')
            local id=tonumber(levels[1])
            local temps={}
            for j = 2, #levels do
                local pos=stringSplitToNumber(levels[j],',')
                local posx=pos[1]
                local posy=pos[2]
                table.insert(temps,{posx,posy})
            end
            self.temppos[id]=temps
        end
    end
end

function  PVELevelData:UpdateLevelData(star,time,count,winSum)
    self.isLock = false
    self.star = star
    local num=#self.star
    --if #self.star==1 then
    --    num=1
    --end
    --if #self.star==1 then
    --    num=1
    --end
    --if self.star[2]=="011" or self.star=="101"  then
    --    num=2
    --end
    --if self.star[3]=="111" then
    --    num=3
    --end
    self.starNum=num
    self.personRecord = time
    self.count=count
    self.winSum=winSum
    if self.levelCfg.copytype==LevelType.GuideLevel and self.starNum>0 then
        self.isLock=true
    end
end
function PVELevelData:CheckStarState(num)
    local result=false
    for i = 1, #self.star do
        if self.star[i]==num then
            result=true
        end
    end
    return result
end
function  PVELevelData:UpdateLevelDataStar(star)
    self.star = star
    local num=#self.star
    --if self.star=="001" then
    --    num=1
    --end
    --if self.star=="011" or self.star=="101"  then
    --    num=2
    --end
    --if self.star=="111" then
    --    num=3
    --end
    self.starNum=num
end
function  PVELevelData:UpdateLevelDataCount(count)
    self.count=count
end
function  PVELevelData:UpdateLevelDataWinSum(winSum)
    self.winSum=winSum
end
function  PVELevelData:GetBattleInfo()
    return self.levelCfg.BattleInfoList
end

---@param arg table<number,SC_ChapterRankInfo)
function PVELevelData:SetRackInfo(arg)
    self.PveRankData={}
    local temp=PVEChapterRankData(arg)
    table.insert(self.PveRankData,temp)
end



