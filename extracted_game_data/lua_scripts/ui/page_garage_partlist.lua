

--车库左侧，配件列表

---@class PageGaragePartlist
PageGaragePartlist = class("PageGaragePartlist")

function PageGaragePartlist:initialize()

    ---@type CarDetailData
    self.Node = nil
    ---@type AssembleSiftData
    self.SelectSift = nil
end

---@param node AssembleNode
---@param templist table<number, AssembleSiftData>
function PageGaragePartlist:SetData(root, node, templist, funcback, funcreform, funcstar, funlevelup,funColor,funInherit,funChange,funAdjust,funAwake,funadvance)

    self.Root = root
    self.SelectSift = nil
    self.Node = node
    self.SuitCount=0
    CommonHelper:SetGameObjectActive("shitstate1", root, true)
    CommonHelper:SetGameObjectActive("shitstate2", root, false)


    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.GarageView_ResetCar)
        if funcback then funcback() end
    end)
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if self.SelectSift and self.Node then
            if self.SelectSift.Article:GetCellID() == self.Node:GetBagId() then
                CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.GarageSamePartAssemble))
                return
            end
            if self.SelectSift:IsFailDefault() then
                self:ShowTips()
                return
            end
            local cardata = CarDataManager:Get():GetCarDataByCarID(self.Node:GetCarIdx())
            if cardata then
                local carid = cardata:GetID()
                local bagid = self.SelectSift.Article:GetCellID()
                local grooveid = self.Node:GetGrooveId()
                AssembleSubsystem:Get():SendMsg_AssemblePart(carid, grooveid, bagid,AssembleGarageOpenType.Garage)
            end
        end
    end)
    CommonHelper:HButtonSetCallback("BtnRemove",root,function (hbtn)
        CommonHelper:SetUnlockFunc({ GameFunction.PartUnpack }, function()
            if self.SelectSift and self.Node then
                if self.SelectSift.Article:GetCellID() ~= self.Node:GetBagId() then
                    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.GarageNotAssemble))
                    return
                end
                local parttype = self.SelectSift.Article:GetPartType()
                if parttype == PartType.Shell or parttype == PartType.Chassis then
                    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.GarageNotDisAssemble))
                    return
                end

                local cardata = CarDataManager:Get():GetCarDataByCarID(self.Node:GetCarIdx())
                local carid = cardata:GetID()
                local grooveid = self.Node:GetGrooveId()
                AssembleSubsystem:Get():SendMsg_DisassemblePart(carid, grooveid,AssembleGarageOpenType.Garage)
            end
        end)
    end)
    CommonHelper:HButtonSetCallback("BtnReform",root,function (hbtn)
        CommonHelper:SetUnlockFunc({ GameFunction.PartStrong }, function()
            if funcreform then funcreform(self.SelectSift.Article) end
        end)
    end)
    self.BtnStar = CommonHelper:HButtonSetCallback("BtnStar",root,function (hbtn)
        local star = self.SelectSift.Article:GetStar()
        local maxstar = self.SelectSift.Article:GetPartBaseCfg().maxstar
        if star < maxstar then
            if funcstar then funcstar(self.SelectSift.Article) end
        else
            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.GaragePartStarMax))
        end
    end)

    self.BtnColor = CommonHelper:HButtonSetCallback("BtnColor",root,function (hbtn)
        if funColor then funColor(self.SelectSift,self.Node) end
    end)
    self.BtnInherit = CommonHelper:HButtonSetCallback("BtnInherit",root,function (hbtn)
        if funInherit then funInherit(self.SelectSift.Article,self.Node) end
    end)
    self.BtnChange = CommonHelper:HButtonSetCallback("BtnChange",root,function (hbtn)
        if funChange then funChange(self.SelectSift.Article,self.Node) end
    end)
    self.BtnAdjust = CommonHelper:HButtonSetCallback("BtnAdjust",root,function (hbtn)
        if funAdjust then funAdjust(self.SelectSift.Article,self.Node) end
    end)

    --车库觉醒跳转
    self.BtnAwake = CommonHelper:HButtonSetCallback("BtnAwake", root, function(hbtn)
        if not self.SelectSift.Article:GetCanAwaken() then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LabMainGarageNoAwake))
        elseif self.SelectSift.Article:GetAwaken() then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LabMainGarageAwoke))
        else
            if funAwake then
                funAwake(self.SelectSift.Article)
            end
        end
    end)

    --车库进阶跳转
    self.BtnPromoted = CommonHelper:HButtonSetCallback("BtnPromoted", root, function(hbtn)
        if not self.SelectSift.Article:GetCanUpGeneration() then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageLabPartNoPromoted))
        else
            if funadvance then
                funadvance(self.SelectSift.Article)
            end
        end
    end)
    ----还原
    --self.BtnRestore = CommonHelper:HButtonSetCallback("BtnRestore", root, function(hbtn)
    --    if not self.SelectSift.Article:GetCanUpGeneration() then
    --        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageLabPartNoPromoted))
    --    else
    --        if funadvance then
    --            funadvance(self.SelectSift.Article)
    --        end
    --    end
    --end)
    --觉醒还原
    self.BtnRestoreAwake = CommonHelper:HButtonSetCallback("BtnRestoreAwake", root, function(hbtn)
        local boxFunc = function()
            local str =CommonHelper:GetTempStr_Default(TemplateStringID.PartReturnAwakeCostErrorTip)
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, str)
            if ret == MessageBoxHelp.BtnType.OK then
                LabSubsystem:Get():SendMsg_PartReturn(self.SelectSift.Article:GetCellID(),1)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end)
    ----单个配件分解
    --self.BtnResolve = CommonHelper:HButtonSetCallback("BtnResolve", root, function(hbtn)
    --    if not self.SelectSift.Article:GetCanUpGeneration() then
    --        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageLabPartNoPromoted))
    --    else
    --        if funadvance then
    --            funadvance(self.SelectSift.Article)
    --        end
    --    end
    --end)


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
        local curdata = nil
        if self.Node:GetBagId() > -1 then
            curdata = KnapsackDataManager:Get():GetArticleByID(self.Node:GetBagId())
        end
        SkipModuleHelper:Get():ToAssembleFilterView(templist,curdata,function(articleList)
              self:SetScrollView(articleList)
          end,self.SuitCount~=0)
        self.SuitCount=self.SuitCount+1
    end)


    self:SetScrollView(templist)

    self:AutoSelect()
    self:SetBtnColor()
