---@class SelectServerView : ViewBase
SelectServerView = class("SelectServerView", ViewBase)

function SelectServerView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelectServerViewAction")
end

function SelectServerView:Awake()
    self:CacheServerViewData()
    self:InitServerViewBtn()
end

function SelectServerView:CacheServerViewData()
    self.Center = self:GetChild("Center")
    self.ServerListScroll = self:GetChildWightByParent("ServerList", self.Center, typeof(MoreRowScrollView))
end

function SelectServerView:InitServerViewBtn()
    CommonHelper:HButtonSetCallback("EnsureBtn", self.Center, function(data)
        local serverInfo= ClientDataManager:Get():GetServerInfoByServerId(self.serverId)
        if serverInfo:GetStatus()==ServerStatus.Hot and serverInfo:GetRid()==0 then
            CommonTipsHelper:Get():ShowCenterTips(TemplateStringID.ServerHotNoEnter)
            return
        end
        UIManager:Get():ClosePopup()
        PlayerPrefsHelper:SetValue_LoginServerId(self.serverId)
        if serverInfo ~= -1 then
            UINotify:Get():SendNotification(UINotifyEvent.GameStartView_UpdateServerInfo, serverInfo)
            UINotify:Get():SendNotification(UINotifyEvent.UpdateServerInfo, serverInfo)
        end
    end)
end

function SelectServerView:OnOpen()
    QuickTa:Get():TrackEvent(TrackEventNames.SelectServer, nil,TrackEventType.First,AnalysisType.SelectServer)
end
function SelectServerView:SetData(id)
    self.serverId = id
    self:InitServerList()
    self:InitViewInfo()
end


function SelectServerView:InitViewInfo()
    local serverInfo = ClientDataManager:Get():GetServerInfoByServerId(ClientDataManager:Get():GetLastServer())
    if serverInfo == nil then
        CommonHelper:SetText("###lastLoginText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankNoRank))
    else
        CommonHelper:SetText("###lastLoginText", self.gameObject, serverInfo:GetName())
    end
end

function SelectServerView:InitServerList()
    ---@type ServerInfo[]
    local serverList={}
    for i = 1, #ClientDataManager:Get():GetServerList() do
        --if ClientDataManager:Get():GetServerList()[i]:GetStatus()~=ServerStatus.Hot then
            table.insert(serverList,ClientDataManager:Get():GetServerList()[i])
        --else
        --    if ClientDataManager:Get():GetServerList()[i]:GetRid()~=0 then
        --        table.insert(serverList,ClientDataManager:Get():GetServerList()[i])
        --    end
        --end

    end
    print("------>>>",serverList[1]:GetServerId())
    local temp=nil
    for i = 1, #serverList do
        if serverList[i]:GetServerId()==ClientDataManager:Get():GetLastServer() then
            temp=serverList[i]
            table.remove(serverList,i)
            break
        end
    end

    local recommend=nil
    for i = 1, #serverList do
        if  serverList[i]:GetRecommend()==1 then
            recommend=serverList[i]
            table.remove(serverList,i)
            break
        end
    end
    if temp then
        table.insert(serverList,1,temp)
    end
    if recommend then
        table.insert(serverList,1,recommend)
    end
    print("------>>>",serverList[1]:GetServerId())
    local lastSelectImage = nil
    local lastSelectText = nil
    local updateFunc = function(dataIndex, itemObj, scroll)
        ---@type ServerInfo
        local serverInfo = serverList[dataIndex + 1]
        local serverNameText = CommonHelper:SetText("###ServerNameText", itemObj, serverInfo:GetName())
        local SelfBgImage = CommonHelper:SetGameObjectActive("select", itemObj, self.serverId == serverInfo:GetServerId())
       CommonHelper:SetGameObjectActive("player", itemObj, serverInfo:GetRid()>0)
        CommonHelper:SetTextColor(serverNameText, self.serverId == serverInfo:GetServerId() and "FFFFFF" or "000000")
        if self.serverId == serverInfo:GetServerId() and lastSelectImage == nil then
            lastSelectImage = SelfBgImage
            lastSelectText = serverNameText
        end

        CommonHelper:HButtonSetCallback("itemBtn", itemObj, function(param)
            local serverInfo=serverList[param.intData + 1]
            if serverInfo:GetStatus()==ServerStatus.Hot and serverInfo:GetRid()==0 then
                CommonTipsHelper:Get():ShowCenterTips(TemplateStringID.ServerHotNoEnter)
                return
            end
            if lastSelectImage and lastSelectImage ~= SelfBgImage then
                CommonHelper:CSGameObjectSetActive(lastSelectImage, false)
                CommonHelper:SetTextColor(lastSelectText, "000000")
            end
            CommonHelper:CSGameObjectSetActive(SelfBgImage, true)
            CommonHelper:SetTextColor(serverNameText, "ffffff")
            lastSelectImage = SelfBgImage
            lastSelectText = serverNameText
            self.serverId = serverInfo:GetServerId()
            if serverInfo:GetStatus() == ServerStatus.Maintain then
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ServerIsMaintaining))
            end
        end,dataIndex)


        local re=ClientDataManager:Get():GetRecommendServer()

        if serverInfo:GetRecommend() ~=1 then
            CommonHelper:SetServerStatus("login_server_item", itemObj, serverInfo:GetStatus())
        else
            CommonHelper:SetServerStatus("login_server_item", itemObj, -1)
        end

       --- CommonHelper:SetServerStatus("login_server_item", itemObj, serverInfo:GetStatus())
        CommonHelper:SetGameObjectActive("serverstate4",itemObj,serverInfo:GetRecommend()==1)
    end
    CommonHelper:InitMoreRowScrollView(self.ServerListScroll, #serverList, 2, updateFunc, true)
end



