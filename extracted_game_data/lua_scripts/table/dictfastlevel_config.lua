



---@class dictfastlevel_config




dictfastlevel_config = {}
---@type table<number,dictfastlevel_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictfastlevel')), '')
local bytes = mono.LoadBytes('dictfastlevel')
local cfg = assert(Dll_PB.decode('dictfastlevel_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictfastlevel.txt'
function dictfastlevel_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 levsection = ConvertToNumber(configName, 'levsection', columns[2]),
		 biglev = ConvertToNumber(configName, 'biglev', columns[3]),
		 trackids = columns[4],
		 beginpoint = ConvertToNumber(configName, 'beginpoint', columns[5]),
		 endpoint = ConvertToNumber(configName, 'endpoint', columns[6]),
		 awardids = columns[7],
		 awardnums = columns[8],
		 lev_name = columns[9],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictfastlevel_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictfastlevel_config_cell>
function dictfastlevel_config.GetConfigData() return configData end
---@return dictfastlevel_config_cell
function dictfastlevel_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewConfigData = {}

function dictfastlevel_config.AnalyseConfig()
	for k, v in pairs(configData) do
		table.insert(__NewConfigData, v)
	end

	table.sort(__NewConfigData,function (a, b)
		return a.C_ID < b.C_ID
	end)
end
function dictfastlevel_config.GetDataList()
	return __NewConfigData
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictfastlevel_config.AnalyseConfig()
----%%%-------------%%%----








return dictfastlevel_config
