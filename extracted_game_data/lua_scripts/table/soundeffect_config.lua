



---@class soundeffect_config




soundeffect_config = {}
---@type table<number,soundeffect_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/soundeffect')), '')
local bytes = mono.LoadBytes('soundeffect')
local cfg = assert(Dll_PB.decode('soundeffect_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'soundeffect.txt'
function soundeffect_config.Load()
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
		 name_kr = columns[4],
		 volume = ConvertToNumber(configName, 'volume', columns[5]),
		 mixtype = ConvertToNumber(configName, 'mixtype', columns[6]),
		 cvwordid = columns[7],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
soundeffect_config.Load()
----------以pb方式加载配置表---end




---@return table<number,soundeffect_config_cell>
function soundeffect_config.GetConfigData() return configData end
---@return soundeffect_config_cell
function soundeffect_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local configTypeData = {}
function soundeffect_config.Load2()
	for i, v in pairs(configData) do

		if configTypeData[v.type] == nil then
			configTypeData[v.type] = {}
		end

		table.insert(configTypeData[v.type], v)
	end
end

function soundeffect_config.GetByType(type)
	if configTypeData[type] == nil then
		return nil
	end
	return configTypeData[type]
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
soundeffect_config.Load2()
----%%%-------------%%%----








return soundeffect_config
