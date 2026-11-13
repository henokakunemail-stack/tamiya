



---@class functionlist_beta_config




functionlist_beta_config = {}
---@type table<number,functionlist_beta_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/functionlist_beta')), '')
local bytes = mono.LoadBytes('functionlist_beta')
local cfg = assert(Dll_PB.decode('functionlist_beta_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'functionlist_beta.txt'
function functionlist_beta_config.Load()
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
		 icon = columns[3],
		 newbieguideId = ConvertToNumber(configName, 'newbieguideId', columns[4]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
functionlist_beta_config.Load()
----------以pb方式加载配置表---end




---@return table<number,functionlist_beta_config_cell>
function functionlist_beta_config.GetConfigData() return configData end
---@return functionlist_beta_config_cell
function functionlist_beta_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return functionlist_beta_config
