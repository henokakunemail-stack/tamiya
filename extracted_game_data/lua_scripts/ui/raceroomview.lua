


---@class RaceRoomView : ViewBase
RaceRoomView = class("RaceRoomView", ViewBase)

function RaceRoomView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRoomViewAction")

    ---@type table<number, RaceRoomData>
    self.RoomList = {}

    self.MsgIdx = 0

    self.TogType = SerE_RaceRoomListType.All
end

function RaceRoomView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnHelp",self.gameObject,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceRoom)
    end)

    CommonHelper:HButtonSetCallback("BtnCreate",self.gameObject,function (hbtn)
        CommonHelper:CheckMini4wdRule(UIModuleID.RaceRoom,function()
            UIManager:Get():ShowPersistentView("RaceRoomCreateView",CanvasType.MainCanvas,"RaceRoomCreateView")
            -- UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_SetViewInfo,{"RaceRoomCreateView",true})
            UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_CreateViewAuto)
        end)



    end)

    CommonHelper:HButtonSetCallback("BtnQuickJoin",self.gameObject,function (hbtn)
        CommonHelper:CheckMini4wdRule(UIModuleID.RaceRoom,function()
            local value = PlayerPrefsHelper:GetValue_RaceRoomAutoReady()
            RaceRoomSubsystem:Get():SendMsg_JoinSelectedRoom(0,0)
        end)
    end)
    self.BtnSearch=CommonHelper:HButtonSetCallback("BtnSearch",self.gameObject,function (hbtn)
        CommonHelper:SetBtnDelayClick(self.BtnSearch, 1, false)
        local value = CommonHelper:GetInputFieldText("Input1/Input75", self.gameObject)
        if value ~= "" then RaceRoomSubsystem:Get():SendMsg_SearchRoom(tonumber(value)) end
    end)
   CommonHelper:HButtonSetCallback("BtnRefreshNext",self.gameObject,function (hbtn)
        self.MsgIdx = self.MsgIdx + 1

        RaceRoomSubsystem:Get():SendMsg_GetRoomList(self.TogType)
    end)
    self.BtnRefresh=  CommonHelper:HButtonSetCallback("BtnRefresh",self.gameObject,function (hbtn)
        CommonHelper:SetBtnDelayClick(self.BtnRefresh, 1, false)
        RaceRoomSubsystem:Get():SendMsg_GetRoomList(self.TogType)
    end)

    self.TogAll = CommonHelper:HButtonSetCallback("Tog1",self.gameObject,function (hbtn)
        self:ClickTog(SerE_RaceRoomListType.All)
    end)
    self.TogThree = CommonHelper:HButtonSetCallback("Tog2",self.gameObject,function (hbtn)
        self:ClickTog(SerE_RaceRoomListType.Three)
    end)
    self.TogFive = CommonHelper:HButtonSetCallback("Tog3",self.gameObject,function (hbtn)
        self:ClickTog(SerE_RaceRoomListType.Five)
    end)

    self.TogAutoSelect = CommonHelper:HButtonSetCallback("TogSelect",self.gameObject,function (hbtn)
        local value = (not PlayerPrefsHelper:GetValue_RaceRoomAutoReady())
        self:SetAutoFlag(value)
    end)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end
