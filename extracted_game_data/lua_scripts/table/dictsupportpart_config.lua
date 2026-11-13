



---@class dictsupportpart_config




dictsupportpart_config = {}
---@type table<number,dictsupportpart_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictsupportpart')), '')
local bytes = mono.LoadBytes('dictsupportpart')
local cfg = assert(Dll_PB.decode('dictsupportpart_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictsupportpart.txt'
function dictsupportpart_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 partid = ConvertToNumber(configName, 'partid', columns[2]),
		 partage = ConvertToNumber(configName, 'partage', columns[3]),
		 initlev = ConvertToNumber(configName, 'initlev', columns[4]),
		 initstar = ConvertToNumber(configName, 'initstar', columns[5]),
		 breakflag = ConvertToNumber(configName, 'breakflag', columns[6]),
		 stickerid = ConvertToNumber(configName, 'stickerid', columns[7]),
		 colorid = ConvertToNumber(configName, 'colorid', columns[8]),
		 entryids = columns[9],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictsupportpart_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictsupportpart_config_cell>
function dictsupportpart_config.GetConfigData() return configData end
---@return dictsupportpart_config_cell
function dictsupportpart_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictsupportpart_config
