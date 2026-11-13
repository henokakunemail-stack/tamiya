---@type dictgiftpart_config_cell
local _isReviewReform=nil
---@type ArticleCell
local ArticleCell=nil



---@class ArticleInfoView : ViewBase
ArticleInfoView = class("ArticleInfoView", ViewBase)

function ArticleInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ArticleInfoViewAction")

    print("---   ArticleInfoView 初始化完成")
end

function ArticleInfoView:Awake()
    print("---   ArticleInfoView awake")
    --CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
    --    UIManager:Get():ClosePopup()
    --end)
    CommonHelper:HButtonSetCallback("BtnClose1",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
   CommonHelper:HButtonSetCallback("BtnClose2",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
      CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)

    self.ArticleGroup = UIUtil.GetChild("ArticleView", self.gameObject)
    self.PartGroup = UIUtil.GetChild("PartView", self.gameObject)
    self.TrackSegmentGroup = UIUtil.GetChild("TrackSegmentView", self.gameObject)
    self.TrackFeatureGroup = UIUtil.GetChild("TrackFeatureView", self.gameObject)
    self.clickPoint = UIUtil.GetChild("clickPoint", self.gameObject)
    self.RightUp = UIUtil.GetChild("RightUp", self.gameObject)
    self.LeftUp = UIUtil.GetChild("LeftUp", self.gameObject)
    self.LeftDown = UIUtil.GetChild("LeftDown", self.gameObject)
    self.RightDown = UIUtil.GetChild("RightDown", self.gameObject)
    self.PartRightDown=self:GetChild("PartRightDown")
    self.PartLeftDown=self:GetChild("PartLeftDown")
    self.PartLeftUp=self:GetChild("PartLeftUp")
    self.PartRightUp=self:GetChild("PartRightUp")
    self.ArticleView = self:GetChildWightByParent("ArticleView",self.gameObject,typeof(CanvasGroup))
    self.PartView = self:GetChildWightByParent("PartView",self.gameObject,typeof(CanvasGroup))
    self.TrackSegmentView = self:GetChildWightByParent("TrackSegmentView",self.gameObject,typeof(CanvasGroup))
    self.TrackFeature = self:GetChildWightByParent("TrackFeatureView",self.gameObject,typeof(CanvasGroup))
    self.ArticleGet= CommonHelper:HButtonSetCallback("BtnGet",self.ArticleGroup,function (hbtn)
      --  UIManager:Get():ClosePopup()
        KnapsackSubsystem:Get():SendMsg_GetArticleLevelList(self.ConfigData.C_ID)
    end)

    self.BtnDetails= CommonHelper:HButtonSetCallback("BtnDetails",self.ArticleGroup,function (hbtn)
        UIManager:Get():OpenPopup("OptionalGiftDetailsView",CanvasType.FrontCanvas,"OptionalGiftDetailsView")
        UINotify:Get():SendNotification(UINotifyEvent.OptionalGiftDetailsViewSetData,self.ConfigData.C_ID)
    end)

    self.Toggle = {}
    for i = 1, 6 do
        local tog = CommonHelper:HButtonSetCallback("Toggle"..i, self.PartGroup,function (hbtn)
            self:OnClickTogPage(i, true)
        end)
        table.insert(self.Toggle, tog)
    end
end

function ArticleInfoView:OnOpen()
    CommonHelper:SetGameObjectActive("BtnClose2", self.gameObject,false )
end

function ArticleInfoView:OnClickTogPage(idx, ischeck)
    if ischeck then
        if self.TogIdx == idx then return end
    end
    self.TogIdx = idx
    self.PartTypeGroup={}
    for i = 1, #self.Toggle do
        CommonHelper:SetToggleState(self.Toggle[i], idx == i)
        self.PartTypeGroup[i]=CommonHelper:SetGameObjectActive("type"..i,self.PartGroup,idx==i)
    end
    local PartBaseCfg=  CommonHelper:GetPartBaseCfg(self.ConfigData.C_ID)
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictpartyoke_config)
    ---@type PartYokeCfg[]
    local List=cfg.GetPartLinksCfgDataById(PartBaseCfg.C_ID)
    CommonHelper:SetHButtonClick( self.Toggle[5],List and #List>0,true)
    local flag=ArticleCell~=nil
    if flag then
        flag=false
        for i = 1, #ArticleCell:GetPartReformList() do
            if ArticleCell:GetPartReformList()[i].id>0 then
                flag=true
                break
            end
        end
    end
    CommonHelper:SetHButtonClick( self.Toggle[6],_isReviewReform~=nil or flag,true)
    if idx == 1 then self:SetGroupDesc(self.PartTypeGroup[1]) end
    if idx == 2 then self:SetGroupInfo(self.PartTypeGroup[2]) end
    if idx == 3 then self:SetGroupSkill(self.PartTypeGroup[3])  end
    if idx == 4 then self:SetDevelopScrollView(self.PartTypeGroup[4]) end
    if idx == 5 then self:SetYokeScrollView(self.PartTypeGroup[5]) end
    if idx == 6 then self:SetReviewReform(self.PartTypeGroup[6]) end
end
function ArticleInfoView:SetGroupDesc(root)
    --self.ConfigData=cfg
    --self.UIModuleID=uiModuleID
    if self.ConfigData then
        self:PartUI(self.ConfigData,self.UIModuleID)
    end
end
function ArticleInfoView:SetGroupInfo(root)
    --{{{ 配件item
    ---@type dictpartage_config_cell
    local  ageCfg=CommonHelper:GetPartAgeCfg(self.ConfigData.C_ID,1)
    --{{{二级属性
    local secondAttrs = {}
    local sortlist = {}
    for k, v in pairs(ageCfg.NewAttr) do
        local attrCfg = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, v.type)
        local tagName = CommonHelper:GetTempStr_Default(attrCfg.tagName)
        if secondAttrs[tagName] == nil then
            secondAttrs[tagName] = {}
            table.insert(sortlist, {attrCfg.tag, tagName})
        end
        table.insert(secondAttrs[tagName], v)
    end
    table.sort(sortlist, function (a, b) return a[1] < b[1] end)

    local temp = {}
    for i = 1, #sortlist do
        local key = sortlist[i][2]
        table.sort(secondAttrs[key],function (a, b) return a.type < b.type end)
        table.insert(temp, key)
        table.insert(temp, #secondAttrs[key])
    end
    local TitleScrollView = UIUtil.GetTypeChildWightInputPath("TitleScrollView", root, typeof(TitleScrollView))
    CommonHelper:InitTitleScrollView(TitleScrollView, temp, 1,function(title, itemObj, dataIndex, scroll)
        local datalist = secondAttrs[title]
        if dataIndex == -1 then
            CommonHelper:SetText("###name", itemObj, title)
        else
            local data = datalist[dataIndex + 1]
            CommonHelper:SetText("###name", itemObj, CommonHelper:GetAttrName(data.type))
            CommonHelper:SetText("###value", itemObj, CommonHelper:GetAttrValue(data.type, data.value))

            CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
                CommonHelper:ShowGarageTipsView(GarageTipsTpye.SecondAttr, data.type, CommonHelper:GetAttrValue(data.type, data.value))
            end)
        end
    end)
    --}}}
end


function ArticleInfoView:SetDevelopScrollView(root)
    local ReformList = {}
    ---@type dictpartstar_config
    local partstar= ClientDataManager:Get():GetDataTable(ConfigNames.dictpartstar_config)
    ---@type dictpartsdevelop_config
    local develop= ClientDataManager:Get():GetDataTable(ConfigNames.dictpartsdevelop_config)
    local PartBaseCfg=  CommonHelper:GetPartBaseCfg(self.ConfigData.C_ID)
    local list=partstar.GetCfgDataByIdAndStar(PartBaseCfg.C_ID,PartBaseCfg.maxstar)
    local starCfg={}
    for i = 1,PartBaseCfg.maxstar  do
        starCfg[i]=stringSplitToNumber(partstar.GetCfgDataByIdAndStar(PartBaseCfg.C_ID,i).entries,":")
    end
    local entries=stringSplitToNumber(list.entries,":")
    for k, v in pairs(entries) do
        local reformcfg =develop.GetDevelopPartByEntryId(v)
        table.insert(ReformList, reformcfg)
    end
    table.sort(ReformList,function(a, b)
        return a.entryid<b.entryid
    end)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #ReformList, 1,function(dataIndex, itemObj, scroll)
        self:UpdateDevelopScrollView(dataIndex, itemObj,ReformList,starCfg,PartBaseCfg.maxstar)
    end)
end
function ArticleInfoView:SetYokeScrollView(root)
    local PartBaseCfg=  CommonHelper:GetPartBaseCfg(self.ConfigData.C_ID)
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictpartyoke_config)
    ---@type PartYokeCfg[]
    local List=cfg.GetPartLinksCfgDataById(PartBaseCfg.C_ID)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Yoke", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #List, 2,function(dataIndex, itemObj, scroll)
        ---@type PartYokeCfg
        local temp=List[dataIndex+1]
        for i = 1, #temp.PartIds do
            local partobj = UIUtil.GetChild("ItemPart_"..i, itemObj)
            CommonHelper:SetItemPartGroup(partobj,self.UIModuleID,temp.PartIds[i],ItemPartUIType.Simple,nil,function(id)

            end,temp.PartIds[i])
            CommonHelper:SetText("###name"..i,itemObj,CommonHelper:GetPartOrArticleName(temp.PartIds[i]))
        end
        local  desc=string.gsub(CommonHelper:GetTempStr_Default(temp.Desc), "f6ff00", "dd740d")
        CommonHelper:SetText("###desc",itemObj,desc)
    end)
