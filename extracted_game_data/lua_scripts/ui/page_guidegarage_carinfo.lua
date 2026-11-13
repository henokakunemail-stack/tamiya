

--车库左侧，车信息

---@class PageGuideGarageCarinfo
PageGuideGarageCarinfo = class("PageGarageCarinfo")

function PageGuideGarageCarinfo:initialize()
    self.TogIdx = -1
    self.CarData = nil
end

---@param cardata CarReviewData
function PageGuideGarageCarinfo:SetData(root, cardata, isresetPos)
    self.CarData = cardata

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

    self:SetGroupBase()

    if isresetPos then
        self.TogIdx = -1
        self:OnClickTogPage(1, false)
    else
        self:OnClickTogPage(self.TogIdx, false)
    end

end

function PageGuideGarageCarinfo:AutoSelect()
    self:OnClickTogPage(1, false)
end

function PageGuideGarageCarinfo:OnClickTogPage(idx, ischeck)
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

function PageGuideGarageCarinfo:SetGroupBase()

    CommonHelper:SetText("###carname", self.ObjBase, CommonHelper:GetTempStr_Default(self.CarData:GetShellCfg().carNameEn) )
    CommonHelper:SetText("###fightvalue", self.ObjBase, string.format("%0.0f", self.CarData:GetScore()))

    local attrs = self.CarData:GetFiveAttrs()
    for i = 1, 5 do
        local data = attrs[i]
        local obj = UIUtil.GetChild("baseattr"..i, self.ObjBase)
        CommonHelper:SetText("###name", obj, CommonHelper:GetAttrName(data.type))
        CommonHelper:SetText("###value", obj, CommonHelper:GetAttrValue(data.type, data.value))
        --CommonHelper:GetComponentSetImage("iconlv", obj, CommonHelper:GetBaseAttrLvIcon(2), UIModuleID.Garage)

        local lv = CommonHelper:GetAttrLV(data.attrCfg, data.value)
        for i = 1, 6 do CommonHelper:SetGameObjectActive("lvbg"..i, obj, i == lv) end
        for i = 1, 6 do CommonHelper:SetGameObjectActive("valuelv"..i, obj, i <= lv) end

        CommonHelper:HButtonSetCallback("BtnItem",obj,function (hbtn)
            CommonHelper:ShowGarageTipsView(GarageTipsTpye.BaseAttr, data.type, CommonHelper:GetAttrValue(data.type, data.value))
        end)
    end


    ---@type dictcalc_config_cell
    local globalcfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.AttrScoreID)
    local attrCfg = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, tonumber(globalcfg.varval))
    local scorelv = CommonHelper:GetAttrLV(attrCfg, self.CarData:GetScore())

    CommonHelper:GetComponentSetImage("scorelv", self.ObjBase, CommonHelper:GetScoreLvIcon(scorelv), UIModuleID.GuideGarage)


end


function PageGuideGarageCarinfo:SetGroupInfo(isresetPos)

    local attrs = self.CarData:GetSecondAttrs()

    local sortlist = {}
    ---@type table<number, table<number, PartAttrData>>
    local secondAttrs = {}
    for i = 1, #attrs do
        if attrs[i].attrCfg then
            local typename = CommonHelper:GetTempStr_Default(attrs[i].attrCfg.tagName)
            if typename~="-1" then
                if secondAttrs[typename] == nil then
                    secondAttrs[typename] = {}
                    table.insert(sortlist, {attrs[i].attrCfg.tag, typename})
                end
                if attrs[i].value>0 then
                    table.insert(secondAttrs[typename], attrs[i])
                end
            end
        end
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
    end,isresetPos)
end

function PageGuideGarageCarinfo:SetGroupAttr(isresetPos)
    ---@type <1:PartFeatureData, 2:PartFeatureData[]>[]
    local templist = self.CarData:GetAttrFeatures()
    local scrollList = {}
    ---@type table<string, PartFeatureData>
    local dataTitle = {}
    ---@type table<string, PartFeatureData[]>
    local dataItem = {}
    for i = 1, #templist do
        ---@type PartFeatureData
        local key = templist[i][1]
        ---@type PartFeatureData[]
        local value = templist[i][2]

        dataTitle[key:GetFeatureName()] = key
        dataItem[key:GetFeatureName()] = value

        table.insert(scrollList, key:GetFeatureName())
        table.insert(scrollList, #value)
    end

    local scrollView = UIUtil.GetTypeChildWightInputPath("TitleScrollView", self.ObjAttr, typeof(TitleScrollView))
    CommonHelper:InitTitleScrollView(scrollView, scrollList, 1,function(title, itemObj, dataIndex, scroll)
        if dataIndex == -1 then
            CommonHelper:SetText("###text", itemObj, title)
            local data = dataTitle[title]

            for i = 1, 3 do
                local tempobj = CommonHelper:SetGameObjectActive("type"..i, itemObj, i == data:GetFeatureType())

                if i == data:GetFeatureType() then
                    CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
                        CommonHelper:ShowGarageTipsView(GarageTipsTpye.Feature, data:GetID(), "")
                    end)

                    CommonHelper:GetComponentSetImage("icon", tempobj, data:GetFeatureIcon(), UIModuleID.GuideGarage)
                    CommonHelper:SetText("###name", tempobj, data:GetFeatureName())

                    local tog = CommonHelper:HButtonSetCallback("TogDetail",tempobj,function (hbtn)
                        --local param = {data:GetFeatureName(), data:GetFeatureValue(), data:GetFeatureDes()}
                        --UINotify:Get():SendNotification(UINotifyEvent.GarageView_ShowFeatureTip, param)
                    end)
                    CommonHelper:SetToggleState(tog, true)
                end
            end
        else
            local list = dataItem[title]
            local data = list[dataIndex + 1]


            local partobj = UIUtil.GetChild("ItemPart", itemObj)
            local param = Param_ItemPartParam()
            param.quality = data.PartBaseCfg.fabric
            CommonHelper:SetItemPartGroup(partobj, UIModuleID.GuideGarage,data.PartCfg.C_ID, ItemPartUIType.Simple, param)


            CommonHelper:SetText("###name", itemObj, CommonHelper:GetTempStr_Default(data.PartCfg.partname))
            CommonHelper:SetText("###value", itemObj, data:GetFeatureValue())
            CommonHelper:SetText("###lv", itemObj, data:GetFeatureLV())
        end




    end,isresetPos)
