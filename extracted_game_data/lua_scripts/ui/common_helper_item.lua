






---@class Param_ItemPartParam
Param_ItemPartParam = class("Param_ItemPartParam")

function Param_ItemPartParam:initialize()
    self.quality = nil
    self.star = nil
    self.lv = nil
    self.using = nil
    self.lock = nil
    self.time=nil
    self.awaken=nil
    self.generation = nil
    self.downType = nil
    self.source = nil
    self.ShowFx = false
    self.expireTime =0
end
local _PartMaxAge={}
_PartMaxAge[1]=1
_PartMaxAge[2]=1
_PartMaxAge[3]=1
_PartMaxAge[4]=2
_PartMaxAge[5]=4
_PartMaxAge[6]=4

---@param param Param_ItemPartParam
---@param uiType ItemPartUIType
function CommonHelper:SetItemPartGroup(gameObject, moduleId, cfgId, uiType, param, func, clickparam)
    if uiType == nil then uiType = ItemPartUIType.Simple end


    local moduleid = moduleId   --功能模块id，必填
    local cfgid = cfgId         --配置id，必填
    local uitype = uiType       --ui排版样式，必填

    local icon = ""
    local name = ""
    local quality = -1
    local star = -1
    local starmax = -1
    local lv = -1
    local flag = -1
    local using = -1
    local lock = false
    local other =false
    local time=false
    local awaken = false
    local generation=-1
    local source=-1
    local expire=false


    ---@type dictparts_config_cell
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config,cfgid)
    ---@type dictpartbase_config_cell
    local partBaseCfg = CommonHelper:GetPartBaseCfg(cfgid)
    if partCfg then
        icon = partCfg.icon

        name = CommonHelper:GetTempStr_Default(partCfg.partname)
        quality = partBaseCfg.fabric
        star = 1
        starmax = partBaseCfg.maxstar
        lv = 1
        flag = partCfg.sign
        using = -1
        lock = false
        generation=1
        awaken=false
        time=false
        other=PartDownType.Self
        source=PartSourceType.Self
        expire=false
        if param then
            if param.quality then quality = param.quality end
            if param.lv then lv = param.lv end
            if param.star then star = param.star end
            if param.using then using = param.using end
            if param.downType then other=param.downType end
            if param.lock then lock = param.lock>0  end
            if param.awaken then awaken = param.awaken end
            if param.generation then generation = param.generation end
            if param.source then source = param.source
            end
            if param.expireTime and param.expireTime ~=0 then expire=CommonHelper:GetNowTime()>param.expireTime
            end
        end

        if generation and generation>1 then
            if generation==2 then
                icon= partCfg.icon2
            end
            if generation==3 then
                icon= partCfg.icon3
            end
            if generation==4 then
                icon= partCfg.icon4
            end
        end
    else
        logError("没有改物品--->>>>>",cfgid)
        return
    end

    CommonHelper:SetGameObjectActive("Kuang_Fx_3",gameObject,quality==3 and moduleid~=UIModuleID.Bag and moduleid~=UIModuleID.Garage and moduleid~=UIModuleID.Bag )
    CommonHelper:SetGameObjectActive("Kuang_Fx_4",gameObject,quality==4 and moduleid~=UIModuleID.Bag and moduleid~=UIModuleID.Garage and moduleid~=UIModuleID.Bag )
    CommonHelper:SetGameObjectActive("Kuang_Fx_5",gameObject, quality==5 and moduleid~=UIModuleID.Bag and moduleid~=UIModuleID.Garage and moduleid~=UIModuleID.Bag)

    --设置ui排版
    CommonHelper:SetGameObjectActive("groupNormal",gameObject, uitype == ItemPartUIType.Normal)
    CommonHelper:SetGameObjectActive("groupName",gameObject, uitype == ItemPartUIType.Name)
    CommonHelper:SetGameObjectActive("PartStarAwake",gameObject, awaken)
    CommonHelper:SetGameObjectActive("PartStar",gameObject, not awaken)

    --设置配件icon
    CommonHelper:GetComponentSetUITexture("icon", gameObject, icon, moduleid)

    --设置配件名字
    CommonHelper:SetText("###name",gameObject,name)

    --设置配件品质
    for i = 1, 6 do
        for j = 1, _PartMaxAge[i] do
            CommonHelper:SetGameObjectActive(string.format("quality%d_%d",i,j), gameObject, quality == i and generation==j)
        end
    end

    --设置配件星级
    CommonHelper:SetPartStar("PartStar",gameObject,star,starmax)

    CommonHelper:SetPartStar("PartStarAwake",gameObject,star,starmax)

    --设置配件等级
    CommonHelper:SetText("###lv",gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.ItemPartLvFormat,lv))

    --设置配件特征角标icon
    CommonHelper:GetComponentSetImage("flag", gameObject, CommonHelper:GetTrackFeatureIcon(flag), moduleid)

    --设置配件所属车位
    for i = 0, 4 do CommonHelper:SetGameObjectActive(string.format("caridx%d",i), gameObject, using == i+1) end

    --设置配件锁
    CommonHelper:SetGameObjectActive("lock", gameObject, other==PartDownType.Self and lock)
    CommonHelper:SetGameObjectActive("time", gameObject, other~=PartDownType.Self and source==PartSourceType.System )
    CommonHelper:SetGameObjectActive("lease", gameObject, other==PartDownType.Lease )
    CommonHelper:SetGameObjectActive("lease/expire", gameObject, other==PartDownType.Lease and expire )
    CommonHelper:SetGameObjectActive("hire", gameObject, other==PartDownType.Hire )
    CommonHelper:SetGameObjectActive("hire/expire", gameObject, other==PartDownType.Hire and expire )

    --设置配件点击事件
    local btn = CommonHelper:HButtonSetCallback("ItemBtn",gameObject,function (hbtn)
        if func then func(clickparam) end
    end)
    CommonHelper:SetHButtonClick(btn, (func ~= nil), true)

    --设置配件所属车位
    for i = 1, 4 do
        CommonHelper:SetGameObjectActive(string.format("generation_%d",i), gameObject, generation and generation == i and _PartMaxAge[quality]>1)
        CommonHelper:SetGameObjectActive(string.format("border_%d",i), gameObject, generation and generation == i)
    end


