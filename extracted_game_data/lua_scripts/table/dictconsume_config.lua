



---@class dictconsume_config




dictconsume_config = {}
---@type table<number,dictconsume_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictconsume')), '')
local bytes = mono.LoadBytes('dictconsume')
local cfg = assert(Dll_PB.decode('dictconsume_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictconsume.txt'
function dictconsume_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 consumeid = ConvertToNumber(configName, 'consumeid', columns[2]),
		 propsid = ConvertToNumber(configName, 'propsid', columns[3]),
		 propsnum = ConvertToNumber(configName, 'propsnum', columns[4]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictconsume_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictconsume_config_cell>
function dictconsume_config.GetConfigData() return configData end
---@return dictconsume_config_cell
function dictconsume_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewConfigData = {}
function dictconsume_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if __NewConfigData[v.consumeid]==nil then  __NewConfigData[v.consumeid]={} end
		table.insert(__NewConfigData[v.consumeid],v)
	end
end
function dictconsume_config.GetCfgDataByDropId(dropId)
	local result =nil
	if __NewConfigData[dropId] then
		result=__NewConfigData[dropId]
	end
	return result
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictconsume_config.AnalyseConfig()
----%%%-------------%%%----








return dictconsume_config
