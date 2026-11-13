Param_PropParam = class("Param_PropParam")
---@class Param_PropParam
function Param_PropParam:initialize()
    self.moduleId = nil
    self.id = nil
    self.count = -1   -- -1不显示
    self.name = ""
    self.star=-1
    self.showname = false
    self.quality = -1
    self.IsGray=false --置灰
    self.BtnFun=false
    self.generation=1
end


---@param param Param_PropParam
function CommonHelper:SetPropGroup(gameObject,param)
    if param == nil then return end
    if param.moduleId == nil then param.moduleId = UIModuleID.None end
    local propType,cfg=CommonHelper:GetPropTypeById(param.id)
    local icon=nil
    local name=nil
    local quality=nil
    local star = param.star
    local season=nil
    local generation=param.generation
    local direction=0
    local isarticle = CommonHelper:AnalyseArticleID(param.id)
    local typeimageName=nil
    --if isarticle==false then
    --    ---@type currency_config_cell
    --    local currencycfg = CommonHelper:GetTableDataByID(ConfigNames.currency_config, param.id)
    --    if currencycfg == nil then return end
    --    icon = currencycfg.icon..".png"
    --    name = ClientDataManager:Get():GetTemplateString(currencycfg.name)
    --    --quality = CommonHelper:GetArticleQualityImage(currencycfg.quality)
    --    quality =currencycfg.quality
    --else
        ---@type dictparts_config_cell
        if propType==PropType.TracKSegment then
            if cfg == nil then return end
            icon=cfg.icon
            name = cfg.name
            --quality=CommonHelper:GetArticleQualityImage(1)
            quality=1
            direction=cfg.direction
        elseif propType==PropType.Part then
            icon=cfg.icon
            if generation and generation>2 then
                if generation==2 then icon=cfg.icon2 end
                if generation==3 then icon=cfg.icon3 end
                if generation==4 then icon=cfg.icon4 end
            end
            name=cfg.partname
            if param.star == -1 then star = cfg.quality end
            local temp=param.quality
            local  base=CommonHelper:GetPartBaseCfg(cfg.C_ID)
            if temp==-1 then temp=base.fabric end
            --quality=CommonHelper:GetAssembleMapPartQualityImage(temp)
            quality=temp
            direction=0
            CommonHelper:SetComponentPartStar("PartStar",gameObject,star)
        elseif propType==PropType.Article then
            ---@type dictarticle_config_cell
            icon=cfg.icon..".png"
            name=cfg.name
            --quality=CommonHelper:GetArticleQualityImage(cfg.quality)
            quality=cfg.propsgrade
            direction=0
            ---@type dictexhibit_config_cell
            local exhibitCfg= CommonHelper:GetTableDataByID(ConfigNames.dictexhibit_config,  cfg.propsadd)
            if exhibitCfg and exhibitCfg.type==ExhibitType.Trophy then
                if tonumber( exhibitCfg.params)>0 then
                    season="s"..exhibitCfg.params
                end
            end
            typeimageName= CommonHelper:GetArticleTypeImage(cfg.propstype,cfg.subtype)
        elseif propType==PropType.Currency then
            icon=cfg.icon..".png"
            name=cfg.name
            --quality=CommonHelper:GetArticleQualityImage(1)
            quality=4
        end
   -- end




    CommonHelper:SetGameObjectActive("artilcetype",gameObject, not CommonHelper:IsNullOrEmpty(typeimageName))
    if not CommonHelper:IsNullOrEmpty(typeimageName) then
        CommonHelper:GetComponentSetImage("artilcetype",gameObject,typeimageName,param.moduleId)
    end
    CommonHelper:SetGameObjectActive("PartStar",gameObject,propType==PropType.Part)
    CommonHelper:SetGameObjectActive("countbg",gameObject,param.count~=-1 and (propType==PropType.Article or propType==PropType.TracKSegment))
    if quality~=nil then

        for i = 1, 6 do
            CommonHelper:SetGameObjectActive("itemquality"..i, gameObject, quality == i)
        end

        --local quality= CommonHelper:GetComponentSetImage("quality", gameObject,quality, param.moduleId)
        --CommonHelper:ImageSetGray(quality,param.IsGray)
    end
    if season~=nil then
        CommonHelper:SetText("###seasonnum",gameObject,season)
    else
        CommonHelper:SetText("###seasonnum",gameObject,"")
    end
    if param.showname then
        CommonHelper:SetText("###name",gameObject,CommonHelper:GetTempStr_Default(name))
    else
        CommonHelper:SetText("###name",gameObject,"")
    end
    for i = 2,4  do
        CommonHelper:SetGameObjectActive("generation_"..i,gameObject,generation==i)
    end

        if icon~=nil then
            local rewImage =CommonHelper:GetComponentSetUITexture("icon", gameObject,icon, param.moduleId)
            CommonHelper:ImageSetGray(rewImage,param.IsGray)
        end

        if param.count~=-1 and propType~=PropType.Part then
            CommonHelper:SetText("###count",gameObject,param.count)
        else
            CommonHelper:SetText("###count",gameObject,"")
        end
    if param.BtnFun~=nil then
        CommonHelper:HButtonSetCallback("BtnItem",gameObject,function(data)
                   param:BtnFun(data)
        end,param.id)
    end
    CommonHelper:SetGameObjectActive("left",gameObject,direction==1)
    CommonHelper:SetGameObjectActive("right",gameObject,direction==2)
    CommonHelper:SetGameObjectActive("BtnItem",gameObject,param.BtnFun)
    return propType,cfg
