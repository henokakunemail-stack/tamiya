


---@class ClubRaceSelfChapterListView : ViewBase
ClubRaceSelfChapterListView = class("ClubRaceSelfChapterListView", ViewBase)

function ClubRaceSelfChapterListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ClubRaceSelfChapterListViewAction")
end

function ClubRaceSelfChapterListView:Awake()

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    self.ScrollView = UIUtil.GetTypeChildWightByParent("LevelMapScrollView",self.gameObject,typeof(LevelMapScrollView))

    ---@type ClubRaceSelfChapterData
    self.chapterData = nil
    ---@type table<number, guildselfchapterlevelinfo_config_cell>
    self.LevelList = {}
end

function ClubRaceSelfChapterListView:OnOpen()

end

function ClubRaceSelfChapterListView:OnClose()

    CommonHelper:ReleasePool(UIModuleID.ClubRaceSelfChapterList)
end

function ClubRaceSelfChapterListView:SetData()
    self.chapterData = ClubRaceSelfChapterDataManager:Get():GetChapterData()
    self:SetScrollView()
    self:SetContent()
end

function ClubRaceSelfChapterListView:SetContent()
    CommonHelper:SetText("joinnum/###value",self.gameObject,self.chapterData.joinNum)
    CommonHelper:SetText("passnum/###value",self.gameObject,self.chapterData.passNum)
    CommonHelper:SetText("subcount/###value",self.gameObject,self.chapterData.subCount)
end

function ClubRaceSelfChapterListView:SetScrollView()
    local level=self.chapterData.level
    local data=self:CreateLevelMapData(self.chapterData.cfg.levelIds)
    CommonHelper:LevelMapView_Init(self.ScrollView, data,false, function(dataIndex, itemObj, scroll)
        ---@type guildselfchapterlevelinfo_config_cell
        local levelData=CommonHelper:GetTableDataByID(ConfigNames.guildselfchapterlevelinfo_config,self.LevelList[dataIndex])
        local easy= CommonHelper:SetGameObjectActive("easy",itemObj,levelData.copytype==LevelType.Normal)
        local hard= CommonHelper:SetGameObjectActive("hard",itemObj,levelData.copytype==LevelType.Elite)
        local boss= CommonHelper:SetGameObjectActive("boss",itemObj,levelData.copytype==LevelType.Boss)
        local story=CommonHelper:SetGameObjectActive("story",itemObj,levelData.copytype==LevelType.Story)
        local levelObj=nil
        if levelData.copytype==LevelType.Normal then
            levelObj=easy
        end
        if levelData.copytype==LevelType.Elite then
            levelObj=hard
        end
        if levelData.copytype==LevelType.Boss then
            levelObj=boss
        end
        if levelData.copytype==LevelType.Story then
            levelObj=story
        end
        if levelData.leveltype~=LevelType.Story then
            local unlock= CommonHelper:SetGameObjectActive("unlock",levelObj,level==dataIndex)
            local lock= CommonHelper:SetGameObjectActive("lock",levelObj,level~=dataIndex)
            CommonHelper:SetGameObjectActive("openstart",levelObj,false)
            CommonHelper:SetGameObjectActive("ThreeStar",levelObj,false)
            CommonHelper:SetGameObjectActive("PassNum",levelObj,false)
            CommonHelper:SetGameObjectActive("SixStar",levelObj,false)
            CommonHelper:SetGameObjectActive("textbg",levelObj,false)
            CommonHelper:SetText("###limitvalue",levelObj,"")
            CommonHelper:GetComponentSetUITexture("icon",unlock,levelData.bossIcon,UIModuleID.ClubRaceSelfChapterList)
            CommonHelper:GetComponentSetUITexture("icon",lock,levelData.bossIcon,UIModuleID.ClubRaceSelfChapterList)
        end
        CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
            if level~=hbtn.intData then
                CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.LevelLock))
            else
                ---@type guildselfchapterlevelinfo_config_cell
                local cfg= CommonHelper:GetTableDataByID(ConfigNames.guildselfchapterlevelinfo_config,self.LevelList[dataIndex])
                SkipModuleHelper:Get():ToSelectCarView(RaceModel.ClubRaceSelfChapter,{self.chapterData,cfg})
            end
        end,dataIndex)
    end)
end
local tileX=400
local tileY=280
function ClubRaceSelfChapterListView:CreateLevelMapData(levelStr)
    local temp=stringSplitToNumber(levelStr,',')
    local levels={}
    for i = 0, #temp do
        levels[i]=temp[i+1]
    end
    self.LevelList=levels
    local result = {}
    for i = 0, #levels do
        ---@type guildselfchapterlevelinfo_config_cell
        local levelData= CommonHelper:GetTableDataByID(ConfigNames.guildselfchapterlevelinfo_config,levels[i])
        local temp = LevelMapScrollViewNode()
        temp.id = i
        local pos=stringSplitToNumber(levelData.pos,',')
        temp.pos = self:GetVector2(pos[1],pos[2])
        local  linePoints ={}
        local inputLevels=stringSplitToNumber(levelData.input,',')
        for j = 1, #inputLevels do
            local tempLinePos={}
            local inputLevel=CommonHelper:GetTableDataByID(ConfigNames.guildselfchapterlevelinfo_config,inputLevels[j])
            if inputLevel then
                local pos=stringSplitToNumber(inputLevel.pos,',')
                table.insert(tempLinePos,self:GetVector2(pos[1],pos[2]))
                if levelData.temppos~="-1" then
                    local tempPos=self:ParseTempPos(levelData.temppos)
                    local inputLeveltemps = tempPos[inputLevel.id]
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
function ClubRaceSelfChapterListView:GetVector2(x,y)
    return Vector2(x*tileX,y*tileY)
end
function   ClubRaceSelfChapterListView:ParseTempPos(str)
    local temppos={}
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
        temppos[id]=temps
    end
    return temppos
end
