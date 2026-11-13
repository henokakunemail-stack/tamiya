---@class Page_LoginTaskSignView
Page_LoginTaskSignView = class("Page_LoginTaskSignView")

function Page_LoginTaskSignView:initialize(parentPref)
    self.parentPref = parentPref
    self:InitBaseData()
end



function Page_LoginTaskSignView:InitBaseData()

    self.togDayItem = {}

    for i = 1, 7 do
        local togDay = UIUtil.GetChild("TogDay_" .. i, self.parentPref)

        CommonHelper:HButtonSetCallback("SignBtn", togDay.gameObject, function(data)
            LoginTaskSubSystem:Get():SendMsg_GetSignInfoReward(data.intData)
        end,i)
        table.insert(self.togDayItem, togDay)
    end
end
function Page_LoginTaskSignView:RefreshTaskLoginInfo(sign)
    local SignState=sign==0
    for i = 1, #self.togDayItem do
        CommonHelper:SetTextColorByName("DayText", self.togDayItem[i].gameObject, self. SignInfo[i].curStatus==1 and "636363" or "ffffff")
        CommonHelper:SetGameObjectActive("HaveSign", self.togDayItem[i].gameObject, self. SignInfo[i].curStatus>=1 or sign==i)
        CommonHelper:SetGameObjectActive("SignBtn", self.togDayItem[i].gameObject, (SignState and self. CurDay==i and self. SignInfo[i].curStatus==0))
        CommonHelper:SetGameObjectActive("RedPoint1", self.togDayItem[i].gameObject, (SignState and self. CurDay==i and self. SignInfo[i].curStatus==0))
        if i ~= 7 then
            CommonHelper:SetGameObjectActive("CanSignImg", self.togDayItem[i].gameObject, (SignState and self. CurDay==i and self. SignInfo[i].curStatus==0))

            ---@param novicedailyreward_config_cell
            local cell = CommonHelper:GetTableDataByID(ConfigNames.novicedailyreward_config, i)
            CommonHelper:GetComponentSetImage("rewardImg", self.togDayItem[i].gameObject, cell.icon, UIModuleID.TaskLogin)
            CommonHelper:SetText("###Dec", self.togDayItem[i].gameObject, CommonHelper:GetTempStr_Default(cell.desc))
        end
    end
    PlayerDataManager:Get():SetPlayerDataDaySign(sign)
    RedPointManager:Get():UpdateValue(RedPointID.LoginActivity_Sign)
    RedPointManager:Get():UpdateValue(RedPointID.LoginActivity_Login)
    RedPointManager:Get():UpdateValue(RedPointID.LoginActivity_NoviceTask)
end
---@param msg SC_UserSign
function Page_LoginTaskSignView:InitTaskLoginInfo(msg)
    local SignState=msg.daySign==0
    self. SignInfo=msg.mySignInfo
    table.sort(self.SignInfo,function(a, b)
        return a.dayNum<b.dayNum
    end)
    self. CurDay=8
    for i = 1, #self. SignInfo do
        if self. SignInfo[i].curStatus==0 and self. SignInfo[i].ifGet==0 then
            self. CurDay=i
            break
        end
    end
    for i = 1, #self.togDayItem do
        CommonHelper:SetTextColorByName("DayText", self.togDayItem[i].gameObject, self. SignInfo[i].curStatus==1 and "636363" or "ffffff")
        CommonHelper:SetGameObjectActive("HaveSign", self.togDayItem[i].gameObject, self. SignInfo[i].curStatus>=1)
        CommonHelper:SetGameObjectActive("SignBtn", self.togDayItem[i].gameObject, (SignState and self. CurDay==i and self. SignInfo[i].curStatus==0))
        CommonHelper:SetGameObjectActive("RedPoint1", self.togDayItem[i].gameObject, (SignState and self. CurDay==i and self. SignInfo[i].curStatus==0))
        if i ~= 7 then
            CommonHelper:SetGameObjectActive("CanSignImg", self.togDayItem[i].gameObject, (SignState and self. CurDay==i and self. SignInfo[i].curStatus==0))

            ---@param novicedailyreward_config_cell
            local cell = CommonHelper:GetTableDataByID(ConfigNames.novicedailyreward_config, i)
            CommonHelper:GetComponentSetImage("rewardImg", self.togDayItem[i].gameObject, cell.icon, UIModuleID.TaskLogin)
            CommonHelper:SetText("###Dec", self.togDayItem[i].gameObject, CommonHelper:GetTempStr_Default(cell.desc))
        end
    end
end




