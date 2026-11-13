---@class Page_ActivitySuperPack:Page_ActivityBase
Page_ActivitySuperPack = class("Page_ActivitySuperPack", Page_ActivityBase)

function Page_ActivitySuperPack:initialize()
end

---@param msg SC_ActivityInfo
function Page_ActivitySuperPack:InitViewInfo(parent, activityType, msg, isreset)
    Page_ActivityBase:InitViewInfo(parent, activityType, msg, isreset)

    self.itemList = UIUtil.GetTypeChildWightByParent("FlimScrollView", self.parent, typeof(FilmScrollView))

    self:InitItemList(msg)
end
---@param msg SC_ActivityInfo
function Page_ActivitySuperPack:InitItemList(msg)
    local data = {}

    for i = 1, #msg.curActInfo do
        ---@type act_gift_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, msg.curActInfo[i].itemid)
        local chargecfg = CommonHelper:GetChargeCfgByAreaAndItemId(msg.curActInfo[i].itemid)
        table.insert(data, { cfg = cfg, chargecfg = chargecfg, buyState = msg.curActInfo[i].buysum,index=i,buyFlag=msg.curActInfo[i].buysum < cfg.buymax })

    end
    table.sort(data,function(a, b)
        if  a.buyFlag and not b.buyFlag then
            return true
        end
        if  not a.buyFlag and  b.buyFlag then
            return false
        end
        return a.index<b.index
    end)
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type act_gift_config_cell
        local cell = data[dataIndex + 1].cfg
        local chargecfg = data[dataIndex + 1].chargecfg
        CommonHelper:SetText("###priceText", itemObj, CommonHelper:GetTempStr_Default(chargecfg.pricename))
        CommonHelper:GetComponentSetUITexture("Bg", itemObj, cell.giftIcon .. ".png", UIModuleID.Activity)

        local purchaseBtn = CommonHelper:HButtonSetCallback("BtnPurchase", itemObj, function()
            ---@type paylist_config_cell
            local payCell = data[dataIndex + 1].chargecfg
            CommonHelper:ChargeMoneyByID(payCell.itemid)
        end)
        self:SetBtnIsRmbOrToken(purchaseBtn,data[dataIndex + 1].chargecfg)
        if cell.buymax - data[dataIndex + 1].buyState > 0 then
            CommonHelper:SetText("###can", itemObj,
                    string.format(CommonHelper:GetTempStr_Default(TemplateStringID.PermanentPurchaseRestrictionNum), cell.buymax - data[dataIndex + 1].buyState))
        else
            CommonHelper:SetText("###can", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyDone))
        end

        local SVC_Two = UIUtil.GetTypeChildWightInputPath("SVC_Two", itemObj, typeof(MoreRowScrollView))
        local SVC_Three = UIUtil.GetTypeChildWightInputPath("SVC_Three", itemObj, typeof(MoreRowScrollView))

        local awardids = stringSplitToNumber(cell.awardids, ':')
        local awardnums = stringSplitToNumber(cell.awardnums, ':')

        if #awardids > 0 then
            if #awardids < 3 then
                CommonHelper:CSGameObjectSetActive(SVC_Two.gameObject, true)
                CommonHelper:CSGameObjectSetActive(SVC_Three.gameObject, false)
                CommonHelper:SetGameObjectActive("###can", itemObj, true)

                CommonHelper:InitMoreRowScrollView(SVC_Two, #awardids, 1, function(dataIndex, itemObj, scroll)
                    local obj = UIUtil.GetChild("ItemCom_118", itemObj)
                    local param = Param_ItemArticleParam()
                    param.count = awardnums[dataIndex + 1]
                    CommonHelper:SetItemComGroup(obj, UIModuleID.Activity, awardids[dataIndex + 1], param, function()
                        CommonHelper:ShowPartInfoByCfgId(awardids[dataIndex + 1], UIModuleID.Activity)
                    end)
                end)
            else
                CommonHelper:CSGameObjectSetActive(SVC_Two.gameObject, false)
                CommonHelper:CSGameObjectSetActive(SVC_Three.gameObject, true)
                CommonHelper:SetGameObjectActive("###can", itemObj, true)

                CommonHelper:InitMoreRowScrollView(SVC_Three, #awardids, 1, function(dataIndex, itemObj, scroll)
                    local obj = UIUtil.GetChild("ItemCom_118", itemObj)
                    local param = Param_ItemArticleParam()
                    param.count = awardnums[dataIndex + 1]
                    CommonHelper:SetItemComGroup(obj, UIModuleID.Activity, awardids[dataIndex + 1], param, function()
                        CommonHelper:ShowPartInfoByCfgId(awardids[dataIndex + 1], UIModuleID.Activity)
                    end)
                end)
            end
        else
            CommonHelper:CSGameObjectSetActive(SVC_Two.gameObject, false)
            CommonHelper:CSGameObjectSetActive(SVC_Three.gameObject, false)
            CommonHelper:SetGameObjectActive("###can", itemObj, false)
        end

        if data[dataIndex + 1].buyState >= cell.buymax then
            CommonHelper:SetHButtonClick(purchaseBtn, false, true)
        else
            CommonHelper:SetHButtonClick(purchaseBtn, true, true)
        end
    end
    CommonHelper:FilmView_Init(self.itemList, #data, UpdateFunc, false)


end

