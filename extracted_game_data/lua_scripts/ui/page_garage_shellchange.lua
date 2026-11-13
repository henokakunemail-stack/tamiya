---@class PageGarageShellChange
PageGarageShellChange = class("PageGarageShellChange")

function PageGarageShellChange:initialize()

end

---@param data ArticleCell
function PageGarageShellChange:SetData(root, node,data, funback)
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.GarageView_ResetCar)
        UINotify:Get():SendNotification(UINotifyEvent.GarageView_SetPartListSelect)

        if funback then funback() end
    end)
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        AssembleSubsystem:Get():SendMsg_AlterPartCopy(self.PartData:GetCellID(), self.SelectSift:GetID(),self.SelectSift:GetColor(),self.SelectSift:GetSticker(),self.SelectSift:GetPartShellGridList())
    end)
    CommonHelper:HButtonSetCallback("BtnReset",root,function (hbtn)
        AppearanceSubsystem:Get():SendMsg_ResetSticker(self.PartData:GetCellID(),AppearanceType.Change , 0)
    end)
    self.PartData=data
    self.PartCfg=self.PartData:GetPartConfig()
    self.Root=root
    self.Node = node
    local partobj = UIUtil.GetChild("ItemPartGarage", root)
    if self.PartData then
        local param = Param_ItemPartParam()
        param.quality = self.PartData:GetPartQuality()
        param.star = self.PartData:GetStar()
        param.lv = self.PartData:GetPartLV()
        param.using = self.PartData:GetCarId()
        param.lock = self.PartData:GetPartLock()
        param.awaken=self.PartData:GetAwaken()
        param.generation=self.PartData:GetGeneration()
        param.downType=self.PartData:GetPartDownType()
        param.source = self.PartData:GetPartSource()
        param.expireTime = self.PartData:GetPartExpTime()
        CommonHelper:SetItemPartGroup(partobj, UIModuleID.Garage, self.PartCfg.C_ID, ItemPartUIType.Normal, param)
    end
    self.SelectSift=self.PartData
    if self.PartData:GetChangeIdx()~=0 and KnapsackDataManager:Get():GetArticleByCellID(self.PartData:GetChangeIdx()) then
        self.SelectSift=KnapsackDataManager:Get():GetArticleByCellID(self.PartData:GetChangeIdx())
    end
    local templist = AssembleHelper:GetPartsBySubType(self.PartData)
    self:SetScrollView(templist)
end
function PageGarageShellChange:SetScrollView(datalist)
    --{{{解析数据
    self.ScrollData = {}
    ---@type table<string, ArticleCell[]>
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
            CommonHelper:SetText("###text", itemObj, CommonHelper:GetTempStr_Default(title))
        end
        if type == TittleItemType.Item then
            local datalist = self.SiftList[title]
            ---@type ArticleCell
            local data = datalist[dataIndex + 1]

            CommonHelper:SetGameObjectActive("partlock", itemObj, false)
            CommonHelper:SetGameObjectActive("partselect", itemObj, self.SelectSift:GetCellID() == data:GetCellID())
            CommonHelper:SetGameObjectActive("RedPointPart", itemObj, false)

            local tempobj = UIUtil.GetChild("ItemPart", itemObj)
            local param = Param_ItemPartParam()
            param.quality =data:GetPartQuality()
            param.star = data:GetStar()
            param.lv = data:GetPartLV()
            param.using = data:GetCarId()
            param.lock = data:GetPartLock()
            param.awaken=data:GetAwaken()
            param.generation=data:GetGeneration()
            param.downType=data:GetPartDownType()
            param.source = data:GetPartSource()
            param.expireTime = data:GetPartExpTime()
            CommonHelper:SetItemPartGroup(tempobj, UIModuleID.Garage, data:GetID(), ItemPartUIType.Normal, param, function(data)
                if self.SelectSift:GetCellID()==data:GetCellID() then return end
                self.SelectSift =data
                CommonHelper:MoreRowTitle_Refresh(self.ScrollView, false)
                UINotify:Get():SendNotification(UINotifyEvent.GarageView_PartReview, {data, self.Node:GetGrooveId(),true})
            end,data)
        end


    end)

end
