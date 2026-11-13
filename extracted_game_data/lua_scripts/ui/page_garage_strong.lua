

--车库右侧，涂装入口

---@class PageGarageStrong
PageGarageStrong = class("PageGarageStrong")

function PageGarageStrong:initialize()
    ---@type ArticleCell
    self.Article = nil
    self.ReformIdx = -1
    ---@type PartReformData
    self.ReformData = nil
    self.Root = nil
end

---@param data ArticleCell
function PageGarageStrong:SetData(root, data, idx, funback)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)

    self.Article = data
    self.ReformIdx = idx
    self.ReformData = data:GetPartReform(idx + 1)
    self.Root = root

    CommonHelper:HButtonSetCallback("BtnAdd1",root,function (hbtn)
        self:OnClickBtn_Count(self.AddNum + 1)
    end)
    CommonHelper:HButtonSetCallback("BtnJian1",root,function (hbtn)
        self:OnClickBtn_Count(self.AddNum - 1)
    end)
    CommonHelper:HButtonSetCallback("BtnMax1",root,function (hbtn)
        self:OnClickBtn_Count(self.AddMax)
    end)

    self:CalculateMax()

    self:AutoSelect()
end

function PageGarageStrong:AutoSelect()
    self:OnClickBtn_Count(1)
end
function PageGarageStrong:UpdateMsg()
    self:OnClickBtn_Count(self.AddNum)
end


function PageGarageStrong:SetAttrs()
    -----@type partreformentry_config_cell
    --local temp = CommonHelper:GetTableDataByID(ConfigNames.partreformentry_config, self.ReformData.id)
    --local attrs = temp.NewAttr
    --for i = 1, 4 do
    --    local data = attrs[i]
    --    local obj = CommonHelper:SetGameObjectActive("attr"..i, self.Root, data ~= nil)
    --    if data then
    --
    --
    --
    --        --local reformid = self.ReformData.id
    --        --local articleid = self.Article:GetArticleID()
    --        --local qyality = self.ReformData.quality + 1
    --        --local value = CommonHelper:GetReformAttrValue(data, reformid, articleid, qyality, self.ReformData.lv)
    --        --local valuenew = CommonHelper:GetReformAttrValue(data, reformid, articleid, qyality, self.ReformData.lv + self.AddNum)
    --        --local difference=tonumber(valuenew)-tonumber(value)
    --
    --
    --
    --        --local str = TemplateStringID.PartReformSucceedAddFormat
    --        --if difference < 0 then
    --        --    str = TemplateStringID.PartReformSucceedSubtractFormat
    --        --end
    --        --CommonHelper:SetText("###valuedelta", obj,CommonHelper:GetTempStr_Default(str,CommonHelper:GetAttrShowValue(data.type, difference)))
    --
    --    end
    --end
end

function PageGarageStrong:SetCost()
    ---@type dictpartsdevelop_config_cell
    local cfg = ClientDataManager:GetDataTable(ConfigNames.dictpartsdevelop_config)
    local cost= cfg.GetDevelopLvPartByEntryId(self.ReformData.id,self.ReformData.lv)
    ---@type dictconsume_config_cell[]
    cost=CommonHelper:GetConsumeGroup(cost.PartGroup)

    local costvalue = self:CalculateCost()
    CommonHelper:HButtonSetCallback("BtnSure",self.Root,function (hbtn)
        local flag=false
        for i = 1, #cost do
            flag= PlayerDataManager:Get():CheckCurrencyEnough(cost[i].propsid,costvalue[i],true)
            if flag==false then
                break
            end
        end
        if flag then
            ReformSubsystem:Get():SendMsg_ReformLv(self.Article:GetCellID(), self.ReformData.id, self.ReformData.lv + self.AddNum)
        end
    end)
    for i = 2, 4 do
        local article =cost[i]
        local costmax = costvalue[i]
        local obj = UIUtil.GetChild("ItemArticleStrong"..i-1, self.Root)
        local articleobj = UIUtil.GetChild("ItemArticle", obj)


        local temp = (article ~= nil and costmax > 0)
        CommonHelper:SetGameObjectActive("blank", obj, not temp)
        CommonHelper:SetGameObjectActive("normal", obj, temp)


        if temp then
            local cur = KnapsackDataManager:Get():GetArticleCountByCfgid(article.propsid)
            ---@type dictarticle_config_cell
            local articlecfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, article.propsid)

            --{{{名字
            CommonHelper:SetText("###articlename", obj, CommonHelper:GetTempStr_Default(articlecfg.name))
            --}}}

            --{{{描述
            CommonHelper:SetText("###articledes", obj, CommonHelper:GetTempStr_Default(articlecfg.description))
            --}}}

            --{{{数量
            local tempstr = ""
            if cur >= costmax then
                tempstr = CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountFormatGreen, cur, costmax)
            else
                tempstr = CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountFormatRed, cur, costmax)
            end
            CommonHelper:SetText("###articlecount", obj, tempstr)
            --}}}

            --{{{item
            CommonHelper:SetItemArticleGroup(articleobj, UIModuleID.Garage, article.propsid,nil,function(data)
                CommonHelper:ShowPartInfoByCfgId(data, UIModuleID.Garage,true)
            end,article.propsid)
            --}}}

        end
    end

    CommonHelper:SetText("###costvalue", self.Root,costvalue[1])
