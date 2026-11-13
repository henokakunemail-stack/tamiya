


--车库左侧，改造

---@class PageRaceAssembleGarageReform
PageRaceAssembleGarageReform = class("PageRaceAssembleGarageReform")

function PageRaceAssembleGarageReform:initialize()
    self.SelectIdx = -1
    ---@type ArticleCell
    self.Article = nil
end


---@param article ArticleCell
function PageRaceAssembleGarageReform:SetData(root,article,OpenType, funcback, funreform, funstrong, funreplace,funstar)
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PartStrongStart)
    local deltaStart = tonumber(cfg.varval)

    cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PartStrongMax)
    local deltaMax = tonumber(cfg.varval)

    self.SelectIdx = -1
    self.Article = article
    self.OpenType=OpenType
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funcback then funcback() end
    end)

    self.BtnReform = CommonHelper:HButtonSetCallback("BtnReform",root,function (hbtn)
        if funreform then funreform(article, self.SelectIdx) end
    end)

    self.BtnStrong = CommonHelper:HButtonSetCallback("BtnStrong",root,function (hbtn)
        local data = article:GetPartReform(self.SelectIdx + 1)

        if data.lv + deltaStart <= PlayerDataManager:Get():GetPlayerLV() then
            if data.lv<deltaMax then
                if funstrong then funstrong(article, self.SelectIdx) end
            else
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ReformStrongMax))
            end

        else
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ReformStrongMax))
        end


    end)

    self.BtnReplace = CommonHelper:HButtonSetCallback("BtnReplace",root,function (hbtn)
        local data = article:GetPartReform(self.SelectIdx + 1)
        if data:IsQualityMax() then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ReformReplaceMax))
        else
            if funreplace then funreplace(article ,data.id) end
        end

    end)
    local templist = article:GetPartReformList()
    self:SetOpenIdx()
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #templist, 1,function(dataIndex, itemObj, scroll)
        self:SetReformItem(dataIndex, itemObj, scroll,deltaStart,deltaMax,funreform,funstar)
    end)



    self:UpdateBtnGroup()

end

function PageRaceAssembleGarageReform:SetReformItem(dataIndex, itemObj, scroll,deltaStart,deltaMax,funreform,funstar)
    local article=self.Article
    local data = article:GetPartReform(dataIndex + 1)

    local isopen = data:IsOpen(article:GetStar())
    local isblank = data:IsBlank(article:GetStar())
    local notblank = data:IsNotBlank(article:GetStar())
    CommonHelper:SetGameObjectActive("lock", itemObj,not isopen and self.OpenIdx~=dataIndex+1)
    local up= CommonHelper:SetGameObjectActive("up", itemObj,not isopen and self.OpenIdx==dataIndex+1)
    CommonHelper:SetGameObjectActive("blank", itemObj, isblank)
    CommonHelper:SetGameObjectActive("enable", itemObj, notblank)
    if not isopen and self.OpenIdx==dataIndex+1 then
        CommonHelper:SetGameObjectActive("canup", up, self.OpenIdxFlag)
        CommonHelper:SetGameObjectActive("uplock", up, not self.OpenIdxFlag)
    end
    CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
        local data = self.Article:GetPartReform(dataIndex + 1)
        if data:IsOpen(self.Article:GetStar()) and data:IsBlank(self.Article:GetStar()) then
            if funreform then funreform(self.Article, data:GetGroove()) end
        else
            if dataIndex+1==self.OpenIdx then
                if self.OpenIdxFlag then
                    if funstar then funstar(self.Article) end
                else
                    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictpartstar_config)
                    ---@type dictpartstar_config_cell
                    local partStar=cfg.GetCfgDataByIdAndStar(self.Article:GetPartBaseCfg().C_ID,self.Article:GetStar())
                    ---@type dictarticle_config_cell
                    local cfg1 = CommonHelper:GetTableDataByID(ConfigNames.article_config, partStar.specialid)
                    local cfg2 = CommonHelper:GetTableDataByID(ConfigNames.article_config, partStar.commonid)
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PropNoEnough, string.format("%s,%s",CommonHelper:GetTempStr_Default(cfg1.name),CommonHelper:GetTempStr_Default(cfg2.name))))
                    return
                end
            else
                if  self.SelectIdx == dataIndex then return end
                self.SelectIdx = dataIndex
                self:UpdateItemSelect(dataIndex,deltaStart,deltaMax,funreform)
                CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
                self:UpdateBtnGroup()
            end
        end
    end,dataIndex)

    local str = CommonHelper:GetTempStr_Default(TemplateStringID.ReformLockFormat, data.limit)
    CommonHelper:SetText("###locktips", itemObj, str)

    if data ~= nil and notblank then
        CommonHelper:HButtonSetCallback("BtnDetail",itemObj,function (hbtn)
            CommonHelper:ShowGarageTipsView(GarageTipsTpye.Reform, data.id)
        end)


        local cfg=CommonHelper:GetDevelopByEntryId(data.id)
        CommonHelper:SetText("###name", itemObj, ClientDataManager:Get():GetTemplateString(cfg.name))

        local tempvalue = PlayerDataManager:Get():GetPlayerLV() - deltaStart >0 and PlayerDataManager:Get():GetPlayerLV() - deltaStart+1 or 1
        if tempvalue > deltaMax then tempvalue = deltaMax end
        local str = CommonHelper:GetTempStr_Default(TemplateStringID.ReformLvFormat, data.lv,tempvalue)
        CommonHelper:SetText("###lv", itemObj, "lv:20")

        for i = 1, 3 do CommonHelper:SetGameObjectActive("quality"..i, itemObj, (data.quality) == i) end

        CommonHelper:SetGameObjectActive("strongenable", itemObj, data.lv < PlayerDataManager:Get():GetPlayerLV())
        CommonHelper:SetGameObjectActive("stronglock", itemObj, data.lv >= PlayerDataManager:Get():GetPlayerLV())

        local attrs = cfg.NewAttr
        table.sort(attrs,function(a,b) return a.increase > b.increase end)
        local flag = 0
        for i = 1, 3 do
            local data = attrs[i]
            local attrobj = CommonHelper:SetGameObjectActive("attr"..i, itemObj, data ~= nil)
            if data ~= nil then
                local state1 = CommonHelper:SetGameObjectActive("feature1", attrobj, data.increase == 1)
                local state2 = CommonHelper:SetGameObjectActive("feature2", attrobj, data.increase == -1)

                local tempobj = (data.increase == 1) and state1 or state2
                CommonHelper:SetGameObjectActive("flag", tempobj, flag ~= data.increase)
                if flag ~= data.increase then flag = data.increase end

                CommonHelper:SetText("###name", tempobj, CommonHelper:GetAttrName(data.type))

                for i = 1, 3 do CommonHelper:SetGameObjectActive("featurelv"..i, tempobj, data.featurelv == i) end
            end
        end


    end
    local BtnDel= CommonHelper:HButtonSetCallback("BtnDel",itemObj,function (hbtn)
        local data = self.Article:GetPartReform(self.SelectIdx + 1)
        if  self.OpenType==AssembleGarageOpenType.RaceAssemble then
            RaceAssembleSubsystem:Get():SendMsg_RaceAssembleReformDel(self.Article:GetCellID(), data.id,3)
        end
        if  self.OpenType==AssembleGarageOpenType.RaceAssembleAdd then
            RaceAssembleSubsystem:Get():SendMsg_RaceAssembleReformDel(self.Article:GetCellID(), data.id,4)
        end

    end,data.id)
    CommonHelper:SetHButtonClick(BtnDel, self.SelectIdx == dataIndex and isopen and notblank, true)
    CommonHelper:SetGameObjectActive("select", itemObj, self.SelectIdx == dataIndex)
