



---@class act_timetoken_lev_config




act_timetoken_lev_config = {}
---@type table<number,act_timetoken_lev_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_timetoken_lev')), '')
local bytes = mono.LoadBytes('act_timetoken_lev')
local cfg = assert(Dll_PB.decode('act_timetoken_lev_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_timetoken_lev.txt'
function act_timetoken_lev_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 tokenid = ConvertToNumber(configName, 'tokenid', columns[2]),
		 lev = ConvertToNumber(configName, 'lev', columns[3]),
		 nextexp = ConvertToNumber(configName, 'nextexp', columns[4]),
		 awardids = columns[5],
		 awardnums = columns[6],
		 hawardids = columns[7],
		 hawardnums = columns[8],
		 ispreviewbonus = ConvertToNumber(configName, 'ispreviewbonus', columns[9]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_timetoken_lev_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_timetoken_lev_config_cell>
function act_timetoken_lev_config.GetConfigData() return configData end
---@return act_timetoken_lev_config_cell
function act_timetoken_lev_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return act_timetoken_lev_config
