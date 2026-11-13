---@class TrackSegmentNeedView : ViewBase
TrackSegmentNeedView = class("TrackSegmentNeedView", ViewBase)
local _Top=nil
local _Center=nil
local _Bottom=nil

function TrackSegmentNeedView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "TrackSegmentNeedViewAction")
end
local ShowList=nil
local _CurShop=nil
function TrackSegmentNeedView:Awake()
    _Top=self:GetChild("Top")
    _Center=self:GetChild("Center")
    _Bottom=self:GetChild("Bottom")
    CommonHelper:HButtonSetCallback("BgBth",_Top,function (data)
        UIManager:Get():ClosePopup()
    end)
   CommonHelper:HButtonSetCallback("BtnAllBuy",_Center,function (data)
       UIManager:Get():ClosePopup()
       ShopDataManager:Get().IsAllBuy=#ShowList
       for i = 1, #ShowList do
           ShopSubsystem:Get():SendMsg_Buy(_CurShop.ShopId,ShowList[i].goodsData.grid,ShowList[i].id,ShowList[i].buyNum)
       end
    end)
 CommonHelper:HButtonSetCallback("BtnBack",_Center,function (data)
        UIManager:Get():ClosePopup()

    end)
    self.trackList=self:GetChildWightByParent("MoreRowScrollView_V",_Center,typeof(MoreRowScrollView))
end
function TrackSegmentNeedView:OnOpen()
    CommonHelper:GetComponentSetImage("SpcSprite",self.gameObject, CommonHelper:GetCurrencyTypeImage(CurrencyType.Diamond) ,UIModuleID.CustomTrackEditor)
    CommonHelper:SetText("LabDiamond", self.gameObject, PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond))
    self:SetData()
end
local miniTrackSystem=nil
function TrackSegmentNeedView:SetData()
         ShowList={}
    ---@type ShopData
        _CurShop=ShopDataManager:Get():GetCurShop()
        local bag=SegmentDataManager:Get():GetSegmentBag()
        for i, v in pairs(SegmentDataManager:Get().AllTrackSgDic) do
            for j, k in pairs(v) do
                if k.needNum>bag:GetItem(k.cfgId) then
                   local goodsData= _CurShop:GetGoodsDataById(k.cfgId)
                    if goodsData then
                        table.insert(ShowList,{id=k.cfgId,buyNum=k.needNum-bag:GetItem(k.cfgId),goodsData=goodsData})
                    end
                end
            end
        end
   CommonHelper:InitMoreRowScrollView(self.trackList,#ShowList,3,function(dataIndex, itemObj, scroll)
       local data=ShowList[dataIndex+1]
       local param=Param_TrackSegmentGroup()
       param.moduleId=UIModuleID.CustomTrackEditor
       param.trackSegmentId=data.id
       param.count=data.buyNum
       param.showcount=true
       param.showname=true
       param.isdirection=false
       print(param.trackSegmentId)
       CommonHelper:SetTrackSegmentGroup(itemObj,param)
       if data.goodsData then
           CommonHelper:GetComponentSetImage("SpcSprite",itemObj, CommonHelper:GetCurrencyTypeImage(data.goodsData.moneyType) ,UIModuleID.CustomTrackEditor)
           CommonHelper:SetText("LabPrice",itemObj,data.goodsData.moneyNum*data.buyNum )
       end

   end)
end

function TrackSegmentNeedView:SetPlayerMoney()
    CommonHelper:SetText("LabDiamond", self.gameObject, PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond))
end


function TrackSegmentNeedView:OnClose()

end
function TrackSegmentNeedView:OnAutoClose()

end