

local _SelectId=-1
---@class RaceSelfChapterCreateView : ViewBase
RaceSelfChapterCreateView = class("RaceSelfChapterCreateView", ViewBase)

function RaceSelfChapterCreateView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfChapterCreateViewAction")
end

function RaceSelfChapterCreateView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnSubmit",self.gameObject,function (hbtn)
        if _SelectId~=-1 then
            ---@type selfchapterticket_config_cell
            local chapterData=CommonHelper:GetTableDataByID(ConfigNames.selfchapterticket_config,_SelectId)
            if KnapsackDataManager:Get():GetArticleCountByCfgid(chapterData.holdCost)>0 then
                RaceSelfChapterSubsystem:Get():SendMsg_CreateSelfChapter(chapterData.holdCost)
            else
                CommonTipsHelper:Get():ShowCenterTips(TemplateStringID.RaceSelfChapterCostNo)
            end

        end
    end)
    self.MoreRowScrollView=self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))
    self.LevelMapScrollView=self:GetChildWight("LevelMapScrollView",typeof(LevelMapScrollView))
end

function RaceSelfChapterCreateView:OnOpen()
   self:SetDefault()
   self:SetTicKets()
end
function RaceSelfChapterCreateView:SetDefault()

end


function RaceSelfChapterCreateView:SetTicKets()

    local cfgdata=ClientDataManager:Get():GetDataTable(ConfigNames.selfchapterticket_config).GetConfigData()
    local data={}
    for i, v in pairs(cfgdata) do
        table.insert(data,v)
    end
    _SelectId=data[1].id
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterViewSetTickets)
    CommonHelper:InitMoreRowScrollView(self.MoreRowScrollView,#data,1,function(dataIndex, itemObj, scroll)
        local temp=data[dataIndex+1]
        local param=Param_PropParam()
        param.moduleId=UIModuleID.RaceSelfChapterCreate
        param.id=temp.holdCost
        CommonHelper:SetPropGroup(itemObj,param)
        ---@type article_config_cell
        local article= CommonHelper:GetTableDataByID(ConfigNames.article_config,temp.holdCost)
        CommonHelper:SetText("###tiketname",itemObj,CommonHelper:GetTempStr_Default(article.name))
        CommonHelper:SetText("###tiketdesc",itemObj,CommonHelper:GetTempStr_Default(article.description))
        CommonHelper:HButtonSetCallback("BtnSelect",itemObj,function(btnData)
            _SelectId=data[btnData.intData+1].id
            UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterViewSetTickets)
            CommonHelper:MoreRowView_RefreshCurList(self.MoreRowScrollView,false)
        end,dataIndex)
        CommonHelper:SetGameObjectActive("select",itemObj,_SelectId==temp.id)
    end)
end


function RaceSelfChapterCreateView:SetLevels()
    ---@type selfchapterticket_config_cell
    local chapterData=CommonHelper:GetTableDataByID(ConfigNames.selfchapterticket_config,_SelectId)
    local data=self:CreateLevelMapData(chapterData.levelIds)
    CommonHelper:LevelMapView_Init(self.LevelMapScrollView, data,false, function(dataIndex, itemObj, scroll)
        ---@type selfchapterlevelinfo_config_cell
        local levelData=CommonHelper:GetTableDataByID(ConfigNames.selfchapterlevelinfo_config,dataIndex)
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
            local unlock= CommonHelper:SetGameObjectActive("unlock",levelObj,true)
            local lock= CommonHelper:SetGameObjectActive("lock",levelObj,false)
            CommonHelper:SetGameObjectActive("openstart",levelObj,false)
            CommonHelper:SetGameObjectActive("ThreeStar",levelObj,false)
            CommonHelper:SetGameObjectActive("PassNum",levelObj,false)
            CommonHelper:SetGameObjectActive("SixStar",levelObj,false)
            CommonHelper:SetGameObjectActive("textbg",levelObj,false)
            CommonHelper:SetText("###limitvalue",levelObj,"")
            CommonHelper:SetGameObjectActive("passlevel",levelObj,false)
            CommonHelper:GetComponentSetUITexture("icon",unlock,levelData.bossIcon,UIModuleID.RaceSelfChapterCreate)
            CommonHelper:GetComponentSetUITexture("icon",lock,levelData.bossIcon,UIModuleID.RaceSelfChapterCreate)
        end
    end)
end


local tileX=400
local tileY=280
function RaceSelfChapterCreateView:CreateLevelMapData(levelStr)
    local levels=stringSplitToNumber(levelStr,',')
    local result = {}
    for i = 1, #levels do
        ---@type selfchapterlevelinfo_config_cell
       local levelData= CommonHelper:GetTableDataByID(ConfigNames.selfchapterlevelinfo_config,levels[i])
        local temp = LevelMapScrollViewNode()
        temp.id = levelData.id
        local pos=stringSplitToNumber(levelData.pos,',')
        temp.pos = self:GetVector2(pos[1],pos[2])
        local  linePoints ={}
        local inputLevels=stringSplitToNumber(levelData.input,',')
        for j = 1, #inputLevels do
            local tempLinePos={}
            local inputLevel=CommonHelper:GetTableDataByID(ConfigNames.selfchapterlevelinfo_config,inputLevels[j])
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
function RaceSelfChapterCreateView:GetVector2(x,y)
    return Vector2(x*tileX,y*tileY)
end
function   RaceSelfChapterCreateView:ParseTempPos(str)
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


function RaceSelfChapterCreateView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceSelfChapterCreate)
end
