



---@class scene_config




scene_config = {}
---@type table<number,scene_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/scene')), '')
local bytes = mono.LoadBytes('scene')
local cfg = assert(Dll_PB.decode('scene_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'scene.txt'
function scene_config.Load()
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
		 resName = columns[3],
		 icon = columns[4],
		 cupcamera = columns[5],
		 camera = columns[6],
		 isfield = ConvertToNumber(configName, 'isfield', columns[7]),
		 isroomtrack = ConvertToNumber(configName, 'isroomtrack', columns[8]),
		 weather = ConvertToNumber(configName, 'weather', columns[9]),
		 bgm = ConvertToNumber(configName, 'bgm', columns[10]),
		 scenebgm = ConvertToNumber(configName, 'scenebgm', columns[11]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
scene_config.Load()
----------以pb方式加载配置表---end




---@return table<number,scene_config_cell>
function scene_config.GetConfigData() return configData end
---@return scene_config_cell
function scene_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return scene_config
