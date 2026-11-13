



---@class dictgvgpointgroupaward_config




dictgvgpointgroupaward_config = {}
---@type table<number,dictgvgpointgroupaward_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictgvgpointgroupaward')), '')
local bytes = mono.LoadBytes('dictgvgpointgroupaward')
local cfg = assert(Dll_PB.decode('dictgvgpointgroupaward_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictgvgpointgroupaward.txt'
function dictgvgpointgroupaward_config.Load()
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
		 winlose = ConvertToNumber(configName, 'winlose', columns[3]),
		 awardids = columns[4],
		 awardnums = columns[5],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictgvgpointgroupaward_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictgvgpointgroupaward_config_cell>
function dictgvgpointgroupaward_config.GetConfigData() return configData end
---@return dictgvgpointgroupaward_config_cell
function dictgvgpointgroupaward_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,table<number,dictseasonpointaward_config_cell>>
local __NewReward = {}
function dictgvgpointgroupaward_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if __NewReward[v.seasonid]==nil then
			__NewReward[v.seasonid]={}
		end
		v.rankfrom=v.winlose
		v.rankto=v.winlose
		table.insert(__NewReward[v.seasonid],v)
	end
end
function dictgvgpointgroupaward_config.GetDataByRank(rank,seasonid)
	for k, v in pairs(__NewReward[seasonid]) do
		if rank <= v.rankto and rank>=v.rankfrom then
			return v
		end
	end
	return nil
end
function dictgvgpointgroupaward_config.GetDataBySeasonid(seasonid)
	return __NewReward[seasonid]
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictgvgpointgroupaward_config.AnalyseConfig()
----%%%-------------%%%----








return dictgvgpointgroupaward_config
