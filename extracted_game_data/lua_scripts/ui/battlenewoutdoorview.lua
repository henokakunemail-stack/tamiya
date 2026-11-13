---@class BattleNewOutdoorView : ViewBase
BattleNewOutdoorView = class("BattleNewOutdoorView", ViewBase)

function BattleNewOutdoorView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BattleNewOutdoorViewAction")
end

function BattleNewOutdoorView:Awake()
    self.skillCardItemTransList = {}

    self.cameraType = 1
    self.cameraData = {
        6001, 6002, 6003
    }
    CommonHelper:HButtonSetCallback("CameraChangeViewBtn", self.gameObject, function(param)
        self:OnCameraTypeBtnClick()
    end)
end

function BattleNewOutdoorView:OnOpen()
    self:InitViewInfo()
end
function BattleNewOutdoorView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.BattleNewOutdoor)
end


function BattleNewOutdoorView:InitViewInfo()

    self.page_battleRank = Page_BattleBase()

    self.page_battleRank:CacheBaseData(self.gameObject, UIModuleID.Battle)

    --for i = 0, 4 do
    --    local tweenCardItemTrans = self:GetChildByParent(string.format("tweenCard%d", i + 1), self.gameObject)
    --    table.insert(self.skillCardItemTransList, tweenCardItemTrans)
    --end
    local tweenCardItemTrans = self:GetChildByParent(string.format("tweenCard%d", 1), self.gameObject)
    table.insert(self.skillCardItemTransList, tweenCardItemTrans)

    self:SetSkillCardsData()
end

------------------------------设置四个技能的数据
function BattleNewOutdoorView:SetSkillCardsData()
    local skillCount = BattleDyDataManager:Get():GetSelfCarData():GetSkillDataCount()

    skillCount=1

    for i = 0, skillCount - 1 do
        self:SetSkillCardData(i)
    end
end

function BattleNewOutdoorView:SetSkillCardData(index)
    local skillCardItemTrans = self.skillCardItemTransList[index + 1]
    CommonHelper:CSGameObjectSetActive(skillCardItemTrans.gameObject, true)

    local selfCarData = BattleDyDataManager:Get():GetSelfCarData()
    local skillCardData = selfCarData:GetSkillDataByIndex(index + 1)

    self:SetSkillImage(skillCardItemTrans, skillCardData)
    self:InitSkillCdAni(skillCardItemTrans, skillCardData)
end
-------------------------------设置技能的信息
---@param skillCardData SkillCardData
function BattleNewOutdoorView:SetSkillImage(skillCardItemTrans, skillCardData)
    local skillBtn = self:GetChildWightByParent("SkillBtn", skillCardItemTrans, typeof(HButton))

    CommonHelper:SetText("SkillEnergyText", skillCardItemTrans, tostring(skillCardData:GetSkillEnergy()))
    CommonHelper:SetText("SkillNameText", skillCardItemTrans, skillCardData:GetSkillName())

    CommonHelper:SetHButtonClick(skillBtn, true, false)
    CommonHelper:GetComponentSetUITexture("SkillRawImage", skillCardItemTrans, skillCardData:GetSkillIcon() .. ".png", UIModuleID.Battle)
end

--------------------------------初始化技能动画
function BattleNewOutdoorView:InitSkillCdAni(skillCardItemTrans, skillCardData)
    local cdImage = self:GetChildWightByParent("CdImage", skillCardItemTrans.gameObject, typeof(Image))
    local cdTweenSkillImage = self:GetChildWightByParent("CdImage", skillCardItemTrans.gameObject, typeof(TweenSkillImage))

    cdImage.fillAmount = 0
    cdTweenSkillImage.from = 0
    cdTweenSkillImage:ResetToBeginning()
    cdTweenSkillImage.isPause = false

    CommonHelper:HButtonSetCallback("SkillBtn", skillCardItemTrans.gameObject, function(param)
        CSLuaHelper.BattleReleaseSkill(skillCardData.skillIndex)
    end)
end

