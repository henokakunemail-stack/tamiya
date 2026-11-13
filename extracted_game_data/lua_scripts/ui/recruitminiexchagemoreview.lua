---@class RecruitMiniExchangeMoreView : ViewBase
RecruitMiniExchangeMoreView = class("RecruitMiniExchangeMoreView", ViewBase)

function RecruitMiniExchangeMoreView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RecruitMiniExchangeMoreViewAction")
end

function RecruitMiniExchangeMoreView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function()
        local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
        local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)
        recruitData:SetCurSelect(self.OrgSelect)
        UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitViewInfo)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnWish", self.gameObject, function()
        local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
        local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)
        local result=""
        for i = 1, recruitData:GetRecruitViewType()  do
            if i==RecruitDivinationCell.Shell or (recruitData:GetCurSelect(i) and recruitData:GetCurSelect(i)>0) then
                result=result..recruitData:GetCurSelect(i)
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitCellNoSelectPart,i-1))
                return
            end
            if i~=recruitData:GetRecruitViewType() then
                result=result..":"
            end
        end
        recruitData:SetCurSelect(result)
        UIManager:Get():ClosePopup()
        UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitViewInfo)
    end)
    self.ScrollView = UIUtil.GetTypeChildWightByParent("ScrollHorizontalOneRow", self.gameObject, typeof(MoreRowScrollView))
end
function RecruitMiniExchangeMoreView:OnOpen()

end

function RecruitMiniExchangeMoreView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RecruitMiniExchange)
end

function RecruitMiniExchangeMoreView:SetData(type)
    self.ExchangeType=type
    self.selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
    ---@type RecruitData
    local  RecruitData=RecruitDataManager:Get():GetDataById(self.selectRecruitId)
    self.OrgSelect=RecruitData.info.CurSelect
    self.awardids={}
    self.SelectCount=0
    if self.ExchangeType~=RecruitDivinationCell.None then
        local titleTab = RecruitData.probability
        ---@type dictaward_config
        local awardTab = ClientDataManager:Get():GetDataTable(ConfigNames.dictaward_config)
        ---@type dictaward_config_cell[]
        local partTable = awardTab.GetPropTableByIdIdx(titleTab[1].awardid)
        if partTable[1].sort then
            table.sort(partTable,function(a, b)
                return a.sort<b.sort
            end)
        end

        for i = 1, #partTable do
            local propsid=partTable[i].propsid
            local tag=partTable[i].tag
            local propType=CommonHelper:GetPropTypeById(propsid)
            if propType==PropType.Part then
                ---@type dictpartbase_config_cell
                local cfg=CommonHelper:GetPartBaseCfg(propsid)
                if cfg.parttype~=PartType.Shell then
                    local flag=false
                    for k, v in pairs(RecruitDivinationCell) do
                        if RecruitData:GetCurSelect(v) and RecruitData:GetCurSelect(v)==propsid then
                            self.SelectCount=self.SelectCount+1
                            flag=true
                            break
                        end
                    end
                    table.insert(self.awardids,{id=propsid,flag=flag,tag=tag})
                end
            end
            if propType==PropType.Article then
                ---@type dictpartbase_config_cell
                CommonHelper:GetTableDataByID(ConfigNames.article_config, propsid)
                local flag=false
                for k, v in pairs(RecruitDivinationCell) do
                    if RecruitData:GetCurSelect(v) and RecruitData:GetCurSelect(v)==propsid then
                        self.SelectCount=self.SelectCount+1
                        flag=true
                        break
                    end
                end
                table.insert(self.awardids,{id=propsid,flag=flag,tag=tag})
            end

        end
    end
    self:SetShowPartView()
    CommonHelper:InitMoreRowScrollView(self.ScrollView,#self.awardids,6,function(index, itemObj,scroll)
        local param = Param_ItemArticleParam()
        param.count = 1
        CommonHelper:SetItemComGroup(itemObj, UIModuleID.RecruitMiniExchange,self.awardids[index + 1].id,param,function(intData)
            if self:CheckSelect(self.awardids[intData].id,self.awardids[intData].flag) then
                self.awardids[intData].flag = not self.awardids[intData].flag
                self:SetShowPartView()
                CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
            end
        end, index+1)
        CommonHelper:SetGameObjectActive("select",itemObj,self.awardids[index + 1].flag)
        if self.awardids[index + 1].tag then
            CommonHelper:SetGameObjectActive("flag1",itemObj,self.awardids[index + 1].tag==1)
            CommonHelper:SetGameObjectActive("flag2",itemObj,self.awardids[index + 1].tag==2)
            CommonHelper:SetGameObjectActive("flag3",itemObj,self.awardids[index + 1].tag==3)
        else
            CommonHelper:SetGameObjectActive("flag1",itemObj,false)
            CommonHelper:SetGameObjectActive("flag2",itemObj,false)
            CommonHelper:SetGameObjectActive("flag3",itemObj,false)
        end

    end)
end
function RecruitMiniExchangeMoreView:CheckSelect(id,flag)
    local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
    local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)
    if flag then
        for i = 2, recruitData:GetRecruitViewType() do
            if (recruitData:GetCurSelect(i) and recruitData:GetCurSelect(i)>0) and id==recruitData:GetCurSelect(i) then
                self:SetSelect(i,0)
                break
            end
        end
        self.SelectCount=self.SelectCount-1
        return true
    else
        local flag=false
        for i = 2, recruitData:GetRecruitViewType() do
            if recruitData:GetCurSelect(i)==nil or recruitData:GetCurSelect(i)==0 then
                flag=true
                self:SetSelect(i,id)
                self.SelectCount=self.SelectCount+1
                break
            end
        end
        if flag==false then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitSelectPartNoCell))
        end
        return flag
    end
end
function RecruitMiniExchangeMoreView:SetSelect(index,id)
    local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
    local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)
    local result=""
    for i = 1, recruitData:GetRecruitViewType()  do
        if i==index then
            result=result..id
        else
            if recruitData:GetCurSelect(i) and recruitData:GetCurSelect(i)>0 then
                result=result..recruitData:GetCurSelect(i)
            else
                result=result..0
            end
        end
        if i~=recruitData:GetRecruitViewType() then
            result=result..":"
        end
    end
    recruitData:SetCurSelect(result)
end
function RecruitMiniExchangeMoreView:SetShowPartView()
    local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
    local recruitData = RecruitDataManager:Get():GetDataById(selectRecruitId)
    for i = 2, recruitData:GetRecruitViewType() do
        local itemObj= CommonHelper:SetGameObjectActive("ItemCom_"..i,self.gameObject,(recruitData:GetCurSelect(i) and recruitData:GetCurSelect(i)>0))
        if (recruitData:GetCurSelect(i) and recruitData:GetCurSelect(i)>0) then
            local partId=recruitData:GetCurSelect(i)
            local param = Param_ItemArticleParam()
            param.count = 1
            CommonHelper:SetItemComGroup(itemObj, UIModuleID.RecruitMiniExchange,partId,param,function(intData)
                CommonHelper:ShowPartInfoByCfgId(intData, UIModuleID.RecruitMiniExchange)
            end, partId)
        end
    end
end



