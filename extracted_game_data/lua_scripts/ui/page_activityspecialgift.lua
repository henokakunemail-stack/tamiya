---@class Page_ActivitySpecialGift
Page_ActivitySpecialGift = class("Page_ActivitySpecialGift", Page_ActivityBase)

function Page_ActivitySpecialGift:initialize()

end

---@param msg SC_ActivityInfo
---@param activityType ActivityType
function Page_ActivitySpecialGift:InitViewInfo(parent, activityType, msg)
    Page_ActivityBase:InitViewInfo(parent, activityType, msg)
    self.Root=parent
    self:SetData(msg)
    -----@type activityitem_config_cell
    --self.curSelectItemCell = nil
    -----@type table<number,number> @key 是格子的索引，value是物品ID
    --self.selectItemId = {}
    --self.giftList = UIUtil.GetTypeChildWightByParent("GiftList", self.parent, typeof(MoreRowScrollView))
    --self.previewList = UIUtil.GetTypeChildWightByParent("PreviewList", self.parent, typeof(MoreRowScrollView))
    --self.previewListCG = UIUtil.GetTypeChildWightByParent("Preview", self.parent, typeof(CanvasGroup))
    --
    --self.gridList = {}
    --self:CacheGridListData()
    --
    --self:InitGiftList()
    --
    --UIUtil.ShowCanvasGroup(self.previewListCG, false)
    --
    --CommonHelper:HButtonSetCallback("BtnPurchase", self.parent, function()
    --    self:OnPurchaseBtnClick()
    --end)
    --
    --CommonHelper:HButtonSetCallback("PreviewBtn", self.parent, function()
    --    UIUtil.ShowCanvasGroup(self.previewListCG, false)
    --end)
end
function Page_ActivitySpecialGift:SetData(msg)
    local data={}
    for i = 1, #msg.curActInfo do
        ---@type act_period_config_cell
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.act_period_config,msg.curActInfo[i].itemid)
        local chargecfg=CommonHelper:GetChargeCfgByAreaAndItemId(msg.curActInfo[i].itemid)
        table.insert(data,{Cfg=cfg,chargecfg=chargecfg})--,BuyState=msg.curActInfo[i].buyState,CurDay=msg.curActInfo[i].curDay,GetState=msg.curActInfo[i].curGetState,DaySum=msg.curActInfo[i].daySum})
    end
    self.ScrollView = UIUtil.GetTypeChildWightByParent("ScrollView", self.parent, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.itemList,#data,1,function(dataIndex, itemObj, scroll)

    end)
end
























function Page_ActivitySpecialGift:OnPurchaseBtnClick()


    local previewData = self:GetPreviewData(self.curSelectItemCell.reward)

    local goodId = ""

    local isCanPurchase = true

    for i = 1, previewData.fixCount do
        goodId = string.format("%s%s,", goodId, previewData.fix[i])
    end

    for i = 1, previewData.selectCount do
        if #self.selectItemId[i] > 0 then
            goodId = string.format("%s%s,", goodId, self.selectItemId[i][1])
        else
            isCanPurchase = false
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CellNoSelectItem, i))
            break
        end
    end
    if isCanPurchase then
        if self.curSelectItemCell.diamond == -1 then
            ---@type paylist_config_cell
            local payCell = CommonHelper:GetTableDataByID(ConfigNames.paylist_config, self.curSelectItemCell.payId)
            CommonHelper:ChargeMoneyByID(payCell.C_ID)
        else
            ActivitySubsystem:Get():SendMsg_GetActivityReward(self.curSelectItemCell.id, goodId)
        end
    end
end

function Page_ActivitySpecialGift:CacheGridListData()
    for i = 1, 5 do
        self.selectItemId[i] = {}
        local grid = UIUtil.GetChild("Grid" .. i, self.parent)
        table.insert(self.gridList, grid)
    end
end

