



---@class hero_config




hero_config = {}
---@type table<number,hero_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/hero')), '')
local bytes = mono.LoadBytes('hero')
local cfg = assert(Dll_PB.decode('hero_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'hero.txt'
function hero_config.Load()
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
		 quality = ConvertToNumber(configName, 'quality', columns[3]),
		 normalpicture = ConvertToNumber(configName, 'normalpicture', columns[4]),
		 smallpicture = ConvertToNumber(configName, 'smallpicture', columns[5]),
		 confusepicture = ConvertToNumber(configName, 'confusepicture', columns[6]),
		 angrypicture = ConvertToNumber(configName, 'angrypicture', columns[7]),
		 shockpicture = ConvertToNumber(configName, 'shockpicture', columns[8]),
		 icon = columns[9],
		 heroSkillPic = columns[10],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
hero_config.Load()
----------以pb方式加载配置表---end




---@return table<number,hero_config_cell>
function hero_config.GetConfigData() return configData end
---@return hero_config_cell
function hero_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function hero_config.AnalyseConfig()
	for k, v in pairs(configData) do
		configData[k].NewIcon = v.icon
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
hero_config.AnalyseConfig()
----%%%-------------%%%----








return hero_config
