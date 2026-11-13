

--车库右侧，重铸

---@class PageGarageReformReplace
PageGarageReformReplace = class("PageGarageReformReplace")

function PageGarageReformReplace:initialize()
    ---@type ArticleCell
    self.Article = nil
    self.ReformPos = -1
end

function PageGarageReformReplace:SetData(root, article, pos, funback)
    self.Article = article
    self.Entry = pos

    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)



    self.TogUse = CommonHelper:HButtonSetCallback("TogTrue",root,function (hbtn)
        self:OnClickTogPerfact(true)
    end)
    self.TogNotUse = CommonHelper:HButtonSetCallback("TogFalse",root,function (hbtn)
        self:OnClickTogPerfact(false)
    end)



    ---@type reformagain_config_cell
    local cfg = CommonHelper:GetDevelopByEntryId(self.Entry)
    --{{{材料消耗
    ---@type dictconsume_config_cell[]
    local rewards = CommonHelper:GetConsumeGroup(cfg.reformagain)
    local data = rewards[1]
    self.data=data
    self.Root=root
    self.Cfg=cfg
    local obj = UIUtil.GetChild("Article1", root)
    local articleobj = UIUtil.GetChild("ItemArticle", obj)

    CommonHelper:SetGameObjectActive("blank", obj, data == nil)
    CommonHelper:SetGameObjectActive("normal", obj, data ~= nil)
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        local flag=false
        for i = 1, #rewards do
            flag= PlayerDataManager:Get():CheckCurrencyEnough(rewards[i].propsid,rewards[i].propsnum,true)
            if flag==false then
                break
            end
        end
        if flag then
            ReformSubsystem:SendMsg_ReformReplace(self.Article:GetCellID(), self.Entry, self.IsUsePerfact)
        end
    end)


    self:SetArticleCost()
    self.BtnProb=CommonHelper:HButtonSetCallback("BtnProb",root,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.ReformProb,nil,HelpStyleType.BlueStyle)
    end)
    CommonHelper:SetHButtonClick(self.BtnProb,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnProb),true)
    self:AutoSelect()

end

function PageGarageReformReplace:AutoSelect()
    self:OnClickTogPerfact(false)
end
function PageGarageReformReplace:UpdateMsg()
    self:SetArticleCost()
end
function PageGarageReformReplace:SetArticleCost()
    local data=self.data
    local cfg=self.Cfg
    local root=self.Root
    ---@type dictconsume_config_cell[]
    local rewards = CommonHelper:GetConsumeGroup(cfg.reformagain)
    local obj = UIUtil.GetChild("Article1", self.Root)
    local articleobj = UIUtil.GetChild("ItemArticle", obj)
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

    --}}}


    --{{{货币消耗
    CommonHelper:SetText("###costvalue", root, tostring(rewards[2].propsnum))
    --}}}



    --{{{完美材料
    if cfg then
        local perfactobj = UIUtil.GetChild("PerfactArticle", root)
        local param = Param_ItemArticleParam()
        param.count = KnapsackDataManager:Get():GetArticleCountByCfgid(cfg.perfectcost)
        CommonHelper:SetItemArticleGroup(perfactobj, UIModuleID.Garage, cfg.perfectcost, param,function(data)
            CommonHelper:ShowPartInfoByCfgId(data, UIModuleID.Garage,true)
        end,cfg.perfectcost)


        ---@type dictarticle_config_cell
        local tempcfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, cfg.perfectcost)
        CommonHelper:SetText("###perfactname", root, CommonHelper:GetTempStr_Default(tempcfg.name))
    end
    --}}}
end


function PageGarageReformReplace:OnClickTogPerfact(flag)
    if flag then
        ---@type dictpartsdevelop_config_cell
        local cfg = CommonHelper:GetDevelopByEntryId(self.Entry)
        local count = KnapsackDataManager:Get():GetArticleCountByCfgid(cfg.perfectcost)
        if count <= 0 then
            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.PartPerfactReformNotEnough))
            return
        end
    end

    self.IsUsePerfact = flag
    CommonHelper:SetToggleState(self.TogNotUse, not flag)
    CommonHelper:SetToggleState(self.TogUse, flag)
end