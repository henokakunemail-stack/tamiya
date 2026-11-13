---@class LimitChapterDataManager
LimitChapterDataManager = class("LimitChapterDataManager")
function LimitChapterDataManager:initialize()

end
---@return LimitChapterDataManager
function LimitChapterDataManager:Get()
    if self._instance == nil then
        self._instance = LimitChapterDataManager()
    end
    return self._instance
end

function LimitChapterDataManager:SetData()

end