---@class BattleExplainView
BattleExplainView = class("BattleExplainView", ViewBase)

function BattleExplainView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BattleExplainViewAction")

    print("---   BattleExplainView 初始化完成")
end

function BattleExplainView:Awake()
    self.isPlayingRoll = false

    self.explain = UIUtil.GetTypeChildWightByParent("###explain", self.gameObject, typeof(Text))

    self.tweenMoreGroup = UIUtil.GetTypeChildWightByParent("Top", self.gameObject, typeof(FXUITweenMoreGroup))

    CommonHelper:TMG_SetAllTweenCallBack(self.tweenMoreGroup, function()
        BattleDyDataManager:Get():RemoveLastMsg()
        self.isPlayingRoll = false
        self:ShowTips()
    end)
end

function BattleExplainView:ShowTips()
    if not BattleDyDataManager:Get():GetIsSelfFinished() then
        if not self.isPlayingRoll then
            local str = BattleDyDataManager:Get():GetLastExplain()
            UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_InitBattleExplain, BattleDyDataManager:Get():GetExplainState())
            if str ~= nil then
                CommonHelper:SetTextByGo(self.explain, str)
                self.isPlayingRoll = true
                CommonHelper:TMG_PlayAllTween(self.tweenMoreGroup)
           end
        end
    else
        UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_InitBattleExplain, BattleExplainState.Closed)
    end
end

function BattleExplainView:OnBackKey()

end