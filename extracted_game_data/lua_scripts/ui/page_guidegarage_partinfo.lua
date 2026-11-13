

--车库左侧，配件信息

---@class PageGuideGaragePartinfo
PageGuideGaragePartinfo = class("PageGuideGaragePartinfo")

function PageGuideGaragePartinfo:initialize()
    self.TogIdx = 1
    ---@type PartData
    self.PartData = nil
    ---@type AssembleNode
    self.NodeData = nil
    self.TogLockIdx = 1
end

---@param data ArticleCell
---@param node AssembleNode
function PageGuideGaragePartinfo:SetData(root, data, node)
    --self.TogIdx = -1
    self.PartData = data
    self.NodeData = node

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
    self.BtnLockChange = CommonHelper:HButtonSetCallback("BtnSure", self.ObjOther,function (hbtn)
        self:OnClickBtnChangeLock()
    end)

    self:SetGroupBase()
    self:AutoSelect()
end

function PageGuideGaragePartinfo:AutoSelect()
    self:OnClickTogPage(self.TogIdx, false)
end

function PageGuideGaragePartinfo:OnClickTogPage(idx, ischeck)
    if ischeck then
        if self.TogIdx == idx then return end
    end
    self.TogIdx = idx

    for i = 1, #self.Toggle do
        CommonHelper:SetToggleState(self.Toggle[i], idx == i)
    end

    CommonHelper:TweenGroupUILeft("tween", self.ObjInfo, idx == 1)
    CommonHelper:TweenGroupUILeft("tween", self.ObjAttr, idx == 2)
    CommonHelper:TweenGroupUILeft("tween", self.ObjSkill, idx == 3)
    CommonHelper:TweenGroupUILeft("tween", self.ObjOther, idx == 4)

    if idx == 1 then self:SetGroupInfo() end
    if idx == 2 then self:SetGroupAttr() end
    if idx == 3 then self:SetGroupSkill() end
    if idx == 4 then self:SetGroupOther() end
end



function PageGuideGaragePartinfo:SetGroupBase()

    --CommonHelper:SetText("###fightvalue", self.ObjBase, string.format("%0.0f", self.PartData:GetPartScore()) )

    local partobj = UIUtil.GetChild("ItemPartGarage", self.ObjBase)
    ---@class PartData
    ---@field PartCfg dictparts_config_cell
    ---@field PartBaseCfg dictpartbase_config_cell
    if self.PartData then
        CommonHelper:SetText("###partname", self.ObjBase, ClientDataManager:Get():GetTemplateString(self.PartData.PartCfg.partname))


        local param = Param_ItemPartParam()
        param.quality = self.PartData.PartBaseCfg.fabric
        param.star = 1
        param.lv = 1
        param.using = 0
        param.lock = false
        param.awaken=false
        CommonHelper:SetItemPartGroup(partobj, UIModuleID.GuideGarage, self.PartData.PartCfg.C_ID, ItemPartUIType.Normal, param)

    end



    -----@type table<number, PartAttrData>
    --local oldattrs = {}
    --if self.NodeData:GetBagId() > -1 then
    --    local data = KnapsackDataManager:Get():GetArticleByID(self.NodeData:GetBagId())
    --    if data then
    --        oldattrs = data:GetPartFiveAttrs()
    --    end
    --end
    local attrs ={}
    local PartAgeCfg=CommonHelper:GetPartAgeCfg(self.PartData.PartCfg.C_ID,1)
    for k, v in pairs(PartAgeCfg.NewAttr) do
        table.insert(attrs,v)
    end
    for i = 1, 5 do
        local obj = UIUtil.GetChild("baseattr"..i, self.ObjBase)
        local data = attrs[i]
        if data then
            CommonHelper:SetText("###name", obj, CommonHelper:GetAttrName(data.type))
            CommonHelper:SetText("###value", obj, CommonHelper:GetAttrValue(data.type, data.value))


            local lv = CommonHelper:GetAttrLV(data.attrCfg, data.value)
            for i = 1, 6 do CommonHelper:SetGameObjectActive("lvbg"..i, obj, i == lv) end
            for i = 1, 6 do CommonHelper:SetGameObjectActive("valuelv"..i, obj, i <= lv) end
        else
            CommonHelper:SetText("###name", obj, "")
            CommonHelper:SetText("###value", obj, "")
            for i = 1, 6 do CommonHelper:SetGameObjectActive("lvbg"..i, obj, false) end
            for i = 1, 6 do CommonHelper:SetGameObjectActive("valuelv"..i, obj, false) end
        end
       -- local olddata = oldattrs[i]



        CommonHelper:HButtonSetCallback("BtnItem",obj,function (hbtn)
            CommonHelper:ShowGarageTipsView(GarageTipsTpye.BaseAttr, data.type, CommonHelper:GetAttrValue(data.type, data.value))
        end)
        CommonHelper:SetText("###delta", obj, "")

    end

end

function PageGuideGaragePartinfo:SetGroupInfo(isresetPos)


    --{{{二级属性
    local attrs = {}
    local PartAgeCfg=CommonHelper:GetPartAgeCfg(self.PartData.PartCfg.C_ID,1)
    for k, v in pairs(PartAgeCfg.NewAttr) do
      local  temp= PartAttrData()
        temp:SetData(k, v.value)
        table.insert(attrs,temp)
    end

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


    local ScrollView = UIUtil.GetTypeChildWightInputPath("TitleScrollView", self.ObjInfo, typeof(TitleScrollView))
    CommonHelper:InitTitleScrollView(ScrollView, temp, 1,function(title, itemObj, dataIndex, scroll)
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
    end, isresetPos)
    --}}}

