---@class PageGarageInherit
PageGarageInherit = class("PageGarageInherit")

function PageGarageInherit:initialize()

end
local ShowData={}
---@param data ArticleCell
function PageGarageInherit:SetData(root, data, funback,funinherit,funlevelup,funrecasting)
    self.PartData=data
    self.Root=root
    self.FuncInherit=funinherit
    self.SelectIdx=-1
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)
    self.BtnLevel=CommonHelper:HButtonSetCallback("BtnLevel",root,function (hbtn)
        if data:GetCurPartInheritList()[self.SelectIdx] then
            if data:GetCurPartInheritList()[self.SelectIdx].Level<#data:GetCurPartInheritList()[self.SelectIdx].Cfg.LevelAttrs then
               -- if funlevelup then funlevelup(data,self.SelectIdx) end
                UIManager:Get():ShowPersistentView("InheritLevelView",CanvasType.FrontCanvas,"InheritLevelView")
                UINotify:Get():SendNotification(UINotifyEvent.InheritLevelView_SetData,{data,self.SelectIdx} )
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritMaxLevel))
            end
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectTips))
        end
    end)
    self.BtnReplace=CommonHelper:HButtonSetCallback("BtnReplace",root,function (hbtn)
        if data:GetCurPartInheritList()[self.SelectIdx] then
            if data:GetCurPartInheritList()[self.SelectIdx].Level<#data:GetCurPartInheritList()[self.SelectIdx].Cfg.LevelAttrs then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritNotMaxLevel))
                return
            end
            if data:GetCurPartInheritList()[self.SelectIdx].ReformVal[1] and math.abs(data:GetCurPartInheritList()[self.SelectIdx].ReformVal[1])>=math.abs(data:GetCurPartInheritList()[self.SelectIdx].Cfg.RecastingAttrs[1].value) then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritUpRecastingMax))
                return
            end
            if funrecasting then funrecasting(data,self.SelectIdx) end
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSelectTips))
        end
    end)
    self:SetScrollView(self.PartData)

end
function PageGarageInherit:UpdateBtnGroup()

end
function PageGarageInherit:UpdateMsg()
    self:SetScrollView(self.PartData)
end

function PageGarageInherit:SetScrollView(data)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("CustomScrollViewTtoM", self.Root, typeof(CustomScrollView))
    local tabledata={}
    ShowData={}
    local InheritList=data:GetCurPartInheritList()
    ---@type ShellBuffData[]
    local bufflist = {}
    if self.PartData:GetPartType() == PartType.Shell then
        bufflist = self.PartData:GetPartShellBuffs()
        CommonHelper:SetText("###tittlename", self.Root, CommonHelper:GetTempStr_Default(TemplateStringID.SkillTittleName))
    else
        CommonHelper:SetText("###tittlename", self.Root, CommonHelper:GetTempStr_Default(TemplateStringID.PartTittleName))

    end
    if #bufflist>0 then
        for i = 1,1 do
            table.insert(tabledata,1)
            table.insert(ShowData, {type=1,data=bufflist[i],index=i})
        end
    end

    for i = 1, data:GetPartInheritCount() do
        if InheritList[i] then
            table.insert(tabledata,0)
            table.insert(ShowData, {type=0,data=InheritList[i],index=i})
        end
    end
    if #InheritList<data:GetPartInheritCount() then
        table.insert(tabledata,0)
        table.insert(ShowData, {type=0,data=InheritList[#InheritList+1],index=#InheritList+1})
    end
    CommonHelper:CustomView_Init(self.ScrollView, tabledata, function(index, itemObj, scroll)
        if ShowData[index+1].type==1 then
            local buffData=ShowData[index+1].data
            if buffData then
                CommonHelper:SetText("###name", itemObj, CommonHelper:GetTempStr_Default(buffData.BuffCfg.name))
                if buffData.BuffCfg then
                    for i = 1, 6 do
                        local obj=   CommonHelper:SetGameObjectActive("quality"..i, itemObj, buffData.BuffCfg.quality == i)
                        CommonHelper:SetText("###des", obj, CommonHelper:GetTempStr_Default(buffData.BuffCfg.desc))
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
            CommonHelper:SetText("blank/Image (1)/text", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CanInherit))
           local BtnItem= CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
                local data = ShowData[index+1].data
                if  data==nil  then
                    if self.FuncInherit then self.FuncInherit(self.PartData, ShowData[index+1].index,InheritOptionType.Select) end
                else
                    if  self.SelectIdx == ShowData[index+1].index then return end
                    self.SelectIdx = ShowData[index+1].index
                    CommonHelper:CustomView_Refresh(self.ScrollView, false)
                    self:UpdateBtnGroup()
                end
            end,index)
            local BtnRep= CommonHelper:HButtonSetCallback("BtnRep",itemObj,function (hbtn)
                if self.FuncInherit then self.FuncInherit(self.PartData, ShowData[index+1].index,InheritOptionType.Replace) end
            end,ShowData[index+1].index)
            local BtnDel= CommonHelper:HButtonSetCallback("BtnDel",itemObj,function (hbtn)
                local boxFunc = function()
                    local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil,CommonHelper:GetTempStr_Default(TemplateStringID.DelInheritPosHit,cost))
                    if ret == MessageBoxHelp.BtnType.OK then
                        AppearanceSubsystem:SendMsg_ResetSticker(self.PartData:GetCellID(),AppearanceType.Inherit, data.InheritId)
                    end
                end
                MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
            end,ShowData[index+1].index)
            CommonHelper:SetHButtonClick(BtnRep, self.SelectIdx ==  ShowData[index+1].index and data~=nil, true)
            CommonHelper:SetHButtonClick(BtnDel, self.SelectIdx ==  ShowData[index+1].index and data~=nil, true)
            CommonHelper:SetGameObjectActive("select", itemObj, self.SelectIdx ==  ShowData[index+1].index)
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
