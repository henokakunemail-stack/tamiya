


---@class RaceMenuView:ViewBase
RaceMenuView = class("RaceMenuView", ViewBase)

function RaceMenuView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceMenuViewAction")

end

function RaceMenuView:Awake()
    CommonHelper:HButtonSetCallback("BtnRaceSys",self.gameObject,function (hbtn)
        --CommonTipsHelper:Get():ShowCenterTips("功能未开启，敬请期待")
    end)

    CommonHelper:HButtonSetCallback("BtnRaceSelf",self.gameObject,function (hbtn)
        --UIManager:Get():OpenView("RaceSelfView",CanvasType.MainCanvas,"RaceSelfView")
        --RaceSelfSubsystem:Get():SendMsg_GetAllList()
    end)

    CommonHelper:HButtonSetCallback("BtnRaceRoom",self.gameObject,function (hbtn)
        --UIManager:Get():OpenView("RaceRoomView",CanvasType.MainCanvas,"RaceRoomView")
    end)

    CommonHelper:HButtonSetCallback("BtnRaceSys",self.gameObject,function (hbtn)
        --UIManager:Get():OpenView("ChampionshipView",CanvasType.MainCanvas,"ChampionshipView")
        --RaceWeekSubsystem:Get():SendMsg_GetAllList()
    end)
end

function RaceMenuView:OnOpen()

end

function RaceMenuView:OnClose()

end