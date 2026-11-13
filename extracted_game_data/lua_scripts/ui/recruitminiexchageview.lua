---@class RecruitMiniExchangeView : ViewBase
RecruitMiniExchangeView = class("RecruitMiniExchangeView", ViewBase)

function RecruitMiniExchangeView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RecruitMiniExchangeViewAction")
end

function RecruitMiniExchangeView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function()
         UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnWish", self.gameObject, function()
        local  RecruitData=RecruitDataManager:Get():GetDataById(self.selectRecruitId)
         if self.SelectId and self.SelectId >0 and RecruitData:GetCurSelect(self.ExchangeType)~=self.SelectId then
            if self.ExchangeType==RecruitDivinationCell.None then
                RecruitSubsystem:Get():SendMsg_MiniChange( self.selectRecruitId,self.SelectId)
            else
                local result=""
                for i = 1, RecruitData:GetRecruitViewType()  do
                    if i==self.ExchangeType then
                        result=result..self.SelectId
                    else
                        if RecruitData:GetCurSelect(i) and RecruitData:GetCurSelect(i)>0 then
                            result=result..RecruitData:GetCurSelect(i)
                        else
                            result=result..0
                        end
                    end
                    if i~=RecruitData:GetRecruitViewType() then
                        result=result..":"
                    end
                end
                RecruitData:SetCurSelect(result)
                UIManager:Get():ClosePopup()
                UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitViewInfo)
            end
        else
            if self.SelectId and self.SelectId<=0 then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitSelectPartNull))
                return
            end
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitSelectPartRepeat))
        end

    end)
    self.ScrollView = UIUtil.GetTypeChildWightByParent("ScrollHorizontalOneRow", self.gameObject, typeof(MoreRowScrollView))
end
function RecruitMiniExchangeView:OnOpen()

end

function RecruitMiniExchangeView:OnClose()
   CommonHelper:ReleasePool(UIModuleID.RecruitMiniExchange)
end

function RecruitMiniExchangeView:SetData(type)
    self.ExchangeType=type
    self.selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
    ---@type RecruitData
    local  RecruitData=RecruitDataManager:Get():GetDataById(self.selectRecruitId)
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
    self.awardids={}
    if self.ExchangeType~=RecruitDivinationCell.None then
        local result={}
        for i = 1, #partTable do
            local propsid=partTable[i].propsid
            local tag=partTable[i].tag
            ---@type dictpartbase_config_cell
            local cfg=CommonHelper:GetPartBaseCfg(propsid)
            if cfg and self.ExchangeType==RecruitDivinationCell.Shell then
                if cfg.parttype==PartType.Shell then
                    table.insert(result, { id=propsid,tag=tag} )
                end
            end
            if self.ExchangeType~=RecruitDivinationCell.Shell and (cfg==nil or cfg.parttype~=PartType.Shell) then
                local flag=true
                for k, v in pairs(RecruitDivinationCell) do
                    if v~=self.ExchangeType and RecruitData:GetCurSelect(v) and RecruitData:GetCurSelect(v)==self.awardids[i] then
                        flag=false
                        break
                    end
                end
                if flag then
                    table.insert(result,{ id=propsid,tag=tag} )
                end
            end
        end
        self.awardids=result
    else
        local result={}
        for i = 1, #partTable do
            local propsid=partTable[i].propsid
            local tag=partTable[i].tag
            table.insert(result,{ id=propsid,tag=tag} )
        end
    end
    if RecruitData:GetCurSelect(self.ExchangeType) and RecruitData:GetCurSelect(self.ExchangeType)>0 then
        self.SelectId=RecruitData:GetCurSelect(self.ExchangeType)
    else
        self.SelectId=0
    end
    self:SetShowPartView(RecruitData:GetCurSelect(self.ExchangeType))
    CommonHelper:InitMoreRowScrollView(self.ScrollView,#self.awardids,6,function(index, itemObj,scroll)
        local param = Param_ItemArticleParam()
        param.count = 1
        CommonHelper:SetItemComGroup(itemObj, UIModuleID.RecruitMiniExchange,self.awardids[index + 1].id,param,function(btnData)
            self.SelectId=btnData
            self:SetShowPartView(self.SelectId)
            CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
        end,self.awardids[index + 1].id)
        CommonHelper:SetGameObjectActive("select",itemObj,self.SelectId==self.awardids[index + 1].id)
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

function RecruitMiniExchangeView:SetShowPartView(id)
    local obj=CommonHelper:SetGameObjectActive("ItemCom_202",self.gameObject,id and id>0)
    if id and id>0 then
        local param = Param_ItemArticleParam()
        param.count = 1
        CommonHelper:SetItemComGroup(obj, UIModuleID.RecruitMiniExchange,id,param,function(btnData)
            CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.RecruitMiniExchange)
        end,id)
    end
end



