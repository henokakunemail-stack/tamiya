



---@class playerexchange_config




playerexchange_config = {}
---@type table<number,playerexchange_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/playerexchange')), '')
local bytes = mono.LoadBytes('playerexchange')
local cfg = assert(Dll_PB.decode('playerexchange_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'playerexchange.txt'
function playerexchange_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = columns[1],
		 batno = ConvertToNumber(configName, 'batno', columns[2]),
		 exptime = ConvertToNumber(configName, 'exptime', columns[3]),
		 packid = ConvertToNumber(configName, 'packid', columns[4]),
		 exchrid = ConvertToNumber(configName, 'exchrid', columns[5]),
		 exchtime = ConvertToNumber(configName, 'exchtime', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
playerexchange_config.Load()
----------以pb方式加载配置表---end




---@return table<number,playerexchange_config_cell>
function playerexchange_config.GetConfigData() return configData end
---@return playerexchange_config_cell
function playerexchange_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return playerexchange_config
