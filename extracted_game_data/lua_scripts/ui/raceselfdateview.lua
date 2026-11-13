
local __State = RaceSelfState.None
local __DateIdx = 0
local __TimeIdx = 0


---@class RaceSelfDateView : ViewBase
RaceSelfDateView = class("RaceSelfDateView", ViewBase)

function RaceSelfDateView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfDateViewAction")
end

function RaceSelfDateView:Awake()

    CommonHelper:HButtonSetCallback("BtnCancel",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnSure",self.gameObject,function (hbtn)
        if __TimeIdx <= 0 then
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.RaceSelfSelectDateError))
        else
            RaceSelfCacheManager:Get():ChangeDate(__State, __DateIdx, __TimeIdx + 1)
            UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_Step3_UpdateDate)
            UIManager:Get():ClosePopup()
        end
    end)



    self.TogDate = {}
    for i = 1, 7 do
        local temp = CommonHelper:HButtonSetCallback("dategroup/Date"..i,self.gameObject,function (hbtn)
            UINotify:Get():SendNotification(UINotifyEvent.SelfRaceDateView_ClickTogDate, hbtn.intData)
        end, i)
        table.insert(self.TogDate, temp)
    end

    self.ScrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RaceSelfDateView:OnOpen()

end

function RaceSelfDateView:OnClose()

end


function RaceSelfDateView:SetData(state)
    __State = state
    self:SetTitle(state)
    self:SetDate()
    self:AutoSelectDate()
end

function RaceSelfDateView:SetTitle(state)
    local statename = CommonHelper:GetTempStr_RaceSelfState(state)

    local str = string.format("设置<color=#F6D046ff>%s</color>时间", statename)
    CommonHelper:SetText("TitleCompoentRed_3/title1", self.gameObject, str)
end

function RaceSelfDateView:SetDate()
    local temp = RaceSelfCacheManager:Get():GetCache_Date()
    for i = 1, #temp.DateList do
        local obj = self.TogDate[i].gameObject
        local data = temp.DateList[i]
        CommonHelper:SetText("date", obj, tostring(data.Day))
        CommonHelper:SetText("week", obj, CommonHelper:GetWeekString(data.Week))

        local flags = {}
        for i = 1, #data.Times do
            if data.Times[i].State ~= RaceSelfState.None then
                table.insert(flags, data.Times[i].State)
            end
        end

        for i = 1, 5 do
            local image = CommonHelper:GetComponentSetImage("flag"..i, obj, CommonHelper:GetRaceSelfStateIcon(flags[i]))
            image.gameObject:SetActive(flags[i] ~= nil)
        end
    end
end

function RaceSelfDateView:SetScrollView(dateidx)
    self.TimeList = {}
    local temp = RaceSelfCacheManager:Get():GetCache_Date()
    self.TimeList = temp.DateList[dateidx].Times


    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.TimeList, 6,function(dataIndex, itemObj, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.SelfRaceDateView_UpdateScrollView, {dataIndex, itemObj})
    end)

end

function RaceSelfDateView:UpdateScrollView(dataIndex, itemObj)
    local data = self.TimeList[dataIndex + 1]

    local str = string.format("%02d:%02d", data.Hour, data.Minute)
    CommonHelper:SetText("time", itemObj, str)

    local statename = ""
    if data.State == RaceSelfState.Join then statename = "报名" end
    if data.State == RaceSelfState.Select then statename = "海选" end
    if data.State == RaceSelfState.Knockout then statename = "淘汰赛" end
    if data.State == RaceSelfState.SemiFinal then statename = "半决赛" end
    if data.State == RaceSelfState.Finals then statename = "决赛" end
    CommonHelper:SetText("titlename", itemObj, statename)

    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.SelfRaceDateView_ClickScrollItem, hbtn.intData)
    end, dataIndex)

    local disable = UIUtil.GetChild("disable", itemObj)
    if disable then disable:SetActive(not data.Enable) end

    local select = UIUtil.GetChild("select", itemObj)
    if select then select:SetActive(__TimeIdx == dataIndex) end
end

function RaceSelfDateView:AutoSelectDate()
    self:OnClickTogDate(1)
end

function RaceSelfDateView:OnClickTogDate(idx)
    for i = 1, #self.TogDate do
        CommonHelper:SetToggleState(self.TogDate[i], idx == i, true)
    end

    __DateIdx = idx
    __TimeIdx = -1
    self:SetScrollView(idx)
end

function RaceSelfDateView:OnClickBtnScrollItem(idx)
    if RaceSelfCacheManager:Get():CheckDateError() then
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_Step3_UpdateDate)
        UIManager:Get():ClosePopup()
        return
    end

    __TimeIdx = idx
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
end







