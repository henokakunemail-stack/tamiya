



---@class racelog_config




racelog_config = {}
---@type table<number,racelog_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/racelog')), '')
local bytes = mono.LoadBytes('racelog')
local cfg = assert(Dll_PB.decode('racelog_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'racelog.txt'
function racelog_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 isShow = ConvertToNumber(configName, 'isShow', columns[2]),
		 priority = ConvertToNumber(configName, 'priority', columns[3]),
		 type = ConvertToNumber(configName, 'type', columns[4]),
		 desc = columns[5],
		 param = columns[6],
		 smallDesc = columns[7],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
racelog_config.Load()
----------以pb方式加载配置表---end




---@return table<number,racelog_config_cell>
function racelog_config.GetConfigData() return configData end
---@return racelog_config_cell
function racelog_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function racelog_config.AnalyseConfig()
	for k, v in pairs(configData) do
		v.ParamType=stringSplitToNumber(v.param,':')
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
racelog_config.AnalyseConfig()
----%%%-------------%%%----








return racelog_config
