---@class RaceRoomDetailView : ViewBase
RaceRoomDetailView = class("RaceRoomDetailView", ViewBase)

function RaceRoomDetailView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRoomDetailViewAction")
end
local ChangeCar=false
function RaceRoomDetailView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        if RaceRoomManager:Get():IsLeader() then
            local boxfunc = function()
                local str = CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomRemoveAsk)
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, str)
                if ret == MessageBoxHelp.BtnType.OK then
                    RaceRoomSubsystem:Get():SendMsg_Leave()
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
        else
            RaceRoomSubsystem:Get():SendMsg_Leave()
        end

    end)

    self.BtnInvite = CommonHelper:HButtonSetCallback("BtnInvite", self.gameObject, function(hbtn)
        if RaceRoomManager:Get():IsLeader() then
            CommonHelper:CloseShareInviteView()
            FriendDataManager:Get():SetFriendType(FriendType.RoomInvite)
            FriendSubsystem:Get():SendMsg_GetAllFriends()
        end

    end)

    self.BtnShare = CommonHelper:HButtonSetCallback("BtnShare", self.gameObject, function(hbtn)
        local data = RaceRoomManager:Get():GetTrackData()
        if RaceRoomManager:Get():IsLeader() then
            local userdata = {
                id = RaceRoomManager:Get():GetID(),
                joinNum = RaceRoomManager:Get():GetJoinNum(),
                maxNum = RaceRoomManager:Get():GetMaxNum(),
                name = RaceRoomManager:Get():GetName(),
                pwd = tostring(RaceRoomManager:Get():IsHavePasswd()),
                mapIcon =  data.icon
            }
            CommonHelper:CloseShareInviteView()
            CommonHelper:ShareToChat(ShareType.RoomInvite, userdata)
        end

    end)

    --self.BtnRevise = CommonHelper:HButtonSetCallback("BtnReserve", self.gameObject, function(hbtn)
    --    UIManager:Get():ShowPersistentView("RaceRoomReviseView", CanvasType.MainCanvas, "RaceRoomReviseView")
    --    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_SetViewInfo, { "RaceRoomReviseView", true })
    --    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_ReviseViewAuto)
    --end)

    self.BtnChangeCar =CommonHelper:HButtonSetCallback("BtnChangeCar", self.gameObject, function(hbtn)
        ChangeCar=true
        SkipModuleHelper:Get():ToGarage(UIModuleID.RaceRoomDetail)
    end)

    self.BtnChangeTrack = CommonHelper:HButtonSetCallback("BtnChangeTrack", self.gameObject, function(hbtn)
        local limit = RaceRoomManager:Get():GetTrackData():GetRaceNumber()
        ---@param data RaceTrackData
        CommonHelper:OpenTrackListView(function(data)
            local trackid = data:GetId()
            local name = RaceRoomManager:Get():GetName()
            local passwd = RaceRoomManager:Get():GetPassword()
            local isOb = RaceRoomManager:Get():IsAllowObserver()
            RaceRoomSubsystem:Get():SendMsg_ReviseRoom(trackid, 0)
        end, limit,MiniTrackType.System, TrackListModule.RaceRoom)
    end)

    self.BtnStart = CommonHelper:HButtonSetCallback("BtnStart", self.gameObject, function(hbtn)
        self:OnClickBtnStart()
    end)
    self.BtnReady = CommonHelper:HButtonSetCallback("BtnReady", self.gameObject, function(hbtn)
        local carIdx= PlayerPrefsHelper:GetValue_MainMenuViewCarIndex()
        if CarDataManager:Get():CheckCarCompleteness(carIdx) then
            RaceRoomSubsystem:Get():SendMsg_Ready(carIdx)
        end
    end)
    self.BtnCancelReady = CommonHelper:HButtonSetCallback("BtnNotReady", self.gameObject, function(hbtn)
        RaceRoomSubsystem:Get():SendMsg_CancelReady()
    end)


end

