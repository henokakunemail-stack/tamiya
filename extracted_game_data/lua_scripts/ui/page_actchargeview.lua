---@class Page_ActChargeView
Page_ActChargeView = class("Page_ActChargeView", Page_ActivityBase)
function Page_ActChargeView:initialize()

end

function Page_ActChargeView:InitViewInfo(parent, activityType, msg, isreset)
    Page_ActivityBase:InitViewInfo(parent, activityType, msg, isreset)
    self.Root = parent
    self:SetData(msg, isreset)
end

function Page_ActChargeView:SetData(msg, isreset)
    self.scrollView = UIUtil.GetTypeChildWightInputPath("ActScrollView", self.Root, typeof(MoreRowScrollView))

    self.Data = {}
    for i = 1, #msg.curActInfo do
        ---@type act_period_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, msg.curActInfo[i].itemid)
        local chargecfg = CommonHelper:GetChargeCfgByAreaAndItemId(msg.curActInfo[i].itemid)
        table.insert(self.Data, { Cfg = cfg, chargecfg = chargecfg, buyState = msg.curActInfo[i].buysum < cfg.buymax, limit = (cfg.buymax - msg.curActInfo[i].buysum),index=i })
        if cfg.buymax == 0 then
            self.Data[i].buyState = true
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
    self:SetView(isreset)
end

function Page_ActChargeView:SetGiftItem(obj,id,count)
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


function Page_ActChargeView:SetView(isreset)

    CommonHelper:InitMoreRowScrollView(self.scrollView, #self.Data, 5, function(index, itemObj, scroll)
        local _data = self.Data[index + 1]
        local _cfg = _data.Cfg
        CommonHelper:GetComponentSetUITexture("ItemBg", itemObj, _cfg.giftIcon .. ".png", UIModuleID.Activity)

        local ids = stringSplitToNumber(_cfg.awardids, ':')
        local nums = stringSplitToNumber(_cfg.awardnums, ':')
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

        local btn = CommonHelper:HButtonSetCallback("BtnActPurchase", itemObj, function(btndata)
            if _data.chargecfg.itemid == 3000 then
                RedPointManager:Get():UpdateValue(RedPointID.S_ActCharge, false)
            end
            CommonHelper:ChargeMoneyByID(_data.chargecfg.itemid)
        end, index + 1)
        self:SetBtnIsRmbOrToken(btn,_data.chargecfg)
        ---@type paylist_config_cell
        local payCfg = _data.chargecfg
        local _priceStr = ""
        if payCfg.chargenum == 0 then
            _priceStr = CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalEveryDayBtnText)
        else
            _priceStr = payCfg.pricename
        end
        CommonHelper:SetText("###priceText", btn.gameObject, _priceStr)
        CommonHelper:SetText("###tittle1", itemObj, CommonHelper:GetTempStr_Default(_cfg.name))
        CommonHelper:SetText("###name", itemObj, CommonHelper:GetTempStr_Default(_cfg.title))
        CommonHelper:SetText("###level", itemObj,CommonHelper:GetTempStr_Default(_cfg.reference))
        CommonHelper:SetBetterOutlineColor("###name", itemObj, _cfg.colorborder)
        CommonHelper:HButtonSetCallback("BtnItem", itemObj, function(btnData)
            local data = self.Data[btnData.intData + 1]
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
        end, index)
        local str = ""
        if _data.limit <= 0 and _data.buyState then
            str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyInfinite)
            CommonHelper:SetText("###numText", itemObj, str)
        elseif _data.limit <= 0 and not _data.buyState then
            str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyDone)
            CommonHelper:SetText("###numText", itemObj, str)
        elseif _data.limit >= 999 then
            str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyInfinite)
            CommonHelper:SetText("###numText", itemObj, str)
        else
            str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyMore, _data.limit)
            CommonHelper:SetText("###numText", itemObj, str)
        end
        CommonHelper:SetHButtonClick(btn, _data.buyState, true)
    end, false, nil, isreset)

end

function Page_ActChargeView:OnClose()

end



