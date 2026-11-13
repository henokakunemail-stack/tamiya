

--车库左侧，配件列表

---@class PageGuideGaragePartlist
PageGuideGaragePartlist = class("PageGuideGaragePartlist")

function PageGuideGaragePartlist:initialize()

    ---@type CarDetailData
    self.Node = nil
    ---@type AssembleSiftData
    self.SelectSift = nil
end

---@param node AssembleNode
---@param templist table<number, AssembleSiftData>
function PageGuideGaragePartlist:SetData(root, node, templist, funcback, funcreform, funcstar, funlevelup)

    self.Root = root
    self.SelectSift = nil
    self.Node = node
    self.SuitCount=0
    CommonHelper:SetGameObjectActive("shitstate1", root, true)
    CommonHelper:SetGameObjectActive("shitstate2", root, false)


    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.GuideGarageView_ResetCar)
        if funcback then funcback() end
    end)
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if self.SelectSift and self.Node then
            UINotify:Get():SendNotification(UINotifyEvent.GuideGarageView_PartChange,{self.SelectSift,self.Node.GrooveId})
            UINotify:Get():SendNotification(UINotifyEvent.GuideGarageView_ChangeMain)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnRemove",root,function (hbtn)
        if self.SelectSift and self.Node then
            UINotify:Get():SendNotification(UINotifyEvent.GuideGarageView_PartRemove,{-1,self.Node.GrooveId})
            UINotify:Get():SendNotification(UINotifyEvent.GuideGarageView_ChangeMain)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnReform",root,function (hbtn)
        CommonHelper:SetUnlockFunc({ GameFunction.PartStrong }, function()
            if funcreform then funcreform(self.SelectSift.Article) end
        end)
    end)
    CommonHelper:HButtonSetCallback("BtnStar",root,function (hbtn)
        local star = self.SelectSift.Article:GetStar()
        local maxstar = self.SelectSift.Article:GetPartBaseCfg().maxstar
        if star < maxstar then
            if funcstar then funcstar(self.SelectSift.Article) end
        else
            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.GaragePartStarMax))
        end
    end)

    --车库觉醒跳转
    self.BtnAwake = CommonHelper:HButtonSetCallback("BtnAwake", root, function(hbtn)
        if not self.SelectSift.Article:GetCanAwaken() then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LabMainGarageNoAwake))
        elseif   self.SelectSift.Article:GetAwaken() then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LabMainGarageAwoke))
        else
        end

    end)

    CommonHelper:HButtonSetCallback("BtnLevelUp",root,function (hbtn)
        local lv = self.SelectSift.Article:GetPartLV()
        ---@type dictcalc_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PartLevelMax)
        local maxlv = tonumber(cfg.varval)
        local playerlv = PlayerDataManager:Get():GetPlayerLV()
        if playerlv > maxlv then playerlv = maxlv end
        if lv < playerlv then
            if funlevelup then funlevelup(self.SelectSift.Article) end
        else
            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.GaragePartLevelupMax))
        end
    end)

    CommonHelper:HButtonSetCallback("BtnSift",root,function (hbtn)
        SkipModuleHelper:Get():ToAssembleFilterView(templist,function(articleList)
            self:SetScrollView(articleList)
        end,self.SuitCount~=0)
        self.SuitCount=self.SuitCount+1
    end)


    self:SetScrollView(templist)

    self:AutoSelect()

end


function PageGuideGaragePartlist:SetScrollView(datalist)
    --{{{解析数据
    self.ScrollData = {}
    ---@type table<string, AssembleSiftData[]>
    self.SiftList = {}

    local curdata = nil
    if self.Node.PartBaseCfg  then
        curdata = self.Node
    end
    local sortlist = CommonHelper:SortPartCfg_AssembleSift(datalist, curdata)
    self.DataList=sortlist
    for i = 1, #sortlist do
        local temp = sortlist[i]
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
            local data = datalist[dataIndex + 1]

            CommonHelper:SetGameObjectActive("partlock", itemObj, false)
            if self.SelectSift then
                CommonHelper:SetGameObjectActive("partselect", itemObj, self.SelectSift.PartCfg.C_ID == data.PartCfg.C_ID)
            else
                CommonHelper:SetGameObjectActive("partselect", itemObj, false)
            end

            local tempobj = UIUtil.GetChild("ItemPart", itemObj)
            local param = Param_ItemPartParam()
            --param.quality = data.Article:GetPartQuality()
            --param.star = data.Article:GetStar()
            --param.lv = data.Article:GetPartLV()
            --param.using = data.Article:GetCarId()
            --param.lock = data.Article:GetPartLock()
            --param.awaken=data.Article:GetAwaken()
            CommonHelper:SetItemPartGroup(tempobj, UIModuleID.GuideGarage, data.PartCfg.C_ID, ItemPartUIType.Normal, param, function()
                self.SelectSift = data
                CommonHelper:MoreRowTitle_Refresh(self.ScrollView, false)
                UINotify:Get():SendNotification(UINotifyEvent.GuideGarageView_SetPartinfo, {self.SelectSift, self.Node})
                UINotify:Get():SendNotification(UINotifyEvent.GuideGarageView_PartReview, {self.SelectSift, self.Node:GetGrooveId()})
            end)
        end


    end)

end


function PageGuideGaragePartlist:AutoSelect()
    local article = nil
    local partid = 0
    if self.Node:GetPartCfg() then
        partid=self.Node:GetPartCfg().C_ID
    end
    if partid > 0 then
        local temp = false
        for k,v in pairs(self.DataList) do
            for i = 1, #v[2] do
                if v[2][i].PartCfg.C_ID == partid then
                    temp = true
                    article=v[2][i]
                    self.SelectSift = v[2][i]
                    break
                end
            end
            if temp then break end
        end
    else
        local title = self.ScrollData[1]
        local datalist = self.SiftList[title.tittle]
        article = datalist[1]
        self.SelectSift = datalist[1]
    end

    CommonHelper:MoreRowTitle_Refresh(self.ScrollView, false)

    UINotify:Get():SendNotification(UINotifyEvent.GuideGarageView_SetPartinfo, {article, self.Node})


end


function PageGuideGaragePartlist:ShowTips()
    if self.SelectSift.File_Using then CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangePartViewFailUsing)) end
    if self.SelectSift.File_OnlyOne then  CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangePartViewFailOnlyOne)) end
    if self.SelectSift.File_Stronger then  CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangePartViewFailStronger)) end
    if self.SelectSift.File_Tail then CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangePartViewFailTail)) end
    if self.SelectSift.File_Hub then  CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangePartViewFailHub)) end
    if self.SelectSift.File_Tyre then CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangePartViewFailTyre)) end
    if self.SelectSift.File_Motor then CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangePartViewFailMotor)) end
    if self.SelectSift.File_DingDing then CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChangePartViewFailDingDing)) end
    if self.SelectSift.File_Exp then CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartIsExp)) end
end

function PageGuideGaragePartlist:UpdateMsg()
    CommonHelper:MoreRowTitle_Refresh(self.ScrollView, false)
end