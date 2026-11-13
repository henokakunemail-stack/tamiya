---@class ServerInfoView : ViewBase
ServerInfoView = class("ServerInfoView", ViewBase)

function ServerInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ServerInfoViewAction")
end

function ServerInfoView:Awake()
    self:CacheInfoViewData()
    self:InitInfoViewBtn()
end

function ServerInfoView:CacheInfoViewData()
    self.Center = self:GetChild("Center")
    self.ServerListScroll = self:GetChildWightByParent("ServerList", self.Center, typeof(MoreRowScrollView))
    self.serverInfo = ServerInfo()
end

function ServerInfoView:InitInfoViewBtn()
    CommonHelper:HButtonSetCallback("BtnClose", self.Center, function(param)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("SelectServerBtn", self.Center, function(data)
        UIManager:Get():OpenPopup("SelectServerView", CanvasType.FrontCanvas, "SelectServerView", true)
        UINotify:Get():SendNotification(UINotifyEvent.SetSelectServerInfo,self.serverInfo:GetServerId())
    end)
    CommonHelper:HButtonSetCallback("EnterGameBtn", self.Center, function(data)
        self:OnEnterGameBtnClick()
    end)
end

function ServerInfoView:OnOpen()
    self:InitServerInfo()
end

function ServerInfoView:InitServerInfo()
    self.serverInfo:SetServerId(ClientDataManager:Get():GetLastServer())
    if  CommonHelper:IsNullOrEmpty(tostring(self.serverInfo:GetServerId())) then
        self.serverInfo=ClientDataManager:Get():GetRecommendServer()
    else
        local gameServerInfo = ClientDataManager:Get():GetServerInfoByServerId(self.serverInfo:GetServerId())
        if gameServerInfo  and tonumber(self.serverInfo:GetServerId()) == gameServerInfo:GetServerId() then
            self.serverInfo = gameServerInfo
        else
            self.serverInfo:SetName(CommonHelper:GetTempStr_Default(TemplateStringID.PleaseSelectServer))
        end
    end
    if self.serverInfo==nil then
        self.serverInfo=ClientDataManager:Get():GetFirstServer()
    end
    self:InitServerData(self.serverInfo)
end
---@param serverInfo ServerInfo
function ServerInfoView:InitServerData(serverInfo)
    self.serverInfo = serverInfo
    CommonHelper:SetText("###serverName", self.gameObject, serverInfo:GetName())

    local re=ClientDataManager:Get():GetRecommendServer()

    if re and re:GetServerId()~=serverInfo:GetServerId() then
        CommonHelper:SetServerStatus("serverstate", self.gameObject, serverInfo:GetStatus())
    else
        CommonHelper:SetServerStatus("serverstate", self.gameObject, -1)
    end
    if serverInfo:GetStatus()~=ServerStatus.Normal then
        CommonHelper:SetServerStatus("serverstate", self.gameObject, serverInfo:GetStatus())
        CommonHelper:SetGameObjectActive("serverstate4",self.gameObject,false)
    else
        CommonHelper:SetGameObjectActive("serverstate4",self.gameObject,re~=nil and re:GetServerId()==serverInfo:GetServerId())
    end


end

function ServerInfoView:OnEnterGameBtnClick()
    if CommonHelper:IsNullOrEmpty(self.serverInfo:GetServerId()) then
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PleaseSelectServer))
    else
       -- if self.serverInfo:GetStatus() == ServerStatus.Normal then
            PlayerPrefsHelper:SetValue_LoginServerId( self.serverInfo:GetServerId())
            ClientDataManager:Get():SetPId(self.serverInfo:GetRid())
            ClientDataManager:Get():SetIsNew(self.serverInfo:GetIsNew())
            LoginFuncHelper:ContentGameServer(self.serverInfo:GetIp(),self.serverInfo:GetPort())
            UIManager:Get():ClosePopup()
       -- else
         --   CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ServerIsMaintaining))
       -- end
    end
end