end


function PageGaragePartlist:SetScrollView(datalist)
    --{{{解析数据
    self.ScrollData = {}
    ---@type table<string, AssembleSiftData[]>
    self.SiftList = {}

    local curdata = nil
    if self.Node:GetBagId() > -1 then
        curdata = KnapsackDataManager:Get():GetArticleByID(self.Node:GetBagId())
    end
    local sortlist = CommonHelper:SortPart_AssembleSift(datalist, curdata)

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

            CommonHelper:SetGameObjectActive("partlock", itemObj, data:IsFailDefault())
            CommonHelper:SetGameObjectActive("RedPointPart", itemObj, data.Article:GetIsNew())
            if self.SelectSift then
                CommonHelper:SetGameObjectActive("partselect", itemObj, self.SelectSift.Article:GetCellID() == data.Article:GetCellID())
            else
                CommonHelper:SetGameObjectActive("partselect", itemObj, false)
            end

            local tempobj = UIUtil.GetChild("ItemPart", itemObj)
            local param = Param_ItemPartParam()
            param.quality = data.Article:GetPartQuality()
            param.star = data.Article:GetStar()
            param.lv = data.Article:GetPartLV()
            param.using = data.Article:GetCarId()
            param.lock = data.Article:GetPartLock()
            param.awaken=data.Article:GetAwaken()
            param.downType=data.Article:GetPartDownType()
            param.generation=data.Article:GetGeneration()
            param.source = data.Article:GetPartSource()
            param.expireTime = data.Article:GetPartExpTime()
            CommonHelper:SetItemPartGroup(tempobj, UIModuleID.Garage, data.Article:GetPartConfig().C_ID, ItemPartUIType.Normal, param, function()
                if data.Article:GetCellID()==self.SelectSift.Article:GetCellID() then return end
                self.SelectSift = data
                self:SetBtnColor()
                data.Article:SetNew(false)
                CommonHelper:PlaySfxByGrooveId(self.Node:GetGrooveId())
                CommonHelper:MoreRowTitle_Refresh(self.ScrollView, false)
                UINotify:Get():SendNotification(UINotifyEvent.GarageView_SetPartinfo, {data.Article, self.Node})
                UINotify:Get():SendNotification(UINotifyEvent.GarageView_PartReview, {data.Article, self.Node:GetGrooveId()})
            end)
        end


    end)

end


function PageGaragePartlist:AutoSelect()
    local article = nil
    local bagid = self.Node:GetBagId()
    if bagid > 0 then
        article = KnapsackDataManager:Get():GetArticleByID(bagid)
        local temp = false
        for k,v in pairs(self.SiftList) do
            for i = 1, #v do
                if v[i].Article:GetCellID() == bagid then
                    temp = true
                    self.SelectSift = v[i]
                    break
                end
            end
            if temp then break end
        end
    else
        local title = self.ScrollData[1]
        local datalist = self.SiftList[title.tittle]
        article = datalist[1].Article
        self.SelectSift = datalist[1]
    end

    CommonHelper:MoreRowTitle_Refresh(self.ScrollView, false)

    UINotify:Get():SendNotification(UINotifyEvent.GarageView_SetPartinfo, {article, self.Node})
    if  self.Node:GetPartId(false) ==0 then
        self.SelectSift.Article:SetNew(false)
        UINotify:Get():SendNotification(UINotifyEvent.GarageView_PartReview, {self.SelectSift.Article, self.Node:GetGrooveId()})
    end

end


function PageGaragePartlist:ShowTips()
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

function PageGaragePartlist:UpdateMsg(force)
    if force then
        local templist = AssembleHelper:GetPartsByGroove(self.Node)
        self:SetScrollView(templist)
    else
        CommonHelper:MoreRowTitle_Refresh(self.ScrollView, false)
    end
    self:SetBtnColor()
end
function PageGaragePartlist:SetBtnColor()
    ---@type dictparts_config
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.parts_config)
    ---@type dictparts_config_cell[]
    local list=cfg.GetPartListByBaseIdCanCopy(self.SelectSift.Article:GetPartBaseCfg().C_ID)
    CommonHelper:SetHButtonClick(self.BtnColor,#list>1,true)
    CommonHelper:SetHButtonClick(self.BtnInherit,   UnlockDataManager:Get():IsUnLock(GameFunction.PartShellSkill) and self.SelectSift.Article:GetPartInheritCount()>0,true)
    CommonHelper:SetHButtonClick(self.BtnChange,   UnlockDataManager:Get():IsUnLock(GameFunction.PartShellChange) and self.SelectSift.Article:GetPartConfig().cellifcopy==0,true)
    CommonHelper:SetHButtonClick(self.BtnAdjust, not GameProperties.AssetBundleMode and self.SelectSift.Article:GetPartType()==PartType.Motor,true)
    CommonHelper:SetHButtonClick(self.BtnAwake,UnlockDataManager:Get():IsUnLock(GameFunction.LabIron) and self.SelectSift.Article:GetCanAwaken() and not self.SelectSift.Article:GetAwaken() ,true)
    CommonHelper:SetHButtonClick(self.BtnPromoted,UnlockDataManager:Get():IsUnLock(GameFunction.LabIron) and self.SelectSift.Article:GetCanUpGeneration() ,true)
    CommonHelper:SetHButtonClick(self.BtnRestoreAwake,UnlockDataManager:Get():IsUnLock(GameFunction.LabIron) and self.SelectSift.Article:GetAwaken() and self.SelectSift.Article:GetCarId()==0 ,true)
    CommonHelper:SetGameObjectActive("ReformParent",self.Root,UnlockDataManager:Get():IsUnLock(GameFunction.PartStrong))
   --CommonHelper:SetGameObjectActive("StarParent",self.Root,UnlockDataManager:Get():IsUnLock(GameFunction.PartStrong))

end