end
















---@class Param_ItemArticleParam
Param_ItemArticleParam = class("Param_ItemArticleParam")

function Param_ItemArticleParam:initialize()
    self.count = nil
    self.probability = nil
end


---@param param Param_ItemArticleParam
function CommonHelper:SetItemArticleGroup(gameObject, moduleId, cfgId, param, func, clickparam)
    local moduleid = moduleId   --功能模块id，必填
    local cfgid = cfgId         --配置id，必填


    local icon = ""
    local quality = -1
    local name = ""

    local count = ""
    local season=""
    local typeimageName=""
    ---@type article_config_cell
    local articleCfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, cfgid)
    if articleCfg then
        icon = articleCfg.NewIcon
        name = CommonHelper:GetTempStr_Default(articleCfg.name)
        quality = articleCfg.propsgrade
        count = ""
        ---@type dictexhibit_config_cell
        local exhibitCfg= CommonHelper:GetTableDataByID(ConfigNames.dictexhibit_config,  articleCfg.propsadd)
        if exhibitCfg and exhibitCfg.type==ExhibitType.Trophy then
            if tonumber( exhibitCfg.params)>0 then
                season="s"..exhibitCfg.params
            end
        end
        if param then
            if param.count then count = CommonHelper:GetTempStr_Default(TemplateStringID.ArticleCountFormat, param.count) end
            if param.probability then count = CommonHelper:GetTempStr_Default(TemplateStringID.ArticleProbabilityFormat, param.probability) end
        end
        typeimageName= CommonHelper:GetArticleTypeImage(articleCfg.propstype,articleCfg.subtype)

    else
        logError("没有改物品--->>>>>",cfgid)
        return
    end

    CommonHelper:SetGameObjectActive("artilcetype",gameObject, not CommonHelper:IsNullOrEmpty(typeimageName))
    if not CommonHelper:IsNullOrEmpty(typeimageName) then
        CommonHelper:GetComponentSetImage("artilcetype",gameObject,typeimageName,moduleId)
    end

    --设置物品icon
    CommonHelper:GetComponentSetUITexture("icon", gameObject, icon, moduleid)

    --设置物品名字
    CommonHelper:SetText("###name",gameObject,name)

    --设置物品品质
    for i = 1, 6 do CommonHelper:SetGameObjectActive(string.format("quality%d",i), gameObject, quality == i) end
    --设置物品数量
    CommonHelper:SetText("###count",gameObject,count)

    --设置物品点击事件
    local btn = CommonHelper:HButtonSetCallback("ItemBtn",gameObject,function (hbtn)
        if func then func(clickparam) end
    end)
    CommonHelper:SetHButtonClick(btn, (func ~= nil), true)

    ---
    CommonHelper:SetText("###seasonnum",gameObject,season)


end

---@class Param_ItemTrackSegmentParam
Param_ItemTrackSegmentParam = class("Param_ItemTrackSegmentParam")

function Param_ItemTrackSegmentParam:initialize()
    self.count = nil
end


