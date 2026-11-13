



---@class championships_config




championships_config = {}
---@type table<number,championships_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/championships')), '')
local bytes = mono.LoadBytes('championships')
local cfg = assert(Dll_PB.decode('championships_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'championships.txt'
function championships_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 type = ConvertToNumber(configName, 'type', columns[2]),
		 week = ConvertToNumber(configName, 'week', columns[3]),
		 cost = columns[4],
		 condition = columns[5],
		 rules = columns[6],
		 time = ConvertToNumber(configName, 'time', columns[7]),
		 duration = ConvertToNumber(configName, 'duration', columns[8]),
		 times = ConvertToNumber(configName, 'times', columns[9]),
		 timeLimit = ConvertToNumber(configName, 'timeLimit', columns[10]),
		 price = ConvertToNumber(configName, 'price', columns[11]),
		 reward = columns[12],
		 sceneId = ConvertToNumber(configName, 'sceneId', columns[13]),
		 trackId = ConvertToNumber(configName, 'trackId', columns[14]),
		 name = columns[15],
		 rulename = columns[16],
		 icon = columns[17],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
championships_config.Load()
----------以pb方式加载配置表---end




---@return table<number,championships_config_cell>
function championships_config.GetConfigData() return configData end
---@return championships_config_cell
function championships_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@return championships_config_cell
function championships_config.GetWeekData(type, week, starthour)
	for k, v in pairs(configData) do
		if v.type == type and v.week == week and v.time == starthour then
			return v
		end
	end
	return nil
end
function championships_config.AnalyseConfig()
	for k, v in pairs(configData) do
		--configData[k].NewID = v.id * 1000 + v.partGroup
		local temp = stringSplit(v.rules, ';')
		configData[k].NewRules = temp

	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
championships_config.AnalyseConfig()
----%%%-------------%%%----








return championships_config
