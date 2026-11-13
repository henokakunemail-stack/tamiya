



---@class act_period_config




act_period_config = {}
---@type table<number,act_period_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_period')), '')
local bytes = mono.LoadBytes('act_period')
local cfg = assert(Dll_PB.decode('act_period_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_period.txt'
function act_period_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 awardids = columns[2],
		 awardnums = columns[3],
		 rightids = columns[4],
		 addday = ConvertToNumber(configName, 'addday', columns[5]),
		 weekBg = columns[6],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_period_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_period_config_cell>
function act_period_config.GetConfigData() return configData end
---@return act_period_config_cell
function act_period_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return act_period_config