end

function PageRaceAssembleGarageReform:UpdateBtnGroup()
    local data = self.Article:GetPartReform(self.SelectIdx + 1)
    local isopen = data and data:IsOpen(self.Article:GetStar())
    local isblank = data and data:IsBlank(self.Article:GetStar())
    local notblank = data and data:IsNotBlank(self.Article:GetStar())
    CommonHelper:SetHButtonClick(self.BtnReform, isopen and isblank, true)
    CommonHelper:SetHButtonClick(self.BtnStrong, false, true)
    --CommonHelper:SetHButtonClick(self.BtnDel, isopen and notblank, true)
    CommonHelper:SetHButtonClick(self.BtnReplace, false, true)
end
function PageRaceAssembleGarageReform:UpdateItemSelect(index,deltaStart,deltaMax,funreform)
    self.deltaStart=deltaStart
    self.deltaMax=deltaMax
    self.funreform=funreform
end

function PageRaceAssembleGarageReform:UpdateMsg()
    self:SetOpenIdx()
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
    self:UpdateItemSelect(self.SelectIdx,self.deltaStart,self.deltaMax,self.funreform)
    self:UpdateBtnGroup()
end
function PageRaceAssembleGarageReform:SetOpenIdx()
    local templist = self.Article:GetPartReformList()
    self.OpenIdx=0
    for i = 1, #templist do
        if not templist[i]:IsOpen(self.Article:GetStar()) then
            self.OpenIdx=i
            break
        end
    end
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictpartstar_config)
    ---@type dictpartstar_config_cell
    local partStar=cfg.GetCfgDataByIdAndStar(self.Article:GetPartBaseCfg().C_ID,self.Article:GetStar())
    self.OpenIdxFlag=(PlayerDataManager:Get():CheckCurrencyEnough(partStar.specialid,partStar.paynum,false) or  PlayerDataManager:Get():CheckCurrencyEnough(partStar.commonid,partStar.commonnum,false)) and ((KnapsackDataManager:Get():GetArticleCountByCfgid(partStar.specialid)+KnapsackDataManager:Get():GetArticleCountByCfgid(partStar.commonid))>=partStar.paynum)
end
