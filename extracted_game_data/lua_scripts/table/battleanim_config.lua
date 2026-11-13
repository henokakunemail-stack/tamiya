



---@class battleanim_config




battleanim_config = {}
---@type table<number,battleanim_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/battleanim')), '')
local bytes = mono.LoadBytes('battleanim')
local cfg = assert(Dll_PB.decode('battleanim_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'battleanim.txt'
function battleanim_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 type = ConvertToNumber(configName, 'type', columns[2]),
		 name = columns[3],
		 cameratime = ConvertToNumber(configName, 'cameratime', columns[4]),
		 time = ConvertToNumber(configName, 'time', columns[5]),
		 clicknum = ConvertToNumber(configName, 'clicknum', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
battleanim_config.Load()
----------以pb方式加载配置表---end




---@return table<number,battleanim_config_cell>
function battleanim_config.GetConfigData() return configData end
---@return battleanim_config_cell
function battleanim_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return battleanim_config
