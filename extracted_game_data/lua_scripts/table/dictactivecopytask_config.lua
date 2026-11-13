



---@class dictactivecopytask_config




dictactivecopytask_config = {}
---@type table<number,dictactivecopytask_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictactivecopytask')), '')
local bytes = mono.LoadBytes('dictactivecopytask')
local cfg = assert(Dll_PB.decode('dictactivecopytask_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictactivecopytask.txt'
function dictactivecopytask_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 copyid = ConvertToNumber(configName, 'copyid', columns[2]),
		 starid = ConvertToNumber(configName, 'starid', columns[3]),
		 cond = columns[4],
		 succval = columns[5],
		 goodsids = columns[6],
		 goodsnums = columns[7],
		 sumpoint = ConvertToNumber(configName, 'sumpoint', columns[8]),
		 difficultylevel = ConvertToNumber(configName, 'difficultylevel', columns[9]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictactivecopytask_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictactivecopytask_config_cell>
function dictactivecopytask_config.GetConfigData() return configData end
---@return dictactivecopytask_config_cell
function dictactivecopytask_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local _NewConfigData={}
function dictactivecopytask_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if _NewConfigData[v.copyid]==nil then
			_NewConfigData[v.copyid]={}
		end
		table.insert(_NewConfigData[v.copyid],v)
	end
	for k, v in pairs(_NewConfigData) do
		table.sort(_NewConfigData,function(a, b)
			return a.starid<b.starid
		end)
	end
end
function dictactivecopytask_config.GetTaskListByCopyId(copyid)
	return  _NewConfigData[copyid]
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictactivecopytask_config.AnalyseConfig()
----%%%-------------%%%----








return dictactivecopytask_config
