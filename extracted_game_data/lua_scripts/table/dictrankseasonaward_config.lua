



---@class dictrankseasonaward_config




dictrankseasonaward_config = {}
---@type table<number,dictrankseasonaward_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/dictrankseasonaward')), '')
local bytes = mono.LoadBytes('dictrankseasonaward')
local cfg = assert(Dll_PB.decode('dictrankseasonaward_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'dictrankseasonaward.txt'
function dictrankseasonaward_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 rankidx = ConvertToNumber(configName, 'rankidx', columns[2]),
		 star = ConvertToNumber(configName, 'star', columns[3]),
		 awards = columns[4],
		 awardnums = columns[5],
		 integral = ConvertToNumber(configName, 'integral', columns[6]),
		 subpoint = ConvertToNumber(configName, 'subpoint', columns[7]),
		 addpoint = ConvertToNumber(configName, 'addpoint', columns[8]),
		 name = columns[9],
		 icon = columns[10],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
dictrankseasonaward_config.Load()
----------以pb方式加载配置表---end




---@return table<number,dictrankseasonaward_config_cell>
function dictrankseasonaward_config.GetConfigData() return configData end
---@return dictrankseasonaward_config_cell
function dictrankseasonaward_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
local __NewConfigData = {}

function dictrankseasonaward_config.AnalyseConfig()
	for k, v in pairs(configData) do
		table.insert(__NewConfigData, v)
	end

	table.sort(__NewConfigData,function (a, b)
		return a.C_ID < b.C_ID
	end)
end
function dictrankseasonaward_config.GetDataList()
	return __NewConfigData
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
dictrankseasonaward_config.AnalyseConfig()
----%%%-------------%%%----








return dictrankseasonaward_config
