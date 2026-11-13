

---@class Param_PartOrArticleParam
Param_PartOrArticleParam = class("Param_PartOrArticleParam")

function Param_PartOrArticleParam:initialize()
    self.moduleId = nil
    self.id = nil
    self.moduleId=nil
    self.count = nil
    self.showname = true
    self.showcount = true
    self.isShowPartFeature=false
    self.ClickShowTips=false
    self.IsGray=false
end

---@param param Param_PartOrArticleParam
function CommonHelper:SetPartOrArticleGroup(gameObject,param)
    local isPart=CommonHelper:GetTableDataByID(ConfigNames.parts_config,param.id)
    self.partGameObject=UIUtil.GetChild("PartCompoent",gameObject)
    self.articleGameObject=UIUtil.GetChild("ArticleCompoent",gameObject)
    self.PartCompoent=UIUtil.GetGameobjectComponent(self.partGameObject,typeof(CanvasGroup))
    self.ArticleCompoent=UIUtil.GetGameobjectComponent(self.articleGameObject,typeof(CanvasGroup))

    local quality=nil
    local rewImage=nil
    if isPart then
        UIUtil.ShowCanvasGroup(self.PartCompoent,true)
        UIUtil.ShowCanvasGroup(self.ArticleCompoent,false)
        local partData = Param_PartGroup()
        partData.partId = isPart.id
        partData.quality=param.quality
        partData.showname=param.showname
        if  param.star then
            partData.star=param.star
        else
            partData.star=isPart.quality
        end
        partData.moduleId = param.moduleId
        partData.isGray=param.IsGray
        partData.isShowPartFeature=param.isShowPartFeature
        partData.ClickShowTips=param.ClickShowTips
        CommonHelper:SetPartGroup(self.partGameObject, partData)
    else
        UIUtil.ShowCanvasGroup(self.PartCompoent,false)
        UIUtil.ShowCanvasGroup(self.ArticleCompoent,true)
        local articleData = Param_ArticleGroup()
        articleData.articleId = param.id
        articleData.count=param.count
        articleData.moduleId = param.moduleId
        articleData.showname = param.showname
        articleData.showcount = param.showcount
        articleData.ClickShowTips=param.ClickShowTips
        articleData.isGray=param.IsGray
        CommonHelper:SetArticleGroup(self.articleGameObject, articleData)
    end

end





