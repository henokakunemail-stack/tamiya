



---@class dictcompose1_config




dictcompose1_config = {}
---@type table<number,dictcompose1_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictcompose1')), '')
local bytes = mono.LoadBytes('dictcompose1')
local cfg = assert(Dll_PB.decode('dictcompose1_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictcompose1.txt'
function dictcompose1_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 addexp = ConvertToNumber(configName, 'addexp', columns[2]),
		 consumeids = ConvertToNumber(configName, 'consumeids', columns[3]),
		 consumnums = ConvertToNumber(configName, 'consumnums', columns[4]),
		 composegold = ConvertToNumber(configName, 'composegold', columns[5]),
		 breakrand = ConvertToNumber(configName, 'breakrand', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictcompose1_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictcompose1_config_cell>
function dictcompose1_config.GetConfigData() return configData end
---@return dictcompose1_config_cell
function dictcompose1_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictcompose1_config
