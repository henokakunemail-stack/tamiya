local DurationDay={
    Seven=7,
    Fourteen=14,
}
local _SelectDay=-1


---@class ClubRaceSelfLevelCreateView : ViewBase
ClubRaceSelfLevelCreateView = class("ClubRaceSelfLevelCreateView", ViewBase)

function ClubRaceSelfLevelCreateView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ClubRaceSelfLevelCreateViewAction")

    self.TogTypeIdx = -1
    self.TogRewardIdx = -1
    self.TogType = {}

    self.SelectFeature = {}
    self.TogTrackFeature = {}
    self.TogReward = {}

    ---@type table<number, RaceTrackData>
    self.TrackList = {}
    ---@type table<number, scene_config_cell>
    self.SceneList = {}
end

function ClubRaceSelfLevelCreateView:Awake()

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnCommit",self.gameObject,function (hbtn)
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
    for i = 1, 3 do
        local tog = CommonHelper:HButtonSetCallback("TogReward"..i, self.gameObject,function (hbtn)
            self:OnClickTogReward(i)
        end)
        table.insert(self.TogReward, tog)
    end

    self.TrackView = UIUtil.GetTypeChildWightByParent("TrackScrollView",self.gameObject,typeof(FilmScrollView))
    self.SceneView = UIUtil.GetTypeChildWightByParent("SceneScrollView",self.gameObject,typeof(FilmScrollView))
    self.NpcView = UIUtil.GetTypeChildWightByParent("NpcScrollView",self.gameObject,typeof(FilmScrollView))
    self.RewardScrollView = UIUtil.GetTypeChildWightByParent("RewardScrollView",self.gameObject,typeof(MoreRowScrollView))
    CommonHelper:FilmView_SetPageMoveFinishCB(self.NpcView,function(idx)
        self:OnClickTogReward(1,false)
    end)
end
function ClubRaceSelfLevelCreateView:OnOpen()
    self:SetDefault()
end

function ClubRaceSelfLevelCreateView:OnClose()

end
function ClubRaceSelfLevelCreateView:SetDefault()
    _SelectDay=DurationDay.Seven
    CommonHelper:SetInputFieldText("RaceNameInput",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfLevelDefaultName,PlayerDataManager:Get():GetPlayerName()))

    for i = 1, #self.TogTrackFeature do CommonHelper:SetToggleState(self.TogTrackFeature[i], true) end
    for i = 1, 6 do self.SelectFeature[i] = true end

    self:OnClickTogType(1, false)

    self:SetSceneView()

    self:SetNpcView()

    self:OnClickTogReward(1,false)
end
function ClubRaceSelfLevelCreateView:OnClickTogType(idx, ischeck)
    if ischeck and self.TogTypeIdx == idx then return end
    self.TogTypeIdx = idx

    for i = 1, #self.TogType do
        CommonHelper:SetToggleState(self.TogType[i], idx == i)
    end

    if idx == 1 then self:SetTrackList(3, MiniTrackType.System) end
    if idx == 2 then self:SetTrackList(5, MiniTrackType.System) end
    if idx == 3 then self:SetTrackList(-1, MiniTrackType.SelfCustomTrack) end

    self:SetTrackView()

end

function ClubRaceSelfLevelCreateView:OnClickTogReward(idx, ischeck)
    if ischeck and self.TogRewardIdx == idx then return end
    self.TogRewardIdx = idx

    for i = 1, #self.TogReward do
        CommonHelper:SetToggleState(self.TogReward[i], idx == i)
    end

    self:SetRewardView()
end

function ClubRaceSelfLevelCreateView:OnClickTogTrackFeature(idx)
    if self.TogTypeIdx==3 then
        return
    end

    local count = 0
    for i = 1, #self.TogTrackFeature do
        if CommonHelper:GetToggleState(self.TogTrackFeature[i]) then
            count=count+1
        end
    end
    if count<= 1 and CommonHelper:GetToggleState(self.TogTrackFeature[idx]) then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.RaceRoomSelectFeature))
        return
    end

    local state = not CommonHelper:GetToggleState(self.TogTrackFeature[idx])
    self.SelectFeature[idx] = state
    CommonHelper:SetToggleState(self.TogTrackFeature[idx], state)
    local trackFeature=nil
    for i = 1, #self.TogTrackFeature do
        if CommonHelper:GetToggleState(self.TogTrackFeature[i]) then
            if trackFeature==nil then
                trackFeature={}
            end
            table.insert(trackFeature,i)
        end
    end
    self:SetTrackList(self.SelectTrackNum, self.SelectTrackType,trackFeature)
end
function ClubRaceSelfLevelCreateView:SetTrackList(num, custom,trackFeature)
    self.SelectTrackNum = num
    self.SelectTrackType = custom
    self.SelectTrackType = custom
    self.SelectTrackFeature=trackFeature
    self.TrackList = {}
    self.TrackList[1] = -1

    ---@type table<number, RaceTrackData>
    local list = CommonHelper:GetTrackListByType(custom, num, TrackListModule.RaceRoom,self.SelectTrackFeature)
    for i = 1, #list do
        table.insert(self.TrackList,list[i])
    end
    self:SetTrackView()
