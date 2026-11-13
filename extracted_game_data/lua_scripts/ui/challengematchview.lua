---@class ChallengeMatchView : ViewBase
ChallengeMatchView = class("ChallengeMatchView", ViewBase)

function ChallengeMatchView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ChallengeMatchViewAction")

    self.ScenesList = {}
end

function ChallengeMatchView:Awake()

    self.ScrollView = self:GetChildWight("MoreRowScrollView_V", typeof(MoreRowScrollView))

    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnCreate", self.gameObject, function(hbtn)
        CommonHelper:CheckMini4wdRule(UIModuleID.ChallengeMatch,function()
            if UIManager:Get():IsViewShow("ChallengeMatchCreateView") == false then
                UIManager:Get():OpenView("ChallengeMatchCreateView", CanvasType.MainCanvas, "ChallengeMatchCreateView")
            end
        end)
    end)

    CommonHelper:HButtonSetCallback("BtnShop", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Shop,ShopID.GiftBag)
    end)

    --我的赛事,暂时隐藏
    --CommonHelper:HButtonSetCallback("BtnMine", self.gameObject, function(hbtn)
    --
    --end)

    self.BtnRefresh = CommonHelper:HButtonSetCallback("BtnRefresh", self.gameObject, function(hbtn)
        CommonHelper:SetBtnDelayClick(self.BtnRefresh, 1, false)
        ChallengeMatchSubsystem:SendMsg_BattleList()
    end)

    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(param)
        CommonHelper:ShowHelpView(PageDetailType.ChallengeMatch)
    end)

end

function ChallengeMatchView:OnOpen()
    CommonHelper:IsOpenMini4wdRuleView(UIModuleID.ChallengeMatch)
    self:SetFightNum(ChallengeMatchManager:Get():GetFightNum())
    self:SetRoomNum(ChallengeMatchManager:Get():GetBattleRoomDataLen())
end

function ChallengeMatchView:ReOpen()
    CommonHelper:SetBtnDelayClick(self.BtnRefresh, 1, false)
    ChallengeMatchSubsystem:SendMsg_BattleList()
end

function ChallengeMatchView:SetFightNum(fightNum)
    CommonHelper:SetText("FightNum/###text", self.gameObject,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchBattleAward_15), fightNum))
end

function ChallengeMatchView:SetRoomNum(roomNum)
    CommonHelper:SetText("RoomNum/###text", self.gameObject,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchBattleAward_18), 100 - roomNum))
