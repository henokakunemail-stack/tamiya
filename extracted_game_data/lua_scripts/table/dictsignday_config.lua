



---@class dictsignday_config




dictsignday_config = {}
---@type table<number,dictsignday_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictsignday')), '')
local bytes = mono.LoadBytes('dictsignday')
local cfg = assert(Dll_PB.decode('dictsignday_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictsignday.txt'
function dictsignday_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 propsid = ConvertToNumber(configName, 'propsid', columns[2]),
		 propsnum = ConvertToNumber(configName, 'propsnum', columns[3]),
		 desc = columns[4],
		 icon = columns[5],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictsignday_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictsignday_config_cell>
function dictsignday_config.GetConfigData() return configData end
---@return dictsignday_config_cell
function dictsignday_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictsignday_config
