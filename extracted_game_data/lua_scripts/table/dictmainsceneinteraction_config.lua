



---@class dictmainsceneinteraction_config




dictmainsceneinteraction_config = {}
---@type table<number,dictmainsceneinteraction_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictmainsceneinteraction')), '')
local bytes = mono.LoadBytes('dictmainsceneinteraction')
local cfg = assert(Dll_PB.decode('dictmainsceneinteraction_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictmainsceneinteraction.txt'
function dictmainsceneinteraction_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 rootnode = columns[2],
		 funtype = ConvertToNumber(configName, 'funtype', columns[3]),
		 unlockmaterial = columns[4],
		 lockmaterial = columns[5],
		 boxnode = columns[6],
		 parentmapnode = ConvertToNumber(configName, 'parentmapnode', columns[7]),
		 mapnode = ConvertToNumber(configName, 'mapnode', columns[8]),
		 mapname = columns[9],
		 params = columns[10],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictmainsceneinteraction_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictmainsceneinteraction_config_cell>
function dictmainsceneinteraction_config.GetConfigData() return configData end
---@return dictmainsceneinteraction_config_cell
function dictmainsceneinteraction_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictmainsceneinteraction_config
