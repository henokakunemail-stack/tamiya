



---@class dictrankseason_config




dictrankseason_config = {}
---@type table<number,dictrankseason_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictrankseason')), '')
local bytes = mono.LoadBytes('dictrankseason')
local cfg = assert(Dll_PB.decode('dictrankseason_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictrankseason.txt'
function dictrankseason_config.Load()
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
		 trackids = columns[6],
		 background = ConvertToNumber(configName, 'background', columns[7]),
		 rltrackids = columns[8],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictrankseason_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictrankseason_config_cell>
function dictrankseason_config.GetConfigData() return configData end
---@return dictrankseason_config_cell
function dictrankseason_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictrankseason_config
