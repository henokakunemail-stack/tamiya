



---@class RaceOverlookView : ViewBase
RaceOverlookView = class("RaceOverlookView", ViewBase)

function RaceOverlookView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceOverlookViewAction")

end
local _CustomTrackCameraCtrl=nil
local _CustomTrackCameraModel=-1
function RaceOverlookView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        CommonHelper:SetToggleState(self.TopBtn,false)
        CommonHelper:SetToggleState(self.FreeBtn,true)
        if _CustomTrackCameraModel==2 then
            _CustomTrackCameraCtrl:SwitchNormalView()
            _CustomTrackCameraModel=1
        end
        _CustomTrackCameraCtrl=nil
        SelfDefineTrack:RecycleAll()
        SelfDefineTrack:Clear()
        UIManager:Get():CloseView()
    end)
 self.TopBtn= CommonHelper:HButtonSetCallback("CameraViewBtn1",self.gameObject,function (hbtn)
      if _CustomTrackCameraCtrl==nil then
          _CustomTrackCameraCtrl=CSCameraManager:Get().gameObject:GetComponent(typeof(CS.Horizon.Game.ShowLayer.SelfDefineTrackCameraCtrl))
      end
      CommonHelper:SetToggleState(self.TopBtn,true)
      CommonHelper:SetToggleState(self.FreeBtn,false)
     if _CustomTrackCameraModel==1 then
         _CustomTrackCameraCtrl:SwitchTopView()
         _CustomTrackCameraModel=2
     end
    end)
    self.FreeBtn=  CommonHelper:HButtonSetCallback("CameraViewBtn2",self.gameObject,function (hbtn)
      if _CustomTrackCameraCtrl==nil then
          _CustomTrackCameraCtrl=CSCameraManager:Get().gameObject:GetComponent(typeof(CS.Horizon.Game.ShowLayer.SelfDefineTrackCameraCtrl))
      end
        CommonHelper:SetToggleState(self.TopBtn,false)
        CommonHelper:SetToggleState(self.FreeBtn,true)
        if _CustomTrackCameraModel==2 then
            _CustomTrackCameraCtrl:SwitchNormalView()
            _CustomTrackCameraModel=1
        end
    end)
    CommonHelper:SetToggleState(self.TopBtn,false)
    CommonHelper:SetToggleState(self.FreeBtn,true)
end

function RaceOverlookView:OnOpen()
    if self.TopBtn then
        CommonHelper:SetToggleState(self.TopBtn,false)
    end
    if self.FreeBtn then
        CommonHelper:SetToggleState(self.FreeBtn,true)
    end
    _CustomTrackCameraModel=1
    cs_coroutine.start(function()
        coroutine.yield()
       local gameObject= GameObject.Find("MiniTrack_Root")
        if not CommonHelper:GameObjectIsNull(gameObject) then
            self:setMiniTrackRootPosition(gameObject)
        end
    end)
end
function RaceOverlookView:setMiniTrackRootPosition(miniTrackRoot)
    if miniTrackRoot.transform.childCount > 0 then
        local firstChild = miniTrackRoot.transform:GetChild(0)
        local childBounds = HMath.GetBounds(firstChild)
        local rootBounds = HMath.GetBounds(miniTrackRoot)

        -- 计算偏移
        local offset = childBounds.min.y - rootBounds.min.y

        -- 设置 MiniTrack_Root 的位置
        miniTrackRoot.transform.position = miniTrackRoot.transform.position + Vector3(0, offset, 0)
    end
end

function RaceOverlookView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end
function RaceOverlookView:OnClose()
    CommonHelper:UnloadTrack()
end