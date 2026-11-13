



---@class assembleruleexpand_config




assembleruleexpand_config = {}
---@type table<number,assembleruleexpand_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/assembleruleexpand')), '')
local bytes = mono.LoadBytes('assembleruleexpand')
local cfg = assert(Dll_PB.decode('assembleruleexpand_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'assembleruleexpand.txt'
function assembleruleexpand_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 groove = ConvertToNumber(configName, 'groove', columns[2]),
		 type = ConvertToNumber(configName, 'type', columns[3]),
		 param1 = columns[4],
		 param2 = columns[5],
		 param3 = columns[6],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
assembleruleexpand_config.Load()
----------以pb方式加载配置表---end




---@return table<number,assembleruleexpand_config_cell>
function assembleruleexpand_config.GetConfigData() return configData end
---@return assembleruleexpand_config_cell
function assembleruleexpand_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@return assembleruleexpand_config_cell
function assembleruleexpand_config.GetRule(grooveid, type)
	local result = nil
	local erroridx = 0
	for k, v in pairs(configData) do
		if v.groove == grooveid and v.type == type then
			result = v
			erroridx = erroridx + 1
		end
	end
	if erroridx > 1 then
		logError("---   error:assembleruleexpand_config   出现重复数据,grooveid = ", grooveid,"type = ", type)
	end
	return result
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return assembleruleexpand_config
