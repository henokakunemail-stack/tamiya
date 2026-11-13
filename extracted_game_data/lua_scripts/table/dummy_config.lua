



---@class dummy_config




dummy_config = {}
---@type table<number,dummy_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dummy')), '')
local bytes = mono.LoadBytes('dummy')
local cfg = assert(Dll_PB.decode('dummy_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dummy.txt'
function dummy_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 resname = columns[2],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dummy_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dummy_config_cell>
function dummy_config.GetConfigData() return configData end
---@return dummy_config_cell
function dummy_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function dummy_config.IsDummy(resname)
	for k,v in pairs(configData) do
		if v.resname == resname then
			return true
		end
	end
	return false
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dummy_config
