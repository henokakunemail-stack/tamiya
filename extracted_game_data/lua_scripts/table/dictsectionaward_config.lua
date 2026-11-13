



---@class dictsectionaward_config




dictsectionaward_config = {}
---@type table<number,dictsectionaward_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictsectionaward')), '')
local bytes = mono.LoadBytes('dictsectionaward')
local cfg = assert(Dll_PB.decode('dictsectionaward_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictsectionaward.txt'
function dictsectionaward_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 awardno = ConvertToNumber(configName, 'awardno', columns[2]),
		 starsum = columns[3],
		 dropid = columns[4],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictsectionaward_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictsectionaward_config_cell>
function dictsectionaward_config.GetConfigData() return configData end
---@return dictsectionaward_config_cell
function dictsectionaward_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictsectionaward_config
