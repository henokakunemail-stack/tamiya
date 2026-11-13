---@class  FriendListView : ViewBase
FriendListView = class("FriendListView", ViewBase)

function FriendListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "FriendListViewAction")
end

function FriendListView:Awake()
    self:CacheBaseData()
    self:InitFriendViewBtn()
end

function FriendListView:OnOpen()
    self.togIdx = nil
    self:InitTogState(true, false, false, false, 1)
end

function FriendListView:ReOpen()
    self.togIdx = nil
    self:InitTogState(true, false, false, false, 1, function()
        self:InitFriendInfo(FriendManagerType.Friend)
    end)
    if self:GetLuaViewInfo("BlackView") then
        UIManager:Get():OpenPopup("FriendBlackListView", CanvasType.MainCanvas, "FriendBlackListView")
    end
end

function FriendListView:CacheBaseData()
    self.FriendListScrollView = self:GetChildWight("FriendList", typeof(MoreRowScrollView))

    self.FriendListCanvas = self:GetChildWight("FriendListCanvas", typeof(CanvasGroup))
    self.FriendAddCanvas = self:GetChildWight("FriendAddCanvas", typeof(CanvasGroup))
    self.FriendApplyCanvas = self:GetChildWight("FriendApplyCanvas", typeof(CanvasGroup))
    self.FriendRentAndLendCanvas = self:GetChildWight("FriendRentAndLendCanvas", typeof(CanvasGroup))

    self.SearchInputField = self:GetChildWight("Input75", typeof(InputField))
    self.DropDown = self:GetChildWight("DropDown_H", typeof(UIDropDown))
    self.SortPanelDropDown = self:GetChildWight("SortPanel", typeof(UIDropDown))

    self.togIdx = nil
end

----初始话界面信息
function FriendListView:InitFriendViewBtn()

    self:InitFriendListBtn()
    self:InitFriendAddBtn()
    self:InitFriendApplyBtn()
    self:InitRentAndLendBtn()

    self.TogFriendList = CommonHelper:HButtonSetCallback("TogFriendList", self.gameObject, function(data)
        self:InitTogState(true, false, false, false, 1, function()
            print("好友  还有  好友")
            FriendSubsystem:Get():SendMsg_GetAllFriends()
            FriendDataManager:Get():SetFriendType(FriendType.Init)
        end)
    end)

    self.TogAddFriend = CommonHelper:HButtonSetCallback("TogAddFriend", self.gameObject, function(data)
        self:InitTogState(false, true, false, false, 2, function()
            FriendSubsystem:Get():SendMsg_GetRecommend()
            -- FriendSubsystem:Get():SendMsg_RecommendFriends(FriendRecommendRequestType.Recommend)
        end)
    end)

    self.TogApplyFriend = CommonHelper:HButtonSetCallback("TogApplyFriend", self.gameObject, function(data)
        self:InitTogState(false, false, true, false, 3, function()
            FriendSubsystem:Get():SendMsg_RequestFriends()
            --FriendSubsystem:Get():SendMsg_RecommendFriends(FriendRecommendRequestType.Request)
        end)
    end)

    self.TogRentAndLend = CommonHelper:HButtonSetCallback("TogRentAndLend", self.gameObject, function(data)
        self:InitTogState(false, false, false, true, 4, function()
            FriendDataManager:Get():SetFriendType(FriendType.Init)
            local friendType = FriendDataManager:Get():GetFriendType()
            if friendType == FriendType.Init then
                UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.RentAndLend)
            end
        end)
    end)

    self. BtnBack = CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(data)
        UIManager:Get():CloseView()
    end)
end

function FriendListView:InitTogState(TogFriendList, TogAddFriend, TogApplyFriend, TogRentAndLend, clickTogIdx, func)

    if self.togIdx ~= clickTogIdx then
        CommonHelper:SetToggleState(self.TogFriendList, TogFriendList)
        CommonHelper:SetToggleState(self.TogAddFriend, TogAddFriend)
        CommonHelper:SetToggleState(self.TogApplyFriend, TogApplyFriend)
        CommonHelper:SetToggleState(self.TogRentAndLend, TogRentAndLend)

        UIUtil.ShowCanvasGroup(self.FriendListCanvas, TogFriendList)
        UIUtil.ShowCanvasGroup(self.FriendAddCanvas, TogAddFriend)
        UIUtil.ShowCanvasGroup(self.FriendApplyCanvas, TogApplyFriend)
        UIUtil.ShowCanvasGroup(self.FriendRentAndLendCanvas, TogRentAndLend)

        if func then
            func()
        end
        self.togIdx = clickTogIdx
    end

    --print("TTTTT FFFFF -----", VersionManager:Get():GetServerFunctionIsFlag(CdnFunctionKey.RentAndLend))
    CommonHelper:SetGameObjectActive("TogRentAndLend", self.gameObject, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Rent) or HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Lend))
    if HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Rent) and HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Lend) then
          CommonHelper:SetText("hover/###text",self.TogRentAndLend.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLend))
          CommonHelper:SetText("tweennormal/###text",self.TogRentAndLend.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLend))
    elseif HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Rent) and HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Lend)==false then
        CommonHelper:SetText("hover/###text",self.TogRentAndLend.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.Rent))
        CommonHelper:SetText("tweennormal/###text",self.TogRentAndLend.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.Rent))
    elseif HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Rent)==false and HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Lend) then
        CommonHelper:SetText("hover/###text",self.TogRentAndLend.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.Lend))
        CommonHelper:SetText("tweennormal/###text",self.TogRentAndLend.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.Lend))
    end
    --CommonHelper:SetGameObjectActive("TogRentAndLend", self.gameObject, false)

end

---@param friendData FriendData
function FriendListView:OnChatBtnClick(friendData)
    UIManager:Get():CloseView()
    UIManager:Get():ShowPersistentView("ChatView", CanvasType.MainCanvas, "ChatView")
    local userdata = {}
    userdata.chatType = ChatType.Private
    userdata.playerId = friendData:GetPlayerId()

    ChatDataManager:Get():SetCurSelectPrivateId(friendData:GetPlayerId())
    UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitTogState, ChatType.Private)--先打开私聊面板，加载私聊数据，再更新玩家数据



    local chatPlayerData = ChatPlayerData()
    chatPlayerData:SetDataByFriendData(friendData)
    ChatDataManager:Get():AddPlayerData(chatPlayerData)--这个时候要刷新玩家数据的--

    UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitPrivateList, chatPlayerData:GetPlayerId())

    --UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitChatScrollList, userdata)
end

function FriendListView:InitFriendInfo(friendManagerType)
    self.awaitMsg = nil
    local isRefresh = false
    self:InitRedPointInfo()

    if friendManagerType == FriendManagerType.Friend then
        self:InitFriendListInfo()
        isRefresh = self.togIdx==1
    elseif friendManagerType == FriendManagerType.AddFriend or friendManagerType == FriendManagerType.SearchList then
        self:InitAddFriendInfo(friendManagerType)
        isRefresh = self.togIdx==2
    elseif friendManagerType == FriendManagerType.Request then
        self:InitApplyFriendInfo()
        isRefresh = self.togIdx==3
    elseif friendManagerType == FriendManagerType.RentAndLend then
        self:InitRentAndLendInfo()
        UINotify:Get():SendNotification(UINotifyEvent.FriendListView_RefreshRentHaveInfo)
        isRefresh = self.togIdx==4
    end
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendList,{friendManagerType,isRefresh} )

end

function FriendListView:OnClose()
    self.togIdx = nil
    CommonHelper:ReleasePool(UIModuleID.Friend)
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_ClearLuaViewInfo)
end
