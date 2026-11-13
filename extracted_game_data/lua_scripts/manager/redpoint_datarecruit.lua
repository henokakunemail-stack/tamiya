---@class RedPointDataRecruit : RedPointDataBase
RedPointDataRecruit = class("RedPointDataRecruit", RedPointDataBase)

function RedPointDataRecruit:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataRecruit:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false

    value = RecruitDataManager:Get():IsHaveRedPoint()

    --}}}
    RedPointDataBase.UpdateValue(self, false)
end

---@class RedPointDataRecruitDiamond : RedPointDataBase
RedPointDataRecruitDiamond = class("RedPointDataRecruitDiamond", RedPointDataBase)

function RedPointDataRecruitDiamond:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataRecruitDiamond:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end

---@class RedPointDataRecruitGold : RedPointDataBase
RedPointDataRecruitGold = class("RedPointDataRecruitGold", RedPointDataBase)

function RedPointDataRecruitGold:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataRecruitGold:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end

---@class RedPointDataRecruitFriend : RedPointDataBase
RedPointDataRecruitFriend = class("RedPointDataRecruitFriend", RedPointDataBase)

function RedPointDataRecruitFriend:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataRecruitFriend:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end