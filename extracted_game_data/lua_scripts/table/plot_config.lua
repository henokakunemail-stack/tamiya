



---@class plot_config




plot_config = {}
---@type table<number,plot_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/plot')), '')
local bytes = mono.LoadBytes('plot')
local cfg = assert(Dll_PB.decode('plot_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'plot.txt'
function plot_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 plotid = ConvertToNumber(configName, 'plotid', columns[2]),
		 stepid = ConvertToNumber(configName, 'stepid', columns[3]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
plot_config.Load()
----------以pb方式加载配置表---end




---@return table<number,plot_config_cell>
function plot_config.GetConfigData() return configData end
---@return plot_config_cell
function plot_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
---@type table<number,plot_config_cell[]>
local NewConfigData = {}
function plot_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if NewConfigData[v.plotid] == nil then
			NewConfigData[v.plotid] = {}
		end
		table.insert(NewConfigData[v.plotid], v)
	end

	for k, v in pairs(NewConfigData) do
		table.sort(v,function (a, b)
			return a.C_ID < b.C_ID
		end)
	end
end
---@return table<number,plot_config_cell[]>
function plot_config.GetPlotDict()
	return NewConfigData
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
plot_config.AnalyseConfig()
----%%%-------------%%%----








return plot_config