end
function ArticleInfoView:SetReviewReform(root)

    local ReformList = {}
    if _isReviewReform~=nil then
        local entryIds=stringSplitToNumber(_isReviewReform.entryids,':')
        local entrylvs=stringSplitToNumber(_isReviewReform.entrylevs,':')
        local entryqlys=stringSplitToNumber(_isReviewReform.entryqlys,':')
        for k, v in pairs(entryIds) do
            table.insert(ReformList, {entryid=v,lev=entrylvs[k],quality=entryqlys[k]})
        end
    end
    if ArticleCell~=nil then
        for k, v in pairs(ArticleCell:GetPartReformList()) do
            table.insert(ReformList, {entryid=v.id,lev=v.lv,quality=v.quality})
        end
    end
    table.sort(ReformList,function(a, b)
        return a.entryid<b.entryid
    end)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #ReformList, 1,function(dataIndex, itemObj, scroll)
        self:UpdateReviewReformScrollView(dataIndex, itemObj,ReformList)
    end)
end
function ArticleInfoView:UpdateReviewReformScrollView(dataIndex, itemObj,ReformList)
    local id=ReformList[dataIndex+1].entryid
    local lev=ReformList[dataIndex+1].lev
    local quality=ReformList[dataIndex+1].quality
    local cfg=CommonHelper:GetDevelopByEntryId(id)
    local calcfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PartStrongStart)
    local deltaStart = tonumber(calcfg.varval)
    calcfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PartStrongMax)
    local deltaMax = tonumber(calcfg.varval)
    if id ~= nil and cfg  then
        CommonHelper:HButtonSetCallback("BtnDetail",itemObj,function (hbtn)
            CommonHelper:ShowGarageTipsView(GarageTipsTpye.Reform, hbtn.intData)
        end,id)
        CommonHelper:SetText("###name", itemObj, ClientDataManager:Get():GetTemplateString(cfg.name))

        local str = CommonHelper:GetTempStr_Default(TemplateStringID.ItemPartLvFormat, lev)
        CommonHelper:SetText("###lv", itemObj, str)

        for i = 1, 3 do CommonHelper:SetGameObjectActive("quality"..i, itemObj, quality == i) end
        local tempvalue = PlayerDataManager:Get():GetPlayerLV() - deltaStart >0 and PlayerDataManager:Get():GetPlayerLV() - deltaStart+1 or 1
        if tempvalue > deltaMax then tempvalue = deltaMax end
        CommonHelper:SetGameObjectActive("strongenable", itemObj, lev<20)
        CommonHelper:SetGameObjectActive("stronglock", itemObj, lev==20)

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

    else
        print("entityId空",id)
    end
