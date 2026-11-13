



---@class act_shop_item_config




act_shop_item_config = {}
---@type table<number,act_shop_item_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_shop_item')), '')
local bytes = mono.LoadBytes('act_shop_item')
local cfg = assert(Dll_PB.decode('act_shop_item_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_shop_item.txt'
function act_shop_item_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 grid = ConvertToNumber(configName, 'grid', columns[2]),
		 begintime = ConvertToNumber(configName, 'begintime', columns[3]),
		 endtime = ConvertToNumber(configName, 'endtime', columns[4]),
		 propsid = ConvertToNumber(configName, 'propsid', columns[5]),
		 exchid = ConvertToNumber(configName, 'exchid', columns[6]),
		 price = ConvertToNumber(configName, 'price', columns[7]),
		 limitnum = ConvertToNumber(configName, 'limitnum', columns[8]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_shop_item_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_shop_item_config_cell>
function act_shop_item_config.GetConfigData() return configData end
---@return act_shop_item_config_cell
function act_shop_item_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return act_shop_item_config
