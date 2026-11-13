



---@class dictsprintactivity_config




dictsprintactivity_config = {}
---@type table<number,dictsprintactivity_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictsprintactivity')), '')
local bytes = mono.LoadBytes('dictsprintactivity')
local cfg = assert(Dll_PB.decode('dictsprintactivity_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictsprintactivity.txt'
function dictsprintactivity_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 sprintstart = ConvertToNumber(configName, 'sprintstart', columns[2]),
		 startweek = ConvertToNumber(configName, 'startweek', columns[3]),
		 endweek = ConvertToNumber(configName, 'endweek', columns[4]),
		 sprintgift = columns[5],
		 sprintshop = ConvertToNumber(configName, 'sprintshop', columns[6]),
		 sprintaward = ConvertToNumber(configName, 'sprintaward', columns[7]),
		 actname = columns[8],
		 acticon = columns[9],
		 acttips = columns[10],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictsprintactivity_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictsprintactivity_config_cell>
function dictsprintactivity_config.GetConfigData() return configData end
---@return dictsprintactivity_config_cell
function dictsprintactivity_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictsprintactivity_config
