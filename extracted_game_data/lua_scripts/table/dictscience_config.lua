



---@class dictscience_config




dictscience_config = {}
---@type table<number,dictscience_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictscience')), '')
local bytes = mono.LoadBytes('dictscience')
local cfg = assert(Dll_PB.decode('dictscience_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictscience.txt'
function dictscience_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 prelev = ConvertToNumber(configName, 'prelev', columns[2]),
		 consumeids = columns[3],
		 consumenums = columns[4],
		 initunlock = ConvertToNumber(configName, 'initunlock', columns[5]),
		 techids = columns[6],
		 name = columns[7],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictscience_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictscience_config_cell>
function dictscience_config.GetConfigData() return configData end
---@return dictscience_config_cell
function dictscience_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictscience_config
