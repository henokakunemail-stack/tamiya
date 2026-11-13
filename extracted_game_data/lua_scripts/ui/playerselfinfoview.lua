---@class PlayerSelfInfoView : ViewBase
PlayerSelfInfoView = class("PlayerSelfInfoView", ViewBase)

-- View必加
function PlayerSelfInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PlayerSelfInfoViewAction")
end
local _CurPage=nil
function PlayerSelfInfoView:Awake()
    self.PlayerInfoView = self:GetChildWight("PlayerInfoView", typeof(CanvasGroup))
    self.RankHistoryView = self:GetChildWight("HistoryView", typeof(CanvasGroup))
    self.SettingView = self:GetChildWight("SettingView", typeof(CanvasGroup))
    self.Playerinfo  = self:GetChild("Page_Playerinfo")
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function(data)
       UIManager:Get():CloseView()
    end)
    self.TogPlayerInfo = CommonHelper:HButtonSetCallback("TogPlayerInfo",self.gameObject,function(data)
        if _CurPage~=SkipPlayerInfoView.PlayerInfo then
            UINotify:Get():SendNotification(UINotifyEvent.PlayerSelfInfoViewUpdateTog,{SkipPlayerInfoView.PlayerInfo})
        end
    end)

    self.TogRankHistory =  CommonHelper:HButtonSetCallback("TogHistory",self.gameObject,function(data)
        if _CurPage~=SkipPlayerInfoView.RankHistory then
            UINotify:Get():SendNotification(UINotifyEvent.PlayerSelfInfoViewUpdateTog,{SkipPlayerInfoView.RankHistory})
        end
    end)
    self.TogSetting =  CommonHelper:HButtonSetCallback("TogSetting",self.gameObject,function(data)
        if _CurPage~=SkipPlayerInfoView.Setting then
            UINotify:Get():SendNotification(UINotifyEvent.PlayerSelfInfoViewUpdateTog,{SkipPlayerInfoView.Setting})
        end

    end)
    self.TogEnable=CommonHelper:HButtonSetCallback("TogEnableTrue",self.gameObject,function(data)
        self.isEnable=not self.isEnable
        self:SetTogPlayerInfo()
        CommonHelper:Tween_Position(self.Playerinfo,Vector3(775,0,0),Vector3(0,0,0),0.16)
    end)
    self.TogEnableFalse=CommonHelper:HButtonSetCallback("TogEnableFalse",self.gameObject,function(data)
        self.isEnable=not self.isEnable
        self:SetTogPlayerInfo()
        CommonHelper:Tween_Position(self.Playerinfo,Vector3(0,0,0),Vector3(775,0,0),0.08)
    end)
end
function PlayerSelfInfoView:SetTogPlayerInfo()
    CommonHelper:SetGameObjectActive("TogEnableTrue",self.gameObject, self.isEnable)
    CommonHelper:SetGameObjectActive("TogEnableFalse",self.gameObject,not self.isEnable)
   -- CommonHelper:CSGameObjectSetActive(self.Playerinfo,self.isEnable)
end


function PlayerSelfInfoView:OnOpen()
    --CommonHelper:Tween_Position(self.Playerinfo,Vector3(775,0,0),Vector3(0,0,0),0.16,0.2)
end

function PlayerSelfInfoView:OnClose()
    if   self.PageSettingObj then
        self.PageSettingObj:SaveSetting()
    end
    if self.PagePlayerinfo then
        self.PagePlayerinfo:OnClose()
    end
    CommonHelper:ReleasePool(UIModuleID.PlayerInfo)
end

function PlayerSelfInfoView:UpdateTog(type,param)
        if (type==SkipPlayerInfoView.Setting or SkipPlayerInfoView.RankHistory) and self.PagePlayerinfo then
            self.PagePlayerinfo:OnClose()
        end
      _CurPage=type
      CommonHelper:SetToggleState(self.TogPlayerInfo,type==SkipPlayerInfoView.PlayerInfo)
      CommonHelper:SetToggleState(self.TogRankHistory,type==SkipPlayerInfoView.RankHistory)
      CommonHelper:SetToggleState(self.TogSetting,type==SkipPlayerInfoView.Setting)
      UIUtil.ShowCanvasGroup(self.PlayerInfoView,type==SkipPlayerInfoView.PlayerInfo)
      UIUtil.ShowCanvasGroup(self.RankHistoryView,type==SkipPlayerInfoView.RankHistory)
      UIUtil.ShowCanvasGroup(self.SettingView,type==SkipPlayerInfoView.Setting)
      UINotify:Get():SendNotification(UINotifyEvent.PlayerSelfInfoViewSetData,{type,param})
      CommonHelper:SetGameObjectActive("bigMask",self.gameObject,type~=SkipPlayerInfoView.PlayerInfo)
end

function PlayerSelfInfoView:SetData(type,param)
    if type==SkipPlayerInfoView.Setting then
       self:OpenSettingView(param)
    elseif type==SkipPlayerInfoView.RankHistory then
       self:HistoryViewSetData(param)
    elseif  type==SkipPlayerInfoView.PlayerInfo then
       self:PlayerInfoViewSetData(param)
    end
end
--{{{  设置面板
function PlayerSelfInfoView:OpenSettingView(param)
    --CommonHelper:SetText("Title1/title1",self.gameObject,ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerViewTitle1_Setting))
    --
    --if self.PageSetting == nil then
    --    PrefabCacheMgr:Get():SwapPrefabAsync("Page_PlayerinfoSetting.prefab", nil, nil, function(data, obj)
    --        self.PageSetting = obj
    --        UIUtil.SetParentTransform(self.SettingView,self.PageSetting,true,true)
    --        self.PageSettingObj = PagePlayerInfoSetting()
    --        self.PageSettingObj:SetData(self.PageSetting)
    --        self.PageSettingObj:SettingViewSetData(param)
    --    end)
    --else
    --    self.PageSettingObj:SettingViewSetData(param)
    --end
end
--}}}
--{{{ 玩家信息
function PlayerSelfInfoView:PlayerInfoViewSetData()
  --  CommonHelper:SetText("Title1/title1",self.gameObject,ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerViewTitle1_PlayerInfo))
    self.isEnable=false
    self:SetTogPlayerInfo()
    if self.PagePlayerinfo == nil then
        --PrefabCacheMgr:Get():SwapPrefabAsync("Page_Playerinfo.prefab", nil, nil, function(data, obj)
        --    self.Playerinfo = obj
        --    UIUtil.SetParentTransform(self.PlayerInfoView,self.Playerinfo,true,true)
            self.PagePlayerinfo = PagePlayerInfoRoleInfo()
            self.PagePlayerinfo:SetData(self.Playerinfo)
            self.PagePlayerinfo:RoleInfoSetData()
       -- end)
    else
        self.PagePlayerinfo:RoleInfoSetData()
    end

    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    HomeSceneHelper:SetRoleInfo(port)
end
function PlayerSelfInfoView:SetSign(sign)
        self.PagePlayerinfo:SetSign(sign)
end

function PlayerSelfInfoView:SetName(name)
        self.PagePlayerinfo:SetName(name)
end

function PlayerSelfInfoView:UpdatePlayerIcon()
        self.PagePlayerinfo:UpdatePlayerIcon()
end


--}}}
--{{{ 参赛历史
function PlayerSelfInfoView:HistoryViewSetData(param)
   -- CommonHelper:SetText("Title1/title1",self.gameObject,ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerViewTitle1_RankHistory))
end
--}}}
