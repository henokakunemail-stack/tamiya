---@class FriendRentAndLendView : ViewBase
FriendRentAndLendView = class("LabSelectPopView", ViewBase)

function FriendRentAndLendView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "FriendRentAndLendViewAction")

end

--1_申请  2_出  3_进
local BtnType = 1

function FriendRentAndLendView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)

    self.RentAndLendSVC = self:GetChildWightByParent("RentAndLendSVC", self.gameObject, typeof(MoreRowScrollView))

end

function FriendRentAndLendView:OnOpen()
    BtnType = 1
    self:SetBtnState(BtnType)
end

function FriendRentAndLendView:InitRentOrLendInfoByType(_type, _btnType)
    if _type == FriendRentAndLendType.Rent then
        RentAndLendDataManager:Get():SetRentOrLendType(FriendRentAndLendType.Rent)

        CommonHelper:HButtonSetCallback("BtnLeft", self.gameObject, function(data)
            BtnType = 1
            self:SetBtnState(BtnType)
            --print("--552, --查看配件雇佣申请 P2类型 0-我的申请 1-申请我的", 1)
            RentAndLendSubsystem:Get():SendMsg_HireApp(1)
        end)

        CommonHelper:HButtonSetCallback("BtnRight", self.gameObject, function(data)
            BtnType = 2
            self:SetBtnState(BtnType)
            UINotify:Get():SendNotification(UINotifyEvent.InitRentOrLendInfoByType, { FriendRentAndLendType.Rent, 1 })
        end)

        CommonHelper:HButtonSetCallback("BtnRightme", self.gameObject, function(data)
            BtnType = 3
            self:SetBtnState(BtnType)
            --print("--552, --查看配件雇佣申请 P2类型 0-我的申请 1-申请我的", 0)
            RentAndLendSubsystem:Get():SendMsg_HireApp(0)
        end)

    end

    if _type == FriendRentAndLendType.Lend then
        RentAndLendDataManager:Get():SetRentOrLendType(FriendRentAndLendType.Lend)

        CommonHelper:HButtonSetCallback("BtnLeft", self.gameObject, function(data)
            BtnType = 1
            self:SetBtnState(BtnType)
            --print("--538, --查看配件租借申请 P2类型 0-我的申请 1-申请我的", 1)
            RentAndLendSubsystem:Get():SendMsg_BorrowApp(1)
        end)

        CommonHelper:HButtonSetCallback("BtnRight", self.gameObject, function(data)
            BtnType = 2
            self:SetBtnState(BtnType)

            UINotify:Get():SendNotification(UINotifyEvent.InitRentOrLendInfoByType, { FriendRentAndLendType.Lend, 1 })
        end)

        CommonHelper:HButtonSetCallback("BtnRightme", self.gameObject, function(data)
            BtnType = 3
            self:SetBtnState(BtnType)
            --print("--538, --查看配件租借申请 P2类型 0-我的申请 1-申请我的", 0)
            RentAndLendSubsystem:Get():SendMsg_BorrowApp(0)
        end)

    end

    self:SetRentOrLendSVC(_type, _btnType)
    self:SetRentOrLendTxt(_type)
end

function FriendRentAndLendView:SetRentOrLendSVC(_type, _btnType)
    local _TypeData = {}

    if _type == FriendRentAndLendType.Rent then
        local HireAppData = RentAndLendDataManager:Get():GetMyHireAppDataByType(_btnType)
        local HireAppOutData = RentAndLendDataManager:Get():GetHireAppOutDataByType(_btnType)
        _TypeData = BtnType == 2 and HireAppOutData or HireAppData
    end

    if _type == FriendRentAndLendType.Lend then
        local BorrowAppData = RentAndLendDataManager:Get():GetMyBorrowAppDataByType(_btnType)
        local BorrowAppOutData = RentAndLendDataManager:Get():GetBorrowAppOutDataByType(_btnType)
        _TypeData = BtnType == 2 and BorrowAppOutData or BorrowAppData
    end

    self:RefreshRentOrLendSVC(_btnType, _TypeData)

end

