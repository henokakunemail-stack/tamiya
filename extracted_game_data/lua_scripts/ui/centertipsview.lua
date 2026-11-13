


local __MaxShowCount = 3


---@class CenterTipsView:ViewBase
CenterTipsView = class("CenterTipsView",ViewBase)


function CenterTipsView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "CenterTipsViewAction")

    print("---   CenterTipsView 初始化完成")
end

function CenterTipsView:Awake()
    print("---   CenterTipsView awake")

    self.ItemList = {}
    for i = 1, 6 do
        local obj = CommonHelper:SetGameObjectActive("Item"..i, self.gameObject, false)
        self.ItemList[i] = obj
    end

    self.TipsPlayingCount = 0
    self.seqHandle = nil
    self.WaitingList = {}
end

function CenterTipsView:OnOpen()
    print("---   CenterTipsView awake")

end

function CenterTipsView:ShowTips(des)
    if self.TipsPlayingCount < __MaxShowCount then
        self.TipsPlayingCount = self.TipsPlayingCount + 1
        self:PlayTween(des)

        if self.seqHandle then
            self.seqHandle:StopSequence()
            self.seqHandle = nil
        end

        self.seqHandle = UnrealM.ActionSequenceHandle()
        self.seqHandle:Looper(2, nil):ActionInt(function(count)
            self.seqHandle:StopSequence()
            self.seqHandle = nil
            self.TipsPlayingCount = 0
            self:AutoPlayWaiting()
        end)
    else
        --table.insert(self.WaitingList, des)
    end

end

function CenterTipsView:PlayTween(des)
    local idx = self.TipsPlayingCount
    local item = self.ItemList[idx]
    local text = self:GetChildWightByParent("Text", item, typeof(Text))
    CommonHelper:SetText("Text",item,des)

    local tween = self:GetChildWightByParent("Tween", item, typeof(TweenPosition))
    tween:ResetToBeginning()
    tween:PlayForward()

    local tweenalpha = self:GetChildWightByParent("Tween", item, typeof(TweenAlpha))
    tweenalpha:ResetToBeginning()
    tweenalpha:PlayForward()

    item:SetActive(true)
    local seqHandle = UnrealM.ActionSequenceHandle()
    seqHandle:Looper(2, nil):ActionInt(function(count)
        seqHandle:StopSequence()
        item:SetActive(false)
    end)
end

function CenterTipsView:AutoPlayWaiting()
    local result = {}
    for i = 1, __MaxShowCount do
        if self.WaitingList[1] then
            table.insert(result, self.WaitingList[1])
            table.remove(self.WaitingList, 1)
        end
    end
    for i = 1, #result do
        self:ShowTips(result[i])
    end

end

function CenterTipsView:OnBackKey()

end