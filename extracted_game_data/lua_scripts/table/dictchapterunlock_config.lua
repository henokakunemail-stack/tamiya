



---@class dictchapterunlock_config




dictchapterunlock_config = {}
---@type table<number,dictchapterunlock_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictchapterunlock')), '')
local bytes = mono.LoadBytes('dictchapterunlock')
local cfg = assert(Dll_PB.decode('dictchapterunlock_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictchapterunlock.txt'
function dictchapterunlock_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = columns[1],
		 needpass = ConvertToNumber(configName, 'needpass', columns[2]),
		 unlockids = columns[3],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictchapterunlock_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictchapterunlock_config_cell>
function dictchapterunlock_config.GetConfigData() return configData end
---@return dictchapterunlock_config_cell
function dictchapterunlock_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictchapterunlock_config
