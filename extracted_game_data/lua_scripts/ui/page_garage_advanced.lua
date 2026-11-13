
---@class PageGarageAdvanced
PageGarageAdvanced = class("PageGarageAdvanced")

function PageGarageAdvanced:initialize()

end

---@param article ArticleCell
function PageGarageAdvanced:SetData(root,article,cost, funcback,funcadd)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funcback then funcback() end
    end)
    self.Article=article
    local partobj = UIUtil.GetChild("ItemPart", root)
    if self.Article then
        local param = Param_ItemPartParam()
        param.quality = self.Article:GetPartQuality()
        param.star = self.Article:GetStar()
        param.lv = self.Article:GetPartLV()
        param.using = self.Article:GetCarId()
        param.lock = self.Article:GetPartLock()
        param.awaken=self.Article:GetAwaken()
        param.generation=self.Article:GetGeneration()
        param.downType=self.Article:GetPartDownType()
        param.source = self.Article:GetPartSource()
        param.expireTime = self.Article:GetPartExpTime()
        CommonHelper:SetItemPartGroup(partobj, UIModuleID.Garage, self.Article:GetPartConfig().C_ID, ItemPartUIType.Normal, param)
    end
    CommonHelper:HButtonSetCallback("BtnAdd",root,function (hbtn)
        ---@type table<string, ArticleCell[]>
        local result= AssembleHelper:GetArticleListByBaseId(self.Article,cost)
        if  #result[TemplateStringID.AdvancedCostUseArticle]<self.Article:GetCurGenerationData().neednum then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartAdvancedNoEnough))
        else
            if funcadd then funcadd(article,cost) end
        end
    end)
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        local costresult=""
        local flag=true
        for i = 1, self.Article:GetCurGenerationData().neednum do
            if cost[i]==nil or cost[i]==0 then
                flag=false
                break
            else
                if i==self.Article:GetCurGenerationData().neednum then
                    costresult=costresult..cost[i]
                else
                    costresult=costresult..cost[i]..":"
                end
            end
        end
        if flag then
            ReformSubsystem:Get():SendMsg_PartAdvanced(self.Article:GetCellID(),costresult)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.AdvancedSelectError))
        end

    end)
    local attrs ={}
    local breakAttrs ={}
    for i = 1, #self.Article:GetPartBreakCfg().attrtypes do
        breakAttrs[self.Article:GetPartBreakCfg().attrtypes[i]]=self.Article:GetPartBreakCfg().breakvalues[i]
    end
    for k, v in pairs(self.Article:GetGenerationAttrList()[self.Article:GetGeneration() + 1].NewAttr) do
        local oldAttr= self.Article:GetCurGenerationData().NewAttr[k]
        if oldAttr==nil or v.value~=oldAttr.value then
            local data = PartAttrCfg()
            data.type = v.type
            if oldAttr then
                data.value = v.value-oldAttr.value
            else
                data.value=v.value
            end
            table.insert(attrs,data)
        end
    end
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #attrs, 1,function(dataIndex, itemObj, scroll)
        CommonHelper:SetText("###name",itemObj,CommonHelper:GetAttrName(attrs[dataIndex+1].type))
        local oldValue=self.Article:GetPartAttr(attrs[dataIndex+1].type)
        if breakAttrs[attrs[dataIndex+1].type] and self.Article:GetAwaken() then
            CommonHelper:SetText("###valueold",itemObj, string.format("%0.2f-%0.2f", oldValue,breakAttrs[attrs[dataIndex+1].type]))
            oldValue=oldValue-breakAttrs[attrs[dataIndex+1].type]
        else
            CommonHelper:SetText("###valueold",itemObj, string.format("%0.2f", oldValue))
        end

        CommonHelper:SetText("###valuenew",itemObj, string.format("%0.2f", oldValue+attrs[dataIndex+1].value))
    end)
    if cost==nil then cost={} end
    for i = 1,4  do
      local item= CommonHelper:SetGameObjectActive("cost"..i,root,self.Article:GetCurGenerationData().neednum>=i)
       CommonHelper:SetGameObjectActive("ItemPart",item,cost[i]~=nil and cost[i]~=0)
        if cost[i] and cost[i]~=0 then
            local articleCell= KnapsackDataManager:Get():GetArticleByCellID(cost[i])
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
function PageGarageAdvanced:UpdateMsg()

end

