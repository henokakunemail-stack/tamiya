



---@class dictcomposenew_config




dictcomposenew_config = {}
---@type table<number,dictcomposenew_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictcomposenew')), '')
local bytes = mono.LoadBytes('dictcomposenew')
local cfg = assert(Dll_PB.decode('dictcomposenew_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictcomposenew.txt'
function dictcomposenew_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 comptype = ConvertToNumber(configName, 'comptype', columns[2]),
		 propid = ConvertToNumber(configName, 'propid', columns[3]),
		 proptype = ConvertToNumber(configName, 'proptype', columns[4]),
		 composegold = ConvertToNumber(configName, 'composegold', columns[5]),
		 consumeids = columns[6],
		 consumenums = columns[7],
		 consumeparts = columns[8],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictcomposenew_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictcomposenew_config_cell>
function dictcomposenew_config.GetConfigData() return configData end
---@return dictcomposenew_config_cell
function dictcomposenew_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewCfgData={}
local tableCount=0
function dictcomposenew_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if __NewCfgData[v.comptype]==nil then
			__NewCfgData[v.comptype]={}
			tableCount=tableCount+1
		end
		table.insert( __NewCfgData[v.comptype],v)
	end
end
function dictcomposenew_config.GetTableCount()
	return tableCount
end
function dictcomposenew_config.GetComposeList(type)
	if __NewCfgData[type] then
		return __NewCfgData[type]
	end
	return {}
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictcomposenew_config.AnalyseConfig()
----%%%-------------%%%----








return dictcomposenew_config
