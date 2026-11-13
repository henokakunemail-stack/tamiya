---@class InheritLevelCell
---@field id
---@field type
---@field data ArticleCell
---@field quality
---@field select
---@field count=0
---@field index=0

---@class InheritLevelView : ViewBase
InheritLevelView = class("InheritLevelView", ViewBase)

function InheritLevelView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "InheritLevelViewAction")
end
local ArticleTypePart=0
local ArticleTypeArticle=1
local AddExp=0
local AddLevel=0
local AddPart=0
local AddArticle=0
local TogSelectArticle=-1
local AddMaxExp=0
local TogAll=false
local SelectQuality=1
local  PlayerSliderCount=0
---@type InheritLevelCell[][]
local articleList={}
local tempExpList={}
local BtnCloseDropDownFlag=false
function InheritLevelView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("InheritLevelView")
    end)
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("InheritLevelView")
    end)
    CommonHelper:HButtonSetCallback("BtnCloseDropDown",self.gameObject,function (hbtn)
        BtnCloseDropDownFlag= not BtnCloseDropDownFlag
        CommonHelper:SetGameObjectActive("BtnCloseDropDown",self.gameObject,BtnCloseDropDownFlag)
        CommonHelper:DropDown_PopList(self.DropDown)
    end)
    CommonHelper:HButtonSetCallback("BtnSure",self.gameObject,function (hbtn)
        local idstr=""
        local numstr=""
        local ImportantIds={}
        local tableRes={}
        for k, v in pairs(self.CellList) do
            if TogSelectArticle==ArticleTypePart then
                if v.type==ArticleTypePart and v.select  then
                    if v.data:GetPartQuality()>=5  then
                        local temp=RewardData()
                        temp:SetDataIdNum(v.data:GetID(),1)
                       table.insert(ImportantIds,temp)
                    end
                    table.insert(tableRes,{v.data:GetCellID(),v.count})
                end
            end
            if TogSelectArticle==ArticleTypeArticle then
                if v.type==ArticleTypeArticle and v.count>0  then
                    table.insert(tableRes,{v.data:GetID(),v.count})
                end
            end
        end
        for i = 1, #tableRes do
            if i<#tableRes then
                idstr=idstr..tableRes[i][1]..":"
                numstr=numstr..tableRes[i][2]..":"
            else
                idstr=idstr..tableRes[i][1]
                numstr=numstr..tableRes[i][2]
            end
        end
        if not CommonHelper:IsNullOrEmpty(idstr) then
            if #ImportantIds>0 then
                local boxFunc = function()
                    local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil,CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectPart5),nil,nil,nil,nil,nil,nil,MessageBoxHelp.ViewType.Article,ImportantIds)
                    if ret == MessageBoxHelp.BtnType.OK then
                        if TogSelectArticle==ArticleTypePart then
                            ReformSubsystem:Get():SendMsg_InheritLevelUp(self.ArticleData:GetCellID(),self.InheritData.InheritId,idstr,"0","0")
                        end
                        if TogSelectArticle==ArticleTypeArticle then
                            ReformSubsystem:Get():SendMsg_InheritLevelUp(self.ArticleData:GetCellID(),self.InheritData.InheritId,"0",idstr,numstr)
                        end
                    end
                end
                MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
            else
                if TogSelectArticle==ArticleTypePart then
                    ReformSubsystem:Get():SendMsg_InheritLevelUp(self.ArticleData:GetCellID(),self.InheritData.InheritId,idstr,"0","0")
                end
                if TogSelectArticle==ArticleTypeArticle then
                    ReformSubsystem:Get():SendMsg_InheritLevelUp(self.ArticleData:GetCellID(),self.InheritData.InheritId,"0",idstr,numstr)
                end
            end

        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InheritItemLevelNoSelect))
        end

    end)
    self.TogPart= CommonHelper:HButtonSetCallback("TogPart",self.gameObject,function (hbtn)
        SelectQuality=5
        TogSelectArticle=ArticleTypePart
        TogAll=false
        self:SetTogAll(true)
        self:SetTogSelectType()
    end)
    self.TogArticle=  CommonHelper:HButtonSetCallback("TogArticle",self.gameObject,function (hbtn)
        SelectQuality=5
        TogSelectArticle=ArticleTypeArticle
        TogAll=false
        self:SetTogAll(true)
        self:SetTogSelectType()
    end)
    self.TogAll=CommonHelper:HButtonSetCallback("TogAll",self.gameObject,function (hbtn)
        local count=0
        for k, v in pairs(tempExpList) do
            for m, n in pairs(articleList[v]) do
              count=count+1
            end
        end
        if count>0 then
            TogAll=not TogAll
            self:SetTogAll(false)
        end
    end)
    self.DropDown = self:GetChildWight("DropDown_H", typeof(UIDropDown))
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("TitleScrollView", self.gameObject, typeof(MoreRowScrollViewTittle))
end
function InheritLevelView:OnOpen()

