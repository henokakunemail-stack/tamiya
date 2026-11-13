---@class PageGarageInheritCost
PageGarageInheritCost = class("PageGarageInheritCost")

function PageGarageInheritCost:initialize()

end

---@param article ArticleCell
function PageGarageInheritCost:SetData(root,article,index,inheritId, optionType,funback)
    self.SelectIdx = 0
    self.Root = root
    self.Article = article
    self.InheritPos = index
    if optionType==InheritOptionType.Replace then
        ---@type PartInheritData
        self.OrgInheritData=self.Article:GetCurPartInheritList()[index]
    end
    self.inheritId = inheritId
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback(article,index,inheritId,optionType) end
    end)

    CommonHelper:HButtonSetCallback("BtnItem",root,function (hbtn)
        self.SelectIdx =  self.SelectIdx==0 and 1 or 0
        self:SetSelect()
    end)
    ---@type dictinherit_config_cell
    self.InheritCfg=CommonHelper:GetTableDataByID(ConfigNames.dictinherit_config,inheritId)
    self.PartList= KnapsackDataManager:Get():GetPartNoChangeListByCfgid(self.InheritCfg.OpenCostPart.id,{article})
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if self.SelectIdx==0 or self.SelectIdx==1 then
            local tips=""
            if self.SelectIdx==0 then
                if optionType==InheritOptionType.Replace then
                    tips=CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectReplaceCostOkPartTips,CommonHelper:GetPartOrArticleName(self.InheritCfg.OpenCostPart.id),self.InheritCfg.OpenCostPart.num,CommonHelper:GetTempStr_Default(self.OrgInheritData.Cfg.inheritname),CommonHelper:GetTempStr_Default(self.InheritCfg.inheritname))
                else
                    tips=CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectCostOkPartTips,CommonHelper:GetPartOrArticleName(self.InheritCfg.OpenCostPart.id),self.InheritCfg.OpenCostPart.num,CommonHelper:GetTempStr_Default(self.InheritCfg.inheritname))
                end
                if #self.PartList<self.InheritCfg.OpenCostPart.num then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectPartCostNoEnough, CommonHelper:GetPartOrArticleName(self.InheritCfg.OpenCostPart.id)))
                    return
                end
            end
            if self.SelectIdx==1 then
                if optionType==InheritOptionType.Replace then
                    tips=CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectReplaceCostOkArticleTips,CommonHelper:GetPartOrArticleName(self.InheritCfg.OpenCostArticle.id),self.InheritCfg.OpenCostArticle.num,CommonHelper:GetTempStr_Default(self.OrgInheritData.Cfg.inheritname),CommonHelper:GetTempStr_Default(self.InheritCfg.inheritname))
                else
                    tips=CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectCostOkArticleTips,CommonHelper:GetPartOrArticleName(self.InheritCfg.OpenCostArticle.id),self.InheritCfg.OpenCostArticle.num,CommonHelper:GetTempStr_Default(self.InheritCfg.inheritname))
                end
                if not PlayerDataManager:Get():CheckCurrencyEnough(self.InheritCfg.OpenCostArticle.id,self.InheritCfg.OpenCostArticle.num,false) then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectArticleCostNoEnough,CommonHelper:GetPartOrArticleName(self.InheritCfg.OpenCostArticle.id)))
                    return
                end
            end
            if optionType==InheritOptionType.Replace then
                local boxFunc = function()
                    local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil,tips)
                    if ret == MessageBoxHelp.BtnType.OK then
                        if self.SelectIdx==0 then
                            ReformSubsystem:Get():SendMsg_InheritDel(self.Article:GetCellID(),self.OrgInheritData.InheritId,inheritId,self.SelectIdx,self.PartList[1]:GetCellID())
                        else
                            ReformSubsystem:Get():SendMsg_InheritDel(self.Article:GetCellID(),self.OrgInheritData.InheritId,inheritId,self.SelectIdx,self.InheritCfg.OpenCostArticle.id)
                        end

                    end
                end
                MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
            else
                local boxFunc = function()
                    local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil,tips)
                    if ret == MessageBoxHelp.BtnType.OK then
                        if self.SelectIdx==0 then
                            ReformSubsystem:Get():SendMsg_InheritPart(self.Article:GetCellID(),inheritId,self.SelectIdx,self.PartList[1]:GetCellID())
                        else
                            ReformSubsystem:Get():SendMsg_InheritPart(self.Article:GetCellID(),inheritId,self.SelectIdx,self.InheritCfg.OpenCostArticle.id)
                        end

                    end
                end
                MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
            end


            return
        end
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectCostTips))
    end)
    self:SetSelect()
