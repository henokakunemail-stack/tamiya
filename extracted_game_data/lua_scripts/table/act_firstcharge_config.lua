



---@class act_firstcharge_config




act_firstcharge_config = {}
---@type table<number,act_firstcharge_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_firstcharge')), '')
local bytes = mono.LoadBytes('act_firstcharge')
local cfg = assert(Dll_PB.decode('act_firstcharge_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_firstcharge.txt'
function act_firstcharge_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 chargetype = ConvertToNumber(configName, 'chargetype', columns[2]),
		 dayno = ConvertToNumber(configName, 'dayno', columns[3]),
		 awardids = columns[4],
		 awardnums = columns[5],
		 dayname = columns[6],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_firstcharge_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_firstcharge_config_cell>
function act_firstcharge_config.GetConfigData() return configData end
---@return act_firstcharge_config_cell
function act_firstcharge_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return act_firstcharge_config
