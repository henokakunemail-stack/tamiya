--赛道生产

function TrackMainView:InitManufactureBaseInfo()
    self:InitManufactureScrollInfo()

    ---@type dicttrackprop_config
    local dicttrackprop_config = ClientDataManager:Get():GetDataTable(ConfigNames.dicttrackprop_config)
    local trackPropData = dicttrackprop_config.GetConfigData()
    self:UpdateManufactureIntroduce(trackPropData[1].C_ID)
end

local selectBtnID = 1

function TrackMainView:InitManufactureScrollInfo()

    ---@type dicttrackprop_config
    local dicttrackprop = ClientDataManager:Get():GetDataTable(ConfigNames.dicttrackprop_config)

    local UpdateFunc = function(dataIndex, itemObj, scroll)

        local ItemDataV = dicttrackprop.GetConfigDataByNum(dataIndex + 1)

        local LockState = TrackDataManager:Get():GetTrackManufactureItemDataByID(ItemDataV.C_ID)

        CommonHelper:SetGameObjectActive("ItemLock", itemObj, LockState)

        CommonHelper:SetGameObjectActive("ChooseIcon", itemObj, selectBtnID == ItemDataV.C_ID)

        local TimeTrackSegmentObj = UIUtil.GetChild("ItemTrackSegment", itemObj)
        self:SetManufactureItem(TimeTrackSegmentObj, ItemDataV)

        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function()
            self:OnManufactureItemBtnClick(ItemDataV.C_ID)
        end)

    end

    CommonHelper:InitMoreRowScrollView(self.ManufactureScroll, dicttrackprop.GetConfigDataLen(), 6, UpdateFunc, true, nil, false)
end

function TrackMainView:OnManufactureItemBtnClick(dataIndex)
    selectBtnID = dataIndex

    self:InitManufactureBaseInfo()
    
    UINotify:Get():SendNotification(UINotifyEvent.TrackScienceMenuView_InitManufactureIntroduceData, { dataIndex })


end

local __AddNum = -1
function TrackMainView:UpdateManufactureIntroduce(data)
    local TrackManufactureMax = tonumber(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.TrackManufactureMax).varval)
    ---@type tracksegement_config
    local tracksegement_config = ClientDataManager:Get():GetDataTable(ConfigNames.tracksegement_config)
    local showData = tracksegement_config.GetById(data)

    ---@type dicttrackprop_config
    local dicttrackprop_config = ClientDataManager:Get():GetDataTable(ConfigNames.dicttrackprop_config)
    local propData = dicttrackprop_config.GetById(data)

    __AddNum = 1
    self:SetUseNum(propData)

    local selfDefineTime = CommonHelper:GetSelfTransferTimeStr(propData.proctime * 1000)
    CommonHelper:SetText("###ComposeTimeText", self.ManufactureCG.gameObject, string.format(
            CommonHelper:GetTempStr_Default(TemplateStringID.HMS),
            selfDefineTime.hour,
            selfDefineTime.minute,
            selfDefineTime.second)
    )

    CommonHelper:SetText("###NameText", self.ManufactureCG.gameObject, CommonHelper:GetTempStr_Default(showData.name))
    CommonHelper:SetText("###InfoText", self.ManufactureCG.gameObject, CommonHelper:GetTempStr_Default(showData.desc))

    CommonHelper:SetText("###ConsumeCountText", self.ManufactureCG.gameObject, propData.proctrackgold)

    local ManufactureTrackSegmentObj = UIUtil.GetChild("ManufactureTrackSegment", self.ManufactureCG.gameObject)
    self:SetManufactureItem(ManufactureTrackSegmentObj, showData)

    CommonHelper:HButtonSetCallback("BtnManufacture", self.ManufactureCG.gameObject, function()
        LabSubsystem:Get():SendMsg_ProcTrack(showData.C_ID, __AddNum)
    end)

    CommonHelper:HButtonSetCallback("BtnEditorAdd", self.gameObject, function(data)
        __AddNum = __AddNum + 1

        if __AddNum >= TrackManufactureMax then
            __AddNum = TrackManufactureMax
        end
        self:SetUseNum(propData)
    end)

    CommonHelper:HButtonSetCallback("BtnEditorRemove", self.gameObject, function(data)
        __AddNum = __AddNum - 1
        if __AddNum <= 1 then
            __AddNum = 1
        end
        self:SetUseNum(propData)
    end)

end

function TrackMainView:SetUseNum(propData)
    CommonHelper:SetText("###ConsumeCountText", self.ManufactureCG.gameObject, propData.proctrackgold * __AddNum)

    local selfDefineTime = CommonHelper:GetSelfTransferTimeStr(propData.proctime * 1000 * __AddNum)
    CommonHelper:SetText("###ComposeTimeText", self.ManufactureCG.gameObject, string.format(
            CommonHelper:GetTempStr_Default(TemplateStringID.HMS),
            selfDefineTime.hour,
            selfDefineTime.minute,
            selfDefineTime.second)
    )
    CommonHelper:SetInputFieldText("###InputText", self.gameObject, __AddNum)
end

function TrackMainView:SetManufactureItem(itemObj, data)
    local needNum = 0
    local curNum = 0
    local param = Param_TrackSegmentGroup()
    param.moduleId = UIModuleID.TrackScience
    param.trackSegmentId = data.C_ID
    param.count = needNum <= curNum and CommonHelper:GetTempStr_Default(TemplateStringID.CustomTackEditNum1, needNum, curNum) or CommonHelper:GetTempStr_Default(TemplateStringID.CustomTackEditNum2, needNum, curNum)
    param.showcount = false
    param.showname = false
    param.isdirection = false
    CommonHelper:SetTrackSegmentGroup(itemObj, param)
end