



---@class comicstep_config




comicstep_config = {}
---@type table<number,comicstep_config_cell>
local configData = {}
local configIdx = {}




----------以pb方式加载配置表---start
--[[
assert(Dll_PB.load(mono.LoadProtoPB('table/load_bypb/pb/comicstep')), '')
local bytes = mono.LoadBytes('comicstep')
local cfg = assert(Dll_PB.decode('comicstep_config', bytes))
for i = 1, #cfg.configData do
	 local id = cfg.configData[i].C_ID
	 configData[id] = cfg.configData[i]
end
--]]
----------以txt方式加载配置表---end




----------以txt方式加载配置表---start
local configName = 'comicstep.txt'
function comicstep_config.Load()
	 local content = loadConfig(configName)
	 local lines = stringSplit(content, '\n')
	 local len = #lines
	 local index = 4
	 while index <= len - 1 do
		 local line = lines[index]
		 local columns = stringSplit(line, '\t')
		 local row = {
		 C_ID = ConvertToNumber(configName, 'C_ID', columns[1]),
		 actionids = columns[2],
		 isSkip = ConvertToNumber(configName, 'isSkip', columns[3]),
		 duration = ConvertToNumber(configName, 'duration', columns[4]),
		 }
		 table.insert(configData,row)
		 configIdx[row.C_ID]=#configData
		 index = index + 1
		 line = nil
		 columns = nil
	 end
	 lines = nil
end
comicstep_config.Load()
----------以pb方式加载配置表---end




---@return table<number,comicstep_config_cell>
function comicstep_config.GetConfigData() return configData end
---@return comicstep_config_cell
function comicstep_config.GetById(id)
	 if id == nil or configIdx[id]== nil or configData[configIdx[id]] == nil then
		 return nil
	 end
	 return configData[configIdx[id]]
end








----@@@SelfDefine@@@----
function comicstep_config.AnalyseConfig()
	for k, v in pairs(configData) do
		if not CommonHelper:IsNullOrEmpty(v.actionids) then
			configData[k].actionids=stringSplitToNumber(v.actionids,':')
		end
	end
end
----@@@--------@@@----




----%%%FieldSelfDefine%%%----
comicstep_config.AnalyseConfig()
----%%%-------------%%%----








return comicstep_config
