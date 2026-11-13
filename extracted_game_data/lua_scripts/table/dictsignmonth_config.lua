



---@class dictsignmonth_config




dictsignmonth_config = {}
---@type table<number,dictsignmonth_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictsignmonth')), '')
local bytes = mono.LoadBytes('dictsignmonth')
local cfg = assert(Dll_PB.decode('dictsignmonth_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictsignmonth.txt'
function dictsignmonth_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 monthnum = ConvertToNumber(configName, 'monthnum', columns[2]),
		 daynum = ConvertToNumber(configName, 'daynum', columns[3]),
		 propsid = ConvertToNumber(configName, 'propsid', columns[4]),
		 propsnum = ConvertToNumber(configName, 'propsnum', columns[5]),
		 batflag = ConvertToNumber(configName, 'batflag', columns[6]),
		 desc = columns[7],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictsignmonth_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictsignmonth_config_cell>
function dictsignmonth_config.GetConfigData() return configData end
---@return dictsignmonth_config_cell
function dictsignmonth_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,dictsignmonth_config_cell>
local __NewConfigData = {}
function dictsignmonth_config.AnalyseConfig()
	__NewConfigData = {}
	for k, v in pairs(configData) do
		if __NewConfigData[v.monthnum] == nil then
			__NewConfigData[v.monthnum]={}
		end
		__NewConfigData[v.monthnum][v.daynum]=v
	end
end

function dictsignmonth_config.GetConfigDataByMonthDay(monthnum,daynum)
	if __NewConfigData[monthnum] then
		return __NewConfigData[monthnum][daynum]
	end
	return nil
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictsignmonth_config.AnalyseConfig()
----%%%-------------%%%----








return dictsignmonth_config
