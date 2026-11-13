


---@class BatchLoadManager @把要加载的东西放到一起，批量加载
BatchLoadManager = class("BatchLoadManager")

--- 批量加载，便于在Loading的时候集中管理进度
function BatchLoadManager:initialize()
    self.loadingAssets = {}
    self.length = 0
end


function BatchLoadManager:AddAssets( asset )
    table.insert(self.loadingAssets, asset)
    self.length = self.length + 1
end

function BatchLoadManager:IsDone()
    for i, v in ipairs(self.loadingAssets) do
        if not v.isDone then
            return false
        end
    end

    return true
end

function BatchLoadManager:GetProgress()
    local progress = 0
    for i, v in ipairs(self.loadingAssets) do
        progress = progress + v.progress
    end

    return progress / self.length
end



