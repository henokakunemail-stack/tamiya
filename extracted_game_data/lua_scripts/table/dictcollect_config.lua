



---@class dictcollect_config




dictcollect_config = {}
---@type table<number,dictcollect_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictcollect')), '')
local bytes = mono.LoadBytes('dictcollect')
local cfg = assert(Dll_PB.decode('dictcollect_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictcollect.txt'
function dictcollect_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 collectval = ConvertToNumber(configName, 'collectval', columns[2]),
		 icon = columns[3],
		 portraiticon = columns[4],
		 portraitname = columns[5],
		 portraitdetail = columns[6],
		 order = ConvertToNumber(configName, 'order', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictcollect_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictcollect_config_cell>
function dictcollect_config.GetConfigData() return configData end
---@return dictcollect_config_cell
function dictcollect_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictcollect_config
