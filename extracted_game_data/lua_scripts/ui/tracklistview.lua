


---@class TrackListView : ViewBase
TrackListView = class("TrackListView", ViewBase)

local _CallBack=nil
---@type RaceTrackData
local _RaceTrackData=nil
local __SelectIdx=nil
local _Tog=-1
local _TogTrackNum=-1
local _FilterTrackNum=-1
local _FilterTrackType=-1
local _TrackListModule=-1
function TrackListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "TrackListViewAction")

    ---@type table<number, RaceRoomData>
    self.RoomList = {}

    self.AutoFlag = true
end

function TrackListView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
       -- _CallBack(-1)
        UIManager:Get():CloseView()
    end)

    self.TogSystem=CommonHelper:HButtonSetCallback("BtnSystem",self.gameObject,function (hbtn)
       _Tog=1
        self:UpdateTogSystemOrCustom()
    end)
    self.TogCustom=CommonHelper:HButtonSetCallback("BtnCustom",self.gameObject,function (hbtn)
        _Tog=2
        self:UpdateTogSystemOrCustom()
    end)
    self.TogThree=CommonHelper:HButtonSetCallback("BtnThree",self.gameObject,function (hbtn)
        _TogTrackNum=3
        self:UpdateTogThreeOrFive()
    end)
    self.TogFive=CommonHelper:HButtonSetCallback("BtnFive",self.gameObject,function (hbtn)
        _TogTrackNum=5
        self:UpdateTogThreeOrFive()
    end)
    self.ScrollView= self:GetChildWightByParent("MoreRowScrollView_V",self.gameObject,typeof(MoreRowScrollView))
end

function TrackListView:OnOpen()
    self:AutoSelect()
end

--------------------------数据
function TrackListView:SetSystemData()
    self.CurList = CommonHelper:GetTrackListByType(MiniTrackType.System,nil,_TrackListModule)
end

function TrackListView:SetCustomData()
    self.CurList = CommonHelper:GetTrackListByType(MiniTrackType.SelfCustomTrack,nil,_TrackListModule)
end

function TrackListView:SetSystemDataByTrackNum()
    self.CurList=CommonHelper:GetTrackListByType(MiniTrackType.System,_TogTrackNum,_TrackListModule)
end

function TrackListView:SetCustomDataByTrackNum()
    self.CurList=CommonHelper:GetTrackListByType(MiniTrackType.SelfCustomTrack,_TogTrackNum,_TrackListModule)
end

function TrackListView:AutoSelect()
    if _FilterTrackType==MiniTrackType.System or _FilterTrackType== MiniTrackType.LocalCustomTrack then
        CommonHelper:SetHButtonClick(self.TogSystem,true,true)
        CommonHelper:SetHButtonClick(self.TogCustom,false,true)
        --UIUtil:HButtonLocalPositionY(self.TogCustom, 216)
        _Tog=1
        CommonHelper:SetGameObjectActive("btncustomImage",self.gameObject,false)
    elseif  _FilterTrackType==MiniTrackType.SelfCustomTrack or _FilterTrackType== MiniTrackType.OtherCustomTrack then
        CommonHelper:SetHButtonClick(self.TogSystem,false,true)
        CommonHelper:SetHButtonClick(self.TogCustom,true,true)
        CommonHelper:SetGameObjectActive("btncustomImage",self.gameObject,false)
        _Tog=2
        UIUtil:HButtonLocalPositionY(self.TogCustom, 318)
    elseif _FilterTrackType==MiniTrackType.None then
        CommonHelper:SetHButtonClick(self.TogSystem,true,true)
        CommonHelper:SetHButtonClick(self.TogCustom,true,true)
        CommonHelper:SetGameObjectActive("btncustomImage",self.gameObject,true)
        --UIUtil:HButtonLocalPositionY(self.TogCustom, 216)
        _Tog=1
    end
    if _FilterTrackNum~=-1 then
        self:UpdateTogSystemOrCustom()
        _TogTrackNum=_FilterTrackNum
        CommonHelper:SetHButtonClick(self.TogThree,false,true)
        CommonHelper:SetHButtonClick(self.TogFive,false,true)
        __SelectIdx=0
        self:UpdateTogThreeOrFive()
    else
        _FilterTrackNum=-1
        CommonHelper:SetHButtonClick(self.TogThree,false,true)
        CommonHelper:SetHButtonClick(self.TogFive,false,true)
        __SelectIdx = 0
        self:UpdateTogSystemOrCustom()
    end


