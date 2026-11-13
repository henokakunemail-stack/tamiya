



---@class dictquestion_config




dictquestion_config = {}
---@type table<number,dictquestion_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictquestion')), '')
local bytes = mono.LoadBytes('dictquestion')
local cfg = assert(Dll_PB.decode('dictquestion_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictquestion.txt'
function dictquestion_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 questioninx = ConvertToNumber(configName, 'questioninx', columns[2]),
		 questioncont = columns[3],
		 option1 = columns[4],
		 option2 = columns[5],
		 option3 = columns[6],
		 rightoption = ConvertToNumber(configName, 'rightoption', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictquestion_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictquestion_config_cell>
function dictquestion_config.GetConfigData() return configData end
---@return dictquestion_config_cell
function dictquestion_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictquestion_config
