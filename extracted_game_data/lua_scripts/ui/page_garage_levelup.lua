

--车库右侧，

---@class PageGarageLevelup
PageGarageLevelup = class("PageGarageLevelup")

function PageGarageLevelup:initialize()
    ---@type ArticleCell
    self.Article = nil
    self.Root = nil
    self.AddNum = 0
    self.AddMax = 0
end

---@param data ArticleCell
function PageGarageLevelup:SetData(root, data, funback)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)

    self.Article = data
    self.Root = root
    self.AddNum = 0
    self.AddMax = 0

    self:CalculateMax()

    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        ReformSubsystem:SendMsg_PartLevelUp(self.Article:GetCellID(), self.Article:GetPartLV() + self.AddNum)
    end)
    CommonHelper:HButtonSetCallback("BtnAdd1",root,function (hbtn)
        self:OnClickBtn_Count(self.AddNum + 1)
    end)
    CommonHelper:HButtonSetCallback("BtnJian1",root,function (hbtn)
        self:OnClickBtn_Count(self.AddNum - 1)
    end)
    CommonHelper:HButtonSetCallback("BtnMax1",root,function (hbtn)
        self:OnClickBtn_Count(self.AddMax)
    end)


    --{{{ item
    self:SetItemPart()
    --}}}

    self:AutoSelect()
end

function PageGarageLevelup:SetItemPart()
    --{{{ item
    local partobj = UIUtil.GetChild("ItemPart", self.Root)
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
    CommonHelper:SetText("###partname", self.Root,  CommonHelper:GetTempStr_Default(self.Article:GetPartConfig().partname))
    --}}}
end

function PageGarageLevelup:AutoSelect()
    self:OnClickBtn_Count(1)
end

function PageGarageLevelup:SetLV()
    --{{{ 等级变化
    local str1 = CommonHelper:GetTempStr_Default(TemplateStringID.PartLevelUpLVFormat,self.Article:GetPartLV())
    local str2 = CommonHelper:GetTempStr_Default(TemplateStringID.PartLevelUpLVFormat,self.Article:GetPartLV() + self.AddNum)
    CommonHelper:SetText("###oldlv",self.Root,str1)
    CommonHelper:SetText("###newlv",self.Root,str2)
    --}}}
end

function PageGarageLevelup:SetAttrs()
    local attrs = self.Article:GetPartSecondAttrs()
    --{{{ 属性变化
    for i = 1, 8 do
        local data = attrs[i]
        local obj = UIUtil.GetChild("attr"..i, self.Root)
        CommonHelper:SetGameObjectActive("valuegroup", obj, data ~= nil and data.levelupCfg)
        if data and data.levelupCfg then
            CommonHelper:SetText("###name", obj, CommonHelper:GetAttrName(data.type))
            local cur = CommonHelper:GetAttrValue(data.type, data.value)
            local new = CommonHelper:GetAttrValue(data.type, self:CalculateNewAttr(data))
            local delta = tonumber(new) - tonumber(cur)
            CommonHelper:SetText("###cur", obj, cur)
            CommonHelper:SetText("###new", obj, new)

            local str = TemplateStringID.PartLevelUpAttrDeltaGreen
            if delta < 0 then
                str = TemplateStringID.PartLevelUpAttrDeltaRed
            end
            str = CommonHelper:GetTempStr_Default(str,CommonHelper:GetAttrShowValue(data.type, delta))

            CommonHelper:SetText("###delta", obj, str)
        end
    end
    --}}}

end

function PageGarageLevelup:SetCost()
    --{{{ 消耗
    local curlv = self.Article:GetPartLV()
    local costgold = 0
    for i = curlv, curlv + self.AddNum-1 do
        ---@type partlevel_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.partlevel_config, i)
        costgold = costgold + cfg.goldcost
    end
    CommonHelper:SetText("###costvalue", self.Root, tostring(costgold))
    --}}}
end

---@param attr PartAttrData
function PageGarageLevelup:CalculateNewAttr(attr)
    local curcfg = CommonHelper:GetTableDataByID(ConfigNames.partlevel_config, self.Article:GetPartLV())
    ---@type dictpartlevel_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.partlevel_config, self.Article:GetPartLV() + self.AddNum)
    local deltavalue =  attr.value + attr.levelupCfg.value * (cfg.changeval-curcfg.changeval)
    return deltavalue
end

function PageGarageLevelup:OnClickBtn_Count(value)
    if value > self.AddMax then value = self.AddMax end
    if value < 1 then value = 1 end
    self.AddNum = value

    self:SetLV()
    self:SetAttrs()
    self:SetCost()

    CommonHelper:SetText("InputCount/###Text", self.Root, tostring(self.AddNum))
end

function PageGarageLevelup:CalculateMax()
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PartLevelMax)
    local maxlv = tonumber(cfg.varval)
    local playerlv = PlayerDataManager:Get():GetPlayerLV()
    if playerlv > maxlv then playerlv = maxlv end

    local curlv = self.Article:GetPartLV()
    local curgold = PlayerDataManager:Get():GetCurrency(CurrencyType.Gold)
    local costgold = 0
    self.AddMax = 0
    for i = curlv + 1, playerlv do
        ---@type partlevel_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.partlevel_config, i)
        costgold = costgold + cfg.goldcost
        if costgold <= curgold then
            self.AddMax = self.AddMax + 1
        end
    end
    if self.AddMax == 0 then self.AddMax = 1 end
end

function PageGarageLevelup:UpdateMsg()
    self:OnClickBtn_Count(self.AddNum)
end