---@param param Param_ItemTrackSegmentParam
function CommonHelper:SetItemTrackSegmentGroup(gameObject, moduleId, cfgId, param, func, clickparam)
    local moduleid = moduleId   --功能模块id，必填
    local cfgid = cfgId         --配置id，必填


    local icon = ""
    local quality = -1
    local name = ""

    local count = ""


    ---@type tracksegement_config_cell
    local tracksegement_config = CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config, cfgid)
    if tracksegement_config then
        icon = tracksegement_config.icon
        name = CommonHelper:GetTempStr_Default(tracksegement_config.name)
        quality = 2
        count = ""
        if param then
            if param.count then count = CommonHelper:GetTempStr_Default(TemplateStringID.ArticleCountFormat, param.count) end
        end
    else
        logError("没有改物品--->>>>>",cfgid)
        return
    end



    --设置物品icon
    CommonHelper:GetComponentSetUITexture("icon", gameObject, icon, moduleid)

    --设置物品名字
    CommonHelper:SetText("###name",gameObject,name)
    CommonHelper:SetGameObjectActive("left",gameObject,tracksegement_config.direction==1)
    CommonHelper:SetGameObjectActive("right",gameObject,tracksegement_config.direction==2)
    --设置物品品质
    for i = 1, 6 do CommonHelper:SetGameObjectActive(string.format("quality%d",i), gameObject, quality == i) end

    --设置物品数量
    CommonHelper:SetText("###count",gameObject,count)

    --设置物品点击事件
    local btn = CommonHelper:HButtonSetCallback("ItemBtn",gameObject,function (hbtn)
        if func then func(clickparam) end
    end)
    CommonHelper:SetHButtonClick(btn, (func ~= nil), true)

end



function CommonHelper:SetItemCurrencyGroup(gameObject, moduleId, cfgId, num, func, clickparam)
    local moduleid = moduleId   --功能模块id，必填
    local cfgid = cfgId         --配置id，必填


    local icon = ""
    local quality = -1
    local name = ""
    local count = ""


    ---@type currency_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.currency_config, cfgid)
    if cfg then
        icon = cfg.NewIcon
        name = CommonHelper:GetTempStr_Default(cfg.name)
        quality = cfg.quality
        count = num and CommonHelper:GetTempStr_Default(TemplateStringID.ArticleCountFormat, num) or ""
    end



    --设置物品icon
    CommonHelper:GetComponentSetUITexture("icon", gameObject, icon, moduleid)

    --设置物品名字
    CommonHelper:SetText("###name",gameObject,name)

    --设置物品品质
    for i = 1, 6 do CommonHelper:SetGameObjectActive(string.format("quality%d",i), gameObject, quality == i) end

    --设置物品数量
    CommonHelper:SetText("###count",gameObject,count)

    --设置物品点击事件
    local btn = CommonHelper:HButtonSetCallback("ItemBtn",gameObject,function (hbtn)
        if func then func(clickparam) end
    end)
    CommonHelper:SetHButtonClick(btn, (func ~= nil), true)

end





---@param articleparam Param_ItemArticleParam
function CommonHelper:SetItemComGroup(gameObject, moduleId, cfgId, articleparam, func, clickparam,uiType)
    local propType,cfg= CommonHelper:GetPropTypeById(cfgId)
    local partobj =  CommonHelper:SetGameObjectActive("PartItem",gameObject,propType==PropType.Part)
    local articleobj = CommonHelper:SetGameObjectActive("ArticleItem",gameObject,propType==PropType.Article)
    local trackobj = CommonHelper:SetGameObjectActive("TrackSegmentItem",gameObject,propType==PropType.TracKSegment)
    if propType==PropType.Part then
        CommonHelper:SetItemPartGroup(partobj, moduleId, cfgId, uiType, articleparam, func, clickparam)
        return
    end
    if propType==PropType.Article then
        CommonHelper:SetItemArticleGroup(articleobj, moduleId, cfgId, articleparam, func, clickparam)
        return
    end
    if propType==PropType.TracKSegment then
        CommonHelper:SetItemTrackSegmentGroup(trackobj, moduleId, cfgId, articleparam, func, clickparam)
        return
    end
    if propType==PropType.None then
        logError("没有改物品--->>>>>",cfgId)
    end
    -----@type currency_config_cell
    --local currencyCfg = CommonHelper:GetTableDataByID(ConfigNames.currency_config, cfgId)
    --if currencyCfg then
    --    CommonHelper:SetGameObjectActive("PartItem",gameObject,false)
    --    local obj = CommonHelper:SetGameObjectActive("ArticleItem",gameObject,true)
    --    local count = articleparam and articleparam.count or nil
    --    CommonHelper:SetItemCurrencyGroup(obj, moduleId, cfgId, count, func, clickparam)
    --    return
    --end
end




