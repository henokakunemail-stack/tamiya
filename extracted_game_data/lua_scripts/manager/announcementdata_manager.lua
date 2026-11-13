---@class AnnouncementDataManager
AnnouncementDataManager =class("AnnouncementDataManager")
function AnnouncementDataManager:Get()
    if self._instance==nil then
        self._instance=AnnouncementDataManager()
    end
    return self._instance
end
function AnnouncementDataManager:initialize()
    self.isMaintain=false
end
--
function AnnouncementDataManager:OnInit(data)
    self.announcementList={}
    self.announcementDic={}
   -- self:ReadLocalAnnouncementData()

    self:ParseAnnouncementData(data)
    self:SortAnnouncement()
    --if not CommonHelper:CheckPlayerIsNewGuide() or ClientDataManager:Get():GetGameState()~=GameState.Login_GameServer then
    --    UIManager:Get():ShowPersistentView("AnnouncementView",CanvasType.FrontCanvas,"AnnouncementView",false)
    --    UINotify:Get():SendNotification(UINotifyEvent.AnnouncementViewOpen)
    --end


    if ClientDataManager:Get():GetGameState() ~= GameState.Login_GameServer then
        FunctionSkipManager:Get():SkipToFunction(GameFunction.ActProclamation, { 1, 1 })
    elseif ClientDataManager:Get():GetGameState() == GameState.Login_GameServer and not CommonHelper:CheckPlayerIsNewGuide() then
        FunctionSkipManager:Get():SkipToFunction(GameFunction.ActProclamation, { 1, 2 })
    end



    --if self.isMaintain then
    --    if self.announcementDic[IsMaintain]~=nil then
    --        UINotify:Get():SendNotification(UINotifyEvent.GameStartView_ServerMaintain,self.announcementDic[IsMaintain].content)
    --    else
    --        UINotify:Get():SendNotification(UINotifyEvent.GameStartView_ServerMaintain)
    --    end
    --else
    --    if UIManager:Get():IsViewShow(CommonHelper:GetMainMenuViewName()) then
    --        UIManager:Get():OpenPopup("AnnouncementView",CanvasType.FrontCanvas,"AnnouncementView",true)
    --        UINotify:Get():SendNotification(UINotifyEvent.AnnouncementViewOpen)
    --    end
    --end
end
---@ param data SC_SysPubInfo
function AnnouncementDataManager:ParseAnnouncementData(data)
    if data.infos then
        for i = 1, #data.infos do
            local v=data.infos[i]
            local temp=AnnouncementData()
            temp:SetNetData(v)
            if temp.tag~=IsMaintain then
                table.insert(self.announcementDic,temp)
            else
                self.announcementDic[IsMaintain]=temp
            end
        end
    end
end
function AnnouncementDataManager:ReadLocalAnnouncementData()
    self.localAnnouncementMsg={}
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.announcement_config)
    for k,v in pairs(cfg.GetConfigData()) do
        local temp=AnnouncementData()
        temp:SetData(v.C_ID)
        if temp:CheckInfoIsExpired() then
            table.insert(self.announcementDic,temp)
        end
    end
end
function AnnouncementDataManager:SortAnnouncement()
    for k,v in pairs(self.announcementDic) do
        if CommonHelper:GetNowTime()<CommonHelper:ConvertIntToDataTime(v.endTime) then
            table.insert(self.announcementList,v)
        end
    end
    table.sort(self.announcementList,function(a, b)
        return a.sortWeight>b.sortWeight
    end)
end
function AnnouncementDataManager:GetAnnouncementList()
    return self.announcementList
end

---@class AnnouncementData
AnnouncementData=class("AnnouncementData")
function AnnouncementData:initialize()
    self.id=nil
    self.title=nil
    self.content=nil
    self.sortWeight=-1
    self.tag=-1
    self.picture="-1"
    self.rewards=nil
    self.startTime=0
    self.endTime=0
    self.sender=""
end
function AnnouncementData:SetData(id)
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.announcement_config,id)
    self.id=cfg.id
    self.title=cfg.title
    self.content=cfg.content
    self.tag=cfg.sort
    self.sortWeight=cfg.weights
    self.type=cfg.type
    self.picture=cfg.picture
    self.rewards=CommonHelper:ParseToReward3(cfg.reward)
    self.startTime=CommonHelper:UnixTimeConvertTime(cfg.startTime)
    self.endTime=CommonHelper:UnixTimeConvertTime(cfg.endTime)
end
---@param data SC_pubinfo
function AnnouncementData:SetNetData(data)
    self.id =data.pubid
    self.title = data.title
    self.content = data.content
    self.tag = data.pubtag
    self.sender=data.sender
    self.startTime=data.createtime
    self.endTime=data.endtime
    self.sortWeight=data.sort
end
function AnnouncementData:CheckInfoIsExpired()
    return  CSDateTime.Compare(CommonHelper:GetNowTime(),self.endTime) <0
end