end


function ArticleInfoView:UpdateDevelopScrollView(dataIndex, itemObj,ReformList,starCfg,maxstar)

    ---@type dictpartsdevelop_config_cell
    local cfg = ReformList[dataIndex + 1]
    local star = -1
    for i = 1, maxstar do
        for m = 1, #starCfg[i] do
            if starCfg[i][m]==cfg.entryid then
                star=i
                break
            end
        end
        if star~=-1 then
            break
        end
    end
    CommonHelper:SetText("###reformname", itemObj, ClientDataManager:Get():GetTemplateString(cfg.name))

    --{{{详细
    CommonHelper:HButtonSetCallback("BtnDetail",itemObj,function (hbtn)
        CommonHelper:ShowGarageTipsView(GarageTipsTpye.Reform, cfg.entryid)
    end)
    --}}}

    --{{{概率
    local rate=stringSplitToNumber(cfg.rate,':')
    local str = CommonHelper:GetTempStr_Default(TemplateStringID.PartReforChangeFormat, (rate[2] + rate[3] + rate[4])* 0.01)
    CommonHelper:SetText("###rate", itemObj, str)
    --}}}


    CommonHelper:SetText("###strongenable", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ReformSelectCanReformReview,star))


    --{{{属性
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

            for i = 1, 3 do CommonHelper:SetGameObjectActive("featurelv"..i, tempobj, 1 == i) end
        end
    end

    --}}}

    --{{{材料消耗

    ---@type dictconsume_config_cell[]
    local costs = CommonHelper:GetConsumeGroup(cfg.costids)
    for i = 1, 3 do
        ---@type dictconsume_config_cell
        local data=costs[i]

        if data and  data.propsid==CurrencyType.Gold then
            data=nil
        end
        local obj = CommonHelper:SetGameObjectActive("ItemCost"..i, itemObj, data ~= nil)
        if data then
            local param = Param_ItemArticleParam()
            CommonHelper:SetItemArticleGroup(obj,self.UIModuleID,data.propsid, param)
            CommonHelper:SetText("###count", obj, data.propsnum)
        end
    end
    -- }}}
