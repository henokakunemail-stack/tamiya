



---@class dictvideocount_config




dictvideocount_config = {}
---@type table<number,dictvideocount_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictvideocount')), '')
local bytes = mono.LoadBytes('dictvideocount')
local cfg = assert(Dll_PB.decode('dictvideocount_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictvideocount.txt'
function dictvideocount_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 seq = ConvertToNumber(configName, 'seq', columns[2]),
		 propsids = columns[3],
		 propsnums = columns[4],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictvideocount_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictvideocount_config_cell>
function dictvideocount_config.GetConfigData() return configData end
---@return dictvideocount_config_cell
function dictvideocount_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function dictvideocount_config.InitAwardData()
	for i, v in pairs(configData) do
		local awardIds = stringSplitToNumber(v.propsids, ":")
		local awardNums = stringSplitToNumber(v.propsnums, ":")
		v.propsids = awardIds
		v.propsnums = awardNums
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictvideocount_config.InitAwardData()
----%%%-------------%%%----








return dictvideocount_config
