


---------------------------------------------------填充部件item
---@class Param_ShopGoodsGroup
Param_ShopGoodsGroup = class("Param_ShopGoodsGroup")
function Param_ShopGoodsGroup:initialize()
    self.moduleId = nil
    self.articleId = nil
    self.grid=nil
    self.name = nil
    self.count = 0
    self.icon = nil
    self.quality = 1
    self.price = 0
    self.currencytype = nil
    self.num=0
    self.maxNum=0
    self.disCount=0
    self.limit=0
    self.limitValue=0
    self.limitCurValue=0
    self.goodType=nil
    self.starGroup=nil
    self.buyCount=nil
    self.goodType=nil
    self.showname=nil
    self.showcount=nil
    self.flag=0
end

---@param param Param_ShopGoodsGroup
function CommonHelper:SetShopGoodsGroup(gameObject, param,func,clickparam)
    if param == nil then return end

    if param.moduleId == nil then param.moduleId = UIModuleID.None end
    local data=Param_PropParam()
    data.moduleId=param.moduleId
    data.id=param.articleId
    data.count=param.count >0 and param.count or 1
    data.showcount=param.count>1 and true or false
    data.showname=param.showname

    if param.num>0 then
        CommonHelper:SetGameObjectActive("hasBg",gameObject,true)
        local str=CommonHelper:GetTempStr_Default(TemplateStringID.ShopBuyCountBlackBlue,param.num)
        CommonHelper:SetText("###buyCount",gameObject,str)
    else
        CommonHelper:SetGameObjectActive("hasBg",gameObject,false)
        CommonHelper:SetText("###buyCount",gameObject,"")
    end

    if param.limit>0 and param.limitCurValue<param.limitValue then
        CommonHelper:SetGameObjectActive("limit",gameObject,true)
        local str=""
        if param.limit==ShopConditionType.GuideLevel then
            str=CommonHelper:GetTempStr_Default(TemplateStringID.ShopBuyLimitType2,param.limitValue)
        end
        CommonHelper:SetText("###limit",gameObject,str)
    else
        CommonHelper:SetGameObjectActive("limit",gameObject,false)
    end
    CommonHelper:SetGameObjectActive("flag1",gameObject,param.flag==1)
    CommonHelper:SetGameObjectActive("flag2",gameObject,param.flag==2)
    CommonHelper:SetGameObjectActive("flag3",gameObject,param.flag==3)

    self.btn=UIUtil.GetTypeChildWightByParent("ItemBtn",gameObject,typeof(HButton))
    CommonHelper:SetText("###LabPrice",gameObject,tostring(math.modf(param.price*param.disCount)))
    local propType,cfg= CommonHelper:GetPropTypeById(param.articleId)
    local name=""
    if propType == PropType.Part then
       name = CommonHelper:GetTempStr_Default(cfg.partname)
    elseif propType == PropType.Article then
        name  = CommonHelper:GetTempStr_Default(cfg.name)
    elseif propType == PropType.TracKSegment then
        name  = CommonHelper:GetTempStr_Default(cfg.name)
    end
    CommonHelper:SetText("###goodsname",gameObject,name)
    local disCount=UIUtil.GetChild("discount",gameObject)
    if disCount~=nil then
        if  param.disCount==1 then
            disCount.gameObject:SetActive(false)
        else
            disCount.gameObject:SetActive(true)
            CommonHelper:SetText("###discountText",disCount,CommonHelper:GetTempStr_Default(TemplateStringID.ShopDiscountFormat,param.disCount*100))
        end
    end
    local typeImg = UIUtil.GetTypeChildWightByParent("SpcSprite", gameObject, typeof(Image))
    if param.currencytype and typeImg then
        CommonHelper:SetImage(typeImg, CommonHelper:GetCurrencyTypeImage(param.currencytype) , param.moduleId)
        CommonHelper:ImageSetNativeSize(typeImg)
        local scale=0.55
        UIUtil.SetUIWidth(typeImg,UIUtil.GetUIWidth(typeImg)*scale)
        UIUtil.SetUIHeight(typeImg,UIUtil.GetUIHeight(typeImg)*scale)

    end
    local sellOut=UIUtil.GetChild("sellOut",gameObject)
    local SpcSprite=UIUtil.GetChild("PriceBg",gameObject)
    local border=UIUtil.GetTypeChildWightByParent("Border",gameObject,typeof(Image))
    if param.num>0 or param.maxNum==0 then
        if self.btn~=nil then
            CommonHelper:SetHButtonClick( self.btn,true)
        end

        data.IsGray=false
        if border~=nil then
            CommonHelper:SetImageColor(border,"4B6EC5")
        end
        data.isShowPartFeature=true
        if sellOut~=nil then
            sellOut:SetActive(false)
        end

        if SpcSprite~=nil then
            SpcSprite:SetActive(true)
        end
    else
        if self.btn~=nil then
            CommonHelper:SetHButtonClick( self.btn,false)
        end
        --typeImg.gameObject:SetActive(false)
        data.IsGray=true
        if border~=nil then
            CommonHelper:SetImageColor(border,"A6A6A6")
        end
        --CommonHelper:SetText("###LabPrice",gameObject,"")
        data.star=0
        data.isShowPartFeature=false
        if sellOut~=nil then
            sellOut:SetActive(true)
        end
        --if SpcSprite~=nil then
        --    SpcSprite:SetActive(false)
        --end
    end
    local AutoScrollView = UIUtil.GetTypeChildWightInputPath("AutoMoveScrollView1",gameObject,typeof(AutoMoveScrollView))
    if AutoScrollView then
        cs_coroutine.start(function()
            CommonHelper:AutoScroll_BreakMove(AutoScrollView,true)
            CommonHelper:AutoScroll_SetValue(AutoScrollView,0)
            CommonHelper:SetGameObjectActive("AutoMoveScrollView1",gameObject,false)
            CommonHelper:SetGameObjectActive("AutoMoveScrollView1",gameObject,true)
            coroutine.yield()
            CommonHelper:AutoScroll_Init(AutoScrollView,true,0,function()

            end)
        end)
    end

    local param2 = Param_ItemArticleParam()
    CommonHelper:SetItemComGroup(gameObject, param.moduleId, param.articleId, param2, function(data)
        if func then func(data) end
    end,clickparam)
end
---------------------------------------------------