end
function InheritLevelView:SetTogSelectType()
    CommonHelper:SetToggleState(self.TogPart,TogSelectArticle==ArticleTypePart)
    CommonHelper:SetToggleState(self.TogArticle,TogSelectArticle==ArticleTypeArticle)
    CommonHelper:SetGameObjectActive("TogAll",self.gameObject,TogSelectArticle==ArticleTypePart)
    CommonHelper:SetGameObjectActive("DropDown_H",self.gameObject,TogSelectArticle==ArticleTypePart)
    self:SetSelectQuality()
    self:SetScrollView()
end
function InheritLevelView:SetTogAll(clear)
    CommonHelper:SetToggleState(self.TogAll,TogAll)
    if clear or not TogAll then
        for k, v in pairs(self.CellList) do
            v.select=TogAll
            v.count=0
        end
    end
    if TogAll then
        local addExp=0
        local count=0
        for k, v in pairs(tempExpList) do
            for m, n in pairs(articleList[v]) do
                if not self.CellList[n.index].select and  self:CalcMaxLevel(n.data:GetInheritExp(),n.index,false,addExp) then
                    self.CellList[n.index].select=not self.CellList[n.index].select
                    if self.CellList[n.index].select then
                        count=count+1
                        addExp=addExp+self.CellList[n.index].data:GetInheritExp()
                    end
                end
            end
        end
        self:SetUpLevel(ArticleTypePart,addExp,count)
    else
        AddPart=0
        AddArticle=0
        AddExp=0
        AddLevel=0
        self:SetUpLevel(-1)
    end
    cs_coroutine.start(function()
        coroutine.yield()
        CommonHelper:MoreRowTitle_Refresh(self.ScrollView,false)
    end)
end

function InheritLevelView:CalcMaxLevel(addExp,itemIdx,istips,addTempExp)
    local flag=true
    addTempExp=addTempExp or 0
    if self.CellList[itemIdx] then
        if not self.CellList[itemIdx].select then
            local MaxExp=self.InheritData.MaxExp
            flag = not ((self.InheritData.CurExp+AddExp+addTempExp)>=MaxExp)
        end
    else

    end
    if not  flag and istips then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InheritItemSelectFail))
    end
    return flag
end
function InheritLevelView:OnClose()
    AddLevel=0
    PlayerSliderCount=0
