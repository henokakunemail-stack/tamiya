
---@class PageGarageAwake
PageGarageAwake = class("PageGarageAwake")

function PageGarageAwake:initialize()

end

---@param article ArticleCell
function PageGarageAwake:SetData(root,article, funcback)
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
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if PlayerDataManager:Get():CheckCurrencyEnough(self.Article:GetPartBreakCostCfg().id,self.Article:GetPartBreakCostCfg().value,true) then
            ReformSubsystem:Get():SendMsg_ReqBreakUp(self.Article:GetCellID())
        end
    end)
    local attrs = self.Article:GetPartBreakCfg().attrtypes
    local attrvals = self.Article:GetPartBreakCfg().breakvalues
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #attrs, 1,function(dataIndex, itemObj, scroll)
        CommonHelper:SetText("###name",itemObj,CommonHelper:GetAttrName(attrs[dataIndex+1]))
        local oldValue=self.Article:GetPartAttr(attrs[dataIndex+1])
        CommonHelper:SetText("###valueold",itemObj, string.format("%0.2f", oldValue))
        CommonHelper:SetText("###valuenew",itemObj, string.format("%0.2f", oldValue+attrvals[dataIndex+1]))
    end)
    local temp=UIUtil.GetChildInputPath("Article1",root)
    local param = Param_ItemArticleParam()
    param.count = self.Article:GetPartBreakCostCfg().value
    CommonHelper:SetItemArticleGroup(temp,UIModuleID.Garage,self.Article:GetPartBreakCostCfg().id,param,function(id)
        CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.Garage,true)
    end,self.Article:GetPartBreakCostCfg().id)
    local articleCfg=CommonHelper:GetTableDataByID(ConfigNames.article_config,self.Article:GetPartBreakCostCfg().id)
    CommonHelper:SetText("###articlename",root,CommonHelper:GetTempStr_Default(articleCfg.name))
    CommonHelper:SetText("###desc",root,CommonHelper:GetTempStr_Default(articleCfg.description))
    CommonHelper:SetText("###cost",root,CommonHelper:GetTempStr_Default(TemplateStringID.CollectWordNum,tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(self.Article:GetPartBreakCostCfg().id))))

end
function PageGarageAwake:UpdateMsg()

end

