---@class RedPointDataFirstActivity : RedPointDataBase
RedPointDataFirstActivity = class("RedPointDataFirstActivity", RedPointDataBase)

function RedPointDataFirstActivity:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataFirstActivity:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false

    value = UserFirstGiftManager:Get():GetRedPointValue()

    --}}}
    RedPointDataBase.UpdateValue(self, value)
end

---@class RedPointDataPlayerReward : RedPointDataBase
RedPointDataPlayerReward = class("RedPointDataPlayerReward", RedPointDataBase)

function RedPointDataPlayerReward:initialize(id)
    RedPointDataBase.initialize(self, id)
end

function RedPointDataPlayerReward:UpdateValue(param)
    --{{{功能模块自定义代码
    local value = false
    local levelAward=PlayerDataManager:Get():GetLevelAward()
    for i = 1,PlayerDataManager:Get():GetPlayerLV()  do
        local flag=true
        for k, v in pairs(levelAward) do
            if v==i then
                flag=false
                break
            end
        end
        if flag then
            value=flag
            break
        end
    end
    --}}}
    RedPointDataBase.UpdateValue(self, value)
end

