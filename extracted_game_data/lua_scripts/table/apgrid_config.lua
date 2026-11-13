



---@class apgrid_config




apgrid_config = {}
---@type table<number,apgrid_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/apgrid')), '')
local bytes = mono.LoadBytes('apgrid')
local cfg = assert(Dll_PB.decode('apgrid_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'apgrid.txt'
function apgrid_config.Load()
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
		 des = columns[3],
		 icon = columns[4],
		 mat = columns[5],
		 resid = ConvertToNumber(configName, 'resid', columns[6]),
		 quality = ConvertToNumber(configName, 'quality', columns[7]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
apgrid_config.Load()
----------以pb方式加载配置表---end




---@return table<number,apgrid_config_cell>
function apgrid_config.GetConfigData() return configData end
---@return apgrid_config_cell
function apgrid_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,apgrid_config_cell>
local __NewConfigData = {}
function apgrid_config.AnalyseConfig()
	__NewConfigData = {}
	for k, v in pairs(configData) do
		configData[k].NewMat = v.mat..".mat"
		table.insert(__NewConfigData, v)
	end
end
function apgrid_config.GetList()
	return __NewConfigData
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
apgrid_config.AnalyseConfig()
----%%%-------------%%%----








return apgrid_config
