



---@class dictshopgrid_config




dictshopgrid_config = {}
---@type table<number,dictshopgrid_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictshopgrid')), '')
local bytes = mono.LoadBytes('dictshopgrid')
local cfg = assert(Dll_PB.decode('dictshopgrid_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictshopgrid.txt'
function dictshopgrid_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 grid = ConvertToNumber(configName, 'grid', columns[2]),
		 groupid = ConvertToNumber(configName, 'groupid', columns[3]),
		 startsell = ConvertToNumber(configName, 'startsell', columns[4]),
		 endsell = ConvertToNumber(configName, 'endsell', columns[5]),
		 sort = ConvertToNumber(configName, 'sort', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictshopgrid_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictshopgrid_config_cell>
function dictshopgrid_config.GetConfigData() return configData end
---@return dictshopgrid_config_cell
function dictshopgrid_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictshopgrid_config
