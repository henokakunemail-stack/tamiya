



---@class dictkillertrack_config




dictkillertrack_config = {}
---@type table<number,dictkillertrack_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictkillertrack')), '')
local bytes = mono.LoadBytes('dictkillertrack')
local cfg = assert(Dll_PB.decode('dictkillertrack_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictkillertrack.txt'
function dictkillertrack_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 scence = ConvertToNumber(configName, 'scence', columns[2]),
		 tracktype = ConvertToNumber(configName, 'tracktype', columns[3]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictkillertrack_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictkillertrack_config_cell>
function dictkillertrack_config.GetConfigData() return configData end
---@return dictkillertrack_config_cell
function dictkillertrack_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,table<number,dictkillertrack_config_cell>>
local __BanTrack = {}
function dictkillertrack_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if v.tracktype==1 then
			table.insert(__BanTrack,v)
		end
	end
end

function dictkillertrack_config.GetBanTrack()
	return __BanTrack
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictkillertrack_config.AnalyseConfig()
----%%%-------------%%%----








return dictkillertrack_config
