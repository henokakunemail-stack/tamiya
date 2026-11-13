


---@class ChampionshipView : ViewBase
ChampionshipView = class("ChampionshipView", ViewBase)

function ChampionshipView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ChampionshipViewAction")
end

function ChampionshipView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnRaceWeek",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("RaceWeekView",CanvasType.MainCanvas,"RaceWeekView")
    end)
end

function ChampionshipView:OnOpen()

end

function ChampionshipView:OnClose()

end

function ChampionshipView:SetBtnRaceWeek()

end