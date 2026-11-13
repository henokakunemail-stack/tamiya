



---@class dicttracktrack_config




dicttracktrack_config = {}
---@type table<number,dicttracktrack_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dicttracktrack')), '')
local bytes = mono.LoadBytes('dicttracktrack')
local cfg = assert(Dll_PB.decode('dicttracktrack_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dicttracktrack.txt'
function dicttracktrack_config.Load()
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
		 icon = columns[3],
		 type = columns[4],
		 tracksource = ConvertToNumber(configName, 'tracksource', columns[5]),
		 tracknum = columns[6],
		 round = ConvertToNumber(configName, 'round', columns[7]),
		 configName = columns[8],
		 resname = columns[9],
		 scope = ConvertToNumber(configName, 'scope', columns[10]),
		 start_camera = columns[11],
		 end_camera = columns[12],
		 length = ConvertToNumber(configName, 'length', columns[13]),
		 logo = columns[14],
		 roomscope = ConvertToNumber(configName, 'roomscope', columns[15]),
		 isfield = ConvertToNumber(configName, 'isfield', columns[16]),
		 qidongjiaConfigName = columns[17],
		 qidongjiaRes = columns[18],
		 bufftype = columns[19],
		 bufftrack = columns[20],
		 cameraDefaultPosition = columns[21],
		 cameraDefaultRotation = columns[22],
		 cameraDefaultLength = ConvertToNumber(configName, 'cameraDefaultLength', columns[23]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dicttracktrack_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dicttracktrack_config_cell>
function dicttracktrack_config.GetConfigData() return configData end
---@return dicttracktrack_config_cell
function dicttracktrack_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dicttracktrack_config
