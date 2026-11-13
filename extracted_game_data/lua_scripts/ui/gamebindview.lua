---@class GameBindView : ViewBase
GameBindView = class("GameBindView", ViewBase)

function GameBindView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "GameBindViewAction")

end

function GameBindView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function()
        UIManager:Get():HidePersistentView("Game4WDBindView")
    end)
    self.ServerListScroll = self:GetChildWightByParent("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function GameBindView:OnClose()

end

---@param msg SC_UserBindInfo
function GameBindView:SetData(msg,isdefault)
    self:StopTime()
   self.CurBind=PlayerDataManager:Get():GetBindData()
    if self.CurBind~=nil and self.CurBind.wdRid~=0 then
        CommonHelper:SetTextMesh("CurBind/###name",self.gameObject,self.CurBind.roleName)
        CommonHelper:SetTextMesh("CurBind/###servername",self.gameObject,CS.Nova.HotUpdateManager.Get():GetKpServerName(self.CurBind.serverId))
        local obj = self:GetChild("CurBind/prefab_ui_playerhead")
        CS.Nova.HotUpdateManager.Get():SetKpHead(obj,self.CurBind.headIcon,self.CurBind.iconFrame)
    else
        CommonHelper:SetTextMesh("CurBind/###name",self.gameObject,self.CurBind.roleName)
        CommonHelper:SetTextMesh("CurBind/###servername",self.gameObject,CS.Nova.HotUpdateManager.Get():GetKpServerName(self.CurBind.serverId))
        local obj = self:GetChild("CurBind/prefab_ui_playerhead")
        CS.Nova.HotUpdateManager.Get():SetKpHead(obj,self.CurBind.headIcon,self.CurBind.iconFrame)
    end
    CommonHelper:InitMoreRowScrollView(self.ServerListScroll, #msg.bindList, 1, function(index,item,view)
        local data=msg.bindList[index+1]
        CommonHelper:SetTextMesh("###name",item,data.roleName)
        CommonHelper:SetTextMesh("###servername",item,CS.Nova.HotUpdateManager.Get():GetKpServerName(data.serverId))
        local obj = UIUtil.GetChild("prefab_ui_playerhead",item)
        CS.Nova.HotUpdateManager.Get():SetKpHead(obj,data.headIcon,data.iconFrame)
        local btn=CommonHelper:HButtonSetCallback("HButton",item,function(hbtn)
            local data=msg.bindList[hbtn.intData]
            local boxFunc = function()
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, CommonHelper:GetTempStr_Default(TemplateStringID.BindHit,CS.Nova.HotUpdateManager.Get():GetKpServerName(data.serverId),data.roleName,PlayerDataManager:Get():GetPlayerName()))
                if ret == MessageBoxHelp.BtnType.OK then
                    PlayerInfoSubsystem:Get():SendMsg_ChangePlayerBind(data.wdRid)
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)

        end,index+1)
        local flag=self.CurBind~=nil and self.CurBind.wdRid~=0 and self.CurBind.wdRid==data.wdRid
        CommonHelper:SetGameObjectActive("hover", btn.gameObject,flag)
        CommonHelper:SetGameObjectActive("normal" , btn.gameObject,not flag)
    end)
    self.ExpTime=msg.expTime-CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    if self.ExpTime>0 then
        if self.ExpTime>0 then
            self.subTime = self.ExpTime
            self:UpdateTimer()
            self:SetTime(msg.expTime)
        else
            CommonHelper:SetTextMesh("###refreshtime",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.CanBind))
        end
    else
        CommonHelper:SetTextMesh("###refreshtime",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.NoBind))
    end
end

function GameBindView:SetTime()
    self.TimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
        if self.subTime <= 0 then
            TimerManager:Get():StopTimer(self.TimeId)
        end
        self.subTime= self.subTime-1
        self:UpdateTimer()
    end, self)
end
function GameBindView:UpdateTimer()
    local hour=math.modf( self.subTime/60/60)
    local minute=math.modf(( self.subTime-(hour*60*60))/60)
    local second=math.fmod( self.subTime,60)
    CommonHelper:SetTextMesh("###refreshtime",self.gameObject,
           CommonHelper:GetTempStr_Default(TemplateStringID.RefreshTimeBind,
                   hour, minute, second))
end
function GameBindView:StopTime()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId = nil
    end
end