end







function PageGarageStrong:OnClickBtn_Count(value)
    if value > self.AddMax then value = self.AddMax end
    if value < 1 then value = 1 end
    self.AddNum = value

    self:SetAttrs()
    self:SetCost()

    CommonHelper:SetText("InputCount/###Text", self.Root, tostring(self.AddNum))
end

function PageGarageStrong:CalculateMax()
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PartStrongMax)
    local deltaMax = tonumber(cfg.varval)
    cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PartStrongStart)
    local deltaMin = tonumber(cfg.varval)

    ---@type dictpartsdevelop_config_cell
    local cfg = ClientDataManager:GetDataTable(ConfigNames.dictpartsdevelop_config)
    local cost= cfg.GetDevelopLvPartByEntryId(self.ReformData.id,self.ReformData.lv)
    ---@type dictconsume_config_cell[]
    cost=CommonHelper:GetConsumeGroup(cost.PartGroup)
    local cost1 = KnapsackDataManager:Get():GetArticleCountByCfgid(cost[1].propsid)
    local cost2 = KnapsackDataManager:Get():GetArticleCountByCfgid(cost[2].propsid)
    local cost3 = KnapsackDataManager:Get():GetArticleCountByCfgid(cost[3].propsid)
    local tempcost1 = 0
    local tempcost2 = 0
    local tempcost3 = 0


    self.AddMax = 0
    for i = self.ReformData.lv+1 , #cfg.GetDevelopByEntryId(self.ReformData.id).NewStrong do
        local cost= cfg.GetDevelopLvPartByEntryId(self.ReformData.id,i)
        ---@type dictconsume_config_cell[]
        cost=CommonHelper:GetConsumeGroup(cost.PartGroup)
        tempcost1 = tempcost1 + cost[1].propsnum
        tempcost2 = tempcost2 + cost[2].propsnum
        tempcost3 = tempcost3 + cost[3].propsnum
        if tempcost1 > cost1 then break end
        if tempcost2 > cost2 then break end
        if tempcost3 > cost3 then break end
        self.AddMax = self.AddMax + 1
    end

    if PlayerDataManager:Get():GetPlayerLV() > (deltaMax + deltaMin) then
        deltaMax = deltaMax
    else
        deltaMax = PlayerDataManager:Get():GetPlayerLV() - deltaMin+1
    end
    local leave = deltaMax - self.ReformData.lv
    if self.AddMax > leave then self.AddMax = leave end

    if self.AddMax == 0 then self.AddMax = 1 end
end

function PageGarageStrong:CalculateCost()
    local result = {0, 0, 0, 0}


    ---@type dictpartsdevelop_config_cell
    local cfg = ClientDataManager:GetDataTable(ConfigNames.dictpartsdevelop_config)

    local startlv = self.ReformData.lv
    local endlv = self.ReformData.lv + self.AddNum-1



    for i = startlv, endlv do
        local cost= cfg.GetDevelopLvPartByEntryId(self.ReformData.id,i)
        ---@type dictconsume_config_cell[]
        cost=CommonHelper:GetConsumeGroup(cost.PartGroup)
        if cost then
            for j = 1, #cost do
                result[j] = result[j] + cost[j].propsnum
            end
        end
    end

    return result
end