function Page_ActivitySpecialGift:InitGiftList()
    local count = ActivityDataManager:Get():GetActivityItemCountByType(self.activityType)
    if self.curSelectItemCell == nil and count > 0 then
        local activityItemData = ActivityDataManager:Get():GetActivityItemDataByIdx(self.activityType, 1)
        ---@type activityitem_config_cell
        local cell = CommonHelper:GetTableDataByID(ConfigNames.activityitem_config, activityItemData:GetActivityItemID())
        self.curSelectItemCell = cell
    end

    local lastSelectImg = nil
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local activityItemData = ActivityDataManager:Get():GetActivityItemDataByIdx(self.activityType, dataIndex + 1)
        ---@type activityitem_config_cell
        local cell = CommonHelper:GetTableDataByID(ConfigNames.activityitem_config, activityItemData:GetActivityItemID())
        local selectImg = CommonHelper:SetGameObjectActive("selectImg", itemObj, cell.id == self.curSelectItemCell.id)

        if cell.id == self.curSelectItemCell.id then
            lastSelectImg = selectImg
            self:InitSelectInfo(cell)
        end

        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(param)
            if self.curSelectItemCell.id ~= cell.id then
                self.curSelectItemCell = cell
                self:InitSelectInfo(cell)

                if lastSelectImg ~= nil then
                    CommonHelper:SetGameObjectActive(lastSelectImg.gameObject, false)
                end
                CommonHelper:CSGameObjectSetActive(selectImg.gameObject, true)
                lastSelectImg = selectImg
            end
        end)
    end
    CommonHelper:InitMoreRowScrollView(self.giftList, count, 1, UpdateFunc, true)
end

---@param cell activityitem_config_cell
function Page_ActivitySpecialGift:InitSelectInfo(cell)

    local selectPreview = self:GetPreviewData(cell.reward)

    for i = 1, #self.gridList do
        CommonHelper:CSGameObjectSetActive(self.gridList[i], i <= selectPreview.selectCount)
        CommonHelper:SetGameObjectActive("AddImg", self.gridList[i].gameObject, #self.selectItemId[i] <= 0)

        CommonHelper:HButtonSetCallback("SelectBtn", self.gridList[i].gameObject, function()
            UIUtil.ShowCanvasGroup(self.previewListCG, true)
            self:InitPreviewList(selectPreview, i)
        end)
    end
end

---@param selectPreview ActivityPreviewData
function Page_ActivitySpecialGift:InitPreviewList(selectPreview, selectGridId)
    local lastSelectImg = nil
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type parts_config_cell
        local propType, cfg = CommonHelper:GetPropTypeById(selectPreview.select[selectGridId][dataIndex + 1])

        local selectImg = CommonHelper:SetGameObjectActive("selectImg", itemObj, self.selectItemId[selectGridId][1] == cfg.id)

        if self.selectItemId[selectGridId][1] == cfg.id then
            lastSelectImg = selectImg
        end

        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(param)
            if self.selectItemId[selectGridId][1] ~= cfg.id then
                self.selectItemId[selectGridId][1] = cfg.id
                self:InitSelectInfo(self.curSelectItemCell)

                if lastSelectImg ~= nil then
                    CommonHelper:CSGameObjectSetActive(lastSelectImg.gameObject, false)
                end
                CommonHelper:CSGameObjectSetActive(selectImg.gameObject, true)
                lastSelectImg = selectImg
            end
            UIUtil.ShowCanvasGroup(self.previewListCG, false)
        end)
    end
    CommonHelper:InitMoreRowScrollView(self.previewList, selectPreview.selectCount, 2, UpdateFunc, true)
end

---@return ActivityPreviewData
function Page_ActivitySpecialGift:GetPreviewData(reward)
    local previewData = {}
    previewData.fix = {}
    previewData.select = {}
    previewData.fixCount = 0
    previewData.selectCount = 0

    local strTab = stringSplit(reward, '|')
    for i = 1, #strTab do
        local subTab = stringSplit(strTab[i], ';')
        if #subTab == 1 then
            previewData.fixCount = previewData.fixCount + 1
            previewData.fix = {}
            table.insert(previewData.fix, tonumber(stringSplit(subTab[1], ',')[1]))
        else
            previewData.selectCount = previewData.selectCount + 1
            previewData.select[previewData.selectCount] = {}
            for j = 1, #subTab do
                table.insert(previewData.select[previewData.selectCount], tonumber(stringSplit(subTab[j], ',')[1]))
            end
        end
    end
    return previewData
end

