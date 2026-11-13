



---@class act_sumcharge_config




act_sumcharge_config = {}
---@type table<number,act_sumcharge_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_sumcharge')), '')
local bytes = mono.LoadBytes('act_sumcharge')
local cfg = assert(Dll_PB.decode('act_sumcharge_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_sumcharge.txt'
function act_sumcharge_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 sumtype = ConvertToNumber(configName, 'sumtype', columns[2]),
		 CurrencyType = columns[3],
		 sumval = ConvertToNumber(configName, 'sumval', columns[4]),
		 propsids = columns[5],
		 propsnums = columns[6],
		 boxid = ConvertToNumber(configName, 'boxid', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_sumcharge_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_sumcharge_config_cell>
function act_sumcharge_config.GetConfigData() return configData end
---@return act_sumcharge_config_cell
function act_sumcharge_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,table<act_sumcharge_config_cell>>
local _sumTypeConfigData = {}
function act_sumcharge_config.AnalyseConfig()
	for i, v in pairs(configData) do
		if _sumTypeConfigData[v.sumtype]==nil then
			_sumTypeConfigData[v.sumtype]={}
		end
		table.insert(_sumTypeConfigData[v.sumtype], v)
	end
end
function act_sumcharge_config.GetConfigDataBySumType(sumType)
	return _sumTypeConfigData[sumType]
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
act_sumcharge_config.AnalyseConfig()
----%%%-------------%%%----








return act_sumcharge_config
