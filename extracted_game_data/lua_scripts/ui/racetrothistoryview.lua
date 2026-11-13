---@class RaceTrotHistoryView : ViewBase
RaceTrotHistoryView = class("RaceTrotHistoryView", ViewBase)

function RaceTrotHistoryView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTrotHistoryViewAction")
end

function RaceTrotHistoryView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("RaceTrotHistoryView")
    end)
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("RaceTrotHistoryView")
    end)
    CommonHelper:HButtonSetCallback("BtnRankLisk",self.gameObject,function (hbtn)
        RaceTrotSubsystem:Get():SendMsg_RankList()
    end)

end

function RaceTrotHistoryView:OnOpen()
   self:SetData()
end
function RaceTrotHistoryView:ReOpen()

end


function RaceTrotHistoryView:OnOpenAnimEnd()

end
function RaceTrotHistoryView:OnClose()

end
function RaceTrotHistoryView:OnAutoClose()

end

function RaceTrotHistoryView:SetData()
    CommonHelper:SetTrotGroupByData("Page_RaceTrotInfo", self.gameObject, RaceTrotManager:Get().RaceTrot)
    CommonHelper:SetText("###valueRankScore",self.gameObject,RaceTrotManager:Get():GetCurScore())
    CommonHelper:SetText("###valueRank",self.gameObject,string.format("%d/%d",RaceTrotManager:Get():GetBoxScore(),RaceTrotManager:Get():GetMaxBoxScore()))
    CommonHelper:SetText("BattleSum/###value",self.gameObject,tostring(RaceTrotManager:Get():GetActSum()))
    CommonHelper:SetText("WinSum/###value",self.gameObject,tostring(RaceTrotManager:Get():GetWinSum()))
end



