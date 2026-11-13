



---@class trackmaterial_config




trackmaterial_config = {}
---@type table<number,trackmaterial_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/trackmaterial')), '')
local bytes = mono.LoadBytes('trackmaterial')
local cfg = assert(Dll_PB.decode('trackmaterial_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'trackmaterial.txt'
function trackmaterial_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 fx = columns[2],
		 dFriction = ConvertToNumber(configName, 'dFriction', columns[3]),
		 staticFriction = ConvertToNumber(configName, 'staticFriction', columns[4]),
		 Restitution = ConvertToNumber(configName, 'Restitution', columns[5]),
		 flyGravity = ConvertToNumber(configName, 'flyGravity', columns[6]),
		 gravity = ConvertToNumber(configName, 'gravity', columns[7]),
		 buffID = ConvertToNumber(configName, 'buffID', columns[8]),
		 speed = ConvertToNumber(configName, 'speed', columns[9]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
trackmaterial_config.Load()
----------以pb方式加载配置表---end




---@return table<number,trackmaterial_config_cell>
function trackmaterial_config.GetConfigData() return configData end
---@return trackmaterial_config_cell
function trackmaterial_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return trackmaterial_config
