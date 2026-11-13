---@class BattleNewSystemView : ViewBase
BattleNewSystemView = class("BattleNewSystemView", ViewBase)

function BattleNewSystemView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BattleNewSystemViewAction")
end


function BattleNewSystemView:OnOpen()
    self:InitViewInfo()
end
function BattleNewSystemView:ReOpen()
    self:InitViewInfo()
end




--carId, curRank, rankIndex, toRank
function BattleNewSystemView:SetRank(rankInfo)
    if rankInfo[3] ~= rankInfo[4] then
        print("当前排名条和索引条不一致,有排名一致的情况-----", "rankIndex:", rankInfo[3], "toRank:", rankInfo[4])
    end
    self.page_battleRank:SetOneRank(rankInfo[1], rankInfo[3], rankInfo[4])
end

function BattleNewSystemView:UpdateScrollList(userdata)
    self.page_battleRank:UpdateScrollList(userdata)
end
function BattleNewSystemView:UpdateAccelerateBtnState(state,check)
    self.page_battleRank:UpdateAccelerateBtnState(state,self.gameObject,check or false)
end
function BattleNewSystemView:SkillCardCdFinish(idx)
    self.page_battleRank:SkillCardCdFinish(idx)
end

function BattleNewSystemView:UpdateProtectBtnState(state,check)
    self.page_battleRank:UpdateProtectBtnState(state,self.gameObject,check or false )
end

function BattleNewSystemView:UpdateRecoverState(state,check)
    self.page_battleRank:UpdateRecoverState(state,self.gameObject )
end

function BattleNewSystemView:RecoverCountDown(count)
    self.page_battleRank:RecoverCountDown(self,count )
end
function BattleNewSystemView:UpdateBattleList(type,id,opType,state,value,duration)
    self.page_battleRank:UpdateBuffList(type,id,opType,state,value,duration)
end
function BattleNewSystemView:SetBattleCostImage(type)
    self.page_battleRank:SetBattleCostImage(type)
end

function BattleNewSystemView:SetBeanCount()
    self.page_battleRank:SetBeanCount()
end
function BattleNewSystemView:PlayBeanEffect(param)
    self.page_battleRank:PlayBeanEffect(param)
end

function BattleNewSystemView:SetTalkContent(content,idx)
    self.page_battleRank:SetTalkContent(content,idx)
end

function BattleNewSystemView:InitChatList(chatType)
    self.page_battleRank:InitChatList(chatType)
end


function BattleNewSystemView:InitViewInfo()

    self.page_battleRank = Page_BattleBase()

    self.page_battleRank:CacheBaseData(self.gameObject, UIModuleID.Battle)

end

function BattleNewSystemView:OnFinishedBattle(finishedData)
    self.page_battleRank:OnBattleFinished(finishedData)
end

function BattleNewSystemView:InitBattleExplain(battleExplainState)
    self.page_battleRank:InitBattleExplainState(battleExplainState)
end
function BattleNewSystemView:OpenGameTools(flag)
    self.page_battleRank:OpenGameTools(flag)
end
function BattleNewSystemView:OpenBattleBreakButton(flag)
    self.page_battleRank:OpenBattleBreakButton(flag)
end
function BattleNewSystemView:ProtectStageStart(duration)
    self.page_battleRank:ProtectStageStart(duration)
end

function BattleNewSystemView:ClearData()
    self.page_battleRank:ResetRankGoData()
    self.page_battleRank:ClearRank()
    CommonHelper:UnloadCollectCurrency()
    CommonHelper:UnloadFlyPeasEffect()
end
function BattleNewSystemView:OnClose()
    if self.page_battleRank then
        self.page_battleRank:ResetIsInit()
    end
    CommonHelper:ReleasePool(UIModuleID.Battle)
end
function BattleNewSystemView:OnAutoClose()
    if self.page_battleRank then
        self.page_battleRank:ResetIsInit()
    end
end
function BattleNewSystemView:OnOpenAnimEnd()

end

function BattleNewSystemView:OnDisable()
    self.page_battleRank:SaveCameraData()
    self:ClearData()
end

function BattleNewSystemView:OnBackKey()

end