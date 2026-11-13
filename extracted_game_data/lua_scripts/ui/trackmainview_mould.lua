--赛道科技

local selectTitleID = 1
local selectMouldID = 1

function TrackMainView:InitMouldBaseInfo()
    selectTitleID = 1
    self:InitTitleBtnScrollInfo()
    self:InitMouldBtnScrollInfo(0)

    ---@type dicttech_config
    local dicttech_config = ClientDataManager:Get():GetDataTable(ConfigNames.dicttech_config)
    local data = dicttech_config.GetById(1)
    self:UpdateIntroduce(data.C_ID, MouldType.MouldItem)
end

function TrackMainView:InitTitleBtnScrollInfo()
    ---@type dictscience_config
    local dictScience_Config = ClientDataManager:Get():GetDataTable(ConfigNames.dictscience_config)

    ---@type dicttech_config
    local dicttech_config = ClientDataManager:Get():GetDataTable(ConfigNames.dicttech_config)

    local floorFull = dicttech_config.GetFloorFullTable()

    local UpdateFunc = function(dataIndex, itemObj, scroll)

        local titleItemData = dictScience_Config.GetById(dataIndex + 1)

        CommonHelper:SetText("dark/Text", itemObj, CommonHelper:GetTempStr_Default(titleItemData.name))
        CommonHelper:SetText("light/Text", itemObj, CommonHelper:GetTempStr_Default(titleItemData.name))

        local lvIDData = TrackDataManager:Get():GetTrackTitleData(dataIndex + 1)
        CommonHelper:SetGameObjectActive("TitleLockBtn", itemObj, lvIDData[2] == 0)

        CommonHelper:HButtonSetCallback("TitleLockBtn", itemObj, function()
            self:OnOpenScienceLevBtn(titleItemData.name, titleItemData.C_ID, tonumber(titleItemData.consumenums))
        end)

        CommonHelper:HButtonSetCallback("TitleChooseBtn", itemObj, function()
            selectTitleID = dataIndex + 1
            self:InitMouldBtnScrollInfo(dataIndex)
        end)

        CommonHelper:SetGameObjectActive("light", itemObj, selectTitleID == dataIndex + 1)
        CommonHelper:SetGameObjectActive("dark", itemObj, selectTitleID ~= dataIndex + 1)

    end

    CommonHelper:InitMoreRowScrollView(self.TitleBtnScroll, #floorFull, 1, UpdateFunc, true)

end

function TrackMainView:InitMouldBtnScrollInfo(dataIndex)

    ---@type dicttech_config
    local dicttech_config = ClientDataManager:Get():GetDataTable(ConfigNames.dicttech_config)
    local ItemData = dicttech_config.GetDataByFloor(dataIndex + 1)

    local UpdateFunc = function(itemIndex, itemObjV, scroll)
        local ItemDataV = dicttech_config.GetById(ItemData[itemIndex + 1])

        ---@type TrackItemData
        local itemDataDic = TrackDataManager:Get():GetTrackItemDataDicByID(ItemDataV.C_ID)

        CommonHelper:SetText("###ItemText", itemObjV, CommonHelper:GetTempStr_Default(ItemDataV.name))
        CommonHelper:SetGameObjectActive("ItemLock", itemObjV, itemDataDic.curStatus == 0)

        CommonHelper:GetComponentSetUITexture("###ItemIcon", itemObjV, ItemDataV.icon, UIModuleID.TrackScience)

        CommonHelper:SetGameObjectActive("ChooseIcon", itemObjV, selectMouldID == ItemDataV.C_ID)

        CommonHelper:HButtonSetCallback("ItemBtn", itemObjV, function()
            self:OnItemBtnVClick(ItemDataV.C_ID, MouldType.MouldItem, dataIndex)
        end)

    end

    CommonHelper:InitMoreRowScrollView(self.MouldBtnScroll, #ItemData, 4, UpdateFunc, true)

    UINotify:Get():SendNotification(UINotifyEvent.TrackScienceMenuView_UpdateTitleScroll)

end

function TrackMainView:OnItemBtnVClick(dataID, type, index)
    selectMouldID = dataID

    UINotify:Get():SendNotification(UINotifyEvent.TrackScienceMenuView_InitIntroduceData, { dataID, type })
    UINotify:Get():SendNotification(UINotifyEvent.TrackScienceMenuView_UpdateMouldScroll, { index })

end

function TrackMainView:UpdateIntroduce(data, type)

    if type == MouldType.MouldItem then

        ---@type dicttech_config
        local dicttech_config = ClientDataManager:Get():GetDataTable(ConfigNames.dicttech_config)
        local ItemDataV = dicttech_config.GetById(data)

        local selfDefineTime = CommonHelper:GetSelfTransferTimeStr(ItemDataV.alivecd * 1000)
        CommonHelper:SetText("###ComposeTimeText", self.MouldCG.gameObject, string.format(
                CommonHelper:GetTempStr_Default(TemplateStringID.HMS),
                selfDefineTime.hour,
                selfDefineTime.minute,
                selfDefineTime.second)
        )

        CommonHelper:SetText("###NameText", self.MouldCG.gameObject, CommonHelper:GetTempStr_Default(ItemDataV.name))
        CommonHelper:SetText("###InfoText", self.MouldCG.gameObject, CommonHelper:GetTempStr_Default(ItemDataV.desc))

        local aliveID = stringSplit(ItemDataV.aliveconsumes, ':')
        local aliveNum = stringSplit(ItemDataV.alivenums, ':')

        CommonHelper:SetGameObjectActive("ComposeTimeText", self.MouldCG.gameObject, true)
        CommonHelper:SetGameObjectActive("ConsumePropCountText", self.MouldCG.gameObject, true)
        CommonHelper:SetGameObjectActive("###InfoText", self.MouldCG.gameObject, true)

        CommonHelper:SetText("###ConsumeCountText", self.MouldCG.gameObject, CommonHelper:GetTempStr_Default(aliveNum[1]))
        CommonHelper:SetText("###ConsumePropCountText", self.MouldCG.gameObject, CommonHelper:GetTempStr_Default(aliveNum[2]))

        CommonHelper:GetComponentSetImage("TenTicketIcon", self.MouldCG.gameObject, CommonHelper:GetCurrencyTypeImage(tonumber(aliveID[1])), UIModuleID.TrackScience)
        CommonHelper:GetComponentSetImage("PropIcon", self.MouldCG.gameObject, CommonHelper:GetCurrencyTypeImage(tonumber(aliveID[2])), UIModuleID.TrackScience)

        ---@type TrackItemData
        local itemDataDic = TrackDataManager:Get():GetTrackItemDataDicByID(ItemDataV.C_ID)
        CommonHelper:SetGameObjectActive("BtnMould", self.MouldCG.gameObject, itemDataDic.curStatus == 0)

        self.BtnMould = CommonHelper:HButtonSetCallback("BtnMould", self.MouldCG.gameObject, function(data)
            -- --发送请求激活天赋 P2=天赋id 175
            LabSubsystem:Get():SendMsg_AliveTech(ItemDataV.C_ID)
        end)

        local Introduce = UIUtil.GetChild("Introduce", self.MouldCG.gameObject)
        CommonHelper:GetComponentSetUITexture("###ShowIcon", Introduce, ItemDataV.icon, UIModuleID.TrackScience)

    end


end
