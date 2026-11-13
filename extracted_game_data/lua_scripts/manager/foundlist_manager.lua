---@class FoundData
FoundData = class("FoundData")

function FoundData:initialize(msg)
    self:Update(msg)
end
function FoundData:Update(msg)
    self. Id = msg.foundId--通行证ID
    self. Type = msg.foundType--通行证类型 601=大赛之路 602=车神传说 603=玩家等级
    self. SubId = msg.subId--通行证子类ID
    self. Lv = msg.curLv--当前通行证等级
    self. Exp = msg.curExp--当前通行证经验
    self. AddNum = msg.addNum--暂时无用
    self. IsBuy = msg.ifBuy==1--购买状态 0没买 1已买
    self. IsGift = {}
    local temp=stringSplitToNumber(msg.ifGift,':')--领取奖励串 0=可领 1=已领免费 2=已领高级 -1没有
    for k, v in pairs(temp) do
        if v>-1 then
            table.insert(self.IsGift,v)
        end
    end
    self. BuyProp = msg.buyProp--暂时无用
    self. BuyNum = msg.buyNum--暂时无用
    self. ExpTime = msg.expTime--暂时无用
    ---@type dictpassfound_config_cell
    self.Cfg=CommonHelper:GetTableDataByID(ConfigNames.dictpassfound_config,self.Id)
    self.ChargeCfg=CommonHelper:GetChargeCfgByAreaAndItemId(self.Cfg.C_ID)
    ---@type   dictpassaward_config
    local awardCfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictpassaward_config)
    ---@type dictpassaward_config_cell[]
    self.Awards=awardCfg.GetAwardListByFoundId(self.Id,self.SubId)
    self.LevelMax = self.Awards[#self.Awards].level
end



---@class FoundListManager
FoundListManager = class("FoundListManager")
function FoundListManager:Get()
    if self._instance == nil then
        self._instance = FoundListManager()
    end
    return self._instance
end
---@param msg SC_UserPassFoundInfo
function FoundListManager:Init(msg)
    ---@type FoundData[]
    self.FoundDic={}
    for k, v in pairs(msg.myPassFound) do
        self.FoundDic[v.foundType]=FoundData(v)
    end
end
---@return FoundData
function FoundListManager:GetFoundData(type)
    for k, v in pairs(self.FoundDic) do
        if type==k then
            return v
        end
    end
end
function FoundListManager:GetFoundInfo(type)
    if type==UserFoundType.SeasonOrder then
        FunctionSkipManager:Get():SkipToFunction(GameFunction.SeasonOrder)
    else
        FoundSubsystem:Get():SendMsg_GetFoundInfo(type)
    end
end
---@param myPassFound SC_MyPassFound
function FoundListManager:UpdateBuyFinish(myPassFound)
    self.FoundDic[myPassFound.foundType].IsBuy=true
    if myPassFound.foundType==UserFoundType.Story then
        UINotify:Get():SendNotification(UINotifyEvent.FoundPassStory_Refresh)
    elseif myPassFound.foundType==UserFoundType.Level then
        UINotify:Get():SendNotification(UINotifyEvent.FoundPassLevel_Refresh)
    elseif myPassFound.foundType==UserFoundType.CarGad then
        UINotify:Get():SendNotification(UINotifyEvent.FoundPassCarGod_Refresh)
    end
end
---@param myPassFound SC_MyPassFound[]
function FoundListManager:RefreshReward(myPassFound)
    for k, v in pairs(myPassFound) do
        self.FoundDic[v.foundType]:Update(v)
        if v.foundType==UserFoundType.Story then
            UINotify:Get():SendNotification(UINotifyEvent.FoundPassStory_Refresh)
        elseif v.foundType==UserFoundType.Level then
            UINotify:Get():SendNotification(UINotifyEvent.FoundPassLevel_Refresh)
        elseif v.foundType==UserFoundType.CarGad then
            UINotify:Get():SendNotification(UINotifyEvent.FoundPassCarGod_Refresh)
        end
    end

end
