---@class SeasonOrderView : ViewBase
SeasonOrderView = class("SeasonOrderView", ViewBase)
function SeasonOrderView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SeasonOrderViewAction")
end

function SeasonOrderView:Awake()
    self.activityList = self:GetChildWightByParent("InfoBaseScroll", self.gameObject, typeof(MoreRowScrollView))
    self.WillView = self:GetChildWightByParent("WillView", self.gameObject, typeof(MoreRowScrollView))
    self.NowView = self:GetChildWightByParent("NowView", self.gameObject, typeof(MoreRowScrollView))
    self.viewbuyed = self:GetChildByParent("viewbuyed", self.gameObject)
    self.viewNormal = self:GetChildByParent("viewNormal", self.gameObject)
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UINotify:Get():SendNotification(UINotifyEvent.FoundPassToggleView_CloseView)
        UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"SeasonOrderView",false})
    end)
    CommonHelper:HButtonSetCallback("BtnClose2", self.gameObject, function(data)
        UINotify:Get():SendNotification(UINotifyEvent.FoundPassToggleView_CloseView)
        UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"SeasonOrderView",false})
    end)
    CommonHelper:HButtonSetCallback("BtnGetLv", self.gameObject, function(data)
        if self.LevelMax then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderLevelMax))
            return
        end
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.SeasonOrderLevelBuySubDay)
        local value = tonumber(cfg.varval)
        if self.day and value and self.day > value then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderDayNoBuy))
            return
        end
        UIManager:Get():OpenPopup("SeasonOrderLevelView", CanvasType.FrontCanvas, "SeasonOrderLevelView")
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderLevelView_SetData, { self.Data, 1 })
    end)
    CommonHelper:HButtonSetCallback("BtnGetExp", self.gameObject, function(data)
        TaskSubsystem:Get():SendMsg_GetTaskList(TaskType.SeasonOrder)
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_SetLuaViewInfo,{"SeasonOrderTaskView",true})
    end)
    self.BtnBuy = CommonHelper:HButtonSetCallback("BtnBuy", self.gameObject, function(data)
        if self.Data.ifbuy == 1 then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderBuyed))
            return
        end
        CommonHelper:ChargeMoneyByID(self.Token_Cell.chargeid)
    end)
    CommonHelper:HButtonSetCallback("BtnGetGift", self.gameObject, function(data)
        if self.CanGet then
            SeasonOrderSubsystem:Get():SendMsg_GetSeasonGift(0)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderNoGeted))
        end

    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(data)
        CommonHelper:ShowHelpView(PageDetailType.SeasonOrder)
    end)
end

function SeasonOrderView:OnOpen()
    if self:GetLuaViewInfo("SeasonOrderTaskView") then
        TaskSubsystem:Get():SendMsg_GetTaskList(TaskType.SeasonOrder)
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_SetLuaViewInfo,{"SeasonOrderTaskView",true})
    end

end
function SeasonOrderView:BuyFinish()
    self.Data.ifbuy = 1
    self:SetData(self.Data)
end

function SeasonOrderView:OnClose()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId = nil
    end
