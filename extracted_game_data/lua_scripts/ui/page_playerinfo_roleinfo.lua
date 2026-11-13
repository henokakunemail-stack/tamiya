---@class PagePlayerInfoRoleInfo
PagePlayerInfoRoleInfo = class("PagePlayerInfoRoleInfo")
function PagePlayerInfoRoleInfo:initialize()

end

local _CurCarIndex = -1

function PagePlayerInfoRoleInfo:SetData(root)
    self.Root = root
    self:RoleInfoViewAwake()
end
function PagePlayerInfoRoleInfo:RoleInfoViewAwake()

    self.PlayerHeadIconFrameImage = UIUtil.GetTypeChildWightInputPath("PlayerInfo/PlayerHeadIconFrameImage", self.Root, typeof(Image))
    self.PlayerHeadIconImage = UIUtil.GetTypeChildWightInputPath("PlayerInfo/PlayerHeadIconImage", self.Root, typeof(RawImage))

    self.ClubIconRawImage = UIUtil.GetTypeChildWightInputPath("ClubInfo/ClubIconRawImage", self.Root, typeof(RawImage))
    self.AddFriendBtn = CommonHelper:HButtonSetCallback("AddFriendBtn", self.Root, function(data)

    end)
    self.BtnChangeName = CommonHelper:HButtonSetCallback("BtnChangeName", self.Root, function(data)
        UIManager:Get():OpenPopup("PlayerRenameView",CanvasType.FrontCanvas,"PlayerRenameView")
        --if KnapsackDataManager:Get():GetArticleCountByCfgid(ArticleIdDefine.ReNameCard) > 0 then
        --    self:ChangeNameCB()
        --    --UIManager:Get():OpenPopup("CommonInputView", CanvasType.FrontCanvas, "CommonInputView")
        --    --local param = CommonInputViewParam()
        --    --param.TitleName = ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerEditNameTittle)
        --    --param.DefaultValue = PlayerDataManager:Get():GetPlayerName()
        --    --param.Func = self.ChangeNameCB
        --    --param.FuncClass = self
        --    --param.FuncParam = nil
        --    --param.CharacterLimit = 8
        --    --UINotify:Get():SendNotification(UINotifyEvent.CommonInputView_SetData, param)
        --else
        --    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangeNameCardNoEnouch))
        --end

    end)
    self.AddBlacklistBtn = CommonHelper:HButtonSetCallback("AddBlacklistBtn", self.Root, function(data)

    end)
    self.RemoveFriendBtn = CommonHelper:HButtonSetCallback("RemoveFriendBtn", self.Root, function(data)

    end)
    self.RemoveBlacklistBtn = CommonHelper:HButtonSetCallback("RemoveBlacklistBtn", self.Root, function(data)

    end)
    self.VehicleBtn = CommonHelper:HButtonSetCallback("VehicleBtn", self.Root, function(data)

    end)
    self.ChatBtn = CommonHelper:HButtonSetCallback("ChatBtn", self.Root, function(data)

    end)
    self.CopyBtn = CommonHelper:HButtonSetCallback("copy", self.Root, function(data)
        CommonHelper:WriteClipboart(PlayerDataManager:Get():GetPlayerRID())
    end)
    self.signBtn = CommonHelper:HButtonSetCallback("edit", self.Root, function(data)
        self:ChangeSignCB()
        --UIManager:Get():OpenPopup("CommonInputView", CanvasType.FrontCanvas, "CommonInputView")
        --local param = CommonInputViewParam()
        --param.TitleName = ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerEditSignTittle)
        --param.DefaultValue = PlayerDataManager:Get():GetPlayerSign()
        --param.Func = self.ChangeSignCB
        --param.FuncClass = self
        --param.FuncParam = nil
        --param.CharacterLimit = 30
        --param.CheckNull = false
        --UINotify:Get():SendNotification(UINotifyEvent.CommonInputView_SetData, param)
    end)
    self.SelectCarBtn = CommonHelper:HButtonSetCallback("SelectCarBtn", self.Root, function(data)
        UIManager:Get():OpenView("PlayerInfoSelectCarView", CanvasType.MainCanvas, "PlayerInfoSelectCarView")
        UINotify:Get():SendNotification(UINotifyEvent.PlayerInfoView_SelectCarOpen, _CurCarIndex)
    end)
    self.AlterHeadBtn = CommonHelper:HButtonSetCallback("AlterHeadBtn", self.Root, function(data)
        UIManager:Get():OpenPopup("PlayerHeadIconView", CanvasType.MainCanvas, "PlayerHeadIconView", true)
       -- PersonalHomeHelper.SetIsCanOperationSign(false)
    end)

    CommonHelper:SetInputFieldCharacterLimit("PlayNameText", self.Root,30)
    CommonHelper:SetInputFieldCharacterLimit("PersonalSignature", self.Root,30)
    self.PageRoot = UIUtil.GetChild("pageroot", self.Root)
    self.info1 = UIUtil.GetChild("info1", self.Root)
    self.info2 = UIUtil.GetChild("info2", self.Root)
    self.Pre_SelectCar = UIUtil.GetChild("Page_SelectCar", self.Root)


