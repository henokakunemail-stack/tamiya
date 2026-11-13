

--车库左侧，配件信息

---@class PageRaceAssembleGaragePartinfo
PageRaceAssembleGaragePartinfo = class("PageRaceAssembleGaragePartinfo")

function PageRaceAssembleGaragePartinfo:initialize()
    self.TogIdx = 1
    ---@type ArticleCell
    self.PartData = nil
    ---@type AssembleNode
    self.NodeData = nil
    self.TogLockIdx = 1
    self.PartCfg=0
end

---@param data ArticleCell
---@param node AssembleNode
---@param KnapsackDataManager KnapsackDataManager
function PageRaceAssembleGaragePartinfo:SetData(root, data, node,KnapsackDataManager)
    --self.TogIdx = -1
    self.PartData = data
    self.NodeData = node
    self.PartCfg=self.PartData:GetPartConfig()
    self.KnapsackDataManager=KnapsackDataManager
    self.ObjBase = UIUtil.GetChild("groupbase", root)
    self.ObjInfo = UIUtil.GetChild("groupinfo", root)
    self.ObjAttr = UIUtil.GetChild("groupattr", root)
    self.ObjSkill = UIUtil.GetChild("groupskill", root)
    self.ObjOther = UIUtil.GetChild("groupother", root)

    self.Toggle = {}
    for i = 1, 4 do
        local tog = CommonHelper:HButtonSetCallback("Toggle"..i, root,function (hbtn)
            self:OnClickTogPage(i, true)
        end)
        table.insert(self.Toggle, tog)
    end

    self.LockToggle = {}
    for i = 1, 7 do
        local tog = CommonHelper:HButtonSetCallback("lockcolor"..i, self.ObjOther,function (hbtn)
            self:OnClickTogPartLock(i, true)
        end)
        table.insert(self.LockToggle, tog)
    end
    self.TogUnlock = CommonHelper:HButtonSetCallback("lockcolornil", self.ObjOther,function (hbtn)
        self:OnClickTogPartLock(0, true)
    end)
    self.BtnLockChange = CommonHelper:HButtonSetCallback("BtnSure", self.ObjInfo,function (hbtn)
        self:OnClickBtnChangeLock(self.PartData:GetPartLock())
    end)

    self:SetGroupBase()
    self:AutoSelect()
end

function PageRaceAssembleGaragePartinfo:AutoSelect()
    self:OnClickTogPage(self.TogIdx, false)
end

function PageRaceAssembleGaragePartinfo:OnClickTogPage(idx, ischeck)
    if ischeck then
        if self.TogIdx == idx then return end
    end
    self.TogIdx = idx

    for i = 1, #self.Toggle do
        CommonHelper:SetToggleState(self.Toggle[i], idx == i)
        CommonHelper:SetBtnDelayClick(self.Toggle[i], 0.5,false)
    end

    CommonHelper:TweenGroupUILeft("tween", self.ObjInfo, idx == 1)
    CommonHelper:TweenGroupUILeft("tween", self.ObjAttr, idx == 2)
    CommonHelper:TweenGroupUILeft("tween", self.ObjSkill, idx == 3)
    CommonHelper:TweenGroupUILeft("tween", self.ObjOther, idx == 4)

    if idx == 1 then self:SetGroupInfo(true) end
    if idx == 2 then self:SetGroupReform() end
    if idx == 3 then self:SetGroupSkill() end
    if idx == 4 then self:SetGroupOther() end
end



