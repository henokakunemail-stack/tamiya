



---@class qualifyingrank_config




qualifyingrank_config = {}
---@type table<number,qualifyingrank_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/qualifyingrank')), '')
local bytes = mono.LoadBytes('qualifyingrank')
local cfg = assert(Dll_PB.decode('qualifyingrank_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'qualifyingrank.txt'
function qualifyingrank_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 name = columns[2],
		 star = ConvertToNumber(configName, 'star', columns[3]),
		 integral = ConvertToNumber(configName, 'integral', columns[4]),
		 reward = columns[5],
		 icon = columns[6],
		 rankidx = ConvertToNumber(configName, 'rankidx', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
qualifyingrank_config.Load()
----------以pb方式加载配置表---end




---@return table<number,qualifyingrank_config_cell>
function qualifyingrank_config.GetConfigData() return configData end
---@return qualifyingrank_config_cell
function qualifyingrank_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----


---@type table<number,qualifyingrank_config_cell>
local __NewConfigData = {}

function qualifyingrank_config.AnalyseConfig()
	for k, v in pairs(configData) do
		table.insert(__NewConfigData, v)
	end

	table.sort(__NewConfigData,function (a, b)
		return a.id < b.id
	end)
end
function qualifyingrank_config.GetDataList()
	return __NewConfigData
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
qualifyingrank_config.AnalyseConfig()
----%%%-------------%%%----








return qualifyingrank_config
