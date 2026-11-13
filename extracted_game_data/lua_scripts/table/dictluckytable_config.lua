



---@class dictluckytable_config




dictluckytable_config = {}
---@type table<number,dictluckytable_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictluckytable')), '')
local bytes = mono.LoadBytes('dictluckytable')
local cfg = assert(Dll_PB.decode('dictluckytable_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictluckytable.txt'
function dictluckytable_config.Load()
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
		 randval = ConvertToNumber(configName, 'randval', columns[4]),
		 hitflag = ConvertToNumber(configName, 'hitflag', columns[5]),
		 hitsum = ConvertToNumber(configName, 'hitsum', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictluckytable_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictluckytable_config_cell>
function dictluckytable_config.GetConfigData() return configData end
---@return dictluckytable_config_cell
function dictluckytable_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictluckytable_config
