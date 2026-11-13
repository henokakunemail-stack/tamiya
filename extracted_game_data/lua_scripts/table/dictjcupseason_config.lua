



---@class dictjcupseason_config




dictjcupseason_config = {}
---@type table<number,dictjcupseason_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictjcupseason')), '')
local bytes = mono.LoadBytes('dictjcupseason')
local cfg = assert(Dll_PB.decode('dictjcupseason_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictjcupseason.txt'
function dictjcupseason_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 start1 = ConvertToNumber(configName, 'start1', columns[2]),
		 join1 = ConvertToNumber(configName, 'join1', columns[3]),
		 join2 = ConvertToNumber(configName, 'join2', columns[4]),
		 start2 = ConvertToNumber(configName, 'start2', columns[5]),
		 result1 = ConvertToNumber(configName, 'result1', columns[6]),
		 result2 = ConvertToNumber(configName, 'result2', columns[7]),
		 nextseasonid = ConvertToNumber(configName, 'nextseasonid', columns[8]),
		 sceneid = ConvertToNumber(configName, 'sceneid', columns[9]),
		 trackid = ConvertToNumber(configName, 'trackid', columns[10]),
		 needpart = columns[11],
		 unpart = columns[12],
		 taskids = columns[13],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictjcupseason_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictjcupseason_config_cell>
function dictjcupseason_config.GetConfigData() return configData end
---@return dictjcupseason_config_cell
function dictjcupseason_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictjcupseason_config
