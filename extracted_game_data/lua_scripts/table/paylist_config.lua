



---@class paylist_config




paylist_config = {}
---@type table<number,paylist_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/paylist')), '')
local bytes = mono.LoadBytes('paylist')
local cfg = assert(Dll_PB.decode('paylist_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'paylist.txt'
function paylist_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 type = ConvertToNumber(configName, 'type', columns[2]),
		 goodsid = columns[3],
		 google = ConvertToNumber(configName, 'google', columns[4]),
		 goodsname = columns[5],
		 icon = columns[6],
		 currencyType = columns[7],
		 price = ConvertToNumber(configName, 'price', columns[8]),
		 goodprice = columns[9],
		 diamond = ConvertToNumber(configName, 'diamond', columns[10]),
		 firstGiftDiamond = ConvertToNumber(configName, 'firstGiftDiamond', columns[11]),
		 otherGiftDiamond = ConvertToNumber(configName, 'otherGiftDiamond', columns[12]),
		 last = ConvertToNumber(configName, 'last', columns[13]),
		 rewardId = columns[14],
		 RMB = ConvertToNumber(configName, 'RMB', columns[15]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
paylist_config.Load()
----------以pb方式加载配置表---end




---@return table<number,paylist_config_cell>
function paylist_config.GetConfigData() return configData end
---@return paylist_config_cell
function paylist_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,paylist_config_cell>@key 是goodsId
local newCfg={}

function paylist_config.AnalyseData()
	for id ,cell in pairs(configData) do
		newCfg[cell.goodsid]=cell
	end
end
---@return paylist_config_cell
function paylist_config.GetDataByGoodsId(goodsId)
	return newCfg[goodsId]
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
paylist_config.AnalyseData()
----%%%-------------%%%----








return paylist_config
