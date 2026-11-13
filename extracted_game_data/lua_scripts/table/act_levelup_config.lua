



---@class act_levelup_config




act_levelup_config = {}
---@type table<number,act_levelup_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_levelup')), '')
local bytes = mono.LoadBytes('act_levelup')
local cfg = assert(Dll_PB.decode('act_levelup_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_levelup.txt'
function act_levelup_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 itemid = ConvertToNumber(configName, 'itemid', columns[2]),
		 lev = ConvertToNumber(configName, 'lev', columns[3]),
		 awardids = columns[4],
		 awardnums = columns[5],
		 hawardids = columns[6],
		 hawardnums = columns[7],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_levelup_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_levelup_config_cell>
function act_levelup_config.GetConfigData() return configData end
---@return act_levelup_config_cell
function act_levelup_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return act_levelup_config
