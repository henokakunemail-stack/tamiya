



---@class RedPointDataTask : RedPointDataBase
RedPointDataTask = class("RedPointDataTask", RedPointDataBase)

function RedPointDataTask:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataTask:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    value=TaskDataManager:Get():GetTaskIsDoneByType(TaskType.Daily)
    if not value then
        --value=TaskDataManager:Get():GetTaskIsDoneByType(TaskType.Week)
    end
    if not value then
        value=TaskDataManager:Get():GetTaskIsDoneByType(TaskType.GrowUp)
    end
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end




---@class RedPointDataTaskDaily : RedPointDataBase
RedPointDataTaskDaily = class("RedPointDataTaskDaily", RedPointDataBase)

function RedPointDataTaskDaily:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataTaskDaily:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    value=TaskDataManager:Get():GetTaskIsDoneByType(TaskType.Daily)
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end







---@class RedPointDataTaskWeek : RedPointDataBase
RedPointDataTaskWeek = class("RedPointDataTaskWeek", RedPointDataBase)

function RedPointDataTaskWeek:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataTaskWeek:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    value=TaskDataManager:Get():GetTaskIsDoneByType(TaskType.Week)
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end





---@class RedPointDataTaskAchievement : RedPointDataBase
RedPointDataTaskAchievement = class("RedPointDataTaskAchievement", RedPointDataBase)

function RedPointDataTaskAchievement:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataTaskAchievement:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    value=TaskDataManager:Get():GetTaskIsDoneByType(TaskType.GrowUp)
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end