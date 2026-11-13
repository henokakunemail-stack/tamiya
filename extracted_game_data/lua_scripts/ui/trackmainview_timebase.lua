----初始化右边的时间列表
---@param labExpType LabExpType
function TrackMainView:InitTimeList(labExpType)

    ---@type dicttech_config
    local dicttech_config = ClientDataManager:Get():GetDataTable(ConfigNames.dicttech_config)

    ---@type dictcalc_config
    local LabSpeedConsumeID = tonumber(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.LabSpeedConsumeID).varval)

    self.chooseExpType = labExpType

    if labExpType == LabToggleType.SegTech then
        local itemCDData = TrackDataManager:Get():GetTrackCdDataByType(labExpType)

        local UpdateCDFunc = function(ItemIndex, itemObjCD, scroll)
            local ItemDataV = dicttech_config.GetById(itemCDData[ItemIndex + 1].techId)

            CommonHelper:SetText("###NameTimeText", itemObjCD, CommonHelper:GetTempStr_Default(ItemDataV.name))
            CommonHelper:SetGameObjectActive("TimeTrackSegment", itemObjCD, false)
            CommonHelper:GetComponentSetUITexture("###TimeIcon", itemObjCD, ItemDataV.icon, UIModuleID.TrackScience)
            CommonHelper:SetGameObjectActive("###TimeIcon", itemObjCD, true)

            local CDData = itemCDData[ItemIndex + 1]

            local _nowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
            CommonHelper:SetGameObjectActive("SpeedBtn", itemObjCD, _nowTime < itemCDData[ItemIndex + 1].startTime)
            CommonHelper:SetGameObjectActive("GetBtn", itemObjCD, _nowTime >= itemCDData[ItemIndex + 1].startTime)

            local time = dicttech_config.GetById(itemCDData[ItemIndex + 1].techId).alivecd
            local costNum = 0

            CommonHelper:HButtonSetCallback("SpeedBtn", itemObjCD, function()
                local differenceValueTime = CDData:GetStartTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
                costNum = math.floor(differenceValueTime / 60) * LabSpeedConsumeID
                if costNum > 0 then
                    self:OnSpeedUpBtn(labExpType, CDData:GetId(), costNum)
                end
            end)

            local groupBtn = UIUtil.GetGameobjectComponent(itemObjCD, typeof(HButton))
            groupBtn.intData = ItemIndex + 1
            groupBtn.longData = time

            CommonHelper:HButtonSetCallback("GetBtn", itemObjCD, function()
                ---发送完成激活天赋 P2=天赋id P3=0 CD 1立即完成 177
                LabSubsystem:Get():SendMsg_FinishAlive(ItemDataV.C_ID, 0)
            end)
        end
        CommonHelper:InitMoreRowScrollView(self.TimeScroll, #itemCDData, 1, UpdateCDFunc, true)
    end

    if labExpType == LabToggleType.SegProduct then

        local itemCDData = TrackDataManager:Get():GetTrackCdDataByType(labExpType)

        local UpdateCDFunc = function(ItemIndex, itemObjCD, scroll)

            ---@type tracksegement_config
            local tracksegement_config = ClientDataManager:Get():GetDataTable(ConfigNames.tracksegement_config)
            local ItemDataV = tracksegement_config.GetById(itemCDData[ItemIndex + 1].techId)

            CommonHelper:SetText("###NameTimeText", itemObjCD, CommonHelper:GetTempStr_Default(ItemDataV.name))

            CommonHelper:SetGameObjectActive("TimeTrackSegment", itemObjCD, true)
            CommonHelper:SetGameObjectActive("###TimeIcon", itemObjCD, false)

            local TimeTrackSegmentObj = UIUtil.GetChild("TimeTrackSegment", itemObjCD)
            self:SetManufactureItem(TimeTrackSegmentObj, ItemDataV)

            local _nowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
            CommonHelper:SetGameObjectActive("SpeedBtn", itemObjCD, _nowTime < itemCDData[ItemIndex + 1].startTime)
            CommonHelper:SetGameObjectActive("GetBtn", itemObjCD, _nowTime >= itemCDData[ItemIndex + 1].startTime)

            local time = (dicttech_config.GetTechIDByProctracksID(itemCDData[ItemIndex + 1].techId).alivecd) * (itemCDData[ItemIndex + 1].procnum)
            local CDData = itemCDData[ItemIndex + 1]
            local costNum = 0

            CommonHelper:HButtonSetCallback("SpeedBtn", itemObjCD, function()
                local differenceValueTime = CDData:GetStartTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
                costNum = math.floor(differenceValueTime / 60) * LabSpeedConsumeID
                if costNum > 0 then
                    self:OnSpeedUpBtn(labExpType, CDData:GetId(), costNum)
                end
            end)

            local groupBtn = UIUtil.GetGameobjectComponent(itemObjCD, typeof(HButton))
            groupBtn.intData = ItemIndex + 1
            groupBtn.longData = time

            CommonHelper:HButtonSetCallback("GetBtn", itemObjCD, function(data)
                ---发送完成赛道 P2=赛道id P3=0 CD 1立即完成 181
                LabSubsystem:Get():SendMsg_FinishTrack(data.intData, 0)
            end, ItemDataV.C_ID)
        end
        CommonHelper:InitMoreRowScrollView(self.TimeScroll, #itemCDData, 1, UpdateCDFunc, true)
        self:RefreshItemProgress()

    end

end

function TrackMainView:RefreshItemProgress()
    local contentTrans = self.TimeScrollContentTrans
    local curTabCDData = TrackDataManager:Get():GetTrackCdDataByType(self.chooseExpType)
    local itemCount = contentTrans.childCount

    for i = 1, itemCount do
        local item = contentTrans:GetChild(i - 1)
        local groupBtn = UIUtil.GetGameobjectComponent(item.gameObject, typeof(HButton))
        local cdIndex = groupBtn.intData
        local time = groupBtn.longData

        if #curTabCDData >= cdIndex and cdIndex >= 1 then
            local _cdData = curTabCDData[cdIndex]
            local timeSlider = UIUtil.GetTypeChildWightByParent("TimeSlider", item.gameObject, typeof(Slider))

            local differenceValueTime = _cdData.startTime - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
            if differenceValueTime <= 0 then
                differenceValueTime = 0
            end
            CommonHelper:SetSliderValue(timeSlider, 1 - differenceValueTime / time)
            local selfDefineTime = CommonHelper:GetSelfTransferTimeStr(differenceValueTime, 1)
            CommonHelper:SetText("###leftTimeText", item.gameObject,
                    string.format(CommonHelper:GetTempStr_Default(TemplateStringID.HMS), selfDefineTime.hour, selfDefineTime.minute, selfDefineTime.second))

            if differenceValueTime <= 0 and cdIndex > 0 then
                groupBtn.intData = -1
                CommonHelper:SetGameObjectActive("SpeedBtn", item.gameObject, false)
                CommonHelper:SetGameObjectActive("GetBtn", item.gameObject, true)
            end
        end
    end

end

function TrackMainView:UpdateTimeList()
    CommonHelper:MoreRowView_RefreshCurList(self.TimeScroll, false)
end

function TrackMainView:OnSpeedUpBtn(labExpType, CdId, costNum)
    costNum = costNum > 0 and costNum or 1
    if labExpType == LabToggleType.SegTech then
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, CommonHelper:GetTempStr_Default(TemplateStringID.Lab_NewSpeedUp, costNum))
            if ret == MessageBoxHelp.BtnType.OK then
                LabSubsystem:Get():SendMsg_FinishAlive(CdId, 1)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    elseif labExpType == LabToggleType.SegProduct then
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, CommonHelper:GetTempStr_Default(TemplateStringID.Lab_NewSpeedUp, costNum))
            if ret == MessageBoxHelp.BtnType.OK then
                LabSubsystem:Get():SendMsg_FinishTrack(CdId, 1)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end
end

function TrackMainView:OnOpenScienceLevBtn(LevStr, CdId, costNum)
    local openScienceStr = CommonHelper:GetTempStr_Default(TemplateStringID.TrackOpenScienceLev, costNum, CommonHelper:GetTempStr_Default(LevStr))
    costNum = costNum > 0 and costNum or 1

    local boxFunc = function()
        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, openScienceStr)
        if ret == MessageBoxHelp.BtnType.OK then
            LabSubsystem:Get():SendMsg_OpenScience(CdId)
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
end