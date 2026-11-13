



---@class plotstep_config




plotstep_config = {}
---@type table<number,plotstep_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/plotstep')), '')
local bytes = mono.LoadBytes('plotstep')
local cfg = assert(Dll_PB.decode('plotstep_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'plotstep.txt'
function plotstep_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 during = ConvertToNumber(configName, 'during', columns[2]),
		 skiptype = ConvertToNumber(configName, 'skiptype', columns[3]),
		 skipparam = ConvertToNumber(configName, 'skipparam', columns[4]),
		 actions = columns[5],
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
plotstep_config.Load()
----------以pb方式加载配置表---end




---@return table<number,plotstep_config_cell>
function plotstep_config.GetConfigData() return configData end
---@return plotstep_config_cell
function plotstep_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function plotstep_config.AnalyseConfig()
	for k, v in pairs(configData) do
		configData[k].NewDuring = v.during * 0.001
		configData[k].NewSkipparam = v.skipparam * 0.001
		configData[k].actions = stringSplitToNumber(configData[k].actions,'|')
	end

end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
plotstep_config.AnalyseConfig()
----%%%-------------%%%----








return plotstep_config
