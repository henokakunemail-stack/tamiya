



---@class dictbearcopy_config




dictbearcopy_config = {}
---@type table<number,dictbearcopy_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictbearcopy')), '')
local bytes = mono.LoadBytes('dictbearcopy')
local cfg = assert(Dll_PB.decode('dictbearcopy_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictbearcopy.txt'
function dictbearcopy_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 matchid = ConvertToNumber(configName, 'matchid', columns[2]),
		 matchtype = ConvertToNumber(configName, 'matchtype', columns[3]),
		 blocknum = ConvertToNumber(configName, 'blocknum', columns[4]),
		 matchtime = ConvertToNumber(configName, 'matchtime', columns[5]),
		 begintime = ConvertToNumber(configName, 'begintime', columns[6]),
		 endtime = ConvertToNumber(configName, 'endtime', columns[7]),
		 linkid = ConvertToNumber(configName, 'linkid', columns[8]),
		 awardid = ConvertToNumber(configName, 'awardid', columns[9]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictbearcopy_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictbearcopy_config_cell>
function dictbearcopy_config.GetConfigData() return configData end
---@return dictbearcopy_config_cell
function dictbearcopy_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictbearcopy_config
