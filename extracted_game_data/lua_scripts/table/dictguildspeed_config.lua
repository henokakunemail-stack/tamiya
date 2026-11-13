



---@class dictguildspeed_config




dictguildspeed_config = {}
---@type table<number,dictguildspeed_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictguildspeed')), '')
local bytes = mono.LoadBytes('dictguildspeed')
local cfg = assert(Dll_PB.decode('dictguildspeed_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictguildspeed.txt'
function dictguildspeed_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 trackid = ConvertToNumber(configName, 'trackid', columns[2]),
		 begintime = ConvertToNumber(configName, 'begintime', columns[3]),
		 endtime = ConvertToNumber(configName, 'endtime', columns[4]),
		 pointnum = ConvertToNumber(configName, 'pointnum', columns[5]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictguildspeed_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictguildspeed_config_cell>
function dictguildspeed_config.GetConfigData() return configData end
---@return dictguildspeed_config_cell
function dictguildspeed_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewConfigData = {}
function dictguildspeed_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if  __NewConfigData[v.trackid]==nil then
			__NewConfigData[v.trackid]={}
		end
		table.insert(__NewConfigData[v.trackid],v)
	end
	for k, v in pairs(__NewConfigData) do
		table.sort(v,function(a, b)
			return a.pointnum>b.pointnum
		end)
	end
end

function dictguildspeed_config.GetSpeedTableByTrackId(id)
	if __NewConfigData[id] then
		return  __NewConfigData[id]
	end
	return nil
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictguildspeed_config.AnalyseConfig()
----%%%-------------%%%----








return dictguildspeed_config
