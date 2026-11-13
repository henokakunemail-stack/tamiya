



---@class camera_config




camera_config = {}
---@type table<number,camera_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/camera')), '')
local bytes = mono.LoadBytes('camera')
local cfg = assert(Dll_PB.decode('camera_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'camera.txt'
function camera_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 scene_camera = columns[2],
		 scene_camera_time = columns[3],
		 battle_camera_mode = ConvertToNumber(configName, 'battle_camera_mode', columns[4]),
		 start_camera = columns[5],
		 end_camera = columns[6],
		 cameraId = columns[7],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
camera_config.Load()
----------以pb方式加载配置表---end




---@return table<number,camera_config_cell>
function camera_config.GetConfigData() return configData end
---@return camera_config_cell
function camera_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return camera_config
