


---@class Pre_RaceRuleSift
Pre_RaceRuleSift = class("Pre_RaceRuleSift")

function Pre_RaceRuleSift:initialize()
    self.Root = nil
    self.ModuleId = -1

    self.SiftLimit = -1

    ---@type RaceDataPlayer
    self.MyData = nil
    ---@type table<number, RaceDataPlayer>
    self.PlayerList = {}
end


function Pre_RaceRuleSift:SetData(root, mydata, data, limit, moduleid)
    self.Root = root
    self.ModuleId = moduleid
    self.SiftLimit = limit
    self.MyData = mydata
    self.PlayerList = data



    self:SetSelfRank()

    self:SetRankList()
end

function Pre_RaceRuleSift:SetSelfRank()
    local obj = UIUtil.GetChild("selfgroup", self.Root)
    local str = "晋级条件:进入前"..self.SiftLimit.."名"
    if self.MyData == nil then
        CommonHelper:SetText("selfrank", obj, "无")
        CommonHelper:SetText("time", obj, "无")
        CommonHelper:SetText("tipssucceed", obj, str)
    else
        CommonHelper:SetText("selfrank", obj, self.MyData:GetRank())
        CommonHelper:SetText("time", obj, self.MyData:GetTimeValue())
        if self.MyData:GetRank() >= self.SiftLimit then
            str = "保持住现在的排名，您可以进入下一轮"
        end
        CommonHelper:SetText("tipssucceed", obj, str)
    end
end

function Pre_RaceRuleSift:SetRankList()
    if self.PlayerList == nil then return end

    table.sort(self.PlayerList,function (a,b)
        return a:GetRank() < b:GetRank()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.Root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.PlayerList, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)
end

function Pre_RaceRuleSift:UpdateScrollView(dataIndex, itemObj)
    local data = self.PlayerList[dataIndex + 1]

    CommonHelper:SetText("rankname", itemObj, string.format("第%d名",data:GetRank()))
    CommonHelper:SetText("playername", itemObj, data:GetName())
    CommonHelper:SetText("clubname", itemObj, data:GetClubName())
    CommonHelper:SetText("time", itemObj, data:GetTimeValue())
    CommonHelper:GetComponentSetUITexture("RawIcon",itemObj,CommonHelper:GetPlayerIconById(data:GetIcon()), self.ModuleId)

end