end

function TrackListView:UpdateTogThreeOrFive()
    CommonHelper:SetToggleState(self.TogThree,_TogTrackNum==3)
    CommonHelper:SetToggleState(self.TogFive,_TogTrackNum==5)
    if _TogTrackNum~=-1 then
        if _Tog==1 then
            self:SetSystemDataByTrackNum()
        elseif _Tog==2 then
            self:SetCustomDataByTrackNum()
        end
        __SelectIdx=0
        cs_coroutine.start(function()
            coroutine.yield()
            coroutine.yield()
            self:UpdateScrollView()
        end)

    end
end

function TrackListView:UpdateTogSystemOrCustom()
    CommonHelper:SetToggleState(self.TogSystem,_Tog==1)
    CommonHelper:SetToggleState(self.TogCustom,_Tog==2)

    if _Tog==1 then
        self:SetSystemData()
    elseif _Tog==2 then
        self:SetCustomData()
    end

    _TogTrackNum=_FilterTrackNum
    self:UpdateTogThreeOrFive()
    __SelectIdx=0
    cs_coroutine.start(function()
        coroutine.yield()
        coroutine.yield()
        self:UpdateScrollView()
    end)
end


function TrackListView:UpdateScrollView()
    CommonHelper:InitMoreRowScrollView(self.ScrollView,#self.CurList,5,function(index, itemObj,scroll)
         ---@type RaceTrackData
          local data = self.CurList[index+1]
        if data and data:GetIsEdit() then
            CommonHelper:GetComponentSetTrackIconByData("trackicon",itemObj,data,UIModuleID.TrackListView)
        else
            CommonHelper:GetComponentSetUITexture("trackicon",itemObj,"uitex_sucai_default.png",UIModuleID.TrackListView)
        end



          local ReviewBtn= CommonHelper:HButtonSetCallback("ReviewBtn",itemObj,function(data)
              local date= self.CurList[data.intData+1]
              if not date:GetIsEdit() then
                  CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNotEditNotReview))
                  return
              end
              CommonHelper:LoadReviewTrack(nil, date)
          end,index)
          local EditBtn= CommonHelper:HButtonSetCallback("EditBtn",itemObj,function(data)
              local trackData = self.CurList[data.intData + 1]
              local customTrackData=trackData:GetCustomData()
              if trackData:GetIsEdit()==false then
                  customTrackData.name=CommonHelper:GetTempStr_Default(TemplateStringID.CustomTrackMy,data.intData+1)
                  customTrackData.TrackNumbers=TrackSegmentNumbers.Three
              end
              CommonHelper:LoadCustomTrack(trackData,MiniTrackSystem.Self)
          end,index)
          CommonHelper:SetHButtonClick(EditBtn,false,true)

          CommonHelper:SetTrackFeatureByParent("trackfeature",itemObj,data:GetFeature())


        CommonHelper:HButtonSetCallback("BtnOk",itemObj,function (hbtn)
            _RaceTrackData = self.CurList[index + 1]

            if _RaceTrackData~=nil then
                if _RaceTrackData:GetCanRun()==false then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNotCanRun))
                    return
                end
                if _RaceTrackData:GetIsEdit()==false then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackNotEdit))
                    return
                end
                if _RaceTrackData:GetIsEdit() and _RaceTrackData:GetCanRun() then
                    _CallBack(_RaceTrackData)
                    UIManager:Get():CloseView()
                end
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PleaseSelectTrack))
            end
        end)
    end)
    CommonHelper:MoreRowView_EnterAni1(self.ScrollView, 0.2)
end

function TrackListView:ReOpen()

end
function TrackListView:SetCallBack(callBack,trackNum,miniTrackType,trackListModule)
    _CallBack=callBack
    _FilterTrackNum=trackNum
    _FilterTrackType=miniTrackType
    _TrackListModule=trackListModule
end
function TrackListView:OnClose()
  self.CurList=nil
  __SelectIdx=-1
  _Tog=1
  _TogTrackNum=-1
    _TrackListModule=TrackListModule.None
    CommonHelper:ReleasePool(UIModuleID.TrackListView)
end
function TrackListView:OnAutoClose()

end