end
function InheritLevelView:SetScrollView()
    ---@type InheritLevelCell[]
    articleList={}
    tempExpList={}
    for k, v in pairs(self.CellList) do
        if v.type==TogSelectArticle and v.quality<=SelectQuality and v.data:GetInheritExp()>0 then
            if articleList[v.data:GetInheritExp()]==nil then
                articleList[v.data:GetInheritExp()]={}
                table.insert(tempExpList,v.data:GetInheritExp())
            end
            table.insert(articleList[v.data:GetInheritExp()],v)
        end
    end
    for k, v in pairs(articleList) do
        table.sort(v,function(a, b)
            if a.quality>b.quality then
                return false
            end
            if a.quality<b.quality then
                return true
            end
            return a.data:GetInheritExp()<b.data:GetInheritExp()

        end)
    end
    table.sort(tempExpList,function(a, b)
        return a<b
    end)
    self.ScrollData={}
    for k, v in pairs(tempExpList) do
        local temp = MoreRowScrollViewTittleGroup()
        temp.tittle = v
        temp.totle = #articleList[v]
        temp.groupIndex = v
        table.insert(self.ScrollData, temp)
    end
    CommonHelper:MoreRowTitle_Init(self.ScrollView, self.ScrollData, 5,function(title, tittleIdx, itemObj, type ,dataIndex, scroll)
        if type==TittleItemType.Title then
            CommonHelper:SetText("###text",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.InheritItemExpValue,title))
        end
        if type == TittleItemType.Item then
            local  PartItem=CommonHelper:SetGameObjectActive("PartItem",itemObj,TogSelectArticle==ArticleTypePart)
            local ArticleItem= CommonHelper:SetGameObjectActive("ArticleItem",itemObj,TogSelectArticle==ArticleTypeArticle)
            ---@type ArticleCell
            local data=articleList[tittleIdx][dataIndex+1].data
            CommonHelper:SetGameObjectActive("TrackSegmentItem",itemObj,TogSelectArticle==2)
            if TogSelectArticle==ArticleTypePart then
                local param = Param_ItemPartParam()
                param.quality = data:GetPartQuality()
                param.star = data:GetStar()
                param.lv = data:GetPartLV()
                param.using = data:GetCarId()
                param.lock = data:GetPartLock()
                param.awaken=data:GetAwaken()
                param.downType=data:GetPartDownType()
                param.generation=data:GetGeneration()
                param.source = data:GetPartSource()
                param.expireTime = data:GetPartExpTime()
                CommonHelper:SetItemPartGroup(PartItem, UIModuleID.Garage,data:GetID(), ItemPartUIType.Normal, param, function(index)
                    if self.CellList[index].type==ArticleTypePart and self:CalcMaxLevel(self.CellList[index].data:GetInheritExp(),index,true) then
                        self.CellList[index].select=not self.CellList[index].select
                        if self.CellList[index].select then
                            self:SetUpLevel(ArticleTypePart,self.CellList[index].data:GetInheritExp(),1)
                        else
                            self:SetUpLevel(ArticleTypePart,-self.CellList[index].data:GetInheritExp(),-1)
                        end
                        cs_coroutine.start(function()
                            coroutine.yield()
                            CommonHelper:MoreRowTitle_Refresh(self.ScrollView,false)
                        end)
                    end
                end,articleList[tittleIdx][dataIndex+1].index)
            elseif TogSelectArticle==ArticleTypeArticle then
                CommonHelper:SetText("###articlecount",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.InheritItemArticleCount,self.CellList[articleList[tittleIdx][dataIndex+1].index].count,self.CellList[articleList[tittleIdx][dataIndex+1].index].data:GetCount()))
                CommonHelper:SetItemArticleGroup(ArticleItem, UIModuleID.Garage, data:GetID(), nil, function(index)
                    if self.CellList[index].type==ArticleTypeArticle then
                        local max=math.floor((self.InheritData.MaxExp-self.InheritData.CurExp-AddExp)/self.CellList[index].data:GetInheritExp())
                        local orgCount=self.CellList[index].count
                        if self.CellList[index].count~=0 then
                            AddArticle=AddArticle-self.CellList[index].count
                            AddExp=AddExp-(self.CellList[index].data:GetInheritExp()*self.CellList[index].count)
                            max=max+self.CellList[index].count
                        end
                        CommonHelper:ShowArticleSelectCountView(UIModuleID.Garage,self.CellList[index].data,max,0,self.CellList[index].count,function(count)
                            if self:CalcMaxLevel(self.CellList[index].data:GetInheritExp()*count,index,true) then
                                self.CellList[index].count=count
                                self:SetUpLevel(ArticleTypeArticle,self.CellList[index].data:GetInheritExp()*count,count)
                                cs_coroutine.start(function()
                                    coroutine.yield()
                                    CommonHelper:MoreRowTitle_Refresh(self.ScrollView,false)
                                end)
                            end
                        end,function()
                            self.CellList[index].count=orgCount
                            self:SetUpLevel(ArticleTypeArticle,self.CellList[index].data:GetInheritExp()*orgCount,orgCount)
                            cs_coroutine.start(function()
                                coroutine.yield()
                                CommonHelper:MoreRowTitle_Refresh(self.ScrollView,false)
                            end)
                        end)
                    end
                end,articleList[tittleIdx][dataIndex+1].index)
            end
            CommonHelper:SetGameObjectActive("###articlecount",itemObj,articleList[tittleIdx][dataIndex+1].type==ArticleTypeArticle)
            local Toggle= CommonHelper:HButtonSetCallback("TogSelectRed", itemObj, function(data)
                if self.CellList[data.intData].type==ArticleTypePart and self:CalcMaxLevel(self.CellList[data.intData].data:GetInheritExp(),data.intData,true) then
                    self.CellList[data.intData].select=not self.CellList[data.intData].select
                    if self.CellList[data.intData].select then
                        self:SetUpLevel(ArticleTypePart,self.CellList[data.intData].data:GetInheritExp(),1)
                    else
                        self:SetUpLevel(ArticleTypePart,-self.CellList[data.intData].data:GetInheritExp(),-1)
                    end
                    cs_coroutine.start(function()
                        coroutine.yield()
                        CommonHelper:MoreRowTitle_Refresh(self.ScrollView,false)
                    end)
                end
            end,articleList[tittleIdx][dataIndex+1].index)
            CommonHelper:SetGameObjectActive("hover",Toggle.gameObject, self.CellList[articleList[tittleIdx][dataIndex+1].index].select or self.CellList[articleList[tittleIdx][dataIndex+1].index].count>0 )
        end
    end)
