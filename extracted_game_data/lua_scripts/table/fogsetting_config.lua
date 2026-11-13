



---@class fogsetting_config




fogsetting_config = {}
---@type table<number,fogsetting_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/fogsetting')), '')
local bytes = mono.LoadBytes('fogsetting')
local cfg = assert(Dll_PB.decode('fogsetting_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'fogsetting.txt'
function fogsetting_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 fog = ConvertToNumber(configName, 'fog', columns[2]),
		 color = columns[3],
		 mode = ConvertToNumber(configName, 'mode', columns[4]),
		 startPoint = ConvertToNumber(configName, 'startPoint', columns[5]),
		 endPoint = ConvertToNumber(configName, 'endPoint', columns[6]),
		 density = ConvertToNumber(configName, 'density', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
fogsetting_config.Load()
----------以pb方式加载配置表---end




---@return table<number,fogsetting_config_cell>
function fogsetting_config.GetConfigData() return configData end
---@return fogsetting_config_cell
function fogsetting_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return fogsetting_config
