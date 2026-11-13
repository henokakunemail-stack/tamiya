



---@class dictfifaseason_config




dictfifaseason_config = {}
---@type table<number,dictfifaseason_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictfifaseason')), '')
local bytes = mono.LoadBytes('dictfifaseason')
local cfg = assert(Dll_PB.decode('dictfifaseason_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictfifaseason.txt'
function dictfifaseason_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 btime = ConvertToNumber(configName, 'btime', columns[2]),
		 championtime = ConvertToNumber(configName, 'championtime', columns[3]),
		 etime = ConvertToNumber(configName, 'etime', columns[4]),
		 paystr = columns[5],
		 champion = ConvertToNumber(configName, 'champion', columns[6]),
		 championodds = ConvertToNumber(configName, 'championodds', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictfifaseason_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictfifaseason_config_cell>
function dictfifaseason_config.GetConfigData() return configData end
---@return dictfifaseason_config_cell
function dictfifaseason_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictfifaseason_config
