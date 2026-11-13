---@class ClubRaceSelfChapterView : ViewBase
ClubRaceSelfChapterView = class("ClubRaceSelfChapterView", ViewBase)

function ClubRaceSelfChapterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ClubRaceSelfChapterViewAction")
end
local _TogState=-1
local _PageIndex=0
local _Data=nil
function ClubRaceSelfChapterView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    self.BtnNext= CommonHelper:HButtonSetCallback("BtnNext",self.gameObject,function (hbtn)
        _PageIndex=ClubRaceSelfChapterDataManager:Get():GetPageIndex()
        ClubRaceSelfChapterSubsystem:Get():SendMsg_GetAllSelfChapter(_PageIndex)
    end)
    CommonHelper:HButtonSetCallback("BtnCreate",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("ClubRaceSelfChapterCreateView",CanvasType.MainCanvas,"ClubRaceSelfChapterCreateView")
    end)
    self.TogAll=CommonHelper:HButtonSetCallback("TogAll",self.gameObject,function (hbtn)
        ClubRaceSelfChapterSubsystem:Get():SendMsg_GetAllSelfChapter(_PageIndex)
    end)
    self.TogJoin= CommonHelper:HButtonSetCallback("TogJoin",self.gameObject,function (hbtn)
        ClubRaceSelfChapterSubsystem:Get():SendMsg_GetAllJoinSelfChapter()
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(data)
        CommonHelper:ShowHelpView(PageDetailType.ClubRaceSelfChapter)
    end)
    self.ScrollView=self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))
end

function ClubRaceSelfChapterView:OnOpen()
    _PageIndex=0
end

function  ClubRaceSelfChapterView:UpdateTog(idx)
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
function ClubRaceSelfChapterView:SetAllData()
    ---@type table<number,ClubRaceSelfChapterData>
    _Data=ClubRaceSelfChapterDataManager:Get():GetAllRace()
    if  _Data then
        local count=#_Data>=6 and #_Data or 6
        CommonHelper:SetHButtonClick(self.BtnNext,#_Data>=8,true)
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
end

function ClubRaceSelfChapterView:SetJoinData()
    ---@type table<number,ClubRaceSelfChapterData>
    _Data=ClubRaceSelfChapterDataManager:Get():GetAllJoinedRace()
    if  _Data then
        local count=#_Data>=6 and #_Data or 6
        CommonHelper:SetHButtonClick(self.BtnNext,#_Data>=8,true)
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
end
function ClubRaceSelfChapterView:SetItem(index, itemObj,scroll)
    -----@type ClubRaceSelfChapterData
    local temp=_Data[index+1]
    CommonHelper:SetGameObjectActive("empty",itemObj,temp==nil)
    CommonHelper:SetGameObjectActive("race",itemObj,temp~=nil)
    if temp then
        CommonHelper:SetText("bgtittlejoin/###racename",itemObj,CommonHelper:GetTempStr_Default(temp.cfg.racename))
        CommonHelper:SetText("bgtittlenormal/###racename",itemObj,CommonHelper:GetTempStr_Default(temp.cfg.racename))
        CommonHelper:SetText("###racedesc",itemObj,CommonHelper:GetTempStr_Default(temp.masterName))
        CommonHelper:SetText("lvlimithit/###lv",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevel ,temp.cfg.levelLimit))
        CommonHelper:SetText("numlimit/###num",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterJoin,temp.cfg.joinLimit))
        CommonHelper:SetText("###racetime",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterDuration,temp.subDay,temp.subHour))
        CommonHelper:SetPlayerIconById("PlayerIcon",itemObj,temp.masterIcon,nil,nil,UIModuleID.RaceSelfChapter)

        local btn= CommonHelper:HButtonSetCallback("BtnJoin",itemObj,function(btnData)
            ClubRaceSelfChapterSubsystem:Get():SendMsg_GetSelfChapterDetail(_Data[btnData.intData+1].id)
        end,index)
        CommonHelper:SetToggleState(btn,temp.isJoin)
        CommonHelper:SetGameObjectActive("bgtittlejoin",itemObj,temp.isJoin)
        CommonHelper:SetGameObjectActive("bgtittlenormal",itemObj,not temp.isJoin)
    end
end
function ClubRaceSelfChapterView:OnClose()
    _TogState=-1
end
function ClubRaceSelfChapterView:OnAutoClose()
    _TogState=-1
end
