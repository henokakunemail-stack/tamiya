---@class SkillDetailView :ViewBase
SkillDetailView = class("TrackPositionSelectView", ViewBase)
function SkillDetailView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SkillDetailViewAction")

end
function SkillDetailView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask", self.gameObject, function(data)
        CSLuaHelper.BattleContinue()
        UIManager:Get():HidePersistentView("SkillDetailView")
        local trackType = BattleDataManager:Get():GetTrackType()
        if trackType == TrackType.Free then
            UINotify:Get():SendNotification(UINotifyEvent.BattleNewOutdoorView_SetSkillTweenIsPause, false)
        end
    end)
    self.BuffScrollView = UIUtil.GetTypeChildWightByParent("CustomScrollViewTtoM",self.gameObject, typeof(CustomScrollView))
end

function SkillDetailView:OnOpen()
   self:SetData()
end

function SkillDetailView:OnClose()

end

function SkillDetailView:SetData()
    local list= CSLuaHelper:Get():GetRealtimeBuffInfo2()
    local buffList={}
    if list==nil then
        return
    end
    local _data={}
    for i = 0, list.Count-1 do
        local subAttr=nil
        if list[i]~=nil and list[i].isCaculating then
            if list[i].buffCostValues.Length>0 and list[i].buffCostValues[0] then
                subAttr={}
                subAttr.typeId=list[i].buffCostValues[0].typeId
                subAttr.leftValue=list[i].buffCostValues[0].leftValue
            end
            local flag=true
            for i = 1, #buffList do
                if buffList[i].data.buffId==list[i].buffId then
                    flag=false
                    break
                end
            end
            if flag then
                local attrList=list[i].buffAttrChangeValues
                local costValues=list[i].buffCostValues
                local tempAttrList={}
                for i = 0, attrList.Length-1 do
                    if attrList[i]~=nil and attrList[i].changeValue~=0 then
                        table.insert(tempAttrList,{typeId=attrList[i].typeId,changeValue=attrList[i].changeValue,type=attrList[i].changeValue})
                    end
                end
                for i = 0, costValues.Length-1 do
                    if costValues[i]~=nil and costValues[i].costSpeed~=0 then
                        table.insert(tempAttrList,{typeId=costValues[i].typeId,changeValue=costValues[i].costSpeed,type=0})
                    end
                end
                if math.ceil(#tempAttrList/2)<=2 then
                    table.insert(_data,1)
                else
                    table.insert(_data,0)
                end
                table.insert(buffList,{data=list[i],leftValue=subAttr,AttrList=tempAttrList})
            end
        end
    end
    CommonHelper:CustomView_Init(self.BuffScrollView, _data, function(index, itemObj, scroll)
        local data=buffList[index+1].data
        local tempAttrList=buffList[index+1].AttrList
        -----@type miniskill_config_cell
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.miniskill_config,data.buffId)
        if cfg then
            CommonHelper:GetComponentSetUITexture("icon",itemObj,cfg.bigIcon,UIModuleID.Battle)
            CommonHelper:SetText("###name",itemObj,CommonHelper:GetTempStr_Default(cfg.name))
            CommonHelper:SetText("###buffvalue",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.SkillDetailStackCount,data.stackCount))
            CommonHelper:SetGameObjectActive("costbg",itemObj,buffList[index+1].leftValue~=nil)
            if buffList[index+1].leftValue then
                CommonHelper:SetText("###costtype",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.SkillDetailCostType,CommonHelper:GetAttrName(buffList[index+1].leftValue.typeId)))
                local cfg = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, buffList[index+1].leftValue.typeId)
                local attrvale=string.format(cfg.format,buffList[index+1].leftValue.leftValue)
                CommonHelper:SetText("###costvalue",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.SkillDetailCostTypeValue,attrvale))
            end
            CommonHelper:SetGameObjectActive("state1",itemObj,not data.isCaculating)
            CommonHelper:SetGameObjectActive("state2",itemObj,data.isCaculating)
            CommonHelper:SetGameObjectActive("attrlistbg",itemObj,math.ceil(#tempAttrList/2)>0)

            local ScrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_Attr",itemObj, typeof(MoreRowScrollView))
            CommonHelper:InitMoreRowScrollView(ScrollView,math.ceil(#tempAttrList/2),1,function(indexAttr, itemObjattr,scroll)
                for i = 1, 2 do
                    local attrData=tempAttrList[indexAttr*2+i]
                    if attrData then
                        ---@type attrtype_config_cell
                        local cfg = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, attrData.typeId)
                        local attrvale=string.format(cfg.format,attrData.changeValue)
                        if attrData.type>0 then
                            local color="ff3646"
                            if cfg .attrtrait>0 then
                                color="14d900"
                            end
                            CommonHelper:SetText("###name"..i,itemObjattr,CommonHelper:GetTempStr_Default(TemplateStringID.SkillDetailAttrShowType1,CommonHelper:GetAttrName(attrData.typeId),color,attrvale))
                        end
                        if attrData.type<0 then
                            local color="ff3646"
                            if cfg .attrtrait<0 then
                                color="14d900"
                            end
                            CommonHelper:SetText("###name"..i,itemObjattr,CommonHelper:GetTempStr_Default(TemplateStringID.SkillDetailAttrShowType2,CommonHelper:GetAttrName(attrData.typeId),color,attrvale))
                        end
                        if attrData.type==0 then
                            CommonHelper:SetText("###name"..i,itemObjattr,CommonHelper:GetTempStr_Default(TemplateStringID.SkillDetailAttrShowType3,CommonHelper:GetAttrName(attrData.typeId),attrvale))
                        end
                    else
                        CommonHelper:SetText("###name"..i,itemObjattr,"")
                    end
                end
            end)
        end
    end)
end