function PageRaceAssembleGaragePartinfo:SetGroupBase()

    --CommonHelper:SetText("###fightvalue", self.ObjBase, string.format("%0.0f", self.PartData:GetPartScore()) )

    local partobj = UIUtil.GetChild("ItemPartGarage", self.ObjBase)
    if self.PartData then
        CommonHelper:SetText("###partname", self.ObjBase, ClientDataManager:Get():GetTemplateString(self.PartCfg.partname))


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



    ---@type table<number, PartAttrData>
    local oldattrs = {}
    if self.NodeData:GetBagId() > -1 then
        local data = self.KnapsackDataManager:GetArticleByCellID(self.NodeData:GetBagId())
        if data then
            oldattrs = data:GetPartFiveAttrs()
        end
    end
    local attrs = self.PartData:GetPartFiveAttrs()
    for i = 1, 5 do
        local obj = UIUtil.GetChild("baseattr"..i, self.ObjBase)
        local data = attrs[i]
        local olddata = oldattrs[i]
        CommonHelper:SetText("###name", obj, CommonHelper:GetAttrName(data.type))
        CommonHelper:SetText("###value", obj, CommonHelper:GetAttrValue(data.type, data.value))


        local lv = CommonHelper:GetAttrLV(data.attrCfg, data.value)
        for i = 1, 6 do CommonHelper:SetGameObjectActive("lvbg"..i, obj, i == lv) end
        for i = 1, 6 do CommonHelper:SetGameObjectActive("valuelv"..i, obj, i <= lv) end


        CommonHelper:HButtonSetCallback("BtnItem",obj,function (hbtn)
            CommonHelper:ShowGarageTipsView(GarageTipsTpye.BaseAttr, data.type, CommonHelper:GetAttrValue(data.type, data.value))
        end)
        if self.NodeData:GetBagId() == self.PartData:GetID() then
            CommonHelper:SetText("###delta", obj, "")
        else
            local oldvalue = 0
            if olddata then oldvalue = olddata.value end
            local newvalue = data.value
            local value = CommonHelper:GetAttrValue(data.type, math.floor(newvalue) - math.floor(oldvalue))

            if oldvalue > newvalue then
                CommonHelper:SetText("###delta", obj, tostring(value))
            elseif oldvalue < newvalue then
                CommonHelper:SetText("###delta", obj, tostring(value))
            else
                CommonHelper:SetText("###delta", obj, "")
            end

        end

    end


end

