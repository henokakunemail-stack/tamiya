



---@class dictgvgpointspeed_config




dictgvgpointspeed_config = {}
---@type table<number,dictgvgpointspeed_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictgvgpointspeed')), '')
local bytes = mono.LoadBytes('dictgvgpointspeed')
local cfg = assert(Dll_PB.decode('dictgvgpointspeed_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictgvgpointspeed.txt'
function dictgvgpointspeed_config.Load()
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
dictgvgpointspeed_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictgvgpointspeed_config_cell>
function dictgvgpointspeed_config.GetConfigData() return configData end
---@return dictgvgpointspeed_config_cell
function dictgvgpointspeed_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewConfigData = {}
function dictgvgpointspeed_config.AnalyseConfig()
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

function dictgvgpointspeed_config.GetSpeedTableByTrackId(id)
	if __NewConfigData[id] then
		return  __NewConfigData[id]
	end
	return nil
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictgvgpointspeed_config.AnalyseConfig()
----%%%-------------%%%----








return dictgvgpointspeed_config
