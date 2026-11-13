---@class PageBattleResultPlayerRank
PageBattleResultPlayerRank = class("PageBattleResultPlayerRank")

function PageBattleResultPlayerRank:initialize(battleInfoCG)
    self.battleInfoCG=battleInfoCG
end
function PageBattleResultPlayerRank:InitPlayerRank(gameObj,more,data,datas,moduleId)
    self.parentPref=gameObj
    self.moduleId=moduleId
    self.battleResultData=data
    if more then
        CommonHelper:SetGameObjectActive("BattleInfo",self.parentPref,false)
        CommonHelper:SetGameObjectActive("TitleScrollView",self.parentPref,true)
        if PVEChapterDataManager:Get():GetBattleResult() then
         self:InitMoreRankList(datas)
        end
    else
        CommonHelper:SetGameObjectActive("BattleInfo",self.parentPref,true)
        CommonHelper:SetGameObjectActive("TitleScrollView",self.parentPref,false)
        if self.battleResultData then
            self:InitRankList(data:GetPlayerList())
        end
    end
end


---@param playerListData table<number,BattleResultPlayerData>
function PageBattleResultPlayerRank:InitRankList(playerListData)
    self.selfIndex = -1
    for i = 1, 5 do
        local isActive = playerListData[i] ~= nil
        local tweenRankItem = CommonHelper:SetGameObjectActive(string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "tweenRank", tostring(i)), self.parentPref, isActive)
        if isActive then
            if self.selfIndex == -1 then
                if playerListData[i]:GetPid() == BattleDataManager:Get():GetDefaultPlayerId() then
                    self.selfIndex = i
                end
            end
            self:InitOneRankItem(tweenRankItem, playerListData[i], self.selfIndex)
        end
    end
    self.BattleCompareType={BattleCompareType.Speed,BattleCompareType.LastingLong,BattleCompareType.ShockAbsorption}
end
---@param playerListData table<number,BattleResultPlayerData>[]
function PageBattleResultPlayerRank:InitMoreRankList(playerListData)
    self.ScrollData={}
    for i = 1, #playerListData do
        local temp = MoreRowScrollViewTittleGroup()
        temp.tittle = playerListData[i].tittle
        temp.totle = #playerListData[i].result.PlayerList
        temp.groupIndex = i
        table.insert(self.ScrollData, temp)
    end
    self.TittleScrollView = UIUtil.GetTypeChildWightByParent("TitleScrollView", self.parentPref, typeof(MoreRowScrollViewTittle))
    CommonHelper:MoreRowTitle_Init(self.TittleScrollView, self.ScrollData, 1,function(title, tittleIdx, itemObj, type ,dataIndex, scroll)
        if type==TittleItemType.Title then
            CommonHelper:SetText("###tittle",itemObj,title)
        end
        if type == TittleItemType.Item then
            self.selfIndex = -1
            if self.selfIndex == -1 then
                if playerListData[tittleIdx].result.PlayerList[dataIndex+1]:GetPid() == BattleDataManager:Get():GetDefaultPlayerId() then
                    self.selfIndex = dataIndex+1
                end
            end
            self:InitOneRankItem(itemObj, playerListData[tittleIdx].result.PlayerList[dataIndex+1],self.selfIndex)
        end
    end)
    self.selfIndex = -1
    for i = 1, #self.battleResultData.PlayerList do
        if self.battleResultData.PlayerList[i]:GetPid() == BattleDataManager:Get():GetDefaultPlayerId() then
            self.selfIndex = i
            break
        end
    end
    self.BattleCompareType={BattleCompareType.Speed,BattleCompareType.LastingLong,BattleCompareType.ShockAbsorption}
end
---@param playerData BattleResultPlayerData
function PageBattleResultPlayerRank:InitOneRankItem(itemPref, playerData,selfIdx)
    print(playerData:GetName())
    CommonHelper:SetText("###PlayerName", itemPref, playerData:GetName())

    if playerData:GetError() == BattleFailError.None then
        if playerData:GetTime() == 0 then
            CommonHelper:SetText("###Time", itemPref, CommonHelper:GetTempStr_Default(TemplateStringID.BattleResultTime))
        else
            CommonHelper:GetComponentTransferTime("###Time", itemPref, playerData:GetTime())
        end
    else
        if BattleDataManager:Get():GetBattleType()==RaceModel.RaceSuperBattle then
            local result = CommonHelper:TransferTime(math.abs(playerData:GetTime()), 0.001)
            CommonHelper:SetText("###Time", itemPref, "-"..CommonHelper:TransferTimeToString(result))
        else
            CommonHelper:SetText("###Time", itemPref, CommonHelper:GetTempStr_BattleFailErrorTips(playerData:GetError()))
        end
    end
    for i = 1, 5 do
        CommonHelper:SetGameObjectActive("ranktype"..i, itemPref, playerData:GetRank()==i)
    end
    CommonHelper:SetPlayerIcon("PlayerIcon80", itemPref, playerData:GetIcon(), playerData:GetIconFrame(), nil, self.moduleId)

    CommonHelper:SetGameObjectActive("HeadBlackBg", itemPref, playerData:GetPid() == BattleDataManager:Get():GetDefaultPlayerId())
    CommonHelper:SetGameObjectActive("BtnInfo", itemPref, playerData:GetPlayerType() ~= PlayerType.None and playerData:GetPlayerType() ~= PlayerType.NPC)

    CommonHelper:HButtonSetCallback("BtnInfo", itemPref, function(param)
        CommonHelper:ShowCarInfoByCarReviewData(playerData:GetCarReview())
    end)

    --local BtnHelpError= CommonHelper:HButtonSetCallback("BtnError", itemPref, function()
    --    CommonHelper:ShowHelpView(playerData:GetError())
    --end)
    --CommonHelper:SetHButtonClick(BtnHelpError,playerData:GetPid()== BattleDataManager:Get():GetDefaultPlayerId() and playerData:GetError()~=nil and playerData:GetError()~=BattleFailError.None,true)

    local BtnCompare = CommonHelper:HButtonSetCallback("BtnCompare", itemPref, function(param)
        self:OnCompareBtn(playerData)
    end)

    --local battleType = BattleDataManager:Get():GetBattleType()
    CommonHelper:SetHButtonClick(BtnCompare,   playerData:GetPid()~=BattleDataManager:Get():GetDefaultPlayerId(), true)

    --local carName = ClientDataManager:Get():GetTemplateString(playerData:GetCarReview().ShellCfg.carNameid)
