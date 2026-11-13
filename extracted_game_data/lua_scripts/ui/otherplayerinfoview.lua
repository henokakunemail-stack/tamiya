---@class OtherPlayerInfoView : ViewBase
OtherPlayerInfoView = class("OtherPlayerInfoView", ViewBase)

-- View必加
function OtherPlayerInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "OtherPlayerInfoViewAction")
end
---@type PlayerData
local _PlayerData = nil
function OtherPlayerInfoView:Awake()
    self.PlayerHeadIconFrameImage = UIUtil.GetTypeChildWightInputPath("PlayerInfo/PlayerHeadIconFrameImage", self.gameObject, typeof(Image))
    self.PlayerHeadIconImage = UIUtil.GetTypeChildWightInputPath("PlayerInfo/PlayerHeadIconImage", self.gameObject, typeof(RawImage))

    self.ClubIconRawImage = UIUtil.GetTypeChildWightInputPath("ClubInfo/ClubIconRawImage", self.gameObject, typeof(RawImage))
    self.AddFriendBtn = CommonHelper:HButtonSetCallback("AddFriendBtn", self.gameObject, function(data)
        local cfg = nil
        if ClientDataManager:Get().IsConfig2 then
            cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist2_config, GameFunction.Friend)
        else
            cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist_config, GameFunction.Friend)
        end
        if _PlayerData.level < cfg.level then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.OtherFriendLocked))
        else
            FriendSubsystem:Get():SendMsg_AddFriends(_PlayerData.id)
        end
    end)
    self.RemoveFriendBtn = CommonHelper:HButtonSetCallback("RemoveFriendBtn", self.gameObject, function(data)
        self:OnDelFriendBtnClick(_PlayerData.id)
    end)
    self.VehicleBtn = CommonHelper:HButtonSetCallback("ShieldBtn", self.gameObject, function(data)
        self:OnBlackBtnClick(_PlayerData.id,_PlayerData.roleName,_PlayerData.headIcon,_PlayerData.iconFrame)
    end)
    self.ChatBtn = CommonHelper:HButtonSetCallback("ChatBtn", self.gameObject, function(data)

    end)
    CommonHelper:HButtonSetCallback("BtnClose2", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnCloseMask1", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)
    self.CopyBtn = CommonHelper:HButtonSetCallback("copy", self.gameObject, function(data)
        CommonHelper:WriteClipboart(_PlayerData.id)
    end)
    self.HighRank = UIUtil.GetChild("HighRank", self.gameObject)
end

function OtherPlayerInfoView:OnOpen()

end

function OtherPlayerInfoView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.PlayerInfo)
end

function OtherPlayerInfoView:OnAutoClose()

end

---@param param SC_getPlayerInfoRes
function OtherPlayerInfoView:SetData(param)

    _PlayerData = PlayerData()
    _PlayerData:SetBasePlayerData(param.playerData)
    self.CarList = CarDataManager:Get():GetCarList()
    --if msg.iconFrame==0 then
    --    msg.icon=16
    --end
    CommonHelper:SetPlayerIconById("RoleIconGourp", self.gameObject, _PlayerData.icon, nil, nil, UIModuleID.PlayerInfo)
    CommonHelper:SetText("###PlayNameText", self.gameObject, _PlayerData.name)
    if _PlayerData.sign == nil or #_PlayerData.sign <= 0 then
        CommonHelper:SetText("###PersonalSignature", self.gameObject, ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerDefaultSign))
    else
        CommonHelper:SetText("###PersonalSignature", self.gameObject, _PlayerData.sign)
    end
    CommonHelper:SetText("###PlayIDText", self.gameObject, _PlayerData.id)
    CommonHelper:SetText("###PlayServerText", self.gameObject, ClientDataManager:Get():GetServerInfoByServerId(_PlayerData.serverId).name)--这个地方服务器返回数据错误，暂时用的是enterplayer返回的，应该用消息返回的

    CommonHelper:SetText("###LabLV", self.gameObject, _PlayerData.level)
    CommonHelper:SetText("###PlayChapterText", self.gameObject, _PlayerData.rlevelId)
    --CommonHelper:SetText("PlayRankText",self.Center,msg.rlevelId)

    self:SetBtnInfo()
    --CommonHelper:SetUITexture(self.ClubIconRawImage,headIconData.icon..".png",UIModuleID.PlayerHeadIcon)
    CommonHelper:SetText("###PlayClubText", self.gameObject, _PlayerData.guildId == ClubState.NoClub and ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerNoClubDefault) or _PlayerData.guildName)

    CommonHelper:SetText("###AllRankCount", self.gameObject, param.playerExData.rankNum)

    if _PlayerData.rLevelId ~= 0 then
        local levelData = PVEChapterDataManager:Get():GetLevelDataByLevelId(_PlayerData.rLevelId)
        CommonHelper:SetText("###StoryPro", self.gameObject, string.format("%s", levelData.name))
    else
        CommonHelper:SetText("###StoryPro", self.gameObject, "1-1")
    end
    CommonHelper:SetText("###WinRankCount", self.gameObject, param.playerExData.winNum)
    --self:SetPersonScore(_PlayerData.rankScore, self.info1)
    self:SetPersonScore(param.playerExData.rankScoreMax, "HighRank")
    self:SetCar(param.carData)
