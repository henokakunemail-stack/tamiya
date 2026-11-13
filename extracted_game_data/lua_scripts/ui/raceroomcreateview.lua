---@class RaceRoomCreateView : ViewBase
RaceRoomCreateView = class("RaceRoomCreateView", ViewBase)

function RaceRoomCreateView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRoomCreateViewAction")


    self.FlagOb = false


    self.TogTypeIdx = -1
    self.TogType = {}

    self.SelectFeature = {}
    self.TogTrackFeature = {}

    ---@type table<number, RaceTrackData>
    self.TrackList = {}
    ---@type table<number, scene_config_cell>
    self.SceneList = {}

    self.SelectTrackNum = -1
    self.SelectTrackType = -1
end

function RaceRoomCreateView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_SetViewInfo, { "RaceRoomCreateView", false })
        UIManager:Get():HidePersistentView("RaceRoomCreateView")
    end)
    CommonHelper:HButtonSetCallback("BtnCloseMask2", self.gameObject, function(hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_SetViewInfo, { "RaceRoomCreateView", false })
        UIManager:Get():HidePersistentView("RaceRoomCreateView")
    end)

    CommonHelper:HButtonSetCallback("BtnCreate", self.gameObject, function(hbtn)
        self:CreateRoom()
    end)

    for i = 1, 3 do
        local tog = CommonHelper:HButtonSetCallback("TogType"..i, self.gameObject,function (hbtn)
            self:OnClickTogType(i, true)
        end)
        table.insert(self.TogType, tog)
    end

    for i = 1, 6 do
        local tog = CommonHelper:HButtonSetCallback("TogRaceType"..i, self.gameObject,function (hbtn)
            self:OnClickTogTrackFeature(i)
        end)
        table.insert(self.TogTrackFeature, tog)
    end


    self.TrackView = UIUtil.GetTypeChildWightByParent("TrackScrollView",self.gameObject,typeof(FilmScrollView))
    self.SceneView = UIUtil.GetTypeChildWightByParent("SceneScrollView",self.gameObject,typeof(FilmScrollView))
end

function RaceRoomCreateView:OnOpen()

end
function RaceRoomCreateView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end

function RaceRoomCreateView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceRoomCreate)
end
function RaceRoomCreateView:OnAutoClose()

end

function RaceRoomCreateView:AutoSelect()
    CommonHelper:SetInputFieldText("InputName", self.gameObject, PlayerDataManager:Get():GetPlayerName())
    CommonHelper:InputFieldSetDefaultText("InputName", self.gameObject, PlayerDataManager:Get():GetPlayerName())
    CommonHelper:SetInputFieldText("InputPasswd", self.gameObject, "")

    for i = 1, #self.TogTrackFeature do CommonHelper:SetToggleState(self.TogTrackFeature[i], true) end
    for i = 1, 6 do self.SelectFeature[i] = true end

    self:OnClickTogType(1, false)

    self:SetSceneView()
end



function RaceRoomCreateView:OnClickTogType(idx, ischeck)
    if ischeck and self.TogTypeIdx == idx then return end
    self.TogTypeIdx = idx

    for i = 1, #self.TogType do
        CommonHelper:SetToggleState(self.TogType[i], idx == i)
    end

    if idx == 1 then self:SetTrackList(3, MiniTrackType.System, self:GetSiftFeature()) end
    if idx == 2 then self:SetTrackList(5, MiniTrackType.System, self:GetSiftFeature()) end
    if idx == 3 then self:SetTrackList(-1, MiniTrackType.SelfCustomTrack, self:GetSiftFeature()) end

    self:SetTrackView()
end

function RaceRoomCreateView:OnClickTogTrackFeature(idx)
    if self.SelectFeature[idx] then
        local count = 0
        for i = 1, #self.SelectFeature do
            if self.SelectFeature[i] then
                count = count + 1
            end
        end
        if count <= 1 then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomSelectFeature))
            return
        end
    end

    local state = not self.SelectFeature[idx]
    self.SelectFeature[idx] = state
    CommonHelper:SetToggleState(self.TogTrackFeature[idx], state)


    local sift = {}
    for i = 1, #self.SelectFeature do
        if self.SelectFeature[i] then
            table.insert(sift, i)
        end
    end

    self:SetTrackList(self.SelectTrackNum, self.SelectTrackType, self:GetSiftFeature())
    self:SetTrackView()
end

