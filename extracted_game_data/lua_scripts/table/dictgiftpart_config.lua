



---@class dictgiftpart_config




dictgiftpart_config = {}
---@type table<number,dictgiftpart_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictgiftpart')), '')
local bytes = mono.LoadBytes('dictgiftpart')
local cfg = assert(Dll_PB.decode('dictgiftpart_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictgiftpart.txt'
function dictgiftpart_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 itemid = ConvertToNumber(configName, 'itemid', columns[2]),
		 partid = ConvertToNumber(configName, 'partid', columns[3]),
		 basepartid = ConvertToNumber(configName, 'basepartid', columns[4]),
		 partlev = ConvertToNumber(configName, 'partlev', columns[5]),
		 partstart = ConvertToNumber(configName, 'partstart', columns[6]),
		 partage = ConvertToNumber(configName, 'partage', columns[7]),
		 partbreak = ConvertToNumber(configName, 'partbreak', columns[8]),
		 entryids = columns[9],
		 entrylevs = columns[10],
		 entryqlys = columns[11],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictgiftpart_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictgiftpart_config_cell>
function dictgiftpart_config.GetConfigData() return configData end
---@return dictgiftpart_config_cell
function dictgiftpart_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local _newConfigData = {}
function dictgiftpart_config.AnalyseConfig()
	for i, v in pairs(configData) do
		if _newConfigData[v.itemid]==nil then
			_newConfigData[v.itemid]={}
		end
		_newConfigData[v.itemid][v.partid]=v
	end
end
function dictgiftpart_config.GetPartDataByGiftId(giftId,partId)
	if _newConfigData[giftId] then
		return _newConfigData[giftId][partId]
	end
	return nil
end
function dictgiftpart_config.GetPartsDataByGiftId(giftId)
	if _newConfigData[giftId] then
		return _newConfigData[giftId]
	end
	return nil
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictgiftpart_config.AnalyseConfig()
----%%%-------------%%%----








return dictgiftpart_config
