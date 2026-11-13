---@class TopLeftInfoView : ViewBase
TopLeftInfoView = class("TopLeftInfoView", ViewBase)

function TopLeftInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "TopLeftInfoViewAction")
end

function TopLeftInfoView:Awake()
    CommonHelper:HButtonSetCallback("PlayerIconBtn", self.gameObject, function(data)
        --SkipModuleHelper:Get():ToPlayerInfoView(SkipPlayerInfoView.PlayerInfo)
        --SkipModuleHelper:Get():ToPlayerInfoView(SkipPlayerInfoView.PersonalHome)
        PersonalHomeSubsystem:Get():SendLookHomeInfo(PlayerDataManager:Get():GetPlayerRID())
    end)

    CommonHelper:HButtonSetCallback("BtnExp", self.gameObject, function(data)
        UIManager:Get():ShowPersistentView("PlayerLevelRewardView",CanvasType.FrontCanvas,"PlayerLevelRewardView")
    end)
    self.Page_PlayerSampleInfo = self:GetChild("Page_PlayerSampleInfoView")
    self.Page_PlayerSampleInfoView = PagePlayerSampleInfoView(self.Page_PlayerSampleInfo, UIModuleID.Top)
end

function TopLeftInfoView:OnOpen()
    self:SetExp()
    --self:SetLv()
    --self:SetPlayerIcon()
    --self:SetName()
    self.Page_PlayerSampleInfoView:Refresh(PlayerSampleInfoDataManager:Get():GetSelfSampleInfo(),true)
end

function TopLeftInfoView:SetExp()
    local lv = PlayerDataManager:Get():GetPlayerLV()
    ---@type levelup_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.levelup_config, lv)

    local nextCfg = CommonHelper:GetTableDataByID(ConfigNames.levelup_config, lv + 1)

    local totalExp = nextCfg == nil and 99999 or cfg.needexp

    local curExp = PlayerDataManager:Get():GetPlayerEXP()
    if nextCfg == nil and curExp >= totalExp then
        curExp = 99999
        totalExp = 99999
    end

    CommonHelper:SetSlider("ExpSlider", self.gameObject, curExp / totalExp)
    CommonHelper:SetText("###nextExpText", self.gameObject, tostring(totalExp - curExp))
end

function TopLeftInfoView:SetLv()
    --local lv = PlayerDataManager:Get():GetPlayerLV()
    --CommonHelper:SetText("###LabLV", self.gameObject, tostring(lv))
    self.Page_PlayerSampleInfoView:Refresh(PlayerSampleInfoDataManager:Get():GetSelfSampleInfo(),true)
end
function TopLeftInfoView:CloseAllUI(flag)
    UIUtil.ShowCanvasGroupByName("Top", self.gameObject, flag)
end
function TopLeftInfoView:SetName()
    --local name = PlayerDataManager:Get():GetPlayerName()
    --CommonHelper:SetText("###playerNameText", self.gameObject, tostring(name))
    self.Page_PlayerSampleInfoView:Refresh(PlayerSampleInfoDataManager:Get():GetSelfSampleInfo(),true)
end

function TopLeftInfoView:SetPlayerIcon()
    self.Page_PlayerSampleInfoView:Refresh(PlayerSampleInfoDataManager:Get():GetSelfSampleInfo(),true)
    --print("/*/-/-*/-/-*/-//-*",PlayerDataManager:Get():GetPlayerIcon(), PlayerDataManager:Get():GetPlayerIconFrame())
    --CommonHelper:SetPlayerIconById("PlayerIcon148", self.gameObject, PlayerDataManager:Get():GetPlayerIcon(), PlayerDataManager:Get():GetPlayerIconFrame(), nil, UIModuleID.Top)
end

function TopLeftInfoView:OnClose()
    self.Page_PlayerSampleInfoView:Clear()
end
