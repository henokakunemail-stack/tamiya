



---@class dicttempletstringportrait_config




dicttempletstringportrait_config = {}
---@type table<number,dicttempletstringportrait_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dicttempletstringportrait')), '')
local bytes = mono.LoadBytes('dicttempletstringportrait')
local cfg = assert(Dll_PB.decode('dicttempletstringportrait_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dicttempletstringportrait.txt'
function dicttempletstringportrait_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = columns[1],
		 chs = columns[2],
		 cht = columns[3],
		 en = columns[4],
		 tai = columns[5],
		 ind = columns[6],
		 pt_BR = columns[7],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dicttempletstringportrait_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dicttempletstringportrait_config_cell>
function dicttempletstringportrait_config.GetConfigData() return configData end
---@return dicttempletstringportrait_config_cell
function dicttempletstringportrait_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dicttempletstringportrait_config
