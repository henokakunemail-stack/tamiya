



---@class dictspecial_config




dictspecial_config = {}
---@type table<number,dictspecial_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictspecial')), '')
local bytes = mono.LoadBytes('dictspecial')
local cfg = assert(Dll_PB.decode('dictspecial_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictspecial.txt'
function dictspecial_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 consumeids = columns[2],
		 consumenums = columns[3],
		 composegold = ConvertToNumber(configName, 'composegold', columns[4]),
		 consumeparts = columns[5],
		 breakrand = ConvertToNumber(configName, 'breakrand', columns[6]),
		 unlockpic = ConvertToNumber(configName, 'unlockpic', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictspecial_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictspecial_config_cell>
function dictspecial_config.GetConfigData() return configData end
---@return dictspecial_config_cell
function dictspecial_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictspecial_config