function RaceRoomCreateView:GetSiftFeature()
    local sift = {}
    for i = 1, #self.SelectFeature do
        if self.SelectFeature[i] then
            table.insert(sift, i)
        end
    end
    return sift
end

function RaceRoomCreateView:SetTrackList(num, custom, sift)
    self.SelectTrackNum = num
    self.SelectTrackType = custom
    self.TrackList = {}

    ---@type table<number, RaceTrackData>
    local list = CommonHelper:GetTrackListByType(custom, num, TrackListModule.RaceRoom, sift)

    if #list > 0 and self.SelectTrackType~=MiniTrackType.SelfCustomTrack then self.TrackList[1] = -1 end
    for i = 1, #list do
        if list[i]:GetCanRun() then
            table.insert(self.TrackList, list[i])
        end
    end
end

function RaceRoomCreateView:SetTrackView()
    local Count= #self.TrackList >0 and #self.TrackList or 1
    CommonHelper:FilmView_Init(self.TrackView, Count, function(idx, itemObj, scroll)
        local data = self.TrackList[idx + 1]
        CommonHelper:SetGameObjectActive("random", itemObj, data ~=nil)
        local normalobj = CommonHelper:SetGameObjectActive("normal", itemObj, data == nil)
        CommonHelper:SetGameObjectActive("trackicon", itemObj, data ~=nil)
        CommonHelper:SetGameObjectActive("trackfeature", itemObj, data ~=nil)
        if data then
            CommonHelper:SetGameObjectActive("random", itemObj, data == -1)
            local normalobj = CommonHelper:SetGameObjectActive("normal", itemObj, data ~= -1)
            if data ~= -1 and data then
                CommonHelper:GetComponentSetTrackIconByData("trackicon", normalobj, data, UIModuleID.RaceRoomCreate)
                CommonHelper:SetTrackFeatureByParent("trackfeature", normalobj, data:GetFeature())
                CommonHelper:SetGameObjectActive("trackfeature", normalobj, data:GetFeature()~="-1")
            end
        end


    end)
end

function RaceRoomCreateView:SetSceneView()
    self.SceneList = {}
   -- self.SceneList[1] = -1

    ---@type scene_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.scene_config)
    local list = tab.GetConfigData()
    for k,v in pairs(list) do
        if v.isroomtrack==1 then
            table.insert(self.SceneList, v)
        end
    end

    CommonHelper:FilmView_Init(self.SceneView, #self.SceneList, function(idx, itemObj, scroll)
        local data = self.SceneList[idx + 1]
        CommonHelper:SetGameObjectActive("random", itemObj, data == -1)
        local normalobj = CommonHelper:SetGameObjectActive("normal", itemObj, data ~= -1)
        if data ~= -1 and data then
            CommonHelper:GetComponentSetUITexture("sceneicon",normalobj,data.icon,UIModuleID.RaceRoomCreate)
            CommonHelper:SetText("###scenename", normalobj, ClientDataManager:GetTemplateString(data.name))
        end
    end)
end


































function RaceRoomCreateView:CreateRoom()
    local name = CommonHelper:GetInputFieldText("InputName", self.gameObject)
    if not CommonHelper:ReviewNicknameV2(name) then return end


    local idx = CommonHelper:FilmView_GetCurItem(self.TrackView)
    ---@type RaceTrackData
    local data = self.TrackList[idx + 1]
    if data==nil then CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNotCanRun)) return end
    if data == -1 then data = self.TrackList[math.random(2, #self.TrackList)] end

    local trackid = 0
    local IsSelf = 0
    local trackType =data:GetRaceNumber()
    local israndom=0
    if idx==0 then
        israndom=1
    end

    if data:GetMiniTrackType() == MiniTrackType.SelfCustomTrack then
        IsSelf=1
        trackid = data:GetServerIdx()
        israndom=0
        if not data:GetCanRun() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNotCanRun))
            return
        end
    else
        trackid=data:GetId()
    end


    idx = CommonHelper:FilmView_GetCurItem(self.SceneView)
    ---@type scene_config_cell
    local scene = self.SceneList[idx + 1]
    if scene == -1 then scene = self.SceneList[math.random(2, #self.SceneList)] end


    local passwd = CommonHelper:GetInputFieldText("InputPasswd", self.gameObject)
    local carIdx= PlayerPrefsHelper:GetValue_MainMenuViewCarIndex()
    RaceRoomSubsystem:Get():SendMsg_CreateRoom(trackid,scene.C_ID,name, passwd, trackType,IsSelf,carIdx,israndom)
end

