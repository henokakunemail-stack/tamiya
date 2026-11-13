






--{{{设置矩形article  item
---@class Param_ArticleItem
Param_ArticleItem = class("Param_ArticleItem")
function Param_ArticleItem:initialize()
    self.moduleId = UIModuleID.None
    self.articleid = -1
    self.count = -1
    self.quality = -1
    self.funClick = nil
    self.funClickParam = nil
end

---@param param Param_ArticleItem
function CommonHelper:SetArticleItem(gameObject, param)
    ---@type article_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, param.articleid)
    local count = tostring(param.count)
    local quality = param.quality
    local icon = ""
    if param.count == -1 then count = "" end
    if param.quality == -1 and cfg then quality = cfg.quality end
    if cfg then icon = cfg.NewIcon end



    CommonHelper:GetComponentSetImage("quality", gameObject, CommonHelper:GetArticleQualityImage(quality), param.moduleId)
    CommonHelper:GetComponentSetUITexture("icon", gameObject, icon, param.moduleId)
    CommonHelper:SetText("###count",gameObject,count)

    for i = 1, 6 do
        CommonHelper:SetGameObjectActive("itemquality"..i, gameObject, quality == i)
    end

    local btnitem = CommonHelper:HButtonSetCallback("BtnItem",gameObject,function (hbtn)
        if param.funClick then param.funClick(param.articleid, param.funClickParam) end
    end)
    CommonHelper:SetHButtonClick(btnitem, param.funClick ~= nil, true)
end
--}}}





--{{{设置正方形article  item
---@class Param_ArticleItemSquare
Param_ArticleItemSquare = class("Param_ArticleItemSquare")
function Param_ArticleItemSquare:initialize()
    self.moduleId = UIModuleID.None
    self.articleid = -1
    self.count = -1
    self.quality = -1
    self.funClick = nil
    self.funClickParam = nil
end

---@param param Param_ArticleItemSquare
--function CommonHelper:SetArticleItemSquare(gameObject, param)
--    ---@type article_config_cell
--    local cfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, param.articleid)
--    local count = tostring(param.count)
--    local quality = param.quality
--    local icon = ""
--    if param.count == -1 then count = "" end
--    if param.quality == -1 and cfg then quality = cfg.quality end
--    if cfg then icon = cfg.NewIcon end
--
--
--    CommonHelper:SetText("count",gameObject,count)
--    CommonHelper:GetComponentSetImage("quality", gameObject, CommonHelper:GetSquareQualityImage(quality), param.moduleId)
--    CommonHelper:GetComponentSetUITexture("icon", gameObject, icon, param.moduleId)
--
--
--    local btnitem = CommonHelper:HButtonSetCallback("BtnItem",gameObject,function (hbtn)
--        if param.funClick then param.funClick(param.articleid, param.funClickParam) end
--    end)
--    CommonHelper:SetHButtonClick(btnitem, param.funClick ~= nil, true)
--end
--}}}


















---------------------------------------------------填充部件item
---@class Param_ArticleGroup
Param_ArticleGroup = class("Param_ArticleGroup")
function Param_ArticleGroup:initialize()
    self.moduleId = nil
    self.articleId = nil
    self.count = 1

    self.showname = true
    self.showcount = true
    self.ClickShowTips = false

    self.icon = nil
    self.name = ""
    self.quality = 1
    self.isGray=false
    self.isFragment = false
end

---@param param Param_ArticleGroup
function CommonHelper:SetArticleGroup(gameObject, param)
    if param == nil then return end

    if param.moduleId == nil then param.moduleId = UIModuleID.None end

    local isarticle = CommonHelper:AnalyseArticleID(param.articleId)

    if isarticle then
        ---@type article_config_cell
        local articlecfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, param.articleId)
        if articlecfg == nil then return end

        param.icon = articlecfg.NewIcon
        param.name = ClientDataManager:Get():GetTemplateString(articlecfg.name)
        param.quality = CommonHelper:GetPartQualityImage(articlecfg.quality)

        if articlecfg.type == KnapsackType.Type2 and articlecfg.school ~= KnapsackSecondType.Fragment_Common then
            param.isFragment = true
        end
    else
        ---@type currency_config_cell
        local currencycfg = CommonHelper:GetTableDataByID(ConfigNames.currency_config, param.articleId)
        if currencycfg == nil then return end

        param.icon = currencycfg.icon..".png"
        param.name = ClientDataManager:Get():GetTemplateString(currencycfg.name)
        param.quality = CommonHelper:GetPartQualityImage(currencycfg.quality)
    end


    local fragment = UIUtil.GetChild("fragment",gameObject)
    if fragment then
        fragment:SetActive(param.isFragment)
    end



    local  rewImage=CommonHelper:GetComponentSetUITexture("RawImage", gameObject, param.icon, param.moduleId)



    local  quality= CommonHelper:GetComponentSetImage("quality", gameObject, param.quality, param.moduleId)


    if param.showcount and param.count then
        CommonHelper:SetText("###count",gameObject,tostring(param.count))
    else
        CommonHelper:SetText("###count",gameObject,"")
    end


    if param.showname then
        CommonHelper:SetText("###name",gameObject,param.name)
    else
        CommonHelper:SetText("###name",gameObject,"")
    end

    CommonHelper:ImageSetGray(quality,param.isGray)
    CommonHelper:ImageSetGray(rewImage,param.isGray)

    local itembtn = CommonHelper:HButtonSetCallback("DefaultItemBtn", gameObject, function(btn)
        ---@type article_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, param.articleId)
        if cfg then CommonHelper:ShowPartInfoByCfgId(param.articleId) end
    end)
    if itembtn then
        CommonHelper:SetHButtonClick(itembtn, param.ClickShowTips)
    end


end
---------------------------------------------------