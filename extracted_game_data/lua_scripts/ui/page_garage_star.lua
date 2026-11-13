


--车库左侧，进化

---@class PageGarageStar
PageGarageStar = class("PageGarageStar")

function PageGarageStar:initialize()
    self.CostFlag = -1
end

---@param article ArticleCell
function PageGarageStar:SetData(root,article, funcback)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funcback then funcback() end
    end)
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictpartstar_config)
    ---@type dictpartstar_config_cell
    local partStar=cfg.GetCfgDataByIdAndStar(article:GetPartBaseCfg().C_ID,article:GetStar())
    cfg.articles={}
    table.insert(cfg.articles,partStar.specialid)
    table.insert(cfg.articles,partStar.commonid)
    cfg.counts={}
    table.insert(cfg.counts,partStar.paynum)
    table.insert(cfg.counts,partStar.commonnum)
    self.Cfg=cfg
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if PlayerDataManager:Get():CheckCurrencyEnough(CurrencyType.Gold,partStar.goldpay) then
            if (PlayerDataManager:Get():CheckCurrencyEnough(partStar.specialid,partStar.paynum,false) or  PlayerDataManager:Get():CheckCurrencyEnough(partStar.commonid,partStar.commonnum,false))==false and ((KnapsackDataManager:Get():GetArticleCountByCfgid(partStar.specialid)+KnapsackDataManager:Get():GetArticleCountByCfgid(partStar.commonid))>=partStar.paynum)==false then
                ---@type dictarticle_config_cell
                local cfg1 = CommonHelper:GetTableDataByID(ConfigNames.article_config, partStar.specialid)
                local cfg2 = CommonHelper:GetTableDataByID(ConfigNames.article_config, partStar.commonid)
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PropNoEnough, string.format("%s,%s",CommonHelper:GetTempStr_Default(cfg1.name),CommonHelper:GetTempStr_Default(cfg2.name))))
                return
            end
            if PlayerDataManager:Get():CheckCurrencyEnough(CurrencyType.Gold,partStar.goldpay) then
                if PlayerDataManager:Get():CheckCurrencyEnough(partStar.specialid,partStar.paynum,false)==false then
                    local boxfunc = function()
                        local cfg2 = CommonHelper:GetTableDataByID(ConfigNames.article_config, partStar.commonid)
                        local text = CommonHelper:GetTempStr_Default(TemplateStringID.PartStarCostCommonArticle,CommonHelper:GetTempStr_Default(cfg2.name))
                        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, text,CommonHelper:GetTempStr_Default(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
                        if ret == MessageBoxHelp.BtnType.OK then
                            if PlayerDataManager:Get():CheckCurrencyEnough(partStar.specialid,partStar.paynum,false) or  PlayerDataManager:Get():CheckCurrencyEnough(partStar.commonid,partStar.commonnum,false) then
                                ReformSubsystem:Get():SendMsg_PartStarUp(article:GetCellID())
                                return
                            end
                            if (KnapsackDataManager:Get():GetArticleCountByCfgid(partStar.specialid)+KnapsackDataManager:Get():GetArticleCountByCfgid(partStar.commonid))>=partStar.paynum then
                                ReformSubsystem:Get():SendMsg_PartStarUp(article:GetCellID())
                                return
                            end
                            ---@type dictarticle_config_cell
                            local cfg1 = CommonHelper:GetTableDataByID(ConfigNames.article_config, partStar.specialid)
                            local cfg2 = CommonHelper:GetTableDataByID(ConfigNames.article_config, partStar.commonid)
                            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PropNoEnough, string.format("%s,%s",CommonHelper:GetTempStr_Default(cfg1.name),CommonHelper:GetTempStr_Default(cfg2.name))))
                        end
                    end
                    MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
                else
                    ReformSubsystem:Get():SendMsg_PartStarUp(article:GetCellID())
                    return
                end
            end
        end

    end)





    --{{{特性
    ---@type sign_config_cell
    local signcfg = CommonHelper:GetTableDataByID(ConfigNames.sign_config, article:GetPartConfig().sign)
    CommonHelper:SetText("###featurename", root, CommonHelper:GetTempStr_Default(signcfg.name))

    CommonHelper:GetComponentSetImage("featureicon", root, CommonHelper:GetTrackFeatureIcon(article:GetPartConfig().sign), UIModuleID.Garage)
    --}}}


    --{{{设置配件icon
    CommonHelper:GetComponentSetUITexture("particon", root, article:GetPartConfig().icon, UIModuleID.Garage)
    --}}}


    --{{{设置配件名字
    CommonHelper:SetText("###partname", root, CommonHelper:GetTempStr_Default(article:GetPartConfig().partname))
    --}}}


    --{{{星级变化
    local starmax = article:GetPartBaseCfg().maxstar
    CommonHelper:SetPartStar("PartStarLeft",root,article:GetStar(),starmax)
    CommonHelper:SetPartStar("PartStarRight",root,article:GetStar() + 1,starmax)
    CommonHelper:SetPartStar("PartStarLeftAwake",root,article:GetStar(),starmax)
    CommonHelper:SetPartStar("PartStarRightAwake",root,article:GetStar() + 1,starmax)
    CommonHelper:SetGameObjectActive("PartStarLeft",root,not article:GetAwaken())
    CommonHelper:SetGameObjectActive("PartStarRight",root,not article:GetAwaken())
    CommonHelper:SetGameObjectActive("PartStarLeftAwake",root,article:GetAwaken())
    CommonHelper:SetGameObjectActive("PartStarRightAwake",root,article:GetAwaken())
    --}}}


    --{{{属性变化
    CommonHelper:SetText("###valueold", root, tostring(article:GetPartReformPosCount(article:GetStar())))
    CommonHelper:SetText("###valuenew", root, tostring(article:GetPartReformPosCount(article:GetStar() + 1)))





    --{{{材料消耗

   self.root=root
   self:SetArticleCost()

    --}}}
    --{{{金币消耗
    CommonHelper:SetText("###costvalue", root, tostring(partStar.goldpay))
    --}}}

end
function PageGarageStar:SetArticleCost()
    for i = 1, 2 do
        local obj = UIUtil.GetChild("Article"..i, self.root)
        local articleobj = UIUtil.GetChild("ItemArticle", obj)
        local articleid = self.Cfg.articles[i]
        local count = self.Cfg.counts[i]
        local cur = KnapsackDataManager:Get():GetArticleCountByCfgid(articleid)


        if articleid then
            ---@type dictarticle_config_cell
            local cfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, articleid)
            CommonHelper:SetText("###articlename", obj, CommonHelper:GetTempStr_Default(cfg.name))


            local tempstr = ""
            if cur >= count then
                tempstr = CommonHelper:GetTempStr_Default(TemplateStringID.PartStarCostFormatGreen, cur)
            else
                tempstr = CommonHelper:GetTempStr_Default(TemplateStringID.PartStarCostFormatRed, cur)
            end
            CommonHelper:SetText("###cost", obj, tempstr)



            local param = Param_ItemArticleParam()
            param.count = count
            CommonHelper:SetItemArticleGroup(articleobj, UIModuleID.Garage, articleid, param,function(data)
                CommonHelper:ShowPartInfoByCfgId(data, UIModuleID.Garage,true)
            end,articleid)
        end
    end
end
function PageGarageStar:OnClickArticle(param)
    local idx = param[1]
    local articleid = param[2]

    self.CostFlag = articleid
end
function PageGarageStar:UpdateMsg()
    self:SetArticleCost()
end