end
---@class Param_PropSquareParam

Param_PropSquareParam = class("Param_PropParam")

function Param_PropSquareParam:initialize()
    self.moduleId = nil
    self.id = nil
    self.count = -1   -- -1不显示
    self.name = ""
    self.star=-1
    self.showname = false
    self.quality = -1
    self.BtnFun=nil
    self.IsGray=false --置灰
    self.generation=1
end


---@param param Param_PropSquareParam
function CommonHelper:SetPropSquareGroup(gameObject,param)
    if param == nil then return end
    if param.moduleId == nil then param.moduleId = UIModuleID.None end
    local propType,cfg=CommonHelper:GetPropTypeById(param.id)
    local icon=nil
    local name=nil
    local quality=nil
    local star = param.star
    local season=""
    local isarticle = CommonHelper:AnalyseArticleID(param.id)
    local generation=param.generation
    local direction=0
    local typeimageName=""
    if isarticle==false then
        ---@type currency_config_cell
        local currencycfg = CommonHelper:GetTableDataByID(ConfigNames.currency_config, param.id)
        if currencycfg == nil then return end
        icon = currencycfg.icon..".png"
        name = ClientDataManager:Get():GetTemplateString(currencycfg.name)
        --quality = CommonHelper:GetArticleQualityImage(currencycfg.quality)
        quality = currencycfg.quality
        generation=-1
    else
        if propType==PropType.TracKSegment then
            if cfg == nil then return end
            icon=cfg.icon..".png"
            name = cfg.name
            --quality=CommonHelper:GetSquareQualityImage(1)

            quality=1
            generation=-1
            direction=cfg.direction
        elseif propType==PropType.Part then
            icon=cfg.icon
            if generation and generation>2 then
                if generation==2 then icon=cfg.icon2 end
                if generation==3 then icon=cfg.icon3 end
                if generation==4 then icon=cfg.icon4 end
            end
            name=cfg.name
            if param.star == -1 then star = cfg.quality end
            quality=  param.quality or cfg.fabric
            --quality=CommonHelper:GetSquareQualityImage(temp)
            CommonHelper:SetComponentPartStar("PartStar",gameObject,star)
        elseif propType==PropType.Article then
            icon=cfg.icon..".png"
            name=cfg.name
            --quality=CommonHelper:GetSquareQualityImage(cfg.quality)
            quality=cfg.propsgrade
            ---@type dictexhibit_config_cell
            local exhibitCfg= CommonHelper:GetTableDataByID(ConfigNames.dictexhibit_config,  cfg.propsadd)
            if exhibitCfg and exhibitCfg.type==ExhibitType.Trophy then
                if tonumber( exhibitCfg.params)>0 then
                    season="s"..exhibitCfg.params
                end
            end
            generation=-1
            typeimageName= CommonHelper:GetArticleTypeImage(cfg.propstype,cfg.subtype)
        end
    end



    CommonHelper:SetGameObjectActive("artilcetype",gameObject, not CommonHelper:IsNullOrEmpty(typeimageName))
    if not CommonHelper:IsNullOrEmpty(typeimageName) then
         CommonHelper:GetComponentSetImage("artilcetype",gameObject,typeimageName,param.moduleId)
    end
    CommonHelper:SetGameObjectActive("PartStar",gameObject,propType==PropType.Part)
    CommonHelper:SetGameObjectActive("countbg",gameObject,propType==PropType.Article or propType==PropType.TracKSegment or isarticle==false)
    if quality~=nil then
        for i = 1, 6 do
            CommonHelper:SetGameObjectActive("itemquality"..i, gameObject, quality == i)
        end
        --local quality= CommonHelper:GetComponentSetImage("quality", gameObject,quality, param.moduleId)
        --CommonHelper:ImageSetGray(quality,param.IsGray)
    end
    if param.showname then
        CommonHelper:SetText("###name",gameObject,ClientDataManager:Get():GetTemplateString(name))
    else
        CommonHelper:SetText("###name",gameObject,"")
    end
    for i = 2,4  do
        CommonHelper:SetGameObjectActive("generation_"..i,gameObject,generation==i)
    end
    if season~=nil then
        CommonHelper:SetText("###seasonnum",gameObject,season)
    else
        CommonHelper:SetText("###seasonnum",gameObject,"")
    end
        if icon~=nil then
            local rewImage =CommonHelper:GetComponentSetUITexture("icon", gameObject,icon, param.moduleId)
            CommonHelper:ImageSetGray(rewImage,param.IsGray)
        end

        if param.count~=-1 and propType~=PropType.Part then
            CommonHelper:SetText("###count",gameObject,param.count)
            CommonHelper:SetGameObjectActive("countbg",gameObject,true)
        else
            CommonHelper:SetText("###count",gameObject,"")
            CommonHelper:SetGameObjectActive("countbg",gameObject,false)
        end
    CommonHelper:SetGameObjectActive("left",gameObject,direction==1)
    CommonHelper:SetGameObjectActive("right",gameObject,direction==2)
