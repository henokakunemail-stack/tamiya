


---@class RaceSelfChapterListView : ViewBase
RaceSelfChapterListView = class("RaceSelfChapterListView", ViewBase)

function RaceSelfChapterListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfChapterListViewAction")
end

function RaceSelfChapterListView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
   CommonHelper:HButtonSetCallback("BtnRewardBtn",self.gameObject,function (hbtn)
       UIManager:Get():OpenPopup("RaceSelfChapterTaskView", CanvasType.FrontCanvas, "RaceSelfChapterTaskView")
       UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterTaskView_SetData,self.chapterData)
    end)
    self.ScrollView = UIUtil.GetTypeChildWightByParent("LevelMapScrollView",self.gameObject,typeof(LevelMapScrollView))

    ---@type RaceSelfChapterData
    self.chapterData = nil
    ---@type table<number, SC_CopyInfo>
    self.LevelList = {}
end

function RaceSelfChapterListView:OnOpen()

end

function RaceSelfChapterListView:OnClose()

    CommonHelper:ReleasePool(UIModuleID.RaceSelfChapterList)
end

function RaceSelfChapterListView:SetData(index)
    ---@type RaceSelfChapterData
    self.chapterData = RaceSelfChapterDataManager:Get():GetRaceByID(index)
    self:SetScrollView()
    self:SetContent()
end
function RaceSelfChapterListView:Refresh()
    CommonHelper:LevelMapView_Refresh(self.ScrollView,false)
    self:SetContent()
end

function RaceSelfChapterListView:SetContent()
    CommonHelper:SetText("joinnum/###value",self.gameObject,self.chapterData.FinishPeople)
    CommonHelper:SetGameObjectActive("taskgroup",self.gameObject,self.chapterData.HasTask)
    if self.chapterData.subTaskDay<=0 and  self.chapterData.subTaskHour<=0 then
        CommonHelper:SetText("###subtime",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterSubTimeMinute,self.chapterData.subTaskMinute,self.chapterData.subTaskSecond))
    else
        CommonHelper:SetText("###subtime",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterSubTimeDay,self.chapterData.subTaskDay,self.chapterData.subTaskHour))
    end
    CommonHelper:SetGameObjectActive("BtnRewardBtn/redpoint",self.gameObject,self.chapterData:GetSelfChapterHasRedPoint())
    --CommonHelper:SetText("passnum/###value",self.gameObject,self.chapterData.passNum)
    --CommonHelper:SetText("subcount/###value",self.gameObject,self.chapterData.subCount)
end

function RaceSelfChapterListView:SetScrollView()
    local level=self.chapterData.level
    local data=self:CreateLevelMapData(self.chapterData.Cops)
    if data then
        CommonHelper:LevelMapView_Init(self.ScrollView, data,false, function(dataIndex, itemObj, scroll)
            local data =self.LevelList[dataIndex]
            ---@type dictactivitycopy_config_cell
            local levelData=CommonHelper:GetTableDataByID(ConfigNames.dictactivitycopy_config,data.copyid)
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
                local unlock= CommonHelper:SetGameObjectActive("unlock",levelObj,data.unlock==1)
                local lock= CommonHelper:SetGameObjectActive("lock",levelObj,data.unlock==0)
                CommonHelper:SetGameObjectActive("openstart",levelObj,false)
                CommonHelper:SetGameObjectActive("ThreeStar",levelObj,false)
                CommonHelper:SetGameObjectActive("PassNum",levelObj,false)
                CommonHelper:SetGameObjectActive("SixStar",levelObj,false)
                CommonHelper:SetGameObjectActive("textbg",levelObj,false)
                CommonHelper:SetText("###limitvalue",levelObj,"")
                CommonHelper:GetComponentSetUITexture("icon",unlock,levelData.levelicon,UIModuleID.RaceSelfChapterList)
                CommonHelper:GetComponentSetUITexture("icon",lock,levelData.levelicon,UIModuleID.RaceSelfChapterList)
                local subTime=CommonHelper:SubTime(data.btime*1000)
                local day = CommonHelper:GetConvertMillSecond(subTime)
                if math.abs(day)>=1 then
                    local dataTime= CommonHelper:ConvertIntToDataTime(data.btime*TimeMilliSecond_Second)
                    CommonHelper:SetText("###openday",lock,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterDataOpen,dataTime.Month,dataTime.Day))
                else
                    CommonHelper:SetText("###openday",lock,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterTomorrowOpen))
                end


                CommonHelper:SetGameObjectActive("passlevel",levelObj,data.winsum>0)
                CommonHelper:SetGameObjectActive("lockstar",levelObj,false)
                CommonHelper:SetGameObjectActive("fxrally",levelObj,false )
            end
            CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
                local data =self.LevelList[hbtn.intData]
                if data.unlock==0 then
                    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.LevelLock))
                else
                    ComicHelper:TriggerComicImg(data.copyid,function()
                        ---@type dictactivitycopy_config_cell
                        local cfg= CommonHelper:GetTableDataByID(ConfigNames.dictactivitycopy_config,data.copyid)
                        self.chapterData.CurLevel=hbtn.intData
                        SkipModuleHelper:Get():ToSelectCarView(RaceModel.RaceSelfChapter,{self.chapterData,cfg})
                    end)
                end
            end,dataIndex)
        end)
    else
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1013))
    end
end


local tileX=400
local tileY=280
---@param  levels SC_CopyInfo[]
function RaceSelfChapterListView:CreateLevelMapData(levels)
    self.LevelList=levels
    local result = {}
    for i = 1, #levels do
        ---@type mapnode_config_cell
        local mapNode=CommonHelper:GetTableDataByID(ConfigNames.mapnode_config,levels[i].copyid)
        if mapNode==nil then
            return nil
        end
        local temp = LevelMapScrollViewNode()
        temp.id = i
        local pos=stringSplitToNumber(mapNode.pos,',')
        temp.pos = self:GetVector2(pos[1],pos[2])
        local  linePoints ={}
        local inputLevels=stringSplitToNumber(mapNode.input,',')
        for j = 1, #inputLevels do
            local tempLinePos={}
            local inputLevel=CommonHelper:GetTableDataByID(ConfigNames.mapnode_config,inputLevels[j])
            if inputLevel then
                local pos=stringSplitToNumber(inputLevel.pos,',')
                table.insert(tempLinePos,self:GetVector2(pos[1],pos[2]))
                if mapNode.temppos~="-1" then
                    local tempPos=self:ParseTempPos(mapNode.temppos)
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
function RaceSelfChapterListView:GetVector2(x,y)
    return Vector2(x*tileX,y*tileY)
end
function   RaceSelfChapterListView:ParseTempPos(str)
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