function RaceRoomDetailView:OnOpen()
    self.idColorTab = {}
    self.pageSingleChannelChat_2 = CommonHelper:InitSingleChannelChat_2(ChatType.PVPRoom, self.gameObject, UIModuleID.RaceRoomDetail, self.idColorTab)
    self:UpdateChatScrollView({chatType=ChatType.PVPRoom,playerId=-1})
    ChangeCar=false
    --local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    --HomeSceneHelper:SetRaceRoom(port)
end
function RaceRoomDetailView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end
function RaceRoomDetailView:ReOpen()
    self.pageSingleChannelChat_2 = CommonHelper:InitSingleChannelChat_2(ChatType.PVPRoom, self.gameObject, UIModuleID.RaceRoomDetail, self.idColorTab)
    self:UpdateChatScrollView({chatType=ChatType.PVPRoom,playerId=-1})
    if ChangeCar then
        local carIdx= PlayerPrefsHelper:GetValue_MainMenuViewCarIndex()
        RaceRoomSubsystem:Get():SendMsg_ChangeCar(carIdx)
    end
    ChangeCar=false
    --local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    --HomeSceneHelper:SetRaceRoom(port)

    --if self:GetLuaViewInfo("RaceRoomReviseView") then
    --    UIManager:Get():ShowPersistentView("RaceRoomReviseView", CanvasType.MainCanvas, "RaceRoomReviseView")
    --    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_SetViewInfo, { "RaceRoomReviseView", true })
    --end
end

function RaceRoomDetailView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceRoomDetail)
    --HomeSceneShowCarRoom:Get():Recycle()
    CommonHelper:CloseShareInviteView()
end

function RaceRoomDetailView:SetData()
    self:SetDataWithoutMesh()
    self:SetCarMesh()
end

function RaceRoomDetailView:SetDataWithoutMesh()
    self:SetRoomInfo()
    self:SetBtnGroup()
    self:SetTrackInfo()
    self:SetPlayerList()

    self:SetObNum()
end

function RaceRoomDetailView:SetRoomInfo()
    CommonHelper:SetText("###roomname", self.gameObject, RaceRoomManager:Get():GetName())
    CommonHelper:SetText("###roomid", self.gameObject, tostring(RaceRoomManager:Get():GetID()))
end

function RaceRoomDetailView:SetTrackInfo()
    local data = RaceRoomManager:Get():GetTrackData()
    CommonHelper:SetGameObjectActive("trackgroup",self.gameObject,not RaceRoomManager:Get():IsRandom())
    CommonHelper:SetGameObjectActive("trackrandom",self.gameObject,RaceRoomManager:Get():IsRandom())
    CommonHelper:GetComponentSetTrackIconByData("trackicon", self.gameObject, data, UIModuleID.RaceRoomDetail)

    CommonHelper:SetTrackFeatureByParent("trackfeature", self.gameObject, data:GetFeature())

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, RaceRoomManager:Get():GetSceneID())
    if cfg then
        CommonHelper:GetComponentSetUITexture("sceneicon", self.gameObject, cfg.icon, UIModuleID.RaceRoomDetail)
        CommonHelper:SetText("###scenename", self.gameObject, ClientDataManager:GetTemplateString(cfg.name))
    end
    CommonHelper:HButtonSetCallback("BtnReview", self.gameObject, function(btn)
        if data:GetIsField() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
        else
            CommonHelper:LoadReviewTrack(nil, data)
        end
    end)
    CommonHelper:SetGameObjectActive("BtnReview",self.gameObject,false)
    CommonHelper:SetHButtonClick(self.BtnChangeTrack,RaceRoomManager:Get():IsLeader() and(data:GetMiniTrackType()==MiniTrackType.System or data:GetMiniTrackType()==MiniTrackType.LocalCustomTrack) and not RaceRoomManager:Get():IsRandom(),true)
end

function RaceRoomDetailView:SetObNum()
    --if RaceRoomManager:Get():IsAllowObserver() then
    --    local num = RaceRoomManager:Get():GetObserverNum()
    --    CommonHelper:SetText("obnum", self.gameObject, tostring(num))
    --else
    --    CommonHelper:SetText("obnum", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomWatchNumNul))
    --end