function FriendRentAndLendView:RefreshRentOrLendSVC(_btnType, _TypeData)
    CommonHelper:SetText("###ErrText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendNoApply))
    CommonHelper:SetGameObjectActive("###ErrText", self.gameObject, #_TypeData <= 0)

    if _btnType == 0 then
        CommonHelper:InitMoreRowScrollView(self.RentAndLendSVC, #_TypeData, 1, function(index, itemObj, scroll)
            local _data = _TypeData[index + 1]
            local _FType = RentAndLendDataManager:Get():GetRentOrLendType()

            if _FType == FriendRentAndLendType.Rent then
                local item = UIUtil.GetChild("ItemCom_138", itemObj)
                local param = Param_ItemArticleParam()
                CommonHelper:SetItemComGroup(item, UIModuleID.FriendRentAndLend, _data:GetPartiID(), param)

                ---@type dictparts_config_cell
                local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, _data:GetPartiID())
                local partName = CommonHelper:GetTempStr_Default(partCfg.partname)
                CommonHelper:SetText("###partTxt", itemObj, partName)

                local timeData = CommonHelper:ConvertIntToDataTime(_data:GetExpTime() * 1000)
                local timeTxt = string.format("%s.%s.%s %s:%s", timeData.Year, timeData.Month, timeData.Day, timeData.Hour, timeData.Minute)
                CommonHelper:SetText("###timeTxt", itemObj, timeTxt)
            end

            if _FType == FriendRentAndLendType.Lend then
                local item = UIUtil.GetChild("ItemCom_138", itemObj)
                local partData = _data.BorrowPart
                local param = Param_ItemArticleParam()
                CommonHelper:SetItemComGroup(item, UIModuleID.FriendRentAndLend, partData.CfgId, param)

                ---@type dictparts_config_cell
                local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partData.CfgId)
                local partName = CommonHelper:GetTempStr_Default(partCfg.partname)
                CommonHelper:SetText("###partTxt", itemObj, partName)

                local timeData = CommonHelper:ConvertIntToDataTime(partData.ExpTime * 1000)
                local timeTxt = string.format("%s.%s.%s %s:%s", timeData.Year, timeData.Month, timeData.Day, timeData.Hour, timeData.Minute)
                CommonHelper:SetText("###timeTxt", itemObj, timeTxt)

            end

            local PNameTxt = ""

            if BtnType == 1 then
                PNameTxt = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendApplyPart), _data.FRoleName)
            end

            if BtnType == 2 then
                PNameTxt = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendPlayerBorrowed), _data.FRoleName)

                local timeTxt = CommonHelper:GetSelfTransferTimeStr((partData:GetExpTime() - CommonHelper:GetNowTime()) * 1000)
                CommonHelper:SetText("###timeTxt", itemObj,
                        string.format(CommonHelper:GetTempStr_Default(TemplateStringID.HMS), timeTxt.hour, timeTxt.minute, timeTxt.second))
            end

            if BtnType == 3 then
                if _FType == FriendRentAndLendType.Lend then
                    PNameTxt = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.LendBeFromPlayer), _data.FRoleName)
                end

                if _FType == FriendRentAndLendType.Rent then
                    PNameTxt = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RentBeFromPlayer), _data.FRoleName)
                end
            end

            CommonHelper:SetText("###PNameTxt", itemObj, PNameTxt)
            CommonHelper:SetText("###getText", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendNotAgree))

            CommonHelper:SetGameObjectActive("BtnAgree", itemObj, BtnType == 1 and _data:GetAccessFlag() == 0)
            CommonHelper:SetGameObjectActive("BtnReject", itemObj, BtnType == 1 and _data:GetAccessFlag() == 0)
            CommonHelper:SetGameObjectActive("RightAgree", itemObj, BtnType == 1 and _data:GetAccessFlag() > 0)
            CommonHelper:SetGameObjectActive("BtnGet", itemObj, BtnType == 3 and _data:GetAccessFlag() == 1)
            CommonHelper:SetGameObjectActive("###getText", itemObj, BtnType == 3 and _data:GetAccessFlag() < 1)
            CommonHelper:SetGameObjectActive("###timeTxt", itemObj, BtnType ~= 1 and _data:GetAccessFlag() > 1)
            CommonHelper:SetGameObjectActive("timeText", itemObj, BtnType ~= 1 and _data:GetAccessFlag() > 1)

            CommonHelper:HButtonSetCallback("BtnReject", itemObj, function(data)
                if _FType == FriendRentAndLendType.Rent then
                    --print(_FType, "--556, --拒绝配件雇佣申请 P2=申请人rid P3=配件索引", _data:GetOriginRid(), _data:GetPartIndex())
                    RentAndLendSubsystem:Get():SendMsg_DenyHire(_data:GetOriginRid(), _data:GetPartIndex())
                end
                if _FType == FriendRentAndLendType.Lend then
                    --print(_FType, "--542, --拒绝配件租借申请 P2=申请人rid P3=配件索引", _data:GetOriginRid(), _data.CellId)
                    RentAndLendSubsystem:Get():SendMsg_DenyBorrow(_data:GetOriginRid(), _data.CellId)
                end
            end)

            CommonHelper:HButtonSetCallback("BtnAgree", itemObj, function(data)
                if _FType == FriendRentAndLendType.Rent then
                    --print(_FType, "--548, --同意雇佣配件 P2=好友rid P3=配件索引", _data:GetOriginRid(), _data:GetPartIndex())
                    RentAndLendSubsystem:Get():SendMsg_AcceptHire(_data:GetOriginRid(), _data:GetPartIndex())
                end
                if _FType == FriendRentAndLendType.Lend then
                    --print(_FType, "--534, --同意租借配件 P2=好友rid P3=配件索引", _data:GetOriginRid(), _data:GetPartIndex())
                    RentAndLendSubsystem:Get():SendMsg_AcceptBorrow(_data:GetOriginRid(), _data:GetPartIndex())
                end
            end)

            CommonHelper:HButtonSetCallback("BtnGet", itemObj, function(data)
                if _FType == FriendRentAndLendType.Rent then
                    --print(_FType, "--550, --获得雇佣来的配件 P2=好友rid P3=配件索引---", _data:GetRid(), _data:GetPartIndex())
                    RentAndLendSubsystem:Get():SendMsg_DownHire(_data:GetRid(), _data:GetPartIndex())
                end
                if _FType == FriendRentAndLendType.Lend then
                    --print(_FType, "--536, --获得租借来的配件 P2=好友rid P3=配件索引---", _data:GetRid(), _data:GetPartIndex())
                    RentAndLendSubsystem:Get():SendMsg_DownBorrow(_data:GetRid(), _data:GetPartIndex())
                end
            end)

        end)

    end

    if _btnType == 1 then
        CommonHelper:InitMoreRowScrollView(self.RentAndLendSVC, #_TypeData, 1, function(index, itemObj, scroll)
            local _data = _TypeData[index + 1]
            local _FType = RentAndLendDataManager:Get():GetRentOrLendType()

            if _FType == FriendRentAndLendType.Rent then
                local item = UIUtil.GetChild("ItemCom_138", itemObj)
                local param = Param_ItemArticleParam()
                CommonHelper:SetItemComGroup(item, UIModuleID.FriendRentAndLend, _data:GetPartiID(), param)

                ---@type dictparts_config_cell
                local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, _data:GetPartiID())
                local partName = CommonHelper:GetTempStr_Default(partCfg.partname)
                CommonHelper:SetText("###partTxt", itemObj, partName)

                local timeData = CommonHelper:ConvertIntToDataTime(_data:GetExpTime() * 1000)
                local timeTxt = string.format("%s.%s.%s %s:%s", timeData.Year, timeData.Month, timeData.Day, timeData.Hour, timeData.Minute)
                CommonHelper:SetText("###timeTxt", itemObj, timeTxt)

            end

            if _FType == FriendRentAndLendType.Lend then
                local item = UIUtil.GetChild("ItemCom_138", itemObj)
                local partData = _data.BorrowPart
                local param = Param_ItemArticleParam()
                CommonHelper:SetItemComGroup(item, UIModuleID.FriendRentAndLend, partData.CfgId, param)

                ---@type dictparts_config_cell
                local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partData.CfgId)
                local partName = CommonHelper:GetTempStr_Default(partCfg.partname)
                CommonHelper:SetText("###partTxt", itemObj, partName)

                local timeData = CommonHelper:ConvertIntToDataTime(partData.ExpTime * 1000)
                local timeTxt = string.format("%s.%s.%s %s:%s", timeData.Year, timeData.Month, timeData.Day, timeData.Hour, timeData.Minute)
                CommonHelper:SetText("###timeTxt", itemObj, timeTxt)
            end

            local PNameTxt = ""

            if BtnType == 1 then
                PNameTxt = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendApplyPart), _data:GetOppositeName())
            end

            if BtnType == 2 then
                if _FType == FriendRentAndLendType.Rent then
                    PNameTxt = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendPlayerRend), _data:GetOppositeName())
                end

                if _FType == FriendRentAndLendType.Lend then
                    PNameTxt = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendPlayerBorrowed), _data:GetOppositeName())
                end
            end

            if BtnType == 3 then
                if _FType == FriendRentAndLendType.Lend then
                    PNameTxt = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.LendBeFromPlayer), _data:GetOppositeName())
                end

                if _FType == FriendRentAndLendType.Rent then
                    PNameTxt = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RentBeFromPlayer), _data:GetOppositeName())
                end
            end

            CommonHelper:SetText("###PNameTxt", itemObj, PNameTxt)
            CommonHelper:SetText("###getText", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendNotAgree))

            CommonHelper:SetGameObjectActive("BtnAgree", itemObj, BtnType == 1 and _data:GetAccessFlag() == 0)
            CommonHelper:SetGameObjectActive("BtnReject", itemObj, BtnType == 1 and _data:GetAccessFlag() == 0)
            CommonHelper:SetGameObjectActive("RightAgree", itemObj, BtnType == 1 and _data:GetAccessFlag() > 0)
            CommonHelper:SetGameObjectActive("BtnGet", itemObj, BtnType == 3 and _data:GetAccessFlag() == 1)
            CommonHelper:SetGameObjectActive("###getText", itemObj, BtnType == 3 and _data:GetAccessFlag() < 1)
            CommonHelper:SetGameObjectActive("###timeTxt", itemObj, BtnType ~= 1 and _data:GetAccessFlag() > 1)
            CommonHelper:SetGameObjectActive("timeText", itemObj, BtnType ~= 1 and _data:GetAccessFlag() > 1)

            CommonHelper:HButtonSetCallback("BtnReject", itemObj, function(data)
                if _FType == FriendRentAndLendType.Rent then
                    --print(_FType, "--556, --拒绝配件雇佣申请 P2=申请人rid P3=配件索引", _data:GetOriginRid(), _data:GetPartIndex())
                    RentAndLendSubsystem:Get():SendMsg_DenyHire(_data:GetOriginRid(), _data:GetPartIndex())
                end
                if _FType == FriendRentAndLendType.Lend then
                    --print(_FType, "--542, --拒绝配件租借申请 P2=申请人rid P3=配件索引", _data:GetOriginRid(), _data:GetPartIndex())
                    RentAndLendSubsystem:Get():SendMsg_DenyBorrow(_data:GetOriginRid(), _data:GetPartIndex())
                end
            end)

            CommonHelper:HButtonSetCallback("BtnAgree", itemObj, function(data)
                if _FType == FriendRentAndLendType.Rent then
                    --print(_FType, "--548, --同意雇佣配件 P2=好友rid P3=配件索引", _data:GetOriginRid(), _data:GetPartIndex())
                    RentAndLendSubsystem:Get():SendMsg_AcceptHire(_data:GetOriginRid(), _data:GetPartIndex())
                end
                if _FType == FriendRentAndLendType.Lend then
                    --print(_FType, "--534, --同意租借配件 P2=好友rid P3=配件索引", _data:GetOriginRid(), _data:GetPartIndex())
                    RentAndLendSubsystem:Get():SendMsg_AcceptBorrow(_data:GetOriginRid(), _data:GetPartIndex())
                end
            end)

            CommonHelper:HButtonSetCallback("BtnGet", itemObj, function(data)
                if _FType == FriendRentAndLendType.Rent then
                    --print(_FType, "--550, --获得雇佣来的配件 P2=好友rid P3=配件索引---", _data:GetRid(), _data:GetPartIndex())
                    RentAndLendSubsystem:Get():SendMsg_DownHire(_data:GetRid(), _data:GetPartIndex())
                end
                if _FType == FriendRentAndLendType.Lend then
                    --print(_FType, "--536, --获得租借来的配件 P2=好友rid P3=配件索引---", _data:GetRid(), _data:GetPartIndex())
                    RentAndLendSubsystem:Get():SendMsg_DownBorrow(_data:GetRid(), _data:GetPartIndex())
                end
            end)

        end)

    end