end
function PageGarageInheritCost:SetSelect()
    local itemCur=UIUtil.GetChild("Itemcur",self.Root)
    local itemClick=UIUtil.GetChild("Itemclick",self.Root)
    if self.SelectIdx==0 then
        CommonHelper:SetText("###curcost",self.Root,CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectCostTips1))
        self:SetItem(itemCur,self.SelectIdx)
        self:SetItem(itemClick,1)
    else
        CommonHelper:SetText("###curcost",self.Root,CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectCostTips2))
        self:SetItem(itemCur,self.SelectIdx)
        self:SetItem(itemClick,0)
    end
end

function PageGarageInheritCost:SetItem(parent,type)
    CommonHelper:SetGameObjectActive("cost1",parent,type==0)
    CommonHelper:SetGameObjectActive("cost2",parent,type==1)

    CommonHelper:SetGameObjectActive("emptypart",parent,#self.PartList<=0)
    local partobj=UIUtil.GetChild("ItemPart_138",parent)
    local param = Param_ItemPartParam()
    if self.PartList[1] then
        param.quality = self.PartList[1]:GetPartQuality()
        param.generation = self.PartList[1]:GetGeneration()
        param.downType = self.PartList[1]:GetPartDownType()
        param.source = self.PartList[1]:GetPartSource()
        param.expireTime = self.PartList[1]:GetPartExpTime()
    end
    CommonHelper:SetItemPartGroup(partobj, UIModuleID.Garage, self.InheritCfg.OpenCostPart.id, ItemPartUIType.Simple, param,function()
        CommonHelper:ShowPartInfoByCfgId(self.InheritCfg.OpenCostPart.id,UIModuleID.Garage,false)
    end)

    local ArticleObj=UIUtil.GetChild("ItemArticle_138",parent)
    local param = Param_ItemArticleParam()
    CommonHelper:SetItemArticleGroup(ArticleObj,UIModuleID.Garage,self.InheritCfg.OpenCostArticle.id, param,function(data)
        CommonHelper:ShowPartInfoByCfgId(self.InheritCfg.OpenCostArticle.id,UIModuleID.Garage,false)
    end,self.InheritCfg.OpenCostArticle.id)
    local tempstr = ""
    local cur=KnapsackDataManager:Get():GetArticleCountByCfgid(self.InheritCfg.OpenCostArticle.id)
    CommonHelper:SetGameObjectActive("emptyarticle",parent,cur<self.InheritCfg.OpenCostArticle.num)
    CommonHelper:SetGameObjectActive("ItemArticle_138",parent,cur>=self.InheritCfg.OpenCostArticle.num)
    if cur >= self.InheritCfg.OpenCostArticle.num then
        tempstr = CommonHelper:GetTempStr_Default(TemplateStringID.InheritItemOpenArticleCostNormal, cur, self.InheritCfg.OpenCostArticle.num)
    else
        tempstr = CommonHelper:GetTempStr_Default(TemplateStringID.InheritItemOpenArticleCostRed, cur, self.InheritCfg.OpenCostArticle.num)
    end
    CommonHelper:SetText("###costcount",parent,tempstr)
end
