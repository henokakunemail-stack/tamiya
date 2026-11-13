

local _PageIndex=-1
local _TogState=-1
local _Data=nil
---@class RaceSelfLevelView : ViewBase
RaceSelfLevelView = class("RaceSelfLevelView", ViewBase)

function RaceSelfLevelView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfLevelViewAction")
end

function RaceSelfLevelView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnCreate",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("RaceSelfLevelCreateView",CanvasType.MainCanvas,"RaceSelfLevelCreateView")
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(data)
        CommonHelper:ShowHelpView(PageDetailType.RaceSelfLevel)
    end)
    self.BtnNext= CommonHelper:HButtonSetCallback("BtnNext",self.gameObject,function (hbtn)
        _PageIndex=RaceSelfLevelDataManager:Get():GetPageIndex()
        _TogState=-1
        RaceSelfLevelSubsystem:Get():SendMsg_SelfLevelGetList(_PageIndex)
    end)
    self.TogAll=CommonHelper:HButtonSetCallback("TogAll",self.gameObject,function (hbtn)
        RaceSelfLevelSubsystem:Get():SendMsg_SelfLevelGetList(_PageIndex)
    end)
    self.TogJoin= CommonHelper:HButtonSetCallback("TogJoin",self.gameObject,function (hbtn)
        RaceSelfLevelSubsystem:Get():SendMsg_SelfLevelGetJoinList()
    end)
    self.ScrollView=self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))
end

function RaceSelfLevelView:OnOpen()
    _PageIndex=0
end

function  RaceSelfLevelView:UpdateTog(idx)
    if _TogState ~=idx then
        _TogState=idx
        CommonHelper:SetToggleState(self.TogAll,_TogState==1)
        CommonHelper:SetToggleState(self.TogJoin,_TogState==2)
        if _TogState==1 then
            self:SetAllData()
        elseif _TogState==2 then
            self:SetJoinData()
        end
    end
