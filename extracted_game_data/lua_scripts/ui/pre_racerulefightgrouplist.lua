


local __TypeGroup = 1
local __TypePlayer = 2


---@class Pre_RaceRuleFightGroupList
Pre_RaceRuleFightGroupList = class("Pre_RaceRuleFightGroupList")

function Pre_RaceRuleFightGroupList:initialize()
    self.Root = nil
    self.ModuleId = -1
    self.GroupNum = 1
    ---@type table<number, RaceDataFightGroup>
    self.GroupList = {}

    self.ShowData = {}
end

function Pre_RaceRuleFightGroupList:Clear()

end

function Pre_RaceRuleFightGroupList:SetData(root, groupnum, grouplist, moduleid)
    self.Root = root
    self.ModuleId = moduleid
    self.GroupNum = groupnum
    self.GroupList = grouplist

    self:SetTog()
    self:AutoSelect()
end

function Pre_RaceRuleFightGroupList:AutoSelect()
    self:ClickTog(1)
end

function Pre_RaceRuleFightGroupList:SetTog()
    local count = self.GroupNum
    self.Tog = {}
    for i = 1, 6 do
        local active = (i <= count + 1)
        self.Tog[i] = CommonHelper:HButtonSetCallback("TogTeam"..i,self.Root,function (hbtn)
            self:ClickTog(hbtn.intData)
        end, i)
        CommonHelper:SetHButtonClick(self.Tog[i], active, true)
    end
end

function Pre_RaceRuleFightGroupList:ClickTog(idx)
    for i = 1, #self.Tog do
        CommonHelper:SetToggleState(self.Tog[i], i == idx, true)
    end

    self:SetScrollView(idx - 1)
end

function Pre_RaceRuleFightGroupList:SetScrollView(idx)
    ---@type table<number, RaceDataFightGroup>
    local list = {}
    for i = 1, #self.GroupList do
        local data = self.GroupList[i]
        if idx == 0 or data.GroupIdx == idx then
            table.insert(list, self.GroupList[i])
        end
    end

    table.sort(list,function (a, b)
        return a.GroupIdx < b.GroupIdx
    end)

    local tempdata = {}
    self.ShowData = {}
    for i = 1, #list do
        local group = list[i]
        table.insert(tempdata, 0)
        table.insert(self.ShowData, {__TypeGroup, group})
        for m = 1, #group.Players do
            table.insert(tempdata, 1)
            table.insert(self.ShowData, {__TypePlayer, group.Players[m]})
        end
    end

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("CustomScrollViewTtoM", self.Root, typeof(CustomScrollView))
    CommonHelper:CustomView_Init(self.ScrollView, tempdata, function(index, itemObj, scroll)
        self:UpdateScrollView(index, itemObj)
    end)

end

function Pre_RaceRuleFightGroupList:UpdateScrollView(idx, itemObj)
    local temp = self.ShowData[idx + 1]
    local type = temp[1]

    if type == __TypeGroup then
        ---@type RaceDataFightGroup
        local data = temp[2]
        CommonHelper:SetText("groupname", itemObj, CommonHelper:GetTempStr_RaceSelfFightGroupTitle(data.Idx, data.GroupIdx))
        CommonHelper:HButtonSetCallback("BtnReplay",itemObj,function (hbtn)
            log("---   回放",hbtn.longData)
            RaceSelfSubsystem:Get():SendMsg_Replay(hbtn.longData)
        end,nil,nil, data.RecordID)
    end
    if type == __TypePlayer then
        ---@type RaceDataPlayer
        local data = temp[2]
        CommonHelper:SetText("racename", itemObj, data:GetName())
        CommonHelper:SetText("clubname", itemObj, data:GetClubName())
        CommonHelper:SetText("carname", itemObj, "")
        CommonHelper:GetComponentSetImage("trackicon", itemObj, CommonHelper:GetCarTrackIdxIcon(1), self.ModuleId)
        CommonHelper:GetComponentSetUITexture("RawIcon",itemObj,CommonHelper:GetPlayerIconById(data:GetIcon()), self.ModuleId)
    end
end