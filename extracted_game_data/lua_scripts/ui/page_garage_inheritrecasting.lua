---@class PageGarageInheritRecasting
PageGarageInheritRecasting = class("PageGarageInheritRecasting")

function PageGarageInheritRecasting:initialize()

end

---@param data ArticleCell
function PageGarageInheritRecasting:SetData(root, data, index, funback)
    ---@type PartInheritData
    self.Root=root
    self.data=data
    self.Index=index
    self.Funback=funback
    self.InheritData=data:GetCurPartInheritList()[index]
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback(data) end
    end)
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if PlayerDataManager:Get():CheckCurrencyEnough(self.InheritData.Cfg.RecastingCost.id,self.InheritData.Cfg.RecastingCost.num,true) then
            ReformSubsystem:SendMsg_InheritRecasting(data:GetCellID(),self.InheritData.InheritId)
        end
    end)
    self.BtnProb=CommonHelper:HButtonSetCallback("BtnRule",root,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.ReformProb,nil,HelpStyleType.BlueStyle)
    end)
    CommonHelper:SetHButtonClick(self.BtnProb,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnProb),true)
    CommonHelper:SetHButtonClick(self.BtnProb, false,true)
    CommonHelper:SetText("###recastingtype", root, CommonHelper:GetTempStr_Default(self.InheritData.Cfg.inheritname))
    local List={}
    for i = 1, #self.InheritData.Cfg.RecastingAttrs do
        if self.InheritData.Cfg.RecastingAttrs[i].value~=0 then
            local cur=0
            if self.InheritData.ReformVal[i] then
                cur=self.InheritData.ReformVal[i]
            end
            table.insert(List,{id=self.InheritData.Cfg.AttrIds[i],max=self.InheritData.Cfg.RecastingAttrs[i].value,cur=cur})
        end
    end
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.Root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #List, 1,function(dataIndex, itemObj, scroll)
        CommonHelper:SetText("###name",itemObj,CommonHelper:GetAttrName(List[dataIndex+1].id))
        CommonHelper:SetText("###value",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.InheritRecastingNumFormat,List[dataIndex+1].cur,List[dataIndex+1].max))
    end)
    local temp=UIUtil.GetChildInputPath("Article1",root)
    local param = Param_ItemArticleParam()
    param.count = self.InheritData.Cfg.RecastingCost.num
    CommonHelper:SetItemArticleGroup(temp,UIModuleID.Garage,self.InheritData.Cfg.RecastingCost.id,param,function(id)
        CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.Garage,true)
    end,self.InheritData.Cfg.RecastingCost.id)
    local articleCfg=CommonHelper:GetTableDataByID(ConfigNames.article_config,self.InheritData.Cfg.RecastingCost.id)
    CommonHelper:SetText("###articlename",root,CommonHelper:GetTempStr_Default(articleCfg.name))
    CommonHelper:SetText("###desc",root,CommonHelper:GetTempStr_Default(articleCfg.description))
    CommonHelper:SetText("###cost",root,CommonHelper:GetTempStr_Default(TemplateStringID.CollectWordNum,tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(self.InheritData.Cfg.RecastingCost.id))))

end
function PageGarageInheritRecasting:UpdateMsg()
     self:SetData(self.Root, self.data, self.Index, self.Funback)
end
