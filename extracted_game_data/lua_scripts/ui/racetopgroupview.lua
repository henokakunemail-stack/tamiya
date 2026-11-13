---@class RaceTopGroupView : ViewBase
RaceTopGroupView = class("RaceTopGroupView", ViewBase)

function RaceTopGroupView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTopGroupViewAction")
end

function RaceTopGroupView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("ScrollView", self.gameObject, typeof(MoreRowScrollView))
end

function RaceTopGroupView:OnOpen()
   self:SetData(true)
end

function RaceTopGroupView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceTopGroup)
end
function RaceTopGroupView:SetData(isref)
    ---@type RaceTopGroup
    self.Data=RaceTopManager:Get():GetRaceGroupData()
    local list={}
    local count=4
    if self.Data.List2 then
        list=self.Data.List2
        CommonHelper:SetText("###title", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopSuperGroup))
    elseif self.Data.List4 then
        list=self.Data.List4
        CommonHelper:SetText("###title", self.gameObject,  CommonHelper:GetTempStr_Default(TemplateStringID.RaceTop4Group))
    elseif self.Data.List8 then
        list=self.Data.List8
        CommonHelper:SetText("###title", self.gameObject,  CommonHelper:GetTempStr_Default(TemplateStringID.RaceTop8Group))
    elseif self.Data.List16 then
        list=self.Data.List16
        CommonHelper:SetText("###title", self.gameObject,  CommonHelper:GetTempStr_Default(TemplateStringID.RaceTop16Group))
    elseif self.Data.List32 then
        list=self.Data.List32
        CommonHelper:SetText("###title", self.gameObject,  CommonHelper:GetTempStr_Default(TemplateStringID.RaceTop32Group))
    else
        CommonHelper:SetText("###title", self.gameObject,  CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopGroupInfo))
    end
    if #list>=4 then
        count=#list
    end
    CommonHelper:InitMoreRowScrollView(self.ScrollView, count, 1,function(dataIndex, itemObj, scroll)
        ---@type RaceTopGroupInfo
        local data=list[dataIndex+1]
        CommonHelper:SetGameObjectActive("values",itemObj,data~=nil)
        CommonHelper:SetText("###rank", itemObj, tostring(dataIndex+1))
        if data then
            if data.Time<=0 then
                CommonHelper:SetText("###time", itemObj, "--:--:--")
            else
                CommonHelper:GetComponentTransferTime("###time", itemObj, data.Time)
            end
            if data.FTime<=0 then
                CommonHelper:SetText("###ftime", itemObj, "--:--:--")
            else
                CommonHelper:GetComponentTransferTime("###ftime", itemObj, data.FTime)
            end
            if data.Rid>0 then
                CommonHelper:HButtonSetCallback("BtnRecord1",itemObj,function(hbtn)
                    UIManager:Get():ClosePopup()
                    RaceTopSubsystem:Get():SendMsg_BeginBattleRaceTopRecord(hbtn.intData,2)
                end,data.Rid)
                CommonHelper:SetGameObjectActive("Rank/BtnGood",itemObj,true)
                local  TogGood1=CommonHelper:HButtonSetCallback("Rank/BtnGood",itemObj,function(hbtn)
                    if self.Data.AgreeId>0 then
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopAgreeed))
                        return
                    end
                    if self.Data.CanAgree==false then
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopAgreeNoTime))
                        return
                    end
                    RaceTopSubsystem:Get():SendMsg_RaceTopGood(hbtn.intData)
                end,data.Rid)
                local goodeNum=0
                if self.Data.GoodList[data.Rid] then
                    goodeNum=self.Data.GoodList[data.Rid]
                end
                CommonHelper:SetText("Rank/###goodvalue", itemObj, tostring(goodeNum))
                CommonHelper:SetToggleState(TogGood1,data.Rid==self.Data.AgreeId)
                CommonHelper:SetGameObjectActive("BtnRecord1",itemObj,data.Time>0)
                CommonHelper:SetText("Rank/###playername", itemObj, data.RoleName)
                CommonHelper:SetPlayerIconById("Rank/PlayerIcon", itemObj, data.HeadIcon, data.IconFrame, nil, UIModuleID.RaceTopGroup)
            else
                CommonHelper:SetText("###time", itemObj, "")
                CommonHelper:SetText("Rank/###playername", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopGroupNull))
                CommonHelper:SetText("Rank/###goodvalue", itemObj, "")
                CommonHelper:SetGameObjectActive("BtnRecord1",itemObj,false)
                CommonHelper:SetGameObjectActive("Rank/BtnGood",itemObj,false)
                CommonHelper:SetPlayerIcon("Rank/PlayerIcon", itemObj, "playericon_z_default.png", "player_kuangicon_1.png", nil, UIModuleID.RaceTopGroup)
            end
            if data.FRid>0 then
                CommonHelper:HButtonSetCallback("BtnRecord2",itemObj,function(hbtn)
                    UIManager:Get():ClosePopup()
                    RaceTopSubsystem:Get():SendMsg_BeginBattleRaceTopRecord(hbtn.intData,2)
                end,data.FRid)
                CommonHelper:SetGameObjectActive("FRank/BtnGood",itemObj,true)
                local  TogGood2=CommonHelper:HButtonSetCallback("FRank/BtnGood",itemObj,function(hbtn)
                    if self.Data.AgreeId>0 then
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopAgreeed))
                        return
                    end
                    if self.Data.CanAgree==false then
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopAgreeNoTime))
                        return
                    end
                    RaceTopSubsystem:Get():SendMsg_RaceTopGood(hbtn.intData)
                end,data.FRid)
                local goodeNum=0
                if self.Data.GoodList[data.FRid] then
                    goodeNum=self.Data.GoodList[data.FRid]
                end
                CommonHelper:SetText("FRank/###goodvalue", itemObj,tostring(goodeNum))
                CommonHelper:SetToggleState(TogGood2,data.FRid==self.Data.AgreeId)
                CommonHelper:SetGameObjectActive("BtnRecord2",itemObj,data.FTime>0)
                CommonHelper:SetText("FRank/###playername", itemObj, data.FRoleName)
                CommonHelper:SetPlayerIconById("FRank/PlayerIcon", itemObj, data.FHeadIcon, data.FIconFrame, nil, UIModuleID.RaceTopGroup)
            else
                CommonHelper:SetText("###ftime", itemObj, "")
                CommonHelper:SetText("FRank/###playername", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopGroupNull))
                CommonHelper:SetText("FRank/###goodvalue", itemObj, "")
                CommonHelper:SetGameObjectActive("BtnRecord2",itemObj,false)
                CommonHelper:SetGameObjectActive("FRank/BtnGood",itemObj,false)
                CommonHelper:SetPlayerIcon("FRank/PlayerIcon", itemObj, "playericon_z_default.png", "player_kuangicon_1.png", nil, UIModuleID.RaceTopGroup)
            end




            --  CommonHelper:SetText("###clubername", MyRank, player.PlayerName)
            --头像

        end
    end,nil,nil,isref)
end

