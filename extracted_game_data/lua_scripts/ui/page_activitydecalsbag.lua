---@class Page_ActivityDecalsBag:Page_ActivityBase
Page_ActivityDecalsBag = class("Page_ActivityDecalsBag", Page_ActivityBase)
function Page_ActivityDecalsBag:initialize()

end

function Page_ActivityDecalsBag:InitViewInfo(parent, activityType, msg, isreset)
    Page_ActivityBase:InitViewInfo(parent, activityType, msg)
    self.itemList = UIUtil.GetTypeChildWightByParent("ScrollView", self.parent, typeof(MoreRowScrollView))
    self:SetData(msg)
    self:SetView(isreset)
end

---@ param msg SC_ActivityInfo
function Page_ActivityDecalsBag:SetData(msg)
    self.Data = {}

    for i = 1, #msg.curActInfo do
        ---@type act_period_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, msg.curActInfo[i].itemid)
        local chargecfg = CommonHelper:GetChargeCfgByAreaAndItemId(msg.curActInfo[i].itemid)
        table.insert(self.Data, { Cfg = cfg, chargecfg = chargecfg, buyState = msg.curActInfo[i].buysum < cfg.buymax, limit = (cfg.buymax - msg.curActInfo[i].buysum),index=i })
        if cfg.buymax==0 then
            self.Data[i].buyState=true
        end
    end
    table.sort(self.Data,function(a, b)
        if  a.buyState and not b.buyState then
            return true
        end
        if  not a.buyState and  b.buyState then
            return false
        end
        return a.index<b.index
    end)
end
function Page_ActivityDecalsBag:SetGiftItem(obj,id,count)
    local propType,Cfg= CommonHelper:GetPropTypeById(id)
    local PartBaseCfg=nil
    if propType==PropType.Part then
        PartBaseCfg=  CommonHelper:GetPartBaseCfg(id)
    end
    CommonHelper:SetGameObjectActive("itemarticle",obj,propType==PropType.Article)
    local item1= CommonHelper:SetGameObjectActive("item6",obj,propType==PropType.Part and PartBaseCfg.parttype==PartType.Pulley)
    local item2=CommonHelper:SetGameObjectActive("item8",obj,propType==PropType.Part and PartBaseCfg.parttype==PartType.Motor)
    local item3= CommonHelper:SetGameObjectActive("item0",obj,propType==PropType.Part and PartBaseCfg.parttype~=PartType.Pulley and PartBaseCfg.parttype~=PartType.Motor)
    if propType==PropType.Article then
        local param = Param_ItemArticleParam()
        param.count = count
        local ArticleItem= UIUtil.GetChild("itemarticle",obj)
        CommonHelper:SetItemArticleGroup(ArticleItem, UIModuleID.Activity, id, param)
    elseif propType==PropType.Part and PartBaseCfg.parttype==PartType.Pulley then
        CommonHelper:GetComponentSetUITexture("icon",item1,Cfg.icon,UIModuleID.Activity)
    elseif propType==PropType.Part and PartBaseCfg.parttype==PartType.Motor then
        CommonHelper:GetComponentSetUITexture("icon",item2,Cfg.icon,UIModuleID.Activity)
    elseif propType==PropType.Part and PartBaseCfg.parttype~=PartType.Pulley and PartBaseCfg.parttype~=PartType.Motor then
        CommonHelper:GetComponentSetUITexture("icon",item3,Cfg.icon,UIModuleID.Activity)
    end

end