-------------------------------------点击技能按钮之后，进入cd状态
function BattleNewOutdoorView:UpdateSkillCardsDataCD(skillCdData)
    for i = 1, 1 do
        self:UpdateSkillCardDataCD({ i, skillCdData[2] })
    end
end

function BattleNewOutdoorView:UpdateSkillCardDataCD(skillCdData)
    local cellIndex = skillCdData[1]
    local cdTime = skillCdData[2]

    local curCardTrans = self.skillCardItemTransList[cellIndex]
    if curCardTrans then
        local cdTweenSkillImage = self:GetChildWightByParent("CdImage", curCardTrans.gameObject, typeof(TweenSkillImage))
        CommonHelper:SetTween(cdTweenSkillImage, 1, 0, cdTime, 0, nil, false)

        local skillBtn = self:GetChildWightByParent("SkillBtn", curCardTrans.gameObject, typeof(HButton))
        CommonHelper:SetHButtonClick(skillBtn, false, false)
    end
end

-----------------------------------------------技能cd之后，改变按钮状态，目前是释放技能，所有技能都进入cd,统一恢复cd
function BattleNewOutdoorView:SkillCardCDFinish(cardCellIndex)
    for i = 1, 1 do
        cardCellIndex = i
        local curCardTrans = self.skillCardItemTransList[cardCellIndex]

        local cdImage = self:GetChildWightByParent("CdImage", curCardTrans.gameObject, typeof(Image))
        cdImage.fillAmount = 0

        local skillBtn = self:GetChildWightByParent("SkillBtn", curCardTrans.gameObject, typeof(HButton))
        CommonHelper:SetHButtonClick(skillBtn, true, false)
    end
end
-------------------------------------------------暂停当前技能cd动画
function BattleNewOutdoorView:PauseAllSkillTween(isPause)
    local currentCarData = BattleDyDataManager:Get():GetSelfCarData()
    local skillDataCount = currentCarData:GetSkillDataCount()
    skillDataCount=1

    for i = 1, skillDataCount do
        local tweenSkillImage = self:GetChildWightByParent("CdImage", self.skillCardItemTransList[i].gameObject, typeof(TweenSkillImage))
        self:PauseOneSkillTween(tweenSkillImage, isPause)
    end

end

function BattleNewOutdoorView:PauseOneSkillTween(tweenSkillImage, isPause)
    if isPause then
        tweenSkillImage:Pause()
    else
        tweenSkillImage:Resume()
    end
end

------------------------------------- 战斗结束，隐藏当前的卡片
function BattleNewOutdoorView:OnFinishedBattle(finishedData)

    self.page_battleRank:OnBattleFinished(finishedData)

    local carId = finishedData[1]
    local selfCarData = BattleDyDataManager:Get():GetSelfCarData()
    if carId == selfCarData:GetCarId() then
        --for i = 1, 4 do
        --    CommonHelper:CSGameObjectSetActive(self.skillCardItemTransList[i].gameObject, false)
        --end
        CommonHelper:CSGameObjectSetActive(self.skillCardItemTransList[1].gameObject, false)

    end
end

--carId, from, to, rank
function BattleNewOutdoorView:SetRank(rankInfo)
    self.page_battleRank:SetOneRank(rankInfo[1], rankInfo[3], rankInfo[4])
end

function BattleNewOutdoorView:UpdateScrollList(userdata)
    self.page_battleRank:UpdateScrollList(userdata)
end

function BattleNewOutdoorView:ClearData()
    self.page_battleRank:ResetRankGoData()
    self.page_battleRank:ClearRank()
end

function BattleNewOutdoorView:OnDisable()
    self.page_battleRank:SaveCameraData()
    self:ClearData()
end


--{{{镜头

function BattleNewOutdoorView:OnCameraTypeBtnClick()
    self.cameraType = self.cameraType + 1

    self.cameraType = self.cameraType <= 3 and self.cameraType or 1

    CSLuaHelper.ChangeCameraView(self.cameraData[self.cameraType])
end

--}}}