end
function RaceSelfLevelView:SetJoinData()
    ---@type table<number,RaceSelfLevelData>
    _Data=RaceSelfLevelDataManager:Get():GetAllJoinedRace()
    local count=#_Data>=6 and #_Data or 6
    CommonHelper:SetHButtonClick(self.BtnNext,#_Data>=6,true)
    CommonHelper:InitMoreRowScrollView(self.ScrollView,count,3,function(index, itemObj,scroll)
         self:SetItem(index, itemObj,scroll)
    end,false,function(index, row,itemObj,scroll)
        if #_Data==0 then
            CommonHelper:SetGameObjectActive("line2",itemObj,true)
            CommonHelper:SetGameObjectActive("line1",itemObj,false)
        end
        if #_Data>0 and #_Data<=row then
            CommonHelper:SetGameObjectActive("line2",itemObj,false)
            CommonHelper:SetGameObjectActive("line1",itemObj,true)
        end
        if #_Data>row  then
            CommonHelper:SetGameObjectActive("line2",itemObj,false)
            CommonHelper:SetGameObjectActive("line1",itemObj,true)
        end
    end)
    CommonHelper:MoreRowView_EnterAni1(self.ScrollView, 0.2)
end
local _SelectRace=-1
function RaceSelfLevelView:SetAllData()
    ---@type table<number,RaceSelfLevelData>
     _Data=RaceSelfLevelDataManager:Get():GetAllRace()
    local count=#_Data>=6 and #_Data or 6
    CommonHelper:SetHButtonClick(self.BtnNext,#_Data>=6,true)
    CommonHelper:InitMoreRowScrollView(self.ScrollView,count,3,function(index, itemObj,scroll)
        self:SetItem(index, itemObj,scroll)
    end,false,function(index, row,itemObj,scroll)
        if #_Data==0 then
            CommonHelper:SetGameObjectActive("line2",itemObj,true)
            CommonHelper:SetGameObjectActive("line1",itemObj,false)
        end
        if #_Data>0 and #_Data<=row then
            CommonHelper:SetGameObjectActive("line2",itemObj,false)
            CommonHelper:SetGameObjectActive("line1",itemObj,true)
        end
        if #_Data>row  then
            CommonHelper:SetGameObjectActive("line2",itemObj,false)
            CommonHelper:SetGameObjectActive("line1",itemObj,true)
        end
    end)
    CommonHelper:MoreRowView_EnterAni1(self.ScrollView, 0.2)
end

function RaceSelfLevelView:SetDetail(data)

end

function RaceSelfLevelView:SetItem(index, itemObj,scroll)
    -----@type RaceSelfLevelData
    local temp=_Data[index+1]

    CommonHelper:SetGameObjectActive("empty",itemObj,temp==nil)
    CommonHelper:SetGameObjectActive("race",itemObj,temp~=nil)
    if temp then
        CommonHelper:SetGameObjectActive("nojoin",itemObj,not temp.isJoin)
        CommonHelper:SetGameObjectActive("join",itemObj, temp.isJoin)
        CommonHelper:SetText("nojoin/###racename",itemObj,CommonHelper:GetTempStr_Default(temp.name))
        CommonHelper:SetText("join/###racename",itemObj,CommonHelper:GetTempStr_Default(temp.name))
        CommonHelper:SetText("###racedesc",itemObj,CommonHelper:GetTempStr_Default(temp.masterName))
        --CommonHelper:SetText("lvlimithit/###lv",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevel ,temp.cfg.levelLimit))
        --CommonHelper:SetText("numlimit/###num",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterJoin,temp.cfg.joinLimit))
        --CommonHelper:SetText("joinnum/###num",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterJoin,temp.cfg.joinLimit))
        --CommonHelper:SetText("rewardnum/###num",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterJoin,temp.cfg.joinLimit))
        --CommonHelper:SetText("###racecount",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterDuration,temp.subDay,temp.subHour))
        if temp.heroId==0 then
            CommonHelper:SetPlayerIconById("PlayerIcon",itemObj,temp.masterIcon,nil,nil,UIModuleID.RaceSelfChapter)
        else
            CommonHelper:GetComponentSetUITexture("icon", itemObj, temp.NpcIcon, UIModuleID.RaceSelfChapter)
        end


        local btn= CommonHelper:HButtonSetCallback("BtnJoin",itemObj,function(btnData)
                RaceSelfLevelSubsystem:Get():SendMsg_SelfLevelGetDetail(_Data[btnData.intData+1].id)
        end,index)
        CommonHelper:HButtonSetCallback("BtnDetail",itemObj,function(btnData)
               CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FunctionNoWait))
        end,index)
        --CommonHelper:SetToggleState(btn,temp.isJoin)
        --CommonHelper:SetGameObjectActive("bgtittlejoin",itemObj,temp.isJoin)
        --CommonHelper:SetGameObjectActive("bgtittlenormal",itemObj,not temp.isJoin)
    end
    ----CommonHelper:GetComponentSetUITexture("rackIcon",itemObj,temp.cfg.icon,UIModuleID.RaceSelfChapter)
    ----CommonHelper:SetText("raceName",itemObj,CommonHelper:GetTempStr_Default(temp.cfg.name))
    --
    ----CommonHelper:SetText("raceTime",itemObj,CommonHelper:GetTempStr_Default(temp.cfg.name))
    --CommonHelper:SetText("raceTime",itemObj,temp.id)
    --CommonHelper:SetText("racePre",itemObj,temp.level)
    --CommonHelper:HButtonSetCallback("BtnJoin",itemObj,function(btnData)
    --    -- RaceSelfLevelSubsystem:Get():SendMsg_SelfLevelGetDetail(temp.id)
    --    _SelectRace=btnData.intData+1
    --    RaceSelfLevelSubsystem:Get():SendMsg_SelfLevelGetDetail(_Data[btnData.intData+1].id)
    --end,index)
    --CommonHelper:HButtonSetCallback("BtnInfo",itemObj,function(btnData)

   -- end,index)
end

function RaceSelfLevelView:OnClose()
    _TogState=-1
end

function RaceSelfLevelView:OnAutoClose()
    _TogState=-1
end

