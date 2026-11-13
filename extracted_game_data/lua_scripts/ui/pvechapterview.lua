local __CurType
local __TypeStory = 2
local __TypeCustom = 1

---@class PveChapterView : ViewBase
PveChapterView = class("PveChapterView", ViewBase)

function PveChapterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PveChapterViewAction")
end

function PveChapterView:Awake()

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(false)
    end)
    self.ChapterView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))

    ---@type table<number,ChapterData>
    self.ChapterList = {}
end

function PveChapterView:OnOpen()
    self.ChapterList={}
    local list =PVEChapterDataManager:Get():GetChapterList()
    for i = 1, #list do
        table.insert(self.ChapterList,list[i])
    end
    table.insert(self.ChapterList,-1)
   self:SetChpaterView()
end

function PveChapterView:OnOpenAnimEnd()
    log("---    ChapterView OnOpenAnimEnd")
    --self:AutoSelect()
    --
    self:CheckNewBieGuide()
end

function PveChapterView:SetChpaterView()
    CommonHelper:InitMoreRowScrollView(self.ChapterView, #self.ChapterList, 6,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        self:UpdateChapterView(dataIndex, itemObj)
    end)
     CommonHelper:MoreRowView_EnterAni2(self.ChapterView, 0.16)
end

function PveChapterView:UpdateChapterView(dataIndex, itemObj)
    ---@type PVEChapterData
    local data = self.ChapterList[dataIndex + 1]
    CommonHelper:SetGameObjectActive("empty",itemObj,data==-1)
    CommonHelper:SetGameObjectActive("chapter",itemObj,data~=-1)
    if data==-1 then
        return
    end
    CommonHelper:SetText("###titlename",itemObj,data.name)
    CommonHelper:SetText("###titleidx",itemObj, data.idx)

    local icon = CommonHelper:GetComponentSetUITexture("icon",itemObj, data.chapterIcon, UIModuleID.PveChapter)
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
        CommonHelper:SetText("###nopass",itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.LastChapterDone,self.ChapterList[dataIndex].idx))
    end


    CommonHelper:SetGameObjectActive("statefinish",itemObj,cur==max)
    CommonHelper:SetGameObjectActive("bglock",itemObj,data.lock)
    CommonHelper:SetGameObjectActive("lock",itemObj,data.lock)
    CommonHelper:SetGameObjectActive("normal",itemObj,not data.lock)
    CommonHelper:SetGameObjectActive("bginprogress",itemObj,PlayerPrefsHelper:GetValue_PveChapterRally()==data.id)
    CommonHelper:SetGameObjectActive("inprogress",itemObj,PlayerPrefsHelper:GetValue_PveChapterRally()==data.id)
    CommonHelper:SetGameObjectActive("bgfinish",itemObj,data.lock==false and PlayerPrefsHelper:GetValue_PveChapterRally()~=data.id )

    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
       -- PVEChapterDataManager:Get():UpdateMsgLevelList(msg)

        --UIManager:Get():OpenView("PveChapterListView", CanvasType.MainCanvas, "PveChapterListView")
        --UINotify:Get():SendNotification(UINotifyEvent.PveChapterListView_SetLevelList, self.ChapterList[hbtn.intData+1].chapterId)
        ChapterSubsystem:Get():SendMsg_GetChapterDetail(data.id)
        PlayerPrefsHelper:SetValue_PveChapterRally(data.id)
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

function PveChapterView:ReOpen()
    self:SetChpaterView()
    CommonHelper:MoreRowView_EnterAni2(self.ChapterView, 0.16)
end
function PveChapterView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.Chapter)
end





--function PveChapterView:OnAutoClose()
--    CommonHelper:ReleasePool(UIModuleID.Chapter)
--
--end
--
--function PveChapterView:AutoSelect()
--    self:OnClickTog_Type(__CurType,  false)
--end
--
--function PveChapterView:OnClickTog_Type(type, ischeck)
--    if ischeck == nil then ischeck = true end
--    if __CurType == type and ischeck then return end
--    __CurType = type
--    self:SetToggleState(type)
--
--    self:SetConfig()
--
--    if type == __TypeStory then
--        if true then
--            CommonTipsHelper:Get():ShowCenterTips("功能未开启")
--        else
--            self:SetChpaterView()
--        end
--    end
--    if type == __TypeCustom then
--        self:SetChpaterView()
--    end
--
--end
--
--function PveChapterView:SetToggleState(type)
--    CommonHelper:SetToggleState(self.TypeTog[__TypeStory],__TypeStory == type)
--    CommonHelper:SetToggleState(self.TypeTog[__TypeCustom],__TypeCustom == type)
--    --CommonHelper:SetToggleState(self.TypeTog[__TypeActive],__TypeActive == type)
--end
--
--function PveChapterView:SetConfig()
--    if __CurType == __TypeStory then
--        self.ChapterList = ChapterDataManager:Get():GetStoryList()
--    end
--    if __CurType == __TypeCustom then
--        self.ChapterList = ChapterDataManager:Get():GetCustomList()
--    end
--
--end
--

--