end


function PageGuideGarageCarinfo:SetGroupSkill()
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("CustomScrollViewTtoM", self.ObjSkill, typeof(CustomScrollView))
    ---@type ShellBuffData[]
    local bufflist = {}
    ---@type CarDetailData
    local CarDetail = self.CarData:GetShowBuffIds()
    if CarDetail then
        for k, v in pairs(CarDetail) do
            table.insert(bufflist, v)
        end
    end
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("CustomScrollViewTtoM", self.ObjSkill, typeof(CustomScrollView))
    local tabledata={}
    local ShowData={}
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

    end)
end

function PageGuideGarageCarinfo:SetGroupOther()
    ---@type CarDetailData
    local article = self.CarData.assembleMgr:GetNodeByGrooveID(PartGrooveID.Chassis)
    local centerIcon= article:GetPartBaseCfg().centerIcon
    CommonHelper:GetComponentSetUITexture("chassisicon",self.ObjOther,centerIcon,UIModuleID.GuideGarage)
    local x=CommonHelper:FloatRound(self.CarData:GetFocusX().value/1000,100)
    local y=CommonHelper:FloatRound(self.CarData:GetFocusY().value/1000,100)
    local z=CommonHelper:FloatRound(self.CarData:GetFocusZ().value/1000,100)
    CommonHelper:SetText("###des",self.ObjOther,CommonHelper:GetTempStr_Default(TemplateStringID.CarInfoFocus,x,y,z))
    local area= UIUtil.GetTypeChildWightByParent("centerarea", self.ObjOther,typeof(RectTransform))
    local areaObj= UIUtil.GetChild("centerarea", self.ObjOther)
    local lineX=UIUtil.GetChild("lineX", self.ObjOther)
    local  lineZ=UIUtil.GetChild("lineZ", self.ObjOther)
    local center= UIUtil.GetChild("center", self.ObjOther)
    local cellz= CommonHelper:GetDictCalcData(CommonCfgKey.CarFocusCellZ)
    local cellx=CommonHelper:GetDictCalcData(CommonCfgKey.CarFocusCellX)
    local AreaZTop=  CommonHelper:GetDictCalcData(CommonCfgKey.CarFocusAreaZTop)
    local AreaZBottom=  CommonHelper:GetDictCalcData(CommonCfgKey.CarFocusAreaZBottom)
    local AreaXLeft=  CommonHelper:GetDictCalcData(CommonCfgKey.CarFocusAreaXLeft)
    local AreaXRight=  CommonHelper:GetDictCalcData(CommonCfgKey.CarFocusAreaXRight)
    UIUtil.SetUIWidth(area,math.abs(AreaZTop)+math.abs(AreaZBottom))
    UIUtil.SetUIHeight(area,math.abs(AreaXLeft)+math.abs(AreaXRight))
    UIUtil:GameobjectLocalPosition(areaObj, Vector3.zero)
    local  posx=-(x*20*cellz)
    local  posz=-(z*10*cellx)
    if posz>AreaZTop then posz=AreaZTop end
    if posz<AreaZBottom then posz=AreaZBottom end
    if posx>AreaZTop then posz=AreaXLeft end
    if posx<AreaZBottom then posz=AreaXRight end
    UIUtil:GameobjectLocalPositionY(lineX,posx)
    UIUtil:GameobjectLocalPositionX(lineX,0)
    UIUtil:GameobjectLocalPositionX(lineZ,posz)
    UIUtil:GameobjectLocalPositionY(lineZ,0)
    UIUtil:GameobjectLocalPositionX(center,posz)
    UIUtil:GameobjectLocalPositionY(center,posx)


end


function PageGuideGarageCarinfo:UpdateMsg()
    self:SetGroupBase()

    if self.TogIdx == 1 then self:SetGroupInfo(false) end
    if self.TogIdx == 2 then self:SetGroupAttr(false) end
    if self.TogIdx == 3 then self:SetGroupSkill(false) end
    if self.TogIdx == 4 then self:SetGroupOther(false) end
end