end

function RaceRoomDetailView:SetBtnGroup()
    CommonHelper:SetHButtonClick(self.BtnStart, RaceRoomManager:Get():IsLeader(), true)
    --CommonHelper:SetHButtonClick(self.BtnChangeTrack, RaceRoomManager:Get():IsLeader(), true)
   -- CommonHelper:SetHButtonClick(self.BtnRevise, RaceRoomManager:Get():IsLeader(), true)
    CommonHelper:SetHButtonClick(self.BtnInvite, RaceRoomManager:Get():IsLeader(), true)
    CommonHelper:SetHButtonClick(self.BtnShare, RaceRoomManager:Get():IsLeader(), true)
    ----屏蔽邀请按钮
    --CommonHelper:SetHButtonClick(self.BtnInvite, false, true)
    ----屏蔽分享按钮
    --CommonHelper:SetHButtonClick(self.BtnShare, false, true)
    local data = RaceRoomManager:Get():GetSelfPlayerData()
    CommonHelper:SetHButtonClick(self.BtnReady, (not RaceRoomManager:Get():IsLeader()) and (not data:GetReady()), true)
    CommonHelper:SetHButtonClick(self.BtnCancelReady, (not RaceRoomManager:Get():IsLeader()) and (data:GetReady()), true)
end

function RaceRoomDetailView:SetPlayerList()
    local list = RaceRoomManager:Get():GetPlayerList()
    for i = 1, 5 do
        local player = list[i]
        local obj = UIUtil.GetChild("player" .. i, self.gameObject)
        self:SetOnePlayer(obj, player, true)
        self:SetOneColor(i, player)
    end
end

---@param player RaceRoomPlayerData
function RaceRoomDetailView:SetOnePlayer(obj, player, showdetail)
    CommonHelper:SetGameObjectActive("leaderbg", obj, player and RaceRoomManager:Get():GetLeaderID() == player:GetID())
    CommonHelper:SetGameObjectActive("playerbg", obj, player and RaceRoomManager:Get():GetLeaderID() ~= player:GetID() and RaceRoomManager:Get():IsLeader())
    CommonHelper:SetGameObjectActive("blank", obj, not player)
    local infoobj = CommonHelper:SetGameObjectActive("playerinfo", obj, player and showdetail)
    local listobj = CommonHelper:SetGameObjectActive("partlist", obj, player and not showdetail)

    CommonHelper:HButtonSetCallback("BtnKickout", obj, function(hbtn)
        self:OnClickBtnKickout(player)
    end)

    if obj and player then

        if showdetail then
            print(player:GetName())
            local str = CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomPlayerName, player:GetLV(), player:GetName())
            CommonHelper:SetText("###playername", infoobj, str)
            CommonHelper:SetGameObjectActive("readystate", infoobj, player:GetReady())
            --CommonHelper:SetGameObjectActive("notready", obj, not player:GetReady())
            CommonHelper:SetPlayerIconById("PlayerIcon", infoobj, player:GetHeadIcon(), player:GetIconFrame(), nil, UIModuleID.RaceRoomDetail)
            if RaceRoomManager:Get():IsLeader() then
                CommonHelper:SetHButtonClick(self.BtnChangeCar, true,true)
            else
                if player:GetID()==PlayerDataManager:Get():GetPlayerRID() then
                    CommonHelper:SetHButtonClick(self.BtnChangeCar, not player:GetReady(),true)
                end
            end

            ---@type qualifyingrank_config_cell
            local curcfg = CommonHelper:GetRankCfgByScore(player:GetRankScore())
            CommonHelper:SetRankIconGroup("rankicon_s_1", infoobj, curcfg)

            local partlist = player:GetCarData():GetPartList()
            for i = 1, 4 do
                local part = partlist[i]
                local partobj = CommonHelper:SetGameObjectActive("partitem" .. i, infoobj, part ~= nil)
                if part then
                    local param = Param_PartItem()
                    param.moduleId = UIModuleID.RaceRoomDetail
                    param.partId = part.PartOrgCfgID
                    param.quality = part.PartQuality
                    param.generation=part.generation
                    CommonHelper:SetPartItem(partobj, param)
                end
            end

            CommonHelper:HButtonSetCallback("BtnList", infoobj, function(hbtn)
                self:SetOnePlayer(obj, player, false)
            end)
        else

            local ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", listobj, typeof(MoreRowScrollView))
            local temp = player:GetCarData():GetPartList()
            local list = {}
            for i = 1, #temp do
                if temp[i] then
                    if temp[i].PartCfgID > 0 then
                        table.insert(list, temp[i])
                    end
                end
            end
            CommonHelper:InitMoreRowScrollView(ScrollView, #list, 2, function(dataIndex, itemObj, scroll)
                local data = list[dataIndex + 1]
                local partobj = UIUtil.GetChild("partitem1", itemObj)
                local param = Param_PartItem()
                param.moduleId = UIModuleID.RaceRoomDetail
                param.partId = data.PartOrgCfgID
                param.quality = data.PartQuality
                param.generation=data.generation
                CommonHelper:SetPartItem(partobj, param)
            end)

            CommonHelper:HButtonSetCallback("BtnDetail", listobj, function(hbtn)
                self:SetOnePlayer(obj, player, true)
            end)
        end
    end