function Page_ActivityDecalsBag:SetView(isreset)
    local temp = self.Data
    CommonHelper:SetGameObjectActive("left", self.parent, #temp > 3)
    CommonHelper:SetGameObjectActive("right", self.parent, #temp > 3)
    CommonHelper:InitMoreRowScrollView(self.itemList, #temp, 1, function(dataIndex, itemObj, scroll)
        local data = temp[dataIndex + 1]
        ---@type act_gift_config_cell
        local cfg = data.Cfg
        ---@type paylist_config_cell
        local payCfg = data.chargecfg
        local scrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_V", itemObj, typeof(MoreRowScrollView))
        local reward = {}
        local ids = stringSplitToNumber(cfg.awardids, ':')
        local nums = stringSplitToNumber(cfg.awardnums, ':')
        for i = 1, #ids do
            local rewarddata = RewardData()
            rewarddata:SetDataIdNum(ids[i], nums[i])
            table.insert(reward, rewarddata)
        end
        local IsShell =0
        local CfgIds={}
        local shellIcon=""
        ---@type PropType
        ---@type dictparts_config_cell
        ---@type dictpartbase_config_cell
        local propType,Cfg,PartBaseCfg=nil
        for i = 1, #ids do
            local flag=false
            propType,Cfg= CommonHelper:GetPropTypeById(ids[i])
            if propType==PropType.Part then
                PartBaseCfg=  CommonHelper:GetPartBaseCfg(ids[i])
            elseif propType== PropType.Article and Cfg.propstype==GoodsType2.Article_Appearance and Cfg.subtype==GoodsType3.Article_Appearance_Sticker then
                IsShell=ids[i]
                shellIcon=Cfg.NewIcon
                flag=true
            end
            if IsShell==0 and PartBaseCfg and PartBaseCfg.parttype==PartType.Shell then
                IsShell=ids[i]
                shellIcon=Cfg.icon
                flag=true
            end
            if not flag then
                table.insert(CfgIds,{ids[i],nums[i]})
            end
        end
        local shellgroup= CommonHelper:SetGameObjectActive("item_shell",itemObj,IsShell~=0)
        local partgroup= CommonHelper:SetGameObjectActive("item_part5",itemObj,IsShell==0)
        if IsShell==0 then
            for i = 1, 5 do
                local temp= CommonHelper:SetGameObjectActive("giftpartitem"..i,partgroup,CfgIds[i]~=nil)
                if CfgIds[i] then
                    self:SetGiftItem(temp,CfgIds[i][1],CfgIds[i][2])
                end
            end
        else
            local propType,Cfg= CommonHelper:GetPropTypeById(IsShell)
            CommonHelper:GetComponentSetUITexture("shell_icon",shellgroup,shellIcon,UIModuleID.Activity)
            local temp1= CommonHelper:SetGameObjectActive("part_"..1,itemObj,#CfgIds<=1)
            local temp2= CommonHelper:SetGameObjectActive("part_"..2,itemObj,#CfgIds==2)
            local temp3= CommonHelper:SetGameObjectActive("part_"..3,itemObj,#CfgIds==3)
            local temp4= CommonHelper:SetGameObjectActive("part_"..4,itemObj,#CfgIds>=4)
            local temp=nil
            if #CfgIds<=1 then
                temp=temp1
            elseif #CfgIds==2 then
                temp=temp2
            elseif #CfgIds==3 then
                temp=temp3
            elseif #CfgIds>=4 then
                temp=temp4
            end
            for i = 1, 4 do
                local obj= CommonHelper:SetGameObjectActive("giftpartitem"..i,temp,CfgIds[i]~=nil)
                if CfgIds[i] then
                    self:SetGiftItem(obj,CfgIds[i][1],CfgIds[i][2])
                end
            end
        end
        CommonHelper:GetComponentSetUITexture("bg1", itemObj, cfg.giftIcon .. ".png", UIModuleID.Activity)
        CommonHelper:InitMoreRowScrollView(scrollView, #reward, 1, function(index, item, scrollview)
            CommonHelper:SetText("###count", item, CommonHelper:GetTempStr_Default(TemplateStringID.PreferentialBagCount, reward[index + 1].num))
            local propType, cfg = CommonHelper:GetPropTypeById(reward[index + 1].id)
            if propType == PropType.Part then
                CommonHelper:SetText("###name", item, CommonHelper:GetTempStr_Default(cfg.partname))
            else
                CommonHelper:SetText("###name", item, CommonHelper:GetTempStr_Default(cfg.name))
            end
        end)

        CommonHelper:SetText("###tittle1", itemObj, CommonHelper:GetTempStr_Default(cfg.name))
        CommonHelper:SetText("###name", itemObj, CommonHelper:GetTempStr_Default(cfg.title))
        CommonHelper:SetText("###level", itemObj,CommonHelper:GetTempStr_Default(cfg.reference))
        CommonHelper:SetBetterOutlineColor("###name", itemObj, cfg.colorborder)


        local str = ""
        if data.limit == 0 and data.state then
            str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyInfinite)
            CommonHelper:SetText("###limit", itemObj, str)
        elseif data.limit == 0 and not data.state then
            str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyDone)
            CommonHelper:SetText("###limit", itemObj, str)
        elseif data.limit >= 999 then
            str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyInfinite)
            CommonHelper:SetText("###limit", itemObj, str)
        else
            str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyMore, data.limit)
            CommonHelper:SetText("###limit", itemObj, str)
        end

        if payCfg then
            CommonHelper:SetText("###priceText", itemObj, payCfg.pricename)
        else
            CommonHelper:SetText("###priceText", itemObj, "--->")
        end
        local pay = CommonHelper:HButtonSetCallback("BtnPay", itemObj, function(btnData)
            local data = temp[btnData.intData + 1].chargecfg
            CommonHelper:ChargeMoneyByID(data.itemid)
        end, dataIndex)
        self:SetBtnIsRmbOrToken(pay,temp[dataIndex + 1].chargecfg)
        CommonHelper:HButtonSetCallback("BtnItem", itemObj, function(btnData)
            local data = temp[btnData.intData + 1]
            ---@type act_gift_config_cell
            local cfg = data.Cfg
            local reward = {}
            local ids = stringSplitToNumber(cfg.awardids, ':')
            local nums = stringSplitToNumber(cfg.awardnums, ':')
            for i = 1, #ids do
                local rewarddata = RewardData()
                rewarddata:SetDataIdNum(ids[i], nums[i])
                table.insert(reward, rewarddata)
            end
           UIManager:Get():OpenPopup("GiftShowRewardView",CanvasType.FrontCanvas,"GiftShowRewardView")
            UINotify:Get():SendNotification(UINotifyEvent.GiftShowRewardView_SetData, {reward,cfg.C_ID})
        end, dataIndex)
        CommonHelper:SetHButtonClick(pay, data.buyState, true)
    end, false, nil, isreset)
end

function Page_ActivityDecalsBag:SetRefreshTimeTextHour(time, parent)
    local hour = math.modf(time / 60 / 60)
    local minute = math.modf((time - (hour * 60 * 60)) / 60)
    local second = math.fmod(time, 60)
    CommonHelper:SetText("###timelimit", parent, CommonHelper:GetTempStr_Default(TemplateStringID.TimeLimitBuy, hour, minute, second))
end

function Page_ActivityDecalsBag:OnBaseClose()

end