function RaceRoomView:ReOpen()
    CommonHelper:IsOpenMini4wdRuleView(UIModuleID.RaceRoom)
    if self:GetLuaViewInfo("RaceRoomCreateView") then
        UIManager:Get():ShowPersistentView("RaceRoomCreateView",CanvasType.MainCanvas,"RaceRoomCreateView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_SetViewInfo,{"RaceRoomCreateView",true})
    end
    if not RaceRoomManager:Get():IsInRoom() then
        self:ClickTog(SerE_RaceRoomListType.All, false)
    end
end
function RaceRoomView:OnOpen()
    CommonHelper:IsOpenMini4wdRuleView(UIModuleID.RaceRoom)
    self:SetAutoFlag(PlayerPrefsHelper:GetValue_RaceRoomAutoReady())
    CommonHelper:SetInputFieldText("Input1/Input75", self.gameObject,"")
    if not RaceRoomManager:Get():IsInRoom() then
        self:ClickTog(SerE_RaceRoomListType.All, false)
    end
end
function RaceRoomView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end
function RaceRoomView:OnAutoClose()
    self.RoomList={}
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
    CommonHelper:ReleasePool(UIModuleID.RaceRoom)
end


function RaceRoomView:OnClose()
    self.RoomList={}
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
    CommonHelper:ReleasePool(UIModuleID.RaceRoom)
end

---@param msg SC_RetSelfRoomList
function RaceRoomView:SetData(msg)
   -- self.MsgIdx = idx
    self.RoomList = {}
    for i = 1, #msg.roomlist do
        local data = RaceRoomData()
        data:SetSimpleData(msg.roomlist[i])
        table.insert(self.RoomList, data)
    end

    self:SetScrollView()
end

function RaceRoomView:SetAutoFlag(value)
    PlayerPrefsHelper:SetValue_RaceRoomAutoReady(value)
    CommonHelper:SetToggleState(self.TogAutoSelect, value)
end

function RaceRoomView:SetScrollView()
    local count= #self.RoomList <6 and 6 or  #self.RoomList
    CommonHelper:InitMoreRowScrollView(self.ScrollView, count, 3,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)

    CommonHelper:MoreRowView_EnterAniRace(self.ScrollView, 0.12)
end

function RaceRoomView:UpdateScrollView(dataIndex, itemObj)
    local data = self.RoomList[dataIndex + 1]

    local objunlock = CommonHelper:SetGameObjectActive("unlock", itemObj, data ~= nil)
    local objlock = CommonHelper:SetGameObjectActive("lock", itemObj, data == nil)

    if data then
        CommonHelper:SetText("###roomname", objunlock, data:GetName())
        local str = CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomPlayerLimit, data:GetJoinNum(), data:GetMaxNum())
        CommonHelper:SetText("###playernum", objunlock, str)

        if data:IsAllowObserver() then
            CommonHelper:SetText("obnum", objunlock, data:GetObserverNum())
        else
            CommonHelper:SetText("obnum", objunlock, CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomWatchNumNul))
        end

        CommonHelper:SetGameObjectActive("havepasswd", objunlock, data:IsHavePasswd())


        CommonHelper:GetComponentSetTrackIconByData("trackicon", objunlock, data:GetTrackData(), UIModuleID.RaceRoom)
        CommonHelper:SetGameObjectActive("TrackIcon_small", objunlock,not data:IsRandomTrack())
        CommonHelper:SetGameObjectActive("trackrandom", objunlock, data:IsRandomTrack())

        ---@type scene_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, data:GetSceneID())
        if cfg then CommonHelper:GetComponentSetUITexture("sceneicon",objunlock,cfg.icon,UIModuleID.RaceRoom) end


        CommonHelper:HButtonSetCallback("BtnJoin",objunlock,function (hbtn)
            CommonHelper:CheckMini4wdRule(UIModuleID.RaceRoom,function()
                self:ClickBtnJoin(data)
            end)
        end)
       local BtnOb= CommonHelper:HButtonSetCallback("BtnObserver",objunlock,function (hbtn)
            RaceRoomSubsystem:Get():SendMsg_ObserverSelectedRoom(data:GetLeaderID())
        end)
        CommonHelper:SetHButtonClick(BtnOb,data:GetLeaderID()~=0,true)
    end


end

---@param data RaceRoomData
function RaceRoomView:ClickBtnJoin(data)
    local passwd = data:GetPassword()
    if passwd == "" then
        self:JoinRoom(data, passwd)
    else
        UIManager:Get():OpenPopup("CommonInputView", CanvasType.FrontCanvas, "CommonInputView")
        local param = CommonInputViewParam()
        param.TitleName = CommonHelper:GetTempStr_Default(TemplateStringID.PleaseInputPassword)
        param.DefaultValue = ""
        param.Func = self.JoinRoom
        param.FuncClass = self
        param.FuncParam = data
        UINotify:Get():SendNotification(UINotifyEvent.CommonInputView_SetData, param)
    end
end

function RaceRoomView:ClickTog(type, ischeck)
    if ischeck == nil then ischeck = true end
    if ischeck and self.TogType == type then
        return
    end

    CommonHelper:SetToggleState(self.TogAll, type == SerE_RaceRoomListType.All)
    CommonHelper:SetToggleState(self.TogThree, type == SerE_RaceRoomListType.Three)
    CommonHelper:SetToggleState(self.TogFive, type == SerE_RaceRoomListType.Five)

    self.TogType = type
    RaceRoomSubsystem:Get():SendMsg_GetRoomList(type)
end

---@param param RaceRoomData
function RaceRoomView:JoinRoom(param, value)
    if value~=param:GetPassword() then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PasswordError))
    else
        RaceRoomSubsystem:Get():SendMsg_JoinSelectedRoom(param:GetID(), value, PlayerPrefsHelper:GetValue_RaceRoomAutoReady())
    end
end

function RaceRoomView:Refresh()
    RaceRoomSubsystem:Get():SendMsg_GetRoomList(self.TogType)
end

---@param msg SC_RetSearchSelf
function RaceRoomView:UpdateSearch(msg)
    if msg.selfroom~=nil then
        self.RoomList = {}
        local data = RaceRoomData()
        data:SetSimpleData(msg.selfroom)
        table.insert(self.RoomList, data)
        self:SetScrollView()
    end
    CommonHelper:SetInputFieldText("Input1/Input75", self.gameObject,"")
end