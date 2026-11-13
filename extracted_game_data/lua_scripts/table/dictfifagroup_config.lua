



---@class dictfifagroup_config




dictfifagroup_config = {}
---@type table<number,dictfifagroup_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictfifagroup')), '')
local bytes = mono.LoadBytes('dictfifagroup')
local cfg = assert(Dll_PB.decode('dictfifagroup_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictfifagroup.txt'
function dictfifagroup_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 seasonid = ConvertToNumber(configName, 'seasonid', columns[2]),
		 tpye = ConvertToNumber(configName, 'tpye', columns[3]),
		 matchgroup = columns[4],
		 teama = ConvertToNumber(configName, 'teama', columns[5]),
		 teamb = ConvertToNumber(configName, 'teamb', columns[6]),
		 day = ConvertToNumber(configName, 'day', columns[7]),
		 odds = columns[8],
		 goala = ConvertToNumber(configName, 'goala', columns[9]),
		 goalb = ConvertToNumber(configName, 'goalb', columns[10]),
		 winflag = ConvertToNumber(configName, 'winflag', columns[11]),
		 endtime = ConvertToNumber(configName, 'endtime', columns[12]),
		 teamnamea = columns[13],
		 teamnameb = columns[14],
		 competitionDes = columns[15],
		 timeDes = columns[16],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictfifagroup_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictfifagroup_config_cell>
function dictfifagroup_config.GetConfigData() return configData end
---@return dictfifagroup_config_cell
function dictfifagroup_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictfifagroup_config
