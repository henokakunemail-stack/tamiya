



---@class dictarticle_config




dictarticle_config = {}
---@type table<number,dictarticle_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictarticle')), '')
local bytes = mono.LoadBytes('dictarticle')
local cfg = assert(Dll_PB.decode('dictarticle_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictarticle.txt'
function dictarticle_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 propstype = ConvertToNumber(configName, 'propstype', columns[2]),
		 subtype = ConvertToNumber(configName, 'subtype', columns[3]),
		 propsgrade = ConvertToNumber(configName, 'propsgrade', columns[4]),
		 propsuse = ConvertToNumber(configName, 'propsuse', columns[5]),
		 propsadd = ConvertToNumber(configName, 'propsadd', columns[6]),
		 sprice = ConvertToNumber(configName, 'sprice', columns[7]),
		 maxnum = ConvertToNumber(configName, 'maxnum', columns[8]),
		 sortinx = ConvertToNumber(configName, 'sortinx', columns[9]),
		 exptime = ConvertToNumber(configName, 'exptime', columns[10]),
		 name = columns[11],
		 description = columns[12],
		 propname = columns[13],
		 propdesc = columns[14],
		 icon = columns[15],
		 useType = ConvertToNumber(configName, 'useType', columns[16]),
		 effectType = ConvertToNumber(configName, 'effectType', columns[17]),
		 effectObj = ConvertToNumber(configName, 'effectObj', columns[18]),
		 effectPara = columns[19],
		 existType = ConvertToNumber(configName, 'existType', columns[20]),
		 existTime = columns[21],
		 canSell = ConvertToNumber(configName, 'canSell', columns[22]),
		 sellItem = columns[23],
		 autoUse = ConvertToNumber(configName, 'autoUse', columns[24]),
		 articletype = ConvertToNumber(configName, 'articletype', columns[25]),
		 accessWay = columns[26],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictarticle_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictarticle_config_cell>
function dictarticle_config.GetConfigData() return configData end
---@return dictarticle_config_cell
function dictarticle_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number, table<number, table<number,  table<number, article_config_cell>>>>
local __IdxMap = {}
local _NewConfigStickerData = {}
function dictarticle_config.AnalyseConfig()
	for k, v in pairs(configData) do
		configData[k].NewIcon = v.icon..".png"

		if __IdxMap[v.propstype] == nil then __IdxMap[v.propstype] = {} end
		local first = __IdxMap[v.propstype]
		if first[v.subtype] == nil then first[v.subtype] = {} end
		if v.propstype==GoodsType2.Article_Appearance and v.subtype==GoodsType3.Article_Appearance_Sticker then
			_NewConfigStickerData[v.propsadd]=v
		end
		local second=first[v.subtype]
		table.insert(second, v)
	end
end

function dictarticle_config.GetArticleListType2(type1, type2)
	return __IdxMap[type1][type2]
end
function dictarticle_config.GetStickerArticleByPropsAdd(stickerId)
	return _NewConfigStickerData[stickerId]
end

----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictarticle_config.AnalyseConfig()
----%%%-------------%%%----








return dictarticle_config
