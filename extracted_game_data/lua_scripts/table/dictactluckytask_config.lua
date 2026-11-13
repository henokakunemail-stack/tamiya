



---@class dictactluckytask_config




dictactluckytask_config = {}
---@type table<number,dictactluckytask_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictactluckytask')), '')
local bytes = mono.LoadBytes('dictactluckytask')
local cfg = assert(Dll_PB.decode('dictactluckytask_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictactluckytask.txt'
function dictactluckytask_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 actid = ConvertToNumber(configName, 'actid', columns[2]),
		 actval = ConvertToNumber(configName, 'actval', columns[3]),
		 propsid = ConvertToNumber(configName, 'propsid', columns[4]),
		 propnum = ConvertToNumber(configName, 'propnum', columns[5]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictactluckytask_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictactluckytask_config_cell>
function dictactluckytask_config.GetConfigData() return configData end
---@return dictactluckytask_config_cell
function dictactluckytask_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local newConfigData={}
function dictactluckytask_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if newConfigData[v.actid]==nil then
			newConfigData[v.actid]={}
		end
		newConfigData[v.actid][v.actval]=v
	end
end
function dictactluckytask_config.GetDataByActIdAndValue(actId,value)
	if newConfigData[actId] then
		return newConfigData[actId][value]
	end
	return nil
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictactluckytask_config.AnalyseConfig()
----%%%-------------%%%----








return dictactluckytask_config
