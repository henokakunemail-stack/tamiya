---@class Param_Reward2
Param_Reward2=class("Param_Reward2")
function Param_Reward2:initialize()
    self.num1=-1
    self.num2=-1
end
function Param_Reward2:SetData(num1,num2)
    self.num1=num1
    self.num2=num2
end
---@class RewardData
RewardData = class("RewardData")
function RewardData:initialize()
    self.type=-1
    self.id=-1
    self.num=-1
    self.quality=-1
    self.probability=-1
end
---@param dropData dropgroup_config_cell
function RewardData:SetDropData(dropData)
    self.type=dropData.dropType
    self.id=dropData.itemId
    self.num=dropData.num
end

function RewardData:SetString2Data(str1)
    local str2 = stringSplitToNumber(str1,",")
    self.id = str2[1]
    self.num = str2[2]
end

function RewardData:SetString3Data(str)
    local num = stringSplitToNumber(str, ",")
    self.type = tonumber(num[1])
    self.id = tonumber(num[2])
    self.num = tonumber(num[3])
end

function RewardData:SetDataIdNum(id,num,partIdx)
    self.id = id
    self.num = num
    self.partIdx = partIdx
end
function RewardData:SetDataIdProbability(id,num)
    self.id = id
    self.probability = num
end

function RewardData:SetTypeAndQuality()
    local type,cfg=CommonHelper:GetPropTypeById(self.id)
    self.type=type
    if self.type==PropType.Part then
        local cfg=CommonHelper:GetPartBaseCfg(self.id)
        if cfg then
            self.quality=cfg.fabric
        end
    elseif self.type==PropType.Article then
        self.quality=cfg.propsgrade
    end
end

---@class RewardGroup
RewardGroup = class("RewardGroup")

function RewardGroup:initialize()
    ---@type RewardData[]
    self.group={}
end

---@param param dropgroup_config_cell
function RewardGroup:AddRewardDrop(param)
    local temp= RewardData()
    temp:SetDropData(param)
    table.insert(self.group,temp)
end

function RewardGroup:AddRewardString2(string)
    local temp= RewardData()
    temp:SetString2Data(string)
    table.insert(self.group,temp)
end


function RewardGroup:AddRewardString3(string)
    local temp= RewardData()
    temp:SetString3Data(string)
    table.insert(self.group,temp)
end

function RewardGroup:AddRewardData(id,num)
    local temp= RewardData()
    temp:SetDataIdNum(id,num)
    table.insert(self.group,temp)
end

function RewardGroup:SetDataByStrIdAndNum(ids,nums)
    local ids=stringSplitToNumber(ids,':')
    local nums=stringSplitToNumber(nums,':')
    for i = 1, #ids do
        local temp=RewardData()
        temp:SetDataIdNum(ids[i],nums[i])
        table.insert(self.group,temp)
    end
    return self.group
end
---@param consumelist SC_Consume[]
function RewardGroup:SetDataByConsumeList(consumelist)
    for i = 1, #consumelist do
        local temp=RewardData()
        temp:SetDataIdNum(consumelist[i].propsid,consumelist[i].propsnum)
        table.insert(self.group,temp)
    end
    return self.group
end
