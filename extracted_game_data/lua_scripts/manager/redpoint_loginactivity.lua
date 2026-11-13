---@class RedPointDataLoginActivity : RedPointDataBase
RedPointDataLoginActivity = class("RedPointDataLoginActivity", RedPointDataBase)

function RedPointDataLoginActivity:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataLoginActivity:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false

    value = PlayerDataManager:Get():GetSevenSignRedPint() or LoginTaskDataManager:Get():IsHaveRedPoint_NoviceTask()

    --}}}
    RedPointDataBase.UpdateValue(self, value)
end

---@class RedPointDataSign : RedPointDataBase
RedPointDataSign = class("RedPointDataSign", RedPointDataBase)

function RedPointDataSign:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataSign:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = PlayerDataManager:Get():GetSevenSignRedPint()

    --}}}
    RedPointDataBase.UpdateValue(self, value)
end

---@class RedPointDataNoviceTask : RedPointDataBase
RedPointDataNoviceTask = class("RedPointDataNoviceTask", RedPointDataBase)

function RedPointDataNoviceTask:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataNoviceTask:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false

    value = LoginTaskDataManager:Get():IsHaveRedPoint_NoviceTask()

    --}}}
    RedPointDataBase.UpdateValue(self, value)
end