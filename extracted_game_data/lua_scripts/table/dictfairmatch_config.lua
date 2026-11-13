



---@class dictfairmatch_config




dictfairmatch_config = {}
---@type table<number,dictfairmatch_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictfairmatch')), '')
local bytes = mono.LoadBytes('dictfairmatch')
local cfg = assert(Dll_PB.decode('dictfairmatch_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictfairmatch.txt'
function dictfairmatch_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 matchname = columns[2],
		 timeflag = ConvertToNumber(configName, 'timeflag', columns[3]),
		 begintime = ConvertToNumber(configName, 'begintime', columns[4]),
		 endtime = ConvertToNumber(configName, 'endtime', columns[5]),
		 finishtime = ConvertToNumber(configName, 'finishtime', columns[6]),
		 bday = ConvertToNumber(configName, 'bday', columns[7]),
		 eday = ConvertToNumber(configName, 'eday', columns[8]),
		 fday = ConvertToNumber(configName, 'fday', columns[9]),
		 btime = ConvertToNumber(configName, 'btime', columns[10]),
		 etime = ConvertToNumber(configName, 'etime', columns[11]),
		 ftime = ConvertToNumber(configName, 'ftime', columns[12]),
		 partgroup = ConvertToNumber(configName, 'partgroup', columns[13]),
		 trackid = ConvertToNumber(configName, 'trackid', columns[14]),
		 scenceid = ConvertToNumber(configName, 'scenceid', columns[15]),
		 awardid = ConvertToNumber(configName, 'awardid', columns[16]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictfairmatch_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictfairmatch_config_cell>
function dictfairmatch_config.GetConfigData() return configData end
---@return dictfairmatch_config_cell
function dictfairmatch_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictfairmatch_config
