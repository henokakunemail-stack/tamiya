---@class CustomTrackListView : ViewBase
CustomTrackListView = class("CustomTrackListView", ViewBase)
local _Top=nil
local _Center=nil
local _Bottom=nil
local _SelectType=nil
local _Data=nil
function CustomTrackListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "CustomTrackListViewAction")
end

function CustomTrackListView:Awake()
    _Top=self:GetChild("Top")
    _Center=self:GetChild("Center")
    _Bottom=self:GetChild("Bottom")
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (data)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(data)
        CommonHelper:ShowHelpView(PageDetailType.CustomTrack)
    end)
    self.TogThree=CommonHelper:HButtonSetCallback("TogThree", self.gameObject, function(data)
        self:TogClick(TrackSegmentNumbers.Three)
    end)
    self.TogFive=CommonHelper:HButtonSetCallback("TogFive", self.gameObject, function(data)
        self:TogClick(TrackSegmentNumbers.Five)
    end)
    self.trackList=self:GetChildWightByParent("MoreRowScrollView_V",_Center,typeof(MoreRowScrollView))
end
function CustomTrackListView:TogClick(type,ischeck)
    if type~=_SelectType or ischeck then
        _SelectType=type
        CommonHelper:SetToggleState(self.TogFive,_SelectType==TrackSegmentNumbers.Five)
        CommonHelper:SetToggleState(self.TogThree,_SelectType==TrackSegmentNumbers.Three)
        self:SetData()
    end
end
function CustomTrackListView:SetData()
    _Data= RaceTrackDataManager:Get():GetCustomTrackListByType(_SelectType)
    CommonHelper:InitMoreRowScrollView(self.trackList,#_Data,3,function (index, itemObj,scroll)
        UINotify:Get():SendNotification(UINotifyEvent.CustomTrackItemSetData,{index+1,itemObj})
    end)
    CommonHelper:MoreRowView_EnterAni1(self.trackList, 0.12)
end
local _CreateToggleState= {TrackSegmentNumbers.Three,TrackSegmentNumbers.Three,TrackSegmentNumbers.Three}
function CustomTrackListView:SetItem(index,itemObj)
    ---@type RaceTrackData
    local trackData=RaceTrackDataManager:Get():GetRaceDataByIndex(_Data[index])
    local detail= CommonHelper:SetGameObjectActive("detail",itemObj,false)
    if trackData and trackData:GetIsEdit() then
        CommonHelper:SetGameObjectActive("add",itemObj,false)
        CommonHelper:SetGameObjectActive("lock",itemObj,false)
        local edit= CommonHelper:SetGameObjectActive("edit",itemObj,true)

        CommonHelper:SetText("###trackname",detail,trackData:GetName())
        CommonHelper:SetText("###createer",detail,PlayerDataManager:Get():GetPlayerName())
        local Time = CommonHelper:ConvertIntToDataTime(trackData:GetCreateTime()*1000)
        local startTimeStr = Time:ToString("yyyy-MM/dd")
        CommonHelper:SetText("###createtime",detail,startTimeStr)

        CommonHelper:SetText("###tracknum",detail,CommonHelper:GetTrackTypeNameByNumber(trackData:GetRaceNumber()))
        local second=CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterDefaultTime)
        if trackData:GetTestRunTime()>0 then
            second = self:ParseTime(trackData:GetTestRunTime())
        end
        CommonHelper:SetText("###runtime",detail,second)
        self:SetStar(trackData:GetScore(),5,detail)
        self:SetStar(trackData:GetScore(),5,edit)

        CommonHelper:HButtonSetCallback("editBtn",itemObj,function (data)
            CommonHelper:LoadCustomTrack(trackData,MiniTrackSystem.Self)
        end)
        CommonHelper:GetComponentSetTrackIconByData("trackicon",itemObj,trackData,UIModuleID.CustomTrackList)

        CommonHelper:HButtonSetCallback("DelBtn",itemObj,function (data)
            local temptrack= RaceTrackDataManager:Get():GetRaceDataByIndex(_Data[data.intData])
            CustomtrackSubsystem:Get():SendMsg_DelTrack(temptrack:GetServerIdx(),1)
        end,index)
        CommonHelper:HButtonSetCallback("DetailBtn",itemObj,function (data)
          local obj= CommonHelper:MoreRowView_GetItemObj(self.trackList,index-1)
            CommonHelper:SetGameObjectActive("detail",obj,true)
        end,index)
        CommonHelper:HButtonSetCallback("BackBtn",itemObj,function (data)
          local obj= CommonHelper:MoreRowView_GetItemObj(self.trackList,index-1)
            CommonHelper:SetGameObjectActive("detail",obj,false)
        end,index)
        CommonHelper:HButtonSetCallback("TestRunBtn",itemObj,function (data)
            local temptrack= RaceTrackDataManager:Get():GetRaceDataByIndex(_Data[data.intData])
            if temptrack:GetCanRun() then
                if CarDataManager:Get():CheckCarCompleteness(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex()) then
                    CommonHelper:RaceTrackTestRun(temptrack,PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
                end
            else
                CommonHelper:OnTrackEditError(temptrack:GetErrorType())
            end
        end,index)

    else
        local isAdd=index==1 or (index>1 and RaceTrackDataManager:Get():GetRaceDataByIndex(_Data[index-1]):GetIsEdit())
        CommonHelper:SetGameObjectActive("add",itemObj,isAdd)
        CommonHelper:SetGameObjectActive("edit",itemObj,false)
        CommonHelper:SetGameObjectActive("lock",itemObj,not  isAdd)

        CommonHelper:HButtonSetCallback("createBtn",itemObj,function (data)
                trackData:SetRaceTrackNumber(_SelectType)
                trackData:SetName(CommonHelper:GetTempStr_Default(TemplateStringID.CustomTrackMy,index))
                trackData:SetId(_Data[data.intData])
                CommonHelper:LoadCustomTrack(trackData,MiniTrackSystem.Self)
        end,index)

    end
end
function CustomTrackListView:SetStar(curstar,maxstar,item)
    print(curstar)
    curstar= curstar==nil and 0 or curstar
    curstar=math.floor(curstar/50)>=5 and 5 or math.floor(curstar/50)
    curstar=curstar<1 and 1 or curstar
    for i = 1, 6 do
        local star= CommonHelper:SetGameObjectActive("star"..i,item,i<=maxstar)
        CommonHelper:SetGameObjectActive("star",star,i<=curstar)
    end
end
function CustomTrackListView:OnOpen()
    self:TogClick(TrackSegmentNumbers.Three)
end
function CustomTrackListView:ReOpen()
   self:TogClick(_SelectType,true)
end

function CustomTrackListView:OnClose()
    _SelectType=nil
    TrackBuilder:Get():RestoreCamera()
    CommonHelper:ReleasePool(UIModuleID.CustomTrackList)
end
function CustomTrackListView:OnAutoClose()
    TrackBuilder:Get():RestoreCamera()
end
function CustomTrackListView:ParseTime(milliSecond)
    local time=CommonHelper:GetSelfTransferTimeStr(milliSecond)
    local second=string.format("%s'%s'%s",time.minute,time.second,time.milliSecond)
    return second
end