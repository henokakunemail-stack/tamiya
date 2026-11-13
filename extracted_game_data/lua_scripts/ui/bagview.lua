


---@class BagView : ViewBase
BagView = class("BagView", ViewBase)

function BagView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BagViewAction")
end
local _SelectItem=-1
---@type ArticleCell[]
local _Data=nil
---@type table<number,goodstype_config_cell>
local _TypeData=nil
local _SelectType=-1
local _CurShowType=nil
local __AddNum=1
function BagView:Awake()

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    self.BtnUse= CommonHelper:HButtonSetCallback("BtnUse",self.gameObject,function (hbtn)
        ---@type ArticleCell
        local data=_Data[_SelectItem+1]
        if data then
            if  data:GetArticleConfig().propstype == KnapsackType.LittleTrumpet  then--PlayerNoticeDefaultID.LittleTrumpet
                UIManager:Get():OpenPopup("UseBroadcastView",CanvasType.FrontCanvas,"UseBroadcastView")
                UINotify:Get():SendNotification(UINotifyEvent.SetBroadcastType,NoticeLittleType.SmallSpeak)
            elseif data:GetArticleConfig().propstype == KnapsackType.OptionalBox then
                UIManager:Get():OpenPopup("OptionalGiftView",CanvasType.FrontCanvas,"OptionalGiftView")
                UINotify:Get():SendNotification(UINotifyEvent.OptionalGiftViewSetData,data.CfgId)
            else
                UIManager:Get():OpenPopup("CostUseView",CanvasType.FrontCanvas,"CostUseInfoView")
                UINotify:Get():SendNotification(UINotifyEvent.CostUseViewSetData,data)
            end
        end
    end)
    self.BtnDisassemble= CommonHelper:HButtonSetCallback("BtnDisassemble",self.gameObject,function (hbtn)
        ---@type ArticleCell
        local data=_Data[_SelectItem+1]
        if data then
            UIManager:Get():OpenPopup("ArticleDisassembleView",CanvasType.FrontCanvas,"ArticleDisassembleView")
            UINotify:Get():SendNotification(UINotifyEvent.ArticleDisassembleViewSetData,data)
        end
    end)

    self.ArticleView= self:GetChildWight("articleView",typeof(CanvasGroup))
    self.articleViewObj= self:GetChild("articleView")
    self.ScrollView= self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))
    self.TypeScroll= self:GetChildWight("TypeScroll",typeof(MoreRowScrollView))
    self.Togs = {}
    for i = 1, 4 do
        local tog = CommonHelper:HButtonSetCallback("Tog"..i,self.gameObject,function (hbtn)
            self:OnClickTog(i)
        end)
        table.insert(self.Togs, tog)
    end



end

function BagView:OnOpen()
    self:ViewFixScreen()
    _SelectType=-1
    self:OnClickTog(1)
    RedPointManager:Get():UpdateValue(RedPointID.Bag)
end

function BagView:OnClose()

    _CurShowType=-1
    CommonHelper:ReleasePool(UIModuleID.Bag)
end
function BagView:RefreshCurList(isDefaultSelect)
    if isDefaultSelect==nil then isDefaultSelect=true end
    self:OnClickTog(_CurShowType,true,isDefaultSelect)
end

