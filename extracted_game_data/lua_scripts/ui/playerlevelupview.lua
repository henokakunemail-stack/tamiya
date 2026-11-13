---@class PlayerLevelUpView : ViewBase
PlayerLevelUpView = class("PlayerLevelUpView", ViewBase)

function PlayerLevelUpView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PlayerLevelUpViewAction")
end

function PlayerLevelUpView:Awake()
    self:InitBtnFunc()
end

function PlayerLevelUpView:OnOpen()
   self:InitViewInfo()
end
function PlayerLevelUpView:OnClose()
    if self.guideId~=-1 then
        UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"GuideCheck",false})
        GuideManager:Get():Init(self.guideId,true)
        self:CheckNewBieGuide(nil,GuideTriggerType.LevelTrigger)
    else
        PopUpGiftDataManager:Get():DelayPopUpShow()
    end
    CommonHelper:ReleasePool(UIModuleID.PlayerLevelUp)
end

function PlayerLevelUpView:InitBtnFunc()
    CommonHelper:HButtonSetCallback("BtnCloseMask", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("ScrollVerticalMoreRow", self.gameObject, typeof(MoreRowScrollView))
end


function PlayerLevelUpView:InitViewInfo()

    local oldData = PlayerLevelUpDataManager:Get():GetOldData()

    CommonHelper:SetText("###UpLevelText", self.gameObject, PlayerDataManager:Get():GetPlayerLV())
    ---@type dictlevelup_config_cell
    local cell = CommonHelper:GetTableDataByID(ConfigNames.levelup_config, PlayerDataManager:Get():GetPlayerLV()-1)
    local ids = stringSplitToNumber(cell.awardids, ':')
    local nums = stringSplitToNumber(cell.awardnums, ':')
    local rewards={}
    for i = 1, #ids do
        local reward=RewardData()
        reward:SetDataIdNum(ids[i],nums[i])
        table.insert(rewards,reward)
    end
    local guideId,funcId,nextUnlockIdx,funcName,nextFuncName,NextLevel=PlayerDataManager:Get():CheckPlayerLevelUpGuide()
    self.guideId=guideId
    local func1 = CommonHelper:SetGameObjectActive("Func1", self.gameObject, #funcId > 0)
    local func2 = CommonHelper:SetGameObjectActive("Func2", self.gameObject, #nextUnlockIdx > 0)
    CommonHelper:SetText("###FuncNameText", func1.gameObject, funcName)
    CommonHelper:SetText("###FuncNameTextShadow", func1.gameObject, funcName)
    CommonHelper:SetText("###FuncNameText", func2.gameObject, nextFuncName)
    if NextLevel then
        CommonHelper:SetText("###title", func2.gameObject, NextLevel)
    end
    CommonHelper:InitMoreRowScrollView( self.ScrollView,#rewards,2,function(dataIndex, itemObj, scroll)
        local data=Param_PropParam()
        data.moduleId=UIModuleID.PlayerLevelUp
        data.count=rewards[dataIndex+1].num
        data.id=rewards[dataIndex+1].id
        data.showcount=true
        data.showname=false
        CommonHelper:SetPropGroup(itemObj,data)
        CommonHelper:HButtonSetCallback("BtnReward",itemObj,function(data)
            CommonHelper:ShowPartInfoByCfgId(data.intData,UIModuleID.PlayerLevelUp)
        end,data.id)
    end)



end

function PlayerLevelUpView:OnDisable()
    PlayerLevelUpDataManager:Get():SetIsUpgrade(false)
end