end

---@param param Param_PropSquareParam
function CommonHelper:SetPropSquareGroupWareHouse(gameObject, param)
    self:SetPropSquareGroup(gameObject, param)
    CommonHelper:SetText("###count", gameObject, param.count)
    CommonHelper:SetGameObjectActive("countbg", gameObject, true)
end

---@return PropType
function CommonHelper:GetPropTypeById(id)
    ---@type dictparts_config_cell
    local partCfg= CommonHelper:GetTableDataByID(ConfigNames.parts_config,id)
    ---@type dictarticle_config_cell
    local articleCfg= CommonHelper:GetTableDataByID(ConfigNames.article_config,id)
    ---@type  tracksegement_config_cell
    local trackSegCfg= CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config,id)
    ---@type  currency_config_cell
    --local currencycfg= CommonHelper:GetTableDataByID(ConfigNames.currency_config,id)

    if partCfg then
        return PropType.Part,partCfg
    end
    if articleCfg then
        return PropType.Article,articleCfg
    end
    if trackSegCfg then
        return PropType.TracKSegment,trackSegCfg
    end
    return PropType.None,nil
    --if currencycfg then
    --    return PropType.Currency,currencycfg
    --end
end

function CommonHelper:GetPropMessageByType(type, data)
    local _name = ""
    local _desc = ""
    local _img = ""
    if type == PropType.Part then
        _name = data.partname
        _desc = data.partdesc
        _img = data.icon
        return _name, _desc
    end
    if type == PropType.Article then
        _name = data.name
        _desc = data.description
        _img = data.icon .. ".png"
        return _name, _desc
    end
    if type == PropType.TracKSegment then
        _name = data.name
        _desc = data.desc
        _img = data.icon
        return _name, _desc
    end
end






