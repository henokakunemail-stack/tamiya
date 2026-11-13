



---@class dictseasonspeedaward_config




dictseasonspeedaward_config = {}
---@type table<number,dictseasonspeedaward_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictseasonspeedaward')), '')
local bytes = mono.LoadBytes('dictseasonspeedaward')
local cfg = assert(Dll_PB.decode('dictseasonspeedaward_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictseasonspeedaward.txt'
function dictseasonspeedaward_config.Load()
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
		 speedfrom = ConvertToNumber(configName, 'speedfrom', columns[3]),
		 speedto = ConvertToNumber(configName, 'speedto', columns[4]),
		 rlawardids = columns[5],
		 rlawardnums = columns[6],
		 awardids = columns[7],
		 awardnums = columns[8],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictseasonspeedaward_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictseasonspeedaward_config_cell>
function dictseasonspeedaward_config.GetConfigData() return configData end
---@return dictseasonspeedaward_config_cell
function dictseasonspeedaward_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,table<number,dictseasonspeedaward_config_cell>>
local __NewReward = {}
function dictseasonspeedaward_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if __NewReward[v.seasonid]==nil then
			__NewReward[v.seasonid]={}
		end
        table.insert(__NewReward[v.seasonid],v)
	end
end
function dictseasonspeedaward_config.GetDataByRank(rank,seasonid)
	if __NewReward[seasonid] then
		for k, v in pairs(__NewReward[seasonid]) do
			if rank <= v.speedto and rank>=v.speedfrom then
				return v
			end
		end
	end
	return nil
end
function dictseasonspeedaward_config.GetDataBySeasonid(seasonid)
	return __NewReward[seasonid]
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictseasonspeedaward_config.AnalyseConfig()
----%%%-------------%%%----








return dictseasonspeedaward_config