end




function ArticleInfoView:SetGroupAttr(root)
    local datalist={}
    local PartAttrs = {}
    ---@type attrtype_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.attrtype_config)
    local list = tab.GetList()
    for i = 1, #list do
        local data = PartAttrData()
        local value=list[i].init
        for j= 1, #self.ConfigData.NewAttrs do
            if list[i].id==self.ConfigData.NewAttrs[j][1] then
                value=self.ConfigData.NewAttrs[j][2]
                break
            end
        end
        data:SetData(list[i].id,value)
        PartAttrs[list[i].id] = data
    end
    for i = 1, #self.ConfigData.NewAttrFeature do
        local temp = self.ConfigData.NewAttrFeature[i]

        ---@type attrfeature_config_cell
        local feature = CommonHelper:GetTableDataByID(ConfigNames.attrfeature_config, temp)
        local value = PartAttrs[feature.attr].value

        local data = PartFeatureData()
        data:SetData(i, feature, value)
        table.insert(datalist, data)
    end
    table.sort(datalist, function(a,b) return a:GetFeatureType() < b:GetFeatureType() end)
    --local count = #datalist > 10 and #datalist or 10

    local ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.PartGroup, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(ScrollView, #datalist, 1,function(dataIndex, itemObj, scroll)
        local data = datalist[dataIndex + 1]
        if data then
            for i = 1, 3 do
                local tempobj = CommonHelper:SetGameObjectActive("type"..i, itemObj, data and i == data:GetFeatureType())

                if data and i == data:GetFeatureType() then
                    CommonHelper:GetComponentSetImage("icon", tempobj, data:GetFeatureIcon(), self.UIModuleID)
                    CommonHelper:SetText("###name", tempobj, data:GetFeatureName())
                    CommonHelper:SetText("###value", tempobj, data:GetFeatureValue())
                    CommonHelper:SetText("###lv", tempobj, data:GetFeatureLV())
                end
            end


        end


    end, nil, nil, true)
