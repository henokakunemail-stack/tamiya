
---@class PageGarageAdvancedSelect
PageGarageAdvancedSelect = class("PageGarageAdvancedSelect")

function PageGarageAdvancedSelect:initialize()

end

---@param article ArticleCell
function PageGarageAdvancedSelect:SetData(root,article,cost, funcback,funcsure)
    self.Article=article
    local orgCost={}
    for k, v in pairs(cost) do
        orgCost[k]=v
    end
    if cost==nil then cost={} end
    self.SelectCount=0
    for i = 1, #cost do
        if cost[i]~=0 then
            self.SelectCount=self.SelectCount+1
        end
    end
    self.Cost=cost
    self.Root=root
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funcback then funcback(article,orgCost) end
    end)
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if funcsure then funcsure(article,self.Cost) end
    end)
    self:SetCost()
    ---@type table<string, ArticleCell[]>
    self.SiftList= AssembleHelper:GetArticleListByBaseId(self.Article,cost)
    --{{{解析数据
    self.ScrollData = {}
    local temp = MoreRowScrollViewTittleGroup()
    if #self.SiftList[TemplateStringID.AdvancedCostUseArticle]>0 then
        temp.tittle =TemplateStringID.AdvancedCostUseArticle
        temp.totle = #self.SiftList[TemplateStringID.AdvancedCostUseArticle]
        temp.groupIndex = 1
        table.insert(self.ScrollData, temp)
    end
    local temp = MoreRowScrollViewTittleGroup()
    if #self.SiftList[TemplateStringID.AdvancedCostNotUseArticle]>0 then
        temp.tittle =TemplateStringID.AdvancedCostNotUseArticle
        temp.totle = #self.SiftList[TemplateStringID.AdvancedCostNotUseArticle]
        temp.groupIndex = 2
        table.insert(self.ScrollData, temp)
    end
    --}}}
    self.ScrollView = UIUtil.GetTypeChildWightByParent("TitleScrollView", root, typeof(MoreRowScrollViewTittle))
    CommonHelper:MoreRowTitle_Init(self.ScrollView, self.ScrollData, 4,function(title, tittleIdx, itemObj, type ,dataIndex, scroll)
        if type == TittleItemType.Title then
            CommonHelper:SetText("###text", itemObj, CommonHelper:GetTempStr_Default(title))
        end
        if type == TittleItemType.Item then
            local datalist = self.SiftList[title]
            ---@type ArticleCell
            local data = datalist[dataIndex + 1].data
            local select = datalist[dataIndex + 1].select
            local type = datalist[dataIndex + 1].type
            local desc = datalist[dataIndex + 1].desc

            CommonHelper:SetGameObjectActive("partlock", itemObj, type==AdvancedPartType.NotUse)
            CommonHelper:SetGameObjectActive("TogSelectRed", itemObj, type==AdvancedPartType.Use)
            CommonHelper:SetGameObjectActive("RedPointPart", itemObj, false)
            local tempobj = UIUtil.GetChild("ItemPart", itemObj)
            local param = Param_ItemPartParam()
            param.quality = data:GetPartQuality()
            param.star = data:GetStar()
            param.lv = data:GetPartLV()
            param.using = data:GetCarId()
            param.lock = data:GetPartLock()
            param.awaken=data:GetAwaken()
            param.downType=data:GetPartDownType()
            param.generation=data:GetGeneration()
            param.source = data:GetPartSource()
            param.expireTime = data:GetPartExpTime()
            CommonHelper:SetItemPartGroup(tempobj, UIModuleID.Garage, data:GetID(), ItemPartUIType.Normal, param,function()
                CommonTipsHelper:Get():ShowCenterTips(desc)
            end)
            local Toggle= CommonHelper:HButtonSetCallback("TogSelectRed", itemObj, function(data)
                self:CheckSelectIndex(title,data.intData)
            end,dataIndex + 1)
            CommonHelper:SetGameObjectActive("hover",itemObj, select)
        end
    end)
end
function PageGarageAdvancedSelect:SetCost()
    for i = 1,4  do
        local item= CommonHelper:SetGameObjectActive("cost"..i,self.Root,self.Article:GetCurGenerationData().neednum>=i)
        CommonHelper:SetGameObjectActive("ItemPart",item,self.Cost[i]~=nil and self.Cost[i]~=0)
        if self.Cost[i] and self.Cost[i]~=0 then
            local articleCell= KnapsackDataManager:Get():GetArticleByCellID(self.Cost[i])
            local param = Param_ItemPartParam()
            param.quality = articleCell:GetPartQuality()
            param.star = articleCell:GetStar()
            param.lv =articleCell:GetPartLV()
            param.using = articleCell:GetCarId()
            param.lock = articleCell:GetPartLock()
            param.awaken=articleCell:GetAwaken()
            param.generation=articleCell:GetGeneration()
            param.downType=articleCell:GetPartDownType()
            param.source = articleCell:GetPartSource()
            param.expireTime = articleCell:GetPartExpTime()
            CommonHelper:SetItemPartGroup(item, UIModuleID.Garage, articleCell:GetPartConfig().C_ID, ItemPartUIType.Normal, param)
        end
    end
end
function PageGarageAdvancedSelect:UpdateMsg()

end
function PageGarageAdvancedSelect:CheckSelectIndex(title,index)
    ---@type ArticleCell
    local data = self.SiftList[title][index].data
    local select = self.SiftList[title][index].select
    local selectIndex = self.SiftList[title][index].selectIndex
    if select then
        --取消
        for k, v in pairs(self.Cost) do
            if v==data:GetCellID() then
                self.Cost[k]=0
                self.SelectCount=self.SelectCount-1
                break
            end
        end
        self.SiftList[title][index].selectIndex=0
        self.SiftList[title][index].select=false
    else
        if self.SelectCount>=self.Article:GetCurGenerationData().neednum then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.AdvancedSelectExceed))
            return
        end
        for i = 1, self.Article:GetCurGenerationData().neednum do
            if self.Cost[i]==nil or self.Cost[i]==0 then
                self.Cost[i]=data:GetCellID()
                self.SiftList[title][index].selectIndex=i
                self.SiftList[title][index].select=true
                self.SelectCount=self.SelectCount+1
                break
            end
        end
    end
    CommonHelper:MoreRowTitle_Refresh(self.ScrollView,false)
    self:SetCost()
end

