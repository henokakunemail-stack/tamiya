



---@class dictexhibit_config




dictexhibit_config = {}
---@type table<number,dictexhibit_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictexhibit')), '')
local bytes = mono.LoadBytes('dictexhibit')
local cfg = assert(Dll_PB.decode('dictexhibit_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictexhibit.txt'
function dictexhibit_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 configName = columns[2],
		 childgroovegroup = columns[3],
		 type = ConvertToNumber(configName, 'type', columns[4]),
		 params = columns[5],
		 name = columns[6],
		 desc = columns[7],
		 icon = columns[8],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictexhibit_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictexhibit_config_cell>
function dictexhibit_config.GetConfigData() return configData end
---@return dictexhibit_config_cell
function dictexhibit_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictexhibit_config
