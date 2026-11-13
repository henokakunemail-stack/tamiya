



---@class miniskill_config




miniskill_config = {}
---@type table<number,miniskill_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/miniskill')), '')
local bytes = mono.LoadBytes('miniskill')
local cfg = assert(Dll_PB.decode('miniskill_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'miniskill.txt'
function miniskill_config.Load()
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
		 desc = columns[3],
		 quality = ConvertToNumber(configName, 'quality', columns[4]),
		 effectType = ConvertToNumber(configName, 'effectType', columns[5]),
		 triggerType = ConvertToNumber(configName, 'triggerType', columns[6]),
		 condition = columns[7],
		 distance = ConvertToNumber(configName, 'distance', columns[8]),
		 time = ConvertToNumber(configName, 'time', columns[9]),
		 parameter = columns[10],
		 triggerCD = ConvertToNumber(configName, 'triggerCD', columns[11]),
		 triggerCount = ConvertToNumber(configName, 'triggerCount', columns[12]),
		 maxStack = ConvertToNumber(configName, 'maxStack', columns[13]),
		 costtype = ConvertToNumber(configName, 'costtype', columns[14]),
		 costvalue = columns[15],
		 startFx = columns[16],
		 runFx = columns[17],
		 endFx = columns[18],
		 triggerStartFx = columns[19],
		 triggerRunFx = columns[20],
		 triggerEndFx = columns[21],
		 startAudio = columns[22],
		 runAudio = columns[23],
		 endAudio = columns[24],
		 endbuffid = ConvertToNumber(configName, 'endbuffid', columns[25]),
		 closeupDuration = ConvertToNumber(configName, 'closeupDuration', columns[26]),
		 runningAnimation = columns[27],
		 isProtectCrash = ConvertToNumber(configName, 'isProtectCrash', columns[28]),
		 ifCellEffect = ConvertToNumber(configName, 'ifCellEffect', columns[29]),
		 type = ConvertToNumber(configName, 'type', columns[30]),
		 skillEquivalent = ConvertToNumber(configName, 'skillEquivalent', columns[31]),
		 bigIcon = columns[32],
		 smallIcon = columns[33],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
miniskill_config.Load()
----------以pb方式加载配置表---end




---@return table<number,miniskill_config_cell>
function miniskill_config.GetConfigData() return configData end
---@return miniskill_config_cell
function miniskill_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return miniskill_config
