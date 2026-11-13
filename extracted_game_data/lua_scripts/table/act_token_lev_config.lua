



---@class act_token_lev_config




act_token_lev_config = {}
---@type table<number,act_token_lev_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_token_lev')), '')
local bytes = mono.LoadBytes('act_token_lev')
local cfg = assert(Dll_PB.decode('act_token_lev_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_token_lev.txt'
function act_token_lev_config.Load()
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
		 id = ConvertToNumber(configName, 'id', columns[3]),
		 tokenid = ConvertToNumber(configName, 'tokenid', columns[4]),
		 lev = ConvertToNumber(configName, 'lev', columns[5]),
		 nextexp = ConvertToNumber(configName, 'nextexp', columns[6]),
		 awardids = columns[7],
		 awardnums = columns[8],
		 hawardids = columns[9],
		 hawardnums = columns[10],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_token_lev_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_token_lev_config_cell>
function act_token_lev_config.GetConfigData() return configData end
---@return act_token_lev_config_cell
function act_token_lev_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local _newConfigData = {}
function act_token_lev_config.AnalyseConfig()
	for i, v in pairs(configData) do
		if _newConfigData[v.serverid]==nil  then
			_newConfigData[v.serverid]={}
		end
		if _newConfigData[v.serverid][v.tokenid]==nil  then
			_newConfigData[v.serverid][v.tokenid]={}
		end
        table.insert(_newConfigData[v.serverid][v.tokenid],v)
	end
	for k, v in pairs(_newConfigData) do
		for i,j in pairs(_newConfigData[k]) do
			table.sort(_newConfigData[k][i],function(a, b)
				return a.lev<b.lev
			end)
		end
	end
end
function act_token_lev_config.GetDataByAndLevel(serverid,token,lv)
	local tokenCfg=_newConfigData[serverid]
	if tokenCfg==nil then
		tokenCfg=_newConfigData[0]
	end
	if tokenCfg[token] then
		return tokenCfg[token][lv]
	end
end
function act_token_lev_config.GetTokenData(serverid,token)
	local tokenCfg=_newConfigData[serverid]
	if tokenCfg==nil then
		tokenCfg=_newConfigData[0]
	end
	return tokenCfg[token]
end
function act_token_lev_config.GetNewConfig()
	return _newConfigData
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
act_token_lev_config.AnalyseConfig()
----%%%-------------%%%----








return act_token_lev_config
