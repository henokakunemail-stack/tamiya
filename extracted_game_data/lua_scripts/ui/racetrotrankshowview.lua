---@class RaceTrotRankShowView : ViewBase
RaceTrotRankShowView = class("RaceTrotRankShowView", ViewBase)

function RaceTrotRankShowView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTrotRankShowViewAction")
end

function RaceTrotRankShowView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)

end

function RaceTrotRankShowView:OnOpen()

end
function RaceTrotRankShowView:ReOpen()

end


function RaceTrotRankShowView:OnOpenAnimEnd()

end
function RaceTrotRankShowView:OnClose()
    if self.CloseFun then
        self.CloseFun()
    end

end
function RaceTrotRankShowView:OnAutoClose()

end

function RaceTrotRankShowView:SetData(isUp,score,func)
     self.CloseFun=func
    self.UpLevel= CommonHelper:SetGameObjectActive("UpLevel",self.gameObject,isUp)
    self.Normal= CommonHelper:SetGameObjectActive("Normal",self.gameObject,not isUp)

    if isUp then
        local cfg,minscore, maxscore= CommonHelper:GetTrotCfgByScore(RaceTrotManager:Get():GetCurScore(),true)
        CommonHelper:SetTrotIconGroup("rankicon_l",self.UpLevel,cfg  )
        CommonHelper:SetTrotIconGroup("rankicon_s_4",self.UpLevel,cfg  )
    else
        local cfg,minscore, maxscore= CommonHelper: GetTrotCfgByScore(RaceTrotManager:Get():GetCurScore(),true)
        CommonHelper:SetTrotGroupByData("Normal",self.gameObject,RaceTrotManager:Get().RaceTrot)
        if RaceTrotManager:Get():GetUpMatch()>-1 then
            CommonHelper:SetText("uplevelscore/###value",self.Normal,0)
        else
            CommonHelper:SetText("uplevelscore/###value",self.Normal,maxscore-RaceTrotManager:Get():GetCurScore())
        end
        CommonHelper:SetSlider("SliderBaseColor",self.Normal,RaceTrotManager:Get():GetBoxScore()/RaceTrotManager:Get():GetMaxBoxScore())
        CommonHelper:SetText("curgetscore/###value",self.Normal,score)
    end
end


