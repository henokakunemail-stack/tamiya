



---@class dictworldtopseason_config




dictworldtopseason_config = {}
---@type table<number,dictworldtopseason_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictworldtopseason')), '')
local bytes = mono.LoadBytes('dictworldtopseason')
local cfg = assert(Dll_PB.decode('dictworldtopseason_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictworldtopseason.txt'
function dictworldtopseason_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 btime = ConvertToNumber(configName, 'btime', columns[2]),
		 daystart1 = ConvertToNumber(configName, 'daystart1', columns[3]),
		 start1 = columns[4],
		 dayend1 = ConvertToNumber(configName, 'dayend1', columns[5]),
		 end1 = columns[6],
		 dayresult1 = ConvertToNumber(configName, 'dayresult1', columns[7]),
		 result1 = columns[8],
		 daystart2 = ConvertToNumber(configName, 'daystart2', columns[9]),
		 start2 = columns[10],
		 dayend2 = ConvertToNumber(configName, 'dayend2', columns[11]),
		 end2 = columns[12],
		 dayresult2 = ConvertToNumber(configName, 'dayresult2', columns[13]),
		 result2 = columns[14],
		 daystart3 = ConvertToNumber(configName, 'daystart3', columns[15]),
		 start3 = columns[16],
		 dayend3 = ConvertToNumber(configName, 'dayend3', columns[17]),
		 end3 = columns[18],
		 dayresult3 = ConvertToNumber(configName, 'dayresult3', columns[19]),
		 result3 = columns[20],
		 daystart4 = ConvertToNumber(configName, 'daystart4', columns[21]),
		 start4 = columns[22],
		 dayend4 = ConvertToNumber(configName, 'dayend4', columns[23]),
		 end4 = columns[24],
		 dayresult4 = ConvertToNumber(configName, 'dayresult4', columns[25]),
		 result4 = columns[26],
		 daystart5 = ConvertToNumber(configName, 'daystart5', columns[27]),
		 start5 = columns[28],
		 dayend5 = ConvertToNumber(configName, 'dayend5', columns[29]),
		 end5 = columns[30],
		 dayresult5 = ConvertToNumber(configName, 'dayresult5', columns[31]),
		 result5 = columns[32],
		 daystart6 = ConvertToNumber(configName, 'daystart6', columns[33]),
		 start6 = columns[34],
		 dayend6 = ConvertToNumber(configName, 'dayend6', columns[35]),
		 end6 = columns[36],
		 dayresult6 = ConvertToNumber(configName, 'dayresult6', columns[37]),
		 result6 = columns[38],
		 dayover1 = ConvertToNumber(configName, 'dayover1', columns[39]),
		 over1 = columns[40],
		 dayover2 = ConvertToNumber(configName, 'dayover2', columns[41]),
		 over2 = columns[42],
		 trackA = ConvertToNumber(configName, 'trackA', columns[43]),
		 track32 = ConvertToNumber(configName, 'track32', columns[44]),
		 track16 = ConvertToNumber(configName, 'track16', columns[45]),
		 track8 = ConvertToNumber(configName, 'track8', columns[46]),
		 track4 = ConvertToNumber(configName, 'track4', columns[47]),
		 track2 = ConvertToNumber(configName, 'track2', columns[48]),
		 trackB = ConvertToNumber(configName, 'trackB', columns[49]),
		 ground1 = ConvertToNumber(configName, 'ground1', columns[50]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictworldtopseason_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictworldtopseason_config_cell>
function dictworldtopseason_config.GetConfigData() return configData end
---@return dictworldtopseason_config_cell
function dictworldtopseason_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictworldtopseason_config
