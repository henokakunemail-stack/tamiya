



---@class dictactive_config




dictactive_config = {}
---@type table<number,dictactive_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictactive')), '')
local bytes = mono.LoadBytes('dictactive')
local cfg = assert(Dll_PB.decode('dictactive_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictactive.txt'
function dictactive_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 activeType = ConvertToNumber(configName, 'activeType', columns[2]),
		 activeval = ConvertToNumber(configName, 'activeval', columns[3]),
		 awardids = columns[4],
		 awardnums = columns[5],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictactive_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictactive_config_cell>
function dictactive_config.GetConfigData() return configData end
---@return dictactive_config_cell
function dictactive_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local _NewConfigData={}
function dictactive_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if _NewConfigData[v.activeType]==nil then
			_NewConfigData[v.activeType]={}
		end
		_NewConfigData[v.activeType][v.activeval]=v
	end
end
function dictactive_config.GetDataByTypeAndValue(type,value)
    return _NewConfigData[type][value]
end

function dictactive_config.GetConfigDataByType(_type)
	return _NewConfigData[_type]
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictactive_config.AnalyseConfig()
----%%%-------------%%%----








return dictactive_config