end

function RaceRoomDetailView:SetCarMesh()
    --local carlist = {}
    --local list = RaceRoomManager:Get():GetPlayerList()
    --for i = 1, 5 do
    --    local player = list[i]
    --    if player then
    --        table.insert(carlist, player:GetCarData())
    --    else
    --        table.insert(carlist, nil)
    --    end
    --end
    --HomeSceneShowCarRoom:Get():Show(carlist)
end

---@param data RaceRoomPlayerData
function RaceRoomDetailView:OnClickBtnKickout(data)
    RaceRoomSubsystem:Get():SendMsg_Kickout(data:GetID())
end

function RaceRoomDetailView:OnClickBtnStart()
    local isstart = true
    local list = RaceRoomManager:Get():GetPlayerList()
    for i = 1, #list do
        if not list[i]:GetReady() then
            isstart = false
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PlayerNoPrepare,list[i]:GetName()))
        end
    end

    if isstart then
        local carIdx= PlayerPrefsHelper:GetValue_MainMenuViewCarIndex()
        if CarDataManager:Get():CheckCarCompleteness(carIdx) then
            RaceRoomSubsystem:Get():SendMsg_Start(carIdx)
        end
    end
end

---@param player RaceRoomPlayerData
function RaceRoomDetailView:SetOneColor(idx, player)
    if player ~= nil then
        if idx == 1 then
            self.idColorTab[player:GetID()] = "848C92"
        elseif idx == 2 then
            self.idColorTab[player:GetID()] = "D43E3F"
        elseif idx == 3 then
            self.idColorTab[player:GetID()] = "E9C526"
        elseif idx == 4 then
            self.idColorTab[player:GetID()] = "2EB17C"
        elseif idx == 5 then
            self.idColorTab[player:GetID()] = "459ADF"
        end
    end
end

function RaceRoomDetailView:UpdateChatScrollView(userdata)
    self.pageSingleChannelChat_2:InitChatList(userdata.chatType, userdata.playerId)
end

function RaceRoomDetailView:OnBackKey()
    if  UIManager:Get():GetTopPopViewName() ~= "" then
        return
    end
    if UIManager:Get():GetTopViewName() == self.gameObject.name then
        if RaceRoomManager:Get():IsLeader() then
            local boxfunc = function()
                local str = CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomRemoveAsk)
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, str)
                if ret == MessageBoxHelp.BtnType.OK then
                    RaceRoomSubsystem:Get():SendMsg_Leave()
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
        else
            RaceRoomSubsystem:Get():SendMsg_Leave()
        end
    end
end
