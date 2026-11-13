



---@class dictpackage_config




dictpackage_config = {}
---@type table<number,dictpackage_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictpackage')), '')
local bytes = mono.LoadBytes('dictpackage')
local cfg = assert(Dll_PB.decode('dictpackage_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictpackage.txt'
function dictpackage_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 packcode = ConvertToNumber(configName, 'packcode', columns[2]),
		 groupid = ConvertToNumber(configName, 'groupid', columns[3]),
		 propsid = ConvertToNumber(configName, 'propsid', columns[4]),
		 propsnum = ConvertToNumber(configName, 'propsnum', columns[5]),
		 randval = ConvertToNumber(configName, 'randval', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictpackage_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictpackage_config_cell>
function dictpackage_config.GetConfigData() return configData end
---@return dictpackage_config_cell
function dictpackage_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

function dictpackage_config.GetListById(id)
	local _list = {}
	for i, v in pairs(configData) do
		if v.packcode == id then
			table.insert(_list, v)
		end
	end
	return _list
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictpackage_config
