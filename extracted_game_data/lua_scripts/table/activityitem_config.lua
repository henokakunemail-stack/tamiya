



---@class activityitem_config




activityitem_config = {}
---@type table<number,activityitem_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/activityitem')), '')
local bytes = mono.LoadBytes('activityitem')
local cfg = assert(Dll_PB.decode('activityitem_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'activityitem.txt'
function activityitem_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 activityid = ConvertToNumber(configName, 'activityid', columns[2]),
		 sort = ConvertToNumber(configName, 'sort', columns[3]),
		 activityType = ConvertToNumber(configName, 'activityType', columns[4]),
		 timeType = ConvertToNumber(configName, 'timeType', columns[5]),
		 openTime = columns[6],
		 endTime = columns[7],
		 reward = columns[8],
		 maxCount = ConvertToNumber(configName, 'maxCount', columns[9]),
		 vip = ConvertToNumber(configName, 'vip', columns[10]),
		 ejectPar = columns[11],
		 nextId = columns[12],
		 payId = ConvertToNumber(configName, 'payId', columns[13]),
		 diamond = ConvertToNumber(configName, 'diamond', columns[14]),
		 giftIcon = columns[15],
		 name = columns[16],
		 title = columns[17],
		 reference = columns[18],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
activityitem_config.Load()
----------以pb方式加载配置表---end




---@return table<number,activityitem_config_cell>
function activityitem_config.GetConfigData() return configData end
---@return activityitem_config_cell
function activityitem_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----

----@@@--------@@@----




----%%%FieldSelfDefine%%%----

----%%%-------------%%%----








return activityitem_config
