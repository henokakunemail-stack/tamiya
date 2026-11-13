



---@class dictguildpveseason_config




dictguildpveseason_config = {}
---@type table<number,dictguildpveseason_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictguildpveseason')), '')
local bytes = mono.LoadBytes('dictguildpveseason')
local cfg = assert(Dll_PB.decode('dictguildpveseason_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictguildpveseason.txt'
function dictguildpveseason_config.Load()
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
		 start2 = ConvertToNumber(configName, 'start2', columns[3]),
		 result1 = ConvertToNumber(configName, 'result1', columns[4]),
		 result2 = ConvertToNumber(configName, 'result2', columns[5]),
		 nextseasonid = ConvertToNumber(configName, 'nextseasonid', columns[6]),
		 sceneids = columns[7],
		 trackids = columns[8],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictguildpveseason_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictguildpveseason_config_cell>
function dictguildpveseason_config.GetConfigData() return configData end
---@return dictguildpveseason_config_cell
function dictguildpveseason_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictguildpveseason_config