function PageRaceAssembleGaragePartinfo:SetGroupInfo(isresetPos)

    local TitleScrollView = UIUtil.GetTypeChildWightInputPath("TitleScrollView", self.ObjInfo, typeof(TitleScrollView))
    local specialGroup=UIUtil.GetChildInputPath("partspecial",self.ObjInfo)
    local scrollView=UIUtil.GetTypeChildWightByParent("ScrollView_trackfeature",specialGroup,typeof(InfinityScrollView))
    if specialGroup then
        CommonHelper:InitScroll_OneRow(scrollView, 1, function(dataIndex, itemObj, scroll)
            ---@type sign_config_cell
            local cfg= CommonHelper:GetTableDataByID(ConfigNames.sign_config,self.PartData:GetPartConfig().sign)
            local temp= CommonHelper:GetComponentSetImage("feature", itemObj, cfg.icon,UIModuleID.Garage)
            CommonHelper:SetText("###featurename", itemObj, CommonHelper:GetTempStr_Default(cfg.name))
            CommonHelper:HButtonSetCallback("Btn",itemObj,function(btndata)
                CommonHelper:ShowTrackFeatureByCfgId(btndata.intData)
            end,self.PartData:GetPartConfig().sign)
        end,nil,true)
    end
    self:OnClickTogPartLock(self.PartData:GetPartLock(), false)
    if  isresetPos then
        --{{{二级属性
        local attrs = self.PartData:GetPartSecondAttrs()

        local sortlist = {}

        ---@type table<number, table<number, PartAttrData>>
        local secondAttrs = {}
        for i = 1, #attrs do
            local typename = CommonHelper:GetTempStr_Default(attrs[i].attrCfg.tagName)
            if secondAttrs[typename] == nil then
                secondAttrs[typename] = {}
                table.insert(sortlist, {attrs[i].attrCfg.tag, typename})
            end
            table.insert(secondAttrs[typename], attrs[i])
        end

        table.sort(sortlist, function (a, b) return a[1] < b[1] end)

        local temp = {}
        for i = 1, #sortlist do
            local key = sortlist[i][2]
            table.sort(secondAttrs[key],function (a, b) return a.type < b.type end)
            table.insert(temp, key)
            table.insert(temp, #secondAttrs[key])
        end

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
    else
        CommonHelper:TitleScrollView_RefreshCurList(TitleScrollView, false)
    end


end

function PageRaceAssembleGaragePartinfo:SetGroupAttr(isresetPos)
    ---@type table<number, PartFeatureData>
    local datalist = self.PartData:GetPartFeatureList()
    --local count = #datalist > 10 and #datalist or 10

    local ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.ObjAttr, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(ScrollView, #datalist, 1,function(dataIndex, itemObj, scroll)
        local data = datalist[dataIndex + 1]
        if data then
            for i = 1, 3 do
                local tempobj = CommonHelper:SetGameObjectActive("type"..i, itemObj, data and i == data:GetFeatureType())

                if data and i == data:GetFeatureType() then
                    CommonHelper:GetComponentSetImage("icon", tempobj, data:GetFeatureIcon(), UIModuleID.Garage)
                    CommonHelper:SetText("###name", tempobj, data:GetFeatureName())
                    CommonHelper:SetText("###value", tempobj, data:GetFeatureValue())
                    CommonHelper:SetText("###lv", tempobj, data:GetFeatureLV())

                    CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
                        CommonHelper:ShowGarageTipsView(GarageTipsTpye.Feature, data:GetID(), data:GetFeatureValue())
                    end)
                end
            end


        end


    end, nil, nil, isresetPos)
end
function PageRaceAssembleGaragePartinfo:SetGroupReform()
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PartStrongStart)
    local deltaStart = tonumber(cfg.varval)

    cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PartStrongMax)
    local deltaMax = tonumber(cfg.varval)
    local templist = self.PartData:GetPartReformList()
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.ObjAttr, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #templist, 1,function(dataIndex, itemObj, scroll)
        local data = self.PartData:GetPartReform(dataIndex + 1)

        local isopen = data:IsOpen(self.PartData:GetStar())
        local isblank = data:IsBlank(self.PartData:GetStar())
        local notblank = data:IsNotBlank(self.PartData:GetStar())
        CommonHelper:SetGameObjectActive("lock", itemObj,not isopen)
        CommonHelper:SetGameObjectActive("blank", itemObj, isblank)
        CommonHelper:SetGameObjectActive("enable", itemObj, notblank)
        local str = CommonHelper:GetTempStr_Default(TemplateStringID.ReformLockFormat, data.limit)
        CommonHelper:SetText("###locktips", itemObj, str)

        if data ~= nil and notblank then
            CommonHelper:HButtonSetCallback("BtnDetail",itemObj,function (hbtn)
                CommonHelper:ShowGarageTipsView(GarageTipsTpye.Reform, data.id)
            end)


            local cfg=CommonHelper:GetDevelopByEntryId(data.id)
            CommonHelper:SetText("###name", itemObj, ClientDataManager:Get():GetTemplateString(cfg.name))

            local tempvalue = PlayerDataManager:Get():GetPlayerLV() - deltaStart >0 and PlayerDataManager:Get():GetPlayerLV() - deltaStart+1 or 1
            if tempvalue > deltaMax then tempvalue = deltaMax end
            local str = CommonHelper:GetTempStr_Default(TemplateStringID.ReformLvFormat, data.lv,tempvalue)
            CommonHelper:SetText("###lv", itemObj, str)

            for i = 1, 3 do CommonHelper:SetGameObjectActive("quality"..i, itemObj, (data.quality) == i) end

            CommonHelper:SetGameObjectActive("strongenable", itemObj, data.lv < PlayerDataManager:Get():GetPlayerLV())
            CommonHelper:SetGameObjectActive("stronglock", itemObj, data.lv >= PlayerDataManager:Get():GetPlayerLV())

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


        end
    end)

end




