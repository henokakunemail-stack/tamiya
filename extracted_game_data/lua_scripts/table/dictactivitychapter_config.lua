



---@class dictactivitychapter_config




dictactivitychapter_config = {}
---@type table<number,dictactivitychapter_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictactivitychapter')), '')
local bytes = mono.LoadBytes('dictactivitychapter')
local cfg = assert(Dll_PB.decode('dictactivitychapter_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictactivitychapter.txt'
function dictactivitychapter_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 chaptertype = ConvertToNumber(configName, 'chaptertype', columns[2]),
		 timeflag = ConvertToNumber(configName, 'timeflag', columns[3]),
		 batno = ConvertToNumber(configName, 'batno', columns[4]),
		 begintime = ConvertToNumber(configName, 'begintime', columns[5]),
		 endtime = ConvertToNumber(configName, 'endtime', columns[6]),
		 needlev = ConvertToNumber(configName, 'needlev', columns[7]),
		 starover = ConvertToNumber(configName, 'starover', columns[8]),
		 mapname = columns[9],
		 mapicon = columns[10],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictactivitychapter_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictactivitychapter_config_cell>
function dictactivitychapter_config.GetConfigData() return configData end
---@return dictactivitychapter_config_cell
function dictactivitychapter_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictactivitychapter_config
