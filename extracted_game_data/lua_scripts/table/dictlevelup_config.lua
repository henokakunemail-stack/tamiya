



---@class dictlevelup_config




dictlevelup_config = {}
---@type table<number,dictlevelup_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictlevelup')), '')
local bytes = mono.LoadBytes('dictlevelup')
local cfg = assert(Dll_PB.decode('dictlevelup_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictlevelup.txt'
function dictlevelup_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 needexp = ConvertToNumber(configName, 'needexp', columns[2]),
		 maxpower = ConvertToNumber(configName, 'maxpower', columns[3]),
		 unlockfunc = columns[4],
		 awardids = columns[5],
		 awardnums = columns[6],
		 maxreformlev = ConvertToNumber(configName, 'maxreformlev', columns[7]),
		 addpower = ConvertToNumber(configName, 'addpower', columns[8]),
		 buffid = ConvertToNumber(configName, 'buffid', columns[9]),
		 energyrecovery = ConvertToNumber(configName, 'energyrecovery', columns[10]),
		 energymax = ConvertToNumber(configName, 'energymax', columns[11]),
		 protect = ConvertToNumber(configName, 'protect', columns[12]),
		 getawardids = columns[13],
		 getawardnums = columns[14],
		 itemid = ConvertToNumber(configName, 'itemid', columns[15]),
		 leveldesc = columns[16],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictlevelup_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictlevelup_config_cell>
function dictlevelup_config.GetConfigData() return configData end
---@return dictlevelup_config_cell
function dictlevelup_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictlevelup_config