end
function ArticleInfoView:SetGroupSkill(root)
    local bufflist={}
    ---@type dictpartbase_config_cell
    local  basecfg=CommonHelper:GetPartBaseCfg(self.ConfigData.C_ID)
    if self.ConfigData and basecfg.NewSkillIds then
        local data = ShellBuffData()
        data:SetData(basecfg.NewSkillIds[1])
        table.insert(bufflist, data)
    end
    local ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Skill", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(ScrollView, #bufflist, 1,function(dataIndex, itemObj, scroll)
        local data = bufflist[dataIndex + 1]
        if data and data.BuffCfg then
            CommonHelper:SetGameObjectActive("qualitynil", itemObj, false)
            for i = 1, 6 do
                local tempobj = CommonHelper:SetGameObjectActive("quality"..i, itemObj, data.BuffCfg.quality == i)
                if data.BuffCfg.quality == i and tempobj then
                    CommonHelper:SetText("###name", tempobj, CommonHelper:GetTempStr_Default(data.BuffCfg.name))
                    CommonHelper:SetText("###des", tempobj, CommonHelper:GetTempStr_Default(data.BuffCfg.desc))
                end
            end
        else
            CommonHelper:SetGameObjectActive("qualitynil", itemObj, true)
            for i = 1, 6 do CommonHelper:SetGameObjectActive("quality"..i, itemObj, false) end
        end
    end)
end

function ArticleInfoView:OnClose()

end

function ArticleInfoView:SetDataByCellid(colortype, cellid)
    self:SetUIColor(colortype)

    local data = KnapsackDataManager:Get():GetArticleByCellID(cellid)
    if data and data:GetArticleConfig() then

        local type1 = data:GetArticleConfig().type
        local type2 = data:GetArticleConfig().school
        local name = data:GetArticleConfig().name
        local des = data:GetArticleConfig().description
        local icon = data:GetArticleConfig().NewIcon
        local count = data:GetCount()
        self:SetUI(type1, type2, name, des, icon, count)
    end
end
---@param cfg tracksegement_config_cell
function ArticleInfoView:SetTrackSegmentDataByCfg(cfg,count)
    self:SetView(PropType.TracKSegment)
    if cfg then
        local name=cfg.name
        local des=cfg.desc
        local title=CommonHelper:GetTableDataByID(ConfigNames.dicttracksegmenttype_config,cfg.type).name
        self:SetTrackSegmentUI(title, name, des,cfg.C_ID)
    end
end

---@param id number
function ArticleInfoView:TrackSegmentFeatureView(id)
    self:SetView(PropType.TrackFeature)
    ---@type sign_config_cell
    local cfg= CommonHelper:GetTableDataByID(ConfigNames.sign_config,id)
    if cfg then
        local name=cfg.name
        local des=cfg.desc
        local icon=id
        self:SetTrackFeatureUI(icon, name, des,cfg.icon)
    end
end

---@param cfg dictarticle_config_cell
function ArticleInfoView:SetDataByCfg(id,uiModuleID,isQuick,Reform,articleCell)
    self.UIModuleID=uiModuleID
    _isReviewReform=Reform
    ArticleCell=articleCell
    local propType,cfg=CommonHelper:GetPropTypeById(id)
    if propType==PropType.Article then
        if cfg then
            local type1 = GoodsType1.Article
            local type2 = cfg.propstype
            local type3 = cfg.subtype
            local name = cfg.name
            local des = cfg.description
            local icon = cfg.NewIcon
            local count = nil
            self.ConfigData=cfg
            self:ArticleUI(id,type1, type2,type3 ,name, des, icon, count)
        end
        CommonHelper:SetHButtonClick(self.ArticleGet,isQuick and cfg.accessWay~="0",true)
        CommonHelper:SetHButtonClick(self.BtnDetails,cfg.propstype == KnapsackType.OptionalBox or cfg.propstype == KnapsackType.RandomBox,true)
        --CommonHelper:SetHButtonClick(self.ArticleGet,false,true)
       -- self:SetArticleViewPosition(self.ArticleGroup)
    elseif propType==PropType.Part then
        ---@type parts_config_cell
        self.ConfigData=cfg
        self:OnClickTogPage(1,false)
        --self:SetPartViewPosition(self.PartGroup)
    elseif propType==PropType.TracKSegment then
        if cfg then
            UINotify:Get():SendNotification(UINotifyEvent.TrackSegmentInfoView_SetData, { cfg, 0 })
        end
        --self:SetArticleViewPosition(self.ArticleGroup)
    end
    self:SetView(propType)
