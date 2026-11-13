-----------解析字符串串成reward  type,id,num[分隔符]type,id,num[分隔符]type,id,num
---@return table<number,RewardData>
function CommonHelper:ParseToReward3(rewardStr,splitStr)
    if rewardStr == "-1" or rewardStr == nil then
        return nil
    end
    splitStr = splitStr or ';'
    local result = stringSplit(rewardStr, splitStr)
    local rewards = RewardGroup()
    for i = 1, #result do
        rewards:AddRewardString3(result[i])
    end
    return rewards.group
end

---@return RewardData[]
function CommonHelper:SetDataByStrIdAndNum(ids,nums)
    if ids == "-1" or ids == nil or nums == "-1" or nums == nil or ids == "0"then
        return { }
    end
    local rewards = RewardGroup()
        rewards:SetDataByStrIdAndNum(ids,nums)
    return rewards.group
end
---@param consumelist SC_Consume[]
function CommonHelper:SetDataByConsumeList(consumelist)
    if consumelist== nil then
        return nil
    end
    local rewards = RewardGroup()
        rewards:SetDataByConsumeList(consumelist)
    return rewards.group
end

-----------解析字符串串成reward  id,num[分隔符]id,num[分隔符]id,num
---@return table<number,RewardData>
function CommonHelper:ParseToReward2(rewardStr,splitStr)
    if rewardStr == "-1" or rewardStr == nil then
        return nil
    end
    splitStr = splitStr or ':'
    local result = stringSplit(rewardStr, splitStr)
    local rewards = RewardGroup()
    for i = 1, #result do
        rewards:AddRewardString2(result[i])
    end
    return rewards.group
end
---@return table<number,RewardData>
function CommonHelper:GetRewardByDictDownId(id)
    ---@type dictdown_config
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictdown_config)
    local rewards= cfg.GetRewardsGroupByDropId(tonumber(id))
    return rewards
end
---@return table<number,dictgiftpart_config_cell>
function CommonHelper:GetSuperPartsByItemId(id)
    ---@type dictgiftpart_config
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictgiftpart_config)
    local rewards= cfg.GetPartsDataByGiftId(tonumber(id))
    return rewards
end

-----------解析字符串串成reward  id,num[分隔符]id,num[分隔符]id,num
---@return table<number,Param_Reward2>
--{{num1=1,num2=num}}
function CommonHelper:ParseToRewardIdNum(param)
    local rewards = RewardGroup()
    for i = 1, #param do
        rewards:AddRewardData(param[i].num1,param[i].num2)
    end
    return rewards.group
end
-----------根据dropid 获取奖励
---@return table<number,RewardData>
function CommonHelper:GetRewardByDropId(dropId)
    ---@type dropgroup_config
    local dropgroup_config= ClientDataManager:Get():GetDataTable(ConfigNames.dropgroup_config)
    ---@type table<number,RewardGroup>
    local rewardData= dropgroup_config.GetReward()
    local rewards=rewardData[dropId]
    if rewards~=nil then
        return rewards.group
    end
    return nil
end

-----------解析单个奖励 id,num
---@return RewardData
function CommonHelper:Parse2StringToReward(str)
    if str == "-1" or str == nil then return nil end

    local reward=RewardData()
    reward:SetString2Data(str)

    return reward
end
-----------解析单个奖励 id,num
---@return RewardData[]
function CommonHelper:ParseToRewardBy2Code(str,split1,split2)
    if str == "-1" or str == nil then return nil end
    split1 = split1 or ';'
    split2 = split2 or ':'
    local rewards= stringSplit(str,split1)
    local result={}
    for i = 1, #rewards do
        local temp= stringSplitToNumber(rewards[i],split2)
        local reward=RewardData()
        reward:SetDataIdNum(temp[1],temp[2])
        table.insert(result,reward)
    end
    return result
end

-----------解析单个奖励 type,id,num
---@return RewardData
function CommonHelper:Parse3StringToReward(str)
    if str == "-1" or str == nil then return nil end

    local reward=RewardData()
    reward:SetString3Data(str)

    return reward
end

---@param data RewardData
function CommonHelper:SetPropGroupByRewardData(gameObject,data,moduleId)
    local param=Param_PropParam()
    param.moduleId=moduleId
    param.id=data.id
    param.count=data.num
    param.IsGray=false
    param.showname=false
    CommonHelper:SetPropGroup(gameObject,param,moduleId)
end

---@param data RewardData
function CommonHelper:SetItemComGroupByRewardData(gameObject,data,moduleId,func,clickparam)
    local param = Param_ItemArticleParam()
    param.count = data.num
    CommonHelper:SetItemComGroup(gameObject,moduleId,data.id,param,func,clickparam)
end
