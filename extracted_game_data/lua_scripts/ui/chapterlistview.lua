




---@class ChapterListView : ViewBase
ChapterListView = class("ChapterListView", ViewBase)

function ChapterListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ChapterListViewAction")
end

function ChapterListView:Awake()
    log("---   ChapterListView awake")

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("LevelMapScrollView",self.gameObject,typeof(LevelListScrollView))


    ---@type ChapterData
    self.chapterData = nil
    ---@type table<number, LevelData>
    self.LevelList = {}
end

function ChapterListView:OnOpen()

end

function ChapterListView:OnClose()
    log("---    ChapterListView OnClose")
    CommonHelper:ReleasePool(UIModuleID.ChapterList)
end
function ChapterListView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end

function ChapterListView:SetData(newid)
    self.chapterData = ChapterDataManager:Get():GetChapterDataByID(newid)
    self.LevelList = self.chapterData.LevelList

    self:SetScrollView()
    self:SetBoxSlider()
    self:SetBoxState()


end

function ChapterListView:SetScrollView()
    local data = {}
    for i = 1, #self.LevelList do
        table.insert(data, self.chapterData.levelMap[i])
    end
    CommonHelper:LevelListView_Init(self.ScrollView, data,self.chapterData.process, function(dataIndex, itemObj, scroll)
        local data = self.LevelList[dataIndex + 1]

        CommonHelper:SetGameObjectActive("passtate1", itemObj, data.lock)
        local notpassobj_normal = CommonHelper:SetGameObjectActive("passtate1/normal", itemObj,not data.isboss)
        local notpassobj_boss = CommonHelper:SetGameObjectActive("passtate1/boss", itemObj, data.isboss)

        CommonHelper:SetGameObjectActive("passtate2", itemObj, not data.lock)
        local passobj_normal = CommonHelper:SetGameObjectActive("passtate2/normal", itemObj,not data.isboss)
        local passobj_boss = CommonHelper:SetGameObjectActive("passtate2/boss", itemObj, data.isboss)


        if data.lock then
            if data.isboss then
                CommonHelper:SetText("levelidx",notpassobj_boss,data.idxname)
                CommonHelper:SetText("levelname",notpassobj_boss,data.name)
                CommonHelper:GetComponentSetUITexture("bossicon",notpassobj_boss,data.icon,UIModuleID.ChapterList)
            else
                CommonHelper:SetText("levelidx",notpassobj_normal,data.idxname)
                CommonHelper:SetText("levelname",notpassobj_normal,data.name)
            end

        else
            if data.isboss then
                CommonHelper:SetText("levelidx",passobj_boss,data.idxname)
                CommonHelper:SetText("levelname",passobj_boss,data.name)
                CommonHelper:SetGameObjectActive("select", passobj_boss, data.state == 0)
                CommonHelper:SetGameObjectActive("finish", passobj_boss, data.state == 1)
                CommonHelper:GetComponentSetUITexture("bossicon",passobj_boss,data.icon,UIModuleID.ChapterList)
            else
                CommonHelper:SetText("levelidx",passobj_normal,data.idxname)
                CommonHelper:SetText("levelname",passobj_normal,data.name)
                CommonHelper:SetGameObjectActive("select", passobj_normal, data.state == 0)
                CommonHelper:SetGameObjectActive("finish", passobj_normal, data.state == 1)
            end
        end

        CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
            if data.lock then
                CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.LevelLock))
            else
                UIManager:Get():OpenView("SelectTeamView",CanvasType.MainCanvas,"SelectTeamView")
                UINotify:Get():SendNotification(UINotifyEvent.SelectTeamView_SetData, {data, self.chapterData})
            end

        end)

    end)
end

function ChapterListView:SetBoxSlider()
    CommonHelper:SetBoxStateSlider("processgroup", self.gameObject, self.chapterData.BoxSlider)

    local per = self.chapterData.process / #self.LevelList
    CommonHelper:SetSlider("SliderBaseColor", self.gameObject, per)

    local str = ClientDataManager:Get():GetTemplateString(TemplateStringID.PartReforLimitFormat)
    str = string.format(str, self.chapterData.process, #self.LevelList)
    CommonHelper:SetText("###processvalue", self.gameObject , str)
end

function ChapterListView:SetBoxState()
    for i = 1, 3 do
        local data = self.chapterData.BoxData[i]
        local obj = CommonHelper:SetGameObjectActive("BoxData"..i, self.gameObject, data ~= nil)
        if data then
            CommonHelper:SetBoxState("BoxData"..i, self.gameObject, data.state)
            CommonHelper:HButtonSetCallback("BoxBtn",obj,function (hbtn)
                if data.state == 0 then
                    --CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChapterBoxNotGet))
                    CommonHelper:ShowRewardPopup(data.rewards,ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardPreview))
                end
                if data.state == 1 then
                    ChapterSubsystem:Get():SendMsg_GetChapterBox(self.chapterData.id, data.levelid)
                end
                if data.state == 2 then
                    --CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChapterBoxHaveGet))
                    CommonHelper:ShowRewardPopup(data.rewards,ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardGeted))
                end
            end)
        end
    end

end

