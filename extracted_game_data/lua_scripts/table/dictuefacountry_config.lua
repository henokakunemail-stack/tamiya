



---@class dictuefacountry_config




dictuefacountry_config = {}
---@type table<number,dictuefacountry_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictuefacountry')), '')
local bytes = mono.LoadBytes('dictuefacountry')
local cfg = assert(Dll_PB.decode('dictuefacountry_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictuefacountry.txt'
function dictuefacountry_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 season_id = ConvertToNumber(configName, 'season_id', columns[2]),
		 name = columns[3],
		 icon = columns[4],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictuefacountry_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictuefacountry_config_cell>
function dictuefacountry_config.GetConfigData() return configData end
---@return dictuefacountry_config_cell
function dictuefacountry_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewConfigData={}
function dictuefacountry_config.AnalyzeCfg(id)
	for k, v in pairs(configData) do
		if __NewConfigData[v.season_id]==nil then
			__NewConfigData[v.season_id]={}
		end
		table.insert(__NewConfigData[v.season_id],v)
	end
end
function dictuefacountry_config.GetCountryBySeason(id)
 	local result={}
	if __NewConfigData[id] then
		result=__NewConfigData[id]
	end
	return result
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictuefacountry_config.AnalyzeCfg()
----%%%-------------%%%----








return dictuefacountry_config
