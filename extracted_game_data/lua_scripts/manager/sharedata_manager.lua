---@class ShareDataManager
ShareDataManager = class("ShareDataManager")

function ShareDataManager:Get()
    if self._instance == nil then
        self._instance = ShareDataManager()
    end
    return self._instance
end


function ShareDataManager:initialize()
    ---@type table<number,ChatShareParam>
    self.ShareData={}
end

---@param ChatShareParam ChatShareParam
function ShareDataManager:AddShareData(ChatShareParam)
    table.insert(self.ShareData,ChatShareParam)
end

---@return  ChatShareParam
function ShareDataManager:GetShareDataByIndex(dataIndex)
    if self.ShareData[dataIndex] then
        return self.ShareData[dataIndex]
    else
        return -1
    end
end
function ShareDataManager:GetShareData()
    return self.ShareData
end

function ShareDataManager:Clear()
    self.ShareData={}
end