



---@class dictseason_config




dictseason_config = {}
---@type table<number,dictseason_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictseason')), '')
local bytes = mono.LoadBytes('dictseason')
local cfg = assert(Dll_PB.decode('dictseason_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictseason.txt'
function dictseason_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 serverid = ConvertToNumber(configName, 'serverid', columns[2]),
		 seasonid = ConvertToNumber(configName, 'seasonid', columns[3]),
		 bday = ConvertToNumber(configName, 'bday', columns[4]),
		 start1 = columns[5],
		 eday = ConvertToNumber(configName, 'eday', columns[6]),
		 start2 = columns[7],
		 bday2 = ConvertToNumber(configName, 'bday2', columns[8]),
		 result1 = columns[9],
		 eday2 = ConvertToNumber(configName, 'eday2', columns[10]),
		 result2 = columns[11],
		 nextseasonid = ConvertToNumber(configName, 'nextseasonid', columns[12]),
		 groupnum = ConvertToNumber(configName, 'groupnum', columns[13]),
		 sceneid = ConvertToNumber(configName, 'sceneid', columns[14]),
		 trackid = ConvertToNumber(configName, 'trackid', columns[15]),
		 showflag = ConvertToNumber(configName, 'showflag', columns[16]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictseason_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictseason_config_cell>
function dictseason_config.GetConfigData() return configData end
---@return dictseason_config_cell
function dictseason_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewConfigData = {}
function dictseason_config.AnalyseConfig(id)
	for k, v in pairs(configData) do
		if __NewConfigData[v.serverid]==nil then
			__NewConfigData[v.serverid]={}
		end
		__NewConfigData[v.serverid][v.seasonid]=v
	end
end
function dictseason_config.GetDataBuyServerIdAndId(serverid,id)
	local result=nil
	if __NewConfigData[serverid] then
		if __NewConfigData[serverid][id] then
			result=__NewConfigData[serverid][id]
		end
	end
	if result==nil then
		result=__NewConfigData[0][id]
	end
	return result
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictseason_config.AnalyseConfig()
----%%%-------------%%%----








return dictseason_config
