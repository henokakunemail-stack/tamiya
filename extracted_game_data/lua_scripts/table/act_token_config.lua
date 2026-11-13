



---@class act_token_config




act_token_config = {}
---@type table<number,act_token_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_token')), '')
local bytes = mono.LoadBytes('act_token')
local cfg = assert(Dll_PB.decode('act_token_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_token.txt'
function act_token_config.Load()
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
		 tokenid = ConvertToNumber(configName, 'tokenid', columns[3]),
		 timeflag = ConvertToNumber(configName, 'timeflag', columns[4]),
		 begintime = ConvertToNumber(configName, 'begintime', columns[5]),
		 endtime = ConvertToNumber(configName, 'endtime', columns[6]),
		 chargeid = ConvertToNumber(configName, 'chargeid', columns[7]),
		 bday = ConvertToNumber(configName, 'bday', columns[8]),
		 eday = ConvertToNumber(configName, 'eday', columns[9]),
		 btime = columns[10],
		 etime = columns[11],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_token_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_token_config_cell>
function act_token_config.GetConfigData() return configData end
---@return act_token_config_cell
function act_token_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewConfigData = {}
function act_token_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if __NewConfigData[v.serverid]==nil then
			__NewConfigData[v.serverid]={}
		end
		__NewConfigData[v.serverid][v.tokenid]=v
	end
end
function act_token_config.GetDataBuyServerIdAndId(serverid,id)
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
act_token_config.AnalyseConfig()
----%%%-------------%%%----








return act_token_config
