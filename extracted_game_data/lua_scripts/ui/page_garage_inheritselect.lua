---@class PageGarageInheritSelect
PageGarageInheritSelect = class("PageGarageInheritSelect")

function PageGarageInheritSelect:initialize()

end

---@param data ArticleCell
function PageGarageInheritSelect:SetData(root, data, index,defaultIdx,optionType,funback,funcOk)
    self.Root = root
    self.Article = data
    self.InheritPos = index
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback(data) end
    end)
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if self.InheritList[self.SelectIdx] and self.InheritList[self.SelectIdx].flag then
            if funcOk then funcOk(data,index,self.InheritList[self.SelectIdx].Cfg.C_ID,optionType) end
        else
            if self.InheritList[self.SelectIdx]==nil then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectTips))
                return
            end
            if not self.InheritList[self.SelectIdx].flag then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectTips2))
            end

        end

    end)
    CommonHelper:SetGameObjectActive("shitstate1", root, true)
    CommonHelper:SetGameObjectActive("shitstate2", root, false)
    CommonHelper:HButtonSetCallback("BtnSift",root,function (hbtn)
        UIManager:Get():ShowPersistentView("InheritFilterView", CanvasType.MainCanvas, "InheritFilterView")
        CommonHelper:SetGameObjectActive("shitstate1", root, false)
        CommonHelper:SetGameObjectActive("shitstate2", root, true)
        UINotify:Get():SendNotification(UINotifyEvent.InheritFilterView_SetData, {function(data)
            self:SetScrollView(data,1)
        end})
    end)
    self:SetScrollView(nil,defaultIdx)
end
---@param filterTable
function PageGarageInheritSelect:SetScrollView(filterTable,defaultIdx)
    self.InheritList = {}
    ---@type PartInheritData[]
    local CurPartInheritList=self.Article:GetCurPartInheritList()
    ---@type dictinherit_config
    local cfgData= ClientDataManager:Get():GetDataTable(ConfigNames.dictinherit_config)
    ---@type dictinherit_config_cell[]
    local list=cfgData.GetConfigData()
    for k, v in pairs(list) do
        local flag=true
        for i = 1, #CurPartInheritList do
            if CurPartInheritList[i].InheritId==v.C_ID then
                flag=false
                break
            end
        end
        if filterTable and flag and #filterTable>0 then
            flag=false
            for i = 1, #filterTable do
                if v.AttrIds[1]==filterTable[i] then
                    flag=true
                    break
                end
            end
        end
        if flag then
            local PartList= KnapsackDataManager:Get():GetPartNoChangeListByCfgid(v.OpenCostPart.id,{self.Article})
            local carInherit=(#PartList>=v.OpenCostPart.num) or (PlayerDataManager:Get():CheckCurrencyEnough(v.OpenCostArticle.id,v.OpenCostArticle.num,false))
            table.insert(self.InheritList,{Cfg=v,flag=carInherit})
        end
    end

    table.sort(self.InheritList,function(a, b)
        if a.flag and not b.flag then
            return true
        end
        if not a.flag and b.flag then
            return false
        end
        return a.Cfg.C_ID<b.Cfg.C_ID
    end)

    if defaultIdx==-1 then
        self.SelectIdx=1
    else
        for i, v in ipairs(self.InheritList) do
            if defaultIdx~=-1 then
                if defaultIdx==v.Cfg.C_ID then
                    self.SelectIdx=i
                    break
                end
            end
        end
    end
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.Root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.InheritList, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)

    self:SetCost(self.SelectIdx)
end
function PageGarageInheritSelect:UpdateScrollView(dataIndex, itemObj)

    ---@type dictinherit_config_cell
    local cfg = self.InheritList[dataIndex + 1].Cfg

  CommonHelper:SetText("###name", itemObj, CommonHelper:GetTempStr_Default(cfg.inheritname))

    for i = 1, 2 do
        CommonHelper:SetText("###name"..i,itemObj,CommonHelper:GetAttrName(cfg.LevelAttrs[1].Attrs[i].type))
        CommonHelper:SetText("###value"..i,itemObj,cfg.LevelAttrs[1].Attrs[i].value)
    end
    --{{{详细
    CommonHelper:HButtonSetCallback("BtnDetail",itemObj,function (hbtn)
        CommonHelper:ShowGarageTipsView(GarageTipsTpye.Inherit, hbtn.intData)
    end,cfg.C_ID)
    --}}}

    CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
        if  self.SelectIdx == hbtn.intData then return end
        self.SelectIdx = hbtn.intData
        self:SetCost(hbtn.intData)
        CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
    end,dataIndex+1)
    CommonHelper:SetGameObjectActive("select", itemObj, self.SelectIdx == dataIndex+1)
    CommonHelper:SetGameObjectActive("gray", itemObj, not self.InheritList[dataIndex + 1].flag)
end
function PageGarageInheritSelect:SetCost(dataIndex)
    if self.InheritList[dataIndex]==nil then
        CommonHelper:SetGameObjectActive("cost", self.Root, false)
    else
        CommonHelper:SetGameObjectActive("cost", self.Root, true)
        local temp =self.InheritList[dataIndex].Cfg
        if self.InheritList[dataIndex].flag then
            CommonHelper:SetText("###costcount1",self.Root,CommonHelper:GetTempStr_Default(TemplateStringID.PreferentialBagCount,temp.OpenCostPart.num))
            CommonHelper:SetText("###costcount2",self.Root,CommonHelper:GetTempStr_Default(TemplateStringID.PreferentialBagCount,temp.OpenCostArticle.num))
        else
            CommonHelper:SetText("###costcount1",self.Root,CommonHelper:GetTempStr_Default(TemplateStringID.PreferentialBagNoCount,temp.OpenCostPart.num))
            CommonHelper:SetText("###costcount2",self.Root,CommonHelper:GetTempStr_Default(TemplateStringID.PreferentialBagNoCount,temp.OpenCostArticle.num))
        end

        local obj1=UIUtil.GetChild("ItemCom_1",self.Root)
        local obj2=UIUtil.GetChild("ItemCom_2",self.Root)
        CommonHelper:SetItemComGroup(obj1, UIModuleID.Garage, temp.OpenCostPart.id, nil, function(index)
            CommonHelper:ShowPartInfoByCfgId(temp.OpenCostPart.id, UIModuleID.OptionalGift, false)
        end)
        CommonHelper:SetItemComGroup(obj2, UIModuleID.Garage, temp.OpenCostArticle.id, nil, function(index)
            CommonHelper:ShowPartInfoByCfgId(temp.OpenCostArticle.id, UIModuleID.Garage, false)
        end)
    end

end