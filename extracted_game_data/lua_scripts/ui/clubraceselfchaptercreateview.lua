

local _SelectId=-1
---@class ClubRaceSelfChapterCreateView : ViewBase
ClubRaceSelfChapterCreateView = class("ClubRaceSelfChapterCreateView", ViewBase)

function ClubRaceSelfChapterCreateView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ClubRaceSelfChapterCreateViewAction")
end

function ClubRaceSelfChapterCreateView:Awake()

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnSubmit",self.gameObject,function (hbtn)
        if _SelectId~=-1 then
            ---@type guildselfchapterticket_config_cell
            local chapterData=CommonHelper:GetTableDataByID(ConfigNames.guildselfchapterticket_config,_SelectId)
            ClubRaceSelfChapterSubsystem:Get():SendMsg_CreateSelfChapter(chapterData.holdCost)
        end
    end)
    self.MoreRowScrollView=self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))
    self.LevelMapScrollView=self:GetChildWight("LevelMapScrollView",typeof(LevelMapScrollView))

end

function ClubRaceSelfChapterCreateView:OnOpen()
    self:SetTicKets()
end
function ClubRaceSelfChapterCreateView:SetTicKets()

    local cfgdata=ClientDataManager:Get():GetDataTable(ConfigNames.guildselfchapterticket_config).GetConfigData()
    local data={}
    for i, v in pairs(cfgdata) do
        table.insert(data,v)
    end
    _SelectId=data[1].id
    UINotify:Get():SendNotification(UINotifyEvent.ClubRaceSelfChapterViewSetTickets)
    CommonHelper:InitMoreRowScrollView(self.MoreRowScrollView,#data,4,function(dataIndex, itemObj, scroll)
        local temp=data[dataIndex+1]
        local param=Param_PropParam()
        param.moduleId=UIModuleID.ClubRaceSelfChapter
        param.id=temp.holdCost
        CommonHelper:SetPropGroup(itemObj,param)
        ---@type article_config_cell
        local article= CommonHelper:GetTableDataByID(ConfigNames.article_config,temp.holdCost)
        CommonHelper:SetText("###tiketname",itemObj,CommonHelper:GetTempStr_Default(article.name))
        CommonHelper:SetText("###tiketdesc",itemObj,CommonHelper:GetTempStr_Default(article.description))
        CommonHelper:HButtonSetCallback("BtnSelect",itemObj,function(btnData)
            _SelectId=data[btnData.intData+1].id
            UINotify:Get():SendNotification(UINotifyEvent.ClubRaceSelfChapterViewSetTickets)
            CommonHelper:MoreRowView_RefreshCurList(self.MoreRowScrollView,false)
        end,dataIndex)
        CommonHelper:SetGameObjectActive("select",itemObj,_SelectId==temp.id)
    end)
end


function ClubRaceSelfChapterCreateView:SetLevels()
    ---@type guildselfchapterticket_config_cell
    local chapterData=CommonHelper:GetTableDataByID(ConfigNames.guildselfchapterticket_config,_SelectId)
    local data=self:CreateLevelMapData(chapterData.levelIds)
    CommonHelper:LevelMapView_Init(self.LevelMapScrollView, data,false, function(dataIndex, itemObj, scroll)
        ---@type guildselfchapterlevelinfo_config_cell
        local levelData=CommonHelper:GetTableDataByID(ConfigNames.guildselfchapterlevelinfo_config,dataIndex)
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
        if levelData.copytype~=LevelType.Story then
            local unlock= CommonHelper:SetGameObjectActive("unlock",levelObj,true)
            local lock= CommonHelper:SetGameObjectActive("lock",levelObj,false)
            CommonHelper:SetGameObjectActive("openstart",levelObj,false)
            CommonHelper:SetGameObjectActive("ThreeStar",levelObj,false)
            CommonHelper:SetGameObjectActive("PassNum",levelObj,false)
            CommonHelper:SetGameObjectActive("SixStar",levelObj,false)
            CommonHelper:SetGameObjectActive("textbg",levelObj,false)
            CommonHelper:SetText("###limitvalue",levelObj,"")
            CommonHelper:GetComponentSetUITexture("icon",unlock,levelData.bossIcon,UIModuleID.ClubRaceSelfChapter)
            CommonHelper:GetComponentSetUITexture("icon",lock,levelData.bossIcon,UIModuleID.ClubRaceSelfChapter)
        end
    end)
end


local tileX=400
local tileY=280
function ClubRaceSelfChapterCreateView:CreateLevelMapData(levelStr)
    local levels=stringSplitToNumber(levelStr,',')
    local result = {}
    for i = 1, #levels do
        ---@type guildselfchapterlevelinfo_config_cell
        local levelData= CommonHelper:GetTableDataByID(ConfigNames.guildselfchapterlevelinfo_config,levels[i])
        local temp = LevelMapScrollViewNode()
        temp.id = levelData.id
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
function ClubRaceSelfChapterCreateView:GetVector2(x,y)
    return Vector2(x*tileX,y*tileY)
end
function   ClubRaceSelfChapterCreateView:ParseTempPos(str)
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


function ClubRaceSelfChapterCreateView:OnClose()

end
