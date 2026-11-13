



---@class npcai_config




npcai_config = {}
---@type table<number,npcai_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/npcai')), '')
local bytes = mono.LoadBytes('npcai')
local cfg = assert(Dll_PB.decode('npcai_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'npcai.txt'
function npcai_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 condition = ConvertToNumber(configName, 'condition', columns[2]),
		 once = ConvertToNumber(configName, 'once', columns[3]),
		 twice = ConvertToNumber(configName, 'twice', columns[4]),
		 threeTimes = ConvertToNumber(configName, 'threeTimes', columns[5]),
		 fourtimes = ConvertToNumber(configName, 'fourtimes', columns[6]),
		 default = ConvertToNumber(configName, 'default', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
npcai_config.Load()
----------以pb方式加载配置表---end




---@return table<number,npcai_config_cell>
function npcai_config.GetConfigData() return configData end
---@return npcai_config_cell
function npcai_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return npcai_config
