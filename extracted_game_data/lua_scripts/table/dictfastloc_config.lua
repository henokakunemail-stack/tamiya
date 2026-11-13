



---@class dictfastloc_config




dictfastloc_config = {}
---@type table<number,dictfastloc_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictfastloc')), '')
local bytes = mono.LoadBytes('dictfastloc')
local cfg = assert(Dll_PB.decode('dictfastloc_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictfastloc.txt'
function dictfastloc_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 lrand = ConvertToNumber(configName, 'lrand', columns[2]),
		 mrand = ConvertToNumber(configName, 'mrand', columns[3]),
		 hrand = ConvertToNumber(configName, 'hrand', columns[4]),
		 srand = ConvertToNumber(configName, 'srand', columns[5]),
		 upgradelow = ConvertToNumber(configName, 'upgradelow', columns[6]),
		 upgradehigh = ConvertToNumber(configName, 'upgradehigh', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictfastloc_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictfastloc_config_cell>
function dictfastloc_config.GetConfigData() return configData end
---@return dictfastloc_config_cell
function dictfastloc_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictfastloc_config
