



---@class dicttracksegmenttype_config




dicttracksegmenttype_config = {}
---@type table<number,dicttracksegmenttype_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dicttracksegmenttype')), '')
local bytes = mono.LoadBytes('dicttracksegmenttype')
local cfg = assert(Dll_PB.decode('dicttracksegmenttype_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dicttracksegmenttype.txt'
function dicttracksegmenttype_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 name = columns[2],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dicttracksegmenttype_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dicttracksegmenttype_config_cell>
function dicttracksegmenttype_config.GetConfigData() return configData end
---@return dicttracksegmenttype_config_cell
function dicttracksegmenttype_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dicttracksegmenttype_config
