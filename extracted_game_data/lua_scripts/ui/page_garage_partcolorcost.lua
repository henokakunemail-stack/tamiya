


--车库左侧，进化

---@class PageGaragePartColorCost
PageGaragePartColorCost = class("PageGaragePartColorCost")

function PageGaragePartColorCost:initialize()
    self.CostFlag = -1
end

---@param article ArticleCell
---@param changepart dictparts_config_cell
function PageGaragePartColorCost:SetData(root,article, changepart,funcback)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funcback then funcback() end
    end)
    self.Article=article
    self.ChangePart=changepart
    self.Root=root
    self:SetCost()
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if self.Article and self.ChangePart then
            local flag=false
            for i = 1, #self.Cost do
                flag= PlayerDataManager:Get():CheckCurrencyEnough(self.Cost[i].id,self.Cost[i].num,true)
                if flag==false then
                    break
                end
            end
            if flag then
                AssembleSubsystem:Get():SendMsg_AlterPartCopy(self.Article:GetCellID(), self.ChangePart.C_ID,self.Article:GetColor(),self.Article:GetSticker(),self.Article:GetPartShellGridList())
            end
        end
    end)
    CommonHelper:GetComponentSetUITexture("particon",self.Root,self.ChangePart.icon,UIModuleID.Garage)
end

function PageGaragePartColorCost:SetCost()
    self.Cost=CommonHelper:SetDataByStrIdAndNum(self.ChangePart.consumeids,self.ChangePart.consumenums)
    local root=CommonHelper:SetGameObjectActive("cost1",self.Root,#self.Cost<=2)
    if #self.Cost>2 then
        root=CommonHelper:SetGameObjectActive("cost2",self.Root,#self.Cost>2)
    else
        CommonHelper:SetGameObjectActive("cost2",self.Root,false)
    end

    for i = 1, #self.Cost-1 do
        local temp=UIUtil.GetChild("Article"..i,root)
        local param = Param_ItemArticleParam()
        param.count = self.Cost[i].num
        CommonHelper:SetItemArticleGroup(temp,UIModuleID.Garage,self.Cost[i].id,param,function(id)
            CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.Garage,true)
        end,self.Cost[i].id)
        ---@type dictarticle_config_cell
        local cfg= CommonHelper:GetTableDataByID(ConfigNames.article_config,self.Cost[i].id)
        CommonHelper:SetText("###articlename",temp,CommonHelper:GetTempStr_Default(cfg.name))
        CommonHelper:SetText("###cost",temp,CommonHelper:GetTempStr_Default(TemplateStringID.CollectWordNum,tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(self.Cost[i].id))))
    end
    CommonHelper:SetText("###costvalue",self.Root,tostring(self.Cost[#self.Cost].num))
end
