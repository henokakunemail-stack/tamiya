



---@class freeskill_config




freeskill_config = {}
---@type table<number,freeskill_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/freeskill')), '')
local bytes = mono.LoadBytes('freeskill')
local cfg = assert(Dll_PB.decode('freeskill_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'freeskill.txt'
function freeskill_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 skillidtype = ConvertToNumber(configName, 'skillidtype', columns[2]),
		 name = columns[3],
		 des = columns[4],
		 icon = columns[5],
		 cardicon = columns[6],
		 heroId = ConvertToNumber(configName, 'heroId', columns[7]),
		 cardAimnTime = ConvertToNumber(configName, 'cardAimnTime', columns[8]),
		 skill_show_ui = columns[9],
		 showinmatch = ConvertToNumber(configName, 'showinmatch', columns[10]),
		 cooldown = ConvertToNumber(configName, 'cooldown', columns[11]),
		 addspeedlevel = ConvertToNumber(configName, 'addspeedlevel', columns[12]),
		 torqueaddpercent = ConvertToNumber(configName, 'torqueaddpercent', columns[13]),
		 torqueaddvalue = ConvertToNumber(configName, 'torqueaddvalue', columns[14]),
		 frictionaddpercent = ConvertToNumber(configName, 'frictionaddpercent', columns[15]),
		 frictionaddvalue = ConvertToNumber(configName, 'frictionaddvalue', columns[16]),
		 rpmaddpercent = ConvertToNumber(configName, 'rpmaddpercent', columns[17]),
		 rpmaddvalue = ConvertToNumber(configName, 'rpmaddvalue', columns[18]),
		 stableaddpercent = ConvertToNumber(configName, 'stableaddpercent', columns[19]),
		 stableaddvalue = ConvertToNumber(configName, 'stableaddvalue', columns[20]),
		 configtype = ConvertToNumber(configName, 'configtype', columns[21]),
		 startfx = columns[22],
		 triggerfx = columns[23],
		 lastfx = columns[24],
		 lasttime = ConvertToNumber(configName, 'lasttime', columns[25]),
		 endfx = columns[26],
		 dirfttype = ConvertToNumber(configName, 'dirfttype', columns[27]),
		 audiofx = columns[28],
		 cameragroup = ConvertToNumber(configName, 'cameragroup', columns[29]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
freeskill_config.Load()
----------以pb方式加载配置表---end




---@return table<number,freeskill_config_cell>
function freeskill_config.GetConfigData() return configData end
---@return freeskill_config_cell
function freeskill_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return freeskill_config
