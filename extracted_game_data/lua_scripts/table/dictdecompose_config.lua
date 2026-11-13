



---@class dictdecompose_config




dictdecompose_config = {}
---@type table<number,dictdecompose_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictdecompose')), '')
local bytes = mono.LoadBytes('dictdecompose')
local cfg = assert(Dll_PB.decode('dictdecompose_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictdecompose.txt'
function dictdecompose_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 id = ConvertToNumber(configName, 'id', columns[2]),
		 propsid = ConvertToNumber(configName, 'propsid', columns[3]),
		 propsnum = ConvertToNumber(configName, 'propsnum', columns[4]),
		 weight = ConvertToNumber(configName, 'weight', columns[5]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictdecompose_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictdecompose_config_cell>
function dictdecompose_config.GetConfigData() return configData end
---@return dictdecompose_config_cell
function dictdecompose_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictdecompose_config
