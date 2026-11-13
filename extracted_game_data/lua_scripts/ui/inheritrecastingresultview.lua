


---@class InheritRecastingResultView : ViewBase
InheritRecastingResultView = class("InheritRecastingResultView", ViewBase)

function InheritRecastingResultView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "InheritRecastingResultViewAction")
end

function InheritRecastingResultView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnAgain",self.gameObject,function (hbtn)
        if  math.abs(self.InheritData.ReformVal[1])>=math.abs(self.InheritData.Cfg.RecastingAttrs[1].value) then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritUpRecastingMax))
            return
        end
        if PlayerDataManager:Get():CheckCurrencyEnough(self.InheritData.Cfg.RecastingCost.id,self.InheritData.Cfg.RecastingCost.num,true) then
            ReformSubsystem:SendMsg_InheritRecasting(self.data:GetCellID(),self.InheritData.InheritId)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnExit",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
        UINotify:Get():SendNotification(UINotifyEvent.Msg_PartInheritRecastingBack)
    end)
end

function InheritRecastingResultView:OnOpen()

end

function InheritRecastingResultView:OnClose()

end

function InheritRecastingResultView:SetData(idx,inheritId,oldAttr)
    self.data = KnapsackDataManager:Get():GetArticleByID(idx)
    self.InheritData=self.data:GetInheritById(inheritId)
    local List={}
    for i = 1, #self.InheritData.Cfg.RecastingAttrs do
        if self.InheritData.Cfg.RecastingAttrs[i].value~=0 then
            local cur=0
            local old=0
            if self.InheritData.ReformVal[i] then
                cur=self.InheritData.ReformVal[i]
            end
            if oldAttr[i] then
                old=oldAttr[i]
            end
            table.insert(List,{id=self.InheritData.Cfg.AttrIds[i],cur=cur,old=old})
        end
    end
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #List, 1,function(dataIndex, itemObj, scroll)
        CommonHelper:SetText("###name",itemObj,CommonHelper:GetAttrName(List[dataIndex+1].id))
        CommonHelper:SetText("###value2",itemObj,List[dataIndex+1].cur)
        CommonHelper:SetText("###value1",itemObj,List[dataIndex+1].old)
    end)
end

