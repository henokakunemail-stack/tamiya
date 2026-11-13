---@class RecruitMiniExchangeedView : ViewBase
RecruitMiniExchangeedView = class("RecruitMiniExchangeedView", ViewBase)

function RecruitMiniExchangeedView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RecruitMiniExchangeedViewAction")
end

function RecruitMiniExchangeedView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function()
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnWish", self.gameObject, function()
        if self.ExchangeType>RecruitDivinationCell.Shell then
            UIManager:Get():OpenPopup("RecruitMiniExchangeMoreView", CanvasType.MainCanvas, "RecruitMiniExchangeMoreView")
            UINotify:Get():SendNotification(UINotifyEvent.RecruitMiniExchangeMoreView_SetData, self.ExchangeType)
        else
            UIManager:Get():OpenPopup("RecruitMiniExchangeView", CanvasType.MainCanvas, "RecruitMiniExchangeView")
            UINotify:Get():SendNotification(UINotifyEvent.RecruitMiniExchangeView_SetData, self.ExchangeType)
        end
    end)
    self.ScrollView = UIUtil.GetTypeChildWightByParent("ScrollHorizontalOneRow", self.gameObject, typeof(MoreRowScrollView))
end
function RecruitMiniExchangeedView:OnOpen()
end

function RecruitMiniExchangeedView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RecruitMiniExchangeed)
end

function RecruitMiniExchangeedView:SetData(type)

    self.ExchangeType=type
    local selectRecruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
    ---@type RecruitData
    local  RecruitData=RecruitDataManager:Get():GetDataById(selectRecruitId)
    local obj=self:GetChild("ItemCom_202")
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config,RecruitData:GetCurSelect(self.ExchangeType))
     CommonHelper:SetText("###partname",self.gameObject,CommonHelper:GetTempStr_Default(partCfg.partname))
    CommonHelper:SetItemComGroup(obj, UIModuleID.RecruitMiniExchangeed,RecruitData:GetCurSelect(self.ExchangeType))
    self:SetGroupInfo(RecruitData:GetCurSelect(self.ExchangeType))
end
function RecruitMiniExchangeedView:SetGroupInfo(id)
    --{{{ 配件item
    ---@type dictpartbase_config_cell
    local  basecfg=CommonHelper:GetPartBaseCfg(id)
    local PartAgeCfg=CommonHelper:GetPartAgeCfg(id,1)
    --{{{二级属性
    local attrs = {}
    for k, v in pairs(PartAgeCfg.NewAttr) do
        table.insert(attrs,v)
    end
    local ScrollView = UIUtil.GetTypeChildWightInputPath("AttrScrollView", self.gameObject, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(ScrollView, #attrs, 1,function( dataIndex,itemObj, scroll)
        local data = attrs[dataIndex+1]
        CommonHelper:SetText("###name", itemObj, CommonHelper:GetAttrName(data.type))
        CommonHelper:SetText("###value", itemObj, CommonHelper:GetAttrValue(data.type, data.value))
    end)
    --}}}
end