end
function PageBattleResultPlayerRank:SetCompareSpeed(idx)
    self.CurIdx=idx
    local type=self.BattleCompareType[self.CurIdx]
    cs_coroutine.start(function()
        CSCameraManager.Get():RecoverMaskLayer()
        CSLuaHelper.BattleCompareResult( self.CurCarId,type)
        local rawImg = UIUtil.GetTypeChildWightByParent("BattleInfoRw", self.battleInfoCG.gameObject, typeof(RawImage))
        rawImg.texture = CSLuaHelper.GetBattleCompareRenderTexture(type)
        CommonHelper:SetText("BtnSpeed/###text",self.battleInfoCG.gameObject,CommonHelper:GetBattleCompareType(type))
        for i=-1,1 do
            CommonHelper:SetGameObjectActive("State"..i,self.battleInfoCG.gameObject,type==i)
        end
        coroutine.yield()
        self.CameraLayer=CSCameraManager.Get()._MainCamera.cullingMask
        CSCameraManager.Get():ClearAllMaskLayer()
    end)

end

---@param playerData BattleResultPlayerData
function PageBattleResultPlayerRank:OnCompareBtn(playerData)
    local carDyData = BattleDyDataManager:Get():GetCarDataByRank(playerData:GetRank())
    CSLuaHelper.BattleCompareResult(carDyData:GetCarId())
    self.CurCarId=carDyData:GetCarId()
    UIUtil.ShowCanvasGroup(self.battleInfoCG, true)
    self:SetCompareSpeed(1)
    CommonHelper:HButtonSetCallback("BtnCloseInfo", self.battleInfoCG.gameObject, function(hbtn)
        CSCameraManager.Get():RecoverMaskLayer()
        UIUtil.ShowCanvasGroup(self.battleInfoCG, false)
        CSLuaHelper.ReleaseBattleCompareRenderTexture()
    end)
    CommonHelper:HButtonSetCallback("BtnLeft",self.battleInfoCG.gameObject,function()
        if self.CurIdx>1 then
            self:SetCompareSpeed(self.CurIdx-1)
        else
            self:SetCompareSpeed(#self.BattleCompareType)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnRight",self.battleInfoCG.gameObject,function()
        if self.CurIdx<#self.BattleCompareType then
            self:SetCompareSpeed(self.CurIdx+1)
        else
            self:SetCompareSpeed(1)
        end
    end)
    ---@type BattleResultPlayerData
    local playerDataList = self.battleResultData:GetPlayerList()
    playerDataList = playerDataList[self.selfIndex]

    for i = 1, 5 do
        CommonHelper:SetGameObjectActive("LeftPlayer/ranktype" .. i, self.battleInfoCG.gameObject, playerDataList:GetRank() == i)
        CommonHelper:SetGameObjectActive("RightPlayer/ranktype" .. i, self.battleInfoCG.gameObject, playerData:GetRank() == i)
    end

    if (playerDataList:GetError() ~= BattleFailError.None) or (playerDataList:GetError() == BattleFailError.None and playerDataList:GetTime() == 0) then
        CommonHelper:SetText("LeftPlayer/###curTimeText", self.battleInfoCG.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.BattleResultTime))
    else
        CommonHelper:GetComponentTransferTime("LeftPlayer/###curTimeText", self.battleInfoCG.gameObject, playerDataList:GetTime())
    end

    if (playerData:GetError() ~= BattleFailError.None) or (playerData:GetError() == BattleFailError.None and playerData:GetTime() == 0) then
        CommonHelper:SetText("RightPlayer/###curTimeText", self.battleInfoCG.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.BattleResultTime))
    else
        CommonHelper:GetComponentTransferTime("RightPlayer/###curTimeText", self.battleInfoCG.gameObject, playerData:GetTime())
    end
end
