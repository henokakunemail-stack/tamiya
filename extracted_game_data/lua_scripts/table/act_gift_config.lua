



---@class act_gift_config




act_gift_config = {}
---@type table<number,act_gift_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/act_gift')), '')
local bytes = mono.LoadBytes('act_gift')
local cfg = assert(Dll_PB.decode('act_gift_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'act_gift.txt'
function act_gift_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 awardids = columns[2],
		 awardnums = columns[3],
		 buymax = ConvertToNumber(configName, 'buymax', columns[4]),
		 period = ConvertToNumber(configName, 'period', columns[5]),
		 begintime = ConvertToNumber(configName, 'begintime', columns[6]),
		 endtime = ConvertToNumber(configName, 'endtime', columns[7]),
		 bats = columns[8],
		 hits = columns[9],
		 timeflag = ConvertToNumber(configName, 'timeflag', columns[10]),
		 bday = ConvertToNumber(configName, 'bday', columns[11]),
		 eday = ConvertToNumber(configName, 'eday', columns[12]),
		 linkitemid = ConvertToNumber(configName, 'linkitemid', columns[13]),
		 spokespersonicon = columns[14],
		 giftIcon = columns[15],
		 colorborder = columns[16],
		 name = columns[17],
		 title = columns[18],
		 reference = columns[19],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
act_gift_config.Load()
----------以pb方式加载配置表---end




---@return table<number,act_gift_config_cell>
function act_gift_config.GetConfigData() return configData end
---@return act_gift_config_cell
function act_gift_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return act_gift_config
