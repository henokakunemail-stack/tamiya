



---@class dictfairmatchparts_config




dictfairmatchparts_config = {}
---@type table<number,dictfairmatchparts_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictfairmatchparts')), '')
local bytes = mono.LoadBytes('dictfairmatchparts')
local cfg = assert(Dll_PB.decode('dictfairmatchparts_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictfairmatchparts.txt'
function dictfairmatchparts_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 partid = ConvertToNumber(configName, 'partid', columns[2]),
		 partlev = ConvertToNumber(configName, 'partlev', columns[3]),
		 partstar = ConvertToNumber(configName, 'partstar', columns[4]),
		 partage = ConvertToNumber(configName, 'partage', columns[5]),
		 partbreak = ConvertToNumber(configName, 'partbreak', columns[6]),
		 partnum = ConvertToNumber(configName, 'partnum', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictfairmatchparts_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictfairmatchparts_config_cell>
function dictfairmatchparts_config.GetConfigData() return configData end
---@return dictfairmatchparts_config_cell
function dictfairmatchparts_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----


----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictfairmatchparts_config