end

function ClubRaceSelfLevelCreateView:SetTrackView()
    CommonHelper:FilmView_Init(self.TrackView, #self.TrackList, function(idx, itemObj, scroll)
        local data = self.TrackList[idx + 1]
        CommonHelper:SetGameObjectActive("random", itemObj, data == -1)
        local normalobj = CommonHelper:SetGameObjectActive("normal", itemObj, data ~= -1)
        if data ~= -1 and data then
            CommonHelper:GetComponentSetTrackIconByData("trackicon", normalobj, data, UIModuleID.ClubRaceSelfLevelCreate)
            CommonHelper:SetTrackFeatureByParent("trackfeature", normalobj, data:GetFeature())
        end
    end)
end

function ClubRaceSelfLevelCreateView:SetSceneView()
    self.SceneList = {}
    self.SceneList[1] = -1
    ---@type table<number,guildselflevelinfo_config_cell>
    local dataTable= ClientDataManager:Get():GetDataTable(ConfigNames.guildselflevelinfo_config).GetConfigData()
    local data=stringSplitToNumber(dataTable[1].sceneIds,',')
    for k,v in pairs(data) do
        local cfg= CommonHelper:GetTableDataByID(ConfigNames.scene_config,v)
        table.insert(self.SceneList, cfg)
    end
    CommonHelper:FilmView_Init(self.SceneView, #self.SceneList, function(idx, itemObj, scroll)
        local data = self.SceneList[idx + 1]
        CommonHelper:SetGameObjectActive("random", itemObj, data == -1)
        local normalobj = CommonHelper:SetGameObjectActive("normal", itemObj, data ~= -1)
        if data ~= -1 and data then
            CommonHelper:GetComponentSetUITexture("sceneicon",normalobj,data.icon,UIModuleID.ClubRaceSelfLevelCreate)
            CommonHelper:SetText("###scenename", normalobj, ClientDataManager:GetTemplateString(data.name))
        end
    end)
end

function ClubRaceSelfLevelCreateView:SetNpcView()
    ---@type table<number,guildselflevelreward_config_cell>
    self.NpcList = {}
    ---@type table<number,guildselflevelreward_config_cell>
    local list= ClientDataManager:Get():GetDataTable(ConfigNames.guildselflevelreward_config).GetConfigData()
    for k,v in pairs(list) do
        table.insert(self.NpcList, v)
    end
    CommonHelper:FilmView_Init(self.NpcView, #self.NpcList, function(idx, itemObj, scroll)
        local data = self.NpcList[idx + 1]
        if  data then
            local name,icon= CommonHelper:AnalyseNPCNameAndIconById(data.captain)
            CommonHelper:GetComponentSetUITexture("icon",itemObj,icon,UIModuleID.ClubRaceSelfLevelCreate)
        end
    end)
end

function ClubRaceSelfLevelCreateView:SetRewardView()

    local idx = CommonHelper:FilmView_GetCurItem(self.NpcView)
    ---@type guildselflevelreward_config_cell
    local data = self.NpcList[idx + 1]
    local temp=-1
    if self.TogRewardIdx==1 then
        temp=data.reward1
    end
    if self.TogRewardIdx==2 then
        temp=data.reward2
    end
    if self.TogRewardIdx==3 then
        temp=data.reward3
    end
    local group= CommonHelper:GetRewardByDropId(temp)
    CommonHelper:InitMoreRowScrollView(self.RewardScrollView,#group,1,function(index,item,scrollView)
        CommonHelper:SetPropGroupByRewardData(item,group[index+1],UIModuleID.ClubRaceSelfLevelCreate)
    end)
end


function ClubRaceSelfLevelCreateView:CreateRoom()

    local idx = CommonHelper:FilmView_GetCurItem(self.TrackView)
    ---@type RaceTrackData
    local data = self.TrackList[idx + 1]
    if data == -1 then data = self.TrackList[math.random(2, #self.TrackList)] end

    if data:GetCanRun() then
        idx = CommonHelper:FilmView_GetCurItem(self.SceneView)
        ---@type scene_config_cell
        local scene = self.SceneList[idx + 1]
        if scene == -1 then scene = self.SceneList[math.random(2, #self.SceneList)] end

        idx = CommonHelper:FilmView_GetCurItem(self.SceneView)
        ---@type selflevelreward_config_cell
        local npc = self.NpcList[idx + 1]

        local name =CommonHelper:GetInputFieldText("RaceNameInput",self.gameObject)

        local isRight=CommonHelper:ReviewNicknameV2(name)
        if isRight then
            ClubRaceSelfLevelSubsystem:Get():SendMsg_SelfLevelCreate(npc.id,scene.id,data:GetId(),name)
        end

    else
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNotCanRun))
    end
end


