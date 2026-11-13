---@class UserDirectManager
UserDirectManager = class("UserDirectManager")

function UserDirectManager:initialize()
    ---@type table<number , DirectData>
    self.DataDict = nil
    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end

function UserDirectManager:Get()
    if self._instance == nil then
        self._instance = UserDirectManager()
    end
    return self._instance
end

---@return DirectData
function UserDirectManager:SetUserDirectData(msg)
    self.DataDict = {}

    for i, v in ipairs(msg) do
        local data = DirectData()
        data:SetData(v)
        table.insert(self.DataDict, data)
    end

end


function UserDirectManager:SetUserDirectDataByID(msg)
    for i, v in ipairs(self.DataDict) do
        if v.propid == msg.propid and v.coinid == msg.coinid then
            self.DataDict[i].ifalert = msg.ifalert
        end
    end
end

---@return DirectData
function UserDirectManager:GetDataByID(id, coinid)
    if self.DataDict then
        for i, v in ipairs(self.DataDict) do
            if v.propid == id and v.coinid == coinid then
                return v
            end
        end
    end
    return nil
end


function UserDirectManager:ClearData()
    self.DataDict =nil
end
