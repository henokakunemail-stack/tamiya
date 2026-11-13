---@class TrackPositionSelectView :ViewBase
TrackPositionSelectView = class("TrackPositionSelectView", ViewBase)
local _CallBack=nil
local _CurTog=nil
function TrackPositionSelectView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "TrackPositionSelectViewAction")

end
function TrackPositionSelectView:Awake()

    CommonHelper:HButtonSetCallback("BtnEnter", self.gameObject, function(data)
        UIManager:Get():HidePersistentView("TrackPositionSelectView")
        if _CallBack then
            _CallBack(0)
            _CallBack=nil
        end
    end)
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():HidePersistentView("TrackPositionSelectView")
    end)
    CommonHelper:HButtonSetCallback("BtnOk", self.gameObject, function(data)
        if _CurTog==0 then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackPositionPlaceSelect))
            return
        end
        UIManager:Get():HidePersistentView("TrackPositionSelectView")
        if _CallBack then
            _CallBack(_CurTog)
            _CallBack=nil
        end
    end)

end

function TrackPositionSelectView:SetTog(idx)
    _CurTog=idx
    for i = 1, #self.Togs do
        CommonHelper:SetToggleState(self.Togs[i],idx==i)
    end
end

function TrackPositionSelectView:OnOpen()

end

function TrackPositionSelectView:OnClose()

end

function TrackPositionSelectView:SetData(trackNum,func,type,param)
    _CallBack=func
    local  trackgroup3= CommonHelper:SetGameObjectActive("trackgroup3",self.gameObject,trackNum==TrackSegmentNumbers.Three)
    local  trackgroup5= CommonHelper:SetGameObjectActive("trackgroup5",self.gameObject,trackNum==TrackSegmentNumbers.Five)
    self.Togs={}
    local parent=trackNum==TrackSegmentNumbers.Three and trackgroup3 or trackgroup5
    for i = 1, trackNum do
        self.Togs[i]=CommonHelper:HButtonSetCallback("Toggle"..i,parent,function (hbtn)
            if hbtn.intData~=_CurTog then
                self:SetTog(hbtn.intData)
            end
        end,i)
    end
    self:SetTog(0)

    local  countgroup=CommonHelper:SetGameObjectActive("countgroup",self.gameObject,type==TrackPositionViewType.Count or type==TrackPositionViewType.CostAndCount)
    local  costgroup=CommonHelper:SetGameObjectActive("costgroup",self.gameObject,type==TrackPositionViewType.Cost or type==TrackPositionViewType.CostAndCount)
    if param then
        if (type==TrackPositionViewType.Count or type==TrackPositionViewType.CostAndCount) and param[1] then
            CommonHelper:SetText("###count",countgroup,CommonHelper:GetTempStr_Default("%d/%d",param[1][1],param[1][2]))
        end
        if (type==TrackPositionViewType.Cost or type==TrackPositionViewType.CostAndCount) and param[2] then
            CommonHelper:GetComponentSetImage("costImage",costgroup,CommonHelper:GetCurrencyTypeImage(param[2][1]),UIModuleID.TrackPositionSelect)
            CommonHelper:SetText("###costNum",costgroup,CommonHelper:GetTempStr_Default("%d",param[2][2]))
        end

    end
end