



---@class dictbearcard_config




dictbearcard_config = {}
---@type table<number,dictbearcard_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictbearcard')), '')
local bytes = mono.LoadBytes('dictbearcard')
local cfg = assert(Dll_PB.decode('dictbearcard_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictbearcard.txt'
function dictbearcard_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 cardtype = ConvertToNumber(configName, 'cardtype', columns[2]),
		 cardlevel = ConvertToNumber(configName, 'cardlevel', columns[3]),
		 cardlvmax = ConvertToNumber(configName, 'cardlvmax', columns[4]),
		 expropid = ConvertToNumber(configName, 'expropid', columns[5]),
		 expropnum = ConvertToNumber(configName, 'expropnum', columns[6]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictbearcard_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictbearcard_config_cell>
function dictbearcard_config.GetConfigData() return configData end
---@return dictbearcard_config_cell
function dictbearcard_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictbearcard_config
