



---@class act_activity_config




act_activity_config = {}
---@type table<number,act_activity_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_activity')), '')
local bytes = mono.LoadBytes('act_activity')
local cfg = assert(Dll_PB.decode('act_activity_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_activity.txt'
function act_activity_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 sort = ConvertToNumber(configName, 'sort', columns[2]),
		 gifttype = columns[3],
		 tab = columns[4],
		 giftid = columns[5],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_activity_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_activity_config_cell>
function act_activity_config.GetConfigData() return configData end
---@return act_activity_config_cell
function act_activity_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local _newConfigData = {}
function act_activity_config.AnalyseConfig()
    for i, v in pairs(configData) do
        table.insert(_newConfigData, v)
    end
    table.sort(_newConfigData, function(a, b)
        return a.sort > b.sort
    end)
end
function act_activity_config.GetNewConfig()
	return _newConfigData
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
act_activity_config.AnalyseConfig()
----%%%-------------%%%----








return act_activity_config