function BagView:SetData()
   --

    CommonHelper:SetGameObjectActive("BagEmpty",self.gameObject,#_Data<=0)
    CommonHelper:SetText("###cellcount",self.gameObject,"")
    if _CurShowType==2 then
        if _SelectType==-1 then
            local  maxNum=CommonHelper:GetDictCalcData(CommonCfgKey.BagMaxCount)
            if #_Data>maxNum then
                maxNum=#_Data
            end
            CommonHelper:SetText("###cellcount",self.gameObject,string.format("%d/%d",#_Data,maxNum))
        else
            CommonHelper:SetText("###cellcount",self.gameObject,string.format("%d",#_Data))
        end
    end
    UIUtil.ShowCanvasGroup(self.ArticleView,#_Data>0)
    CommonHelper:InitMoreRowScrollView(self.ScrollView,#_Data,6,function(index, itemObj,scroll)

        ---@type ArticleCell
        local temp =_Data[index + 1]
        --local partcfg = partdata:GetPartConfig()
        local param = Param_PropSquareParam()
        param.id = temp:GetID()
        param.moduleId = UIModuleID.Bag
        if _CurShowType==2 then
            param.star = temp:GetStar()
            param.quality =temp:GetPartQuality()
        elseif _CurShowType==1 then
            param.count=temp:GetCount()
        elseif _CurShowType==3 then
            param.count=temp:GetCount()
        end
        param.showname=false
        param.generation=temp:GetGeneration()
        CommonHelper:SetPropSquareGroup(itemObj, param)

        CommonHelper:HButtonSetCallback("BtnItem",itemObj,function(data)
            _SelectItem=data.intData
            _Data[_SelectItem+1]:SetNew(false)
            self:SetArticleView()
            CommonHelper:MoreRowView_RefreshCurList(scroll,false)
        end,index)
        CommonHelper:SetGameObjectActive("selctBg",itemObj,_SelectItem==index)
        CommonHelper:SetGameObjectActive("RedPointPart",itemObj,temp:GetIsNew())
        CommonHelper:SetGameObjectActive("bg",itemObj,_CurShowType==1 or _CurShowType==3)
    end)

end

function BagView:SetTypeScroll()
    CommonHelper:SetGameObjectActive("TypeScroll",self.gameObject,#_TypeData>0)
    CommonHelper:SetGameObjectActive("NullType",self.gameObject,#_TypeData<=0)

    CommonHelper:InitMoreRowScrollView(self.TypeScroll,#_TypeData,1,function(index, itemObj,scroll)
        local tog= CommonHelper:HButtonSetCallback("TagBtn",itemObj,function(btnData)
            if _SelectType ~=_TypeData[btnData.intData+1] then
                _SelectType=_TypeData[btnData.intData+1]
                if _CurShowType==2 then
                    self:SetScrollViewPart(false)
                end
                if _CurShowType==4 then
                    self:SetScrollViewSticker(false)
                end

                CommonHelper:MoreRowView_RefreshCurList(self.TypeScroll,false)
            end
        end,index)
        if _CurShowType==2 then
            if _TypeData[index+1]~=-1 then
                local  typeName=CommonHelper:GetGoodsTypeName(GoodsType1.Part, _TypeData[index+1])
                local  icon=CommonHelper:GetGoodsTypeIcon(GoodsType1.Part, _TypeData[index+1])
                CommonHelper:SetText("hover/###text",itemObj,typeName)
                CommonHelper:SetText("normal/###text",itemObj,typeName)
                CommonHelper:GetComponentSetImage("typeImage",itemObj,icon,UIModuleID.Bag)
            else
                local  icon=CommonHelper:GetGoodsTypeIcon(GoodsType1.Part, _TypeData[index+1])
                CommonHelper:GetComponentSetImage("typeImage",itemObj,icon,UIModuleID.Bag)
                CommonHelper:SetText("hover/###text",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.BagPartALL))
                CommonHelper:SetText("normal/###text",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.BagPartALL))
            end
        end
        if _CurShowType==4 then
            if _TypeData[index+1]~=-1 then
                local  typeName=CommonHelper:GetGoodsTypeName(GoodsType1.Article,self.TogStickerGoodsType, _TypeData[index+1])
                local  icon=CommonHelper:GetGoodsTypeIcon(GoodsType1.Article,self.TogStickerGoodsType, _TypeData[index+1])
                CommonHelper:SetText("hover/###text",itemObj,typeName)
                CommonHelper:SetText("normal/###text",itemObj,typeName)
                CommonHelper:GetComponentSetImage("typeImage",itemObj,icon,UIModuleID.Bag)
            end
        end

        CommonHelper:SetToggleState(tog,_TypeData[index+1]==_SelectType)
    end)
end

function BagView:OnClickTog(idx, ischeck,isDefaultSelect)
    local check=ischeck or false
    if _CurShowType ~=idx or check then
        for i = 1, #self.Togs do
            CommonHelper:SetToggleState(self.Togs[i], idx == i)
        end
        _CurShowType=idx
        if idx == 1 then self:SetScrollViewCost(isDefaultSelect) end
        if idx == 2 then self:SetScrollViewPart(true,isDefaultSelect) end
        if idx == 3 then self:SetScrollViewArticle(isDefaultSelect) end
        if idx == 4 then self:SetScrollViewSticker(true,isDefaultSelect) end

        self:SetArticleView()
        if check==false then
            CommonHelper:MoreRowView_EnterAni1(self.ScrollView, 0.2)
        end
    end
end

function BagView:SetSelectItemIdx(isDefaultSelect)
    if isDefaultSelect then
        if #_Data>0 then
            _SelectItem=0
        else
            _SelectItem=-1
        end
    else
        if  #_Data == 0 then
            _SelectItem=-1
        elseif _SelectItem >= #_Data then
            _SelectItem=0
        end
    end
end

function BagView:SortPartShowList()
    if #_Data>0 then
        _Data=CommonHelper:SortPart_1(_Data)
    end
end

function BagView:SortArticleShowList()
    if #_Data>0 then
        table.sort(_Data,function (a, b)
            local cfgA = a:GetArticleConfig()
            local cfgB = b:GetArticleConfig()

            if cfgA.propsgrade > cfgB.propsgrade then
                return true
            end
            if cfgA.propsgrade < cfgB.propsgrade then
                return false
            end
            if cfgA.C_ID > cfgB.C_ID then
                return true
            end
            if cfgA.C_ID < cfgB.C_ID then
                return false
            end
            if a:GetCount() > b:GetCount() then
                return true
            end
            if a:GetCount() < b:GetCount() then
                return false
            end
            return false
        end)
    end

end

function BagView:SetScrollViewCost(isDefaultSelect)
    _Data = KnapsackDataManager:Get():GetAllArticleSubConsumables()
    --local tab = KnapsackDataManager:Get():GetArticleListByType(GoodsType2.Article_GiftBag)
    --for i = 1, #tab do
    --    table.insert(_Data,tab[i])
    --end
    _TypeData={}
    self:SortArticleShowList()
    self:SetSelectItemIdx(isDefaultSelect)
    self:SetData()
    self:SetTypeScroll()
end

function BagView:SetScrollViewPart(ischeck,isDefaultSelect)
    local check=ischeck
    if _SelectType==-1 then
        _Data = KnapsackDataManager:Get():GetEquipmentList()
    else
        _Data = KnapsackDataManager:Get():GetEquipmentsByType(_SelectType)
    end
    if check then
        _TypeData={}
        ---@type goodstype_config
        local goodstype_config= ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
        table.insert(_TypeData,-1)
        local temp=goodstype_config.GetListType2(GoodsType1.Part)
        for i = 1, #temp do
            table.insert(_TypeData,temp[i].type2)
        end
        self:SetTypeScroll()
    end
    self:SortPartShowList()
    self:SetSelectItemIdx(isDefaultSelect)
    self:SetData()
    self:SetArticleView()
end

function BagView:SetScrollViewArticle(isDefaultSelect)
    _Data = KnapsackDataManager:Get():GetAllArticleSubCost()
    _TypeData={}
    self:SortArticleShowList()
    self:SetSelectItemIdx(isDefaultSelect)
    self:SetData()
    self:SetTypeScroll()
end
function BagView:SetScrollViewSticker(ischeck,isDefaultSelect)
    self.TogStickerGoodsType=CommonHelper:GetDictCalcData(CommonCfgKey.BagShowSticker)
    if ischeck then
        _TypeData={}
        ---@type goodstype_config
        local goodstype_config= ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
        local temp=goodstype_config.GetListType3(GoodsType1.Article,self.TogStickerGoodsType)
        for i = 1, #temp do
            table.insert(_TypeData,temp[i].type3)
        end
        _SelectType=_TypeData[1]
        self:SetTypeScroll()
    end
    _Data = KnapsackDataManager:Get():GetAllArticleSticker(_SelectType)
    self:SortArticleShowList()
    self:SetSelectItemIdx(isDefaultSelect)
    self:SetData()
    self:SetArticleView()
end

function BagView:SetItem(index,item,scrollView)
    CommonHelper:HButtonSetCallback()
end

function BagView:SetArticleView()
   UIUtil.ShowCanvasGroup(self.ArticleView,_SelectItem~=-1)
    __AddNum=1
    if _SelectItem~=-1 then
        ---@type ArticleCell
        local data=_Data[_SelectItem+1]
        ---@type dictarticle_config_cell
        ---@type dictparts_config_cell
        local propType,cfg=CommonHelper:GetPropTypeById(data:GetID())
        local  part=CommonHelper:SetGameObjectActive("partview",self.articleViewObj,propType==PropType.Part)
        local  article=CommonHelper:SetGameObjectActive("costview",self.articleViewObj,propType==PropType.Article)
        if propType==PropType.Article then
            CommonHelper:SetText("###costname",article,ClientDataManager:Get():GetTemplateString(cfg.name))
            CommonHelper:SetText("costnum/###value",article,ClientDataManager:Get():GetTemplateString(data:GetCount()))
            CommonHelper:SetText("###costdesc",article,ClientDataManager:Get():GetTemplateString(cfg.description))
            CommonHelper:GetComponentSetUITexture("costicon",article,cfg.icon..".png",UIModuleID.Bag)
            CommonHelper:SetHButtonClick(self.BtnUse, _CurShowType==1 and CommonHelper:GetBagTypeByConsumables(cfg.propstype) ,true)
            CommonHelper:SetHButtonClick(self.BtnDisassemble, false ,true)
            --CommonHelper:SetHButtonClick(self.BtnUse2, _CurShowType==1 and CommonHelper:GetBagTypeByConsumables(cfg.propstype) and cfg.propstype== KnapsackType.RandomBox,true)
            --CommonHelper:SetHButtonClick(self.BtnUseAll, _CurShowType==1 and CommonHelper:GetBagTypeByConsumables(cfg.propstype) and cfg.propstype== KnapsackType.RandomBox,true)
        else

            CommonHelper:SetText("###articleName",part,ClientDataManager:Get():GetTemplateString(cfg.partname))
            CommonHelper:GetComponentSetUITexture("partIcon",part,cfg.icon,UIModuleID.Bag)
            if data:GetGeneration() and data:GetGeneration()>1 then
                if data:GetGeneration() ==2 then
                    CommonHelper:GetComponentSetUITexture("partIcon",part,cfg.icon2,UIModuleID.Bag)
                end
               if data:GetGeneration() ==3 then
                    CommonHelper:GetComponentSetUITexture("partIcon",part,cfg.icon3,UIModuleID.Bag)
                end
               if data:GetGeneration() ==4 then
                    CommonHelper:GetComponentSetUITexture("partIcon",part,cfg.icon4,UIModuleID.Bag)
                end
            end

            CommonHelper:SetText("scroes/###value",part,string.format("%0.0f",data:GetPartScore()))
            CommonHelper:SetText("###level",part,CommonHelper:GetTempStr_Default(TemplateStringID.BagPartLevel,data:GetPartLV()))
            CommonHelper:SetComponentPartStar("PartStar",part,data:GetStar())
            CommonHelper:SetComponentPartStar("PartStarAwake",part,data:GetStar())
            CommonHelper:SetGameObjectActive("PartStarAwake",part,data:GetAwaken())
            CommonHelper:SetGameObjectActive("PartStar",part,not data:GetAwaken())
            --{{{ 属性
            ---@type table<number, PartAttrData>
            local attrlist = {}
            local templist = data:GetPartSecondAttrs()
            for i = 1, #templist do
                if not CommonHelper:PartAttrShowValueEqualZero(templist[i].value) then
                    table.insert(attrlist, templist[i])
                end
            end
            for i = 1, 8 do
                local temp = attrlist[i]
                local obj = CommonHelper:SetGameObjectActive("grid/attr" .. i, part, temp ~= nil)
                if temp then
                    CommonHelper:SetText("###key", obj, CommonHelper:GetAttrName(temp.type))
                    CommonHelper:SetText("###value", obj, CommonHelper:GetAttrValue(temp.type, temp.value))
                    CommonHelper:HButtonSetCallback("BtnAttr", obj, function(hbtn)
                        CommonHelper:ShowAttrInfoView(temp.type)
                    end)
                end
            end
            --}}}
        end
        -----@type ArticleCell
        --local data=_Data[_SelectItem+1]
        --local propType,cfg=CommonHelper:GetPropTypeById(data:GetArticleID())
        --CommonHelper:SetText("curArticleName",self.gameObject,ClientDataManager:Get():GetTemplateString(cfg.name))
        --local des=""
        --local icon=""
        --if propType==PropType.Part then
        --    icon=cfg.icon
        --    des=cfg.desc
        --    CommonHelper:SetGameObjectActive("playerHoldNum",self.gameObject,false)
        --elseif propType==PropType.Article then
        --    icon=cfg.icon..".png"
        --    des=cfg.description
        --    CommonHelper:SetGameObjectActive("playerHoldNum",self.gameObject,true)
        --    CommonHelper:SetText("curArticleNum",self.gameObject,KnapsackDataManager:Get():GetArticleCountByCfgid(data:GetArticleID()))
        --end
        --CommonHelper:SetText("curArticleDesc",self.gameObject,ClientDataManager:Get():GetTemplateString(des))
        --CommonHelper:GetComponentSetUITexture("curArticleicon",self.gameObject,icon,UIModuleID.Bag)
        ----CommonHelper:SetGameObjectActive("shownum",self.gameObject,_CurShowType==1)

    end
end