end
local _Data =nil
function ChallengeMatchView:InitData(flag)

    ---@type dictbattleaward_config
    local dictbattleaward_config = ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)

    _Data = ChallengeMatchManager:Get():SortData()

    if #_Data == 0 then
        CommonHelper:SetGameObjectActive("NoMatch", self.gameObject, true)
        CommonHelper:SetGameObjectActive("MoreRowScrollView_V", self.gameObject, false)
    else
        CommonHelper:SetGameObjectActive("NoMatch", self.gameObject, false)
        CommonHelper:SetGameObjectActive("MoreRowScrollView_V", self.gameObject, true)

        cs_coroutine.start(function()
            coroutine.yield()
            coroutine.yield()
            CommonHelper:InitMoreRowScrollView(self.ScrollView, #_Data, 3, function(index, itemObj, scroll)
                ---@type MatchRoomData
                local _itemData = _Data[index + 1]
                CommonHelper:SetText("###RoomName", itemObj, _itemData.roleName)
                if _itemData.createID and _itemData.createID == PlayerDataManager:Get():GetPlayerRID() then
                    CommonHelper:SetText("###Name", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchBattleAward_1))
                    CommonHelper:SetGameObjectActive("BtnForwarding", itemObj, true)
                    --转发
                    CommonHelper:HButtonSetCallback("BtnForwarding", itemObj, function(hbtn)
                        ---@type  ChallengeMatchShareData
                        local userdata = {  }
                        userdata.id = _itemData.createID
                        userdata.resultTime = _itemData.resultTime
                        userdata.awardID = _itemData.awardID

                        local pos = hbtn.transform.position
                        CommonHelper:ShareToChat(ShareType.ChallengeMatchInvite, userdata, pos)
                    end)
                else
                    if _itemData.IsSystem==1 then
                        CommonHelper:SetText("###Name", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatch_CreateSystem))
                    else
                        CommonHelper:SetText("###Name", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchBattleAward_2))
                    end
                    CommonHelper:SetGameObjectActive("BtnForwarding", itemObj, false)
                end
                local typeData = dictbattleaward_config.GetDataByAwardID(tonumber(_itemData.awardID))
                local imgType = stringSplit(typeData[1].jackpottype, ':')
                CommonHelper:GetComponentSetImage("###showIcon", itemObj, CommonHelper:GetCurrencyTypeImage(tonumber(imgType[1])), UIModuleID.ChallengeMatch)

                CommonHelper:SetText("###CreateName", itemObj,
                        string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchBattleAward_3), _itemData.roleName))

                CommonHelper:SetText("###GuildName", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchBattleAward_4), _itemData.guildName))

                if _itemData.diamondPool > tonumber(imgType[4]) then
                    _itemData.diamondPool = tonumber(imgType[4])
                end
                CommonHelper:SetText("###showNum", itemObj, _itemData.diamondPool)

                if #_itemData.rank3 == 0 then
                    CommonHelper:SetText("###FirstName", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankNoRank))
                    CommonHelper:SetPlayerIconById("PlayerIcon", itemObj, 0, 0, nil, UIModuleID.ChallengeMatch)

                else
                    CommonHelper:SetText("###FirstName", itemObj, _itemData.rank3[1].rolename)
                    CommonHelper:SetPlayerIconById("PlayerIcon", itemObj,
                            tonumber(_itemData.rank3[1].headicon), tonumber(_itemData.rank3[1].iconframe), nil, UIModuleID.ChallengeMatch)
                end
                local sceneCfg= CommonHelper:GetTableDataByID(ConfigNames.scene_config,tonumber(_itemData.sceneID))
                CommonHelper:GetComponentSetUITexture("middleBg", itemObj, sceneCfg.icon, UIModuleID.ChallengeMatch)

                local _resultTime = CommonHelper:ConvertIntToDataTime(_itemData.resultTime * 1000)

                CommonHelper:SetText("###TimeRemaining", itemObj,
                        string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchBattleAward_6,
                                _resultTime.Month, _resultTime.Day, _resultTime.Hour, _resultTime.Minute)))

                CommonHelper:HButtonSetCallback("BtnJoin", itemObj, function(hbtn)
                    CommonHelper:CheckMini4wdRule(UIModuleID.ChallengeMatch,function()
                        ChallengeMatchSubsystem:SendMsg_BattleDetail(_itemData.createID)
                    end)
                end)

                CommonHelper:SetGameObjectActive("newObj", itemObj, ChallengeMatchManager:Get():GetRecordsNewStateByID(_itemData.createID))

                CommonHelper:SetGameObjectActive("AdmireImg_Y", itemObj, ChallengeMatchManager:Get():GetRecordsAgreeStateByID(_itemData.createID))
                CommonHelper:SetText("###Admiretext", itemObj, _itemData.agree)
                CommonHelper:HButtonSetCallback("AdmireBtn", itemObj, function(hbtn)
                    if tonumber(_itemData.resultTime) < CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) then
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchOverTime))
                    else
                        if ChallengeMatchManager:Get():GetRecordsDataByID(_itemData.createID) ~= nil then
                            if ChallengeMatchManager:Get():GetRecordsAgreeStateByID(_itemData.createID) then
                                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchAlreadyAdmire))
                            else
                                ChallengeMatchSubsystem:SendMsg_BattleAgree(_itemData.createID)
                            end
                        else
                            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchNoJoinNoAdmire))
                        end

                    end
                end)

            end)
        end,false,nil,flag)

        CommonHelper:MoreRowView_EnterAniRace(self.ScrollView, 0.12)
    end
end

function ChallengeMatchView:RefreshData()
    self:SetFightNum(ChallengeMatchManager:Get():GetFightNum())
    self:SetRoomNum(ChallengeMatchManager:Get():GetBattleRoomDataLen())
    _Data = ChallengeMatchManager:Get():SortData()
    UINotify:Get():SendNotification(UINotifyEvent.ChallengeMatch_InitData,false)
end

function ChallengeMatchView:OnClose()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId = nil
    end
    CommonHelper:ReleasePool(UIModuleID.ChallengeMatch)
end
