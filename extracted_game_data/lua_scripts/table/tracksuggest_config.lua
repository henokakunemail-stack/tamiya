



---@class tracksuggest_config




tracksuggest_config = {}
---@type table<number,tracksuggest_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/tracksuggest')), '')
local bytes = mono.LoadBytes('tracksuggest')
local cfg = assert(Dll_PB.decode('tracksuggest_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'tracksuggest.txt'
function tracksuggest_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 track = ConvertToNumber(configName, 'track', columns[2]),
		 motor = ConvertToNumber(configName, 'motor', columns[3]),
		 gear = ConvertToNumber(configName, 'gear', columns[4]),
		 stabilizeMin = ConvertToNumber(configName, 'stabilizeMin', columns[5]),
		 stabilizeMax = ConvertToNumber(configName, 'stabilizeMax', columns[6]),
		 cushionMin = ConvertToNumber(configName, 'cushionMin', columns[7]),
		 cushionMax = ConvertToNumber(configName, 'cushionMax', columns[8]),
		 downforceMin = ConvertToNumber(configName, 'downforceMin', columns[9]),
		 downforceMax = ConvertToNumber(configName, 'downforceMax', columns[10]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
tracksuggest_config.Load()
----------以pb方式加载配置表---end




---@return table<number,tracksuggest_config_cell>
function tracksuggest_config.GetConfigData() return configData end
---@return tracksuggest_config_cell
function tracksuggest_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return tracksuggest_config
