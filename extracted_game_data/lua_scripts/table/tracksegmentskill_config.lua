



---@class tracksegmentskill_config




tracksegmentskill_config = {}
---@type table<number,tracksegmentskill_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/tracksegmentskill')), '')
local bytes = mono.LoadBytes('tracksegmentskill')
local cfg = assert(Dll_PB.decode('tracksegmentskill_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'tracksegmentskill.txt'
function tracksegmentskill_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 name = columns[2],
		 effectType = ConvertToNumber(configName, 'effectType', columns[3]),
		 triggerType = ConvertToNumber(configName, 'triggerType', columns[4]),
		 condition = columns[5],
		 distance = ConvertToNumber(configName, 'distance', columns[6]),
		 time = ConvertToNumber(configName, 'time', columns[7]),
		 parameter = columns[8],
		 triggerCD = ConvertToNumber(configName, 'triggerCD', columns[9]),
		 triggerCount = ConvertToNumber(configName, 'triggerCount', columns[10]),
		 maxStack = ConvertToNumber(configName, 'maxStack', columns[11]),
		 costtype = ConvertToNumber(configName, 'costtype', columns[12]),
		 costvalue = columns[13],
		 startFx = columns[14],
		 runFx = columns[15],
		 endFx = columns[16],
		 triggerStartFx = columns[17],
		 triggerRunFx = columns[18],
		 triggerEndFx = columns[19],
		 startAudio = columns[20],
		 runAudio = columns[21],
		 endAudio = columns[22],
		 endbuffid = ConvertToNumber(configName, 'endbuffid', columns[23]),
		 type = ConvertToNumber(configName, 'type', columns[24]),
		 skillEquivalent = ConvertToNumber(configName, 'skillEquivalent', columns[25]),
		 bigIcon = columns[26],
		 smallIcon = columns[27],
		 dynamic = ConvertToNumber(configName, 'dynamic', columns[28]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
tracksegmentskill_config.Load()
----------以pb方式加载配置表---end




---@return table<number,tracksegmentskill_config_cell>
function tracksegmentskill_config.GetConfigData() return configData end
---@return tracksegmentskill_config_cell
function tracksegmentskill_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return tracksegmentskill_config