end

function OtherPlayerInfoView:SetBtnInfo()
    --CommonHelper:SetHButtonClick(self.RemoveFriendBtn, FriendDataManager:Get():GetFriendDataByID(_PlayerData.id) ~= nil, true)
    --CommonHelper:SetHButtonClick(self.AddFriendBtn, FriendDataManager:Get():GetFriendDataByID(_PlayerData.id) == nil, true)
    --CommonHelper:SetHButtonClick(self.VehicleBtn, FriendDataManager:Get():GetBlackFriendDataById(_PlayerData.id) == nil, true)
end

function OtherPlayerInfoView:SetPersonScore(rankscore, obj)
    local score = rankscore == nil and 0 or rankscore
    ---@type qualifyingrank_config_cell
    local cfg = CommonHelper:GetRankCfgByScore(score)
    CommonHelper:SetRankIconGroup(obj, self.gameObject, cfg)
end

function OtherPlayerInfoView:OnDelFriendBtnClick(playerId)
    local boxFunc = function()
        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, CommonHelper:GetTempStr_Default(TemplateStringID.IsDelFriend), CommonHelper:GetTempStr_Default(TemplateStringID.DeleteFriend), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
        if ret == MessageBoxHelp.BtnType.OK then
            FriendDataManager:Get():SetFriendType(FriendType.DelFriendInOtherPlayerInfo)
            FriendSubsystem:Get():SendMsg_DelFriends(playerId)
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
end

function OtherPlayerInfoView:OnBlackBtnClick(playerId,nickName,icon,iconframe)
    local tips = FriendDataManager:Get():GetFriendDataByID(playerId) == nil and CommonHelper:GetTempStr_Default(TemplateStringID.BlackStranger) or CommonHelper:GetTempStr_Default(TemplateStringID.BlackFriend)

    local boxFunc = function()
        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.BanFriend), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
        if ret == MessageBoxHelp.BtnType.OK then
            FriendDataManager:Get():SetFriendType(FriendType.BlackFriendInOtherPlayerInfo)
            FriendSubsystem:Get():SendMsg_AddBlacklist(playerId,nickName,icon,iconframe)
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
end

---@param carData SC_BaseCarData
function OtherPlayerInfoView:SetCar(carData)
    if carData == nil then
        return
    end
    local reviewdata = CarReviewData()
    reviewdata:SetDataByMsg(carData.parts)
    local parts=reviewdata:GetPartList()
    local PartsItem={4,1,2,3,17}
    for i = 1, 5 do
        local obj=self:GetChild("ItemRaceRoom"..i)
        local param=Param_PropParam()
        param.id=parts[PartsItem[i]].PartCfgID
        param.generation=parts[PartsItem[i]].PartGeneration
        CommonHelper:SetPropGroup(obj,param)
    end
end