end

function FriendRentAndLendView:SetRentOrLendTxt(_type)
    if _type == FriendRentAndLendType.Rent then
        CommonHelper:SetText("###TitleText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendRentManagement))

        CommonHelper:SetText("BtnLeft/BG/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendRentApply))
        CommonHelper:SetText("BtnLeft/BGLight/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendRentApply))

        CommonHelper:SetText("BtnRight/BG/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendRentOut))
        CommonHelper:SetText("BtnRight/BGLight/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendRentOut))

        CommonHelper:SetText("BtnRightme/BG/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendMyRent))
        CommonHelper:SetText("BtnRightme/BGLight/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendMyRent))

    end

    if _type == FriendRentAndLendType.Lend then
        CommonHelper:SetText("###TitleText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendLendManagement))

        CommonHelper:SetText("BtnLeft/BG/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendLendApply))
        CommonHelper:SetText("BtnLeft/BGLight/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendLendApply))

        CommonHelper:SetText("BtnRight/BG/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendLendOut))
        CommonHelper:SetText("BtnRight/BGLight/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendLendOut))

        CommonHelper:SetText("BtnRightme/BG/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendMyLend))
        CommonHelper:SetText("BtnRightme/BGLight/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendMyLend))

    end

end

function FriendRentAndLendView:SetBtnState(_btnType)
    CommonHelper:SetGameObjectActive("BtnLeft/BGLight", self.gameObject, _btnType == 1)
    CommonHelper:SetGameObjectActive("BtnRight/BGLight", self.gameObject, _btnType == 2)
    CommonHelper:SetGameObjectActive("BtnRightme/BGLight", self.gameObject, _btnType == 3)

    CommonHelper:SetGameObjectActive("BtnLeft/BG", self.gameObject, _btnType ~= 1)
    CommonHelper:SetGameObjectActive("BtnRight/BG", self.gameObject, _btnType ~= 2)
    CommonHelper:SetGameObjectActive("BtnRightme/BG", self.gameObject, _btnType ~= 3)
end

function FriendRentAndLendView:OnClose()

end