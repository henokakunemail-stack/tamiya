



---@class startbattle_config




startbattle_config = {}
---@type table<number,startbattle_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/startbattle')), '')
local bytes = mono.LoadBytes('startbattle')
local cfg = assert(Dll_PB.decode('startbattle_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'startbattle.txt'
function startbattle_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 sceneId = ConvertToNumber(configName, 'sceneId', columns[2]),
		 trackId = ConvertToNumber(configName, 'trackId', columns[3]),
		 round = ConvertToNumber(configName, 'round', columns[4]),
		 npcs = columns[5],
		 track = columns[6],
		 view = columns[7],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
startbattle_config.Load()
----------以pb方式加载配置表---end




---@return table<number,startbattle_config_cell>
function startbattle_config.GetConfigData() return configData end
---@return startbattle_config_cell
function startbattle_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return startbattle_config
