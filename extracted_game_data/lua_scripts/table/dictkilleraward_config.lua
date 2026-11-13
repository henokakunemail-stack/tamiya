



---@class dictkilleraward_config




dictkilleraward_config = {}
---@type table<number,dictkilleraward_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictkilleraward')), '')
local bytes = mono.LoadBytes('dictkilleraward')
local cfg = assert(Dll_PB.decode('dictkilleraward_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictkilleraward.txt'
function dictkilleraward_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 seasonid = ConvertToNumber(configName, 'seasonid', columns[2]),
		 rankloc = ConvertToNumber(configName, 'rankloc', columns[3]),
		 awardids = columns[4],
		 awardnums = columns[5],
		 mailid = ConvertToNumber(configName, 'mailid', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictkilleraward_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictkilleraward_config_cell>
function dictkilleraward_config.GetConfigData() return configData end
---@return dictkilleraward_config_cell
function dictkilleraward_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,table<number,dictseasonspeedaward_config_cell>>
local __NewReward = {}
function dictkilleraward_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if __NewReward[v.seasonid]==nil then
			__NewReward[v.seasonid]={}
		end
		table.insert(__NewReward[v.seasonid],v)
	end
end
function dictkilleraward_config.GetDataByRank(rank,seasonid)
	for k, v in pairs(__NewReward[seasonid]) do
		if rank ==RaceSuperBattleRewardState.Join  and rank==v.rankloc then
			return v
		end
        if rank ==RaceSuperBattleRewardState.Playoff  and rank==v.rankloc then
			return v
		end
        if rank ==v.rankloc then
			return v
		end
	end
	return nil
end
function dictkilleraward_config.GetDataBySeasonid(seasonid)
	return __NewReward[seasonid]
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictkilleraward_config.AnalyseConfig()
----%%%-------------%%%----








return dictkilleraward_config