end
---@param data ArticleCell
function InheritLevelView:SetData(data,index)
    AddPart=0
    AddArticle=0
    AddExp=0
    AddLevel=0
    TogSelectArticle=ArticleTypePart
    TogAll=false
    SelectQuality=5
    ---@type InheritLevelCell[]
    self.CellList={}
    ---@return table<number, ArticleCell>
    self.PartList=  KnapsackDataManager:Get():GetPartNoChangeList()
    local articleType= CommonHelper:GetDictCalcData(CommonCfgKey.InheritLevelArticleKey,true)
    self.ArticleList= KnapsackDataManager:Get():GetArticleListByTypes(stringSplitToNumber(articleType,':'))
    for i = 1, #self.PartList do
        table.insert(self.CellList,{type=ArticleTypePart,data=self.PartList[i],select=false,index=#self.CellList+1,quality=self.PartList[i]:GetPartQuality(),count=0})
    end
    for i = 1, #self.ArticleList do
        table.insert(self.CellList,{type=ArticleTypeArticle,data=self.ArticleList[i],select=false,index=#self.CellList+1,quality=self.ArticleList[i]:GetArticleConfig().propsgrade,count=0})
    end
    self.ArticleData=data
    ---@param PartInheritData
    self.InheritData=data:GetCurPartInheritList()[index]
    self:SetTogSelectType()
    self:SetTogAll(true)
    CommonHelper:SetText("###inheritname",self.gameObject,CommonHelper:GetTempStr_Default(self.InheritData.Cfg.inheritname))
    CommonHelper:SetText("###CurLevel",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.InheritItemLevel,self.InheritData.Level))
    BtnCloseDropDownFlag=false
    CommonHelper:SetGameObjectActive("BtnCloseDropDown",self.gameObject,false)
    CommonHelper:InitDropDown(self.DropDown, 6, function(uiDropDown, item, index)
        for i = 1, 6 do
            CommonHelper:SetGameObjectActive("quality"..i,item,index+1==i)
        end
    end, function(index)
        BtnCloseDropDownFlag= not BtnCloseDropDownFlag
        CommonHelper:SetGameObjectActive("BtnCloseDropDown",self.gameObject,BtnCloseDropDownFlag)
        SelectQuality=index+1
        self:SetSelectQuality()
        self:SetScrollView()
        TogAll=false
        self:SetTogAll(true)
    end,SelectQuality-1,true,function()
        BtnCloseDropDownFlag= not BtnCloseDropDownFlag
        CommonHelper:SetGameObjectActive("BtnCloseDropDown",self.gameObject,BtnCloseDropDownFlag)
    end)
    self:SetUpLevel(-1)
end
function InheritLevelView:SetSelectQuality()
    for i = 1, 5 do
        CommonHelper:SetGameObjectActive("selectquality/quality"..i,self.gameObject,SelectQuality==i)
    end
end
function InheritLevelView:SetUpLevel(type,exp,count)
    if self.cor then
        cs_coroutine.stop(self.cor)
        self.cor=nil
    end
    local orgAddExp=AddExp
    local orgAddLevel=1
    if AddLevel>1 then
        orgAddLevel=AddLevel
    end
    AddLevel=1
   local AddShowLevel=0
   local AddShowExp=0
    AddMaxExp=0
    if type==ArticleTypePart then
        AddPart=AddPart+count
        AddExp=AddExp+exp
    end
    if type==ArticleTypeArticle then
        AddArticle=AddArticle+count
        AddExp=AddExp+exp
    end
    if self.InheritData.CurExp+AddExp>self.InheritData.NextExp then
        AddMaxExp=self.InheritData.Cfg.LevelAttrs[self.InheritData.Level].NeedExp
        AddShowExp=self.InheritData.Cfg.LevelAttrs[self.InheritData.Level].NeedExp
        for i = self.InheritData.Level+1, #self.InheritData.Cfg.LevelAttrs-1 do
            if self.InheritData.CurExp+AddExp>AddMaxExp then
                AddMaxExp=AddMaxExp+self.InheritData.Cfg.LevelAttrs[i].NeedExp
                AddLevel=AddLevel+1
            end
        end
        for i = self.InheritData.Level, #self.InheritData.Cfg.LevelAttrs do
            if self.InheritData.CurExp+AddExp>=AddShowExp then
                AddShowExp=AddShowExp+self.InheritData.Cfg.LevelAttrs[i].NeedExp
                AddShowLevel=AddShowLevel+1
            end
        end
    end
    CommonHelper:SetText("###costpart",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.InheritCostPart,AddPart))
    CommonHelper:SetText("###costarticle",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.InheritCostArticle,AddArticle))
    CommonHelper:SetText("###Level",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.InheritNextLevelView,self.InheritData.Level+AddShowLevel,self.InheritData.MaxLevel))
    if AddMaxExp<=0 then
        CommonHelper:SetText("###needexp",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.InheritItemAddMaxExp,self.InheritData.CurExp,AddExp,self.InheritData.NextExp))
    else
        AddMaxExp=AddMaxExp-self.InheritData.NextExp
        CommonHelper:SetText("###needexp",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.InheritItemAddMaxExp,self.InheritData.CurExp,AddExp,self.InheritData.NextExp+AddMaxExp))
    end
    local  sliderCount=AddLevel-orgAddLevel
    if sliderCount<=1 or type==-1 then
        CommonHelper:SetSliderAni("ExpSlider", self.gameObject, (self.InheritData.CurExp+AddExp)/(self.InheritData.NextExp+AddMaxExp),nil,0.2)
    elseif sliderCount>1 then
        if PlayerSliderCount==0 then
            PlayerSliderCount=sliderCount
            CommonHelper:SetSliderAni("ExpSlider", self.gameObject, 1,nil,0.1)
            PlayerSliderCount=PlayerSliderCount-1
            cs_coroutine.start(function()
                while PlayerSliderCount>0 do
                    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
                    if PlayerSliderCount==1 then
                        CommonHelper:SetSlider("ExpSlider",  self.gameObject,0)
                        CommonHelper:SetSliderAni("ExpSlider", self.gameObject, (self.InheritData.CurExp+AddExp)/(self.InheritData.NextExp+AddMaxExp),nil,0.2)
                    else
                        CommonHelper:SetSlider("ExpSlider",  self.gameObject,0)
                        CommonHelper:SetSliderAni("ExpSlider", self.gameObject, 1,nil,0.1)
                    end
                    PlayerSliderCount=PlayerSliderCount-1
                end
            end)
        else
            PlayerSliderCount=PlayerSliderCount+sliderCount-1
        end
    end
    CommonHelper:SetText("attrtype/###name1",self.gameObject,CommonHelper:GetAttrName(self.InheritData.Cfg.LevelAttrs[self.InheritData.Level+AddLevel].Attrs[1].type))
    CommonHelper:SetText("attrtype/###name2",self.gameObject,CommonHelper:GetAttrName(self.InheritData.Cfg.LevelAttrs[self.InheritData.Level+AddLevel].Attrs[2].type))
    CommonHelper:SetText("attrtype/###value1",self.gameObject,self.InheritData.Cfg.LevelAttrs[self.InheritData.Level+AddLevel].Attrs[1].value)
    CommonHelper:SetText("attrtype/###value2",self.gameObject,self.InheritData.Cfg.LevelAttrs[self.InheritData.Level+AddLevel].Attrs[2].value)
end