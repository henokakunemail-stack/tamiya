



---@class skill_config




skill_config = {}
---@type table<number,skill_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/skill')), '')
local bytes = mono.LoadBytes('skill')
local cfg = assert(Dll_PB.decode('skill_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'skill.txt'
function skill_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 id = ConvertToNumber(configName, 'id', columns[1]),
		 skillidtype = ConvertToNumber(configName, 'skillidtype', columns[2]),
		 name = columns[3],
		 des = columns[4],
		 icon = columns[5],
		 skill_show_ui = columns[6],
		 showinmatch = ConvertToNumber(configName, 'showinmatch', columns[7]),
		 cooldown = ConvertToNumber(configName, 'cooldown', columns[8]),
		 addspeedlevel = ConvertToNumber(configName, 'addspeedlevel', columns[9]),
		 torqueaddpercent = ConvertToNumber(configName, 'torqueaddpercent', columns[10]),
		 torqueaddvalue = ConvertToNumber(configName, 'torqueaddvalue', columns[11]),
		 frictionaddpercent = ConvertToNumber(configName, 'frictionaddpercent', columns[12]),
		 frictionaddvalue = ConvertToNumber(configName, 'frictionaddvalue', columns[13]),
		 rpmaddpercent = ConvertToNumber(configName, 'rpmaddpercent', columns[14]),
		 rpmaddvalue = ConvertToNumber(configName, 'rpmaddvalue', columns[15]),
		 stableaddpercent = ConvertToNumber(configName, 'stableaddpercent', columns[16]),
		 stableaddvalue = ConvertToNumber(configName, 'stableaddvalue', columns[17]),
		 configtype = ConvertToNumber(configName, 'configtype', columns[18]),
		 startfx = columns[19],
		 triggerfx = columns[20],
		 lastfx = columns[21],
		 lasttime = ConvertToNumber(configName, 'lasttime', columns[22]),
		 endfx = columns[23],
		 dirfttype = ConvertToNumber(configName, 'dirfttype', columns[24]),
		 audiofx = columns[25],
		 cameragroup = ConvertToNumber(configName, 'cameragroup', columns[26]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
skill_config.Load()
----------以pb方式加载配置表---end




---@return table<number,skill_config_cell>
function skill_config.GetConfigData() return configData end
---@return skill_config_cell
function skill_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return skill_config
