

local __TempChapterTweenIndex = {}
local __TimerID = -1




---@class SelfChallengeChapterListView : ViewBase
SelfChallengeChapterListView = class("SelfChallengeChapterListView", ViewBase)

function SelfChallengeChapterListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeChapterListViewAction")

    print("---   ChapterListView 初始化完成")
end

function SelfChallengeChapterListView:Awake()

    ---@type table<number, LevelData>
    self.LevelList = {}
    ---@type ChapterData
    self.chapterData = nil

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
        CommonHelper:PlayScreenEffectUIMask(1.2)
    end)

    self.LevelView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
    self.levelListScrollView = UIUtil.GetTypeChildWightByParent("LevelMapScrollView",self.gameObject,typeof(LevelListScrollView))

    self.ProcressBar = UIUtil.GetTypeChildWightByParent("ProcressBar",self.gameObject,typeof(RectTransform))
    self.PointGroup = {}
    for i = 1, 3 do
        local temp = UIUtil.GetTypeChildWightByParent("PointGroup"..i, self.gameObject,typeof(RectTransform))
        table.insert(self.PointGroup, temp)
    end

    self.chapterBgRoot = UIUtil.GetChild("chapterbgroot", self.gameObject)
    self.chapterbg = nil
end

function SelfChallengeChapterListView:OnOpen()


end

function SelfChallengeChapterListView:OnClose()
    print("---    ChapterListView OnClose")
    --TimerManager:Get():StopTimer(__TimerID)
    --__TimerID = -1
    CommonHelper:ReleasePool(UIModuleID.ChapterList)
    --LuaButtonManager:Get():ReleasePool(UIModuleID.ChapterList)
    self.LevelView:OutAni_Alpha(0)
    PrefabCacheMgr:Get():RecyclePrefab(self.chapterbg)
    self.chapterbg = nil
end

function SelfChallengeChapterListView:SetLevelList()
    ---设置数据
    print("     sdaaaaaaaaaa")
    self.chapterData=SelfChallengeDataManager:Get():GetChapterData()
    --LuaLogHelper.LogTable("---5555555555555555555555    0000   ", self.chapterData)
    self.LevelList = self.chapterData.LevelList

    self:SetLevelView()

    self:SetTitle()

    self:SetProcessBar()

    self:SetChapterBg()
end




function SelfChallengeChapterListView:SetLevelView()
    --CommonHelper:InitMoreRowScrollView(self.LevelView, #self.LevelList, 1,function(dataIndex, itemObj, scroll)
    --    --print("---      更新item :    dataIndex = " ,dataIndex,"   itemObj = ", itemObj)
    --    UINotify:Get():SendNotification(UINotifyEvent.ChapterListView_UpdateLevelView, {dataIndex, itemObj})
    --end)
    --
    --self.LevelView:EnterAni_Alpha(0.2)

    local data = {}
    for i = 1, #self.LevelList do
        table.insert(data, self.chapterData.levelMap[i])
    end

    CommonHelper:LevelListView_Init(self.levelListScrollView, data,self.chapterData.process, function(dataIndex, itemObj, scroll)

        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeChapterListView_UpdateLevelView, {dataIndex, itemObj})
    end)

end

function SelfChallengeChapterListView:UpdateLevelView(dataIndex, itemObj)
    local data = self.LevelList[dataIndex + 1]

    itemObj.name="ItemGroup"..dataIndex

    CommonHelper:SetText("LabName",itemObj,data.name)

    local iconRaw = UIUtil.GetTypeChildWightByParent("levelicon", itemObj, typeof(RawImage))
    if iconRaw then
        local icon = data.icon
        if data.state == 0 then icon = icon.."1.png" end
        if data.state == 1 then icon = icon.."2.png" end
        if data.state == -1 then icon = icon.."2.png" end
        CommonHelper:SetUITexture(iconRaw, icon, UIModuleID.ChapterList)
        CommonHelper:ImageSetNativeSize(iconRaw)
        if data.lock then
            CommonHelper:ImageSetGray(iconRaw, true)
        else
            CommonHelper:ImageSetMaterialDefault(iconRaw)
        end
    end

    --local itemBtn= self:GetChildByParent("ItemBtn",itemObj)
    --if itemBtn~=nil then
    --    itemBtn.gameObject.name="ItemBtn"..dataIndex
    --else
    --    itemBtn=self:GetChildByParent("ItemBtn"..dataIndex,itemObj)
    --end

    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeChapterListView_ClickLevelItem, hbtn.intData)
    end, dataIndex)

    local lock = CommonHelper:HButtonSetCallback("lock",itemObj,function (hbtn)
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.LevelLock))
    end)
    CommonHelper:SetHButtonClick(lock, data.lock, true)

    local stategoing = UIUtil.GetChild("stategoing",itemObj)
    stategoing:SetActive(data.state == 0)
    local statefinish = UIUtil.GetChild("statefinish",itemObj)
    statefinish:SetActive(data.state == 1)
    local shadowbig = UIUtil.GetChild("shadowbig",itemObj)
    shadowbig:SetActive(data.state == 0)
    local shadowsmall = UIUtil.GetChild("shadowsmall",itemObj)
    shadowsmall:SetActive(data.state == 1)

    local tweenPosition = self:GetChildWightByParent("ItemBtn", itemObj, typeof(TweenPosition))
    if tweenPosition then
        tweenPosition.enabled = (data.state == 0)
    end


