



---@class dictcapyactive_config




dictcapyactive_config = {}
---@type table<number,dictcapyactive_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictcapyactive')), '')
local bytes = mono.LoadBytes('dictcapyactive')
local cfg = assert(Dll_PB.decode('dictcapyactive_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictcapyactive.txt'
function dictcapyactive_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 acttype = ConvertToNumber(configName, 'acttype', columns[2]),
		 btime = ConvertToNumber(configName, 'btime', columns[3]),
		 etime = ConvertToNumber(configName, 'etime', columns[4]),
		 overtime = ConvertToNumber(configName, 'overtime', columns[5]),
		 awardid = ConvertToNumber(configName, 'awardid', columns[6]),
		 actname = columns[7],
		 acticon = columns[8],
		 acttips = columns[9],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictcapyactive_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictcapyactive_config_cell>
function dictcapyactive_config.GetConfigData() return configData end
---@return dictcapyactive_config_cell
function dictcapyactive_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictcapyactive_config
