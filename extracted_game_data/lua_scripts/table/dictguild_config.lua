



---@class dictguild_config




dictguild_config = {}
---@type table<number,dictguild_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictguild')), '')
local bytes = mono.LoadBytes('dictguild')
local cfg = assert(Dll_PB.decode('dictguild_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictguild.txt'
function dictguild_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 exp = ConvertToNumber(configName, 'exp', columns[2]),
		 maxnum = ConvertToNumber(configName, 'maxnum', columns[3]),
		 limitnum4 = ConvertToNumber(configName, 'limitnum4', columns[4]),
		 limitnum3 = ConvertToNumber(configName, 'limitnum3', columns[5]),
		 limitnum2 = ConvertToNumber(configName, 'limitnum2', columns[6]),
		 maxdonation = ConvertToNumber(configName, 'maxdonation', columns[7]),
		 maxexch = ConvertToNumber(configName, 'maxexch', columns[8]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictguild_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictguild_config_cell>
function dictguild_config.GetConfigData() return configData end
---@return dictguild_config_cell
function dictguild_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictguild_config
