



---@class RaceRoomReviseView : ViewBase
RaceRoomReviseView = class("RaceRoomReviseView", ViewBase)

function RaceRoomReviseView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRoomReviseViewAction")

    ---@type RaceTrackData
    self.TrackInfo = nil

    self.FlagOb = false
end

function RaceRoomReviseView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_SetViewInfo,{"RaceRoomReviseView",false})
        UIManager:Get():HidePersistentView("RaceRoomReviseView")
    end)
    CommonHelper:HButtonSetCallback("BtnCloseMask2",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_SetViewInfo,{"RaceRoomReviseView",false})
        UIManager:Get():HidePersistentView("RaceRoomReviseView")
    end)

    CommonHelper:HButtonSetCallback("BtnReview",self.gameObject,function (hbtn)
        CommonHelper:LoadReviewTrack(nil, self.TrackInfo)
    end)

    CommonHelper:HButtonSetCallback("BtnChange",self.gameObject,function (hbtn)
        local limit = self.TrackInfo:GetRaceNumber()
        CommonHelper:OpenTrackListView(function(data)
            self.TrackInfo = data
            self:SetTrackInfo(data)
        end,limit,MiniTrackType.System,TrackListModule.RaceRoom)

    end)

    CommonHelper:HButtonSetCallback("BtnRevise",self.gameObject,function (hbtn)
        self:CreateRoom()
    end)

    self.TogObFlagTrue = CommonHelper:HButtonSetCallback("flagObTrue",self.gameObject,function (hbtn)
        self:SetObFlag(true)
    end)

    self.TogObFlagFalse = CommonHelper:HButtonSetCallback("flagObFalse",self.gameObject,function (hbtn)
        self:SetObFlag(false)
    end)


end

function RaceRoomReviseView:OnOpen()

end
function RaceRoomReviseView:OnClose()

end
function RaceRoomReviseView:OnAutoClose()

end

function RaceRoomReviseView:AutoSelect()
    self:SetObFlag(RaceRoomManager:Get():IsAllowObserver())
    CommonHelper:SetInputFieldText("InputName", self.gameObject, RaceRoomManager:Get():GetName())
    CommonHelper:InputFieldSetDefaultText("InputName", self.gameObject, RaceRoomManager:Get():GetName())
    CommonHelper:SetInputFieldText("InputPasswd", self.gameObject,  RaceRoomManager:Get():GetPassword())

    self.TrackInfo = RaceRoomManager:Get():GetTrackData()
    self:SetTrackInfo(self.TrackInfo)
end

function RaceRoomReviseView:SetObFlag(value)
    self.FlagOb = value
    CommonHelper:SetToggleState(self.TogObFlagTrue, value)
    CommonHelper:SetToggleState(self.TogObFlagFalse, not value)
end

---@param data RaceTrackData
function RaceRoomReviseView:SetTrackInfo(data)
    CommonHelper:GetComponentSetTrackIconByData("trackicon", self.gameObject, data, UIModuleID.RaceRoomCreate)
    CommonHelper:SetText("tracktype/text",self.gameObject,data:GetRaceNumName())
    CommonHelper:SetTrackFeatureByParent("trackfeature",self.gameObject,data:GetFeature())
end




function RaceRoomReviseView:CreateRoom()
    local name = CommonHelper:GetInputFieldText("InputName", self.gameObject)
    local passwd = CommonHelper:GetInputFieldText("InputPasswd", self.gameObject)

    RaceRoomSubsystem:Get():SendMsg_ReviseRoom(self.TrackInfo:GetId(), name, passwd, self.FlagOb)
end