end
function ArticleInfoView:SetView(type)
    UIUtil.ShowCanvasGroup(self.ArticleView,type==PropType.Article or type==PropType.Currency)
    UIUtil.ShowCanvasGroup(self.PartView, type==PropType.Part)
    UIUtil.ShowCanvasGroup(self.TrackSegmentView, type==PropType.TracKSegment)
    UIUtil.ShowCanvasGroup(self.TrackFeature, type==PropType.TrackFeature)
end
function ArticleInfoView:SetArticleViewPosition(view)
    local  mousePosition= mono.GetMousePosition()
    self.clickPoint.transform.position=Vector3(mousePosition.x,mousePosition.y,0)
    local  clickQuadrant=mono.GetClickQuadrant()
    if clickQuadrant==MouseClickQuadrant.LeftDown then
        UIUtil.SetParentGameObject(self.RightUp,view)
    elseif clickQuadrant==MouseClickQuadrant.LeftUp then
        UIUtil.SetParentGameObject(self.RightDown,view)
    elseif clickQuadrant==MouseClickQuadrant.RightDown then
        UIUtil.SetParentGameObject(self.LeftUp,view)
    elseif clickQuadrant==MouseClickQuadrant.RightUp then
        UIUtil.SetParentGameObject(self.LeftDown,view)
    end
end
function ArticleInfoView:SetPartViewPosition(view)
    local  mousePosition= mono.GetMousePosition()
    self.clickPoint.transform.position=Vector3(mousePosition.x,mousePosition.y,0)
    local  clickQuadrant=mono.GetClickQuadrant()
    if clickQuadrant==MouseClickQuadrant.LeftDown then
        UIUtil.SetParentGameObject(self.PartRightUp,view)
    elseif clickQuadrant==MouseClickQuadrant.LeftUp then
        UIUtil.SetParentGameObject(self.PartRightDown,view)
    elseif clickQuadrant==MouseClickQuadrant.RightDown then
        UIUtil.SetParentGameObject(self.PartLeftUp,view)
    elseif clickQuadrant==MouseClickQuadrant.RightUp then
        UIUtil.SetParentGameObject(self.PartLeftDown,view)
    end
end

function ArticleInfoView:SetUIColor(type)
    CommonHelper:SetColorSystem_Title2(self.TitleGroup, type)
    CommonHelper:SetColorSystem_WindowBg1(self.BgGroup, type)
end


function ArticleInfoView:ArticleUI(id,Type1, Type2,Type3, name, des, icon, count)
    CommonHelper:SetGameObjectActive("bg (1)",self.ArticleGroup,false)
    ---@type goodstype_config
    local cfg = ClientDataManager:GetDataTable(ConfigNames.goodstype_config)
    local title = ClientDataManager:GetTemplateString(cfg.GetDataType3(Type1,Type2,Type3))

    CommonHelper:SetText("###typename",self.ArticleGroup,CommonHelper:GetTempStr_Default(TemplateStringID.PartTypeFormat,title))

    CommonHelper:SetText("###title1",self.ArticleGroup,ClientDataManager:Get():GetTemplateString(name))

    CommonHelper:SetText("###articledes",self.ArticleGroup,ClientDataManager:Get():GetTemplateString(des))

    local obj=UIUtil.GetChildInputPath("articlecom",self.ArticleGroup)
    local param = Param_ItemArticleParam()
    CommonHelper:SetItemArticleGroup(obj, self.UIModuleID, id, param)
    if count then
        CommonHelper:SetText("havenum",self.ArticleGroup,tostring(count))
    else
        CommonHelper:SetText("havenum",self.ArticleGroup,"")
    end

end

function ArticleInfoView:CurrencyUI(id,name, des, icon, count)

    CommonHelper:SetText("###typename",self.ArticleGroup,CommonHelper:GetTempStr_Default(TemplateStringID.PartTypeFormat,ClientDataManager:Get():GetTemplateString(name)))

    CommonHelper:SetText("###title1",self.ArticleGroup,ClientDataManager:Get():GetTemplateString(name))

    CommonHelper:SetText("###articledes",self.ArticleGroup,ClientDataManager:Get():GetTemplateString(des))
    local obj=UIUtil.GetChildInputPath("articlecom",self.ArticleGroup)
    local param=Param_PropParam()
    param.id=id
    param.moduleId=self.UIModuleID
    CommonHelper:SetPropGroup(obj,param)