end
---@param msg SC_ActToken
function SeasonOrderView:SetData(msg,default)
    self.Data = msg
    self.LevelMax = false

    ---@type act_token_lev_config
    local config = ClientDataManager:Get():GetDataTable(ConfigNames.act_token_lev_config)
    local act_token_config = ClientDataManager:Get():GetDataTable(ConfigNames.act_token_config)
    ---@type act_token_config_cell
    self.Token_Cell = act_token_config.GetDataBuyServerIdAndId(PlayerDataManager:Get():GetPlayerServerID(), msg.tokenid)
    ---@type dictcharge_config_cell
    self.chargeCfg =CommonHelper:GetChargeCfgByAreaAndItemId( self.Token_Cell.chargeid)
    ---@type act_token_lev_config[]
    local data = config.GetTokenData(PlayerDataManager:Get():GetPlayerServerID(),msg.tokenid)
    if self.Data.lev >= data[#data].lev then
        self.LevelMax = true
    end
    SeasonOrderDataManager:Get():SetLevelMax(self.LevelMax)
    ---@type act_token_lev_config_cell
    local cell_lev = config.GetDataByAndLevel(PlayerDataManager:Get():GetPlayerServerID(),msg.tokenid, msg.lev)
    CommonHelper:SetText("###seasonexp", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderExp, msg.curexp, cell_lev.nextexp))
    CommonHelper:SetText("###seasonlv", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderLevel, msg.lev))
    CommonHelper:SetText("###seasomoreder", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderName, msg.tokenid))
    if msg.ifbuy == 0 then
        UIUtil.SetParentTransform(self.viewNormal, self.activityList, true, true)
        if self.chargeCfg and self.chargeCfg.exnum then
            CommonHelper:SetBtnIsRmbOrToken(self.BtnBuy,self.chargeCfg)
        end
    else
        UIUtil.SetParentTransform(self.viewbuyed, self.activityList, true, true)
        CommonHelper:SetText("BtnBuy/###priceText", self.BtnBuy.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderBuyed))
    end
    CommonHelper:SetGameObjectActive("buyBg", self.gameObject, msg.ifbuy == 0)
    CommonHelper:SetGameObjectActive("lockimage", self.gameObject, msg.ifbuy == 0)
    CommonHelper:SetSlider("Slider", self.gameObject, msg.curexp / cell_lev.nextexp)

    self:SetSeasonMoreDerTime(msg)

    local GetNow = {}
    local GetWill = {}
    self.CanGet=false
    for i = 1, #data do
        if data[i].lev <= msg.lev then
            if GetNow[tonumber(data[i].hawardids)] == nil then
                GetNow[tonumber(data[i].hawardids)] = tonumber(data[i].hawardnums)
            else
                GetNow[tonumber(data[i].hawardids)] = GetNow[tonumber(data[i].hawardids)] + tonumber(data[i].hawardnums)
            end
            if self.CanGet==false and self.Data.ifgift[i] and tonumber(self.Data.ifgift[i])==0 then
                self.CanGet=true
            end
            if self.CanGet==false and self.Data.ifgift[i] and self.Data.ifbuy == 1 and tonumber(self.Data.ifgift[i])==1 then
                self.CanGet=true
            end
        else
            if GetWill[tonumber(data[i].hawardids)] == nil then
                GetWill[tonumber(data[i].hawardids)] = tonumber(data[i].hawardnums)
            else
                GetWill[tonumber(data[i].hawardids)] = GetWill[tonumber(data[i].hawardids)] + tonumber(data[i].hawardnums)
            end
        end
    end
    local GetNowList = {}
    local GetWillList = {}
    for k, v in pairs(GetNow) do
        local data = RewardData()
        data:SetDataIdNum(k, v)
        table.insert(GetNowList, data)
    end
    for k, v in pairs(GetWill) do
        local data = RewardData()
        data:SetDataIdNum(k, v)
        data:SetTypeAndQuality()
        table.insert(GetWillList, data)
    end
    table.sort(GetWillList,function(a, b)
        return a.type<b.type
    end)
    table.sort(GetWillList,function(a, b)
        return a.quality>b.quality
    end)
    CommonHelper:InitMoreRowScrollView(self.activityList, #data, 1, function(index, itemObj, scroll)
            ---@type act_token_lev_config_cell
            local temp = data[index + 1]
            CommonHelper:SetText("###lv", itemObj, "LV." .. temp.lev)
            CommonHelper:SetGameObjectActive("toplock", itemObj, temp.lev > self.Data.lev)
            CommonHelper:SetGameObjectActive("bottomlock", itemObj, temp.lev > self.Data.lev)
            if self.Data.ifbuy == 1 then
                CommonHelper:SetGameObjectActive("bottomlock", itemObj, temp.lev > self.Data.lev)
            else
                CommonHelper:SetGameObjectActive("bottomlock", itemObj, true)
            end
            if self.Data.ifgift[index + 1] == nil or tonumber(self.Data.ifgift[index + 1]) == 0 then
                CommonHelper:SetGameObjectActive("toplockgeted", itemObj, false)
                CommonHelper:SetGameObjectActive("bottomlockgeted", itemObj, false)
            else
                CommonHelper:SetGameObjectActive("toplockgeted", itemObj, true)
                CommonHelper:SetGameObjectActive("bottomlockgeted", itemObj, tonumber(self.Data.ifgift[index + 1]) == 2)
            end

            local reward1 = self:GetChildByParent("reward1", itemObj)
            local reward2 = self:GetChildByParent("reward2", itemObj)
            local param1 = Param_ItemArticleParam()
            param1.count = tonumber(temp.awardnums)
            local param2 = Param_ItemArticleParam()
            param2.count = tonumber(temp.hawardnums)
            CommonHelper:SetItemComGroup(reward1, UIModuleID.SeasonOrder, tonumber(temp.awardids), param1, function(data)
                CommonHelper:ShowPartInfoByCfgId(tonumber(temp.awardids), UIModuleID.SeasonOrder)
            end)
            CommonHelper:SetItemComGroup(reward2, UIModuleID.SeasonOrder, tonumber(temp.hawardids), param2, function(data)
                CommonHelper:ShowPartInfoByCfgId(tonumber(temp.hawardids), UIModuleID.SeasonOrder)
            end)
        end,false,nil,not default)
        if default then
            local index=msg.lev-1
            if index<0  then
                index=0
            end
            if index>=#data then
                index=#data-1
            end
            CommonHelper:MoreRowView_ScrollToItem(self.activityList, msg.lev-1)
        end
    CommonHelper:InitMoreRowScrollView(self.NowView, #GetNowList, 1, function(index, itemObj, scroll)
        ---@type RewardData
        local temp = GetNowList[index + 1]
        local param = Param_ItemArticleParam()
        param.count = temp.num
        CommonHelper:SetItemComGroup(itemObj, UIModuleID.SeasonOrder, tonumber(temp.id), param, function(data)
            CommonHelper:ShowPartInfoByCfgId(tonumber(temp.id), UIModuleID.SeasonOrder)
        end)
    end)
    CommonHelper:InitMoreRowScrollView(self.WillView, #GetWillList, 1, function(index, itemObj, scroll)
        ---@type RewardData
        local temp = GetWillList[index + 1]
        local param = Param_ItemArticleParam()
        param.count = temp.num
        CommonHelper:SetItemComGroup(itemObj, UIModuleID.SeasonOrder, tonumber(temp.id), param, function(data)
            CommonHelper:ShowPartInfoByCfgId(tonumber(temp.id), UIModuleID.SeasonOrder)
        end)
    end)
end

function SeasonOrderView:OnBackKey()
    UIManager:Get():HidePersistentView("SeasonOrderView")
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"SeasonOrderView",false})
end

function SeasonOrderView:SetSeasonMoreDerTime(msg)
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
    self.subTime = msg.endtime - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    self.TimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
        if self.subTime <= 0 then
            TimerManager:Get():StopTimer(self.TimeId)
        end

        local day = math.modf(self.subTime / TimeSecond_Day)
        class.day = day
        SeasonOrderDataManager:Get():SetDay(day)
        local hour = math.modf((self.subTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
        local minute = math.modf((self.subTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
        local second = self.subTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)
        self.subTime = self.subTime - 1

        if day >= 1 then
            CommonHelper:SetText("###seasomoredertime", self.gameObject,
                    CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, day, hour, minute))
        else
            CommonHelper:SetText("###seasomoredertime", self.gameObject,
                    CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, hour, minute, second))
        end

    end, self)
end
