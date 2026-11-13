
--车库右侧，

---@class PageGaragePartColor
PageGaragePartColor = class("PageGaragePartColor")

function PageGaragePartColor:initialize()
    ---@type ArticleCell
    self.Article = nil
    self.Root = nil
    ---@type AssembleNode
    self.Node=nil
end

---@param node AssembleNode
---@param data AssembleSiftData
function PageGaragePartColor:SetData(root, data, node,funback,funsure)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if funsure then funsure(self.Article, self.SelectSift) end
    end)
    self.Node=node
    self.Article=data.Article
    self.Root=root
    ---@type dictparts_config_cell
    self.SelectSift= self.Article:GetPartConfig()
    local templist = AssembleHelper:GetPartCfgsByBaseId(self.Article)
    self:SetScrollView(templist)
    self:SetCurData()
end


function PageGaragePartColor:SetScrollView(datalist)
    --{{{解析数据
    self.ScrollData = {}
    ---@type table<string, dictparts_config[]>
    self.SiftList = {}
    for i = 1, #datalist do
        local temp = datalist[i]
        local title = temp[1]
        local valuelist = temp[2]
        self.SiftList[title] = valuelist
        local temp = MoreRowScrollViewTittleGroup()
        temp.tittle = title
        temp.totle = #valuelist
        temp.groupIndex = i
        table.insert(self.ScrollData, temp)
    end
    --}}}



    self.ScrollView = UIUtil.GetTypeChildWightByParent("TitleScrollView", self.Root, typeof(MoreRowScrollViewTittle))
    CommonHelper:MoreRowTitle_Init(self.ScrollView, self.ScrollData, 4,function(title, tittleIdx, itemObj, type ,dataIndex, scroll)
        if type == TittleItemType.Title then
            CommonHelper:SetText("###text", itemObj, title)
        end
        if type == TittleItemType.Item then
            local datalist = self.SiftList[title]
            ---@type dictparts_config_cell
            local data = datalist[dataIndex + 1]

            CommonHelper:SetGameObjectActive("partlock", itemObj, false)
            CommonHelper:SetGameObjectActive("partselect", itemObj, self.SelectSift.C_ID == data.C_ID)
            CommonHelper:SetGameObjectActive("RedPointPart", itemObj, false)

            local tempobj = UIUtil.GetChild("ItemPart", itemObj)
            local param = Param_ItemPartParam()
            param.quality = self.Article:GetPartQuality()
            param.star = self.Article:GetStar()
            param.lv = self.Article:GetPartLV()
            param.using = self.Article:GetCarId()
            param.lock = self.Article:GetPartLock()
            param.awaken=self.Article:GetAwaken()
            param.downType=self.Article:GetPartDownType()
            param.generation=self.Article:GetGeneration()
            param.source = self.Article:GetPartSource()
            param.expireTime = self.Article:GetPartExpTime()
            CommonHelper:SetItemPartGroup(tempobj, UIModuleID.Garage, data.C_ID, ItemPartUIType.Normal, param, function(data)
                if self.SelectSift.C_ID==data.C_ID then return end
                self.SelectSift =data
                CommonHelper:MoreRowTitle_Refresh(self.ScrollView, false)
                UINotify:Get():SendNotification(UINotifyEvent.GarageView_SetPartinfoByCfg, {self.Article, self.Node,data})
                UINotify:Get():SendNotification(UINotifyEvent.GarageView_PartReviewByCfg, {self.SelectSift.C_ID, self.Article,self.Node:GetGrooveId()})
            end,data)
        end


    end)

end


function PageGaragePartColor:SetCurData()
    local temp=UIUtil.GetChild("ItemCurPart",self.Root)
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
    CommonHelper:SetItemPartGroup(temp, UIModuleID.Garage, self.Article:GetID(), ItemPartUIType.Normal, param)
    CommonHelper:SetText("curName/###name",self.Root,CommonHelper:GetTempStr_Default(self.Article:GetPartConfig().partname))
end