end

function SelfChallengeChapterListView:ClickLevelItem(idx)
    local data = self.LevelList[idx + 1]
    UIManager:Get():OpenView("SelfChallengeSelectTeamView",CanvasType.MainCanvas,"SelfChallengeSelectTeamView")
    UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelectTeamView_SetData, {data, self.chapterData})
end

function SelfChallengeChapterListView:SetProcessBar()
    for i = 1, #self.chapterData.BoxData do
        local temp = self.chapterData.BoxData[i]
        self.PointGroup[i].gameObject:SetActive(temp.levelid > 0)

        if temp.levelid > 0 then
            --local per = i / 3
            --self.PointGroup[i].anchoredPosition = Vector2(self.ProcressBar.rect.width * per, self.PointGroup[i].anchoredPosition.y)

            CommonHelper:SetBoxState("boxstate", self.PointGroup[i].gameObject, temp.state)

            --print("---   9999   ",temp.levelid, temp.state, temp.rewardid,  temp.rewardnum)

            local getstate = UIUtil.GetChild("getstate",self.PointGroup[i].gameObject)
            local bossstate = UIUtil.GetChild("bossstate",self.PointGroup[i].gameObject)
            getstate:SetActive(true)
            bossstate:SetActive(true)
            ---@type SelfChallengeData
            local data= SelfChallengeDataManager:Get():GetChapterData()
            local selfChallengeData=SelfChallengeDataManager:Get():GetSelfChallengeDataByTicket(data.idx)
            CommonHelper:SetText("levelname", self.PointGroup[i].gameObject, "困难关"..selfChallengeData.needSetLv[i].."关奖励")

            CommonHelper:HButtonSetCallback("BtnBox",self.PointGroup[i].gameObject,function (hbtn)
                UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeChapterListView_ClickBox, hbtn.intData)
            end, i)
        end

    end
end


function SelfChallengeChapterListView:SetChapterBg()
    if self.chapterbg then
        PrefabCacheMgr:Get():RecyclePrefab(self.chapterbg)
        self.chapterbg = nil
    end

    PrefabCacheMgr:Get():SwapPrefabAsync(self.chapterData.chapterbg, nil, nil,self.LoadBgFinish, nil, self)
end

function SelfChallengeChapterListView:LoadBgFinish(param, obj)
    self.chapterbg = obj
    UIUtil.SetParentGameObject(self.chapterBgRoot, obj)
end

function SelfChallengeChapterListView:SetTitle()
    local ChapterTitle = UIUtil.GetChild("ChapterTitle",self.gameObject)
    CommonHelper:SetText("title1",ChapterTitle,self.chapterData.masterName)
    CommonHelper:SetText("title2",ChapterTitle,self.chapterData.name)
    CommonHelper:SetText("processValue",self.gameObject,tostring(self.chapterData.process))
    CommonHelper:SetText("processMax",self.gameObject,"/"..tostring(#self.chapterData.LevelList))

    --local iconRaw = UIUtil.GetTypeChildWightByParent("chapterIcon", self.gameObject, typeof(RawImage))
    --if iconRaw then
    --    CommonHelper:SetUITexture(iconRaw, self.chapterData.icon, UIModuleID.ChapterList)
    --
    --end

    CommonHelper:GetComponentSetUITexture("chapterIcon",self.gameObject,self.chapterData.icon,UIModuleID.ChapterList)
end


function SelfChallengeChapterListView:OnClickBtn_Box(idx)
    local temp = self.chapterData.BoxData[idx]
    if temp.state == 0 then
        --CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChapterBoxNotGet))
    end
    if temp.state == 1 then
       -- SelfChallengeSubsystem:Get():SendFinishSelfChallenge()
    end
    if temp.state == 2 then
        --CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChapterBoxHaveGet))
    end
end
