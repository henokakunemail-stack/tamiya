



---@class dictpartstar_config




dictpartstar_config = {}
---@type table<number,dictpartstar_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictpartstar')), '')
local bytes = mono.LoadBytes('dictpartstar')
local cfg = assert(Dll_PB.decode('dictpartstar_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictpartstar.txt'
function dictpartstar_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 basepartid = ConvertToNumber(configName, 'basepartid', columns[2]),
		 star = ConvertToNumber(configName, 'star', columns[3]),
		 specialid = ConvertToNumber(configName, 'specialid', columns[4]),
		 paynum = ConvertToNumber(configName, 'paynum', columns[5]),
		 commonid = ConvertToNumber(configName, 'commonid', columns[6]),
		 commonnum = ConvertToNumber(configName, 'commonnum', columns[7]),
		 goldpay = ConvertToNumber(configName, 'goldpay', columns[8]),
		 entrynum = ConvertToNumber(configName, 'entrynum', columns[9]),
		 entries = columns[10],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictpartstar_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictpartstar_config_cell>
function dictpartstar_config.GetConfigData() return configData end
---@return dictpartstar_config_cell
function dictpartstar_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewConfigData = {}
function dictpartstar_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if __NewConfigData[v.basepartid]==nil then  __NewConfigData[v.basepartid]={} end
		__NewConfigData[v.basepartid][v.star]=v
	end
end
function dictpartstar_config.GetCfgDataByIdAndStar(partId,star)
	local result =nil
	if __NewConfigData[partId] then
		result=__NewConfigData[partId][star]
	end
	return result
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictpartstar_config.AnalyseConfig()
----%%%-------------%%%----








return dictpartstar_config
