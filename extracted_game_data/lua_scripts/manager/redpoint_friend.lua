---@class RedPointDataFriend : RedPointDataBase
RedPointDataFriend = class("RedPointDataFriend", RedPointDataBase)

function RedPointDataFriend:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataFriend:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false

    value = FriendDataManager:Get():IsHaveRedPoint_List() or FriendDataManager:Get():IsHaveRedPoint_Apply()

    --}}}
    RedPointDataBase.UpdateValue(self, value)
end

---@class RedPointDataFriendList : RedPointDataBase
RedPointDataFriendList = class("RedPointDataFriendList", RedPointDataBase)

function RedPointDataFriendList:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataFriendList:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    value = FriendDataManager:Get():IsHaveRedPoint_List()
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end

---@class RedPointDataFriendApply : RedPointDataBase
RedPointDataFriendApply = class("RedPointDataFriendApply", RedPointDataBase)

function RedPointDataFriendApply:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataFriendApply:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false

    value = FriendDataManager:Get():IsHaveRedPoint_Apply()
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end