



---@class dictseasonaward_config




dictseasonaward_config = {}
---@type table<number,dictseasonaward_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictseasonaward')), '')
local bytes = mono.LoadBytes('dictseasonaward')
local cfg = assert(Dll_PB.decode('dictseasonaward_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictseasonaward.txt'
function dictseasonaward_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 rankidx = ConvertToNumber(configName, 'rankidx', columns[2]),
		 star = ConvertToNumber(configName, 'star', columns[3]),
		 rankid = columns[4],
		 winaward = columns[5],
		 winpoint = columns[6],
		 integral = ConvertToNumber(configName, 'integral', columns[7]),
		 name = columns[8],
		 icon = columns[9],
		 subpoint = ConvertToNumber(configName, 'subpoint', columns[10]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictseasonaward_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictseasonaward_config_cell>
function dictseasonaward_config.GetConfigData() return configData end
---@return dictseasonaward_config_cell
function dictseasonaward_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewConfigData = {}

function dictseasonaward_config.AnalyseConfig()
	for k, v in pairs(configData) do
		table.insert(__NewConfigData, v)
	end

	table.sort(__NewConfigData,function (a, b)
		return a.C_ID < b.C_ID
	end)
end
function dictseasonaward_config.GetDataList()
	return __NewConfigData
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictseasonaward_config.AnalyseConfig()
----%%%-------------%%%----








return dictseasonaward_config
