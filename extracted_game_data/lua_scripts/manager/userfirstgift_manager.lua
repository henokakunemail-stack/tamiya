---@class UserFirstGiftManager
UserFirstGiftManager = class("UserFirstGiftManager")

function UserFirstGiftManager:initialize()
    ---@type table<number , FirstBuyData>
    self.DataDict = nil

end

function UserFirstGiftManager:Get()
    if self._instance == nil then
        self._instance = UserFirstGiftManager()
    end
    return self._instance

end

---@return FirstBuyData
function UserFirstGiftManager:SetUserFirstGiftData(msg)

    self.DataDict = {}

    self.IsShowMainButton = false
    if #msg == 0 then
        self.IsShowMainButton = true
    else
        for i, v in ipairs(msg) do
            local data = FirstBuyData()
            data:SetData(v)
            if not self.IsShowMainButton and data.Actfirstcharge < 111 then
                self.IsShowMainButton = true
            end
            table.insert(self.DataDict, data)
        end
    end

    self:SetRedPointValue()
end

function UserFirstGiftManager:SetUserFirstGiftDataByType(msg)
    ---@type SC_UserFirstGift
    for i, v in pairs(self.DataDict) do
        if v.actType == msg.actType then
            local data = FirstBuyData()
            data:SetData(msg)
            self.DataDict[i] = data
        end
    end
    self:SetRedPointValue()
end

---@type table<number , FirstBuyData>
function UserFirstGiftManager:GetAllData()
    return self.DataDict
end

function UserFirstGiftManager:GetIsFirstShow()
    return self.IsShowMainButton
end

function UserFirstGiftManager:SetRedPointValue()

    local userGiftData = UserFirstGiftManager:Get():GetDataByID(1)
    if userGiftData == nil then
        self.RedPointValue = false
    else
        if math.floor((userGiftData.Actfirstcharge % 10)) == 0 then
            self.RedPointValue = true
        elseif userGiftData.Actfirstcharge>=10 and  math.floor(((userGiftData.Actfirstcharge % 100) / 10)) == 0 then
            self.RedPointValue = true
        elseif userGiftData.Actfirstcharge>=100 and math.floor((userGiftData.Actfirstcharge / 100)) == 0 then
            self.RedPointValue = true
        else
            self.RedPointValue = false
        end
    end
    RedPointManager:Get():UpdateValue(RedPointID.Activity_FirstBuy)
end

function UserFirstGiftManager:GetRedPointValue()
    return self.RedPointValue
end

---@return FirstBuyData
function UserFirstGiftManager:GetDataByID(id)
    for i, v in ipairs(self.DataDict) do
        if v.actType == id then
            return v
        end
    end

    return nil
end
