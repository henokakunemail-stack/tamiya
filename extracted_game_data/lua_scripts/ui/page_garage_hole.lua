

--车库右侧，涂装入口

---@class PageGarageHole
PageGarageHole = class("PageGarageHole")

function PageGarageHole:initialize()
    self.SelectIdx = -1
    ---@type CarData
    self.CarData = nil

end

---@param cardata CarData
function PageGarageHole:SetData(root, cardata, funback)
    self.SelectIdx = -1
    self.CarData = cardata


    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)

    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if self.SelectIdx > -1 then
            local state = self.CarData:GetLightweight(true)[self.SelectIdx+1]
            if not state then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageNotHole))
            else
                local carshellid = self.CarData.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetBagId()
                AppearanceSubsystem:Get():SendMsg_Lightweight(carshellid, self.SelectIdx)
            end
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageNotSelectHole))
        end
    end)
    CommonHelper:HButtonSetCallback("BtnRestore",root,function (hbtn)
        local carshellid = self.CarData.assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetBagId()
        if self.SelectIdx > -1 then
            local state = self.CarData:GetLightweight(true)[self.SelectIdx+1]
            if state then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageNotHoleReset))
            else
                local id=CommonHelper:GetDictCalcData(CommonCfgKey.CarResetHoleCost,false)
                local value= 1
                if PlayerDataManager:Get():CheckCurrencyEnough(id,value) then
                    local boxFunc = function()
                        ---@type article_config_cell
                        local cell= CommonHelper:GetTableDataByID(ConfigNames.article_config,id)
                        local tips=CommonHelper:GetTempStr_Default(TemplateStringID.GarageHoleResetHit,CommonHelper:GetTempStr_Default(cell.name))
                        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.GarageHoleResetTittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
                        if ret == MessageBoxHelp.BtnType.OK then
                            AppearanceSubsystem:Get():SendMsg_ResetSticker(carshellid,AppearanceType.Hole , self.SelectIdx)
                        end
                    end
                    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
                end
            end
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageNotSelectHole))
        end

    end)



    ---@type table<number,number>
    local HoleCfg = cardata:GetShellPartCfg().NewShellHole
    self.ScrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #HoleCfg, 1,function(dataIndex, itemObj, scroll)
        local data = HoleCfg[dataIndex + 1]
        if data == nil then return end

        local state = cardata:GetLightweight(true)[dataIndex+1]

        CommonHelper:SetGameObjectActive("state2", itemObj, not state)
        CommonHelper:SetGameObjectActive("state1", itemObj, state)
        CommonHelper:SetGameObjectActive("select", itemObj, self.SelectIdx == dataIndex)
        CommonHelper:SetText("###name", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.PartHoldNameFormat, dataIndex + 1))

        CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
            if  self.SelectIdx == dataIndex then return end
            self.SelectIdx = dataIndex
            CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
            UINotify:Get():SendNotification(UINotifyEvent.GarageView_ShellHoleReview,  dataIndex + 1)
        end)
    end)


end

function PageGarageHole:UpdateMsg()
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)

end