end
function PagePlayerInfoRoleInfo:ChangeNameCB()
    local value=CommonHelper:GetInputFieldText("PlayNameText",self.Root)
    if value~= PlayerDataManager:Get():GetPlayerName() then
        CommonHelper:RegexName(value, function()
           -- local isRight=CommonHelper:ReviewNicknameV2(value)
            --if isRight then
                PlayerInfoSubsystem:Get():SendMsg_ChangePlayerInfo(PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerSign(),value)
               -- PlayerInfoSubsystem:Get():SendMsg_ChangePlayerInfo(headIcon,iconFrame,sign,rolename)
            --end
        end)
    end
end

function PagePlayerInfoRoleInfo:ChangeSignCB()
    local value=CommonHelper:GetInputFieldText("PersonalSignature",self.Root)
    --local isRightDescribe, message = CommonHelper:ReviewWordsV2(tostring(PlayerDataManager:Get():GetPlayerLV()), tostring(ChatType.Club), value)
    --if  isRightDescribe then
    CommonHelper:RegexName(value, function()
        PlayerInfoSubsystem:Get():SendChangePlayerSign(value)
    end)

    --end
end

function PagePlayerInfoRoleInfo:SetSign(sign)
    if PlayerDataManager:Get():GetPlayerSign() == nil or #PlayerDataManager:Get():GetPlayerSign() <= 0 then
        CommonHelper:SetInputFieldText("PersonalSignature", self.Root, ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerDefaultSign))
    else
        CommonHelper:SetInputFieldText("PersonalSignature", self.Root, PlayerDataManager:Get():GetPlayerSign())
    end
end

function PagePlayerInfoRoleInfo:SetName(name)
    CommonHelper:SetInputFieldText("PlayNameText", self.Root, PlayerDataManager:Get():GetPlayerName())
end

function PagePlayerInfoRoleInfo:UpdatePlayerIcon()
    CommonHelper:SetPlayerIconById("RoleIconGourp", self.Root, PlayerDataManager:Get():GetPlayerIcon(), PlayerDataManager:Get():GetPlayerIconFrame(), nil, UIModuleID.PlayerInfo)
end

function PagePlayerInfoRoleInfo:RoleInfoSetDataByMsg(msg)
    self.Rid = msg[1]
    self.Name = msg[2]
    self.ClubName = msg[3]
    self.Signature = msg[4]
    self.Lv = msg[5]
    self.IconId=msg[6]
    self.IconFrame= msg[7]
    CommonHelper:SetPlayerIconById("RoleIconGourp", self.Root, self.IconId, self.IconFrame, nil, UIModuleID.PlayerInfo)
    CommonHelper:SetInputFieldText("PlayNameText", self.Root, self.Name)
    if self.Signature==nil or CommonHelper:IsNullOrEmpty(self.Signature) then
        CommonHelper:SetInputFieldText("PersonalSignature", self.Root, ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerDefaultSign))
    else
        CommonHelper:SetInputFieldText("PersonalSignature", self.Root, self.Signature)
    end
    CommonHelper:SetText("###PlayIDText", self.Root, self.Rid)
    CommonHelper:SetText("###PlayClubText", self.Root, (self.ClubName==nil or CommonHelper:IsNullOrEmpty(self.ClubName) ) and ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerNoClubDefault) or self.ClubName)
    self:SetExp()
end

