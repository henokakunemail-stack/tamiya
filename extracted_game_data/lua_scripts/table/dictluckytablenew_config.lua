



---@class dictluckytablenew_config




dictluckytablenew_config = {}
---@type table<number,dictluckytablenew_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictluckytablenew')), '')
local bytes = mono.LoadBytes('dictluckytablenew')
local cfg = assert(Dll_PB.decode('dictluckytablenew_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictluckytablenew.txt'
function dictluckytablenew_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 tableid = ConvertToNumber(configName, 'tableid', columns[2]),
		 seq = ConvertToNumber(configName, 'seq', columns[3]),
		 propsid = ConvertToNumber(configName, 'propsid', columns[4]),
		 propsnum = ConvertToNumber(configName, 'propsnum', columns[5]),
		 randval = ConvertToNumber(configName, 'randval', columns[6]),
		 hitflag = ConvertToNumber(configName, 'hitflag', columns[7]),
		 hitsum = ConvertToNumber(configName, 'hitsum', columns[8]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictluckytablenew_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictluckytablenew_config_cell>
function dictluckytablenew_config.GetConfigData() return configData end
---@return dictluckytablenew_config_cell
function dictluckytablenew_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,dictluckytablenew_config_cell>
local __NewConfigData = {}
function dictluckytablenew_config.AnalyseConfig()
	__NewConfigData = {}
	for k, v in pairs(configData) do
		if __NewConfigData[v.tableid]==nil then
			__NewConfigData[v.tableid] = {}
		end
		table.insert(__NewConfigData[v.tableid],v)
	end
end

function dictluckytablenew_config.GetDataListByTableId(id)
	return __NewConfigData[id]
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictluckytablenew_config.AnalyseConfig()
----%%%-------------%%%----








return dictluckytablenew_config
