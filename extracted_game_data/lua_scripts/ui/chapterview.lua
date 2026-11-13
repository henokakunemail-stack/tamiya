

local __CurType
local __TypeStory = 2
local __TypeCustom = 1


---@class ChapterView : ViewBase
ChapterView = class("ChapterView", ViewBase)

function ChapterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ChapterViewAction")
end

function ChapterView:Awake()
    log("---   ChapterView awake")

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    self.TypeTog = {}
    local btn = CommonHelper:HButtonSetCallback("TogStory",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ChapterView_ClickTogType, __TypeStory)
    end)
    self.TypeTog[__TypeStory] = btn

    btn = CommonHelper:HButtonSetCallback("TogCustom",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ChapterView_ClickTogType, __TypeCustom)
    end)
    self.TypeTog[__TypeCustom] = btn


    self.ChapterView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))

    ---@type table<number,ChapterData>
    self.ChapterList = {}
end

function ChapterView:OnOpen()
    log("---    ChapterView OnOpen")
    __CurType  = __TypeCustom

end

function ChapterView:OnOpenAnimEnd()
    log("---    ChapterView OnOpenAnimEnd")
    self:AutoSelect()
    --
    self:CheckNewBieGuide()
end



function ChapterView:ReOpen()
    log("---    ChapterView ReOpen")

end
function ChapterView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.Chapter)

end
function ChapterView:OnAutoClose()
    log("---    ChapterView OnAutoClose")
    CommonHelper:ReleasePool(UIModuleID.Chapter)

end

function ChapterView:AutoSelect()
    self:OnClickTog_Type(__CurType,  false)
end

function ChapterView:OnClickTog_Type(type, ischeck)
    if ischeck == nil then ischeck = true end
    if __CurType == type and ischeck then return end
    __CurType = type
    self:SetToggleState(type)

    self:SetConfig()

    if type == __TypeStory then
        if true then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SurveyNoOpen))
        else
            self:SetChpaterView()
        end
    end
    if type == __TypeCustom then
        self:SetChpaterView()
    end

end

function ChapterView:SetToggleState(type)
    CommonHelper:SetToggleState(self.TypeTog[__TypeStory],__TypeStory == type)
    CommonHelper:SetToggleState(self.TypeTog[__TypeCustom],__TypeCustom == type)
    --CommonHelper:SetToggleState(self.TypeTog[__TypeActive],__TypeActive == type)
end

function ChapterView:SetConfig()
    if __CurType == __TypeStory then
        self.ChapterList = ChapterDataManager:Get():GetStoryList()
    end
    if __CurType == __TypeCustom then
        self.ChapterList = ChapterDataManager:Get():GetCustomList()
    end

end

function ChapterView:SetChpaterView()
    CommonHelper:InitMoreRowScrollView(self.ChapterView, #self.ChapterList, 1,function(dataIndex, itemObj, scroll)
        --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
        self:UpdateChapterView(dataIndex, itemObj)
    end)
    CommonHelper:MoreRowView_EnterAni1(self.ChapterView, 0.2)
end

function ChapterView:UpdateChapterView(dataIndex, itemObj)
    local data = self.ChapterList[dataIndex + 1]

    CommonHelper:SetText("titlename",itemObj,data.name)
    CommonHelper:SetText("titleidx",itemObj, data.idx)

    local icon = CommonHelper:GetComponentSetUITexture("Icon",itemObj, data.icon, UIModuleID.Chapter)

    if data.lock then
        CommonHelper:ImageSetGray(icon, true)
    else
        CommonHelper:ImageSetMaterialDefault(icon)
    end


    local max = #data.LevelList
    local cur = data.process
    CommonHelper:SetText("process",itemObj, cur.."/"..max)

    CommonHelper:SetGameObjectActive("statefinish",itemObj,false)

    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
        ChapterSubsystem:Get():SendMsg_GetChapterDetail(data.id)
        CommonHelper:PlayScreenEffectUIMask()
    end)


    local lock = CommonHelper:HButtonSetCallback("lock",itemObj,function (hbtn)
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChapterLock))
    end)
    CommonHelper:SetHButtonClick(lock, data.lock, true)


    local havereward = false
    for i = 1, #data.BoxData do
        if data.BoxData[i].state == 1 then
            havereward = true
            break
        end
    end
    CommonHelper:SetGameObjectActive("RedPointModule", itemObj, havereward)
end

