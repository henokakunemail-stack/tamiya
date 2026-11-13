
local __CurType=nil
local __TypeStory = 2
local __TypeCustom = 1

---@class RaceSeniorTrainView : ViewBase
RaceSeniorTrainView = class("RaceSeniorTrainView", ViewBase)

function RaceSeniorTrainView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSeniorTrainViewAction")
end

function RaceSeniorTrainView:Awake()

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    self.ChapterView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))
    self.ChapterTittleView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Tittle", self.gameObject, typeof(MoreRowScrollView))

    ---@type table<number,ChapterData>
    self.ChapterList = {}
    ---@type table<string <number,ChapterData>>
    self.ChapterTableList = {}
    ---@type table <number,string>
    self.TabList={}
end

function RaceSeniorTrainView:OnOpen()
    self:SetChapterTableList()
    self:SetChapterTabView()
    self:SetChapterList()
    self:SetChpaterView()
    self:CheckNewBieGuide()
end
function RaceSeniorTrainView:SetChapterTableList()
    self.ChapterList = {}
    self.ChapterTableList = {}
    self.TabList={}
    __CurType=1
    ---@type table<number,ChapterData>
    local list =RaceSeniorTrainManager:Get():GetChapterList()
    for i = 1, #list do
        if self.ChapterTableList[list[i].ChapterTabType]==nil then
            self.ChapterTableList[list[i].ChapterTabType]={}
            table.insert(self.TabList,list[i].ChapterTabType)

        end
        table.insert(self.ChapterTableList[list[i].ChapterTabType],list[i])
    end
end
function RaceSeniorTrainView:SetChapterList()
    self.ChapterList=self.ChapterTableList[self.TabList[__CurType]]
end
function RaceSeniorTrainView:SetChapterTabView()
    CommonHelper:InitMoreRowScrollView(self.ChapterTittleView,#self.TabList,1,function (index, itemObj,scroll)
        ---@type SpecialTrainingData
        local temp =self.TabList[index+1]
        CommonHelper:SetText("bg/###text",itemObj,CommonHelper:GetTempStr_Default(temp))
        CommonHelper:SetText("hover/###text",itemObj,CommonHelper:GetTempStr_Default(temp))
        local Tog= CommonHelper:HButtonSetCallback("TogBtn",itemObj,function (data)
            if data.intData+1~=__CurType then
                __CurType=data.intData+1
                CommonHelper:MoreRowView_RefreshCurList(self.ChapterTittleView,false)
                self:SetChapterList()
                self:SetChpaterView()
            end
        end,index)
        CommonHelper:SetToggleState(Tog,__CurType==index+1)
    end)
end

function RaceSeniorTrainView:OnOpenAnimEnd()
    log("---    ChapterView OnOpenAnimEnd")


end

function RaceSeniorTrainView:SetChpaterView()
    CommonHelper:InitMoreRowScrollView(self.ChapterView, #self.ChapterList, 6,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        self:UpdateChapterView(dataIndex, itemObj)
    end)
    if not CommonHelper:CheckPlayerIsNewGuide() then
        CommonHelper:MoreRowView_EnterAni2(self.ChapterView, 0.16)
    end

end

function RaceSeniorTrainView:UpdateChapterView(dataIndex, itemObj)
    ---@type PVEChapterData
    local data = self.ChapterList[dataIndex + 1]
    CommonHelper:SetGameObjectActive("empty",itemObj,data==-1)
    CommonHelper:SetGameObjectActive("chapter",itemObj,data~=-1)
    if data==-1 then
        return
    end
    CommonHelper:SetText("###titlename",itemObj,data.name)
    CommonHelper:SetText("###titleidx",itemObj, data.idx)
    CommonHelper:SetText("###nopass",itemObj, data.idx)

    local icon = CommonHelper:GetComponentSetUITexture("icon",itemObj, data.chapterIcon, UIModuleID.RaceSeniorTrain)
    --local icon2 = CommonHelper:GetComponentSetUITexture("Icon2",itemObj, data.chapterIcon, UIModuleID.PveChapter)

    if data.lock then
        CommonHelper:ImageSetGray(icon, true)
    else
        CommonHelper:ImageSetMaterialDefault(icon)
        -- CommonHelper:ImageSetMaterialDefault(icon2)
    end


    local max = data.MaxStar
    local cur = data.process
    CommonHelper:SetText("###process",itemObj, cur.."/"..max)
    if dataIndex>0 then
      --  CommonHelper:SetText("###nopass",itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.LastChapterDone,self.ChapterList[dataIndex].idx))
    end


    CommonHelper:SetGameObjectActive("statefinish",itemObj,cur==max)
    CommonHelper:SetGameObjectActive("bglock",itemObj,data.lock)
    CommonHelper:SetGameObjectActive("lock",itemObj,data.lock)
    CommonHelper:SetGameObjectActive("normal",itemObj,not data.lock)
    CommonHelper:SetGameObjectActive("bginprogress",itemObj,PlayerPrefsHelper:GetValue_RaceSeniorTrainRally()==data.id)
    CommonHelper:SetGameObjectActive("inprogress",itemObj,PlayerPrefsHelper:GetValue_RaceSeniorTrainRally()==data.id)
    CommonHelper:SetGameObjectActive("bgfinish",itemObj,data.lock==false and PlayerPrefsHelper:GetValue_RaceSeniorTrainRally()~=data.id )

    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
        -- PVEChapterDataManager:Get():UpdateMsgLevelList(msg)

        --UIManager:Get():OpenView("PveChapterListView", CanvasType.MainCanvas, "PveChapterListView")
        --UINotify:Get():SendNotification(UINotifyEvent.PveChapterListView_SetLevelList, self.ChapterList[hbtn.intData+1].chapterId)
        RaceSeniorTrainSubsystem:Get():SendMsg_GetChapterDetail(data.id)
        PlayerPrefsHelper:SetValue_RaceSeniorTrainRally(data.id)
        -- CommonHelper:SetGameObjectActive("clickfx", itemObj, true)
        CommonHelper:PlayScreenEffectUIMask()
    end,dataIndex)


    local lock = CommonHelper:HButtonSetCallback("lock",itemObj,function (hbtn)
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChapterLock))
    end)



    local havereward = false
    for i = 1, #data.BoxData do
        if data.BoxData[i].state == LevelBoxState.CanReceive then
            havereward = true
            break
        end
    end
    CommonHelper:SetGameObjectActive("RedPointModule", itemObj, havereward)
    CommonHelper:SetGameObjectActive("clickfx", itemObj, false)
end

function RaceSeniorTrainView:ReOpen()
    self:SetChpaterView()
    CommonHelper:MoreRowView_EnterAni2(self.ChapterView, 0.16)
end
function RaceSeniorTrainView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceSeniorTrain)
end


function RaceSeniorTrainView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end



