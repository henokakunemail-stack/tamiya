



---@class dictguildlevel_config




dictguildlevel_config = {}
---@type table<number,dictguildlevel_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictguildlevel')), '')
local bytes = mono.LoadBytes('dictguildlevel')
local cfg = assert(Dll_PB.decode('dictguildlevel_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictguildlevel.txt'
function dictguildlevel_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 guildexpe = ConvertToNumber(configName, 'guildexpe', columns[2]),
		 guildnum = ConvertToNumber(configName, 'guildnum', columns[3]),
		 signgiftids = columns[4],
		 signgiftnums = columns[5],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictguildlevel_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictguildlevel_config_cell>
function dictguildlevel_config.GetConfigData() return configData end
---@return dictguildlevel_config_cell
function dictguildlevel_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictguildlevel_config
