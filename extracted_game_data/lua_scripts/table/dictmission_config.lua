



---@class dictmission_config




dictmission_config = {}
---@type table<number,dictmission_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictmission')), '')
local bytes = mono.LoadBytes('dictmission')
local cfg = assert(Dll_PB.decode('dictmission_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictmission.txt'
function dictmission_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 missiontype = ConvertToNumber(configName, 'missiontype', columns[2]),
		 missionname = columns[3],
		 missionmemo = columns[4],
		 unlocklev = ConvertToNumber(configName, 'unlocklev', columns[5]),
		 pointval = ConvertToNumber(configName, 'pointval', columns[6]),
		 condtionid = ConvertToNumber(configName, 'condtionid', columns[7]),
		 condtionkey = ConvertToNumber(configName, 'condtionkey', columns[8]),
		 succval = ConvertToNumber(configName, 'succval', columns[9]),
		 firstval = ConvertToNumber(configName, 'firstval', columns[10]),
		 awardids = columns[11],
		 awardnums = columns[12],
		 nextmission = ConvertToNumber(configName, 'nextmission', columns[13]),
		 initunlock = ConvertToNumber(configName, 'initunlock', columns[14]),
		 tradeseq = ConvertToNumber(configName, 'tradeseq', columns[15]),
		 missionjump = columns[16],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictmission_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictmission_config_cell>
function dictmission_config.GetConfigData() return configData end
---@return dictmission_config_cell
function dictmission_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictmission_config