end

function PageGuideGaragePartinfo:SetGroupAttr(isresetPos)
    ---@type table<number, PartFeatureData>
    local datalist = {}
    local PartAgeCfg=CommonHelper:GetPartAgeCfg(self.PartData.PartCfg.C_ID,1)
    --local count = #datalist > 10 and #datalist or 10
    for i = 1, #self.PartData.PartBaseCfg.NewAttrFeature do
        local temp =  self.PartData.PartBaseCfg.NewAttrFeature[i]
        if temp~=-1 then
            ---@type attrfeature_config_cell
            local feature = CommonHelper:GetTableDataByID(ConfigNames.attrfeature_config, temp)
            local value=0
            if PartAgeCfg.NewAttr[feature.attr] then
                value= PartAgeCfg.NewAttr[feature.attr].value
            end
            local data = PartFeatureData()
            data:SetDataByCfg(self.PartData.PartCfg,self.PartData.PartBaseCfg, feature, value)
            table.insert(datalist, data)
        end
    end
    table.sort(datalist, function(a,b) return a:GetFeatureType() < b:GetFeatureType() end)
    local ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.ObjAttr, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(ScrollView, #datalist, 1,function(dataIndex, itemObj, scroll)
        local data = datalist[dataIndex + 1]
        if data then
            for i = 1, 3 do
                local tempobj = CommonHelper:SetGameObjectActive("type"..i, itemObj, data and i == data:GetFeatureType())

                if data and i == data:GetFeatureType() then
                    CommonHelper:GetComponentSetImage("icon", tempobj, data:GetFeatureIcon(), UIModuleID.GuideGarage)
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

function PageGuideGaragePartinfo:SetGroupSkill()

    ---@type ShellBuffData[]
    local bufflist = {}
    if self.PartData.PartBaseCfg.parttype == PartType.Shell then
        if self.PartData.PartBaseCfg.NewSkillIds then
            for k, v in pairs(self.PartData.PartBaseCfg.NewSkillIds) do
                if v>0 then
                    local data = ShellBuffData()
                    data:SetData(v)
                    table.insert(bufflist, data)
                end
            end
        end
    end

    local ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.ObjSkill, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(ScrollView, 3, 1,function(dataIndex, itemObj, scroll)
        local data = bufflist[dataIndex + 1]

        if data then
            CommonHelper:SetGameObjectActive("qualitynil", itemObj, false)
            if data.BuffCfg then
                for i = 1, 6 do
                    local tempobj = CommonHelper:SetGameObjectActive("quality"..i, itemObj, data.BuffCfg.quality == i)
                    if data.BuffCfg.quality == i and tempobj then
                        CommonHelper:SetText("###name", tempobj, CommonHelper:GetTempStr_Default(data.BuffCfg.name))
                        CommonHelper:SetText("###des", tempobj, CommonHelper:GetTempStr_Default(data.BuffCfg.desc))
                    end
                end
            end
        else
            CommonHelper:SetGameObjectActive("qualitynil", itemObj, true)
            for i = 1, 6 do CommonHelper:SetGameObjectActive("quality"..i, itemObj, false) end
        end
    end)

end

function PageGuideGaragePartinfo:SetGroupOther()
    local partcfg = self.PartData.PartCfg
    if partcfg then
        -- 描述加id
        CommonHelper:SetText("###des", self.ObjOther, ClientDataManager:Get():GetTemplateString(partcfg.partdesc))
        --CommonHelper:SetText("###des", self.ObjOther, partcfg.C_ID.."   "..ClientDataManager:Get():GetTemplateString(partcfg.partdesc))
    end

    for i = 1, 7 do
        CommonHelper:SetGameObjectActive("lockstate"..i, self.ObjOther, false)
    end

    --self:OnClickTogPartLock(self.PartData:GetPartLock(), false)
end
function PageGuideGaragePartinfo:OnClickTogPartLock(idx, ischeck)
    if ischeck then
        if self.TogLockIdx == idx then return end
    end

    for i = 1, #self.LockToggle do
        CommonHelper:SetToggleState(self.LockToggle[i], idx == i)
    end
    CommonHelper:SetToggleState(self.TogUnlock, idx == 0)
    for i = 1, 7 do
        CommonHelper:SetGameObjectActive("lockstate"..i, self.ObjOther, idx == i)
    end
    self.TogLockIdx = idx
    CommonHelper:SetHButtonClick(self.BtnLockChange, self.PartData:GetPartLock() ~= idx, true)
    CommonHelper:SetGameObjectActive("lock",self.BtnLockChange.gameObject,idx>0)
    CommonHelper:SetGameObjectActive("unlock",self.BtnLockChange.gameObject,idx==0)
end
function PageGuideGaragePartinfo:OnClickBtnChangeLock()
    KnapsackSubsystem:Get():SendMsg_PartLock(self.PartData:GetCellID(), self.TogLockIdx)
end

function PageGuideGaragePartinfo:UpdateMsg()
    self:SetGroupBase()

    if self.TogIdx == 1 then self:SetGroupInfo(false) end
    if self.TogIdx == 2 then self:SetGroupAttr(false) end
    if self.TogIdx == 3 then self:SetGroupSkill() end
    if self.TogIdx == 4 then self:SetGroupOther() end
end