end
---@param cfg dictparts_config_cell
function ArticleInfoView:PartUI(cfg,uiModuleID)
    --{{{ 配件item
    ---@type dictpartbase_config_cell
   local  basecfg=CommonHelper:GetPartBaseCfg(cfg.C_ID)
    if cfg then
        local partobj = UIUtil.GetChild("PartItem", self.PartGroup)
        local param= Param_ItemPartParam()
        param.generation=1
        local type=ItemPartUIType.Simple
        if _isReviewReform then
            param.generation=_isReviewReform.partage
            param.star=_isReviewReform.partstart
            param.lv=_isReviewReform.partlev
            param.awaken=_isReviewReform.partbreak==1
            type=ItemPartUIType.Normal
        end
        if ArticleCell then
            param.quality = ArticleCell:GetPartQuality()
            param.star = ArticleCell:GetStar()
            param.lv = ArticleCell:GetPartLV()
            param.using = ArticleCell:GetCarId()
            param.lock = ArticleCell:GetPartLock()
            param.awaken=ArticleCell:GetAwaken()
            param.generation=ArticleCell:GetGeneration()
            param.downType=ArticleCell:GetPartDownType()
            param.source = ArticleCell:GetPartSource()
            param.expireTime = ArticleCell:GetPartExpTime()
            type=ItemPartUIType.Normal
        end
        CommonHelper:SetItemPartGroup(partobj,self.UIModuleID,cfg.C_ID,type,param)
    end
    --}}}
    CommonHelper:SetText("###partname", self.PartGroup, ClientDataManager:Get():GetTemplateString(cfg.partname))
    CommonHelper:SetText("###partdes", self.PartGroup, ClientDataManager:Get():GetTemplateString(cfg.partdesc))
    CommonHelper:SetText("###partrule", self.PartGroup, CommonHelper:GetTempStr_Default(TemplateStringID.PartSpecialGroove,ClientDataManager:Get():GetTemplateString(cfg.descspecial)))
    CommonHelper:SetText("###partenable", self.PartGroup, CommonHelper:GetTempStr_Default(TemplateStringID.PartOpenGroove,ClientDataManager:Get():GetTemplateString(cfg.descopen)))
    CommonHelper:SetText("###partdisable", self.PartGroup, CommonHelper:GetTempStr_Default(TemplateStringID.PartCloseGroove,ClientDataManager:Get():GetTemplateString(cfg.descclose)))
    CommonHelper:SetText("###typename",self.PartGroup,CommonHelper:GetTempStr_Default(TemplateStringID.PartTypeFormat,CommonHelper:GetGoodsTypeName(GoodsType1.Part, basecfg.parttype)))
    cs_coroutine.start(function()
        CommonHelper:SetGameObjectActive("ScrollViewDesc",self.PartGroup,false)
        coroutine.yield()
        CommonHelper:SetGameObjectActive("ScrollViewDesc",self.PartGroup,true)
    end)
end


function ArticleInfoView:SetTrackSegmentUI(title,name, desc, id)

    --}}}
    CommonHelper:SetText("###partname", self.TrackSegmentGroup, ClientDataManager:Get():GetTemplateString(name))
    CommonHelper:SetText("###partdes", self.TrackSegmentGroup, ClientDataManager:Get():GetTemplateString(desc))
    CommonHelper:SetText("###typename", self.TrackSegmentGroup, CommonHelper:GetTempStr_Default(TemplateStringID.PartTypeFormat,ClientDataManager:Get():GetTemplateString(title)))
    local partobj = UIUtil.GetChild("ItemTrackSegment_Shop", self.TrackSegmentGroup)
    local param=  Param_ItemArticleParam()
    CommonHelper:SetItemTrackSegmentGroup(partobj, self.UIModuleID, id, param)
end

function ArticleInfoView:SetTrackFeatureUI(type,name ,desc,icon )

    --}}}
    CommonHelper:SetText("###typename", self.TrackFeatureGroup, ClientDataManager:Get():GetTemplateString(name))
    CommonHelper:SetText("###partdes", self.TrackFeatureGroup, ClientDataManager:Get():GetTemplateString(desc))
    CommonHelper:GetComponentSetImage("feature",self.TrackFeatureGroup, icon,self.UIModuleID)
    CommonHelper:SetGameObjectActive("BtnClose2", self.gameObject,false )
end