function PageRaceAssembleGaragePartinfo:SetGroupSkill()

    ---@type ShellBuffData[]
    local bufflist = {}
    if self.PartData:GetPartType() == PartType.Shell then
        bufflist = self.PartData:GetPartShellBuffs()
        CommonHelper:SetText("###tittlename", self.ObjSkill, CommonHelper:GetTempStr_Default(TemplateStringID.SkillTittleName))
    else
        CommonHelper:SetText("###tittlename", self.ObjSkill, CommonHelper:GetTempStr_Default(TemplateStringID.PartTittleName))

    end

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("CustomScrollViewTtoM", self.ObjSkill, typeof(CustomScrollView))
    local tabledata={}
    local ShowData={}
    local InheritList=self.PartData:GetCurPartInheritList()
    if #bufflist>0 then
        for i = 1, 1 do
            table.insert(tabledata,1)
            table.insert(ShowData, {type=1,data=bufflist[i],index=i})
        end
    end
    if #bufflist<1 then
        table.insert(tabledata,1)
        table.insert(ShowData, {type=1,data=nil,index=1})
    end
    for i = 1, self.PartData:GetPartInheritCount() do
        if InheritList[i] then
            table.insert(tabledata,0)
            table.insert(ShowData, {type=0,data=InheritList[i],index=i})
        end
    end
    if not GameProperties.AssetBundleMode then
        for i = 1, #bufflist do
            table.insert(tabledata,2)
            table.insert(ShowData, {type=2,data=bufflist[i],index=i})
        end
    end

    CommonHelper:CustomView_Init(self.ScrollView, tabledata, function(index, itemObj, scroll)
        if ShowData[index+1].type==1 then
            local buffData=ShowData[index+1].data
            if buffData then
                CommonHelper:SetGameObjectActive("qualitynil", itemObj, false)
                if buffData.BuffCfg then
                    for i = 1, 6 do
                        local obj=   CommonHelper:SetGameObjectActive("quality"..i, itemObj, buffData.BuffCfg.quality == i)
                        CommonHelper:SetText("###des", obj, CommonHelper:GetTempStr_Default(buffData.BuffCfg.desc))
                        CommonHelper:SetText("###name", obj, CommonHelper:GetTempStr_Default(buffData.BuffCfg.name))
                    end
                end
            else
                CommonHelper:SetGameObjectActive("qualitynil", itemObj, true)
                for i = 1, 6 do CommonHelper:SetGameObjectActive("quality"..i, itemObj, false) end
            end
        end
        if ShowData[index+1].type==0 then
            ---@type PartInheritData
            local data=ShowData[index+1].data
            CommonHelper:SetGameObjectActive("enable", itemObj, data~=nil)
            CommonHelper:SetGameObjectActive("blank", itemObj, data==nil)
            if data~=nil then
                CommonHelper:SetGameObjectActive("replacelock", itemObj, data.Level==#data.Cfg.LevelAttrs and data.ReformVal[1] and data.ReformVal[1]>=data.Cfg.RecastingAttrs[1].value)
                CommonHelper:SetGameObjectActive("upenable", itemObj, data.Level<#data.Cfg.LevelAttrs)
                CommonHelper:SetGameObjectActive("replaceenable", itemObj, data.Level==#data.Cfg.LevelAttrs and (data.ReformVal[1]==nil or data.ReformVal[1]<data.Cfg.RecastingAttrs[1].value))
                CommonHelper:SetText("###name", itemObj, CommonHelper:GetTempStr_Default(data.Cfg.inheritname))
                CommonHelper:SetText("###lv", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectLevel,data.Level,#data.Cfg.LevelAttrs))

                for i = 1, 2 do
                    CommonHelper:SetText("###name"..i,itemObj,CommonHelper:GetAttrName(data.Cfg.AttrIds[i]))
                    CommonHelper:SetText("###value"..i,itemObj,data.AttrVal[i])
                end
                --{{{详细
                CommonHelper:HButtonSetCallback("BtnDetail",itemObj,function (hbtn)
                    CommonHelper:ShowGarageTipsView(GarageTipsTpye.Inherit, hbtn.intData)
                end,data.InheritId)
                --}}}
            end
        end
        if ShowData[index+1].type==2 then
            ---@type ShellBuffData
            local buffData=ShowData[index+1].data
            if buffData.BuffCfg.bigIcon~="0" then
                CommonHelper:GetComponentSetUITexture("SkillIcon", itemObj,buffData.BuffCfg.bigIcon , UIModuleID.Garage)
            end
            CommonHelper:SetText("###desc", itemObj,buffData.BuffCfg.bigIcon..":"..buffData.BuffCfg.C_ID )
        end
    end)

end

function PageRaceAssembleGaragePartinfo:SetGroupOther()
    local partcfg = self.PartCfg
    self.ScrollViewOther = UIUtil.GetTypeChildWightInputPath("CustomScrollViewTtoMOther", self.ObjOther, typeof(CustomScrollView))
    local tabledata={}
    local ShowData={}
    if partcfg then
        table.insert(tabledata,0)
        table.insert(ShowData, {type=1,data=CommonHelper:GetTempStr_Default(partcfg.partdesc),index=1})
        local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictpartyoke_config)
        ---@type PartYokeCfg[]
        local temp=cfg.GetPartLinksCfgDataById(self.PartData:GetPartBaseCfg().C_ID)
        if temp and #temp>=0 then
            table.insert(tabledata,1)
            table.insert(ShowData, {type=2,data=2,index=1})
            for i = 1, #temp do
                table.insert(tabledata,2)
                table.insert(ShowData, {type=3,data=temp[i],index=1})
            end
        end
        table.insert(tabledata,3)
        table.insert(ShowData, {type=4,data=CommonHelper:GetTempStr_Default(partcfg.descspecial),index=1})
        table.insert(tabledata,4)
        table.insert(ShowData, {type=5,data=CommonHelper:GetTempStr_Default(partcfg.descopen),index=1})
        table.insert(tabledata,5)
        table.insert(ShowData, {type=6,data=CommonHelper:GetTempStr_Default(partcfg.descclose),index=1})
    end
    CommonHelper:CustomView_Init(self.ScrollViewOther, tabledata, function(index, itemObj, scroll)
        if ShowData[index+1].type==1 then
            CommonHelper:SetText("###des", self.ObjOther, ShowData[index+1].data)
        end
        if ShowData[index+1].type==2 then
            CommonHelper:HButtonSetCallback("BtnReview",itemObj,function (hbtn)
                UIManager:Get():OpenPopup("PartYokeView",CanvasType.FrontCanvas,"PartYokeView")
            end)
        end
        if ShowData[index+1].type==3 then
            ---@type PartYokeCfg
            local temp=ShowData[index+1].data
            local showId=0
            for i = 1, #temp.PartIds do
                if temp.PartIds[i]~=self.PartData:GetPartBaseCfg().C_ID then
                    showId=temp.PartIds[i]
                    break
                end
            end
            local partobj = UIUtil.GetChild("ItemPart_118", itemObj)
            CommonHelper:SetItemPartGroup(partobj,UIModuleID.Garage,showId,ItemPartUIType.Simple,nil,function(id)
                CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.Garage)
            end,showId)
            CommonHelper:SetText("###name",itemObj,CommonHelper:GetPartOrArticleName(showId))
            CommonHelper:SetText("###value",itemObj,CommonHelper:GetTempStr_Default(temp.Desc))
        end
        if ShowData[index+1].type==4 then
            CommonHelper:SetText("###partrule", itemObj, ShowData[index+1].data)
        end
        if ShowData[index+1].type==5 then
            CommonHelper:SetText("###partenable", itemObj, ShowData[index+1].data)
        end
        if ShowData[index+1].type==6 then
            CommonHelper:SetText("###partdisable", itemObj, ShowData[index+1].data)
        end
    end)
end
function PageRaceAssembleGaragePartinfo:OnClickTogPartLock(idx, ischeck)
    CommonHelper:SetGameObjectActive("unlock",self.BtnLockChange.gameObject,idx>0)
    CommonHelper:SetGameObjectActive("lock",self.BtnLockChange.gameObject,idx==0)
    CommonHelper:SetGameObjectActive("locked",self.ObjInfo,idx>0)
    CommonHelper:SetGameObjectActive("unlocked",self.ObjInfo,idx==0)
end
function PageRaceAssembleGaragePartinfo:OnClickBtnChangeLock(idx)
    if idx>0 then
        KnapsackSubsystem:Get():SendMsg_PartLock(self.PartData:GetCellID(), 0)
    else
        KnapsackSubsystem:Get():SendMsg_PartLock(self.PartData:GetCellID(), 1)
    end

end

function PageRaceAssembleGaragePartinfo:UpdateMsg(isresetPos)
    self:SetGroupBase()

    if self.TogIdx == 1 then self:SetGroupInfo(true) end
    if self.TogIdx == 2 then self:SetGroupReform() end
    if self.TogIdx == 3 then self:SetGroupSkill() end
    if self.TogIdx == 4 then self:SetGroupOther() end
end

