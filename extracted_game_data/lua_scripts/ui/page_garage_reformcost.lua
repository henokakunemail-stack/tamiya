

--车库右侧，涂装入口

---@class PageGarageReformCost
PageGarageReformCost = class("PageGarageReformCost")

function PageGarageReformCost:initialize()
    ---@type ArticleCell
    self.Article = nil
    self.ReformPos = -1
    self.ReformId = -1
end

function PageGarageReformCost:SetData(root, article, pos, reformid, funback)
    self.Article = article
    self.ReformPos = pos
    self.ReformId = reformid

    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)
    ---@type dictpartsdevelop_config_cell
    self.cfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartsdevelop_config, reformid)
    ---@type dictconsume_config_cell[]
    local costs = CommonHelper:GetConsumeGroup(self.cfg.costids)
    self.costs=costs
    self.Root=root
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        local IsUsePerfact=self.IsUsePerfact and 1 or 0
        if self.Article then
            local flag=false
            for i = 1, #costs do
                flag= PlayerDataManager:Get():CheckCurrencyEnough(costs[i].propsid,costs[i].propsnum,true)
                if flag==false then
                    break
                end
            end
            if flag then
                ReformSubsystem:SendMsg_ReformPos(self.Article:GetCellID(), self.ReformPos, self.cfg.entryid, IsUsePerfact)
            end
        end
    end)

    self.TogUse = CommonHelper:HButtonSetCallback("TogTrue",root,function (hbtn)
        self:OnClickTogPerfact(true)
    end)
    self.TogNotUse = CommonHelper:HButtonSetCallback("TogFalse",root,function (hbtn)
        self:OnClickTogPerfact(false)
    end)

    self:SetArticleCost()
    self:AutoSelect()
    self.BtnProb=CommonHelper:HButtonSetCallback("BtnProb",root,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.ReformProb,nil,HelpStyleType.BlueStyle)
    end)
    CommonHelper:SetHButtonClick(self.BtnProb,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnProb),true)
end

function PageGarageReformCost:AutoSelect()
    self:OnClickTogPerfact(false)
end
function PageGarageReformCost:SetArticleCost()
    local costs= self.costs
    local root= self.Root
    local goldNum=0
    --{{{材料消耗
    for i = 1, 3 do
        local data = costs[i]
        if data.propsid==CurrencyType.Gold then
            goldNum=data.propsnum
            data=nil
        end
        local obj = UIUtil.GetChild("Article"..i, root)
        local articleobj = UIUtil.GetChild("ItemArticle", obj)

        CommonHelper:SetGameObjectActive("blank", obj, data == nil)
        CommonHelper:SetGameObjectActive("normal", obj, data ~= nil)

        if data then
            ---@type dictarticle_config_cell
            local articlecfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, data.propsid)

            --{{{名字
            CommonHelper:SetText("###articlename", obj, CommonHelper:GetTempStr_Default(articlecfg.name))
            --}}}

            --{{{描述
            CommonHelper:SetText("###articledes", obj, CommonHelper:GetTempStr_Default(articlecfg.description))
            --}}}

            --{{{数量
            local count = data.propsnum
            local cur = KnapsackDataManager:Get():GetArticleCountByCfgid(data.propsid)
            local tempstr = ""
            if cur >= count then
                tempstr = CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountFormatGreen, cur, count)
            else
                tempstr = CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountFormatRed, cur, count)
            end
            CommonHelper:SetText("###articlecount", obj, tempstr)
            --}}}


            --{{{item
            CommonHelper:SetItemArticleGroup(articleobj, UIModuleID.Garage, data.propsid,nil,function(data)
                CommonHelper:ShowPartInfoByCfgId(data, UIModuleID.Garage,true)
            end,data.propsid)
            --}}}

        end

    end
    --}}}


    --{{{货币消耗
    CommonHelper:SetText("###costvalue", root, tostring(goldNum))
    --}}}



    --{{{完美材料
    if self.cfg then
        local perfactobj = UIUtil.GetChild("PerfactArticle", root)
        local param = Param_ItemArticleParam()
        param.count = KnapsackDataManager:Get():GetArticleCountByCfgid(self.cfg.perfectcost)
        CommonHelper:SetItemArticleGroup(perfactobj, UIModuleID.Garage, self.cfg.perfectcost, param,function(data)
            CommonHelper:ShowPartInfoByCfgId(data, UIModuleID.Garage,true)
        end,self.cfg.perfectcost)


        ---@type dictarticle_config_cell
        local tempcfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, self.cfg.perfectcost)
        CommonHelper:SetText("###perfactname", root, CommonHelper:GetTempStr_Default(tempcfg.name))
    end
    --}}}
end
function PageGarageReformCost:UpdateMsg()
    self:SetArticleCost()
end

function PageGarageReformCost:OnClickTogPerfact(flag)
    if flag then
        local count = KnapsackDataManager:Get():GetArticleCountByCfgid(self.cfg.perfectcost)
        if count <= 0 then
            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.PartPerfactReformNotEnough))
            return
        end
    end

    self.IsUsePerfact = flag
    CommonHelper:SetToggleState(self.TogNotUse, not flag)
    CommonHelper:SetToggleState(self.TogUse, flag)
end