



---@class dictnpc_config




dictnpc_config = {}
---@type table<number,dictnpc_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictnpc')), '')
local bytes = mono.LoadBytes('dictnpc')
local cfg = assert(Dll_PB.decode('dictnpc_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictnpc.txt'
function dictnpc_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 score = ConvertToNumber(configName, 'score', columns[2]),
		 npclevel = ConvertToNumber(configName, 'npclevel', columns[3]),
		 name = columns[4],
		 suits = ConvertToNumber(configName, 'suits', columns[5]),
		 hero = ConvertToNumber(configName, 'hero', columns[6]),
		 npcskills = ConvertToNumber(configName, 'npcskills', columns[7]),
		 attr1 = ConvertToNumber(configName, 'attr1', columns[8]),
		 attr2 = ConvertToNumber(configName, 'attr2', columns[9]),
		 attr3 = ConvertToNumber(configName, 'attr3', columns[10]),
		 attr4 = ConvertToNumber(configName, 'attr4', columns[11]),
		 attr5 = ConvertToNumber(configName, 'attr5', columns[12]),
		 attr6 = ConvertToNumber(configName, 'attr6', columns[13]),
		 attr7 = ConvertToNumber(configName, 'attr7', columns[14]),
		 attr8 = ConvertToNumber(configName, 'attr8', columns[15]),
		 attr9 = ConvertToNumber(configName, 'attr9', columns[16]),
		 attr10 = ConvertToNumber(configName, 'attr10', columns[17]),
		 attr11 = ConvertToNumber(configName, 'attr11', columns[18]),
		 attr12 = ConvertToNumber(configName, 'attr12', columns[19]),
		 attr13 = ConvertToNumber(configName, 'attr13', columns[20]),
		 attr14 = ConvertToNumber(configName, 'attr14', columns[21]),
		 attr15 = ConvertToNumber(configName, 'attr15', columns[22]),
		 attr16 = ConvertToNumber(configName, 'attr16', columns[23]),
		 attr17 = ConvertToNumber(configName, 'attr17', columns[24]),
		 attr18 = ConvertToNumber(configName, 'attr18', columns[25]),
		 attr19 = ConvertToNumber(configName, 'attr19', columns[26]),
		 attr20 = ConvertToNumber(configName, 'attr20', columns[27]),
		 attr21 = ConvertToNumber(configName, 'attr21', columns[28]),
		 attr22 = ConvertToNumber(configName, 'attr22', columns[29]),
		 attr23 = ConvertToNumber(configName, 'attr23', columns[30]),
		 attr26 = ConvertToNumber(configName, 'attr26', columns[31]),
		 attr27 = ConvertToNumber(configName, 'attr27', columns[32]),
		 attr28 = ConvertToNumber(configName, 'attr28', columns[33]),
		 attr29 = ConvertToNumber(configName, 'attr29', columns[34]),
		 attr30 = ConvertToNumber(configName, 'attr30', columns[35]),
		 attr31 = ConvertToNumber(configName, 'attr31', columns[36]),
		 attr39 = ConvertToNumber(configName, 'attr39', columns[37]),
		 attr40 = ConvertToNumber(configName, 'attr40', columns[38]),
		 attr41 = ConvertToNumber(configName, 'attr41', columns[39]),
		 attr42 = ConvertToNumber(configName, 'attr42', columns[40]),
		 attr43 = ConvertToNumber(configName, 'attr43', columns[41]),
		 attr44 = ConvertToNumber(configName, 'attr44', columns[42]),
		 attr45 = ConvertToNumber(configName, 'attr45', columns[43]),
		 attr46 = ConvertToNumber(configName, 'attr46', columns[44]),
		 attr47 = ConvertToNumber(configName, 'attr47', columns[45]),
		 attr48 = ConvertToNumber(configName, 'attr48', columns[46]),
		 attr49 = ConvertToNumber(configName, 'attr49', columns[47]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictnpc_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictnpc_config_cell>
function dictnpc_config.GetConfigData() return configData end
---@return dictnpc_config_cell
function dictnpc_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictnpc_config