---@param msg SC_getPlayerInfoRes
function PagePlayerInfoRoleInfo:RoleInfoSetData(msg)
    self.CarList = CarDataManager:Get():GetCarList()
    --if msg.iconFrame==0 then
    --    msg.icon=16
    --end
    CommonHelper:SetPlayerIconById("RoleIconGourp", self.Root, PlayerDataManager:Get():GetPlayerIcon(), PlayerDataManager:Get():GetPlayerIconFrame(), nil, UIModuleID.PlayerInfo)
    CommonHelper:SetInputFieldText("PlayNameText", self.Root, PlayerDataManager:Get():GetPlayerName())
    if PlayerDataManager:Get():GetPlayerSign() == nil or #PlayerDataManager:Get():GetPlayerSign() <= 0 then
        CommonHelper:SetInputFieldText("PersonalSignature", self.Root, ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerDefaultSign))
    else
        CommonHelper:SetInputFieldText("PersonalSignature", self.Root, PlayerDataManager:Get():GetPlayerSign())
    end
    CommonHelper:SetText("###PlayIDText", self.Root, PlayerDataManager:Get():GetPlayerRID())
    --local serverData= ClientDataManager:Get():GetServerInfoByServerId(PlayerDataManager:Get():GetPlayerServerID())
    --if serverData then
    --    CommonHelper:SetText("###PlayServerText", self.Root, serverData.name)--这个地方服务器返回数据错误，暂时用的是enterplayer返回的，应该用消息返回的
    --end

    local clubName
    if PlayerDataManager:Get():GetGuildId() ~= ClubState.NoClub then
        clubName =  PlayerDataManager:Get():GetGuildName()
    else
        clubName = ClientDataManager:Get():GetTemplateString(TemplateStringID.PlayerNoClubDefault)
    end
    CommonHelper:SetText("###PlayClubText", self.Root, clubName)
    CommonHelper:SetText("###AllRankCount", self.Root, PlayerDataManager:Get():GetPlayerRankNum())
    if PlayerDataManager:Get():GetLevelId() ~= 0 then
        local levelData = PVEChapterDataManager:Get():GetLevelDataByLevelId(PlayerDataManager:Get():GetLevelId())
        if levelData then
            CommonHelper:SetText("###StoryPro", self.Root, string.format("%s", levelData.name))
        end
    else
        CommonHelper:SetText("###StoryPro", self.Root, "1-1")
    end
    CommonHelper:SetText("###WinRankCount", self.Root, PlayerDataManager:Get():GetPlayerWinNum())

   -- self:SetPersonScore(PlayerDataManager:Get():GetRankScore(), self.info1)
   -- self:SetPersonScore(PlayerDataManager:Get():GetPlayerRankScoreMax(), self.info2)
    self:SetCar()
    self:SetCup()
    self:SetExp()
end
function PagePlayerInfoRoleInfo:SetExp()
    local lv = PlayerDataManager:Get():GetPlayerLV()
    ---@type levelup_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.levelup_config, lv)

    local nextCfg=CommonHelper:GetTableDataByID(ConfigNames.levelup_config, lv+1)

    local totalExp = nextCfg == nil and 99999 or cfg.needexp

    local curExp = PlayerDataManager:Get():GetPlayerEXP()
    if nextCfg==nil and curExp>=totalExp then
        curExp=99999
        totalExp=99999
    end
    CommonHelper:SetText("###LabLV", self.Root, PlayerDataManager:Get():GetPlayerLV())
    CommonHelper:SetSlider("ExpSlider", self.Root, curExp / totalExp)
    CommonHelper:SetText("###expvalue", self.Root, string.format("%d/%d", curExp, totalExp))
end
function PagePlayerInfoRoleInfo:SetPersonScore(rankscore, obj)
    local score = rankscore
    ---@type qualifyingrank_config_cell
    local curcfg, minscore, maxscore = CommonHelper:GetRankCfgByScore(score)
    local process = (score - minscore) / (maxscore - minscore)
    if score > maxscore then
        CommonHelper:SetSlider("scoreslider", obj, 1)
        CommonHelper:SetText("###scoreprocess", obj, score)
    else
        CommonHelper:SetSlider("scoreslider", obj, process)
        CommonHelper:SetText("###scoreprocess", obj, score .. "/" .. maxscore)
    end

    CommonHelper:SetText("###scorevalue", obj, curcfg.name)
    CommonHelper:GetComponentSetUITexture("rankicon", obj, curcfg.icon, UIModuleID.RaceRank)

    for i = 1, 5 do
        CommonHelper:SetGameObjectActive("stargroup" .. i, obj, curcfg.star == i)
    end
end
function PagePlayerInfoRoleInfo:SetCar()
       HomeSceneCarMeshHelper:Get():LoadAllCar(SceneChangeID.RoleInfo)
end

function PagePlayerInfoRoleInfo:OnClose()
      HomeSceneCarMeshHelper:Get():ClearCache()
    if self.CupGo then
        GameObject.Destroy(self.CupGo)
        AssetsManager.Unload(self.CupAsset)
    end

end

function PagePlayerInfoRoleInfo:SetCup()
    local rootCup=HomeSceneHelper:GetCupRoot_RoleInfo()
    local exhibitDataList = PersonalHomeDataManager:Get().selfInfo:GetExhibitDic()
    local SeasonId=1
    local CupName=nil
    for i, exhibitData in pairs(exhibitDataList) do
        if exhibitData:GetParentSlot()==101 then
            ---@type dictexhibit_config_cell
            local cfgdata = CommonHelper:GetTableDataByID(ConfigNames.dictexhibit_config,exhibitData:GetExhibitID())
            CupName=cfgdata.configName
            SeasonId=tonumber(cfgdata.params)
        end
    end
    if CupName then
        self.CupAsset= AssetsManager.Load(CupName, typeof(GameObject))
        self.CupGo= CommonHelper:InstantiateGameObjectByObject(self.CupAsset.asset)
        UIUtil.SetParentTransform(rootCup,self.CupGo,true,false)
        mono.SetLayerName(self.CupGo,"Default")
        local textname={"num1","num2","num3" }
        CommonHelper:Set3D_TextGroup(textname,tostring(SeasonId),self.CupGo)
    end

end


