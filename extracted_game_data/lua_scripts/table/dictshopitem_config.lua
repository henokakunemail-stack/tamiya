



---@class dictshopitem_config




dictshopitem_config = {}
---@type table<number,dictshopitem_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictshopitem')), '')
local bytes = mono.LoadBytes('dictshopitem')
local cfg = assert(Dll_PB.decode('dictshopitem_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictshopitem.txt'
function dictshopitem_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 propsid = ConvertToNumber(configName, 'propsid', columns[2]),
		 weight = ConvertToNumber(configName, 'weight', columns[3]),
		 cond = ConvertToNumber(configName, 'cond', columns[4]),
		 condval = ConvertToNumber(configName, 'condval', columns[5]),
		 coinid = ConvertToNumber(configName, 'coinid', columns[6]),
		 moneynum = ConvertToNumber(configName, 'moneynum', columns[7]),
		 discount = ConvertToNumber(configName, 'discount', columns[8]),
		 limitnum = ConvertToNumber(configName, 'limitnum', columns[9]),
		 startsell = ConvertToNumber(configName, 'startsell', columns[10]),
		 endsell = ConvertToNumber(configName, 'endsell', columns[11]),
		 timeflag = ConvertToNumber(configName, 'timeflag', columns[12]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictshopitem_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictshopitem_config_cell>
function dictshopitem_config.GetConfigData() return configData end
---@return dictshopitem_config_cell
function dictshopitem_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return dictshopitem_config
