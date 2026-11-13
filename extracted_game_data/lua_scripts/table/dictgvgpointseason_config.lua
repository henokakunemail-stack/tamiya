



---@class dictgvgpointseason_config




dictgvgpointseason_config = {}
---@type table<number,dictgvgpointseason_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictgvgpointseason')), '')
local bytes = mono.LoadBytes('dictgvgpointseason')
local cfg = assert(Dll_PB.decode('dictgvgpointseason_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictgvgpointseason.txt'
function dictgvgpointseason_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 start1 = ConvertToNumber(configName, 'start1', columns[2]),
		 end1 = ConvertToNumber(configName, 'end1', columns[3]),
		 result1 = ConvertToNumber(configName, 'result1', columns[4]),
		 start2 = ConvertToNumber(configName, 'start2', columns[5]),
		 end2 = ConvertToNumber(configName, 'end2', columns[6]),
		 result2 = ConvertToNumber(configName, 'result2', columns[7]),
		 start3 = ConvertToNumber(configName, 'start3', columns[8]),
		 end3 = ConvertToNumber(configName, 'end3', columns[9]),
		 result3 = ConvertToNumber(configName, 'result3', columns[10]),
		 start4 = ConvertToNumber(configName, 'start4', columns[11]),
		 end4 = ConvertToNumber(configName, 'end4', columns[12]),
		 result4 = ConvertToNumber(configName, 'result4', columns[13]),
		 over1 = ConvertToNumber(configName, 'over1', columns[14]),
		 over2 = ConvertToNumber(configName, 'over2', columns[15]),
		 track1 = ConvertToNumber(configName, 'track1', columns[16]),
		 track2 = ConvertToNumber(configName, 'track2', columns[17]),
		 track3 = ConvertToNumber(configName, 'track3', columns[18]),
		 ground1 = ConvertToNumber(configName, 'ground1', columns[19]),
		 racegvgapplication = columns[20],
		 racegvgfirst = columns[21],
		 racegvgsecond = columns[22],
		 racegvgthird = columns[23],
		 racegvgsettlement = columns[24],
		 racegvgapplicationdes = columns[25],
		 racegvgfirstdes = columns[26],
		 racegvgseconddes = columns[27],
		 racegvgthirddes = columns[28],
		 racegvgsettlementdes = columns[29],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictgvgpointseason_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictgvgpointseason_config_cell>
function dictgvgpointseason_config.GetConfigData() return configData end
---@return dictgvgpointseason_config_cell
function dictgvgpointseason_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictgvgpointseason_config
